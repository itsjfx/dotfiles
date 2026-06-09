// skip 1st line
// see https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig

function createElement(document, tag, props, isHTML = false) {
    let el = isHTML ? document.createElement(tag) : document.createXULElement(tag);
    for (let prop of Object.keys(props)) {
        el.setAttribute(prop, props[prop]);
    }
    return el;
}

function removeExistingHotKeys(window, details) {
    const document = window.document;

    // remove by id first
    let byId = document.getElementById(details.id);
    if (byId) {
        byId.remove();
    }

    let modifiers = details.modifiers?.join() || [];
    let keys = document.querySelectorAll(`[key='${details.key}']`);

    // find keys with the same modifier and remove them if they exist too
    [...keys].forEach((element) => {
        let elModifiers = element.attributes.getNamedItem('modifiers')?.value;
        if (modifiers.length && elModifiers == modifiers) {
            window.console.log('removing', element);
            element.remove();
        } else if (!modifiers.length) {
            element.remove();
        }
    });
}

function applyCustomScriptToWindow(window) {
    const document = window.document;
    const console = window.console;

    let keyChanges = [
        // DL
        {
            id: 'custom_dl',
            modifiers: ['accel'],
            key: 'J',
            command: 'Tools:Downloads',
            reserved: true,
        },
    ];

    // CTRL + ALT + number -> select tab 1..10
    // (tap into the browser native tab handling)
    // https://github.com/mozilla/gecko-dev/blob/7d73613454bfe426fdceb635b33cd3061a69def4/browser/base/content/browser-sets.js#L297-L311
    ['accel', 'alt'].forEach((mod) => {
        for (let i = 0; i < 10; i++) {
            let key = i + 1;
            keyChanges.push({
                id: `uc_selectTab${key}${mod}`,
                modifiers: [mod],
                key: (key != 10 ? key : 0), // cater for pressing 0
                action: (win, ev) => win.gBrowser.selectTabAtIndex(i, ev),
                reserved: true,
                _keepExistingHotKey: true,
            });
        }
    });
    // ALT + function key -> select tab 11..22
    for (let i = 0; i < 12; i++) {
        let key = i + 1;
        keyChanges.push({
            id: `uc_selectTabF${key}`,
            modifiers: ['alt'],
            keycode: 'VK_F' + key,
            action: (win, ev) => win.gBrowser.selectTabAtIndex(i + 10, ev),
            reserved: true,
            _keepExistingHotKey: true,
        });
    }

    // Build keys into a fresh, detached keyset; inserting a fully-populated
    // keyset is what makes Firefox register the keys in its live shortcut map.
    // Any key that runs JS gets routed through a real <command> element: the
    // chrome CSP blocks inline oncommand code added at runtime, but a <key>
    // that points at a <command> (and a JS 'command' listener on that command)
    // is allowed — same path the native Tools:Downloads key uses.
    let ucKeys = createElement(document, 'keyset', { id: 'ucCustomKeys' });
    let ucCmds = createElement(document, 'commandset', { id: 'ucCustomCommands' });

    keyChanges.forEach((details) => {
        if (details._keepExistingHotKey) {
            delete details._keepExistingHotKey;
        } else {
            removeExistingHotKeys(window, details);
        }

        // don't pass our internal fields through as DOM attributes
        let { _keepExistingHotKey, action, ...attrs } = details;

        if (action) {
            let cmdId = `${attrs.id}_cmd`;
            let cmd = createElement(document, 'command', { id: cmdId });
            cmd.addEventListener('command', (ev) => action(window, ev));
            ucCmds.appendChild(cmd);
            attrs.command = cmdId; // key fires this command when pressed
        }

        ucKeys.appendChild(createElement(document, 'key', attrs));
    });

    // mainKeyset is a direct child of <html:body> in browser.xhtml. Insert the
    // commandset first so the commands exist when the keyset registers.
    let mainKeyset = document.getElementById('mainKeyset');
    if (mainKeyset) {
        mainKeyset.parentNode.insertBefore(ucCmds, mainKeyset);
        mainKeyset.parentNode.insertBefore(ucKeys, mainKeyset.nextSibling);
    } else {
        // not a real browser window — shouldn't happen with the hook below
        console.warn('config.js: no mainKeyset, skipping', window.location.href);
        return;
    }

    console.log('config.js: applied', ucKeys.childElementCount, 'custom keys');
}

/* Run the init function once per real browser window.
   "browser-delayed-startup-finished" fires with the top ChromeWindow as its
   subject, after the window is ready, and never for inner <browser> frames or
   privileged about: pages — so we always get browser.xhtml, never a stray doc.
*/
try {
    if (!Services.appinfo.inSafeMode) {
        Services.obs.addObserver((window) => {
            try {
                applyCustomScriptToWindow(window);
            } catch (ex) {
                window.console.error('config.js error', ex);
            }
        }, 'browser-delayed-startup-finished');
    }
} catch (ex) {
    Cu.reportError(ex);
}
