/obj/item/paper_bin
	name = "paper bin"
	desc = "A plastic bin full of paper. It seems to have both regular and carbon-copy paper to choose from."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
			)
	item_state = "sheet-metal"
	throwforce = 1
	w_class = ITEMSIZE_NORMAL
	throw_speed = 3
	throw_range = 7
	pressure_resistance = 10
	layer = OBJ_LAYER - 0.1
	var/amount = 30					//How much paper is in the bin.
	var/list/papers = new/list()	//List of papers put in the bin for reference.
	drop_sound = 'sound/items/drop/cardboardbox.ogg'
	pickup_sound = 'sound/items/pickup/cardboardbox.ogg'


/obj/item/paper_bin/MouseDrop(mob/user)
	if(user == usr && !(user.restrained() || user.stat) && (user.contents.Find(src) || in_range(src, user)))
		if(!isanimal(user))
			if( !user.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]

				if (H.hand)
					temp = H.organs_by_name[BP_L_HAND]
				if(temp && !temp.is_usable())
					to_chat(user, span_notice("You try to move your [temp.name], but cannot!"))
					return

				to_chat(user, span_notice("You pick up the [src]."))
				user.put_in_hands(src)

	return

/obj/item/paper_bin/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, span_notice("You try to move your [temp.name], but cannot!"))
			return
	var/response = ""
	if(!papers.len > 0)
		response = tgui_alert(user, "Do you take regular paper, or Carbon copy paper?", "Paper type request", list("Regular", "Carbon-Copy", "Cancel"))
		if (response != "Regular" && response != "Carbon-Copy")
			add_fingerprint(user)
			return
	if(amount >= 1)
		amount--
		if(amount==0)
			update_icon()

		var/obj/item/paper/P
		if(papers.len > 0)	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[papers.len]
			papers.Remove(P)
		else
			if(response == "Regular")
				P = new /obj/item/paper
				if(Holiday == "April Fool's Day")
					if(prob(30))
						P.info = span_red(span_bold("<font face=\"[P.crayonfont]\">HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</font>"))
						P.rigged = 1
						P.updateinfolinks()
			else if (response == "Carbon-Copy")
				P = new /obj/item/paper/carbon

		P.loc = user.loc
		user.put_in_hands(P)
		to_chat(user, span_notice("You take [P] out of the [src]."))
	else
		to_chat(user, span_notice("[src] is empty!"))

	add_fingerprint(user)
	return


/obj/item/paper_bin/attackby(obj/item/paper/i as obj, mob/user as mob)
	if(!istype(i))
		return

	user.drop_item()
	i.loc = src
	to_chat(user, span_notice("You put [i] in [src]."))
	papers.Add(i)
	update_icon()
	amount++


/obj/item/paper_bin/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(amount)
			. += span_notice("There " + (amount > 1 ? "are [amount] papers" : "is one paper") + " in the bin.")
		else
			. += span_notice("There are no papers in the bin.")

/obj/item/paper_bin/update_icon()
	if(amount < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"
