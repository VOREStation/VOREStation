/obj/item/endoware
	name = "Endoware Implant"
	desc = "A device meant to be installed under the flesh and attached to either someone's nerves or a synthetic's internal systems. Doesn't do you much good outside, though."
	icon = 'code/modules/cybernetics/assets/endoware.dmi'
	icon_state = "implant"

	//what organs we're allowed to be in - can be a list or single value. by default can be installed in any organ or limb
	var/allowed_in = BP_ALL // O_STANDARD
	var/can_be_implanted = FALSE //true if we want implanters to allow

	//what we can be damaged by
	var/damage_flags = (ENDOWARE_DAMAGEABLE_BRUTE | ENDOWARE_DAMAGEABLE_BURN | ENDOWARE_DAMAGEABLE_ALL)
	var/installed_in //used for saving. it's a slot, not an obj.

	//if we can save it or not. if this is var edited to be true in round (ae, event reward, whatever) people can still spawn with it
	var/allowed_to_save = FALSE
	//can't be changed at runtime, but it's a sanity check to see if we have something we REALLY shouldn't have. ae, admin implants (if ever made) or etc.
	var/allowed_to_spawn = FALSE
	var/list/commands_to_run = list() //added to the command queue! can be modified w/ a multitool before install
	var/list/managed_components = list()

	var/mob/living/carbon/host //who we're embedded in
	var/obj/item/organ/home //what we're embedded in

	var/is_activatable = FALSE //whether it shows up in the endoware activation menu or not
	var/image/radial_image //only generated if is_activatable
	var/image_text = "FSDFSD"

	health = 30 //fsdfsd

	maptext_height = 32
	maptext_width = 32

/obj/item/endoware/Initialize(mapload)
	. = ..()
	if(is_activatable)
		init_radial_image()

/obj/item/endoware/verb/debug_install_remove_me()
	set category = "Object"
	set src in range(1)

	var/list/select_list = list()
	select_list += BP_ALL
	select_list += O_STANDARD
	var/fsdfsd = tgui_input_list(usr, "You want...","waow", select_list)
	if(iscarbon(usr))
		install_in(usr,fsdfsd)



/obj/item/endoware/proc/install_in(var/mob/living/carbon/host, var/target = BP_TORSO)
	if(!(target in allowed_in))
		to_chat(world,"DEBUG: not allowed to install [target] in [host]!")
		return FALSE

	var/obj/item/organ/targetOrgan

	/*
TODO:
	* Species check to see if they're allowed to be chromed up
	* Limb check to see if it's compatible with the implant & person
	*/

	if(target in O_STANDARD) //external organs
		targetOrgan = LAZYACCESS(host.internal_organs_by_name,target)

	if(target in BP_ALL) //internal organs
		targetOrgan = LAZYACCESS(host.organs_by_name,target)

	if(targetOrgan)
		installed_in = target
		forceMove(targetOrgan)
		post_install(targetOrgan) //get the
		SEND_SIGNAL(src, COMSIG_ENDOWARE_INSTALLED)
		return TRUE

	to_chat(world,"DEBUG: not able to find organ [target] in [host]!")
	return FALSE



/obj/item/endoware/proc/damage_implant(damage)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src,COMSIG_ENDOWARE_DAMAGE_TAKEN)

/obj/item/endoware/Destroy()
	if(host)
		dissolve_human_components(host)
		dissolve_human_signals(host)
		host = null

	if(home)
		dissolve_organ_signals(home)
		home = null
	. = ..()


/obj/item/endoware/proc/host_took_damage(var/datum/source, damage, damagetype, def_zone) //TODO
	to_chat(world,"WOW! DAMAGE: [damage]| [damagetype]| [def_zone]")
	if(damage_matches_bitflag(damagetype,damage_flags,host))
		return
	else
		return

/obj/item/endoware/proc/damage_matches_bitflag(var/damageType,var/compare_against,var/mob/living/carbon/human/comparing)
	var/list/converted = list( BRUTE = (ENDOWARE_DAMAGEABLE_BRUTE),
		BURN = (ENDOWARE_DAMAGEABLE_BURN),
		TOX = (ENDOWARE_DAMAGEABLE_TOXIN),
		OXY = (ENDOWARE_DAMAGEABLE_OXYLOSS),
		CLONE = (ENDOWARE_DAMAGEABLE_CLONE),
		HALLOSS = (ENDOWARE_DAMAGEABLE_HALLOSS),
		ELECTROCUTE = (ENDOWARE_DAMAGEABLE_ELECTRO),
		BIOACID = (comparing.isSynthetic() ? (ENDOWARE_DAMAGEABLE_BURN) : (ENDOWARE_DAMAGEABLE_TOXIN)),
		SEARING = (ENDOWARE_DAMAGEABLE_CLONE | ENDOWARE_DAMAGEABLE_BURN),
		ELECTROMAG = (ENDOWARE_DAMAGEABLE_ELECTROMAG)
	)
	var/compare_to = converted[damageType]
	return (compare_against & compare_to)

