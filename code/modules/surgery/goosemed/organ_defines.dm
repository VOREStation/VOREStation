/obj/item/organ
	// The list of wounds actively affecting this organ.
	var/list/wounds = list()

	// Volume of the internal blood reservoir.
	var/volume = 100

	// The amount of blood requested from the body's bloodstream per Life() tick.
	var/blood_per_tick = 20

/obj/item/organ/Initialize()
	. = ..()
	create_reagents(volume)

// Not actually enqueued with a subsystem, but called from a mob's Life() code.
/obj/item/organ/process()
	if(!istype(owner))
		return

	// Fetch some amount of reagents from the body's central bloodstream,
	// and store them in the local reservoir.
	request_blood()
	process_blood()
	process_wounds()
	return_blood()
	return

/obj/item/organ/proc/request_blood()
	var/bloodstream_filled_percent
	// Request an amount based on the total amount in the body's central reservoir at the start of the life tick, rather than what it has instantaneously
	// Other organs may've already drained some.

/obj/item/organ/proc/process_blood()
	// Do we have enough blood? If not, organ damage
	
	// For each reagent in our blood, process its effects upon the organ, for weal or for woe

	// Consume some blood

	// Eat some nutriment

/obj/item/organ/proc/return_blood()


/obj/item/organ/external/process_blood()	
	// Create some blood, because we have BONES

	return ..()

/obj/item/organ/external/proc/process_touch()

/obj/item/organ/internal/lung/proc/process()
	// Move some reagents to the blood

	return ..()
	
/obj/item/organ/internal/stomach/process()
	// Move some reagents to the intestine

	return ..()




