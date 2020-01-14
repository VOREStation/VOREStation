/obj/item/weapon/dogborg/jaws/big
	name = "combat jaws"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "jaws"
	desc = "The jaws of the law."
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
	force = 5
	throwforce = 0
	hitsound = 'sound/weapons/bite.ogg'
	attack_verb = list("nibbled", "bit", "gnawed", "chomped", "nommed")
	w_class = ITEMSIZE_NORMAL
	var/emagged = 0

/obj/item/weapon/dogborg/jaws/small/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.emagged || R.emag_items)
		emagged = !emagged
		if(emagged)
			name = "combat jaws"
			icon = 'icons/mob/dogborg_vr.dmi'
			icon_state = "jaws"
			desc = "The jaws of the law."
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

	to_chat(user, "<span class='notice'><B>Smells like:</B></span>")
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(user, "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>")
	else
		to_chat(user, "<span class='warning'>Pressure: [round(pressure,0.1)] kPa</span>")
	if(total_moles)
		for(var/g in environment.gas)
			to_chat(user, "<span class='notice'>[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]%</span>")
		to_chat(user, "<span class='notice'>Temperature: [round(environment.temperature-T0C,0.1)]&deg;C ([round(environment.temperature,0.1)]K)</span>")

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
			to_chat(user, "<span class='notice'>Your BOOP module indicates: [dat]</span>")
		else
			to_chat(user, "<span class='notice'>No active chemical agents smelled in [O].</span>")
	else
		to_chat(user, "<span class='notice'>No significant chemical agents smelled in [O].</span>")

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

/obj/item/weapon/shockpaddles/robot/hound
	name = "paws of life"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "defibpaddles0"
	desc = "Zappy paws. For fixing cardiac arrest."
	combat = 1
	attack_verb = list("batted", "pawed", "bopped", "whapped")
	chargecost = 500

/obj/item/weapon/shockpaddles/robot/hound/jumper
	name = "jumper paws"
	desc = "Zappy paws. For rebooting a full body prostetic."
	use_on_synthetic = 1

/obj/item/weapon/reagent_containers/borghypo/hound
	name = "MediHound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves, designed for heavy-duty medical equipment."
	charge_cost = 10
	var/datum/matter_synth/water = null

/obj/item/weapon/reagent_containers/borghypo/hound/process() //Recharges in smaller steps and uses the water reserves as well.
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(R && R.cell)
			for(var/T in reagent_ids)
				if(reagent_volumes[T] < volume && water.energy >= charge_cost)
					R.cell.use(charge_cost)
					water.use_charge(charge_cost)
					reagent_volumes[T] = min(reagent_volumes[T] + 1, volume)
	return 1

/obj/item/weapon/reagent_containers/borghypo/hound/lost
	name = "Hound hypospray"
	desc = "An advanced chemical synthesizer and injection system utilizing carrier's reserves."
	reagent_ids = list("tricordrazine", "inaprovaline", "bicaridine", "dexalin", "anti_toxin", "tramadol", "spaceacillin")


//Tongue stuff
/obj/item/device/dogborg/tongue
	name = "synthetic tongue"
	desc = "Useful for slurping mess off the floor before affectionally licking the crew members in the face."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/attackblob.ogg'
	var/emagged = 0
	var/datum/matter_synth/water = null

/obj/item/device/dogborg/tongue/New()
	..()
	flags |= NOBLUDGEON //No more attack messages

/obj/item/device/dogborg/tongue/examine(user)
	if(!..(user, 1))
		return
	if(water.energy)
		user <<"<span class='notice'>[src] is wet. Just like it should be.</span>"
	if(water.energy < 5)
		user <<"<span class='notice'>[src] is dry.</span>"

