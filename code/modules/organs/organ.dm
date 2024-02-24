var/list/organ_cache = list()

/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0
	drop_sound = 'sound/items/drop/flesh.ogg'
	pickup_sound = 'sound/items/pickup/flesh.ogg'

	// Strings.
	var/organ_tag = "organ"				// Unique identifier.
	var/parent_organ = BP_TORSO			// Organ holding this object.

	// Status tracking.
	var/status = 0						// Various status flags
	var/vital							// Lose a vital limb, die immediately.
	var/damage = 0						// Current damage to the organ
	var/robotic = 0
	var/stapled_nerves = FALSE

	// Reference data.
	var/mob/living/carbon/human/owner	// Current mob owning the organ.
	var/list/transplant_data			// Transplant match data.
	var/list/autopsy_data = list()		// Trauma data for forensics.
	var/list/trace_chemicals = list()	// Traces of chemicals in the organ.
	var/datum/dna/dna					// Original DNA.
	var/datum/species/species			// Original species.

	// Damage vars.
	var/min_bruised_damage = 10			// Damage before considered bruised
	var/min_broken_damage = 30			// Damage before becoming broken
	var/max_damage						// Damage cap
	var/can_reject = 1					// Can this organ reject?
	var/rejecting						// Is this organ already being rejected?
	var/decays = TRUE					// Can this organ decay at all?
	var/preserved = 0					// If this is 1, prevents organ decay.

	// Language vars. Putting them here in case we decide to do something crazy with sign-or-other-nonverbal languages.
	var/list/will_assist_languages = list()
	var/list/datum/language/assists_languages = list()

	// Organ verb vars.
	var/list/organ_verbs		// Verbs added by the organ when present in the body.
	var/list/target_parent_classes = list()	// Is the parent supposed to be organic, robotic, assisted?
	var/forgiving_class = TRUE	// Will the organ give its verbs when it isn't a perfect match? I.E., assisted in organic, synthetic in organic.

	var/butcherable = TRUE
	var/meat_type	// What does butchering, if possible, make?

/obj/item/organ/Destroy()

	handle_organ_mod_special(TRUE)
	if(owner)           owner = null
	if(transplant_data) transplant_data.Cut()
	if(autopsy_data)    autopsy_data.Cut()
	if(trace_chemicals) trace_chemicals.Cut()
	dna = null
	species = null

	return ..()

/obj/item/organ/proc/update_health()
	return

/obj/item/organ/New(var/mob/living/holder, var/internal)
	..(holder)
	create_reagents(5)

	if(isliving(holder))
		src.owner = holder
		src.w_class = max(src.w_class + mob_size_difference(holder.mob_size, MOB_MEDIUM), 1) //smaller mobs have smaller organs.
		if(internal)
			if(!LAZYLEN(holder.internal_organs))
				holder.internal_organs = list()
			if(!LAZYLEN(holder.internal_organs_by_name))
				holder.internal_organs_by_name = list()

			holder.internal_organs |= src
			holder.internal_organs_by_name[organ_tag] = src

		else
			if(!LAZYLEN(holder.organs))
				holder.organs = list()
			if(!LAZYLEN(holder.organs_by_name))
				holder.organs_by_name = list()

			holder.organs |= src
			holder.organs_by_name[organ_tag] = src

	if(!max_damage)
		max_damage = min_broken_damage * 2
	if(iscarbon(holder))
		var/mob/living/carbon/C = holder
		species = GLOB.all_species[SPECIES_HUMAN]
		if(holder.dna)
			dna = C.dna.Clone()
			species = C.species //VOREStation Edit - For custom species
		else
			log_debug("[src] at [loc] spawned without a proper DNA.")
		var/mob/living/carbon/human/H = C
		if(istype(H))
			if(internal)
				var/obj/item/organ/external/E = H.get_organ(parent_organ)
				if(E)
					if(E.internal_organs == null)
						E.internal_organs = list()
					E.internal_organs |= src
			if(dna)
				if(!blood_DNA)
					blood_DNA = list()
				blood_DNA[dna.unique_enzymes] = dna.b_type
	else
		species = GLOB.all_species["Human"]

	handle_organ_mod_special()

