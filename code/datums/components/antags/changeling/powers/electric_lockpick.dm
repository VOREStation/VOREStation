/datum/power/changeling/electric_lockpick
	name = "Electric Lockpick"
	desc = "We discreetly evolve a finger to be able to send a small electric charge.  \
	We can open most electrical locks, but it will be obvious when we do so."
	helptext = "Use the ability, then touch something that utilizes an electrical locking system, to open it.  Each use costs 10 chemicals."
	ability_icon_state = "ling_electric_lockpick"
	genomecost = 3
	verbpath = /mob/proc/changeling_electric_lockpick

//Emag-lite
/mob/proc/changeling_electric_lockpick()
	set category = "Changeling"
	set name = "Electric Lockpick (5 + 10/use)"
	set desc = "Bruteforces open most electrical locking systems, at 10 chemicals per use."

	var/datum/component/antag/changeling/changeling = changeling_power(5,0,100,CONSCIOUS)

	var/obj/held_item = get_active_hand()

	if(!changeling)
		return 0

	if(held_item == null)
		if(changeling_generic_weapon(/obj/item/finger_lockpick,0,5))  //Chemical cost is handled in the equip proc.
			return 1
		return 0

/obj/item/finger_lockpick
	name = "finger lockpick"
	desc = "This finger appears to be an organic datajack."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "electric_hand"
	show_examine = FALSE

/obj/item/finger_lockpick/Initialize(mapload)
	. = ..()
	if(ismob(loc))
		to_chat(loc, span_notice("We shape our finger to fit inside electronics, and are ready to force them open."))

/obj/item/finger_lockpick/dropped(mob/user)
	..()
	to_chat(user, span_notice("We discreetly shape our finger back to a less suspicious form."))
	spawn(1)
		if(src)
			qdel(src)

/obj/item/finger_lockpick/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	var/datum/component/antag/changeling/ling_datum = is_changeling(user)
	if(!ling_datum)
		return

	if(ling_datum.chem_charges < 10)
		to_chat(user, span_warning("We require more chemicals to do that."))
		return

	//Airlocks require an ugly block of code, but we don't want to just call emag_act(), since we don't want to break airlocks forever.
	if(istype(target,/obj/machinery/door))
		var/obj/machinery/door/door = target
		to_chat(user, span_notice("We send an electrical pulse up our finger, and into \the [target], attempting to open it."))

		if(door.density && door.operable())
			door.do_animate("spark")
			sleep(6)
			//More typechecks, because windoors can't be locked.  Fun.
			if(istype(target,/obj/machinery/door/airlock))
				var/obj/machinery/door/airlock/airlock = target

				if(airlock.locked) //Check if we're bolted.
					airlock.unlock()
					to_chat(user, span_notice("We've unlocked \the [airlock].  Another pulse is requried to open it."))
				else	//We're not bolted, so open the door already.
					airlock.open()
					to_chat(user, span_notice("We've opened \the [airlock]."))
			else
				door.open() //If we're a windoor, open the windoor.
				to_chat(user, span_notice("We've opened \the [door]."))
		else //Probably broken or no power.
			to_chat(user, span_warning("The door does not respond to the pulse."))
		door.add_fingerprint(user)
		log_and_message_admins("finger-lockpicked \an [door].")
		ling_datum.chem_charges -= 10
		return 1

	else if(istype(target,/obj/)) //This should catch everything else we might miss, without a million typechecks.
		var/obj/O = target
		to_chat(user, span_notice("We send an electrical pulse up our finger, and into \the [O]."))
		O.add_fingerprint(user)
		O.emag_act(1,user,src)
		log_and_message_admins("finger-lockpicked \an [O].")
		ling_datum.chem_charges -= 10

		return 1
	return 0
