/****************************************************
				EXTERNAL ORGANS
****************************************************/

//These control the damage thresholds for the various ways of removing limbs
#define DROPLIMB_THRESHOLD_EDGE 5
#define DROPLIMB_THRESHOLD_TEAROFF 2
#define DROPLIMB_THRESHOLD_DESTROY 1

/obj/item/organ/external
	name = "external"
	min_broken_damage = 30
	max_damage = 0
	dir = SOUTH
	organ_tag = "limb"

	// Strings
	var/broken_description             // fracture string if any.
	var/damage_state = "00"            // Modifier used for generating the on-mob damage overlay for this limb.

	// Damage vars.
	var/brute_mod = 1                  // Multiplier for incoming brute damage.
	var/burn_mod = 1                   // As above for burn.
	var/brute_dam = 0                  // Actual current brute damage.
	var/burn_dam = 0                   // Actual current burn damage.
	var/last_dam = -1                  // used in healing/processing calculations.
	var/spread_dam = 0
	var/thick_skin = 0                 // If a needle has a chance to fail to penetrate.

	// Appearance vars.
	var/nonsolid                       // Snowflake warning, reee. Used for slime limbs.
	var/transparent                    // As above, so below. Used for transparent limbs.
	var/icon_name = null               // Icon state base.
	var/body_part = null               // Part flag
	var/icon_position = 0              // Used in mob overlay layering calculations.
	var/model                          // Used when caching robolimb icons.
	var/force_icon                     // Used to force override of species-specific limb icons (for prosthetics). Also used for any limbs chopped from a simple mob, and then attached to humans.
	var/force_icon_key                 // Used to force the override of the icon-key generated using the species. Must be used in tandem with the above.
	var/icon/mob_icon                  // Cached icon for use in mob overlays.
	var/gendered_icon = 0              // Whether or not the icon state appends a gender.
	var/s_tone                         // Skin tone.
	var/list/s_col                     // skin colour
	var/s_col_blend = ICON_ADD         // How the skin colour is applied.
	var/list/h_col                     // hair colour
	var/body_hair                      // Icon blend for body hair if any.
	var/mob/living/applied_pressure
	var/list/markings = list()         // Markings (body_markings) to apply to the icon
	var/skip_robo_icon = FALSE 			//to force it to use the normal species icon
	var/digi_prosthetic = FALSE 		//is it a prosthetic that can be digitigrade

	// Wound and structural data.
	var/wound_update_accuracy = 1      // how often wounds should be updated, a higher number means less often
	var/list/wounds = list()           // wound datum list.
	var/number_wounds = 0              // number of wounds, which is NOT wounds.len!
	var/obj/item/organ/external/parent // Master-limb.
	var/list/children = list()         // Sub-limbs.
	var/list/internal_organs = list()  // Internal organs of this body part
	var/sabotaged = 0                  // If a prosthetic limb is emagged, it will detonate when it fails.
	var/list/implants = list()         // Currently implanted objects.
	var/organ_rel_size = 25            // Relative size of the organ.
	var/base_miss_chance = 20          // Chance of missing.
	var/atom/movable/splinted

	// Joint/state stuff.
	var/can_grasp                      // It would be more appropriate if these two were named "affects_grasp" and "affects_stand" at this point
	var/can_stand                      // Modifies stance tally/ability to stand.
	var/disfigured = 0                 // Scarred/burned beyond recognition.
	var/cannot_amputate                // Impossible to amputate.
	var/cannot_break                   // Impossible to fracture.
	var/cannot_gib                     // Impossible to gib, distinct from amputation.
	var/joint = "joint"                // Descriptive string used in dislocation.
	var/amputation_point               // Descriptive string used in amputation.
	var/dislocated = 0    // If you target a joint, you can dislocate the limb, impairing it's usefulness and causing pain
	var/encased                        // Needs to be opened with a saw to access the organs.

	// Surgery vars.
	var/open = 0
	var/stage = 0
	var/cavity = 0
	var/burn_stage = 0		//Surgical repair stage for burn.
	var/brute_stage = 0		//Surgical repair stage for brute.

	// HUD element variable, see organ_icon.dm get_damage_hud_image()
	var/image/hud_damage_image

/obj/item/organ/external/Destroy()

	if(parent && parent.children)
		parent.children -= src
		parent = null

	if(children)
		for(var/obj/item/organ/external/C in children)
			children -= C
			C.parent = null
			qdel(C)

	if(internal_organs)
		for(var/obj/item/organ/O in internal_organs)
			internal_organs -= O
			qdel(O)

	if(splinted && splinted.loc == src)
		splinted.loc = null
		qdel(splinted)
	splinted = null

	if(istype(owner))
		owner.organs -= src
		owner.organs_by_name[organ_tag] = null
		owner.organs_by_name -= organ_tag
		while(null in owner.organs)
			owner.organs -= null

	for(var/obj/item/implant/I as anything in implants)
		if(!istype(I))
			continue
		I.imp_in = I.part = null
	implants.Cut()

	return ..()

/obj/item/organ/external/emp_act(severity)
	for(var/obj/O as anything in src.contents)
		O.emp_act(severity)

	if(!(robotic >= ORGAN_ROBOT))
		return
	var/burn_damage = 0
	for(var/i = 1; i <= robotic; i++)
		switch (severity)
			if (1)
				burn_damage += rand(5, 8)
			if (2)
				burn_damage += rand(4, 6)
			if(3)
				burn_damage += rand(2, 5)
			if(4)
				burn_damage += rand(1, 3)

	if(burn_damage)
		take_damage(0, burn_damage)

