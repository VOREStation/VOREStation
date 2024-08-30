// Modes for examine text output
#define EXAMINE_MODE_DEFAULT		 0
#define EXAMINE_MODE_INCLUDE_USAGE	 1
#define EXAMINE_MODE_SWITCH_TO_PANEL 2

// Should be one higher than the above
#define EXAMINE_MODE_MAX			 3

// Modes for parsing multilingual speech
#define MULTILINGUAL_DEFAULT			0
#define MULTILINGUAL_SPACE				1
#define MULTILINGUAL_DOUBLE_DELIMITER	2
#define MULTILINGUAL_OFF				3

#define MULTILINGUAL_MODE_MAX			4

#define SAVE_RESET -1

// Values for /datum/preference/savefile_identifier
/// This preference is character specific.
#define PREFERENCE_CHARACTER "character"
/// This preference is account specific.
#define PREFERENCE_PLAYER "player"

// Values for /datum/preferences/current_tab
/// Open the character preference window
#define PREFERENCE_TAB_CHARACTER_PREFERENCES 0

/// Open the game preferences window
#define PREFERENCE_TAB_GAME_PREFERENCES 1

/// These will be shown in the character sidebar, but at the bottom.
#define PREFERENCE_CATEGORY_FEATURES "features"

/// Any preferences that will show to the sides of the character in the setup menu.
#define PREFERENCE_CATEGORY_CLOTHING "clothing"

/// Preferences that will be put into the 3rd list, and are not contextual.
#define PREFERENCE_CATEGORY_NON_CONTEXTUAL "non_contextual"

/// Will be put under the game preferences window.
#define PREFERENCE_CATEGORY_GAME_PREFERENCES "game_preferences"

/// These will show in the list to the right of the character preview.
#define PREFERENCE_CATEGORY_SECONDARY_FEATURES "secondary_features"

/// These are preferences that are supplementary for main features,
/// such as hair color being affixed to hair.
#define PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES "supplemental_features"

/// These preferences will not be rendered on the preferences page, and are practically invisible unless specifically rendered. Used for quirks, currently.
#define PREFERENCE_CATEGORY_MANUALLY_RENDERED "manually_rendered_features"
