/obj/item/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = NOBLUDGEON
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ILLEGAL = 2)
	var/datum/wires/explosive/c4/wires = null
	var/timer = 10
	var/atom/target = null
	var/open_panel = 0
	var/image_overlay = null
	var/blast_dev = -1
	var/blast_heavy = -1
	var/blast_light = 2
	var/blast_flash = 3

/obj/item/plastique/New()
	wires = new(src)
	image_overlay = image('icons/obj/assemblies.dmi', "plastic-explosive2")
	..()

/obj/item/plastique/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/item/plastique/attackby(var/obj/item/I, var/mob/user)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		open_panel = !open_panel
		to_chat(user, span_notice("You [open_panel ? "open" : "close"] the wire panel."))
		playsound(src, I.usesound, 50, 1)
	else if(I.has_tool_quality(TOOL_WIRECUTTER) || istype(I, /obj/item/multitool) || istype(I, /obj/item/assembly/signaler ))
		wires.Interact(user)
	else
		..()

/obj/item/plastique/attack_self(mob/user as mob)
	var/newtime = tgui_input_number(usr, "Please set the timer.", "Timer", 10, 60000, 10)
	if(user.get_active_hand() == src)
		newtime = CLAMP(newtime, 10, 60000)
		timer = newtime
		to_chat(user, "Timer set for [timer] seconds.")

/obj/item/plastique/afterattack(atom/movable/target, mob/user, flag)
	if (!flag)
		return
	if (ismob(target) || istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/storage/) || istype(target, /obj/item/clothing/accessory/storage/) || istype(target, /obj/item/clothing/under))
		return
	to_chat(user, "Planting explosives...")
	user.do_attack_animation(target)

	if(do_after(user, 50) && in_range(user, target))
		user.drop_item()
		src.target = target
		loc = null

		if (ismob(target))
			add_attack_logs(user, target, "planted [name] on with [timer] second fuse")
			user.visible_message(span_danger("[user.name] finished planting an explosive on [target.name]!"))
		else
			message_admins("[key_name(user, user.client)](<A HREF='?_src_=holder;[HrefToken()];adminmoreinfo=\ref[user]'>?</A>) planted [src.name] on [target.name] at ([target.x],[target.y],[target.z] - <A HREF='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>) with [timer] second fuse",0,1)
			log_game("[key_name(user)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z]) with [timer] second fuse")

		target.add_overlay(image_overlay, TRUE)
		to_chat(user, "Bomb has been planted. Timer counting down from [timer].")
		spawn(timer*10)
			explode(get_turf(target))

/obj/item/plastique/proc/explode(var/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, blast_dev, blast_heavy, blast_light, blast_flash)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1,1,1)
		else if(istype(target, /mob/living))
			target.ex_act(2) // c4 can't gib mobs anymore.
		else
			target.ex_act(1)
	if(target)
		target.cut_overlay(image_overlay, TRUE)
	qdel(src)

/obj/item/plastique/attack(mob/M as mob, mob/user as mob, def_zone)
	return

/obj/item/plastique/seismic
	name = "seismic charge"
	desc = "Used to dig holes in specific areas without too much extra hole."

	blast_heavy = 2
	blast_light = 4
	blast_flash = 7

/obj/item/plastique/seismic/attackby(var/obj/item/I, var/mob/user)
	. = ..()
	if(open_panel)
		if(istype(I, /obj/item/stock_parts/micro_laser))
			var/obj/item/stock_parts/SP = I
			var/new_blast_power = max(1, round(SP.rating / 2) + 1)
			if(new_blast_power > blast_heavy)
				to_chat(user, span_notice("You install \the [I] into \the [src]."))
				user.drop_from_inventory(I)
				qdel(I)
				blast_heavy = new_blast_power
				blast_light = blast_heavy + round(new_blast_power * 0.5)
				blast_flash = blast_light + round(new_blast_power * 0.75)
			else
				to_chat(user, span_notice("The [I] is not any better than the component already installed into this charge!"))
	return .
