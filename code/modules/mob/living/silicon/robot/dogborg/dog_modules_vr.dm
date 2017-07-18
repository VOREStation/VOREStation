/obj/item/weapon/dogborg/jaws/big
	name = "combat jaws"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "jaws"
	desc = "The jaws of the law."
	flags = CONDUCT
	force = 10
	throwforce = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
	w_class = ITEMSIZE_NORMAL

/obj/item/weapon/dogborg/jaws/small
	name = "puppy jaws"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "smalljaws"
	desc = "The jaws of a small dog."
	flags = CONDUCT
	force = 5
	throwforce = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	w_class = ITEMSIZE_NORMAL
	var/emagged = 0

/obj/item/weapon/dogborg/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.emagged)
		emagged = !emagged
		if(emagged)
			name = "combat jaws"
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "jaws"
			desc = "The jaws of the law."
			flags = CONDUCT
			force = 10
			throwforce = 0
			hitsound = 'sound/weapons/bite.ogg'
			attack_verb = list("chomped", "bit", "ripped", "mauled", "enforced")
			w_class = ITEMSIZE_NORMAL
		else
			name = "puppy jaws"
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "smalljaws"
			desc = "The jaws of a small dog."
			flags = CONDUCT
			force = 5
			throwforce = 0
			hitsound = 'sound/weapons/bite.ogg'
			attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
			w_class = ITEMSIZE_NORMAL
		update_icon()

//Boop //New and improved, now a simple reagent sniffer.
/obj/item/device/dogborg/boop_module
	name = "boop module"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "nose"
	desc = "The BOOP module, a simple reagent and atmosphere sniffer."
	flags = CONDUCT
	force = 0
	throwforce = 0
	attack_verb = list("nuzzled", "nosed", "booped")
	w_class = ITEMSIZE_TINY

/obj/item/device/dogborg/boop_module/New()
	..()
	flags |= NOBLUDGEON //No more attack messages

/obj/item/device/dogborg/boop_module/attack_self(mob/user)
	if (!( istype(user.loc, /turf) ))
		return

	var/datum/gas_mixture/environment = user.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<span class='notice'>[user] sniffs the air.</span>", "<span class='notice'>You sniff the air...</span>")

	user << "<span class='notice'><B>Smells like:</B></span>"
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		user << "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>"
	else
		user << "<span class='warning'>Pressure: [round(pressure,0.1)] kPa</span>"
	if(total_moles)
		for(var/g in environment.gas)
			user << "<span class='notice'>[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]%</span>"
		user << "<span class='notice'>Temperature: [round(environment.temperature-T0C,0.1)]&deg;C ([round(environment.temperature,0.1)]K)</span>"

/obj/item/device/dogborg/boop_module/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return
	if (user.stat)
		return
	if(!istype(O))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<span class='notice'>[user] sniffs at \the [O.name].</span>", "<span class='notice'>You sniff \the [O.name]...</span>")

	if(!isnull(O.reagents))
		var/dat = ""
		if(O.reagents.reagent_list.len > 0)
			for (var/datum/reagent/R in O.reagents.reagent_list)
				dat += "\n \t <span class='notice'>[R]</span>"

		if(dat)
			user << "<span class='notice'>Your BOOP module indicates: [dat]</span>"
		else
			user << "<span class='notice'>No active chemical agents smelled in [O].</span>"
	else
		user << "<span class='notice'>No significant chemical agents smelled in [O].</span>"

	return


//Delivery
/*
/obj/item/weapon/storage/bag/borgdelivery
	name = "fetching storage"
	desc = "Fetch the thing!"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "dbag"
	w_class = ITEMSIZE_HUGE
	max_w_class = ITEMSIZE_SMALL
	max_combined_w_class = ITEMSIZE_SMALL
	storage_slots = 1
	collection_mode = 0
	can_hold = list() // any
	cant_hold = list(/obj/item/weapon/disk/nuclear)
*/

