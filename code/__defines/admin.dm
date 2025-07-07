// A set of constants used to determine which type of mute an admin wishes to apply.
// Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO, etc. = (MUTE_IC << 1)
// Therefore there needs to be a gap between the flags for the automute flags.
#define MUTE_IC        0x1
#define MUTE_OOC       0x2
#define MUTE_LOOC      0x4
#define MUTE_PRAY      0x8
#define MUTE_ADMINHELP 0x10
#define MUTE_DEADCHAT  0x20
#define MUTE_ALL       0xFFFF

// Number of identical messages required to get the spam-prevention auto-mute thing to trigger warnings and automutes.
#define SPAM_TRIGGER_WARNING  5
#define SPAM_TRIGGER_AUTOMUTE 10

// Some constants for DB_Ban
#define BANTYPE_PERMA       1
#define BANTYPE_TEMP        2
#define BANTYPE_JOB_PERMA   3
#define BANTYPE_JOB_TEMP    4
#define BANTYPE_ANY_FULLBAN 5 // Used to locate stuff to unban.

#define ROUNDSTART_LOGOUT_REPORT_TIME 6000 // Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

//Admin Permissions
/// Used for signifying that all admins can use this regardless of actual permissions
#define R_NONE NONE
#define R_BUILDMODE (1<<0)
#define R_ADMIN (1<<1)
#define R_BAN (1<<2)
#define R_FUN (1<<3)
#define R_SERVER (1<<4)
#define R_DEBUG (1<<5)
#define R_POSSESS (1<<6)
#define R_PERMISSIONS (1<<7)
#define R_STEALTH (1<<8)
#define R_REJUVINATE (1<<9)
#define R_VAREDIT (1<<10)
#define R_SOUNDS (1<<11)
#define R_SPAWN (1<<12)
#define R_MOD (1<<13)
#define R_EVENT (1<<14)
#define R_HOST (1<<15) //higher than this will overflow
#define R_MENTOR (1<<16)

#define R_DEFAULT R_NONE

#define R_EVERYTHING (1<<17)-1 //the sum of all other rank permissions, used for +EVERYTHING
#define R_HOLDER ((R_EVERYTHING) & (~R_MENTOR))

#define SMITE_BREAKLEGS				"Break Legs"
#define SMITE_BLUESPACEARTILLERY	"Bluespace Artillery"
#define SMITE_SPONTANEOUSCOMBUSTION	"Spontaneous Combustion"
#define SMITE_LIGHTNINGBOLT			"Lightning Bolt"
#define SMITE_TERROR				"Terrify"
#define SMITE_SHADEKIN_ATTACK		"Shadekin (Attack)"
#define SMITE_SHADEKIN_NOMF			"Shadekin (Devour)"
#define SMITE_REDSPACE_ABDUCT		"Redspace Abduction"
#define SMITE_AD_SPAM				"Ad Spam"
#define SMITE_AUTOSAVE				"10 Second Autosave"
#define SMITE_AUTOSAVE_WIDE			"10 Second Autosave (AoE)"
#define SMITE_SPICEREQUEST			"Give Them Spice (Harmless)"
#define SMITE_PEPPERNADE			"Give Them Spice (Extra Spicy)"

#define MODIFIY_ROBOT_MODULE_ADD	"Add a Module"
#define MODIFIY_ROBOT_MODULE_REMOVE	"Remove a Module"
#define MODIFIY_ROBOT_APPLY_UPGRADE	"Apply an Upgrade"
#define MODIFIY_ROBOT_SUPP_ADD		"Add Upgrade Support"
#define MODIFIY_ROBOT_SUPP_REMOVE	"Remove Upgrade Support"
#define MODIFIY_ROBOT_RADIOC_ADD	"Add a Radio Channel"
#define MODIFIY_ROBOT_RADIOC_REMOVE	"Remove a Radio Channel"
#define MODIFIY_ROBOT_COMP_ADD		"Replace a Component"
#define MODIFIY_ROBOT_COMP_REMOVE	"Remove a Component"
#define MODIFIY_ROBOT_SWAP_MODULE	"Swap a Robot Module"
#define MODIFIY_ROBOT_RESET_MODULE	"Fully Reset Robot Module"
#define MODIFIY_ROBOT_TOGGLE_ERT	"Toggle ERT Module Overwrite"
#define MODIFIY_ROBOT_LIMIT_MODULES_ADD	"Restrict Modules to"
#define MODIFIY_ROBOT_LIMIT_MODULES_REMOVE	"Remove from restricted Modules"
#define MODIFIY_ROBOT_TOGGLE_STATION_ACCESS "Toggle All Station Access Codes"
#define MODIFIY_ROBOT_TOGGLE_CENT_ACCESS	"Toggle Central Access Codes"

