////////////////////////
// ARKENFOX OVERRIDES // 
////////////////////////

// firefox home
/* 0103 */ user_pref("browser.startup.homepage", "about:home");
/* 0104 */ user_pref("browser.newtabpage.enabled", true);

// search bar suggestions
/* 0802 */ user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
/* 0802 */ user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
/* 0803 */ // user_pref("browser.search.suggest.enabled", true);
/* 0804 */ // user_pref("browser.urlbar.suggest.searches", true);

/* 0830 */ user_pref("browser.search.separatePrivateDefault", false);
/* 0831 */ user_pref("browser.search.separatePrivateDefault.ui.enabled", false);

// session restore (1/2)
/* 0102 */ user_pref("browser.startup.page", 3);

/* 1003 */ // user_pref("browser.sessionstore.privacy_level", 0);


// session restore (2/2) / keep history
/* 2811 */ user_pref("privacy.clearOnShutdown.history", false);

/* 4504 */ user_pref("privacy.resistFingerprinting.letterboxing", false);

// WebGL
/* 4520 */ // user_pref("webgl.disabled", false);



///////////////////////
// ARKENFOX OPTIONAL // 
///////////////////////

// don't save passwords
/* 5003 */ user_pref("signon.rememberSignons", false);

/* 5005 */ user_pref("security.nocertdb", true);

// increase undo close tab count
/* 5007 */ user_pref("browser.sessionstore.max_tabs_undo", 50);

// I don't even think this works on my dots
/* 5009 */ user_pref("browser.download.forbid_open_with", true);

/* 5017 */ user_pref("extensions.formautofill.addresses.enabled", false);
/* 5017 */ user_pref("extensions.formautofill.creditCards.enabled", false);

///////////////////
// OTHER OPTIONS // 
///////////////////

// DRM
user_pref("media.gmp-widevinecdm.enabled", true);
user_pref("media.eme.enabled", true);

// compact tabs
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);

// middle mouse scroll
user_pref("general.autoScroll", true);

// user_pref("dom.allow_cut_copy", true);

user_pref("extensions.pocket.enabled", false);

// additional options behind 5003 save passwords
user_pref("signon.firefoxRelay.feature", false);
user_pref("signon.generation.enabled", false);

// new tap page
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.discoverystream.rec.impressions", "{}");

// duckduckgo default search
user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");