/obj/item/organ/external/attack_self(var/mob/living/user)
	if(!contents.len)
		return ..()
	var/list/removable_objects = list()
	for(var/obj/item/organ/external/E in (contents + src))
		if(!istype(E))
			continue
		for(var/obj/item/I in E.contents)
			if(istype(I,/obj/item/organ))
				continue
			removable_objects |= I
	if(removable_objects.len)
		var/obj/item/I = pick(removable_objects)
		I.loc = get_turf(user) //just in case something was embedded that is not an item
		if(istype(I))
			user.put_in_hands(I)
		user.visible_message(span_danger("\The [user] rips \the [I] out of \the [src]!"))
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine()
	. = ..()
	if(in_range(usr, src) || istype(usr, /mob/observer/dead))
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			. += span_danger("There is \a [I] sticking out of it.")

/obj/item/organ/external/attackby(obj/item/W as obj, mob/living/user as mob)
	switch(stage)
		if(0)
			if(istype(W,/obj/item/surgical/scalpel))
				user.visible_message(span_danger("<b>[user]</b> cuts [src] open with [W]!"))
				stage++
				return
		if(1)
			if(istype(W,/obj/item/surgical/retractor))
				user.visible_message(span_danger("<b>[user]</b> cracks [src] open like an egg with [W]!"))
				stage++
				return
		if(2)
			if(istype(W,/obj/item/surgical/hemostat))
				if(contents.len)
					var/obj/item/removing = pick(contents)
					removing.loc = get_turf(user.loc)
					user.put_in_hands(removing)
					user.visible_message(span_danger("<b>[user]</b> extracts [removing] from [src] with [W]!"))
				else
					user.visible_message(span_danger("<b>[user]</b> fishes around fruitlessly in [src] with [W]."))
				return
	..()

/obj/item/organ/external/proc/is_dislocated()
	if(dislocated > 0)
		return 1
	if(is_parent_dislocated())
		return 1//if any parent is dislocated, we are considered dislocated as well
	return 0

/obj/item/organ/external/proc/is_parent_dislocated()
	var/obj/item/organ/external/O = parent
	while(O && O.dislocated != -1)
		if(O.dislocated == 1)
			return 1
		O = O.parent
	return 0

//new function to check for markings
/obj/item/organ/external/proc/is_hidden_by_markings()
	for(var/M in markings)
		var/datum/sprite_accessory/marking/mark_style = markings[M]["datum"]
		if(istype(mark_style,/datum/sprite_accessory/marking) && (organ_tag in mark_style.hide_body_parts))
			return 1

/obj/item/organ/external/proc/dislocate()
	if(dislocated == -1)
		return

	dislocated = 1
	if(istype(owner))
		add_verb(owner, /mob/living/carbon/human/proc/relocate)

/obj/item/organ/external/proc/relocate()
	if(dislocated == -1)
		return

	dislocated = 0
	if(istype(owner))
		owner.shock_stage += 20

		//check to see if we still need the verb
		for(var/obj/item/organ/external/limb in owner.organs)
			if(limb.dislocated == 1)
				return
		remove_verb(owner, /mob/living/carbon/human/proc/relocate)

/obj/item/organ/external/update_health()
	damage = min(max_damage, (brute_dam + burn_dam))

/obj/item/organ/external/New(var/mob/living/carbon/holder)
	..(holder, 0)
	if(istype(owner))
		replaced(owner)
		sync_colour_to_human(owner)
	spawn(1)
		get_icon()

/obj/item/organ/external/replaced(var/mob/living/carbon/human/target)
	owner = target
	forceMove(owner)
	if(istype(owner))
		owner.organs_by_name[organ_tag] = src
		owner.organs |= src
		for(var/obj/item/organ/organ in src)
			organ.replaced(owner,src)
		owner.refresh_modular_limb_verbs()

	if(parent_organ)
		parent = owner.organs_by_name[src.parent_organ]
		if(parent)
			if(!parent.children)
				parent.children = list()
			parent.children.Add(src)
			//Remove all stump wounds since limb is not missing anymore
			for(var/datum/wound/lost_limb/W in parent.wounds)
				parent.wounds -= W
				qdel(W)
				break
			parent.update_damages()

/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(var/additional_damage = 0)
	//Continued damage to vital organs can kill you, and robot organs don't count towards total damage so no need to cap them.
	return (vital || (robotic >= ORGAN_ROBOT) || brute_dam + burn_dam + additional_damage < max_damage)

