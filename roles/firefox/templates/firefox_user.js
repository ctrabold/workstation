# My Firefox User Preferences

/**
 * These are my personal Firefox settings
 * which OVERRIDE the default settings in `pref.js`.
 *
 * They can NOT be overriden via `about:config`.
 *
 * @see http://kb.mozillazine.org/User.js_file
 * @see http://kb.mozillazine.org/About:config_entries
 * @see https://support.mozilla.org/en-US/questions/965842
 */

user_pref("accessibility.typeaheadfind", true);
user_pref("accessibility.typeaheadfind.enablesound", false);
user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("browser.bookmarks.restore_default_bookmarks", false);
user_pref("browser.cache.disk.capacity", 50000);
user_pref("browser.cache.memory.capacity", 5000);
user_pref("browser.chrome.site_icons", false);
user_pref("browser.ctrlTab.previews", true);
user_pref("browser.fullscreen.animateUp", 0);
user_pref("browser.fullscreen.autohide", false);
user_pref("browser.newtab.url", "about:blank");
user_pref("browser.search.openintab", true);
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.tabs.animate", false);
user_pref("browser.tabs.loadBookmarksInBackground", true);
user_pref("browser.urlbar.clickSelectsAll", false);
user_pref("browser.urlbar.doubleClickSelectsAll", false);
user_pref("browser.urlbar.formatting.enabled", false);
user_pref("browser.urlbar.trimURLs", false);
user_pref("general.autoScroll", true);
user_pref("security.dialog_enable_delay", 0);
user_pref("signon.rememberSignons", false);
