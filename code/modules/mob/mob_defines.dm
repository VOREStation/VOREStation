/mob
	density = TRUE
	layer = MOB_LAYER
	plane = MOB_PLANE
	animate_movement = 2
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	///when this be added to vis_contents of something it inherit something.plane, important for visualisation of mob in openspace.
	vis_flags = VIS_INHERIT_PLANE
	var/datum/mind/mind

	var/stat = 0 //Whether a mob is alive or dead. TODO: Move this to living - Nodrak
	var/next_move = null // world.time when mob is next allowed to self-move.

	//Not in use yet
	var/obj/effect/organstructure/organStructure = null

	var/obj/screen/hands = null
	var/obj/screen/pullin = null
	var/obj/screen/purged = null
	var/obj/screen/internals = null
	var/obj/screen/i_select = null
	var/obj/screen/m_select = null
	var/obj/screen/healths = null
	var/obj/screen/throw_icon = null
	var/obj/screen/pain = null
	var/obj/screen/gun/item/item_use_icon = null
	var/obj/screen/gun/radio/radio_use_icon = null
	var/obj/screen/gun/move/gun_move_icon = null
	var/obj/screen/gun/run/gun_run_icon = null
	var/obj/screen/gun/mode/gun_setting_icon = null
	var/obj/screen/ling/chems/ling_chem_display = null
	var/obj/screen/wizard/energy/wiz_energy_display = null
	var/obj/screen/wizard/instability/wiz_instability_display = null
	var/obj/screen/autowhisper_display = null

	var/datum/plane_holder/plane_holder = null
	var/list/vis_enabled = null		// List of vision planes that should be graphically visible (list of their VIS_ indexes).
	var/list/planes_visible = null	// List of atom planes that are logically visible/interactable (list of actual plane numbers).

	//spells hud icons - this interacts with add_spell and remove_spell
	var/list/obj/screen/movable/spell_master/spell_masters = null
	var/obj/screen/movable/ability_master/ability_master = null

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/obj/screen/zone_sel/zone_sel = null

	var/use_me = 1 //Allows all mobs to use the me verb by default, will have to manually specify they cannot
	var/damageoverlaytemp = 0
	var/computer_id = null
	var/already_placed = 0.0
	var/obj/machinery/machine = null
	var/other_mobs = null
	var/memory = ""
	var/poll_answer = 0.0
	var/sdisabilities = 0	//Carbon
	var/disabilities = 0	//Carbon
	var/atom/movable/pulling = null
	var/transforming = null	//Carbon
	var/other = 0.0
	var/eye_blind = null	//Carbon
	var/eye_blurry = null	//Carbon
	var/ear_deaf = null		//Carbon
	var/ear_damage = null	//Carbon
	var/stuttering = null	//Carbon
	var/slurring = null		//Carbon
	var/real_name = null
	var/nickname = null
	var/flavor_text = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""
	var/exploit_addons = list()		//Assorted things that show up at the end of the exploit_record list
	var/blinded = null
	var/bhunger = 0			//Carbon
	var/ajourn = 0
	var/druggy = 0			//Carbon
	var/confused = 0		//Carbon
	var/antitoxs = null
	var/phoron = null
	var/sleeping = 0		//Carbon
	var/resting = 0			//Carbon
	var/lying = 0
	var/lying_prev = 0
	var/is_shifted = FALSE // VoreStation Edit; pixel shifting
	var/canmove = 1
	//Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	var/incorporeal_move = 0 //0 is off, 1 is normal, 2 is for ninjas.
	var/unacidable = FALSE
	var/list/pinned = list()            // List of things pinning this creature to walls (see living_defense.dm)
	var/list/embedded = list()          // Embedded items, since simple mobs don't have organs.
	var/list/languages = list()         // For speaking/listening.
	var/list/language_keys = list()		// List of language keys indexing languages
	var/species_language = null			// For species who want reset to use a specified default.
	var/only_species_language  = 0		// For species who can only speak their default and no other languages. Does not affect understanding.
	var/list/speak_emote = list("says") // Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/emote_type = 1		// Define emote default type, 1 for seen emotes, 2 for heard emotes
	var/facing_dir = null   // Used for the ancient art of moonwalking.

	var/name_archive //For admin things like possession

	var/timeofdeath = 0.0//Living
	var/cpr_time = 1.0//Carbon

	var/bodytemperature = 310.055	//98.7 F
	var/drowsyness = 0.0//Carbon
	var/charges = 0.0

	var/paralysis = 0.0
	var/stunned = 0.0
	var/weakened = 0.0
	var/losebreath = 0.0//Carbon
	var/a_intent = I_HELP//Living
	var/m_int = null//Living
	var/m_intent = I_RUN//Living
	var/lastKnownIP = null
	var/obj/buckled = null//Living
	var/no_pull_when_living = FALSE //Test for if it can be pulled when alive

	var/seer = 0 //for cult//Carbon, probably Human

	var/datum/hud/hud_used = null

	var/list/grabbed_by = list()

	var/list/mapobjs = list()

	var/in_throw_mode = 0

	var/inertia_dir = 0

	var/music_lastplayed = "null"

	var/job = null//Living

	var/const/blindness = 1//Carbon
	var/const/deafness = 2//Carbon
	var/const/muteness = 4//Carbon

	var/can_pull_size = ITEMSIZE_NO_CONTAINER // Maximum w_class the mob can pull.
	var/can_pull_mobs = MOB_PULL_LARGER // Whether or not the mob can pull other mobs.

	var/datum/dna/dna = null//Carbon
	var/radiation = 0.0//Carbon

	var/list/mutations = list() //Carbon -- Doohl
	//see: setup.dm for list of mutations

	var/voice_name = "unidentifiable voice"

	var/faction = FACTION_NEUTRAL //Used for checking whether hostile simple animals will attack you, possibly more stuff later

	var/can_be_antagged = FALSE // To prevent pAIs/mice/etc from getting antag in autotraitor and future auto- modes. Uses inheritance instead of a bunch of typechecks.
	var/away_from_keyboard = FALSE	//are we at, or away, from our keyboard?
	var/manual_afk = FALSE			//did we set afk manually or was it automatic?