/* REGISTERING / DEREGISTERING TO/FROM SOMEONE/A ORGAN*/

/obj/item/endoware/proc/post_install(var/obj/item/organ/new_location)
	SHOULD_CALL_PARENT(TRUE)
	ASSERT(loc == new_location)
	ASSERT(ishuman(loc.loc)) //can't install on a standalone limb.

	added_to_organ(new_location)
	added_to_human(loc.loc)

/obj/item/endoware/proc/uninstalled(var/mob/living/carbon/host)
	SHOULD_CALL_PARENT(TRUE)
	ASSERT(ishuman(host))
	SEND_SIGNAL(src,COMSIG_ENDOWARE_UNINSTALLED)


/obj/item/endoware/proc/removed_from_human(var/mob/living/carbon/human/human) //either we were uninstalled, organ got removed, or the limb got blown off
	ASSERT(host == human)
	to_chat(world,"REMOVING FROM HUMAN!")
	dissolve_human_components(host)
	dissolve_human_signals(host)
	host.installed_endoware -= src
	host = null

/obj/item/endoware/proc/added_to_human(var/mob/living/carbon/human/human)
	ASSERT(host == null) //if we weren't removed from something uh oh!
	host = human
	build_human_signals(host)
	build_human_components(host)
	host.installed_endoware |= src

/obj/item/endoware/proc/build_organ_signals(var/obj/item/organ/target)
	RegisterSignal(target,COMSIG_ORGAN_INSERTED,PROC_REF(human_installed_organ))
	RegisterSignal(target,COMSIG_PARENT_QDELETING,PROC_REF(organ_destroyed))

/obj/item/endoware/proc/dissolve_organ_signals(var/obj/item/organ/target)
	UnregisterSignal(target,COMSIG_ORGAN_INSERTED)
	UnregisterSignal(target,COMSIG_PARENT_QDELETING)

/obj/item/endoware/proc/organ_destroyed(var/datum/source,var/force)
	if(force)
		qdel(src)
		return
	forceMove(get_turf(src))
	if(home) //we really should have this
		removed_from_organ(home)

/obj/item/endoware/proc/added_to_organ(var/obj/item/organ/target)
	ASSERT(home == null) //we shouldn't have a home yet!
	home = target
	build_organ_signals(target)

/obj/item/endoware/proc/removed_from_organ(var/obj/item/organ/target)
	ASSERT(target == home)
	if(host)
		removed_from_human(host)

	dissolve_organ_signals(target)
	home = null

/obj/item/endoware/proc/build_human_signals(var/mob/living/carbon/target)
	SHOULD_CALL_PARENT(TRUE)
	RegisterSignal(target,COMSIG_CARBON_LOSE_ORGAN,PROC_REF(human_lost_organ))
	RegisterSignal(target,COMSIG_MOB_APPLY_DAMGE,PROC_REF(host_took_damage))

/obj/item/endoware/proc/dissolve_human_signals(var/mob/living/carbon/target)
	UnregisterSignal(target,COMSIG_CARBON_LOSE_ORGAN)
	UnregisterSignal(target,COMSIG_MOB_APPLY_DAMGE)

/obj/item/endoware/proc/human_lost_organ(var/datum/source, var/obj/item/organ/lostorgan)
	ASSERT(source == host)
	to_chat(world,"HUMAN LOST ORGAN:[lostorgan]")
	if(lostorgan == home)
		if(host)
			removed_from_human(host)

/obj/item/endoware/proc/human_installed_organ(var/mob/living/carbon/human/owner)
	added_to_human(owner)

// for the most part, these are where the magic happens. nearly 100% of the behavior done by these should be component driven! Unless it's simple shit, anyway.
/obj/item/endoware/proc/build_human_components(var/mob/living/carbon/human/human)
	return

/obj/item/endoware/proc/dissolve_human_components(var/mob/living/carbon/human/human)
	return
/* ACTIVATION */

//check ./human.dm for usage
/obj/item/endoware/proc/attempt_activate()
	if(can_activate() && is_activatable)
		activate()

/obj/item/endoware/proc/activate(var/external)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ENDOWARE_ACTIVATE)


/obj/item/endoware/proc/init_radial_image()
	radial_image = image(icon = src.icon, icon_state = src.icon_state) //this can be more complicated, this is just a baseline.

/obj/item/endoware/proc/activated_externally()
	activate(TRUE)

/obj/item/endoware/proc/can_activate()
	return TRUE //if we return false here when it's is_activatable, we assume we want to be "grey'd out"


/obj/item/endoware/proc/update_radial_image()
	if(radial_image == null)  return
	if(can_activate())
		radial_image.color = null
	else
		radial_image.color = "#5B5B5B"
	radial_image.maptext = image_text
