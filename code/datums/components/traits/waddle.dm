/datum/component/waddle_trait
	var/atom/movable/our_atom
	var/mob/living/living_owner

	var/waddling = 1
	var/waddle_z = 4
	var/waddle_min = -12
	var/waddle_max = 12
	var/waddle_time = 2

/datum/component/waddle_trait/Initialize()
	if (!isobj(parent) && !ismob(parent))
		return COMPONENT_INCOMPATIBLE
	if(isliving(parent))
		living_owner = parent
		add_verb(living_owner, /mob/living/proc/waddle_adjust)
		//add_verb(living_owner, /mob/living/proc/waddle_debug)
	our_atom = parent
	RegisterSignal(our_atom, COMSIG_MOVABLE_MOVED, PROC_REF(handle_comp))

/datum/component/waddle_trait/proc/handle_comp()
	SIGNAL_HANDLER
	if (QDELETED(our_atom))
		return
	//Living owner only. No waddling while downed.
	if(living_owner)
		if(living_owner.stat != CONSCIOUS || living_owner.resting)
			return
	if(waddling)
		waddle_waddle(our_atom)

/datum/component/waddle_trait/Destroy(force = FALSE)
	UnregisterSignal(our_atom, COMSIG_MOVABLE_MOVED)
	if(living_owner)
		remove_verb(living_owner, /mob/living/proc/waddle_adjust)
		//remove_verb(living_owner, /mob/living/proc/waddle_debug)
	living_owner = null
	our_atom = null
	. = ..()

/mob/living/verb/toggle_waddle()
	set name = "Toggle or Enable Waddling"
	set desc = "Allows you to toggle if you want to walk with a waddle or not!"
	set category = "Preferences.Character"
	var/datum/component/waddle_trait/comp = LoadComponent(/datum/component/waddle_trait)
	if(comp)
		comp.waddling = !comp.waddling
		to_chat(src, span_warning("You will [ (comp.waddling) ? "now" : "no longer"] waddle."))

/mob/living/proc/waddle_debug() //Debug tool to debug waddling.
	set name = "WADDLE DEBUG"
	set desc = "Allows you to debug waddling!!"
	set category = "Preferences.Character"
	var/datum/component/waddle_trait/comp = GetComponent(/datum/component/waddle_trait)
	if(comp)
		var/Z = tgui_input_number(src,, "Desired Z.", "Set Z", 0.5)
		comp.waddle_z = Z
		var/min = tgui_input_number(src, "Desired min.", "Set min", -4)
		comp.waddle_min = min
		var/max = tgui_input_number(src, "Desired max.", "Set max", 4)
		comp.waddle_max = max
		var/time = tgui_input_number(src, "Desired time.", "Set time", 2)
		comp.waddle_time = time
		to_chat(src, "z = [Z] min = [min] max = [max] time = [time]")

/mob/living/proc/waddle_adjust()
	set name = "Waddle Adjust"
	set desc = "Allows you to adjust your waddling."
	set category = "Preferences.Character"
	var/datum/component/waddle_trait/comp = GetComponent(/datum/component/waddle_trait)
	if(comp)
		var/Z_height = tgui_input_number(src, "Put the desired waddle height. (5 is default. 0 min 40 max)", "Set Height", 5, 40, 0)
		Z_height = Z_height/10 //Clear numbers
		if(Z_height > 4 || Z_height < 0 )
			to_chat(src, span_notice("Invalid height!"))
			return
		comp.waddle_z = Z_height

		var/min = tgui_input_number(src, "Put the desired waddle backwards lean. (4 is default. 0 min, 12 max)", "Set Back Lean", 4, 12, 0)
		if(min > 12 || min < 0 )
			to_chat(src, span_notice("Invalid number!"))
			return
		comp.waddle_min = -min

		var/max = tgui_input_number(src, "Put the desired waddle forwards lean. (4 is default. 0 min, 12 max)", "Set Forwards Lean", 4, 12, 0)
		if(max > 12 || max < 0 )
			to_chat(src, span_notice("Invalid number!"))
			return
		comp.waddle_max = max

		var/time = tgui_input_number(src, "Put the desired waddle animation time. (20 is default. 10 min, 20 max)", "Set Time", 20, 20, 10)
		time = time/10 //Clear numbers
		if(time > 2 || time < 1 )
			to_chat(src, span_notice("Invalid number!"))
			return
		comp.waddle_time = time
		to_chat(src, span_notice("You have set your waddle height to [comp.waddle_z*10], your back lean to [comp.waddle_min], your forward lean to [comp.waddle_max] and your waddle time to [comp.waddle_time*10]! You will now waddle!"))
		comp.waddling = 1 //Activate it!

/datum/component/waddle_trait/proc/waddle_waddle(atom/movable/target)
	var/prev_pixel_z = our_atom.pixel_z

	animate(target, pixel_z = target.pixel_z + waddle_z, time = 0)
	var/prev_transform = target.transform //The person's default state.
	animate(pixel_z = prev_pixel_z, transform = turn(target.transform, pick(waddle_min, 0, waddle_max)), time=waddle_time)
	animate(transform = prev_transform, time = 0)
