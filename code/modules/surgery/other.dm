//Procedures in this file: Inernal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////
// Internal Bleeding Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/fix_vein
	surgery_name = "Fix Vein"
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
	user.visible_message(span_filter_notice("[user] starts patching the damaged vein in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start patching the damaged vein in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts patching the damaged ven in [target]'s [affected.name]", "patching the damaged vein in \the [affected.name]")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has patched the damaged vein in [target]'s [affected.name] with \the [tool]."), \
		span_notice("You have patched the damaged vein in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("patches the damaged vein in [target]'s [affected.name]", "patched the damaged vein in \the [affected.name]")

	for(var/datum/wound/W in affected.wounds) if(W.internal)
		affected.wounds -= W
		affected.update_damages()
	if (ishuman(user) && prob(40)) user:bloody_hands(target, 0)

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!") , \
	span_danger("Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"))
	user.balloon_alert_visible("slips, smearing [tool] in the incision in [target]'s [affected.name]", "your hand slips, smearing [tool] in the incisiom in [affected.name]")
	affected.take_damage(5, 0)

///////////////////////////////////////////////////////////////
// Necrosis Surgery Step 1
///////////////////////////////////////////////////////////////
/datum/surgery_step/fix_dead_tissue        //Debridement
	surgery_name = "Remove Dead Tissue"
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
	user.visible_message(span_filter_notice("[user] starts cutting away necrotic tissue in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start cutting away necrotic tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts cutting away necrotic tissue in [target]'s [affected.name]", "cutting away necrotic issue in \the [affected.name]")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/fix_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has cut away necrotic tissue in [target]'s [affected.name] with \the [tool]."), \
		span_notice("You have cut away necrotic tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("cuts away necrotic tissue in [target]'s [affected.name]", "cut away necrotic tissue in \the [affected.name]")
	affected.open = 3

/datum/surgery_step/fix_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, slicing an artery inside [target]'s [affected.name]", "your hand slips, slicing an artery inside \the [affected.name]")
	affected.createwound(CUT, 20, 1)

///////////////////////////////////////////////////////////////
// Necrosis Surgery Step 2
///////////////////////////////////////////////////////////////
/datum/surgery_step/treat_necrosis
	surgery_name = "Treat Necrosis"
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
	if(!container.reagents.has_reagent(REAGENT_ID_PERIDAXON))
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
	user.visible_message(span_filter_notice("[user] starts applying medication to the affected tissue in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start applying medication to the affected tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts applying medication to the affected tissue in [target]'s [affected.name]", "applying medication to the affected tissue in \the [affected.name]")
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

		user.visible_message(span_notice("[user] applies [trans] units of the solution to affected tissue in [target]'s [affected.name]."), \
			span_notice("You apply [trans] units of the solution to affected tissue in [target]'s [affected.name] with \the [tool]."))
		user.balloon_alert_visible("applies [trans] units of the solution to affected tissue in [target]'s [affected.name]", "applied [trans] units of the solution to afected tissue in [affected.name]")

/datum/surgery_step/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

	user.visible_message(span_danger("[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!") , \
	span_danger("Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"))
	user.balloon_alert_visible("slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name]",
	"your hand slips, applying [trans] units of the solution to the wrong place in \the [affected.name]")

	//no damage or anything, just wastes medicine

///////////////////////////////////////////////////////////////
// Hardsuit Removal Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/hardsuit
	surgery_name = "Remove Hardsuit"
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
	user.visible_message(span_filter_notice("[user] starts cutting through the support systems of \the [rig] on [target] with \the [tool].") , \
	span_filter_notice("You start cutting through the support systems of \the [rig] on [target] with \the [tool]."))
	user.balloon_alert_visible("starts cutting through the support systems of \the [rig] on [target]", "cutting through the support systems of \the [rig] on [target]")
	..()

/datum/surgery_step/hardsuit/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		rig = target.belt
		if(!istype(rig))
			return
	rig.cut_suit()
	user.visible_message(span_notice("[user] has cut through the support systems of \the [rig] on [target] with \the [tool]."), \
		span_notice("You have cut through the support systems of \the [rig] on [target] with \the [tool]."))
	user.balloon_alert_visible("cuts through the support systems of \the [rig] on [target]", "cut through the support systems of \the [rig]")

/datum/surgery_step/hardsuit/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_danger("[user]'s [tool] can't quite seem to get through the metal..."), \
	span_danger("\The [tool] can't quite seem to get through the metal. It's weakening, though - try again."))
	user.balloon_alert_visible("[tool] can't quite seem to get through the metal", "\the [tool] can't quite seem to get through the metal.")

///////////////////////////////////////////
//			De-Husking Surgery			//
/////////////////////////////////////////

/datum/surgery_status/
	var/dehusk = 0

/datum/surgery_step/dehusk/
	surgery_name = "Dehusk"
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
	surgery_name = "Create Structure"
	allowed_tools = list(
		/obj/item/surgical/bioregen = 100
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/structinitial/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 0

/datum/surgery_step/dehusk/structinitial/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You begin to create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("begins to create a fleshy mesh over gaps in [target]'s flesh.", "creating a flesh mesh over gaps")
	..()

/datum/surgery_step/dehusk/structinitial/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] creates a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("creates a fleshy mesh over gaps in [target]'s flesh", "created a fleshy mesh over gaps in the flesh")
	target.op_stage.dehusk = 1
	..()

/datum/surgery_step/dehusk/structinitial/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, and the mesh falls, with \the [tool] scraping [target]'s body."), \
	span_danger("Your hand slips, and the mesh falls, with \the [tool] scraping [target]'s body."))
	user.balloon_alert_visible("slips, the mesh falls and scrapes [target]'s body", "your hand slips, the mesh falls and scrapes the body")
	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()

/datum/surgery_step/dehusk/relocateflesh
	surgery_name = "Relocate Flesh"
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,	\
		/obj/item/stack/cable_coil = 75, 	\
		/obj/item/assembly/mousetrap = 20
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/relocateflesh/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 1

/datum/surgery_step/dehusk/relocateflesh/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to relocate some of [target]'s flesh with \the [tool], using it to fill in gaps."), \
	span_notice("You begin to relocate some of [target]'s flesh with \the [tool], using it to fill in gaps."))
	user.balloon_alert_visible("begins relocating [target]'s flesh", "relocating the flesh")
	..()

/datum/surgery_step/dehusk/relocateflesh/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] relocates some of [target]'s flesh with \the [tool], using it to fill in gaps."), \
	span_notice("You relocate some of [target]'s flesh with \the [tool], using it to fill in gaps."))
	user.balloon_alert_visible("relocates [target]'s flesh", "relocated the flesh")
	target.op_stage.dehusk = 2
	..()

/datum/surgery_step/dehusk/relocateflesh/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user] accidentally rips a massive chunk out of [target]'s flesh with \the [tool], causing massive damage."), \
	span_danger("You accidentally rip a massive chunk out of [target]'s flesh with \the [tool], causing massive damage."))
	user.balloon_alert_visible("accidentally rips a massive chunk out of [target]'s flesh, causing massive damage",
	"you accidentally rip a massive chunk out of the flesh, causing massive damage")
	affected.createwound(CUT, 25)
	affected.createwound(BRUISE, 10)
	..()

