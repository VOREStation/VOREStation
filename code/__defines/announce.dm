// Announcer IDs
#define ANNOUNCER_VOICE_SS13 "announcer_ss13"
#define ANNOUNCER_VOICE_VIRGO "announcer_virgo"

// Announcements
#define ANNOUNCER_MSG_ROUND_START "announcer_msg_round_start"

#define ANNOUNCER_MSG_SHUTTLE_ENDROUND_DOCK "announcer_msg_endround_shuttle_dock"
#define ANNOUNCER_MSG_SHUTTLE_ENDROUND_CALLED "announcer_msg_endround_shuttle_called"

#define ANNOUNCER_MSG_SHUTTLE_EMERG_DOCK "announcer_msg_emergency_shuttle_dock"
#define ANNOUNCER_MSG_SHUTTLE_EMERG_CALLED "announcer_msg_emergency_shuttle_called"
#define ANNOUNCER_MSG_SHUTTLE_EMERG_RECALLED "announcer_msg_emergency_shuttle_recalled"

#define ANNOUNCER_MSG_NIGHTSHIFT_START "announcer_msg_nightshift_start"
#define ANNOUNCER_MSG_NIGHTSHIFT_END "announcer_msg_nightshift_end"

#define ANNOUNCER_MSG_NEW_AI "announcer_msg_new_ai"

#define ANNOUNCER_MSG_UNIDENTIFIED_LIFESIGNS "announcer_msg_unidentified_lifesigns"

#define ANNOUNCER_MSG_NEW_COMMAND_REPORT "announcer_msg_new_command_report"

#define ANNOUNCER_MSG_BIOHAZARD_FIVE "announcer_msg_biohazard_five"
#define ANNOUNCER_MSG_BIOHAZARD_SEVEN "announcer_msg_biohazard_seven"

// Set sound paths to null to explicitly disable a message from falling back to SS13 default
GLOBAL_VAR_INIT(current_announcer_voice, ANNOUNCER_VOICE_VIRGO)

GLOBAL_LIST_INIT(announcer_library, list(
	ANNOUNCER_VOICE_SS13 = list(
		ANNOUNCER_MSG_ROUND_START = 'sound/AI/welcome.ogg',

		ANNOUNCER_MSG_SHUTTLE_ENDROUND_DOCK = null,
		ANNOUNCER_MSG_SHUTTLE_ENDROUND_CALLED = null,

		ANNOUNCER_MSG_SHUTTLE_EMERG_DOCK = 'sound/AI/shuttledock.ogg',
		ANNOUNCER_MSG_SHUTTLE_EMERG_CALLED = 'sound/AI/shuttlecalled.ogg',
		ANNOUNCER_MSG_SHUTTLE_EMERG_RECALLED = 'sound/AI/shuttlerecalled.ogg',

		ANNOUNCER_MSG_NIGHTSHIFT_START = 'sound/AI/dim_lights.ogg',
		ANNOUNCER_MSG_NIGHTSHIFT_END = 'sound/AI/bright_lights.ogg',

		ANNOUNCER_MSG_NEW_AI = 'sound/AI/newai.ogg',

		ANNOUNCER_MSG_NEW_COMMAND_REPORT = 'sound/AI/commandreport.ogg',

		ANNOUNCER_MSG_UNIDENTIFIED_LIFESIGNS = 'sound/AI/aliens.ogg',

		ANNOUNCER_MSG_BIOHAZARD_FIVE = ,
		ANNOUNCER_MSG_BIOHAZARD_SEVEN = 'sound/AI/outbreak7.ogg',
	),
	ANNOUNCER_VOICE_VIRGO = list(
		ANNOUNCER_MSG_ROUND_START = 'sound/AI/welcome_virgo.ogg', // Skie

		ANNOUNCER_MSG_SHUTTLE_ENDROUND_DOCK = 'sound/AI/tramarrived.ogg',
		ANNOUNCER_MSG_SHUTTLE_ENDROUND_CALLED = 'sound/AI/tramcalled.ogg',

		ANNOUNCER_MSG_NEW_AI = null,
	),
))

// Edit these for custom AI message start sounds
/proc/announcer_message_preamble()
	return 'sound/AI/preamble.ogg'

/proc/announcer_message_preamble_delay()
	return 2.2 SECONDS // based on length of preamble.ogg + arbitrary delay
