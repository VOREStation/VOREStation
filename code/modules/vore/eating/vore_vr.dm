
/*
VVVVVVVV           VVVVVVVV     OOOOOOOOO     RRRRRRRRRRRRRRRRR   EEEEEEEEEEEEEEEEEEEEEE
V::::::V           V::::::V   OO:::::::::OO   R::::::::::::::::R  E::::::::::::::::::::E
V::::::V           V::::::V OO:::::::::::::OO R::::::RRRRRR:::::R E::::::::::::::::::::E
V::::::V           V::::::VO:::::::OOO:::::::ORR:::::R     R:::::REE::::::EEEEEEEEE::::E
 V:::::V           V:::::V O::::::O   O::::::O  R::::R     R:::::R  E:::::E       EEEEEE
  V:::::V         V:::::V  O:::::O     O:::::O  R::::R     R:::::R  E:::::E
   V:::::V       V:::::V   O:::::O     O:::::O  R::::RRRRRR:::::R   E::::::EEEEEEEEEE
    V:::::V     V:::::V    O:::::O     O:::::O  R:::::::::::::RR    E:::::::::::::::E
     V:::::V   V:::::V     O:::::O     O:::::O  R::::RRRRRR:::::R   E:::::::::::::::E
      V:::::V V:::::V      O:::::O     O:::::O  R::::R     R:::::R  E::::::EEEEEEEEEE
       V:::::V:::::V       O:::::O     O:::::O  R::::R     R:::::R  E:::::E
        V:::::::::V        O::::::O   O::::::O  R::::R     R:::::R  E:::::E       EEEEEE
         V:::::::V         O:::::::OOO:::::::ORR:::::R     R:::::REE::::::EEEEEEEE:::::E
          V:::::V           OO:::::::::::::OO R::::::R     R:::::RE::::::::::::::::::::E
           V:::V              OO:::::::::OO   R::::::R     R:::::RE::::::::::::::::::::E
            VVV                 OOOOOOOOO     RRRRRRRR     RRRRRRREEEEEEEEEEEEEEEEEEEEEE

-Aro <3 */

//
// Overrides/additions to stock defines go here, as well as hooks. Sort them by
// the object they are overriding. So all /mob/living together, etc.
//
/datum/configuration
	var/items_survive_digestion = 1		//For configuring if the important_items survive digestion

//
// The datum type bolted onto normal preferences datums for storing Virgo stuff
//
/client
	var/datum/vore_preferences/prefs_vr

/hook/client_new/proc/add_prefs_vr(client/C)
	C.prefs_vr = new/datum/vore_preferences(C)
	if(C.prefs_vr)
		return 1

	return 0

/datum/vore_preferences
	//Actual preferences
	var/digestable = 1
	var/list/belly_prefs = list()

	//Mechanically required
	var/path
	var/slot
	var/client/client
	var/client_ckey

/datum/vore_preferences/New(client/C)
	if(istype(C))
		client = C
		client_ckey = C.ckey
		load_vore(C)

//
// Adding procs to types to support vore
//
/datum/vore_preferences/proc/save_vore_preferences()
	save_vore()
	return

/datum/vore_preferences/proc/load_vore_preferences()
	load_vore()
	return

//
//	Check if an object is capable of eating things, based on vore_organs
//
/proc/is_vore_predator(var/mob/living/O)
	if(istype(O,/mob/living))
		if(O.vore_organs.len > 0)
			return 1

	return 0

//
//	Belly searching for simplifying other procs
//
/proc/check_belly(atom/movable/A)
	if(istype(A.loc,/mob/living))
		var/mob/living/M = A.loc
		for(var/I in M.vore_organs)
			var/datum/belly/B = M.vore_organs[I]
			if(A in B.internal_contents)
				return(B)

	return 0

//
// Save/Load Vore Preferences
//
/datum/vore_preferences/proc/load_vore(filename="preferences_vr.sav")
	if(!client || !client_ckey) return 0 //No client, how can we save?
	if(!path)
		path = "data/player_saves/[copytext(client_ckey,1,2)]/[client_ckey]/[filename]"
		if(!path) return 0 //Path couldn't be set?

	var/savefile/S = new /savefile(path)
	if(!S) return 0 //Savefile object couldn't be created?

	S.cd = "/"
	if(!slot)
		slot = client.prefs.default_slot

	slot = sanitize_integer(slot, 1, config.character_slots, initial(client.prefs.default_slot))
	S.cd = "/character[slot]"

	S["digestable"] >> digestable
	S["belly_prefs"] >> belly_prefs

	return 1

/datum/vore_preferences/proc/save_vore()
	if(!path)				return 0
	if(!slot)				return 0
	var/savefile/S = new /savefile(path)
	if(!S)					return 0
	S.cd = "/character[slot]"

	S["digestable"] << digestable
	S["belly_prefs"] << belly_prefs

	return 1