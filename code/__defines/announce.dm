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

#define ANNOUNCER_MSG_RADIATION "announcer_msg_radiation"
#define ANNOUNCER_MSG_SPACETIME_ANOMS "announcer_msg_spacetime_anoms"
#define ANNOUNCER_MSG_GRAV_ANOMS "announcer_msg_grav_anoms"
#define ANNOUNCER_MSG_IONSTORM "announcer_msg_ionstorm"
#define ANNOUNCER_MSG_METEORS "announcer_msg_meteors"

#define ANNOUNCER_MSG_POWER_OFF "announcer_msg_power_off"
#define ANNOUNCER_MSG_POWER_ON "announcer_msg_power_on"


#define ANNOUNCER_MSG_DISTRESS_SIGNAL "announcer_msg_distress_signal"


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

		ANNOUNCER_MSG_BIOHAZARD_FIVE = 'sound/AI/outbreak5.ogg',
		ANNOUNCER_MSG_BIOHAZARD_SEVEN = 'sound/AI/outbreak7.ogg',

		ANNOUNCER_MSG_RADIATION = 'sound/AI/radiation.ogg',
		ANNOUNCER_MSG_SPACETIME_ANOMS = 'sound/AI/spanomalies.ogg',
		ANNOUNCER_MSG_GRAV_ANOMS = 'sound/AI/granomalies.ogg',
		ANNOUNCER_MSG_IONSTORM = 'sound/AI/ionstorm.ogg',
		ANNOUNCER_MSG_METEORS = 'sound/AI/meteors.ogg',

		ANNOUNCER_MSG_POWER_OFF = 'sound/AI/poweroff.ogg',
		ANNOUNCER_MSG_POWER_ON = 'sound/AI/poweron.ogg',

		ANNOUNCER_MSG_DISTRESS_SIGNAL = 'sound/AI/sos.ogg',
	),
	ANNOUNCER_VOICE_VIRGO = list(
		ANNOUNCER_MSG_ROUND_START = 'sound/AI/welcome_virgo.ogg', // Skie

		ANNOUNCER_MSG_SHUTTLE_ENDROUND_DOCK = 'sound/AI/tramarrived.ogg',
		ANNOUNCER_MSG_SHUTTLE_ENDROUND_CALLED = 'sound/AI/tramcalled.ogg',

		ANNOUNCER_MSG_NEW_AI = null,
	),
))

#define AIRLOCK_MSG_OUT "airlock_out"
#define AIRLOCK_MSG_IN "airlock_in"
#define AIRLOCK_MSG_BEEP "airlock_beep"
#define AIRLOCK_MSG_END_OUT "airlock_end_out"
#define AIRLOCK_MSG_END_IN "airlock_end_in"
