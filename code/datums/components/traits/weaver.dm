
/datum/component/weaver
	var/silk_reserve = 100
	var/silk_max_reserve = 500
	var/silk_color = "#FFFFFF"
	var/silk_production = FALSE
	var/silk_generation_amount = 2
	var/nutrtion_per_silk = 0.2

	var/mob/living/carbon/human/owner

/datum/component/weaver/Initialize()

	if (!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	owner = parent

	add_verb(owner, /datum/component/weaver/proc/check_silk_amount)
	add_verb(owner, /datum/component/weaver/proc/toggle_silk_production)
	add_verb(owner, /datum/component/weaver/proc/weave_structure)
	add_verb(owner, /datum/component/weaver/proc/weave_item)
	add_verb(owner, /datum/component/weaver/proc/set_silk_color)

	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process))

/datum/component/weaver/process()
	if (QDELETED(parent))
		return
	process_weaver_silk() //Add one energy per tick, up to 100

/datum/component/weaver/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE) //IF we registered a signal, we need to unregister it.
	owner = null //MAKE SURE TO CLEAR YOUR REFS!
	..()

/datum/component/weaver/proc/process_weaver_silk()
	if(silk_reserve < silk_max_reserve && silk_production == TRUE && owner.nutrition > 100)
		silk_reserve = min(silk_reserve + silk_generation_amount, silk_max_reserve)
		owner.adjust_nutrition(-(nutrtion_per_silk*silk_generation_amount))


/datum/component/weaver/proc/check_silk_amount()
	set name = "Check Silk Amount"
	set category = "Abilities.Weaver"
	to_chat(owner, "Your silk reserves are at [silk_reserve]/[silk_max_reserve].")

/datum/component/weaver/proc/toggle_silk_production()
	set name = "Toggle Silk Production"
	set category = "Abilities.Weaver"
	silk_production = !(silk_production)
	to_chat(owner, "You are [silk_production ? "now" : "no longer"] producing silk.")

/datum/component/weaver/proc/weave_structure()
	set name = "Weave Structure"
	set category = "Abilities.Weaver"

	var/choice
	var/datum/weaver_recipe/structure/desired_result
	var/finalized = "No"

	while(finalized == "No" && owner.client)
		choice = tgui_input_list(owner,"What would you like to weave?", "Weave Choice", GLOB.weavable_structures)
		desired_result  = GLOB.weavable_structures[choice]
		if(!desired_result || !istype(desired_result))
			return

		if(choice)
			finalized = tgui_alert(owner, "Are you sure you want to weave [desired_result.title]? It will cost you [desired_result.cost] silk.","Confirmation",list("Yes","No"))

	if(!desired_result || !istype(desired_result))
		return

	if(desired_result.cost > silk_reserve)
		to_chat(owner, span_warning("You don't have enough silk to weave that!"))
		return

	if(owner.stat)
		to_chat(owner, span_warning("You can't do that in your current state!"))
		return

	if(locate(desired_result.result_type) in owner.loc)
		to_chat(owner, span_warning("You can't create another weaversilk [desired_result.title] here!"))
		return

	if(!isturf(owner.loc))
		to_chat(owner, span_warning("You can't weave here!"))
		return

	if(do_after(owner, desired_result.time, exclusive = TASK_USER_EXCLUSIVE))
		if(desired_result.cost > silk_reserve)
			to_chat(owner, span_warning("You don't have enough silk to weave that!"))
			return

		if(locate(desired_result.result_type) in owner.loc)
			to_chat(owner, span_warning("You can't create another weaversilk [desired_result.title] here!"))
			return

		if(!isturf(owner.loc))
			to_chat(owner, span_warning("You can't weave here!"))
			return

		silk_reserve = max(silk_reserve - desired_result.cost, 0)

		var/atom/O = new desired_result.result_type(owner.loc)
		O.color = silk_color


/datum/component/weaver/proc/weave_item()
	set name = "Weave Item"
	set category = "Abilities.Weaver"
	var/choice
	var/datum/weaver_recipe/item/desired_result
	var/finalized = "No"

	while(finalized == "No" && owner.client)
		choice = tgui_input_list(owner,"What would you like to weave?", "Weave Choice", GLOB.weavable_items)
		desired_result  = GLOB.weavable_items[choice]
		if(!desired_result || !istype(desired_result))
			return

		if(choice)
			finalized = tgui_alert(owner, "Are you sure you want to weave [desired_result.title]? It will cost you [desired_result.cost] silk.","Confirmation",list("Yes","No"))

	if(!desired_result || !istype(desired_result))
		return

	if(desired_result.cost > silk_reserve)
		to_chat(owner, span_warning("You don't have enough silk to weave that!"))
		return

	if(owner.stat)
		to_chat(owner, span_warning("You can't do that in your current state!"))
		return

	if(!isturf(owner.loc))
		to_chat(owner, span_warning("You can't weave here!"))
		return

	if(do_after(owner, desired_result.time, exclusive = TASK_USER_EXCLUSIVE))
		if(desired_result.cost > 	silk_reserve)
			to_chat(owner, span_warning("You don't have enough silk to weave that!"))
			return

		if(!isturf(owner.loc))
			to_chat(owner, span_warning("You can't weave here!"))
			return

		silk_reserve = max(silk_reserve - desired_result.cost, 0)

		var/atom/O = new desired_result.result_type(owner.loc)
		O.color = silk_color

/datum/component/weaver/proc/set_silk_color()
	set name = "Set Silk Color"
	set category = "Abilities.Weaver"

	var/new_silk_color = tgui_color_picker(owner, "Pick a color for your woven products:","Silk Color", silk_color)
	if(new_silk_color)
		silk_color = new_silk_color