/obj/item/device/dogborg/dog_zapper //TODO
	name = "paws of life"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "defibpaddles0"
	desc = "Zappy paws. For fixing cardiac arrest."
	flags = CONDUCT
	force = 0
	throwforce = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("batted", "pawed", "bopped", "whapped")
	w_class = ITEMSIZE_TINY
	var/charge = 0
	var/charge_required = 1000
	var/charge_per = 100
	var/state = 0 //0 = Off, 1 = Charging, 2 = Ready

	//[round(((world.realtime - src.disconnect_time) / 10) / 60)]

/obj/item/device/dogborg/dog_zapper/attack_self(mob/user)
	switch(state)
		if(0) // Was off when clicked
			if(charge < charge_required) //Turned on and now charging
				state = 1
				//TODO Change Icon
				//TODO Start charging
				user << "<span class='notice'>[name] now charging.</span>"
			else //Turned on and was already charged
				state = 2
				user << "<span class='notice'>[name] now READY.</span>"
		if(1) // Was charging when clicked
			state = 0
			//TODO Change Icon
			user << "<span class='notice'>[name] now turned off.</span>"
		if(2) // Was ready when clicked
			state = 0
			//TODO Change Icon
			user << "<span class='notice'>[name] now turned off (fully charged).</span>"
/*
/obj/item/device/dogborg/dog_zapper/proc/charge()
	var/mob/living/silicon/robot.R = usr

	do
		R.cell.charge -= charge_per
		charge += charge_per
		sleep(1)
	while(state = 1 && charge < charge_required && (R.cell.charge > (charge_required - charge)))

	if(charge = charge_required)
		usr << "<span class='notice'>[name] now READY.</span>"


/obj/item/device/dogborg/dog_zapper/afterattack(mob/living/carbon/target, mob/living/silicon/user, proximity)
*/
//Tongue stuff
/obj/item/device/dogborg/tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/attackblob.ogg'
	var/emagged = 0

/obj/item/device/dogborg/tongue/New()
	..()
	flags |= NOBLUDGEON //No more attack messages

/obj/item/device/dogborg/tongue/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.emagged)
		emagged = !emagged
		if(emagged)
			name = "hacked tongue of doom"
			desc = "Your tongue has been upgraded successfully. Congratulations."
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "syndietongue"
		else
			name = "synthetic tongue"
			desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "synthtongue"
		update_icon()

