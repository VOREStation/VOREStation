/obj/item/weapon/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon_state = "chain"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

	suicide_act(mob/user)
		var/datum/gender/T = gender_datums[user.get_visible_gender()]
		user.visible_message(span("danger", "\The [user] [T.is] strangling [T.himself] with \the [src]! It looks like [T.he] [T.is] trying to commit suicide."), span("danger", "You start to strangle yourself with \the [src]!"), span("danger", "You hear the sound of someone choking!"))
		return (OXYLOSS)

/obj/item/weapon/melee/umbrella
	name = "umbrella"
	desc = "To keep the rain off you. Use with caution on windy days."
	icon = 'icons/obj/items.dmi'
	icon_state = "umbrella_closed"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 5
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	var/open = FALSE

/obj/item/weapon/melee/umbrella/New()
	..()
	color = "#"+get_random_colour()
	update_icon()

/obj/item/weapon/melee/umbrella/attack_self()
	src.toggle_umbrella()

/obj/item/weapon/melee/umbrella/proc/toggle_umbrella()
	open = !open
	icon_state = "umbrella_[open ? "open" : "closed"]"
	item_state = icon_state
	update_icon()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		H.update_inv_l_hand(0)
		H.update_inv_r_hand()
	..()