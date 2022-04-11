// For general use
/obj/item/weapon/gun/projectile/shotgun/pump/USDF
	name = "\improper USDF tactical shotgun"
	desc = "All you greenhorns who wanted to see Xenomorphs up close... this is your lucky day. Uses 12g rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "haloshotgun"
	icon_override = 'icons/obj/gun_vr.dmi'
	item_state = "haloshotgun_i"
	item_icons = null
	ammo_type = /obj/item/ammo_casing/a12g
	max_shells = 12

//Warden's shotgun gets it's own entry now, rather than being handled by the maps
/obj/item/weapon/gun/projectile/shotgun/pump/combat/warden
	name = "warden's shotgun"
	desc = "Built for close quarters combat, the Hephaestus Industries KS-40 is widely regarded as a weapon of choice for repelling boarders. This one has 'Property of the Warden' inscribed on the stock."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' branding for its military-grade equipment used by armed forces across human space."
	ammo_type = /obj/item/ammo_casing/a12g/beanbag

//Compact shotgun, this version's for usage later by mappers/coders/w.e.
/obj/item/weapon/gun/projectile/shotgun/compact
	name = "compact shotgun"
	desc = "Built for <i>extremely</i>-close quarters combat, the Hephaestus Industries KS-55 \"semi-auto shorty\" is a relatively rare sight to see, usually in the hands of elite troops that specialize in boarding. Uses 12g rounds."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' branding for its military-grade equipment used by armed forces across human space."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "compshotc"
	item_state = "cshotgun"
	max_shells = 4 //short magazine tube means small capacity
	w_class = ITEMSIZE_NORMAL //Starts folded, becomes large when stock is extended
	force = 10
	slot_flags = SLOT_BELT|SLOT_BACK
	caliber = "12g"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	load_method = SINGLE_CASING|SPEEDLOADER
	handle_casings = EJECT_CASINGS //However, it's semi-automatic to make up for that
	ammo_type = /obj/item/ammo_casing/a12g
	projectile_type = /obj/item/projectile/bullet/shotgun
	one_handed_penalty = 30 //You madman, one-handing a 12g shotgun.
	recoil = 5 //Unfold the damn stock you fool!
	action_button_name = "Toggle stock"
	var/stock = FALSE


/obj/item/weapon/gun/projectile/shotgun/compact/proc/toggle_stock()
	var/mob/living/user = loc
	stock = !stock
	if(stock)
		user.visible_message("<span class='warning'>With a fluid movement, [user] unfolds their shotgun's stock and foregrip.</span>",\
		"<span class='warning'>You unfold the shotgun's stock and foregrip.</span>",\
		"You hear an ominous click.")
		icon_state = "compshot"
		item_state = icon_state
		w_class = ITEMSIZE_LARGE
		one_handed_penalty = 15 //Stock extended to steady it, even with just the one hand.
		recoil = 1 //As above, stock and foregrip would help with the kick
	else
		user.visible_message("<b>\The [user]</b> collapses their shotgun's stock and fold it's foregrip.",\
		"<span class='notice'>You fold the shotgun's stock and foregrip.</span>",\
		"You hear a click.")
		icon_state = "compshotc"
		item_state = icon_state
		w_class = ITEMSIZE_NORMAL
		one_handed_penalty = 30
		recoil = 5

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src, 'sound/weapons/targeton.ogg', 50, 1)
	user.update_action_buttons()

/obj/item/weapon/gun/projectile/shotgun/compact/verb/verb_toggle_stock(mob/user as mob)
	set category = "Object"
	set name = "Toggle stock"
	set src in usr

	if(issilicon(usr))
		return

	if (isliving(usr))
		toggle_stock()
	else
		to_chat(usr, "<span class='notice'>You cannot do this in your current state.</span>")


/obj/item/weapon/gun/projectile/shotgun/compact/attack_self(mob/user as mob)
	if(issilicon(usr))
		return

	if (isliving(usr))
		toggle_stock()
	else
		to_chat(usr, "<span class='notice'>You cannot do this in your current state.</span>")

/obj/item/weapon/gun/projectile/shotgun/compact/ui_action_click()
	var/mob/living/user = loc
	if(!isliving(user))
		return
	else
		toggle_stock()

/obj/item/weapon/gun/projectile/shotgun/compact/warden
	name = "warden's compact shotgun"
	desc = "Built for <i>extremely</i>-close quarters combat, the Hephaestus Industries KS-55 \"semi-auto shorty\" is a relatively rare sight to see, usually in the hands of elite troops that specialize in boarding. This one has 'Property of the Warden' inscribed on the upper receiver."
	description_fluff = "The leading arms producer in the SCG, Hephaestus typically only uses its 'top level' branding for its military-grade equipment used by armed forces across human space."
	ammo_type = /obj/item/ammo_casing/a12g/beanbag
