/*
 * Arm mounted augments.
 */

/obj/item/organ/internal/augment/armmounted
	name = "laser rifle implant"
	desc = "A large implant that fits into a subject's arm. It deploys a laser-emitting array by some painful means."

	icon_state = "augment_laser"

	w_class = ITEMSIZE_LARGE

	organ_tag = O_AUG_L_FOREARM

	parent_organ = BP_L_ARM

	target_slot = slot_l_hand

	target_parent_classes = list(ORGAN_FLESH, ORGAN_ASSISTED)

	integrated_object_type = /obj/item/gun/energy/laser/mounted/augment

/obj/item/organ/internal/augment/armmounted/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		switch(organ_tag)
			if(O_AUG_L_FOREARM)
				organ_tag = O_AUG_R_FOREARM
				parent_organ = BP_R_ARM
				target_slot = slot_r_hand
			if(O_AUG_R_FOREARM)
				organ_tag = O_AUG_L_FOREARM
				parent_organ = BP_L_ARM
				target_slot = slot_l_hand
		to_chat(user, "<span class='notice'>You swap \the [src]'s servos to install neatly into \the lower [parent_organ] mount.</span>")
		return

	. = ..()

/obj/item/organ/internal/augment/armmounted/taser
	name = "taser implant"
	desc = "A large implant that fits into a subject's arm. It deploys a taser-emitting array by some painful means."

	icon_state = "augment_taser"

	integrated_object_type = /obj/item/gun/energy/taser/mounted/augment

/obj/item/organ/internal/augment/armmounted/dartbow
	name = "crossbow implant"
	desc = "A small implant that fits into a subject's arm. It deploys a dart launching mechanism through the flesh through unknown means."

	icon_state = "augment_dart"

	w_class = ITEMSIZE_SMALL

	integrated_object_type = /obj/item/gun/energy/crossbow

// Wrist-or-hand-mounted implant

/obj/item/organ/internal/augment/armmounted/hand
	name = "resonant analyzer implant"
	desc = "An augment that fits neatly into the hand, useful for determining the usefulness of an object for research."
	icon_state = "augment_box"

	w_class = ITEMSIZE_SMALL

	integrated_object_type = /obj/item/portable_scanner

/obj/item/organ/internal/augment/armmounted/hand/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		switch(organ_tag)
			if(O_AUG_L_HAND)
				organ_tag = O_AUG_R_HAND
				parent_organ = BP_R_HAND
				target_slot = slot_r_hand
			if(O_AUG_R_HAND)
				organ_tag = O_AUG_L_HAND
				parent_organ = BP_L_HAND
				target_slot = slot_l_hand
		to_chat(user, "<span class='notice'>You swap \the [src]'s servos to install neatly into \the upper [parent_organ] mount.</span>")
		return

	. = ..()

/obj/item/organ/internal/augment/armmounted/hand/sword
	name = "energy blade implant"

	integrated_object_type = /obj/item/melee/energy/sword

/obj/item/organ/internal/augment/armmounted/hand/blade
	name = "handblade implant"
	desc = "A small implant that fits neatly into the hand. It deploys a small, but dangerous blade."
	icon_state = "augment_handblade"

	integrated_object_type = /obj/item/melee/augment/blade

/*
 * Shoulder augment.
 */

/obj/item/organ/internal/augment/armmounted/shoulder
	name = "shoulder augment"
	desc = "A large implant that fits into a subject's arm. It looks kind of like a skeleton."

	icon_state = "augment_armframe"

	organ_tag = O_AUG_R_UPPERARM

	w_class = ITEMSIZE_HUGE

	integrated_object_type = null

/obj/item/organ/internal/augment/armmounted/shoulder/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		switch(organ_tag)
			if(O_AUG_L_UPPERARM)
				organ_tag = O_AUG_R_UPPERARM
				parent_organ = BP_R_ARM
				target_slot = slot_r_hand
			if(O_AUG_R_UPPERARM)
				organ_tag = O_AUG_L_UPPERARM
				parent_organ = BP_L_ARM
				target_slot = slot_l_hand
		to_chat(user, "<span class='notice'>You swap \the [src]'s servos to install neatly into \the upper [parent_organ] mount.</span>")
		return

	. = ..()