/obj/item/organ/external/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), permutation = 0)
	brute = round(brute * brute_mod, 0.1)
	burn = round(burn * burn_mod, 0.1)

	if((brute <= 0) && (burn <= 0))
		return 0

	// High brute damage or sharp objects may damage internal organs
	if(internal_organs && (brute_dam >= max_damage || (((sharp && brute >= 5) || brute >= 10) && prob(5))))
		// Damage an internal organ
		if(internal_organs && internal_organs.len)
			var/obj/item/organ/I = pick(internal_organs)
			brute *= 0.5
			I.take_damage(brute)

	if(status & ORGAN_BROKEN && brute)
		jostle_bone(brute)
		if(organ_can_feel_pain() && prob(40) && !isbelly(owner.loc) && !istype(owner.loc, /obj/item/dogborg/sleeper)) //VOREStation Edit
			owner.emote("scream")	//getting hit on broken hand hurts
	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)

	var/can_cut = (sharp) && (robotic < ORGAN_ROBOT)

	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	// Non-vital organs are limited to max_damage. You can't kill someone by bludeonging their arm all the way to 200 -- you can
	// push them faster into paincrit though, as the additional damage is converted into shock.
	var/brute_overflow = 0
	var/burn_overflow = 0
	if(is_damageable(brute + burn) || !config.limbs_can_break)
		if(brute)
			if(can_cut)
				if(sharp && !edge)
					createwound( PIERCE, brute )
				else
					createwound( CUT, brute )
			else
				createwound( BRUISE, brute )
		if(burn)
			createwound( BURN, burn )
	else
		//If we can't inflict the full amount of damage, spread the damage in other ways
		//How much damage can we actually cause?
		var/can_inflict = max_damage * config.organ_health_multiplier - (brute_dam + burn_dam)
		var/spillover = 0
		if(can_inflict)
			if (brute > 0)
				//Inflict all burte damage we can
				if(can_cut)
					if(sharp && !edge)
						createwound( PIERCE, min(brute,can_inflict) )
					else
						createwound( CUT, min(brute,can_inflict) )
				else
					createwound( BRUISE, min(brute,can_inflict) )
				//How much more damage can we inflict
				brute_overflow = max(0, brute - can_inflict)
				//How much brute damage is left to inflict
				spillover += max(0, brute - can_inflict)

			can_inflict = max_damage * config.organ_health_multiplier - (brute_dam + burn_dam) //Refresh the can_inflict var, so burn doesn't overload the limb if it is set to take both.

			if (burn > 0 && can_inflict)
				//Inflict all burn damage we can
				createwound(BURN, min(burn,can_inflict))
				//How much burn damage is left to inflict
				burn_overflow = max(0, burn - can_inflict)
				spillover += burn_overflow

		//If there is pain to dispense.
		if(spillover)
			owner.shock_stage += spillover * config.organ_damage_spillover_multiplier

	// sync the organ's damage with its wounds
	src.update_damages()
	if(owner)
		owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called

	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner && !is_stump())
		if(!cannot_amputate && config.limbs_can_break && (brute_dam + burn_dam) >= (max_damage * config.organ_health_multiplier))
			//organs can come off in three cases
			//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
			//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
			//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
			//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.

			//Check edge eligibility
			var/edge_eligible = 0
			if(edge)
				if(istype(used_weapon,/obj/item))
					var/obj/item/W = used_weapon
					if(W.w_class >= w_class)
						edge_eligible = 1
				else
					edge_eligible = 1

			//VOREStation Add
			if(nonsolid && damage >= max_damage)
				droplimb(TRUE, DROPLIMB_EDGE)
			else if (robotic >= ORGAN_NANOFORM && damage >= max_damage)
				droplimb(TRUE, DROPLIMB_BURN)
			//VOREStation Add End
			//VOREStation Edit - We have special droplimb handling for prom/proteans
			else if(edge_eligible && brute >= max_damage / DROPLIMB_THRESHOLD_EDGE && prob(brute))
				droplimb(0, DROPLIMB_EDGE)
			else if((burn >= max_damage / DROPLIMB_THRESHOLD_DESTROY) && prob(burn*0.33))
				droplimb(0, DROPLIMB_BURN)
			else if((brute >= max_damage / DROPLIMB_THRESHOLD_DESTROY && prob(brute)))
				droplimb(0, DROPLIMB_BLUNT)
			//VOREStation Edit End
			else if(brute >= max_damage / DROPLIMB_THRESHOLD_TEAROFF && prob(brute*0.33))
				droplimb(0, DROPLIMB_EDGE)
			else if(spread_dam && owner && parent && (brute_overflow || burn_overflow) && (brute_overflow >= 5 || burn_overflow >= 5) && !permutation) //No infinite damage loops.
				var/brute_third = brute_overflow * 0.33
				var/burn_third = burn_overflow * 0.33
				if(children && children.len)
					var/brute_on_children = brute_third / children.len
					var/burn_on_children = burn_third / children.len
					spawn()
						for(var/obj/item/organ/external/C in children)
							if(!C.is_stump())
								C.take_damage(brute_on_children, burn_on_children, 0, 0, null, forbidden_limbs, 1) //Splits the damage to each individual 'child', incase multiple exist.
				parent.take_damage(brute_third, burn_third, 0, 0, null, forbidden_limbs, 1)

	return update_icon()