/obj/item/organ/proc/set_initial_meat()
	if(owner)
		if(!meat_type)
			if(owner.isSynthetic())
				meat_type = /obj/item/stack/material/steel
			else if(ishuman(owner))
				var/mob/living/carbon/human/H = owner
				meat_type = H?.species?.meat_type

			if(!meat_type)
				if(owner.meat_type)
					meat_type = owner.meat_type
				else
					meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

/obj/item/organ/proc/set_dna(var/datum/dna/new_dna)
	if(new_dna)
		dna = new_dna.Clone()
		if(blood_DNA)
			blood_DNA.Cut()
			blood_DNA[dna.unique_enzymes] = dna.b_type

/obj/item/organ/proc/die()
	if(robotic < ORGAN_ROBOT)
		status |= ORGAN_DEAD
	damage = max_damage
	STOP_PROCESSING(SSobj, src)
	handle_organ_mod_special(TRUE)
	if(owner && vital)
		owner.can_defib = 0
		owner.death()

/obj/item/organ/proc/adjust_germ_level(var/amount)		// Unless you're setting germ level directly to 0, use this proc instead
	germ_level = CLAMP(germ_level + amount, 0, INFECTION_LEVEL_MAX)

/obj/item/organ/process()

	if(loc != owner)
		owner = null

	//dead already, no need for more processing
	if(status & ORGAN_DEAD)
		return
	// Don't process if we're in a freezer, an MMI or a stasis bag.or a freezer or something I dunno
	if(istype(loc,/obj/item/device/mmi))
		return
	if(preserved)
		return

	//check if we've hit max_damage
	if(damage >= max_damage)
		die()

	handle_organ_proc_special()

	//Process infections
	if(robotic >= ORGAN_ROBOT || (istype(owner) && (owner.species && (owner.species.flags & (IS_PLANT | NO_INFECT)))))
		germ_level = 0
		return

	if(!owner && reagents)
		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		if(B && prob(40) && !isbelly(loc)) //VOREStation Edit
			reagents.remove_reagent("blood",0.1)
			blood_splatter(src,B,1)
		if(config.organs_decay && decays) damage += rand(1,3)
		if(damage >= max_damage)
			damage = max_damage
		adjust_germ_level(rand(2,6))
		if(germ_level >= INFECTION_LEVEL_TWO)
			adjust_germ_level(rand(2,6))
		if(germ_level >= INFECTION_LEVEL_THREE)
			die()

	else if(owner && owner?.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

/obj/item/organ/examine(mob/user)
	. = ..()
	if(status & ORGAN_DEAD)
		. += "<span class='notice'>Decay appears to have set in.</span>"

//A little wonky: internal organs stop calling this (they return early in process) when dead, but external ones cause further damage when dead
/obj/item/organ/proc/handle_germ_effects()
	//** Handle the effects of infections
	if(robotic >= ORGAN_ROBOT) //Just in case!
		germ_level = 0
		return 0

	var/antibiotics = iscarbon(owner) ? owner.chem_effects[CE_ANTIBIOTIC] || 0 : 0

	var/infection_damage = 0

	/// Infection damage

	//If the organ is dead, for the sake of organs that may have died due to non-infection, we'll only do damage if they have at least L1 infection (built up below)
	if((status & ORGAN_DEAD) && antibiotics < ANTIBIO_OD && germ_level >= INFECTION_LEVEL_ONE)
		infection_damage = max(1, 1 + round((germ_level - INFECTION_LEVEL_THREE)/200,0.25)) //1 Tox plus a little based on germ level

	else if(germ_level > INFECTION_LEVEL_TWO && antibiotics < ANTIBIO_OD)
		infection_damage = max(0.25, 0.25 + round((germ_level - INFECTION_LEVEL_TWO)/200,0.25))

	if(infection_damage)
		owner.adjustToxLoss(infection_damage)

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
		adjust_germ_level(-antibiotics)

	/// Germ Accumulation

	//Dead organs accumulate germs indefinitely
	if(status & ORGAN_DEAD)
		adjust_germ_level(1)

	//Half of level 1 is growing but harmless
	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
		if(!antibiotics && prob(round(germ_level/6)))
			adjust_germ_level(1)

	//Level 1 qualifies for specific organ processing effects
	if(germ_level >= INFECTION_LEVEL_ONE)
		. = 1 //Organ qualifies for effect-specific processing
		//var/fever_temperature = (owner.species.heat_level_1 - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		//owner.bodytemperature += between(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)
		var/fever_temperature = owner?.species.heat_discomfort_level * 1.10 //Heat discomfort level plus 10%
		if(owner?.bodytemperature < fever_temperature)
			owner?.bodytemperature += min(0.2,(fever_temperature - owner?.bodytemperature) / 10) //Will usually climb by 0.2, else 10% of the difference if less

	//Level two qualifies for further processing effects
	if (germ_level >= INFECTION_LEVEL_TWO)
		. = 2 //Organ qualifies for effect-specific processing
		//No particular effect on the general 'organ' at 3

	//Level three qualifies for significant growth and further effects
	if (germ_level >= INFECTION_LEVEL_THREE && antibiotics < ANTIBIO_OD)
		. = 3 //Organ qualifies for effect-specific processing
		adjust_germ_level(rand(5,10)) //Germ_level increases without overdose of antibiotics

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(dna && can_reject)
		if(!rejecting)
			if(blood_incompatible(dna.b_type, owner.dna.b_type, species.name, owner.species.name)) //VOREStation Edit - Process species by name.
				rejecting = 1
		else
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						adjust_germ_level(1)
					if(51 to 200)
						adjust_germ_level(rand(1,2))
					if(201 to 500)
						adjust_germ_level(rand(2,3))
					if(501 to INFINITY)
						adjust_germ_level(rand(3,5))
						owner.reagents.add_reagent("toxin", rand(1,2))

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/remove_rejuv()
	qdel(src)

/obj/item/organ/proc/rejuvenate(var/ignore_prosthetic_prefs)
	damage = 0
	status = 0
	germ_level = 0
	if(owner)
		handle_organ_mod_special()
	if(!ignore_prosthetic_prefs && owner && owner.client && owner.client.prefs && owner.client.prefs.real_name == owner.real_name)
		var/status = owner.client.prefs.organ_data[organ_tag]
		if(status == "assisted")
			mechassist()
		else if(status == "mechanical")
			robotize()

/obj/item/organ/proc/is_damaged()
	return damage > 0

/obj/item/organ/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

//Germs
/obj/item/organ/proc/handle_antibiotics()
	if(istype(owner))
		var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC] || 0

		if (!germ_level || antibiotics < ANTIBIO_NORM)
			return

		if (germ_level < INFECTION_LEVEL_ONE)
			germ_level = 0	//cure instantly
		else if (germ_level < INFECTION_LEVEL_TWO)
			adjust_germ_level(-antibiotics*4)	//at germ_level < 500, this should cure the infection in a minute
		else if (germ_level < INFECTION_LEVEL_THREE)
			adjust_germ_level(-antibiotics*2) //at germ_level < 1000, this will cure the infection in 5 minutes
		else
			adjust_germ_level(-antibiotics)	// You waited this long to get treated, you don't really deserve this organ

