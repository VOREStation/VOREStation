/// Maximum number of windows that can be suspended/reused
#define TGUI_WINDOW_SOFT_LIMIT 5
/// Maximum number of open windows
#define TGUI_WINDOW_HARD_LIMIT 9

/// Maximum ping timeout allowed to detect zombie windows
#define TGUI_PING_TIMEOUT 4 SECONDS

/// Window does not exist
#define TGUI_WINDOW_CLOSED 0
/// Window was just opened, but is still not ready to be sent data
#define TGUI_WINDOW_LOADING 1
/// Window is free and ready to receive data
#define TGUI_WINDOW_READY 2

/// Get a window id based on the provided pool index
#define TGUI_WINDOW_ID(index) "tgui-window-[index]"
/// Get a pool index of the provided window id
#define TGUI_WINDOW_INDEX(window_id) text2num(copytext(window_id, 13))

/// Max length for Modal Input
#define TGUI_MODAL_INPUT_MAX_LENGTH 1024
/// Max length for Modal Input for names
#define TGUI_MODAL_INPUT_MAX_LENGTH_NAME 64 // Names for generally anything don't go past 32, let alone 64.

#define TGUI_MODAL_OPEN 1
#define TGUI_MODAL_DELEGATE 2
#define TGUI_MODAL_ANSWER 3
#define TGUI_MODAL_CLOSE 4