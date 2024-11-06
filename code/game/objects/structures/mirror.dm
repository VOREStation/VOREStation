//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "A SalonPro Nano-Mirror(TM) brand mirror! The leading technology in hair salon products, utilizing nano-machinery to style your hair just right."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	layer = ABOVE_WINDOW_LAYER
	density = FALSE
	anchored = TRUE
	var/shattered = 0
	var/glass = 1
	var/datum/tgui_module/appearance_changer/mirror/M

/obj/structure/mirror/Initialize(mapload, var/dir, var/building = 0, mob/user as mob)
	M = new(src, null)
	if(building)
		glass = 0
		icon_state = "mirror_frame"
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -28 : 28)
		pixel_y = (dir & 3)? (dir == 1 ? -30 : 30) : 0
	return

/obj/structure/mirror/Destroy()
	QDEL_NULL(M)
	. = ..()

/obj/structure/mirror/attack_hand(mob/user as mob)
	if(!glass) return
	if(shattered)	return

	if(ishuman(user))
		M.tgui_interact(user)

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
	if(I.has_tool_quality(TOOL_WRENCH))
		if(!glass)
			playsound(src, I.usesound, 50, 1)
			if(do_after(user, 20 * I.toolspeed))
				to_chat(user, span_notice("You unfasten the frame."))
				new /obj/item/frame/mirror( src.loc )
				qdel(src)
		return
	if(I.has_tool_quality(TOOL_WRENCH))
		if(shattered && glass)
			to_chat(user, span_notice("The broken glass falls out."))
			icon_state = "mirror_frame"
			glass = !glass
			new /obj/item/material/shard( src.loc )
			return
		if(!shattered && glass)
			playsound(src, I.usesound, 50, 1)
			to_chat(user, span_notice("You remove the glass."))
			glass = !glass
			icon_state = "mirror_frame"
			new /obj/item/stack/material/glass( src.loc, 2 )
			return

	if(istype(I, /obj/item/stack/material/glass))
		if(!glass)
			var/obj/item/stack/material/glass/G = I
			if (G.get_amount() < 2)
				to_chat(user, span_warning("You need two sheets of glass to add them to the frame."))
				return
			to_chat(user, span_notice("You start to add the glass to the frame."))
			if(do_after(user, 20))
				if (G.use(2))
					shattered = 0
					glass = 1
					icon_state = "mirror"
					to_chat(user, span_notice("You add the glass to the frame."))
			return

	if(shattered && glass)
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message(span_warning("[user] smashes [src] with [I]!"))
		if(glass)
			shatter()
	else
		visible_message(span_warning("[user] hits [src] with [I]!"))
		playsound(src, 'sound/effects/Glasshit.ogg', 70, 1)

/obj/structure/mirror/attack_generic(var/mob/user, var/damage)

	user.do_attack_animation(src)
	if(shattered && glass)
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return 0

	if(damage)
		user.visible_message(span_danger("[user] smashes [src]!"))
		if(glass)
			shatter()
	else
		user.visible_message(span_danger("[user] hits [src] and bounces off!"))
	return 1

// The following mirror is ~special~.
/obj/structure/mirror/raider
	name = "cracked mirror"
	desc = "Something seems strange about this old, dirty mirror. Your reflection doesn't look like you remember it."
	icon_state = "mirror_broke"
	shattered = 1

/obj/structure/mirror/raider/attack_hand(var/mob/living/carbon/human/user)
	if(istype(get_area(src),/area/syndicate_mothership))
		if(istype(user) && user.mind && user.mind.special_role == "Raider" && user.species.name != SPECIES_VOX && is_alien_whitelisted(user, SPECIES_VOX))
			var/choice = tgui_alert(usr, "Do you wish to become a true Vox of the Shoal? This is not reversible.", "Become Vox?", list("No","Yes"))
			if(choice && choice == "Yes")
				var/mob/living/carbon/human/vox/vox = new(get_turf(src),SPECIES_VOX)
				vox.gender = user.gender
				raiders.equip(vox)
				if(user.mind)
					user.mind.transfer_to(vox)
				spawn(1)
					var/newname = sanitizeSafe(tgui_input_text(vox,"Enter a name, or leave blank for the default name.", "Name change","", MAX_NAME_LEN), MAX_NAME_LEN)
					if(!newname || newname == "")
						var/datum/language/L = GLOB.all_languages[vox.species.default_language]
						newname = L.get_random_name()
					vox.real_name = newname
					vox.name = vox.real_name
					raiders.update_access(vox)
				qdel(user)
	..()
