// ==UserScript==
// @name         Slack share message link to browser message link
// @namespace    https://jfx.ac
// @version      0.1
// @description  Redirect Slack archive links to browser links
// @author       jfx
// @match        https://*.slack.com/archives/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    const [channel, message] = window.location.href.match(/\/archives\/([A-Za-z0-9]+)\/p([0-9]+)/);
    if (channel && message) {
        window.location.replace(`https://${window.location.hostname}/messages/${channel}/p${message}`);
    }
})();
