// Skill manages for use in-game, where the skill list is attached to a mind datum, as opposed to character setup, where the list is inside prefs.
// Used mostly for inheritence.

/datum/skill_manager/in_game
	var/datum/mind/skill_owner = null	// The mind holding onto the skill list.

/datum/skill_manager/in_game/New(client/new_user, list/new_skill_list_ref, datum/mind/new_mind)
	..()
	if(istype(new_mind))
		skill_owner = new_mind
	else
		crash_with("/datum/skill_manager/in_game/New() suppled with improper list reference argument '[new_skill_list_ref]'.")
		qdel(src)

/datum/skill_manager/in_game/Destroy()
	skill_owner = null
	return ..()

/datum/skill_manager/in_game/get_age()
	var/mob/living/carbon/human/H = skill_owner.current
	if(istype(H))
		return H.age
	return ..()

/datum/skill_manager/in_game/get_species()
	var/mob/living/carbon/human/H = skill_owner.current
	if(istype(H))
		return H.species
	return ..()

// Override this for determining if they're a robot, and if so, what kind.
/datum/skill_manager/in_game/get_FBP_type()
	var/mob/living/carbon/human/H = skill_owner.current
	if(istype(H))
		return H.get_FBP_type()
	return ..()

/datum/skill_manager/in_game/refresh_ui()
	make_window()
	return ..()


// This subtype is for players to look at their own character's skills while in round.
// The skills that are in their character setup might not match their current character's skills (e.g. off-station antags).
/datum/skill_manager/in_game/local_viewer
	read_only = TRUE
	main_window_id = "self_skill_manager"

/datum/skill_manager/in_game/local_viewer/make_window()
	var/list/dat = list()
	dat += skill_point_total_content()
	dat += skill_table_content(skill_list_ref)

	var/datum/browser/popup = new(user, main_window_id, "[skill_owner.current.real_name]'s Skills", 800, 500, src)
	popup.set_content(dat.Join(null))
	popup.open()

/mob/living
	var/datum/skill_manager/in_game/local_viewer/local_skill_viewer = null
	var/datum/skill_manager/in_game/assignment/ingame_skill_assignment = null

/mob/living/Destroy()
	QDEL_NULL(local_skill_viewer)
	QDEL_NULL(ingame_skill_assignment)
	return ..()

/mob/living/verb/show_own_skills()
	set name = "Show Own Skills"
	set desc = "Opens a window displaying your current character's skillset."
	set category = "IC"

	if(!client || !mind)
		return

	if(!local_skill_viewer)
		local_skill_viewer = new(client, mind.skills, mind)

	local_skill_viewer.make_window()


// This subtype is for admins to be able to look at, and set a player's skills.
// There are no restrictions placed on what skills can be set to. Use responsibly.
/datum/skill_manager/in_game/admin_viewer
	main_window_id = "admin_skill_manager"

/datum/skill_manager/in_game/admin_viewer/is_valid()
	return TRUE

/datum/skill_manager/in_game/admin_viewer/make_window()
	var/list/dat = list()
	dat += "<b><h1>Modifications to skills are applied instantly!</h1></b>"
	dat += display_skill_setup_ui()

	var/datum/browser/popup = new(user, main_window_id, "Admin Skill Manager - [skill_owner.current.real_name]'s Skills", 800, 500, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()

// Some simple logging.
/datum/skill_manager/in_game/admin_viewer/write_skill_level(skill_id, new_skill_level)
	var/current_skill_level = skill_list_ref[skill_id]
	if(..()) // Only do this on successful edits.
		log_and_message_admins("[key_name(usr)] has modified [key_name(skill_owner.current)]'s [skill_id] skill level \
		from [current_skill_level-1] to [new_skill_level-1].")


// This subtype is used for the player to assign points to their character outside of character setup.
// Most commonly will be used for antags, both on and off station, as well as possibly for ghost roles.
// Main difference is that this skill manager modifies a buffer list instead of editing their character's list live, to avoid shenannigans.
// Skills which are already set also cannot be lowered.
// When the player is finished, they hit a 'commit' button, and the window closes.
/datum/skill_manager/in_game/assignment
//	var/list/buffer = null // List which gets modified. skill_list_ref is set to this.
	var/list/current_skills = null // The 'real' list of skills for the character. Used to forbid lowering a skill in buffer to below the same skill in this list.
	var/bonus_points = 50 // How many extra points someone gets to spend.
	main_window_id = "skill_manager_assignment"

/datum/skill_manager/in_game/assignment/New(client/new_user, list/new_skill_list_ref, datum/mind/new_mind)
	..()
	current_skills = new_skill_list_ref
	change_skill_list(current_skills.Copy())

/datum/skill_manager/in_game/assignment/Destroy()
	if(skill_owner.current)
		skill_owner.current.ingame_skill_assignment = null
	return ..()

/datum/skill_manager/in_game/assignment/can_write_skill_level(skill_id, new_skill_level)
	if(new_skill_level < current_skills[skill_id])
		return FALSE
	return ..()

// Sets their skills to the one in the window, then closes the windows.
/datum/skill_manager/in_game/assignment/proc/commit()
	skill_owner.skills = skill_list_ref.Copy()
	qdel(src)

/datum/skill_manager/in_game/assignment/make_window()
	var/list/dat = list()
	dat += "Skill levels cannot be lowered past their original levels."
	dat += display_skill_setup_ui()
	dat += href(src, list("commit" = 1), "Finalize Changes")

	var/datum/browser/popup = new(user, main_window_id, "In-Round Assignment - [skill_owner.current.real_name]'s Skills", 800, 500, src)
	popup.set_content(dat.Join("<br>"))
	popup.open()

/datum/skill_manager/in_game/assignment/Topic(var/href,var/list/href_list)
	if(..())
		return 1

	// Applies the skill configuration to the actual skill list.
	if(href_list["commit"])
		if(!is_valid())
			to_chat(user, span("warning", "Your current skill selection is not valid. Please correct it and try again."))
			return TOPIC_HANDLED

		if(alert(user, "This will lock in your current skill selection to your character. You will not be able to change it afterwards. \
		Are you sure you are finished?", "Finalize Warning", "No", "Yes") == "No")
			return TOPIC_HANDLED

		commit()
		return TOPIC_HANDLED

/mob/living/verb/test_assignment()
	ingame_skill_assignment = new(client, mind.skills, mind)
	ingame_skill_assignment.make_window()
