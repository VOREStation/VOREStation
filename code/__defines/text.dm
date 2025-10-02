/**
 * Holds global defines for use in text input procedures
 */


/**
 * stuff like `copytext(input, length(input))` will trim the last character of the input,
 * because DM does it so it copies until the char BEFORE the `end` arg, so we need to bump `end` by 1 in these cases.
 */
#define PREVENT_CHARACTER_TRIM_LOSS(integer) (integer + 1)

/// Simply removes the < and > characters, and limits the length of the message.
#define STRIP_HTML_SIMPLE(text, limit) (GLOB.angular_brackets.Replace(copytext(text, 1, limit), ""))

/// Removes everything enclose in < and > inclusive of the bracket, and limits the length of the message.
#define STRIP_HTML_FULL(text, limit) (GLOB.html_tags.Replace(copytext(text, 1, limit), ""))

/// BYOND's string procs don't support being used on datum references (as in it doesn't look for a name for stringification)
/// We just use this macro to ensure that we will only pass strings to this BYOND-level function without developers needing to really worry about it.
#define LOWER_TEXT(thing) lowertext(UNLINT("[thing]"))

/// Removes characters incompatible with file names.
#define SANITIZE_FILENAME(text) (GLOB.filename_forbidden_chars.Replace(text, ""))

#define MAX_MESSAGE_CHUNKS 1000

#define MAX_TGUI_INPUT (MAX_MESSAGE_CHUNKS * 1024)

#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}

#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);