/obj/item/organ/external/proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(robotic >= ORGAN_ROBOT && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	if(internal)
		status &= ~ORGAN_BROKEN

	//Sync the organ's damage with its wounds
	src.update_damages()
	src.update_wounds()
	owner.updatehealth()

	var/result = update_icon()
	return result

//Helper proc used by various tools for repairing robot limbs
/obj/item/organ/external/proc/robo_repair(var/repair_amount, var/damage_type, var/damage_desc, obj/item/tool, mob/living/user)
	if((src.robotic < ORGAN_ROBOT))
		return 0

	var/damage_amount
	switch(damage_type)
		if(BRUTE)   damage_amount = brute_dam
		if(BURN)    damage_amount = burn_dam
		if("omni")  damage_amount = max(brute_dam,burn_dam)
		else return 0

	if(!damage_amount)
		to_chat(user, span_notice("Nothing to fix!"))
		return 0

	if(brute_dam + burn_dam >= min_broken_damage) //VOREStation Edit - Makes robotic limb damage scalable
		to_chat(user, span_danger("The damage is far too severe to patch over externally."))
		return 0

	if(user == src.owner)
		var/grasp
		if(user.l_hand == tool && (src.body_part & (ARM_LEFT|HAND_LEFT)))
			grasp = "l_hand"
		else if(user.r_hand == tool && (src.body_part & (ARM_RIGHT|HAND_RIGHT)))
			grasp = "r_hand"

		if(grasp)
			to_chat(user, span_warning("You can't reach your [src.name] while holding [tool] in your [owner.get_bodypart_name(grasp)]."))
			return 0

	user.setClickCooldown(user.get_attack_speed(tool))
	if(!do_mob(user, owner, 10))
		to_chat(user, span_warning("You must stand still to do that."))
		return 0

	switch(damage_type)
		if(BRUTE) src.heal_damage(repair_amount, 0, 0, 1)
		if(BURN)  src.heal_damage(0, repair_amount, 0, 1)
		if("omni")src.heal_damage(repair_amount, repair_amount, 0, 1)

	if(damage_desc)
		var/fix_verb = (damage_amount > repair_amount) ? "patches" : "finishes patching"
		if(user == src.owner)
			var/datum/gender/T = gender_datums[user.get_visible_gender()]
			user.visible_message("<b>\The [user]</b> [fix_verb] [damage_desc] on [T.his] [src.name] with [tool].")
		else
			user.visible_message("<b>\The [user]</b> [fix_verb] [damage_desc] on [owner]'s [src.name] with [tool].")

	return 1


/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/rejuvenate(var/ignore_prosthetic_prefs)
	damage_state = "00"
	status = 0
	brute_dam = 0
	burn_dam = 0
	germ_level = 0
	wounds.Cut()
	number_wounds = 0

	// handle internal organs
	for(var/obj/item/organ/current_organ in internal_organs)
		current_organ.rejuvenate(ignore_prosthetic_prefs)

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(istype(implanted_object,/obj/item/implant) || istype(implanted_object,/obj/item/nif))	// We don't want to remove REAL implants. Just shrapnel etc. //VOREStation Edit - NIFs pls
			continue
		implanted_object.loc = get_turf(src)
		implants -= implanted_object
	if(!owner.has_embedded_objects())
		owner.clear_alert("embeddedobject")

	if(owner && !ignore_prosthetic_prefs)
		if(owner.client && owner.client.prefs && owner.client.prefs.real_name == owner.real_name)
			var/status = owner.client.prefs.organ_data[organ_tag]
			if(status == "amputated")
				remove_rejuv()
			else if(status == "cyborg")
				var/robodata = owner.client.prefs.rlimb_data[organ_tag]
				if(robodata)
					robotize(robodata)
				else
					robotize()
		owner.updatehealth()

/obj/item/organ/external/remove_rejuv()
	if(owner)
		owner.organs -= src
		owner.organs_by_name[organ_tag] = null
		owner.organs_by_name -= organ_tag
		while(null in owner.organs) owner.organs -= null
	if(children && children.len)
		for(var/obj/item/organ/external/E in children)
			E.remove_rejuv()
	children.Cut()
	for(var/obj/item/organ/internal/I in internal_organs)
		I.remove_rejuv()
	..()

/obj/item/organ/external/proc/createwound(var/type = CUT, var/damage)
	if(damage == 0) return

	//moved this before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage
	if((damage > 15) && (type != BURN) && (local_damage > 30) && prob(damage) && (robotic < ORGAN_ROBOT) && !(species.flags & NO_BLOOD))
		var/datum/wound/internal_bleeding/I = new (min(damage - 15, 15))
		wounds += I
		owner.custom_pain("You feel something rip in your [name]!", 50)

//Burn damage can cause fluid loss due to blistering and cook-off

	if((damage > 5 || damage + burn_dam >= 15) && type == BURN && (robotic < ORGAN_ROBOT) && !(species.flags & NO_BLOOD))
		var/fluid_loss = 0.4 * (damage/(owner.getMaxHealth() - config.health_threshold_dead)) * owner.species.blood_volume*(1 - owner.species.blood_level_fatal)
		owner.remove_blood(fluid_loss)

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(prob(25))
					if(robotic >= ORGAN_ROBOT)
						owner.visible_message(span_danger("The damage to [owner.name]'s [name] worsens."),\
						span_danger("The damage to your [name] worsens."),\
						span_danger("You hear the screech of abused metal."))
					else
						owner.visible_message(span_danger("The wound on [owner.name]'s [name] widens with a nasty ripping noise."),\
						span_danger("The wound on your [name] widens with a nasty ripping noise."),\
						span_danger("You hear a nasty ripping noise, as if flesh is being torn apart."))
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage)

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W = null // to signify that the wound was added
				break
		if(W)
			wounds += W

/****************************************************
			   PROCESSING & UPDATING
****************************************************/

//external organs handle brokenness a bit differently when it comes to damage. Instead brute_dam is checked inside process()
//this also ensures that an external organ cannot be "broken" without broken_description being set.
/obj/item/organ/external/is_broken()
	return ((status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN) && (!splinted || (splinted && (splinted in src.contents) && prob(30))))

//Determines if we even need to process this organ.
/obj/item/organ/external/proc/need_process()
	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_DESTROYED|ORGAN_DEAD|ORGAN_MUTATED))
		return 1
	if(brute_dam || burn_dam)//VOREStation Edit - But they do for medichines! ---&& (robotic < ORGAN_ROBOT)) //Robot limbs don't autoheal and thus don't need to process when damaged
		return 1
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return 1
	else
		last_dam = brute_dam + burn_dam
	if (number_wounds != 0)
		return 1
	if(germ_level)
		return 1
	return 0

/obj/item/organ/external/process()
	if(owner)
		//Dismemberment
		//if(parent && parent.is_stump()) //should never happen
		//	warning("\The [src] ([src.type]) belonging to [owner] ([owner.type]) was attached to a stump")
		//	remove()
		//	return

		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		if(owner.life_tick % wound_update_accuracy == 0)
			update_wounds()

		//Chem traces slowly vanish
		if(owner.life_tick % 10 == 0)
			for(var/chemID in trace_chemicals)
				trace_chemicals[chemID] = trace_chemicals[chemID] - 1
				if(trace_chemicals[chemID] <= 0)
					trace_chemicals.Remove(chemID)

		//Infections
		update_germs()
	else
		..()