//Generic list for proc holders. Only way I can see to enable certain verbs/procs. Should be modified if needed.
	var/proc_holder_list[] = list()//Right now unused.
	//Also unlike the spell list, this would only store the object in contents, not an object in itself.

	/* Add this line to whatever stat module you need in order to use the proc holder list.
	Unlike the object spell system, it's also possible to attach verb procs from these objects to right-click menus.
	This requires creating a verb for the object proc holder.

	if (proc_holder_list.len)//Generic list for proc_holder objects.
		for(var/obj/effect/proc_holder/P in proc_holder_list)
			statpanel("[P.panel]","",P)
	*/

//The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/mob/living/carbon/LAssailant = null

//Wizard mode, but can be used in other modes thanks to the brand new "Give Spell" badmin button
	var/list/spell/spell_list = list()

//Changlings, but can be used in other modes
//	var/obj/effect/proc_holder/changpower/list/power_list = list()

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/update_icon = 1 //Set to 1 to trigger update_icons() at the next life() call

	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)

	var/area/lastarea = null
	var/lastareachange = null

	var/digitalcamo = 0 // Can they be tracked by the AI?

	var/list/radar_blips = list() // list of screen objects, radar blips
	var/radar_open = 0 	// nonzero is radar is open


	var/obj/control_object //Used by admins to possess objects. All mobs should have this var

	//Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/universal_speak = 0 // Set to 1 to enable the mob to speak to everyone -- TLE
	var/universal_understand = 0 // Set to 1 to enable the mob to understand everyone, not necessarily speak

	var/stance_damage = 0 //Whether this mob's ability to stand has been affected

	//If set, indicates that the client "belonging" to this (clientless) mob is currently controlling some other mob
	//so don't treat them as being SSD even though their client var is null.
	var/mob/teleop = null

	var/list/shouldnt_see = list(/mob/observer/eye)	//list of objects that this mob shouldn't see in the stat panel. this silliness is needed because of AI alt+click and cult blood runes

	var/list/active_genes=list()
	var/mob_size = MOB_MEDIUM
	var/forbid_seeing_deadchat = FALSE // Used for lings to not see deadchat, and to have ghosting behave as if they were not really dead.

	var/seedarkness = 1	//Determines mob's ability to see shadows. 1 = Normal vision, 0 = darkvision

	var/get_rig_stats = 0 //Moved from computer.dm

	var/custom_speech_bubble = "default"

	var/low_priority = FALSE //Skip processing life() if there's just no players on this Z-level

	var/default_pixel_x = 0 //For offsetting mobs
	var/default_pixel_y = 0

	var/attack_icon //Icon to use when attacking w/o anything in-hand
	var/attack_icon_state //State for above

	var/registered_z

	var/in_enclosed_vehicle = 0	//For mechs and fighters ambiance. Can be used in other cases.

	var/list/progressbars = null //VOREStation Edit

	var/datum/focus //What receives our keyboard inputs. src by default
	/// dict of custom stat tabs with data
	var/list/list/misc_tabs = list()

	var/list/datum/action/actions

	VAR_PROTECTED/list/viruses
	VAR_PROTECTED/list/resistances

	var/custom_footstep = FOOTSTEP_MOB_SHOE
	VAR_PRIVATE/is_motion_tracking = FALSE // Prevent multiple unsubs and resubs, also used to check if the vis layer is enabled, use has_motiontracking() to get externally.
	VAR_PRIVATE/wants_to_see_motion_echos = TRUE

	/// a ckey that persists client logout / ghosting, replaced when a client inhabits the mob
	var/persistent_ckey