/obj/item/device/dogborg/tongue/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(R.emagged || R.emag_items)
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
		to_chat(user, "<span class='warning'>You need to take \the [target.name] off before cleaning it!</span>")
	if(istype(target, /obj/structure/sink) || istype(target, /obj/structure/toilet)) //Dog vibes.
		user.visible_message("[user] begins to lap up water from [target.name].", "<span class='notice'>You begin to lap up water from [target.name].</span>")
		if(do_after (user, 50))
			water.add_charge(50)
	else if(water.energy < 5)
		to_chat(user, "<span class='notice'>Your mouth feels dry. You should drink up some water .</span>")
		return
	else if(istype(target,/obj/effect/decal/cleanable))
		user.visible_message("[user] begins to lick off \the [target.name].", "<span class='notice'>You begin to lick off \the [target.name]...</span>")
		if(do_after (user, 50))
			to_chat(user, "<span class='notice'>You finish licking off \the [target.name].</span>")
			water.use_charge(5)
			qdel(target)
			var/mob/living/silicon/robot.R = user
			R.cell.charge += 50
	else if(istype(target,/obj/item))
		if(istype(target,/obj/item/trash))
			user.visible_message("[user] nibbles away at \the [target.name].", "<span class='notice'>You begin to nibble away at \the [target.name]...</span>")
			if(do_after (user, 50))
				user.visible_message("[user] finishes eating \the [target.name].", "<span class='notice'>You finish eating \the [target.name].</span>")
				to_chat(user, "<span class='notice'>You finish off \the [target.name].</span>")
				qdel(target)
				var/mob/living/silicon/robot.R = user
				R.cell.charge += 250
				water.use_charge(5)
			return
		if(istype(target,/obj/item/weapon/cell))
			user.visible_message("[user] begins cramming \the [target.name] down its throat.", "<span class='notice'>You begin cramming \the [target.name] down your throat...</span>")
			if(do_after (user, 50))
				user.visible_message("[user] finishes gulping down \the [target.name].", "<span class='notice'>You finish swallowing \the [target.name].</span>")
				to_chat(user, "<span class='notice'>You finish off \the [target.name], and gain some charge!</span>")
				var/mob/living/silicon/robot.R = user
				var/obj/item/weapon/cell.C = target
				R.cell.charge += C.maxcharge / 3
				water.use_charge(5)
				qdel(target)
			return
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after (user, 50))
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			water.use_charge(5)
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
	else if(ishuman(target))
		if(src.emagged)
			var/mob/living/silicon/robot.R = user
			var/mob/living/L = target
			if(R.cell.charge <= 666)
				return
			L.Stun(1)
			L.Weaken(1)
			L.apply_effect(STUTTER, 1)
			L.visible_message("<span class='danger'>[user] has shocked [L] with its tongue!</span>", \
								"<span class='userdanger'>[user] has shocked you with its tongue! You can feel the betrayal.</span>")
			playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
			R.cell.charge -= 666
		else
			user.visible_message("<span class='notice'>\the [user] affectionally licks all over \the [target]'s face!</span>", "<span class='notice'>You affectionally lick all over \the [target]'s face!</span>")
			playsound(src.loc, 'sound/effects/attackblob.ogg', 50, 1)
			water.use_charge(5)
			var/mob/living/carbon/human/H = target
			if(H.species.lightweight == 1)
				H.Weaken(3)
	else
		user.visible_message("[user] begins to lick \the [target.name] clean...", "<span class='notice'>You begin to lick \the [target.name] clean...</span>")
		if(do_after (user, 50))
			to_chat(user, "<span class='notice'>You clean \the [target.name].</span>")
			var/obj/effect/decal/cleanable/C = locate() in target
			qdel(C)
			target.clean_blood()
			water.use_charge(5)
			if(istype(target, /turf/simulated))
				var/turf/simulated/T = target
				T.dirt = 0
	return

/obj/item/pupscrubber
	name = "floor scrubber"
	desc = "Toggles floor scrubbing."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "scrub0"
	var/enabled = FALSE

/obj/item/pupscrubber/New()
	..()
	flags |= NOBLUDGEON

/obj/item/pupscrubber/attack_self(mob/user)
	var/mob/living/silicon/robot.R = user
	if(!enabled)
		R.scrubbing = TRUE
		enabled = TRUE
		icon_state = "scrub1"
	else
		R.scrubbing = FALSE
		enabled = FALSE
		icon_state = "scrub0"

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
	uses = 10
	var/cooldown = 0
	var/datum/matter_synth/glass = null

/obj/item/device/lightreplacer/dogborg/attack_self(mob/user)//Recharger refill is so last season. Now we recycle without magic!
	if(uses >= max_uses)
		to_chat(user, "<span class='warning'>[src.name] is full.</span>")
		return
	if(uses < max_uses && cooldown == 0)
		if(glass.energy < 125)
			to_chat(user, "<span class='warning'>Insufficient material reserves.</span>")
			return
		to_chat(user, "It has [uses] lights remaining. Attempting to fabricate a replacement. Please stand still.")
		cooldown = 1
		if(do_after(user, 50))
			glass.use_charge(125)
			add_uses(1)
			cooldown = 0
		else
			cooldown = 0
	else
		to_chat(user, "It has [uses] lights remaining.")
		return

//Pounce stuff for K-9
/obj/item/weapon/dogborg/pounce
	name = "pounce"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "pounce"
	desc = "Leap at your target to momentarily stun them."
	force = 0
	throwforce = 0

/obj/item/weapon/dogborg/pounce/New()
	..()
	flags |= NOBLUDGEON

/obj/item/weapon/dogborg/pounce/attack_self(mob/user)
	var/mob/living/silicon/robot/R = user
	R.leap()

/mob/living/silicon/robot/proc/leap()
	if(last_special > world.time)
		to_chat(src, "Your leap actuators are still recharging.")
		return

	if(cell.charge < 1000)
		to_chat(src, "Cell charge too low to continue.")
		return

	if(usr.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(3,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to leap at?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 3) return

	if(last_special > world.time)
		return

	if(usr.incapacitated(INCAPACITATION_DISABLED))
		to_chat(src, "You cannot leap in your current state.")
		return

	last_special = world.time + 10
	status_flags |= LEAPING
	pixel_y = pixel_y + 10

	src.visible_message("<span class='danger'>\The [src] leaps at [T]!</span>")
	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src.loc, 'sound/mecha/mechstep2.ogg', 50, 1)
	pixel_y = default_pixel_y
	cell.charge -= 750

	sleep(5)

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		to_chat(src, "<span class='warning'>You miss!</span>")
		return

	if(ishuman(T))
		var/mob/living/carbon/human/H = T
		if(H.species.lightweight == 1)
			H.Weaken(3)
			return
	var/armor_block = run_armor_check(T, "melee")
	var/armor_soak = get_armor_soak(T, "melee")
	T.apply_damage(20, HALLOSS,, armor_block, armor_soak)
	if(prob(75)) //75% chance to stun for 5 seconds, really only going to be 4 bcus click cooldown+animation.
		T.apply_effect(5, WEAKEN, armor_block)