#define ADMIN_QUE(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];adminmoreinfo=\ref[user]'>?</a>)"
#define ADMIN_FLW(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];adminplayerobservefollow=\ref[user]'>FLW</a>)"
#define ADMIN_PP(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];adminplayeropts=\ref[user]'>PP</a>)"
#define ADMIN_VV(atom) "(<a href='byond://?_src_=vars;[HrefToken(TRUE)];Vars=\ref[atom]'>VV</a>)"
#define ADMIN_SM(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];subtlemessage=\ref[user]'>SM</a>)"
#define ADMIN_TP(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];traitor=\ref[user]'>TP</a>)"
#define ADMIN_BSA(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];BlueSpaceArtillery=\ref[user]'>BSA</a>)"
#define ADMIN_KICK(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];boot2=\ref[user]'>KICK</a>)"
#define ADMIN_CENTCOM_REPLY(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];CentComReply=\ref[user]'>RPLY</a>)"
#define ADMIN_SYNDICATE_REPLY(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];SyndicateReply=\ref[user]'>RPLY</a>)"
#define ADMIN_SC(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];adminspawncookie=\ref[user]'>SC</a>)"
#define ADMIN_SMITE(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];adminsmite=\ref[user]'>SMITE</a>)"
#define ADMIN_LOOKUP(user) "[key_name_admin(user)][ADMIN_QUE(user)]"
#define ADMIN_LOOKUPFLW(user) "[key_name_admin(user)][ADMIN_QUE(user)] [ADMIN_FLW(user)]"
#define ADMIN_FULLMONTY_NONAME(user) "[ADMIN_QUE(user)] [ADMIN_PP(user)] [ADMIN_VV(user)] [ADMIN_SM(user)] [ADMIN_FLW(user)] [ADMIN_TP(user)]"
#define ADMIN_FULLMONTY(user) "[key_name_admin(user)] [ADMIN_FULLMONTY_NONAME(user)]"
#define ADMIN_JMP(src) "(<a href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)"
#define COORD(src) "[src ? src.Admin_Coordinates_Readable() : "nonexistent location"]"
#define AREACOORD(src) "[src ? src.Admin_Coordinates_Readable(TRUE) : "nonexistent location"]"
#define ADMIN_COORDJMP(src) "[src ? src.Admin_Coordinates_Readable(FALSE, TRUE) : "nonexistent location"]"
#define ADMIN_VERBOSEJMP(src) "[src ? src.Admin_Coordinates_Readable(TRUE, TRUE) : "nonexistent location"]"
#define ADMIN_CA(user) "(<a href='byond://?_src_=holder;[HrefToken(TRUE)];secretsadmin=check_antagonist'>?</a>)"

/atom/proc/Admin_Coordinates_Readable(area_name, admin_jump_ref)
	var/turf/turf_at_coords = Safe_COORD_Location()
	return turf_at_coords ? "[area_name ? "[get_area_name(turf_at_coords, TRUE)] " : " "]([turf_at_coords.x],[turf_at_coords.y],[turf_at_coords.z])[admin_jump_ref ? " [ADMIN_JMP(turf_at_coords)]" : ""]" : "nonexistent location"

/atom/proc/Safe_COORD_Location()
	var/atom/drop_atom = drop_location()
	if(!drop_atom)
		return //not a valid atom.
	var/turf/drop_turf = get_step(drop_atom, 0) //resolve where the thing is.
	if(!drop_turf) //incase it's inside a valid drop container, inside another container. ie if a mech picked up a closet and has it inside its internal storage.
		var/atom/last_try = drop_atom.loc?.drop_location() //one last try, otherwise fuck it.
		if(last_try)
			drop_turf = get_step(last_try, 0)
	return drop_turf

/turf/Safe_COORD_Location()
	return src

#define AHELP_ACTIVE 1
#define AHELP_CLOSED 2
#define AHELP_RESOLVED 3

// LOG BROWSE TYPES
#define BROWSE_ROOT_ALL_LOGS 1
#define BROWSE_ROOT_RUNTIME_LOGS 2
#define BROWSE_ROOT_CURRENT_LOGS 3

/// A value for /datum/admins/cached_feedback_link to indicate empty, rather than unobtained
#define NO_FEEDBACK_LINK "no_feedback_link"
