// skip 1st line
// see https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig

function createElement(document, tag, props, isHTML = false){
    let el = isHTML ? document.createElement(tag) : document.createXULElement(tag);
    for (let prop of Object.keys(props)) {
        el.setAttribute(prop, props[prop])
    }
    return el;
}

function removeExistingHotKeys(window, details) {
    const document = window.document;

    // TO-DO: filter by type
    // see if the ID matches
    let id = document.getElementById(details.id);
    if (id) {
        id.remove();
    }

    let modifiers = details.modifiers?.join() || [];
    let keys = document.querySelectorAll(`[key='${details.key}']`);

    // find keys with the same modifier and remove them if they exist too
    [...keys]
    .forEach((element) => {
        if (modifiers.length && element.attributes.getNamedItem('modifiers').value == modifiers) {
            window.console.log("removing", element);
            element.remove();
        } else if (!modifiers.length) {
            element.remove();
        }
    });
}

function applyCustomScriptToWindow(window) {
    window.console.log('1');
    const document = window.document;
    let keyChanges = [
        // DL
        {
            id: 'custom_dl',
            modifiers: ['accel'],
            key: 'J',
            command: 'Tools:Downloads',
        },
        {
            id: 'focus_window',
            modifiers: ['alt'],
            key: 'VK_OEM_2',
            command: 'Tools:Downloads',
        }
    ];

    // CTRL + ALT keys
    for (let i = 0; i < 10; i++) {
        ['accel', 'alt'].forEach((mod) => {
            let key = i + 1;
            keyChanges.push({
                id: `${mod}_selectTab${key}`,
                modifiers: [mod],
                key: (key != 10 ? key : 0), // cater for pressing 0
                oncommand: `gBrowser.selectTabAtIndex(${i}, event);`,
            });
        });
    }
    // ALT Function keys
    for (let i = 0; i < 12; i++) {
        let key = i + 1;
        keyChanges.push({
            id: `alt_selectTabF${key}`,
            modifiers: ['alt'],
            keycode: 'VK_F'+key,
            oncommand: `gBrowser.selectTabAtIndex(${i+10}, event);`,
        });
    }

    window.console.log('3');
    keyChanges.forEach((details) => {
        if (details.keepExistingHotKey) {
            delete details.keepExistingHotKey;
        } else {
            removeExistingHotKeys(window, details);
        }
        window.console.log('5');
        let el = createElement(document, "key", details);
        window.console.log('6');
        
        el.addEventListener("command", (ev) => {
            window.console.log('hey');
            window.focus();
            //func(ev.target.ownerGlobal, eToO(ev))
        });
        window.console.log('7');
        let keyset = document.getElementById("mainKeyset") || document.body.appendChild(createElement(document, "keyset", {id: "ucKeys"}));
        window.console.log('8');
        keyset.insertBefore(el, keyset.firstChild);
        window.console.log('9');
    });

    window.console.log('4');
}
/* Single function userChrome.js loader to run the above init function (no external scripts)
    derived from https://www.reddit.com/r/firefox/comments/kilmm2/
*/
// see also https://www.reddit.com/r/FirefoxCSS/comments/mica0g/how_to_add_bookmarks_to_my_about_autoconfig_script/gt4dhfc/
try {
    const { Services } = Components.utils.import('resource://gre/modules/Services.jsm');

    const ConfigJS = {
        observe: function (subject) {
            subject.addEventListener('DOMContentLoaded', this, {once: true});
        },
        handleEvent: function (event) {
            let document = event.originalTarget;
            let window = document.defaultView;
            let location = window.location;

            window.console.log(document, window, location, 'hi', location.href);

            if (/^(chrome:(?!\/\/(global\/content\/commonDialog|browser\/content\/webext-panels)\.x?html)|about:(?!blank))/i.test(location.href)) {
                if (window._gBrowser) {
                    window.console.log('Applying script');
                    try {
                        applyCustomScriptToWindow(window);
                    } catch (ex) {
                        window.console.error('Error', ex);
                    }
                }
            }
        }
    }

    if (!Services.appinfo.inSafeMode) {
        Services.obs.addObserver(ConfigJS, 'chrome-document-global-created', false);
    }
} catch(ex) {};
