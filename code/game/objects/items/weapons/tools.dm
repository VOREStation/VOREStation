//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/* Tools!
 * Note: Multitools are /obj/item/device
 *
 * Contains:
 * 		Wrench
 * 		Screwdriver
 * 		Wirecutters
 * 		Welding Tool
 * 		Crowbar
 */

/*
 * Wrench
 */
/obj/item/weapon/wrench
	name = "wrench"
	desc = "A wrench with many common uses. Can be usually found in your hand."
	icon = 'icons/obj/items.dmi'
	icon_state = "wrench"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 6
	throwforce = 7
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	attack_verb = list("bashed", "battered", "bludgeoned", "whacked")


/*
 * Screwdriver
 */
/obj/item/weapon/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	icon = 'icons/obj/items.dmi'
	icon_state = "screwdriver"
	flags = CONDUCT
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 6
	w_class = ITEMSIZE_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	attack_verb = list("stabbed")
	sharp  = 1

	suicide_act(mob/user)
		viewers(user) << pick("<span class='danger'>\The [user] is stabbing the [src.name] into \his temple! It looks like \he's trying to commit suicide.</span>", \
		                       "<span class='danger'>\The [user] is stabbing the [src.name] into \his heart! It looks like \he's trying to commit suicide.</span>")
		return(BRUTELOSS)

/obj/item/weapon/screwdriver/New()
	switch(pick("red","blue","purple","brown","green","cyan","yellow"))
		if ("red")
			icon_state = "screwdriver2"
			item_state = "screwdriver"
		if ("blue")
			icon_state = "screwdriver"
			item_state = "screwdriver_blue"
		if ("purple")
			icon_state = "screwdriver3"
			item_state = "screwdriver_purple"
		if ("brown")
			icon_state = "screwdriver4"
			item_state = "screwdriver_brown"
		if ("green")
			icon_state = "screwdriver5"
			item_state = "screwdriver_green"
		if ("cyan")
			icon_state = "screwdriver6"
			item_state = "screwdriver_cyan"
		if ("yellow")
			icon_state = "screwdriver7"
			item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	..()

/obj/item/weapon/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(user.zone_sel.selecting != O_EYES && user.zone_sel.selecting != BP_HEAD)
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/*
 * Wirecutters
 */
/obj/item/weapon/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'icons/obj/items.dmi'
	icon_state = "cutters"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 6
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 80)
	attack_verb = list("pinched", "nipped")
	sharp = 1
	edge = 1

/obj/item/weapon/wirecutters/New()
	if(prob(50))
		icon_state = "cutters-y"
		item_state = "cutters_yellow"
	..()

/obj/item/weapon/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/weapon/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()

/*
 * Welding Tool
 */
/obj/item/weapon/weldingtool
	name = "welding tool"
	icon = 'icons/obj/items.dmi'
	icon_state = "welder"
	flags = CONDUCT
	slot_flags = SLOT_BELT

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL

	//Cost to make in the autolathe
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 30)

	//R&D tech level
	origin_tech = list(TECH_ENGINEERING = 1)

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold

/obj/item/weapon/weldingtool/New()
//	var/random_fuel = min(rand(10,20),max_fuel)
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	..()

/obj/item/weapon/weldingtool/Destroy()
	if(welding)
		processing_objects -= src
	return ..()

/obj/item/weapon/weldingtool/examine(mob/user)
	if(..(user, 0))
		if(max_fuel)
			user << text("\icon[] [] contains []/[] units of fuel!", src, src.name, get_fuel(),src.max_fuel )