/mob/living/human/proc/handle_organs()
	var/blood_fill_percent	


	var/force_process = recheck_bad_external_organs()

	if(force_process)
		bad_external_organs.Cut()
		for(var/obj/item/organ/external/Ex in organs)
			bad_external_organs |= Ex

	//processing internal organs is pretty cheap, do that first.
	for(var/obj/item/organ/I in internal_organs)
		I.process()

	handle_stance()
	handle_grasp()

	if(!force_process && !bad_external_organs.len)
		return

	for(var/obj/item/organ/external/E in bad_external_organs)
		if(!E)
			continue
		if(!E.need_process())
			bad_external_organs -= E
			continue
		else
			E.process()

			if (!lying && !buckled && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (prob(10) && !stat && can_feel_pain() && chem_effects[CE_PAINKILLER] < 50 && E.is_broken() && E.internal_organs.len)
					custom_pain("Pain jolts through your broken [E.encased ? E.encased : E.name], staggering you!", 50)
					drop_item(loc)
					Stun(2)

				//Moving makes open wounds get infected much faster
				if (E.wounds.len)
					for(var/datum/wound/W in E.wounds)
						if (W.infection_check())
							W.germ_level += 1



/**
 * Proc: get_surgery_steps
 * Fetches the list of surgery steps available from the current position in the surgery tree
 * If a tool is supplied, only those steps possible with that tool will be returned.
 * @param: tool - Optional. Filters returned steps by tool qualities on the tool
 * @return: The list of surgery steps possible from the current step.
**/
/obj/item/organ/proc/get_available_surgery_steps(var/obj/item/tool)
	// This organ doesn't support surgery or has gotten into an invalid state
	if(!LAZYLEN(surgery_map[surgery_current_step]))
		return list()
	var/list/options = list()
	for(var/list/L in surgery_map[surgery_current_step])
		if(!istype(L[1], /decl/surgery))
			crash_with("Error: uninitialized surgery step [L[1]][L.len > 1 ? ", [L[2]]" : ""]")		
		if(!L[1].check_tool(tool))
			continue
		
		// Enforce key uniqueness
		if(istype(options[S.name], /decl/surgery))
			crash_with("Error: multiple surgery steps with name [S.name] inherit from [src]:[surgery_current_step.name]!")
		
		options[S.name] = L
	return options


/**
 * Proc: do_surgery
 * Checks if any surgery steps for this organ are possible for the tool.
 * If so, generates a radial menu for the user to select one to perform.
 * @param: tool - The object being wielded by \
 * @param: user - The person doing the surgery
 * @returns: True if surgery is possible (Stops attack logic), false otherwise.
 *           The radial menu is asynchronous behind a spawn() to avoid blocking further logic.
**/
/obj/item/organ/proc/do_surgery(var/obj/item/tool, var/mob/living/user)
	if(!istype(tool))
		return FALSE

	var/list/options = get_available_surgery_steps(tool)
	if(choices.len)
		// Maps the options to the input for the radial. Both lists have the same unique keys.
		var/list/radial_choices = list()
		for(var/key in options)
			radial_choices[key] = options[key][1].radial_image

		// Decouples radial menu from attackcode to avoid blocking player input
		spawn(0)
			// Do the radial
			var/choice = show_radial_menu(user, owner ? owner : src, radial_choices, require_near = TRUE, tooltips = TRUE)
			if(istype(options[choice][1], /decl/surgery) && options[choice][1].check_tool(src))
				// Do the surgery. If it succeeds, update surgery step
				if(options[choice][1].operate(tool, src, user))
					surgery_current_step = options[choice][2]
			return // Inside spawn, nothing should expect this
		return TRUE
	return FALSE



/*
Generic:
ROOT_BIO
/	Start incision: scalpel
/W		Clamp Bleeders: Hemostat
/W			Open Incision: Retractor
/W					Cauterise Incision: Cautery -> ROOT_BIO
/W					Glue Bone: Bonegel // Track with modifiers!
/W						Set Bone: Bonesetter
/						Back: [] -> Open Incision (Bad)
/W							Fix Bone: Bonegel -> Open Incision
/							Back: [] -> Open Incision (Bad)
/W					Magic Bone: Boneclamp
/W ENCASED				Saw Ribs: Circular Saw // Track with modifiers!
/W						Open Ribs: Retractor
/W							Close Ribs: Retractor -> Open Incision
/W 							Mend Ribs: Bonegel
/W ENCASED				Magic Ribs: Advanced Saw -> Open Ribs
/W					IB: FixOVein
/W					Necrosis Debridement: Scalpel // Track with modifiers!
/W						Necrosis Treatment: Beaker (Peri)
					Scan Injury: Autopsy Scanner
					Mend Brute: Brute Kit
					Mend Burn: Burn Kit
					Mend Organs: Brute Kit (Select organ through radial)
/W					Detach Organ: Scalpel // Track with modifiers!
/						Back: [] -> Open Incision (Bad)
/W						Remove Organ: Hemostat
/W					Insert Organ: Organ // Track with modifiers!
/W						Attach Organ: FixOVein
MOUTH				Mend/Break Face: Brute Kit, Burn Kit, Scalpel?
HEAD				Mend Skull: Bonesetter (?)
HEAD,TORSO,GROIN	Open Cavity: Surgical Drill // Track with modifiers!
						Close Cavity: Cautery -> Open Incision
						Implant Item: Item
						Remove Item: Hemostat
HEAD				Mend Brainstem: FixOVein // What does this do? Resets defib timer, Frankenstein // Track with modifiers!
						Drill Vertebrae: Bonedrill
							Clean Bonechips: Hemostat
								Mend Spinal Cord: FixOVein
									Repair Vertebrae: Boneglue
										Realign Tissue: Hemostat

	Cauterise Bleeding: Cautery

/	Steal Organ: The Ripper
/	Bloodless Incision: Laser Scalpel -> Clamp Bleeders
/	Incision Management: IMS -> Open Incision
/	Amputate: Circular Saw
/W?	Limb Attach: Limb // Track with modifiers!
/W		Limb Connect: Hemostat
/W?	Mechanize: Robot Part (Borg part analog to Limb Attach)
/	Hardsuit Removal: Circular Saw

MOUTH (Custom Text, mostly. Fixes disfigured face)
	Cut Face: Scalpel
		Clamp Face: Hemostat	
			Open Face: Retractor -> Open Incision
				Fix Face: Cautery -> ROOT_BIO


ROOT_ROBOT
	Unscrew Hatch: Screwdriver
		Screw Hatch: Screwdriver -> ROOT_ROBOT
		Open Hatch: Crowbar
			Close Hatch: Crowbar -> Unscrew Hatch
			Mend Dents: Welder
			Mend Burn: Cable Coil
			Mend Organ: Nanopaste
			Detach Organ: Multitool
			Attach Organ: Organ (Robotic)
HEAD		Insert MMI: MMI/Brain
HEAD		Nymph Mech: Nymph			



****************************************************************************************************************************


ORGAN
	var/list/surgeries = list(
// Misc high-level crap
		SURGERY_UNIVERSAL = list(
			steal_organ: The Ripper -> Creates bleeding wound
			amputate_limb: Circular Saw -> Removes child organ, creates bleeding gouge wound

		MISSING_CHILD_ORGAN = list(
			Limb Attach: Limb -> Adds attached limb wound
			Mechanize: Robot Part -> Adds attached limb wound //  Borg part analog to Limb Attach

		ATTACHED_CHILD_ORGAN = list(
			limb_connect: Hemostat -> Closes attached limb wound (Limb starts working)

		SURGERY_OBSTRUCTED = list(
			Hardsuit Removal: Circular Saw // Heavy damage to whatever is blocking and/or unequips it

		SURGERY_IB = list(
			IB: FixOVein -> Clears IB wound

// Incisions
		SURGERY_NO_INCISION = list(
			start_incision: Scalpel -> Creates incision wound (Stage 0)
			bloodless_incision: Laser Scalpel -> Creates incision wound (Stage 1)
			open_incision: Incision Management System ->Creates incision wound (Stage 2)

		SURGERY_INCISION_0 = list(
			clamp_incision: Hemostat -> Upgrades incision wound (Stage 1)

		SURGERY_INCISION_1 = list(
			open_incision: Retractor -> Upgrades incision wound (Stage 2)

		SURGERY_INCISION_2 = list(
			cauterise_incision: Cautery -> Closes incision wound // Blocked by opened internals?
			cut_bone: Circular Saw -> Creates broken bone wound (Stage 2)
			


// Bone surgery
		SURGERY_BROKEN_BONE_0 = list(
			glue_bone: Bonegel -> Upgrades broken bone wound (Stage 1)
			fix_bone: Boneclamp -> Clears broken bone wound
		
		SURGERY_BROKEN_BONE_1 = list(
			set_bone: Bonesetter -> Upgrades broken bone wound (Stage 2)
			fix_bone: Boneclamp -> Clears broken bone wound

		SURGERY_BROKEN_BONE_2 = list(
			mend_bone: Bonegel -> Clears broken bone wound
			fix_bone: Boneclamp -> Clears broken bone wound
			pry_bone: Retractor -> Adds opened internals wound // Access to encased organs


// Encased
		SURGERY_LOCKED_INTERNALS = list(
			magic_bone: Advanced Saw -> Creates broken bone wound (Stage 2), opened internals wound

		// Locked behind encased, or just open incision
		SURGERY_OPENED_INTERNALS = list(
			restore_bone: Retractor -> Clears opened internals wound
			detach_organ: Scalpel -> Creates detached organ wound
			insert_organ: Organ -> Inserts Organ, creates detached organ wound
		
		SURGERY_DETACHED_ORGAN = list(
			attach_organ: FixOVein -> Clears detached organ wound
			remove_organ: Hemostat -> Removes Organ, clears detached organ wound


// Necrosis
		SURGERY_NECROSIS_0 = list(
			debride_necrosis: Scalpel -> Upgrades necrosis wound (Stage 1)
		
		SURGERY_NECROSIS_1 = list(
			clean_necrosis: Beaker (peri) -> Clears necrosis wound(?)
	

*/