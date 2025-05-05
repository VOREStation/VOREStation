
/datum/component/weaver
	var/silk_reserve = 100
	var/silk_max_reserve = 500
	var/silk_color = "#FFFFFF"
	var/silk_production = FALSE
	var/silk_generation_amount = 2
	var/nutrtion_per_silk = 0.2

	var/mob/living/owner

/datum/component/weaver/Initialize()

	if (!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent

	add_verb(owner, /mob/living/proc/check_silk_amount)
	add_verb(owner, /mob/living/proc/toggle_silk_production)
	add_verb(owner, /mob/living/proc/weave_structure)
	add_verb(owner, /mob/living/proc/weave_item)
	add_verb(owner, /mob/living/proc/set_silk_color)

	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process))

/datum/component/weaver/process()
	if (QDELETED(parent))
		return
	process_weaver_silk()

/datum/component/weaver/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE) //IF we registered a signal, we need to unregister it.
	remove_verb(owner, /mob/living/proc/check_silk_amount)
	remove_verb(owner, /mob/living/proc/toggle_silk_production)
	remove_verb(owner, /mob/living/proc/weave_structure)
	remove_verb(owner, /mob/living/proc/weave_item)
	remove_verb(owner, /mob/living/proc/set_silk_color)
	owner = null
	..()

/datum/component/weaver/proc/process_weaver_silk()
	if(silk_reserve < silk_max_reserve && silk_production == TRUE && owner.nutrition > 100)
		silk_reserve = min(silk_reserve + silk_generation_amount, silk_max_reserve)
		owner.adjust_nutrition(-(nutrtion_per_silk*silk_generation_amount))


/mob/living/proc/check_silk_amount()
	set name = "Check Silk Amount"
	set category = "Abilities.Weaver"
	var/datum/component/weaver/W = GetComponent(/datum/component/weaver)
	if(!W)
		return
	to_chat(src, "Your silk reserves are at [W.silk_reserve]/[W.silk_max_reserve].")

/mob/living/proc/toggle_silk_production()
	set name = "Toggle Silk Production"
	set category = "Abilities.Weaver"
	var/datum/component/weaver/W = GetComponent(/datum/component/weaver)
	if(!W)
		return
	W.silk_production = !(W.silk_production)
	to_chat(src, "You are [W.silk_production ? "now" : "no longer"] producing silk.")

/mob/living/proc/weave_structure()
	set name = "Weave Structure"
	set category = "Abilities.Weaver"

	var/choice
	var/datum/weaver_recipe/structure/desired_result
	var/finalized = "No"
	var/datum/component/weaver/W = GetComponent(/datum/component/weaver)
	if(!W)
		return

	while(finalized == "No" && client)
		choice = tgui_input_list(src,"What would you like to weave?", "Weave Choice", GLOB.weavable_structures)
		desired_result  = GLOB.weavable_structures[choice]
		if(!desired_result || !istype(desired_result))
			return

		if(choice)
			finalized = tgui_alert(src, "Are you sure you want to weave [desired_result.title]? It will cost you [desired_result.cost] silk.","Confirmation",list("Yes","No"))

	if(!desired_result || !istype(desired_result))
		return

	if(desired_result.cost > W.silk_reserve)
		to_chat(src, span_warning("You don't have enough silk to weave that!"))
		return

	if(stat)
		to_chat(src, span_warning("You can't do that in your current state!"))
		return

	if(locate(desired_result.result_type) in src.loc)
		to_chat(src, span_warning("You can't create another weaversilk [desired_result.title] here!"))
		return

	if(!isturf(src.loc))
		to_chat(src, span_warning("You can't weave here!"))
		return

	if(do_after(src, desired_result.time, exclusive = TASK_USER_EXCLUSIVE))
		if(desired_result.cost > W.silk_reserve)
			to_chat(src, span_warning("You don't have enough silk to weave that!"))
			return

		if(locate(desired_result.result_type) in src.loc)
			to_chat(src, span_warning("You can't create another weaversilk [desired_result.title] here!"))
			return

		if(!isturf(src.loc))
			to_chat(src, span_warning("You can't weave here!"))
			return

		W.silk_reserve = max(W.silk_reserve - desired_result.cost, 0)

		var/atom/O = new desired_result.result_type(src.loc)
		O.color = W.silk_color


/mob/living/proc/weave_item()
	set name = "Weave Item"
	set category = "Abilities.Weaver"
	var/choice
	var/datum/weaver_recipe/item/desired_result
	var/finalized = "No"
	var/datum/component/weaver/W = GetComponent(/datum/component/weaver)
	if(!W)
		return
	while(finalized == "No" && client)
		choice = tgui_input_list(src,"What would you like to weave?", "Weave Choice", GLOB.weavable_items)
		desired_result  = GLOB.weavable_items[choice]
		if(!desired_result || !istype(desired_result))
			return

		if(choice)
			finalized = tgui_alert(src, "Are you sure you want to weave [desired_result.title]? It will cost you [desired_result.cost] silk.","Confirmation",list("Yes","No"))

	if(!desired_result || !istype(desired_result))
		return

	if(desired_result.cost > W.silk_reserve)
		to_chat(src, span_warning("You don't have enough silk to weave that!"))
		return

	if(stat)
		to_chat(src, span_warning("You can't do that in your current state!"))
		return

	if(!isturf(src.loc))
		to_chat(src, span_warning("You can't weave here!"))
		return

	if(do_after(src, desired_result.time, exclusive = TASK_USER_EXCLUSIVE))
		if(desired_result.cost > W.silk_reserve)
			to_chat(src, span_warning("You don't have enough silk to weave that!"))
			return

		if(!isturf(src.loc))
			to_chat(src, span_warning("You can't weave here!"))
			return

		W.silk_reserve = max(W.silk_reserve - desired_result.cost, 0)

		var/atom/O = new desired_result.result_type(src.loc)
		O.color = W.silk_color

/mob/living/proc/set_silk_color()
	set name = "Set Silk Color"
	set category = "Abilities.Weaver"
	var/datum/component/weaver/W = GetComponent(/datum/component/weaver)
	if(!W)
		return
	var/new_silk_color = tgui_color_picker(src, "Pick a color for your woven products:","Silk Color", W.silk_color)
	if(new_silk_color)
		W.silk_color = new_silk_color
