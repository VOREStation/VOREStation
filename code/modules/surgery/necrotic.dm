	///Has multiple stages. At or past stage 1, peridaxon can immediately treat it.
	///0 = Not started
	///1 = Dead tissue removed (Can use bioregen)
	///2 = Flesh Rejuvenated (Can use hemostat)
	///3 = Flesh Rearranged (Can use bioregen)

///////////////////////////////////////////////////////////////
// Necrosis Surgery Step 1
///////////////////////////////////////////////////////////////

/datum/surgery_step/necrotic
	surgery_name = "Necrosis"
	priority = 1
	can_infect = 0 //It's already fully infected.
	blood_level = 0 //Already gone.

/datum/surgery_step/necrotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0

	if (target_zone == O_MOUTH || target_zone == O_EYES)
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0

	return affected && affected.open >= FLESH_RETRACTED && (affected.status & ORGAN_DEAD)

/datum/surgery_step/necrotic/fix_dead_tissue        //Debridement
	surgery_name = "Remove Dead Tissue"
	allowed_tools = list(
		/obj/item/surgical/scalpel = 100,        \
		/obj/item/material/knife = 75,    \
		/obj/item/material/shard = 50,         \
	)

	min_duration = 110
	max_duration = 160

/datum/surgery_step/necrotic/fix_dead_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open >= 1 && (affected.status & ORGAN_DEAD) && !affected.remove_necrosis

/datum/surgery_step/necrotic/fix_dead_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts cutting away necrotic tissue in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start cutting away necrotic tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts cutting away necrotic tissue in [target]'s [affected.name]", "cutting away necrotic issue in \the [affected.name]")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/necrotic/fix_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has cut away necrotic tissue in [target]'s [affected.name] with \the [tool]."), \
		span_notice("You have cut away necrotic tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("cuts away necrotic tissue in [target]'s [affected.name]", "cut away necrotic tissue in \the [affected.name]")
	affected.remove_necrosis = 1

/datum/surgery_step/necrotic/fix_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, slicing an artery inside [target]'s [affected.name]", "your hand slips, slicing an artery inside \the [affected.name]")
	affected.createwound(CUT, 20, 1)

///////////////////////////////////////////////////////////////
// Necrosis Surgery Step 2
///////////////////////////////////////////////////////////////
/datum/surgery_step/necrotic/treat_necrosis
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

/datum/surgery_step/necrotic/treat_necrosis/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/obj/item/reagent_containers/container = tool
	if(!istype(container))
		return FALSE
	if(!container.reagents.has_reagent(REAGENT_ID_PERIDAXON))
		return FALSE
	return ..() && affected.remove_necrosis >= 1

/datum/surgery_step/necrotic/treat_necrosis/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts applying medication to the affected tissue in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start applying medication to the affected tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts applying medication to the affected tissue in [target]'s [affected.name]", "applying medication to the affected tissue in \the [affected.name]")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 50)
	..()

/datum/surgery_step/necrotic/treat_necrosis/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD) //technically it's contact, but the reagents are being applied to internal tissue
	if (trans > 0)
		affected.germ_level = 0 //CURE THE INFECTION
		affected.status &= ~ORGAN_DEAD
		affected.owner.update_icons_body()

		user.visible_message(span_notice("[user] applies [trans] units of the solution to affected tissue in [target]'s [affected.name]."), \
			span_notice("You apply [trans] units of the solution to affected tissue in [target]'s [affected.name] with \the [tool]."))
		user.balloon_alert_visible("applies [trans] units of the solution to affected tissue in [target]'s [affected.name]", "applied [trans] units of the solution to afected tissue in [affected.name]")
		affected.remove_necrosis = 0

/datum/surgery_step/necrotic/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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
// Necrosis Surgery Alternative Step 2
///////////////////////////////////////////////////////////////

/datum/surgery_step/necrotic/rejuvenate_dead_tissue
	surgery_name = "Rejuvenate Dead Tissue"
	allowed_tools = list(/obj/item/surgical/bioregen = 100)

	min_duration = 110
	max_duration = 160

