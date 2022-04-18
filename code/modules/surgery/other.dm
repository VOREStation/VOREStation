//Procedures in this file: Inernal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////
// Internal Bleeding Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/fix_vein
	priority = 2
	allowed_tools = list(
	/obj/item/surgical/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90

/datum/surgery_step/fix_vein/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected) return
	if(coverage_check(user, target, affected, tool))
		return 0
	var/internal_bleeding = 0
	for(var/datum/wound/W in affected.wounds) if(W.internal)
		internal_bleeding = 1
		break

	return affected.open == (affected.encased ? 3 : 2) && internal_bleeding

/datum/surgery_step/fix_vein/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts patching the damaged vein in [target]'s [affected.name] with \the [tool]." , \
	"You start patching the damaged vein in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has patched the damaged vein in [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have patched the damaged vein in [target]'s [affected.name] with \the [tool].</span>")

	for(var/datum/wound/W in affected.wounds) if(W.internal)
		affected.wounds -= W
		affected.update_damages()
	if (ishuman(user) && prob(40)) user:bloody_hands(target, 0)

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='danger'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
	affected.take_damage(5, 0)

///////////////////////////////////////////////////////////////
// Necrosis Surgery Step 1
///////////////////////////////////////////////////////////////
/datum/surgery_step/fix_dead_tissue        //Debridement
	priority = 2
	allowed_tools = list(
		/obj/item/surgical/scalpel = 100,        \
		/obj/item/material/knife = 75,    \
		/obj/item/material/shard = 50,         \
	)

	can_infect = 1
	blood_level = 1

	min_duration = 110
	max_duration = 160

/datum/surgery_step/fix_dead_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0

	if (target_zone == O_MOUTH || target_zone == O_EYES)
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0

	return affected && affected.open >= 2 && (affected.status & ORGAN_DEAD)

/datum/surgery_step/fix_dead_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts cutting away necrotic tissue in [target]'s [affected.name] with \the [tool]." , \
	"You start cutting away necrotic tissue in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/fix_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has cut away necrotic tissue in [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have cut away necrotic tissue in [target]'s [affected.name] with \the [tool].</span>")
	affected.open = 3

/datum/surgery_step/fix_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='danger'>Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(CUT, 20, 1)

///////////////////////////////////////////////////////////////
// Necrosis Surgery Step 2
///////////////////////////////////////////////////////////////
/datum/surgery_step/treat_necrosis
	priority = 2
	allowed_tools = list(
		/obj/item/reagent_containers/dropper = 100,
		/obj/item/reagent_containers/glass/bottle = 75,
		/obj/item/reagent_containers/glass/beaker = 75,
		/obj/item/reagent_containers/spray = 50,
		/obj/item/reagent_containers/glass/bucket = 50,
	)

	can_infect = 0
	blood_level = 0

	min_duration = 50
	max_duration = 60

/datum/surgery_step/treat_necrosis/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!istype(tool, /obj/item/reagent_containers))
		return 0

	var/obj/item/reagent_containers/container = tool
	if(!container.reagents.has_reagent("peridaxon"))
		return 0

	if(!hasorgans(target))
		return 0

	if (target_zone == O_MOUTH || target_zone == O_EYES)
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	return affected && affected.open == 3 && (affected.status & ORGAN_DEAD)

/datum/surgery_step/treat_necrosis/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts applying medication to the affected tissue in [target]'s [affected.name] with \the [tool]." , \
	"You start applying medication to the affected tissue in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 50)
	..()

/datum/surgery_step/treat_necrosis/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD) //technically it's contact, but the reagents are being applied to internal tissue
	if (trans > 0)
		affected.status &= ~ORGAN_DEAD
		affected.owner.update_icons_body()

		user.visible_message("<span class='notice'>[user] applies [trans] units of the solution to affected tissue in [target]'s [affected.name].</span>", \
			"<span class='notice'>You apply [trans] units of the solution to affected tissue in [target]'s [affected.name] with \the [tool].</span>")

/datum/surgery_step/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

	user.visible_message("<span class='danger'>[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!</span>" , \
	"<span class='danger'>Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!</span>")

	//no damage or anything, just wastes medicine

///////////////////////////////////////////////////////////////
// Hardsuit Removal Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/hardsuit
	allowed_tools = list(
		/obj/item/weldingtool = 80,
		/obj/item/surgical/circular_saw = 60,
		/obj/item/pickaxe/plasmacutter = 100
		)
	req_open = 0

	can_infect = 0
	blood_level = 0

	min_duration = 120
	max_duration = 180

/datum/surgery_step/hardsuit/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(target))
		return 0
	if(istype(tool,/obj/item/weldingtool))
		var/obj/item/weldingtool/welder = tool
		if(!welder.isOn() || !welder.remove_fuel(1,user))
			return 0
	return (target_zone == BP_TORSO) && ((istype(target.back, /obj/item/rig) && !(target.back.canremove)) || (istype(target.belt, /obj/item/rig) && !(target.belt.canremove)))

/datum/surgery_step/hardsuit/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		rig = target.belt
		if(!istype(rig))
			return
	user.visible_message("[user] starts cutting through the support systems of \the [rig] on [target] with \the [tool]." , \
	"You start cutting through the support systems of \the [rig] on [target] with \the [tool].")
	..()

/datum/surgery_step/hardsuit/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		rig = target.belt
		if(!istype(rig))
			return
	rig.cut_suit()
	user.visible_message("<span class='notice'>[user] has cut through the support systems of \the [rig] on [target] with \the [tool].</span>", \
		"<span class='notice'>You have cut through the support systems of \the [rig] on [target] with \the [tool].</span>")

/datum/surgery_step/hardsuit/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='danger'>[user]'s [tool] can't quite seem to get through the metal...</span>", \
	"<span class='danger'>\The [tool] can't quite seem to get through the metal. It's weakening, though - try again.</span>")

