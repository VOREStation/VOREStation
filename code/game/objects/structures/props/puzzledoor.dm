// An indestructible blast door that can only be opened once its puzzle requirements are completed.

/obj/machinery/door/blast/puzzle
	name = "puzzle door"
	desc = "A large, virtually indestructible door that will not open unless certain requirements are met."
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"

	explosion_resistance = 100

	maxhealth = 9999999 //No.

	var/list/locks = list()
	var/lockID = null
	var/checkrange_mult = 1

/obj/machinery/door/blast/puzzle/proc/check_locks()
	if(!locks || locks.len <= 0)	// Puzzle doors with no locks will only listen to boring buttons.
		return 0

	for(var/obj/structure/prop/lock/L in locks)
		if(!L.enabled)
			return 0
	return 1

/obj/machinery/door/blast/puzzle/bullet_act(var/obj/item/projectile/Proj)
	if(!istype(Proj, /obj/item/projectile/test))
		visible_message(span_cult("\The [src] is completely unaffected by \the [Proj]."))
	qdel(Proj) //No piercing. No.

/obj/machinery/door/blast/puzzle/ex_act(severity)
	visible_message(span_cult("\The [src] is completely unaffected by the blast."))
	return

/obj/machinery/door/blast/puzzle/Initialize(mapload)
	. = ..()
	implicit_material = get_material_by_name("dungeonium")
	if(locks.len)
		return
	var/check_range = world.view * checkrange_mult
	for(var/obj/structure/prop/lock/L in orange(src, check_range))
		if(L.lockID == lockID)
			L.linked_objects |= src
			locks |= L

/obj/machinery/door/blast/puzzle/Destroy()
	if(locks.len)
		for(var/obj/structure/prop/lock/L in locks)
			L.linked_objects -= src
			locks -= L
	. = ..()

/obj/machinery/door/blast/puzzle/attack_hand(mob/user as mob)
	if(check_locks())
		force_toggle(1, user)
	else
		to_chat(user, span_notice("\The [src] does not respond to your touch."))

/obj/machinery/door/blast/puzzle/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item))
		if(C.pry == 1 && (user.a_intent != I_HURT || (stat & BROKEN)))
			if(istype(C,/obj/item/material/twohanded/fireaxe))
				var/obj/item/material/twohanded/fireaxe/F = C
				if(!F.wielded)
					to_chat(user, span_warning("You need to be wielding \the [F] to do that."))
					return

			if(check_locks())
				force_toggle(1, user)

			else
				to_chat(user, span_notice("[src]'s arcane workings resist your effort."))
			return

		else if(src.density && (user.a_intent == I_HURT))
			var/obj/item/W = C
			user.setClickCooldown(user.get_attack_speed(W))
			if(W.damtype == BRUTE || W.damtype == BURN)
				user.do_attack_animation(src)
				user.visible_message(span_danger("\The [user] hits \the [src] with \the [W] with no visible effect."))

		else if(istype(C, /obj/item/plastique))
			to_chat(user, span_danger("On contacting \the [src], a flash of light envelops \the [C] as it is turned to ash. Oh."))
			qdel(C)
			return 0

/obj/machinery/door/blast/puzzle/attack_generic(var/mob/user, var/damage)
	if(check_locks())
		force_toggle(1, user)

/obj/machinery/door/blast/puzzle/attack_alien(var/mob/user)
	if(check_locks())
		force_toggle(1, user)
