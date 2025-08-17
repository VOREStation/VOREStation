// Base object works similar to ticket printers, but produces gold star accessories.

/obj/item/gold_star_printer
	name = "gold star dispenser"
	desc = "It prints gold stickers to reward the crew for their excellent contributions!"
	icon = 'icons/obj/device.dmi'
	icon_state = "gold_star_printer"
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	var/print_cooldown = 1 MINUTE
	var/last_print
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/gold_star_printer/attack_self(mob/user)
	. = ..()
	if(last_print + print_cooldown <= world.time)
		make_star(user)
	else
		to_chat(user, span_warning("\The [src] is not ready to print another star yet."))

/obj/item/gold_star_printer/proc/make_star(mob/user)

	var/star_title = tgui_input_text(user, "Choose a title for the star, this can be an action or name. The name of the star will read Gold Star for 'Title'.", "Title", max_length = 32)
	if(length(star_title) > 32)
		tgui_alert_async(user, "Entered title too long. 100 character limit.","Error")
		return
	if(!star_title)
		return
	var/star_desc = tgui_input_text(user, "Choose the description of the 'Gold Star for [star_title]', this is what it will read on examination. (Max length: 200)", "Ticket Details", max_length = 200)
	if(length(star_desc) > 200)
		tgui_alert_async(user, "Entered details too long. 200 character limit.","Error")
		return
	if(!star_desc)
		return

	var/turf/our_turf = get_turf(user)

	var/obj/item/clothing/accessory/gold_sticker/p = new /obj/item/clothing/accessory/gold_sticker(our_turf)

	p.desc = "A gold star issued by [user] for [star_title], if you look closely, the fine print reads: [star_desc]"
	p.name = "Gold Star for [star_title]"
	playsound(user, 'sound/items/ticket_printer.ogg', 75, 1)

	log_admin("[key_name(user)] has printed a Gold Star for [star_title] with the description: \"[star_desc]\"")
	last_print = world.time

/obj/item/clothing/accessory/gold_sticker
	name = "Gold Star"
	desc = "A gold star!"
	icon_state = "gold_sticker"
	slot = ACCESSORY_SLOT_TIE

/obj/item/clothing/accessory/gold_sticker/afterattack(atom/target, mob/user)
	if(!user)
		return
	if(!user.Adjacent(target))
		return
	if(isobj(target) && !istype(target,/obj/item/clothing/under))
		var/obj/O = target
		apply_sticker(O,user)
		return
	if(isanimal(target) || issilicon(target))
		var/mob/living/M = target
		if(M.client)
			var/accepting = tgui_alert(M,"[user] is attempting to stick a [src] on you. Will you allow this?","Sticker!",list("No","Yes"))
			if(!accepting || (accepting == "No"))
				to_chat(user, span_warning("\The [M] does not allow you to stick the [src] on them."))
				return
			else
				apply_sticker(M,user)
				to_chat(M, span_notice("\The [user] stuck \the [src] to you!"))
				return
		else
			apply_sticker(M,user)
			return
	. = ..()

/obj/item/clothing/accessory/gold_sticker/proc/apply_sticker(atom/target, mob/user)
	if(!user)
		return
	if(!user.Adjacent(target))
		return
	if(user.get_active_hand() != src)
		to_chat(user, span_warning("You need to have \the [src] in your active hand to apply it to something."))
		return
	target.desc = "[target.desc] It has a [src] stuck to it!"
	target.description_fluff = "[target.description_fluff] Attached to it is [desc]"
	to_chat(user, span_notice("You stick \the [src] to \the [target]."))
	user.drop_item()
	qdel(src)
	return