///////////////////////////////////////////
//			De-Husking Surgery			//
/////////////////////////////////////////

/datum/surgery_status/
	var/dehusk = 0

/datum/surgery_step/dehusk/
	priority = 1
	can_infect = 0
	blood_level = 1

/datum/surgery_step/dehusk/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected || (affected.robotic >= ORGAN_ROBOT))
		return 0
	if(coverage_check(user,target,affected,tool))
		return 0
	return target_zone == BP_TORSO && (HUSK in target.mutations)

/datum/surgery_step/dehusk/structinitial
	allowed_tools = list(
		/obj/item/weapon/surgical/bioregen = 100
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/structinitial/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 0

/datum/surgery_step/dehusk/structinitial/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] begins to create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool].</span>", \
	"<span class='notice'>You begin to create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool].</span>")
	..()

/datum/surgery_step/dehusk/structinitial/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] creates a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool].</span>", \
	"<span class='notice'>You create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool].</span>")
	target.op_stage.dehusk = 1
	..()

/datum/surgery_step/dehusk/structinitial/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, and the mesh falls, with \the [tool] scraping [target]'s body.</span>", \
	"<span class='danger'>Your hand slips, and the mesh falls, with \the [tool] scraping [target]'s body.</span>")
	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()

/datum/surgery_step/dehusk/relocateflesh
	allowed_tools = list(
		/obj/item/weapon/surgical/hemostat = 100,	\
		/obj/item/stack/cable_coil = 75, 	\
		/obj/item/device/assembly/mousetrap = 20
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/relocateflesh/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 1

/datum/surgery_step/dehusk/relocateflesh/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] begins to relocate some of [target]'s flesh with \the [tool], using it to fill in gaps.</span>", \
	"<span class='notice'>You begin to relocate some of [target]'s flesh with \the [tool], using it to fill in gaps.</span>")
	..()

/datum/surgery_step/dehusk/relocateflesh/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] relocates some of [target]'s flesh with \the [tool], using it to fill in gaps.</span>", \
	"<span class='notice'>You relocate some of [target]'s flesh with \the [tool], using it to fill in gaps.</span>")
	target.op_stage.dehusk = 2
	..()

/datum/surgery_step/dehusk/relocateflesh/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user] accidentally rips a massive chunk out of [target]'s flesh with \the [tool], causing massive damage.</span>", \
	"<span class='danger'>You accidentally rip a massive chunk out of [target]'s flesh with \the [tool], causing massive damage.</span>")
	affected.createwound(CUT, 25)
	affected.createwound(BRUISE, 10)
	..()

/datum/surgery_step/dehusk/structfinish
	allowed_tools = list(
		/obj/item/weapon/surgical/bioregen = 100, \
		/obj/item/weapon/surgical/FixOVein = 30
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/structfinish/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 2

/datum/surgery_step/dehusk/structfinish/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(istype(tool,/obj/item/weapon/surgical/bioregen))
		user.visible_message("<span class='notice'>[user] begins to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool].</span>", \
	"<span class='notice'>You begin to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool].</span>")
	else if(istype(tool,/obj/item/weapon/surgical/FixOVein))
		user.visible_message("<span class='notice'>[user] attempts to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool].</span>", \
	"<span class='notice'>You attempt to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool].</span>")
	..()

/datum/surgery_step/dehusk/structfinish/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] finishes recreating the missing biological structures and filling in gaps in [target]'s flesh with \the [tool].</span>", \
	"<span class='notice'>You finish recreating the missing biological structures and filling in gaps in [target]'s flesh with \the [tool].</span>")
	target.op_stage.dehusk = 0
	target.mutations.Remove(HUSK)
	target.status_flags &= ~DISFIGURED
	target.update_icons_body()
	..()

/datum/surgery_step/dehusk/structfinish/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(tool,/obj/item/weapon/surgical/bioregen))
		user.visible_message("<span class='danger'>[user]'s hand slips, causing \the [tool] to scrape [target]'s body.</span>", \
	"<span class='danger'>Your hand slips, causing \the [tool] to scrape [target]'s body.</span>")
	else if(istype(tool,/obj/item/weapon/surgical/FixOVein))
		user.visible_message("<span class='danger'>[user] fails to finish the structure over the gaps in [target]'s flesh, doing more damage than good.</span>", \
	"<span class='danger'>You fail to finish the structure over the gaps in [target]'s flesh, doing more damage than good.</span>")
	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()

/datum/surgery_step/internal/detoxify
	blood_level = 1
	allowed_tools = list(/obj/item/weapon/surgical/bioregen=100)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/internal/detoxify/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_TORSO && (target.toxloss > 25 || target.oxyloss > 25)

/datum/surgery_step/internal/detoxify/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] begins to pull toxins from, and restore oxygen to [target]'s musculature and organs with \the [tool].</span>", \
	"<span class='notice'>You begin to pull toxins from, and restore oxygen to [target]'s musculature and organs with \the [tool].</span>")
	..()

/datum/surgery_step/internal/detoxify/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] finishes pulling toxins from, and restoring oxygen to [target]'s musculature and organs with \the [tool].</span>", \
	"<span class='notice'>You finish pulling toxins from, and restoring oxygen to [target]'s musculature and organs with \the [tool].</span>")
	if(target.toxloss>25)
		target.adjustToxLoss(-20)
	if(target.oxyloss>25)
		target.adjustOxyLoss(-20)
	..()

/datum/surgery_step/internal/detoxify/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, failing to finish the surgery, and damaging [target] with \the [tool].</span>", \
	"<span class='danger'>Your hand slips, failing to finish the surgery, and damaging [target] with \the [tool].</span>")
	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()