/obj/item/organ/internal/augment/armmounted/shoulder/surge
	name = "muscle overclocker"

	aug_cooldown = 1.5 MINUTES

/obj/item/organ/internal/augment/armmounted/shoulder/surge/augment_action()
	if(!owner)
		return

	if(aug_cooldown)
		if(cooldown <= world.time)
			cooldown = world.time + aug_cooldown
		else
			return

	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		H.add_modifier(/datum/modifier/melee_surge, 0.75 MINUTES)

/obj/item/organ/internal/augment/armmounted/shoulder/blade
	name = "armblade implant"
	desc = "A large implant that fits into a subject's arm. It deploys a large metal blade by some painful means."

	icon_state = "augment_armblade"

	integrated_object_type = /obj/item/melee/augment/blade/arm

// The toolkit / multi-tool implant.

/obj/item/organ/internal/augment/armmounted/shoulder/multiple
	name = "rotary toolkit"
	desc = "A large implant that fits into a subject's arm. It deploys an array of tools by some painful means."

	icon_state = "augment_toolkit"

	organ_tag = O_AUG_R_UPPERARM

	w_class = ITEMSIZE_HUGE

	integrated_object_type = null

	toolspeed = 0.8

	var/list/integrated_tools = list(
		/obj/item/tool/screwdriver = null,
		/obj/item/tool/wrench = null,
		/obj/item/tool/crowbar = null,
		/obj/item/tool/wirecutters = null,
		/obj/item/multitool = null,
		/obj/item/stack/cable_coil/gray = null,
		/obj/item/tape_roll = null
		)

	var/list/integrated_tools_by_name

	var/list/integrated_tool_images

	var/list/synths

	var/list/synth_types = list(
		/datum/matter_synth/wire
		)

/obj/item/organ/internal/augment/armmounted/shoulder/multiple/Initialize()
	. = ..()

	if(integrated_object)
		integrated_tools[integrated_object_type] = integrated_object

	if(integrated_tools && integrated_tools.len)

		integrated_tools_by_name = list()

		integrated_tool_images = list()

		if(synth_types)
			synths = list()
			for(var/datumpath in synth_types)
				var/datum/matter_synth/MS = new datumpath
				synths += MS

		for(var/path in integrated_tools)
			if(!integrated_tools[path])
				integrated_tools[path] = new path(src)
			var/obj/item/I = integrated_tools[path]
			I.canremove = FALSE
			I.toolspeed = toolspeed
			I.my_augment = src
			I.name = "integrated [I.name]"

		for(var/tool in integrated_tools)
			var/obj/item/Tool = integrated_tools[tool]
			if(istype(Tool, /obj/item/stack))
				var/obj/item/stack/S = Tool
				S.synths = synths
				S.uses_charge = synths.len
			integrated_tools_by_name[Tool.name] = Tool
			integrated_tool_images[Tool.name] = image(icon = Tool.icon, icon_state = Tool.icon_state)

/obj/item/organ/internal/augment/armmounted/shoulder/multiple/handle_organ_proc_special()
	..()

	if(!owner || is_bruised() || !synths)
		return

	if(prob(20))
		for(var/datum/matter_synth/MS in synths)
			MS.add_charge(MS.recharge_rate)

/obj/item/organ/internal/augment/armmounted/shoulder/multiple/augment_action()
	if(!owner)
		return

	var/list/options = list()

	for(var/Iname in integrated_tools_by_name)
		options[Iname] = integrated_tool_images[Iname]

	var/list/choice = list()
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(owner, owner, options)

	integrated_object = integrated_tools_by_name[choice]

	..()

/obj/item/organ/internal/augment/armmounted/shoulder/multiple/medical
	name = "rotary medical kit"
	icon_state = "augment_medkit"
	integrated_object_type = null

	integrated_tools = list(
		/obj/item/surgical/hemostat = null,
		/obj/item/surgical/retractor = null,
		/obj/item/surgical/cautery = null,
		/obj/item/surgical/surgicaldrill = null,
		/obj/item/surgical/scalpel = null,
		/obj/item/surgical/circular_saw = null,
		/obj/item/surgical/bonegel = null,
		/obj/item/surgical/FixOVein = null,
		/obj/item/surgical/bonesetter = null,
		/obj/item/stack/medical/crude_pack = null
		)

	synth_types = list(
		/datum/matter_synth/bandage
		)
