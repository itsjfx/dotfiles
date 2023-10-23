// vi: ft=javascript

const child_process = require('node:child_process');
const repl = require('node:repl');

const start = repl.start;
// monkey patch repl.start()
repl.start = function (...args) {
    const replServer = start(...args);

    // if the Node default REPL, do specific things
    // should try support ts-node and what not in the future
    if (!!repl.repl) {
        // force to true. on by default
        replServer.breakEvalOnSigint = true;

        // annoying
        replServer.ignoreUndefined = true;

        // _load()
        replServer.context['_load'] = (file, encoding = 'utf-8') => {
            const fs = require('node:fs');
            return fs.readFileSync(file, encoding);
        };
    }

    // https://github.com/lincheney/fzf-tab-completion/blob/master/node/fzf-node-completion.js
    replServer.input.on('keypress', (str, key) => {
        // tab completion
        if (key.sequence == '\t') {
            // sabotage the key so the repl doesn't get it
            key.name = '';
            key.ctrl = 1;
            key.sequence = '';

            replServer.completer(replServer.line.slice(0, replServer.cursor), function (error, [completions, prefix]) {
                if (completions.length == 0) {
                    return;
                }
                let stdout = prefix;
                const input = completions.filter(x => x !== '').join('\n');
                try {
                    stdout = child_process.execFileSync('rl_custom_complete', [prefix], { input, stdio: ['pipe', 'pipe', 'inherit'] }).toString().trim('\n');
                } catch (e) {
                }
                replServer.line = replServer.line.slice(0, replServer.cursor - prefix.length) + stdout + replServer.line.slice(replServer.cursor);
                replServer.cursor += stdout.length - prefix.length;
                // fzf will have destroyed the prompt, so fix it
                replServer._refreshLine();
            });

        // reverse i-search
        } else if (key.ctrl && key.name == 'r') {
            // sabotage the key so the repl doesn't get it
            key.name = '';

            const input = [...replServer.history].reverse().join('\n');
            let stdout = replServer.line;
            try {
                stdout = child_process.execFileSync('rl_custom_isearch', [], { input, stdio: ['pipe', 'pipe', 'inherit'] }).toString().trim('\n').replace(/\0*$/, '');
            } catch (e) { // ignore if fzf fails
            }
            replServer.cursor += stdout.length - replServer.line.length;
            replServer.line = stdout;
            // fzf will have destroyed the prompt, so fix it
            replServer._refreshLine();
        }

    });


    return replServer;
};