//Adds autopsy data for used_weapon.
/obj/item/organ/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

//Note: external organs have their own version of this proc
/obj/item/organ/take_damage(amount, var/silent=0)
	if(src.robotic >= ORGAN_ROBOT)
		src.damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		src.damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && parent_organ && amount > 0)
			var/obj/item/organ/external/parent = owner?.get_organ(parent_organ)
			if(parent && !silent)
				owner.custom_pain("Something inside your [parent.name] hurts a lot.", amount)

/obj/item/organ/proc/bruise()
	damage = max(damage, min_bruised_damage)

/obj/item/organ/proc/robotize() //Being used to make robutt hearts, etc
	robotic = ORGAN_ROBOT
	src.status &= ~ORGAN_BROKEN
	src.status &= ~ORGAN_BLEEDING
	src.status &= ~ORGAN_CUT_AWAY

/obj/item/organ/proc/mechassist() //Used to add things like pacemakers, etc
	robotize()
	robotic = ORGAN_ASSISTED
	min_bruised_damage = 15
	min_broken_damage = 35
	butcherable = FALSE

/obj/item/organ/proc/digitize() //Used to make the circuit-brain. On this level in the event more circuit-organs are added/tweaks are wanted.
	robotize()

/obj/item/organ/emp_act(severity)
	for(var/obj/O as anything in src.contents)
		O.emp_act(severity)

	if(!(robotic >= ORGAN_ASSISTED))
		return
	for(var/i = 1; i <= robotic; i++)
		switch (severity)
			if (1)
				take_damage(rand(5,9))
			if (2)
				take_damage(rand(3,7))
			if (3)
				take_damage(rand(2,5))
			if (4)
				take_damage(rand(1,3))

