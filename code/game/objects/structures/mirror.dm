//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! The leading technology in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/shattered = 0
	var/list/ui_users = list()
	var/glass = 1

/obj/structure/mirror/New(var/loc, var/dir, var/building = 0, mob/user as mob)
	if(building)
		glass = 0
		icon_state = "mirror_frame"
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -28 : 28)
		pixel_y = (dir & 3)? (dir == 1 ? -30 : 30) : 0
	return

/obj/structure/mirror/attack_hand(mob/user as mob)
	if(!glass) return
	if(shattered)	return

	if(ishuman(user))
		var/datum/nano_module/appearance_changer/AC = ui_users[user]
		if(!AC)
			AC = new(src, user)
			AC.name = "SalonPro Nano-Mirror&trade;"
			ui_users[user] = AC
		AC.ui_interact(user)

/obj/structure/mirror/proc/shatter()
	if(!glass) return
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)

	if(prob(Proj.get_structure_damage() * 2))
		if(!shattered)
			shatter()
		else if(glass)
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()

/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/wrench))
		if(!glass)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, 20))
				user << "<span class='notice'>You unfasten the frame.</span>"
				new /obj/item/frame/mirror( src.loc )
				qdel(src)
		return
	if(istype(I, /obj/item/weapon/crowbar))
		if(shattered && glass)
			user << "<span class='notice'>The broken glass falls out.</span>"
			icon_state = "mirror_frame"
			glass = !glass
			new /obj/item/weapon/material/shard( src.loc )
			return
		if(!shattered && glass)
			playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
			user << "<span class='notice'>You remove the glass.</span>"
			glass = !glass
			icon_state = "mirror_frame"
			new /obj/item/stack/material/glass( src.loc, 2 )
			return

	if(istype(I, /obj/item/stack/material/glass))
		if(!glass)
			var/obj/item/stack/material/glass/G = I
			if (G.get_amount() < 2)
				user << "<span class='warning'>You need two sheets of glass to add them to the frame.</span>"
				return
			user << "<span class='notice'>You start to add the glass to the frame.</span>"
			if(do_after(user, 20))
				if (G.use(2))
					shattered = 0
					glass = 1
					icon_state = "mirror"
					user << "<span class='notice'>You add the glass to the frame.</span>"
			return

	if(shattered && glass)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message("<span class='warning'>[user] smashes [src] with [I]!</span>")
		if(glass)
			shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 70, 1)

/obj/structure/mirror/attack_generic(var/mob/user, var/damage)

	user.do_attack_animation(src)
	if(shattered && glass)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return 0

	if(damage)
		user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
		if(glass)
			shatter()
	else
		user.visible_message("<span class='danger'>[user] hits [src] and bounces off!</span>")
	return 1
