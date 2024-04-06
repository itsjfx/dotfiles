// me
// some from: https://zren.github.io/kde/#firefox
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.urlbar.oneOffSearches", false); // deprecated, keeping in case it comes back
user_pref("browser.ctrlTab.recentlyUsedOrder", false); // makes ctrl tab cool
user_pref("browser.download.autohideButton", false); // keeps download button there
user_pref("devtools.netmonitor.persistlog", true);
user_pref("devtools.webconsole.persistlog", true);
user_pref("general.autoScroll", true); // false by default on Linux
user_pref("full-screen-api.warning.timeout", 0);
user_pref("middlemouse.contentLoadURL", false);
user_pref("middlemouse.paste", false);
user_pref("browser.sessionstore.resume_from_crash", false);

// animations
user_pref("browser.tabs.animate", false);
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.durationToIntervalRatio", 100)
user_pref("general.smoothScroll.lines.durationMaxMS", 100)

// annoying
user_pref("network.protocol-handler.external.ext+container", true);

// downloads
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.download.lastDir", "/tmp");
user_pref("browser.download.dir", "/tmp");

// set to refresh rate
user_pref("layout.frame_rate", 240);
// fixes framerate issues on NVIDIA
// not sure if this breaks intel :)
user_pref("gfx.x11-egl.force-disabled", true);
user_pref("gfx.webrender.all", true);

//user_pref("layers.acceleration.force-enabled", true); // hardware accel
//user_pref("network.dns.disableIPv6", true); // depending on network



// below is stolen from https://github.com/arkenfox/user.js/blob/master/user.js

user_pref("browser.messaging-system.whatsNewPanel.enabled", false); // What's New [FF69+]
user_pref("extensions.pocket.enabled", false); // Pocket Account [FF46+]
user_pref("identity.fxaccounts.enabled", false); // Firefox Accounts & Sync [FF60+] [RESTART]
user_pref("reader.parse-on-load.enabled", false); // Reader View

user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.shell.checkDefaultBrowser", false);

user_pref("privacy.trackingprotection.cryptomining.enabled", false);
user_pref("clipboard.autocopy", false); // disable autocopy default [LINUX]

// Remove bloat from new tab page
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false); // [FF66+]
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

/* 1610: ALL: enable the DNT (Do Not Track) HTTP header
 * [NOTE] DNT is enforced with Enhanced Tracking Protection regardless of this pref
 * [SETTING] Privacy & Security>Enhanced Tracking Protection>Send websites a "Do Not Track" signal... ***/
user_pref("privacy.donottrackheader.enabled", true);

/* 0330: disable telemetry */
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false); // see [NOTE]
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false); // [FF55+]
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false); // [FF55+]
user_pref("toolkit.telemetry.updatePing.enabled", false); // [FF56+]
user_pref("toolkit.telemetry.bhrPing.enabled", false); // [FF57+] Background Hang Reporter
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false); // [FF57+]

/* 0503: disable Normandy/Shield [FF60+]
 * Shield is an telemetry system (including Heartbeat) that can also push and test "recipes"
 * [1] https://wiki.mozilla.org/Firefox/Shield
 * [2] https://github.com/mozilla/normandy ***/
 user_pref("app.normandy.enabled", false);
 user_pref("app.normandy.api_url", "");

 /* 0506: disable PingCentre telemetry (used in several System Add-ons) [FF57+]
 * Currently blocked by 'datareporting.healthreport.uploadEnabled' (see 0340) ***/
user_pref("browser.ping-centre.telemetry", false);

/* 0331: disable Telemetry Coverage
 * [1] https://blog.mozilla.org/data/2018/08/20/effectively-measuring-search-in-firefox/ ***/
user_pref("toolkit.telemetry.coverage.opt-out", true); // [HIDDEN PREF]
user_pref("toolkit.coverage.opt-out", true); // [FF64+] [HIDDEN PREF]
user_pref("toolkit.coverage.endpoint.base", "");

/* 0340: disable Health Reports
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to send technical... data ***/
user_pref("datareporting.healthreport.uploadEnabled", false);

/* 0341: disable new data submission, master kill switch [FF41+]
 * If disabled, no policy is shown or upload takes place, ever
 * [1] https://bugzilla.mozilla.org/1195552 ***/
user_pref("datareporting.policy.dataSubmissionEnabled", false);

/* 0342: disable Studies (see 0503)
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to install and run studies ***/
user_pref("app.shield.optoutstudies.enabled", false);

/* 0343: disable personalized Extension Recommendations in about:addons and AMO [FF65+]
 * [NOTE] This pref has no effect when Health Reports (0340) are disabled
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to make personalized extension recommendations
 * [1] https://support.mozilla.org/kb/personalized-extension-recommendations ***/
user_pref("browser.discovery.enabled", false);

/* 0350: disable Crash Reports ***/
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false); // [FF44+]
user_pref("browser.crashReports.unsubmittedCheck.enabled", false); // [FF51+]

/* 0351: disable backlogged Crash Reports
 * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to send backlogged crash reports  ***/
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false); // [FF58+]

/* 0412: disable SB checks for downloads (remote)
 * To verify the safety of certain executable files, Firefox may submit some information about the
 * file, including the name, origin, size and a cryptographic hash of the contents, to the Google
 * Safe Browsing service which helps Firefox determine whether or not the file should be blocked
 * [SETUP-SECURITY] If you do not understand this, or you want this protection, then override it ***/
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");

/* 0606: enforce no "Hyperlink Auditing" (click tracking)
 * [1] https://www.bleepingcomputer.com/news/software/major-browsers-to-prevent-disabling-of-click-tracking-privacy-risk/ ***/
 user_pref("browser.send_pings", false); // [DEFAULT: false]
 user_pref("browser.send_pings.require_same_host", true); // defense-in-depth

 /* 0803: display all parts of the url in the location bar ***/
user_pref("browser.urlbar.trimURLs", false);
