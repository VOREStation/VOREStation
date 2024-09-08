// Define a place to save in character setup
/datum/preferences
	var/resleeve_lock = 0	// Whether movs should have OOC reslieving protection. Default false.
	var/resleeve_scan = 1	// Whether mob should start with a pre-spawn body scan.  Default true.
	var/mind_scan = 1		// Whether mob should start with a pre-spawn mind scan.  Default true.

// Definition of the stuff for Sizing
/datum/category_item/player_setup_item/vore/resleeve
	name = "Resleeving"
	sort_order = 4

/datum/category_item/player_setup_item/vore/resleeve/load_character(list/save_data)
	pref.resleeve_lock = save_data["resleeve_lock"]
	pref.resleeve_scan = save_data["resleeve_scan"]
	pref.mind_scan = save_data["mind_scan"]

/datum/category_item/player_setup_item/vore/resleeve/save_character(list/save_data)
	save_data["resleeve_lock"] = pref.resleeve_lock
	save_data["resleeve_scan"] = pref.resleeve_scan
	save_data["mind_scan"] = pref.mind_scan

/datum/category_item/player_setup_item/vore/resleeve/sanitize_character()
	pref.resleeve_lock		= sanitize_integer(pref.resleeve_lock, 0, 1, initial(pref.resleeve_lock))
	pref.resleeve_scan		= sanitize_integer(pref.resleeve_scan, 0, 1, initial(pref.resleeve_scan))
	pref.mind_scan			= sanitize_integer(pref.mind_scan, 0, 1, initial(pref.mind_scan))

/datum/category_item/player_setup_item/vore/resleeve/copy_to_mob(var/mob/living/carbon/human/character)
	if(character && !istype(character,/mob/living/carbon/human/dummy))
		spawn(50)
			if(QDELETED(character) || QDELETED(pref))
				return // They might have been deleted during the wait
			if(pref.resleeve_scan)
				var/datum/transhuman/body_record/BR = new()
				BR.init_from_mob(character, pref.resleeve_scan, pref.resleeve_lock)
			if(pref.mind_scan)
				var/datum/transcore_db/our_db = SStranscore.db_by_key(null)
				if(our_db)
					our_db.m_backup(character.mind,character.nif,one_time = TRUE)
			if(pref.resleeve_lock)
				character.resleeve_lock = character.ckey
			character.original_player = character.ckey

/datum/category_item/player_setup_item/vore/resleeve/content(var/mob/user)
	. += "<br>"
	. += "<b>Start With Body Scan:</b> <a [pref.resleeve_scan ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_resleeve_scan=1'><b>[pref.resleeve_scan ? "Yes" : "No"]</b></a><br>"
	. += "<b>Start With Mind Scan:</b> <a [pref.mind_scan ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_mind_scan=1'><b>[pref.mind_scan ? "Yes" : "No"]</b></a><br>"
	. += "<b>Prevent Body Impersonation:</b> <a [pref.resleeve_lock ? "class='linkOn'" : ""] href='?src=\ref[src];toggle_resleeve_lock=1'><b>[pref.resleeve_lock ? "Yes" : "No"]</b></a><br>"

/datum/category_item/player_setup_item/vore/resleeve/OnTopic(var/href, var/list/href_list, var/mob/user)
	if(href_list["toggle_resleeve_lock"])
		pref.resleeve_lock = pref.resleeve_lock ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["toggle_resleeve_scan"])
		pref.resleeve_scan = pref.resleeve_scan ? 0 : 1;
		return TOPIC_REFRESH
	else if(href_list["toggle_mind_scan"])
		pref.mind_scan = pref.mind_scan ? 0 : 1;
		return TOPIC_REFRESH
	return ..();