//Updating germ levels. Handles organ germ levels and necrosis.
/*
The INFECTION_LEVEL values defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 15 minutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245. Note that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level nothing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on spaceacillin to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/organ/external/proc/update_germs()

	if(robotic >= ORGAN_ROBOT || (owner.species && (owner.species.flags & IS_PLANT || (owner.species.flags & NO_INFECT)))) //Robotic limbs shouldn't be infected, nor should nonexistant limbs.
		germ_level = 0
		return

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Syncing germ levels with external wounds
		handle_germ_sync()

		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		handle_germ_effects()

/obj/item/organ/external/proc/handle_germ_sync()
	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]
	for(var/datum/wound/W in wounds)
		//Open wounds can become infected
		if (owner.germ_level > W.germ_level && W.infection_check())
			W.germ_level++

	if (antibiotics < ANTIBIO_NORM)
		for(var/datum/wound/W in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level)
				germ_level++
				break	//limit increase to a maximum of one per second

/obj/item/organ/external/handle_germ_effects()
	. = ..() //May be null or an infection level, if null then no specific processing needed here
	if(!.) return

	var/antibiotics = owner.chem_effects[CE_ANTIBIOTIC]

	if(. >= 2 && antibiotics < ANTIBIO_NORM) //INFECTION_LEVEL_TWO
		//spread the infection to internal organs
		var/obj/item/organ/target_organ = null	//make internal organs become infected one at a time instead of all at once
		for (var/obj/item/organ/I in internal_organs)
			if (I.germ_level > 0 && I.germ_level < min(germ_level, INFECTION_LEVEL_TWO))	//once the organ reaches whatever we can give it, or level two, switch to a different one
				if (!target_organ || I.germ_level > target_organ.germ_level)	//choose the organ with the highest germ_level
					target_organ = I

		if (!target_organ)
			//figure out which organs we can spread germs to and pick one at random
			var/list/candidate_organs = list()
			for (var/obj/item/organ/I in internal_organs)
				if (I.germ_level < germ_level)
					candidate_organs |= I
			if (candidate_organs.len)
				target_organ = pick(candidate_organs)

		if (target_organ)
			target_organ.germ_level++

		//spread the infection to child and parent organs
		if (children)
			for (var/obj/item/organ/external/child in children)
				if (child.germ_level < germ_level && (child.robotic < ORGAN_ROBOT))
					if (child.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
						child.germ_level++

		if (parent)
			if (parent.germ_level < germ_level && (parent.robotic < ORGAN_ROBOT))
				if (parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30))
					parent.germ_level++

	if(. >= 3 && antibiotics < ANTIBIO_OD)	//INFECTION_LEVEL_THREE
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			to_chat(owner, span_notice("You can't feel your [name] anymore..."))
			owner.update_icons_body()
			for (var/obj/item/organ/external/child in children)
				child.germ_level += 110 //Burst of infection from a parent organ becoming necrotic

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/obj/item/organ/external/proc/update_wounds()

	if((robotic >= ORGAN_ROBOT) || (species.flags & UNDEAD)) //Robotic and dead limbs don't heal or get worse.
		for(var/datum/wound/W in wounds) //Repaired wounds disappear though
			if(W.damage <= 0)  //and they disappear right away
				wounds -= W    //TODO: robot wounds for robot limbs
				src.update_damages()
				if (update_icon())
					owner.UpdateDamageIcon(1)
		return

	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + 10 MINUTES <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		// Internal wounds get worse over time. Low temperatures (cryo) stop them.
		if(W.internal && owner.bodytemperature >= 170)
			var/bicardose = owner.reagents.get_reagent_amount("bicaridine")
			var/inaprovaline = owner.reagents.get_reagent_amount("inaprovaline")
			var/myeldose = owner.reagents.get_reagent_amount("myelamine")
			if(!(W.can_autoheal() || (bicardose && inaprovaline) || myeldose))	//bicaridine and inaprovaline stop internal wounds from growing bigger with time, unless it is so small that it is already healing
				W.open_wound(0.1 * wound_update_accuracy)

			owner.remove_blood( wound_update_accuracy * W.damage/40) //line should possibly be moved to handle_blood, so all the bleeding stuff is in one place.
			if(prob(1 * wound_update_accuracy))
				owner.custom_pain("You feel a stabbing pain in your [name]!", 50)

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && W.wound_damage() < 50)
			heal_amt += 0.5

		//we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * config.organ_regeneration_multiplier
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (wounds.len + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		W.heal_damage(heal_amt)

		// Salving also helps against infection
		if(W.germ_level > 0 && W.salved && prob(2))
			W.disinfected = 1
			W.germ_level = 0

	// sync the organ's damage with its wounds
	src.update_damages()
	if (update_icon())
		owner.UpdateDamageIcon(1)

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/obj/item/organ/external/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0
	status &= ~ORGAN_BLEEDING
	var/clamped = 0

	var/mob/living/carbon/human/H
	if(istype(owner,/mob/living/carbon/human))
		H = owner

	//update damage counts
	for(var/datum/wound/W in wounds)
		if(!W.internal) //so IB doesn't count towards crit/paincrit
			if(W.damage_type == BURN)
				burn_dam += W.damage
			else
				brute_dam += W.damage

		if(!(robotic >= ORGAN_ROBOT) && W.bleeding() && (H && H.should_have_organ(O_HEART)) && !(H.species.flags & NO_BLOOD))
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped

		number_wounds += W.amount

	//things tend to bleed if they are CUT OPEN
	if (open && !clamped && (H && H.should_have_organ(O_HEART)))
		status |= ORGAN_BLEEDING

	//Bone fractures
	if(config.bones_can_break && brute_dam > min_broken_damage * config.organ_health_multiplier && !(robotic >= ORGAN_ROBOT))
		src.fracture()

	update_health()

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/obj/item/organ/external/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/obj/item/organ/external/proc/damage_state_text()

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"

/****************************************************
			   DISMEMBERMENT
****************************************************/

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children = null)

	if(cannot_amputate || !owner)
		return
	//VOREStation Add
	if(robotic >= ORGAN_NANOFORM)
		disintegrate = DROPLIMB_BURN //Ashes will be fine
	else if(disintegrate == DROPLIMB_EDGE && nonsolid) //VOREStation Add End
		disintegrate = DROPLIMB_BLUNT //splut

	GLOB.lost_limbs_shift_roundstat++

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			if(!clean)
				var/gore_sound = "[(robotic >= ORGAN_ROBOT) ? "tortured metal" : "ripping tendons and flesh"]"
				owner.visible_message(
					span_danger("\The [owner]'s [src.name] flies off in an arc!"),\
					span_bolddanger("Your [src.name] goes flying off!"),\
					span_danger("You hear a terrible sound of [gore_sound]."))
		if(DROPLIMB_BURN)
			if(cannot_gib)
				return
			var/gore = "[(robotic >= ORGAN_ROBOT) ? "": " of burning flesh"]"
			owner.visible_message(
				span_danger("\The [owner]'s [src.name] flashes away into ashes!"),\
				span_bolddanger("Your [src.name] flashes away into ashes!"),\
				span_danger("You hear a crackling sound[gore]."))
		if(DROPLIMB_BLUNT)
			if(cannot_gib)
				return
			var/gore = "[(robotic >= ORGAN_ROBOT) ? "": " in shower of gore"]"
			var/gore_sound = "[(status >= ORGAN_ROBOT) ? "rending sound of tortured metal" : "sickening splatter of gore"]"
			owner.visible_message(
				span_danger("\The [owner]'s [src.name] explodes[gore]!"),\
				span_bolddanger("Your [src.name] explodes[gore]!"),\
				span_danger("You hear the [gore_sound]."))

	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	var/obj/item/organ/external/parent_organ = parent

	var/use_flesh_colour = species?.get_flesh_colour(owner) ? species.get_flesh_colour(owner) : "#C80000"
	var/use_blood_colour = species?.get_blood_colour(owner) ? species.get_blood_colour(owner) : "#C80000"

	removed(null, ignore_children)
	victim?.traumatic_shock += 60

	if(parent_organ)
		var/datum/wound/lost_limb/W = new (src, disintegrate, clean)
		if(clean)
			parent_organ.wounds |= W
			parent_organ.update_damages()
		else
			var/obj/item/organ/external/stump/stump = new (victim, 0, src)
			if(robotic >= ORGAN_ROBOT)
				stump.robotize()
			stump.wounds |= W
			victim.organs |= stump
			stump.update_damages()

	spawn(1)
		if(istype(victim))
			victim.updatehealth()
			victim.UpdateDamageIcon()
			victim.update_icons_body()
		else
			victim.update_icons()
		dir = 2

	var/atom/droploc = victim.drop_location()
	switch(disintegrate)
		if(DROPLIMB_EDGE)
			appearance_flags &= ~PIXEL_SCALE
			compile_icon()
			add_blood(victim)
			var/matrix/M = matrix()
			M.Turn(rand(180))
			src.transform = M
			if(!clean)
				// Throw limb around.
				if(src && istype(loc,/turf))
					throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),5)
				dir = 2
		if(DROPLIMB_BURN)
			new /obj/effect/decal/cleanable/ash(droploc)
			for(var/obj/item/I in src)
				if(I.w_class > ITEMSIZE_SMALL && !istype(I,/obj/item/organ))
					I.forceMove(droploc)
			qdel(src)
		if(DROPLIMB_BLUNT)
			var/obj/effect/decal/cleanable/blood/gibs/gore
			if(robotic >= ORGAN_ROBOT)
				gore = new /obj/effect/decal/cleanable/blood/gibs/robot(droploc)
			else
				gore = new /obj/effect/decal/cleanable/blood/gibs(droploc)
				if(species)
					gore.fleshcolor = use_flesh_colour
					gore.basecolor =  use_blood_colour
					gore.update_icon()

			gore.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),5)

			for(var/obj/item/organ/I in internal_organs)
				I.removed()
				if(istype(loc,/turf))
					I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),5)

			for(var/obj/item/I in src)
				if(I.w_class <= ITEMSIZE_SMALL)
					qdel(I)
					continue
				I.forceMove(droploc)
				I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),5)

			qdel(src)

	if(victim.l_hand)
		if(istype(victim.l_hand,/obj/item/material/twohanded)) //if they're holding a two-handed weapon, drop it now they've lost a hand
			victim.l_hand.update_held_icon()
	if(victim.r_hand)
		if(istype(victim.r_hand,/obj/item/material/twohanded))
			victim.r_hand.update_held_icon()