/obj/item/organ/proc/removed(var/mob/living/user)
	if(owner)
		owner.internal_organs_by_name[organ_tag] = null
		owner.internal_organs_by_name -= organ_tag
		owner.internal_organs_by_name -= null
		owner.internal_organs -= src

		var/obj/item/organ/external/affected = owner.get_organ(parent_organ)
		if(affected) affected.internal_organs -= src

		owner.remove_from_mob(src, owner.drop_location())
		START_PROCESSING(SSobj, src)
		rejecting = null

	if(istype(owner))
		var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list
		if(!organ_blood || !organ_blood.data["blood_DNA"])
			owner.vessel.trans_to(src, 5, 1, 1)

		if(owner && vital)
			if(user)
				add_attack_logs(user, owner, "Removed vital organ [src.name]")
			if(owner.stat != DEAD)
				owner.can_defib = 0
				owner.death()

	handle_organ_mod_special(TRUE)

	owner = null


/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target,var/obj/item/organ/external/affected)

	if(!istype(target)) return

	var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	transplant_data = list()
	if(!transplant_blood)
		transplant_data["species"] =    target?.species.name
		transplant_data["blood_type"] = target?.dna.b_type
		transplant_data["blood_DNA"] =  target?.dna.unique_enzymes
	else
		transplant_data["species"] =    transplant_blood?.data["species"]
		transplant_data["blood_type"] = transplant_blood?.data["blood_type"]
		transplant_data["blood_DNA"] =  transplant_blood?.data["blood_DNA"]

	owner = target
	loc = owner
	STOP_PROCESSING(SSobj, src)
	target.internal_organs |= src
	affected.internal_organs |= src
	target.internal_organs_by_name[organ_tag] = src

	handle_organ_mod_special()

/obj/item/organ/proc/bitten(mob/user)

	if(robotic >= ORGAN_ROBOT)
		return

	to_chat(user, "<span class='notice'>You take an experimental bite out of \the [src].</span>")
	var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
	blood_splatter(src,B,1)

	user.drop_from_inventory(src)
	var/obj/item/weapon/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.icon = icon
	O.icon_state = icon_state

	// Pass over the blood.
	reagents.trans_to(O, reagents.total_volume)

	if(fingerprints) O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden) O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast) O.fingerprintslast = fingerprintslast

	user.put_in_active_hand(O)
	qdel(src)

/obj/item/organ/attack_self(mob/user as mob)

	// Convert it to an edible form, yum yum.
	if(!(robotic >= ORGAN_ROBOT) && user.a_intent == I_HELP && user.zone_sel.selecting == O_MOUTH)
		bitten(user)
		return

