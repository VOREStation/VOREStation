
/datum/component/weaver
	var/silk_reserve = 100
	var/silk_max_reserve = 500
	var/silk_color = "#FFFFFF"
	var/silk_production = FALSE
	var/silk_generation_amount = 2
	var/nutrtion_per_silk = 0.2

	var/mob/living/owner

	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/weaver/Initialize()

	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent
	add_verb(owner, /mob/living/proc/weaver_control_panel)
	if(ishuman(parent))
		add_verb(owner, /mob/living/carbon/human/proc/enter_cocoon)

	//Processing
/datum/component/weaver/proc/process_component()
	if (QDELETED(parent))
		return
	process_weaver_silk()

/datum/component/weaver/Destroy(force = FALSE)
	remove_verb(owner, /mob/living/proc/weaver_control_panel)
	if(ishuman(parent))
		remove_verb(owner, /mob/living/carbon/human/proc/enter_cocoon)
	owner = null
	. = ..()

/datum/component/weaver/RegisterWithParent()
	RegisterSignal(parent, COMSIG_LIVING_LIFE, PROC_REF(process_component))

/datum/component/weaver/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_LIVING_LIFE))

/datum/component/weaver/proc/process_weaver_silk()
	if(silk_reserve < silk_max_reserve && silk_production == TRUE && owner.nutrition > 100)
		silk_reserve = min(silk_reserve + silk_generation_amount, silk_max_reserve)
		owner.adjust_nutrition(-(nutrtion_per_silk*silk_generation_amount))

/datum/component/weaver/proc/weave_item()
	var/choice
	var/datum/weaver_recipe/item/desired_result
	var/finalized = "No"

	while(finalized == "No" && owner.client)
		choice = tgui_input_list(owner,"What would you like to weave?", "Weave Choice", GLOB.all_weavable)
		desired_result = GLOB.all_weavable[choice]
		if(!desired_result || !istype(desired_result))
			return

		if(choice)
			finalized = tgui_alert(owner, "Are you sure you want to weave [desired_result.title]? It will cost you [desired_result.cost] silk.","Confirmation",list("Yes","No"))

	weave_check(desired_result.cost, desired_result.result_type)

//TGUI Weaver Panel
/datum/component/weaver/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WeaverConfig", "Weaver Config")
		ui.open()


/mob/living/proc/weaver_control_panel()
	set name = "Weaver Control Panel"
	set desc = "Allows you to adjust the settings of various weaver settings!"
	set category = "Abilities.Weaver"

	var/datum/component/weaver/weave = get_weaver_component()
	if(!weave)
		to_chat(src, span_warning("Only a weaver can use that!"))
		return FALSE

	weave.tgui_interact(src)

/mob/living/proc/get_weaver_component()
	var/datum/component/weaver/weave = GetComponent(/datum/component/weaver)
	if(weave)
		return weave

/datum/component/weaver/tgui_data(mob/user)
	var/data = list(
		"silk_reserve" = silk_reserve,
		"silk_max_reserve" = silk_max_reserve,
		"silk_color" = silk_color,
		"silk_production" = silk_production,
		"savefile_selected" = correct_savefile_selected()
	)

	return data

/datum/component/weaver/tgui_close(mob/user)
	SScharacter_setup.queue_preferences_save(user?.client?.prefs)
	. = ..()

/datum/component/weaver/proc/correct_savefile_selected()
	if(owner.client.prefs.default_slot == owner.mind.loaded_from_slot)
		return TRUE
	return FALSE

/datum/component/weaver/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("new_silk_color")
			var/set_new_color = tgui_color_picker(ui.user, "Select a color you wish your silk to be!", "Color Selector", silk_color)
			if(!set_new_color)
				return FALSE
			silk_color = set_new_color
			return TRUE
		if("toggle_silk_production")
			silk_production = !(silk_production)
			to_chat(owner, span_info("You are [silk_production ? "now" : "no longer"] producing silk."))
			return FALSE
		if("check_silk_amount")
			to_chat(owner, span_info("Your silk reserves are at [silk_reserve]/[silk_max_reserve]."))
			return FALSE
		/* //Unused.
		if("weave_item") //The global list of items.
			weave_item()
			return TRUE
		*/
		if("weave_binding")
			weave_check(50, /obj/item/clothing/suit/weaversilk_bindings)
			return TRUE
		if("weave_floor")
			weave_check(25, /obj/effect/weaversilk/floor)
			return TRUE
		if("weave_wall")
			weave_check(100, /obj/effect/weaversilk/wall)
			return TRUE
		if("weave_nest")
			weave_check(100, /obj/structure/bed/double/weaversilk_nest)
			return TRUE
		if("weave_trap")
			weave_check(250, /obj/effect/weaversilk/trap)
			return TRUE
/*
 * Checks to see if we can create the object
*/
/datum/component/weaver/proc/weave_check(cost, weaved_object)
	if(cost > silk_reserve)
		to_chat(owner, span_warning("You don't have enough silk to weave that!"))
		return

	if(owner.stat)
		to_chat(owner, span_warning("You can't do that in your current state!"))
		return

	if(!isturf(owner.loc))
		to_chat(owner, span_warning("You can't weave here!"))
		return

	if(locate(weaved_object) in owner.loc)
		to_chat(owner, span_warning("You can't create another one in the same tile here!"))
		return

	if(do_after(owner, ((cost/25) SECONDS), target = owner))
		if(cost > silk_reserve)
			to_chat(owner, span_warning("You don't have enough silk to weave that!"))
			return

		if(!isturf(owner.loc))
			to_chat(owner, span_warning("You can't weave here!"))
			return

		if(locate(weaved_object) in owner.loc)
			to_chat(owner, span_warning("You can't create another one in the same tile!"))
			return

		silk_reserve = max(silk_reserve - cost, 0)
		var/atom/object = new weaved_object(owner.loc)
		object.color = silk_color
		return