/obj/item/weapon/weldingtool/attackby(obj/item/W as obj, mob/living/user as mob)
	if(istype(W,/obj/item/weapon/screwdriver))
		if(welding)
			user << "<span class='danger'>Stop welding first!</span>"
			return
		status = !status
		if(status)
			user << "<span class='notice'>You secure the welder.</span>"
		else
			user << "<span class='notice'>The welder can now be attached and modified.</span>"
		src.add_fingerprint(user)
		return

	if((!status) && (istype(W,/obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		var/obj/item/weapon/flamethrower/F = new/obj/item/weapon/flamethrower(user.loc)
		src.loc = F
		F.weldtool = src
		if (user.client)
			user.client.screen -= src
		if (user.r_hand == src)
			user.remove_from_mob(src)
		else
			user.remove_from_mob(src)
		src.master = F
		src.layer = initial(src.layer)
		user.remove_from_mob(src)
		if (user.client)
			user.client.screen -= src
		src.loc = F
		src.add_fingerprint(user)
		return

	..()
	return


/obj/item/weapon/weldingtool/process()
	if(welding)
		if(prob(5))
			remove_fuel(1)

		if(get_fuel() < 1)
			setWelding(0)

	//I'm not sure what this does. I assume it has to do with starting fires...
	//...but it doesnt check to see if the welder is on or not.
	var/turf/location = src.loc
	if(istype(location, /mob/living))
		var/mob/living/M = location
		if(M.item_is_in_hands(src))
			location = get_turf(M)
	if (istype(location, /turf))
		location.hotspot_expose(700, 5)


/obj/item/weapon/weldingtool/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1 && !welding)
		if(!welding && max_fuel)
			O.reagents.trans_to_obj(src, max_fuel)
			user << "<span class='notice'>Welder refueled</span>"
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			return
		else if(!welding)
			user << "<span class='notice'>[src] doesn't use fuel.</span>"
			return
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion with a welding tool.")
			log_game("[key_name(user)] triggered a fueltank explosion with a welding tool.")
			user << "<span class='danger'>You begin welding on the fueltank and with a moment of lucidity you realize, this might not have been the smartest thing you've ever done.</span>"
			var/obj/structure/reagent_dispensers/fueltank/tank = O
			tank.explode()
			return
	if (src.welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
	return


/obj/item/weapon/weldingtool/attack_self(mob/user as mob)
	setWelding(!welding, usr)
	return

//Returns the amount of fuel in the welder
/obj/item/weapon/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")


//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weapon/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << "<span class='notice'>You need more welding fuel to complete this task.</span>"
		return 0

//Returns whether or not the welding tool is currently on.
/obj/item/weapon/weldingtool/proc/isOn()
	return src.welding

/obj/item/weapon/weldingtool/update_icon()
	..()
	icon_state = welding ? "[icon_state]1" : "[initial(icon_state)]"
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weapon/weldingtool/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if (ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech. why?
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		//makes sure that the thing is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if ((src.loc == usr) && !(istype(over_object, /obj/screen)) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.u_equip(src)
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.u_equip(src)
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weapon/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if(!status)	return

	var/turf/T = get_turf(src)
	//If we're turning it on
	if(set_welding && !welding)
		if (get_fuel() > 0)
			if(M)
				M << "<span class='notice'>You switch the [src] on.</span>"
			else if(T)
				T.visible_message("<span class='danger'>\The [src] turns on.</span>")
			src.force = 15
			src.damtype = "fire"
			src.w_class = ITEMSIZE_LARGE
			welding = 1
			update_icon()
			processing_objects |= src
		else
			if(M)
				var/msg = max_fuel ? "welding fuel" : "charge"
				M << "<span class='notice'>You need more [msg] to complete this task.</span>"
			return
	//Otherwise
	else if(!set_welding && welding)
		processing_objects -= src
		if(M)
			M << "<span class='notice'>You switch \the [src] off.</span>"
		else if(T)
			T.visible_message("<span class='warning'>\The [src] turns off.</span>")
		src.force = 3
		src.damtype = "brute"
		src.w_class = initial(src.w_class)
		src.welding = 0
		update_icon()

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weapon/weldingtool/proc/eyecheck(mob/user as mob)
	if(!iscarbon(user))	return 1
	var/safety = user:eyecheck()
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(!E)
			return
		switch(safety)
			if(1)
				usr << "<span class='warning'>Your eyes sting a little.</span>"
				E.damage += rand(1, 2)
				if(E.damage > 12)
					user.eye_blurry += rand(3,6)
			if(0)
				usr << "<span class='warning'>Your eyes burn.</span>"
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4,10)
			if(-1)
				usr << "<span class='danger'>Your thermals intensify the welder's glow. Your eyes itch and burn severely.</span>"
				user.eye_blurry += rand(12,20)
				E.damage += rand(12, 16)
		if(safety<2)

			if(E.damage > 10)
				user << "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>"

			if (E.damage >= E.min_broken_damage)
				user << "<span class='danger'>You go blind!</span>"
				user.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage)
				user << "<span class='danger'>You go blind!</span>"
				user.Blind(5)
				user.eye_blurry = 5
				user.disabilities |= NEARSIGHTED
				spawn(100)
					user.disabilities &= ~NEARSIGHTED
	return

/obj/item/weapon/weldingtool/largetank
	name = "industrial welding tool"
	max_fuel = 40
	origin_tech = list(TECH_ENGINEERING = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 60)

/obj/item/weapon/weldingtool/hugetank
	name = "upgraded welding tool"
	max_fuel = 80
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 120)

/obj/item/weapon/weldingtool/experimental
	name = "experimental welding tool"
	max_fuel = 40
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 120)
	var/nextrefueltick = 0

/obj/item/weapon/weldingtool/experimental/New()
	processing_objects |= src
	..()

/obj/item/weapon/weldingtool/experimental/Destroy()
	processing_objects -= src
	..()