/obj/item/organ/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(can_butcher(W, user))
		butcher(W, user)
		return

	return ..()

/obj/item/organ/proc/can_butcher(var/obj/item/O, var/mob/living/user)
	if(butcherable && meat_type)

		if(istype(O, /obj/machinery/gibber))	// The great equalizer.
			return TRUE

		if(robotic >= ORGAN_ROBOT)
			if(O.has_tool_quality(TOOL_SCREWDRIVER))
				return TRUE

		else
			if(is_sharp(O) && has_edge(O))
				return TRUE

	return FALSE

/obj/item/organ/proc/butcher(var/obj/item/O, var/mob/living/user, var/atom/newtarget)
	if(robotic >= ORGAN_ROBOT)
		user?.visible_message("<span class='notice'>[user] disassembles \the [src].</span>")

	else
		user?.visible_message("<span class='notice'>[user] butchers \the [src].</span>")

	if(!newtarget)
		newtarget = get_turf(src)

	var/obj/item/newmeat = new meat_type(newtarget)

	if(istype(newmeat, /obj/item/weapon/reagent_containers/food/snacks/meat))
		newmeat.name = "[src.name] [newmeat.name]"	// "liver meat" "heart meat", etc.

	qdel(src)

/obj/item/organ/proc/organ_can_feel_pain()
	if(species.flags & NO_PAIN)
		return 0
	if(status & ORGAN_DESTROYED)
		return 0
	if(robotic && robotic < ORGAN_LIFELIKE)	//Super fancy humanlike robotics probably have sensors, or something?
		return 0
	if(stapled_nerves)
		return 0
	return 1

/obj/item/organ/proc/handle_organ_mod_special(var/removed = FALSE)	// Called when created, transplanted, and removed.
	if(!istype(owner))
		return

	var/list/save_verbs = list()

	if(removed && organ_verbs)	// Do we share verbs with any other organs? Are they functioning?
		var/list/all_organs = list()
		all_organs |= owner.organs
		all_organs |= owner.internal_organs

		for(var/obj/item/organ/O in all_organs)
			if(!(O.status & ORGAN_DEAD) && O.organ_verbs && O.check_verb_compatability())
				for(var/verb_type in O.organ_verbs)
					if(verb_type in organ_verbs)
						save_verbs |= verb_type

	if(!removed && organ_verbs && check_verb_compatability())
		for(var/verb_path in organ_verbs)
			owner.verbs |= verb_path
	else if(organ_verbs)
		for(var/verb_path in organ_verbs)
			if(!(verb_path in save_verbs))
				owner.verbs -= verb_path
	return

/obj/item/organ/proc/handle_organ_proc_special()	// Called when processed.
	return

/obj/item/organ/proc/check_verb_compatability()		// Used for determining if an organ should give or remove its verbs. I.E., FBP part in a human, no verbs. If true, keep or add.
	if(owner)
		if(ishuman(owner))
			var/mob/living/carbon/human/H = owner
			var/obj/item/organ/O = H.get_organ(parent_organ)
			if(forgiving_class)
				if(O.robotic <= ORGAN_ASSISTED && robotic <= ORGAN_LIFELIKE)	// Parent is organic or assisted, we are at most synthetic.
					return TRUE

				if(O.robotic >= ORGAN_ROBOT && robotic >= ORGAN_ASSISTED)		// Parent is synthetic, and we are biosynthetic at least.
					return TRUE

			if(!target_parent_classes || !target_parent_classes.len)	// Default checks, if we're not looking for a Specific type.

				if(O.robotic == robotic)	// Same thing, we're fine.
					return TRUE

				if(O.robotic < ORGAN_ROBOT && robotic < ORGAN_ROBOT)
					return TRUE

				if(O.robotic > ORGAN_ASSISTED && robotic > ORGAN_ASSISTED)
					return TRUE

			else
				if(O.robotic in target_parent_classes)
					return TRUE

	return FALSE