/****************************************************
			   HELPERS
****************************************************/

/obj/item/organ/external/proc/is_stump()
	return 0

/obj/item/organ/external/proc/release_restraints(var/mob/living/carbon/human/holder)
	if(!holder)
		holder = owner
	if(!holder)
		return
	if (holder.handcuffed && (body_part in list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT)))
		holder.visible_message(\
			"\The [holder.handcuffed.name] falls off of [holder.name].",\
			"\The [holder.handcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.handcuffed)
	if (holder.legcuffed && (body_part in list(FOOT_LEFT, FOOT_RIGHT, LEG_LEFT, LEG_RIGHT)))
		holder.visible_message(\
			"\The [holder.legcuffed.name] falls off of [holder.name].",\
			"\The [holder.legcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.legcuffed)

// checks if all wounds on the organ are bandaged
/obj/item/organ/external/proc/is_bandaged()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.bandaged)
			return 0
	return 1

// checks if all wounds on the organ are salved
/obj/item/organ/external/proc/is_salved()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.salved)
			return 0
	return 1

// checks if all wounds on the organ are disinfected
/obj/item/organ/external/proc/is_disinfected()
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		if(!W.disinfected)
			return 0
	return 1

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/obj/item/organ/external/proc/organ_clamp()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		if(W.internal) continue
		rval |= !W.clamped
		W.clamped = 1
	return rval

