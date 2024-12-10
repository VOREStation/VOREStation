var/list/trait_datums = list() // Assoc list using name = instance.  Traits are saved as a list of strings.
var/list/trait_type_to_ref = list() // Similar to above but uses paths, which is more reliable but more risky to save.
var/list/trait_categories = list() // The categories available for the trait menu.

/hook/startup/proc/populate_trait_list()

	//create a list of trait datums
	for(var/trait_type as anything in subtypesof(/datum/trait))
		if (is_abstract(trait_type))
			continue
		var/datum/trait/T = new trait_type
		if(!T.is_available())
			qdel(T)
			continue

		if(!T.name)
			error("Trait Menu - Missing name: [T.type]")
			continue

		if(!T.category)
			error("Trait Menu - Missing category: [T.type]")
			continue

		T.desc = T.generate_desc()

		trait_datums[T.name] = T
		trait_type_to_ref[T.type] = T
		if(!(T.category in trait_categories))
			trait_categories += T.category

	return 1

/datum/category_item/player_setup_item/traits
	name = "Quirks" //VOREStation Edit
	sort_order = 1
	var/current_tab = "Physical"

/datum/category_item/player_setup_item/traits/load_character(list/save_data)
	pref.traits = save_data["traits"]

/datum/category_item/player_setup_item/traits/save_character(list/save_data)
	save_data["traits"] = pref.traits


/datum/category_item/player_setup_item/traits/content()
	. = list()
	. += "<table align = 'center' width = 100%>"
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>Traits</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"

	. += "<tr><td colspan=3><center>"
	var/firstcat = 1
	for(var/category in trait_categories)
		if(firstcat)
			firstcat = 0
		else
			. += " |"

		if(category == current_tab)
			. += " " + span_linkOn("[category]") + " "
		else
			. += " <a href='byond://?src=\ref[src];select_category=[category]'>[category]</a> "
	. += "</center></td></tr>"


	for(var/trait_name in trait_datums)
		var/datum/trait/T = trait_datums[trait_name]
		if(T.category != current_tab)
			continue

		var/ticked = (T.name in pref.traits)
		var/style_class
		if(!T.validate(pref.traits, src))
			style_class = "linkOff"
		else if(ticked)
			style_class = "linkOn"
		. += "<tr style='vertical-align:top;'><td width=25%><div align='center'><a style='white-space:normal;' [style_class ? "class='[style_class]' " : ""]href='byond://?src=\ref[src];toggle_trait=[html_encode(T.name)]'>[T.name]</a></div></td>"
//		. += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"

		var/invalidity = T.test_for_invalidity(src)
		var/conflicts = T.test_for_trait_conflict(pref.traits)
		var/invalid = ""
		if(invalidity)
			invalid += "[invalidity]  "
		if(conflicts)
			invalid += "This trait is mutually exclusive with [conflicts]."

		. += "<td width = 75%><font size=2><i>[T.desc]</i>\
		[invalid ? "<font color='#FF0000'><br>Cannot take trait.  Reason: [invalid]</font>":""]</font></td></tr>"
//		if(ticked)
//			. += "<tr><td colspan=3>"
//			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
//				. += " <a href='byond://?src=\ref[src];gear=[G.display_name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
//			. += "</td></tr>"
	. += "</table>"
	. = jointext(., null)

/datum/category_item/player_setup_item/traits/sanitize_character()
	var/mob/preference_mob = preference_mob()
	if(!islist(pref.traits))
		pref.traits = list()

	for(var/trait_name in pref.traits)
		if(!(trait_name in trait_datums))
			pref.traits -= trait_name

	for(var/trait_name in pref.traits)
		if(!trait_datums[trait_name])
			to_chat(preference_mob, span_warning("You cannot have more than one of trait: [trait_name]"))
			pref.traits -= trait_name
		else
			var/datum/trait/T = trait_datums[trait_name]
			var/invalidity = T.test_for_invalidity(src)
			if(invalidity)
				pref.traits -= trait_name
				to_chat(preference_mob, span_warning("You cannot take the [trait_name] trait.  Reason: [invalidity]"))

			var/conflicts = T.test_for_trait_conflict(pref.traits)
			if(conflicts)
				pref.traits -= trait_name
				to_chat(preference_mob, span_warning("The [trait_name] trait is mutually exclusive with [conflicts]."))

/datum/category_item/player_setup_item/traits/OnTopic(href, href_list, user)
	if(href_list["toggle_trait"])
		var/datum/trait/T = trait_datums[href_list["toggle_trait"]]
		if(T.name in pref.traits)
			pref.traits -= T.name
		else
			var/invalidity = T.test_for_invalidity(src)
			if(invalidity)
				to_chat(user, span_warning("You cannot take the [T.name] trait.  Reason: [invalidity]"))
				return TOPIC_NOACTION

			var/conflicts = T.test_for_trait_conflict(pref.traits)
			if(conflicts)
				to_chat(user, span_warning("The [T.name] trait is mutually exclusive with [conflicts]."))
				return TOPIC_NOACTION

			pref.traits += T.name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH
	return ..()


/datum/trait
	abstract_type = /datum/trait
	var/name = null							// Name to show on UI
	var/desc = null							// Description of what it does, also shown on UI.
	var/list/mutually_exclusive = list()	// List of trait types which cannot be taken alongside this trait.
	var/category = null						// What section to place this trait inside.

// Applies effects to the newly spawned mob.
/datum/trait/proc/apply_trait_post_spawn(var/mob/living/L)
	return

// Used to forbid a trait based on certain criteria (e.g. if they are an FBP).
// It receives the player_setup_item datum since some reasons for being invalid depend on the currently loaded preferences.
// Returns a string explaining why the trait is invalid.  Returns null if valid.
/datum/trait/proc/test_for_invalidity(var/datum/category_item/player_setup_item/traits/setup)
	return null

// Checks mutually_exclusive.  current_traits needs to be a list of strings.
// Returns null if everything is well, similar to the above proc.  Otherwise returns an english_list() of conflicting traits.
/datum/trait/proc/test_for_trait_conflict(var/list/current_traits)
	var/list/conflicts = list()
	var/result

	if(mutually_exclusive.len)
		for(var/trait_name in current_traits)
			var/datum/trait/T = trait_datums[trait_name]
			if(T.type in mutually_exclusive)
				conflicts.Add(T.name)

	if(conflicts.len)
		result = english_list(conflicts)

	return result

/datum/trait/proc/is_available()
	return TRUE

// Similar to above, but uses the above two procs, in one place.
// Returns TRUE is everything is well.
/datum/trait/proc/validate(var/list/current_traits, var/datum/category_item/player_setup_item/traits/setup)
	if(test_for_invalidity(setup))
		return FALSE
	if(test_for_trait_conflict(current_traits))
		return FALSE
	return TRUE

// Creates a description, if one doesn't exist.
// This one is for inheritence, and so doesn't do anything.
/datum/trait/proc/generate_desc()
	return desc

/mob/living/proc/apply_traits()
	if(!mind || !mind.traits || !mind.traits.len)
		return
	for(var/trait in mind.traits)
		var/datum/trait/T = trait_datums[trait]
		if(istype(T))
			T.apply_trait_post_spawn(src)
