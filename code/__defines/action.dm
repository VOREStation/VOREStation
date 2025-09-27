#define AB_CHECK_RESTRAINED 1
#define AB_CHECK_STUNNED 2
#define AB_CHECK_LYING 4
#define AB_CHECK_CONSCIOUS 8

///Action button triggered with right click
#define TRIGGER_SECONDARY_ACTION (1<<0)
///Action triggered to ignore any availability checks
#define TRIGGER_FORCE_AVAILABLE (1<<1)

// Defines for formatting cooldown actions for the stat panel.
/// The stat panel the action is displayed in.
#define PANEL_DISPLAY_PANEL "panel"
/// The status shown in the stat panel.
/// Can be stuff like "ready", "on cooldown", "active", "charges", "charge cost", etc.
#define PANEL_DISPLAY_STATUS "status"
/// The name shown in the stat panel.
#define PANEL_DISPLAY_NAME "name"

#define ACTION_BUTTON_DEFAULT_BACKGROUND "_use_ui_default_background"

#define UPDATE_BUTTON_NAME (1<<0)
#define UPDATE_BUTTON_ICON (1<<1)
#define UPDATE_BUTTON_BACKGROUND (1<<2)
#define UPDATE_BUTTON_OVERLAY (1<<3)
#define UPDATE_BUTTON_STATUS (1<<4)