/obj/item/organ/external/proc/fracture()
	if(robotic >= ORGAN_ROBOT)
		return	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if((status & ORGAN_BROKEN) || cannot_break)
		return

	if(owner)	//VOREStation Edit Start
		if(organ_can_feel_pain() && !isbelly(owner.loc) && !isliving(owner.loc))
			owner.visible_message(\
				span_danger("You hear a loud cracking sound coming from \the [owner]."),\
				span_danger("Something feels like it shattered in your [name]!"),\
				span_danger("You hear a sickening crack."))
			owner.emote("scream")
		jostle_bone()	//VOREStation Edit End

	playsound(src, "fracture", 10, 1, -2)
	status |= ORGAN_BROKEN
	broken_description = pick("broken","fracture","hairline fracture")

	// Fractures have a chance of getting you out of restraints
	if (prob(25))
		release_restraints()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	// TODO: consider moving this to a suit proc or process() or something during
	// hardsuit rewrite.

	if(!(splinted) && owner && istype(owner.wear_suit, /obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = owner.wear_suit
		suit.handle_fracture(owner, src)

	return 1

/obj/item/organ/external/proc/mend_fracture()
	if(robotic >= ORGAN_ROBOT)
		return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage * config.organ_health_multiplier)
		return 0	//will just immediately fracture again

	status &= ~ORGAN_BROKEN
	return 1

/obj/item/organ/external/proc/apply_splint(var/atom/movable/splint)
	if(!splinted)
		splinted = splint
		if(!applied_pressure)
			applied_pressure = splint
		return 1
	return 0

/obj/item/organ/external/proc/remove_splint()
	if(splinted)
		if(splinted.loc == src)
			splinted.dropInto(owner? owner.loc : src.loc)
		if(applied_pressure == splinted)
			applied_pressure = null
		splinted = null
		return 1
	return 0

/obj/item/organ/external/robotize(var/company, var/skip_prosthetics = 0, var/keep_organs = 0)

	if(robotic >= ORGAN_ROBOT)
		return

	..()

	if(company)
		model = company
		var/datum/robolimb/R = all_robolimbs[company]
		if(!R || (species && (species.name in R.species_cannot_use)))
			R = basic_robolimb
		if(R)
			force_icon = R.icon
			brute_mod *= R.robo_brute_mod
			burn_mod *= R.robo_burn_mod
			if(R.lifelike)
				robotic = ORGAN_LIFELIKE
				name = "[initial(name)]"
			else if(R.modular_bodyparts == MODULAR_BODYPART_PROSTHETIC)
				name = "prosthetic [initial(name)]"
			else
				name = "robotic [initial(name)]"
			desc = "[R.desc] It looks like it was produced by [R.company]."

	dislocated = -1
	cannot_break = 1
	min_broken_damage = ROBOLIMB_REPAIR_CAP //VOREStation Addition - Makes robotic limb damage scalable
	remove_splint()
	get_icon()
	unmutate()
	drop_sound = 'sound/items/drop/weldingtool.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'

	for(var/obj/item/organ/external/T in children)
		T.robotize(company, keep_organs = keep_organs)

	if(owner)

		if(!keep_organs)
			for(var/obj/item/organ/thing in internal_organs)
				if(istype(thing))
					if(thing.vital)
						continue
					internal_organs -= thing
					owner.internal_organs_by_name[thing.organ_tag] = null
					owner.internal_organs_by_name -= thing.organ_tag
					owner.internal_organs.Remove(thing)
					qdel(thing)

		while(null in owner.internal_organs)
			owner.internal_organs -= null
		owner.refresh_modular_limb_verbs()
	return 1

/obj/item/organ/external/proc/mutate()
	if(src.robotic >= ORGAN_ROBOT)
		return
	src.status |= ORGAN_MUTATED
	if(owner) owner.update_icons_body()

/obj/item/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	if(owner) owner.update_icons_body()

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return (brute_dam+burn_dam)	//could use max_damage?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/obj/item/organ/external/proc/is_usable()
	return !(status & (ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/external/proc/is_malfunctioning()
	return ((robotic >= ORGAN_ROBOT) && (brute_dam + burn_dam) >= min_broken_damage*0.83 && prob(brute_dam + burn_dam)) //VOREStation Edit - Makes robotic limb damage scalable

/obj/item/organ/external/proc/embed(var/obj/item/W, var/silent = 0)
	if(!owner || loc != owner)
		return
	if(!silent)
		owner.visible_message(span_danger("\The [W] sticks in the wound!"))
	implants += W
	owner.embedded_flag = 1
	add_verb(owner, /mob/proc/yank_out_object)
	owner.throw_alert("embeddedobject", /obj/screen/alert/embeddedobject)
	W.add_blood(owner)
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_from_inventory(W)
	W.loc = owner

/obj/item/organ/external/removed(var/mob/living/user, var/ignore_children = 0)
	if(!owner)
		return
	var/is_robotic = robotic >= ORGAN_ROBOT
	var/mob/living/carbon/human/victim = owner

	..()

	victim.bad_external_organs -= src

	for(var/atom/movable/implant in implants)
		//large items and non-item objs fall to the floor, everything else stays
		var/obj/item/I = implant
		if(istype(I) && I.w_class < ITEMSIZE_NORMAL)
			implant.loc = get_turf(victim.loc)
		else
			implant.loc = src
	implants.Cut()

	// Attached organs also fly off.
	if(!ignore_children)
		for(var/obj/item/organ/external/O in children)
			O.removed()
			if(O)
				O.loc = src
				for(var/obj/item/I in O.contents)
					I.loc = src

	// Grab all the internal giblets too.
	for(var/obj/item/organ/organ in internal_organs)
		organ.removed()
		organ.loc = src

	// Remove parent references
	parent?.children -= src
	parent = null

	release_restraints(victim)
	victim.organs -= src
	victim.organs_by_name[organ_tag] = null // Remove from owner's vars.

	status |= ORGAN_CUT_AWAY //Checked during surgeries to reattach it

	//Robotic limbs explode if sabotaged.
	if(is_robotic && sabotaged)
		victim.visible_message(
			span_danger("\The [victim]'s [src.name] explodes violently!"),\
			span_danger("Your [src.name] explodes!"),\
			span_danger("You hear an explosion!"))
		explosion(get_turf(owner),-1,-1,2,3)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, victim)
		spark_system.attach(owner)
		spark_system.start()
		spawn(10)
			qdel(spark_system)
		qdel(src)

	victim.refresh_modular_limb_verbs()
	victim.update_icons_body()

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(owner)
		if(type == "brute")
			owner.visible_message(span_danger("You hear a sickening cracking sound coming from \the [owner]'s [name]."),	\
			span_danger("Your [name] becomes a mangled mess!"),	\
			span_danger("You hear a sickening crack."))
		else
			owner.visible_message(span_danger("\The [owner]'s [name] melts away, turning into mangled mess!"),	\
			span_danger("Your [name] melts away!"),	\
			span_danger("You hear a sickening sizzle."))
	disfigured = 1

/obj/item/organ/external/proc/jostle_bone(force)
	if(!(status & ORGAN_BROKEN)) //intact bones stay still
		return
	if(brute_dam + force < min_broken_damage/5)	//no papercuts moving bones
		return
	if(internal_organs.len && prob(brute_dam + force))
		owner.custom_pain("A piece of bone in your [encased ? encased : name] moves painfully!", 50)
		var/obj/item/organ/I = pick(internal_organs)
		I.take_damage(rand(3,5))

/obj/item/organ/external/proc/get_wounds_desc()
	. = ""
	if(status & ORGAN_DESTROYED && !is_stump())
		. += "tear at [amputation_point] so severe that it hangs by a scrap of flesh"

	//Handle robotic and synthetic organ damage
	if(robotic >= ORGAN_ROBOT)
		var/LL //Life-Like, aka only show that it's robotic in heavy damage
		if(robotic >= ORGAN_LIFELIKE)
			LL = 1
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					. += "some [LL ? "cuts" : "dents"]"
				if(21 to INFINITY)
					. += "[LL ? pick("exposed wiring","torn-back synthflesh") : pick("a lot of dents","severe denting")]"

		if(brute_dam && burn_dam)
			. += " and "

		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					. += "some burns"
				if(21 to INFINITY)
					. += "[LL ? pick("roasted synth-flesh","melted internal wiring") : pick("many burns","scorched metal")]"

		if(open)
			if(brute_dam || burn_dam)
				. += " and "
			if(open == 1)
				. += "some exposed screws"
			else
				. += "an open panel"

		return

	//Normal organic organ damage
	var/list/wound_descriptors = list()
	if(open > 1)
		wound_descriptors["an open incision"] = 1
	else if (open)
		wound_descriptors["an incision"] = 1
	for(var/datum/wound/W in wounds)
		if(W.internal && !open) continue // can't see internal wounds
		var/this_wound_desc = W.desc

		if(W.damage_type == BURN && W.salved)
			this_wound_desc = "salved [this_wound_desc]"

		if(W.bleeding())
			this_wound_desc = "bleeding [this_wound_desc]"
		else if(W.bandaged)
			this_wound_desc = "bandaged [this_wound_desc]"

		if(W.germ_level > 600)
			this_wound_desc = "badly infected [this_wound_desc]"
		else if(W.germ_level > 330)
			this_wound_desc = "lightly infected [this_wound_desc]"

		if(wound_descriptors[this_wound_desc])
			wound_descriptors[this_wound_desc] += W.amount
		else
			wound_descriptors[this_wound_desc] = W.amount

	if(wound_descriptors.len)
		var/list/flavor_text = list()
		var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
		"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area") //note to self make this more robust
		for(var/wound in wound_descriptors)
			switch(wound_descriptors[wound])
				if(1)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a [wound]"
				if(2)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a pair of [wound]s"
				if(3 to 5)
					flavor_text += "several [wound]s"
				if(6 to INFINITY)
					flavor_text += "a ton of [wound]\s"
		return english_list(flavor_text)

// Returns a list of the clothing (not glasses) that are covering this part
/obj/item/organ/external/proc/get_covering_clothing(var/target_covering)	// target_covering checks for mouth/eye coverage
	var/list/covering_clothing = list()

	if(!target_covering)
		target_covering = src.body_part

	if(owner)
		var/list/protective_gear = list(owner.head, owner.wear_mask, owner.wear_suit, owner.w_uniform, owner.gloves, owner.shoes, owner.glasses)
		for(var/obj/item/clothing/gear in protective_gear)
			if(gear.body_parts_covered & target_covering)
				covering_clothing |= gear
			if(LAZYLEN(gear.accessories))
				for(var/obj/item/clothing/accessory/bling in gear.accessories)
					if(bling.body_parts_covered & src.body_part)
						covering_clothing |= bling

	return covering_clothing

/mob/living/carbon/human/proc/has_embedded_objects()
	. = 0
	for(var/obj/item/organ/external/L in organs)
		for(var/obj/item/I in L.implants)
			if(!istype(I,/obj/item/implant) && !istype(I,/obj/item/nif)) //VOREStation Add - NIFs
				return 1

/obj/item/organ/external/proc/is_hidden_by_sprite_accessory(var/clothing_only = FALSE)			// Clothing only will mean the check should only be used in places where we want to hide clothing icon, not organ itself.
	if(owner && owner.tail_style && owner.tail_style.hide_body_parts && (organ_tag in owner.tail_style.hide_body_parts))
		return 1
	if(clothing_only && markings.len)
		for(var/M in markings)
			var/datum/sprite_accessory/marking/mark = markings[M]["datum"]
			if(mark.hide_body_parts && (organ_tag in mark.hide_body_parts))
				return 1

#undef DROPLIMB_THRESHOLD_EDGE
#undef DROPLIMB_THRESHOLD_TEAROFF
#undef DROPLIMB_THRESHOLD_DESTROY