/obj/item/device/dogborg/tongue/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(user.client && (target in user.client.screen))
		user << "<span class='warning'>You need to take \the [target.name] off before cleaning it!</span>"
	else if(istype(target,/obj/effect/decal/cleanable))
		user.visible_message("[user] begins to lick off \the [target.name].", "<span class='notice'>You begin to lick off \the [target.name]...</span>")
		if(do_after (user, 50))
			user << "<span class='notice'>You finish licking off \the [target.name].</span>"
			qdel(target)
			var/mob/living/silicon/robot.R = user
			R.cell.charge = R.cell.charge + 50
	else if(istype(target,/obj/item))
		if(istype(target,/obj/item/trash))
			user.visible_message("[user] nibbles away at \the [target.name].", "<span class='notice'>You begin to nibble away at \the [target.name]...</span>")
			if(do_after (user, 50))
				user.visible_message("[user] finishes eating \the [target.name].", "<span class='notice'>You finish eating \the [target.name].</span>")
				user << "<span class='notice'>You finish off \the [target.name].</span>"
				qdel(target)
				var/mob/living/silicon/robot.R = user
				R.cell.charge = R.cell.charge + 250
			return
		if(istype(target,/obj/item/weapon/cell))
			user.visible_message("[user] begins cramming \the [target.name] down its throat.", "<span class='notice'>You begin cramming \the [target.name] down your throat...</span>")
			if(do_after (user, 50))
				user.visible_message("[user] finishes gulping down \the [target.name].", "<span class='notice'>You finish swallowing \the [target.name].</span>")
				user << "<span class='notice'>You finish off \the [target.name], and gain some charge!</span>"
				var/mob/living/silicon/robot.R = user
				var/obj/item/weapon/cell.C = target
				R.cell.charge = R.cell.charge + (C.maxcharge / 3)
				qdel(target)
			return
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after (user, 50))
			user << "<span class='notice'>You clean \the [target.name].</span>"
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
	else if(ishuman(target))
		if(src.emagged)
			var/mob/living/silicon/robot.R = user
			var/mob/living/L = target
			if(R.cell.charge <= 666)
				return
			L.Stun(4) // normal stunbaton is force 7 gimme a break good sir!
			L.Weaken(4)
			L.apply_effect(STUTTER, 4)
			L.visible_message("<span class='danger'>[user] has shocked [L] with its tongue!</span>", \
								"<span class='userdanger'>[user] has shocked you with its tongue! You can feel the betrayal.</span>")
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			R.cell.charge = R.cell.charge - 666
		else
			user.visible_message("<span class='notice'>\the [user] affectionally licks all over \the [target]'s face!</span>", "<span class='notice'>You affectionally lick all over \the [target]'s face!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			return
	else if(istype(target, /obj/structure/window))
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after (user, 50))
			user << "<span class='notice'>You clean \the [target.name].</span>"
			target.color = initial(target.color)
			//target.SetOpacity(initial(target.opacity)) //Apparantly this doesn't work?
	else
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after (user, 50))
			user << "<span class='notice'>You clean \the [target.name].</span>"
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
	return

/obj/item/weapon/gun/energy/taser/mounted/cyborg/ertgun //Not a taser, but it's being used as a base so it takes energy and actually works.
	name = "disabler"
	desc = "A small and nonlethal gun produced by NT.."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "projgun"
	fire_sound = 'sound/weapons/eLuger.ogg'
	projectile_type = /obj/item/projectile/beam/disable
	charge_cost = 240 //Normal cost of a taser. It used to be 1000, but after some testing it was found that it would sap a borg's battery to quick
	recharge_time = 10 //Takes ten ticks to recharge a shot, so don't waste them all!
	//cell_type = null //Same cell as a taser until edits are made.

/obj/item/weapon/dogborg/swordtail
	name = "sword tail"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "swordtail"
	desc = "A glowing pink dagger normally attached to the end of a cyborg's tail. It appears to be extremely sharp."
	flags = CONDUCT
	force = 20 //Takes 5 hits to 100-0
	sharp = 1
	edge = 1
	throwforce = 0 //This shouldn't be thrown in the first place.
	hitsound = 'sound/weapons/blade1.ogg'
	attack_verb = list("slashed", "stabbed", "jabbed", "mauled", "sliced")
	w_class = ITEMSIZE_NORMAL

/obj/item/device/lightreplacer/dogborg
	name = "light replacer"
	desc = "A device to automatically replace lights. This version is capable to produce a few replacements using your internal matter reserves."
	max_uses = 16
	var/cooldown = 0

/obj/item/device/lightreplacer/dogborg/attack_self(mob/user)//Boo recharger fill is slow as shit and removes all the extra cyberfat gains you worked so hard for!
	if(uses >= max_uses)
		user << "<span class='warning'>[src.name] is full.</span>"
		return
	if(uses < max_uses && cooldown == 0)
		var/mob/living/silicon/robot.R = user
		if(R.cell.charge <= 1000)
			user << "<span class='warning'>Insufficient power reserves. Please recharge.</span>"
			return
		usr << "It has [uses] lights remaining. Attempting to fabricate a replacement. Please stand still."
		cooldown = 1
		if(do_after(user, 50))
			R.cell.charge = R.cell.charge - 800
			AddUses(1)
			cooldown = 0
		else
			cooldown = 0
	else
		usr << "It has [uses] lights remaining."
		return