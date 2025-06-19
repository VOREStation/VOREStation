// Modes for examine text output
#define EXAMINE_MODE_SLIM		 "Slim"
#define EXAMINE_MODE_VERBOSE	 "Verbose"
#define EXAMINE_MODE_SWITCH_TO_PANEL "Switch To Panel"


// Modes for parsing multilingual speech
#define MULTILINGUAL_DEFAULT			"Default"
#define MULTILINGUAL_SPACE				"Space"
#define MULTILINGUAL_DOUBLE_DELIMITER	"Double Delimiter"
#define MULTILINGUAL_OFF				"Single Language"

#define MULTILINGUAL_MODE_MAX			4

#define SAVE_RESET -1

//randomised elements
#define RANDOM_ANTAG_ONLY 1
#define RANDOM_DISABLED 2
#define RANDOM_ENABLED 3

// randomise_appearance_prefs() and randomize_human_appearance() proc flags
#define RANDOMIZE_SPECIES (1<<0)
#define RANDOMIZE_NAME (1<<1)

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

/// Emote switch preferences
#define EMOTE_SOUND_NO_FREQ "Default"
#define EMOTE_SOUND_VOICE_FREQ "Voice Frequency"
#define EMOTE_SOUND_VOICE_LIST "Voice Sound"