/obj/item/weapon/weldingtool/experimental/process()
	..()
	if(get_fuel() < max_fuel && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent("fuel", 1)

/*
 * Electric/Arc Welder
 */

/obj/item/weapon/weldingtool/electric	//AND HIS WELDING WAS ELECTRIC
	name = "electric welding tool"
	icon_state = "arcwelder"
	max_fuel = 0	//We'll handle the consumption later.
	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 24	//The rough equivalent of 1 unit of fuel, based on us wanting 10 welds per battery
	var/cell_type = /obj/item/weapon/cell/device
	var/use_external_power = 0	//If in a borg or hardsuit, this needs to = 1

/obj/item/weapon/weldingtool/electric/New()
	..()
	if(cell_type == null)
		update_icon()
	else if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/weapon/cell/device(src)
	update_icon()

/obj/item/weapon/weldingtool/electric/unloaded/New()
	cell_type = null

/obj/item/weapon/weldingtool/electric/examine(mob/user)
	..()
	if(power_supply)
		user << text("\icon[] [] has [] charge left.", src, src.name, get_fuel())
	else
		user << text("\icon[] [] has power for no power cell!", src, src.name)

/obj/item/weapon/weldingtool/electric/get_fuel()
	if(use_external_power)
		var/obj/item/weapon/cell/external = get_external_power_supply()
		return external.charge
	else if(power_supply)
		return power_supply.charge
	else
		return 0

/obj/item/weapon/weldingtool/electric/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		power_supply.checked_use(charge_cost)
		if(use_external_power)
			var/obj/item/weapon/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				power_supply.give(charge_cost)	//Give it back to the cell.
		if(M)
			eyecheck(M)
		return 1
	else
		if(M)
			M << "<span class='notice'>You need more energy to complete this task.</span>"
		return 0

/obj/item/weapon/weldingtool/electric/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(power_supply)
			power_supply.update_icon()
			user.put_in_hands(power_supply)
			power_supply = null
			user << "<span class='notice'>You remove the cell from the [src].</span>"
			setWelding(0)
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/weapon/weldingtool/electric/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/cell))
		if(istype(W, /obj/item/weapon/cell/device))
			if(!power_supply)
				user.drop_item()
				W.loc = src
				power_supply = W
				user << "<span class='notice'>You install a cell in \the [src].</span>"
				update_icon()
			else
				user << "<span class='notice'>\The [src] already has a cell.</span>"
		else
			user << "<span class='notice'>\The [src] cannot use that type of cell.</span>"
	else
		..()

/obj/item/weapon/weldingtool/electric/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/weapon/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

/obj/item/weapon/weldingtool/electric/mounted
	use_external_power = 1

/*
 * Crowbar
 */

/obj/item/weapon/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon = 'icons/obj/items.dmi'
	icon_state = "crowbar"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 6
	throwforce = 7
	pry = 1
	item_state = "crowbar"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/crowbar/red
	icon = 'icons/obj/items.dmi'
	icon_state = "red_crowbar"
	item_state = "crowbar_red"

/obj/item/weapon/weldingtool/attack(var/atom/A, var/mob/living/user, var/def_zone)
	if(ishuman(A) && user.a_intent == I_HELP)
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/external/S = H.organs_by_name[user.zone_sel.selecting]

		if(!S || S.robotic < ORGAN_ROBOT || S.open == 3)
			return ..()

		if(!welding)
			user << "<span class='warning'>You'll need to turn [src] on to patch the damage on [H]'s [S.name]!</span>"
			return 1

		if(S.robo_repair(15, BRUTE, "some dents", src, user))
			remove_fuel(1, user)

	else
		return ..()

/*/obj/item/weapon/combitool
	name = "combi-tool"
	desc = "It even has one of those nubbins for doing the thingy."
	icon = 'icons/obj/items.dmi'
	icon_state = "combitool"
	w_class = ITEMSIZE_SMALL

	var/list/spawn_tools = list(
		/obj/item/weapon/screwdriver,
		/obj/item/weapon/wrench,
		/obj/item/weapon/wirecutters,
		/obj/item/weapon/material/kitchen/utensil/knife,
		/obj/item/weapon/material/kitchen/utensil/fork,
		/obj/item/weapon/material/hatchet
		)
	var/list/tools = list()
	var/current_tool = 1

/obj/item/weapon/combitool/examine()
	..()
	if(loc == usr && tools.len)
		usr << "It has the following fittings:"
		for(var/obj/item/tool in tools)
			usr << "\icon[tool] - [tool.name][tools[current_tool]==tool?" (selected)":""]"

/obj/item/weapon/combitool/New()
	..()
	for(var/type in spawn_tools)
		tools |= new type(src)

/obj/item/weapon/combitool/attack_self(mob/user as mob)
	if(++current_tool > tools.len) current_tool = 1
	var/obj/item/tool = tools[current_tool]
	if(!tool)
		user << "You can't seem to find any fittings in \the [src]."
	else
		user << "You switch \the [src] to the [tool.name] fitting."
	return 1

/obj/item/weapon/combitool/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!M.Adjacent(user))
		return 0
	var/obj/item/tool = tools[current_tool]
	if(!tool) return 0
	return (tool ? tool.attack(M,user) : 0)

/obj/item/weapon/combitool/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if(!proximity)
		return 0
	var/obj/item/tool = tools[current_tool]
	if(!tool) return 0
	tool.loc = user
	var/resolved = target.attackby(tool,user)
	if(!resolved && tool && target)
		tool.afterattack(target,user,1)
	if(tool)
		tool.loc = src*/