/datum/surgery_step/necrotic/rejuvenate_dead_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.remove_necrosis == 1

/datum/surgery_step/necrotic/rejuvenate_dead_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts rejuvenating necrotic tissue in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start rejuvenating necrotic tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts rejuvenating necrotic tissue in [target]'s [affected.name]", "rejuvenating necrotic tissue in \the [affected.name]")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/necrotic/rejuvenate_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has rejuvenated necrotic tissue in [target]'s [affected.name] with \the [tool]."), \
		span_notice("You have rejuvenated necrotic tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("rejuvenated necrotic tissue in [target]'s [affected.name]", "rejuvenated necrotic tissue in \the [affected.name]")
	affected.remove_necrosis = 2

/datum/surgery_step/necrotic/rejuvenate_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, bruising the muscle inside of [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips, bruising the muscle inside of [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, bruising the muscle inside of [target]'s [affected.name]", "your hand slips, bruising the muscle inside of \the [affected.name]")
	affected.createwound(BRUISE, 20, 1)

///////////////////////////////////////////////////////////////
// Necrosis Surgery Step 3
///////////////////////////////////////////////////////////////
/datum/surgery_step/necrotic/rearrange_dead_tissue
	surgery_name = "Rearrange Tissue"
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,	\
		/obj/item/stack/cable_coil = 75, 	\
		/obj/item/assembly/mousetrap = 20
	)
	min_duration = 110
	max_duration = 160

/datum/surgery_step/necrotic/rearrange_dead_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.remove_necrosis == 2

/datum/surgery_step/necrotic/rearrange_dead_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts rearranging rejuvinated tissue in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start rearranging rejuvinated tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts rearranging rejuvinated tissue in [target]'s [affected.name]", "rearranging rejuvinated tissue in \the [affected.name]")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/necrotic/rearrange_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has rearranging rejuvinated tissue in [target]'s [affected.name] with \the [tool]."), \
		span_notice("You have rearranging rejuvinated tissue in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("rearranging rejuvinated tissue in [target]'s [affected.name]", "rearranging rejuvinated tissue in \the [affected.name]")
	affected.remove_necrosis = 3

/datum/surgery_step/necrotic/rearrange_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, slicing the fresh tissue on [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips, slicing the fresh tissue on [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, slicing the fresh tissue on [target]'s [affected.name]", "your hand slips, slicing the fresh tissue on \the [affected.name]")
	affected.createwound(CUT, 10, 1)

///////////////////////////////////////////////////////////////
// Necrosis Surgery Step 4
///////////////////////////////////////////////////////////////
/datum/surgery_step/necrotic/fix_necrotic_vessel
	surgery_name = "Reroute Blood Vessels"
	allowed_tools = list(
	/obj/item/surgical/bioregen = 100, \
	/obj/item/surgical/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)

	min_duration = 110
	max_duration = 160

/datum/surgery_step/necrotic/fix_necrotic_vessel/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.remove_necrosis == 3

/datum/surgery_step/necrotic/fix_necrotic_vessel/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts rerouting the vessels in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start rerouting the vessels in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts rerouting the vessels in [target]'s [affected.name]", "rerouting vessels in \the [affected.name]")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/necrotic/fix_necrotic_vessel/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has rerouted the vessels in [target]'s [affected.name] with \the [tool]."), \
	span_notice("You have rerouted the vessels in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("rerouted the vessels in [target]'s [affected.name]", "rerouted the vessels in \the [affected.name]")

	//the actual heal stuffs
	affected.germ_level = 0
	affected.status &= ~ORGAN_DEAD
	affected.owner.update_icons_body()
	affected.remove_necrosis = 0

/datum/surgery_step/necrotic/fix_necrotic_vessel/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, slicing the fresh tissue on [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips, slicing the fresh tissue on [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, slicing the fresh tissue on [target]'s [affected.name]", "your hand slips, slicing the fresh tissue on \the [affected.name]")
	affected.createwound(CUT, 10, 1)