/datum/surgery_step/dehusk/structfinish
	surgery_name = "Finish Structure"
	allowed_tools = list(
		/obj/item/surgical/bioregen = 100, \
		/obj/item/surgical/FixOVein = 30
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/structfinish/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 2

/datum/surgery_step/dehusk/structfinish/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(istype(tool,/obj/item/surgical/bioregen))
		user.visible_message(span_notice("[user] begins to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You begin to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool]."))
		user.balloon_alert_visible("begins recreating blood vessels and filing gaps in [target]'s flesh", "recreating blood vessels and filling gaps in the flesh")
	else if(istype(tool,/obj/item/surgical/FixOVein))
		user.visible_message(span_notice("[user] attempts to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You attempt to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool]."))
		user.balloon_alert_visible("attempts to recreate blood vessesl and fill the gaps in [target]'s flesh", "attempting to recreate blood vessels and fill gaps in the flesh")
	..()

/datum/surgery_step/dehusk/structfinish/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] finishes recreating the missing biological structures and filling in gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You finish recreating the missing biological structures and filling in gaps in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("recreates the missing biological structures and gaps in [target]'s flesh", "recreated the missing bological structures and gaps in the flesh")
	target.op_stage.dehusk = 0
	target.mutations.Remove(HUSK)
	target.status_flags &= ~DISFIGURED
	target.update_icons_body()
	..()

/datum/surgery_step/dehusk/structfinish/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(tool,/obj/item/surgical/bioregen))
		user.visible_message(span_danger("[user]'s hand slips, causing \the [tool] to scrape [target]'s body."), \
	span_danger("Your hand slips, causing \the [tool] to scrape [target]'s body."))
		user.balloon_alert_visible("slips, scraping [target]'s body", "you slip, scraping the body.")
	else if(istype(tool,/obj/item/surgical/FixOVein))
		user.visible_message(span_danger("[user] fails to finish the structure over the gaps in [target]'s flesh, doing more damage than good."), \
	span_danger("You fail to finish the structure over the gaps in [target]'s flesh, doing more damage than good."))
		user.balloon_alert_visible("fails to finish the structure in [target]'s flesh, doing more damage", "you fail to finish the structur, doing more damage")

	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()

/datum/surgery_step/internal/detoxify
	surgery_name = "Detoxify"
	blood_level = 1
	allowed_tools = list(/obj/item/surgical/bioregen=100)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/internal/detoxify/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_TORSO && (target.toxloss > 25 || target.oxyloss > 25)

/datum/surgery_step/internal/detoxify/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to pull toxins from, and restore oxygen to [target]'s musculature and organs with \the [tool]."), \
	span_notice("You begin to pull toxins from, and restore oxygen to [target]'s musculature and organs with \the [tool]."))
	user.balloon_alert_visible("begins pulling from, and restoring oxygen to [target]'s organs", "pulling toxins from and restoring oxygen to the organs")
	..()

/datum/surgery_step/internal/detoxify/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] finishes pulling toxins from, and restoring oxygen to [target]'s musculature and organs with \the [tool]."), \
	span_notice("You finish pulling toxins from, and restoring oxygen to [target]'s musculature and organs with \the [tool]."))
	user.balloon_alert_visible("finishes pulling toxins and restoring oxygen to [target]'s organs", "pulled toxins from and restored oxygen to the organs")
	if(target.toxloss>25)
		target.adjustToxLoss(-20)
	if(target.oxyloss>25)
		target.adjustOxyLoss(-20)
	..()

/datum/surgery_step/internal/detoxify/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, failing to finish the surgery, and damaging [target] with \the [tool]."), \
	span_danger("Your hand slips, failing to finish the surgery, and damaging [target] with \the [tool]."))
	user.balloon_alert_visible("slips, failing to finish the surgery and damaging [target]", "your hand slips, failing to finish the surgery and damaging [target]")
	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()
