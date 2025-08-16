/*
 * "Magic" "Guns"
 */

/obj/item/gun/magic
	name = "staff of nothing"
	desc = "This staff is boring to watch because even though it came first you've seen everything it can do in other staves for years."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staffofnothing"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_magic.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_magic.dmi',
		)
	fire_sound = 'sound/weapons/emitter.ogg'
	w_class = ITEMSIZE_HUGE
	projectile_type = null
	var/checks_antimagic = TRUE
	var/max_charges = 6
	var/charges = 0
	var/recharge_rate = 4
	var/charge_tick = 0
	var/can_charge = TRUE

/obj/item/gun/magic/consume_next_projectile()
	if(checks_antimagic && locate(/obj/item/nullrod) in usr) return null
	if(!ispath(projectile_type)) return null
	if(charges <= 0) return null

	charges -= 1

	return new projectile_type(src)

/obj/item/gun/magic/Initialize(mapload)
	. = ..()
	charges = max_charges
	if(can_charge)
		START_PROCESSING(SSobj, src)

/obj/item/gun/magic/Destroy()
	if(can_charge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/magic/process()
	if (charges >= max_charges)
		charge_tick = 0
		return
	charge_tick++
	if(charge_tick < recharge_rate)
		return 0
	charge_tick = 0
	charges++
	return 1

/obj/item/gun/magic/handle_click_empty(mob/user)
	if (user)
		user.visible_message("*wzhzhzh*", span_danger("The [name] whizzles quietly."))
	else
		src.visible_message("*wzhzh*")
	playsound(src, 'sound/weapons/empty.ogg', 100, 1)
