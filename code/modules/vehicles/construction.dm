/*
 * Construction!
 */

/obj/item/weapon/vehicle_assembly
	name = "vehicle assembly"
	desc = "The frame of some vehicle."
	icon = 'icons/obj/vehicles_64x64.dmi'
	icon_state = "quad-frame"
	item_state = "buildpipe"

	density = TRUE
	slowdown = 10 //It's a vehicle frame, what do you expect?
	w_class = 5
	pixel_x = -16

	var/build_stage = 0
	var/obj/item/weapon/cell/cell = null

/obj/item/weapon/vehicle_assembly/New()
	..()
	icon_state = "[initial(icon_state)][build_stage]"
	update_icon()

/obj/item/weapon/vehicle_assembly/proc/increase_step(var/new_name = null)
	build_stage++
	if(new_name)
		name = new_name
	icon_state = "[initial(icon_state)][build_stage]"
	update_icon()
	return 1

/*
 * Quadbike and trailer.
 */

/obj/item/weapon/vehicle_assembly/quadbike
	name = "all terrain vehicle assembly"
	desc = "The frame of an ATV."
	icon_state = "quad-frame"

/obj/item/weapon/vehicle_assembly/quadbike/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()

	switch(build_stage)
		if(0)
			if(istype(W, /obj/item/stack/material/plastic))
				var/obj/item/stack/material/plastic/P = W
				if (P.get_amount() < 8)
					to_chat(user, "<span class='warning'>You need eight sheets of plastic to add tires to \the [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to add tires to [src].</span>")
				if(do_after(user, 40) && build_stage == 0)
					if(P.use(8))
						to_chat(user, "<span class='notice'>You add tires to \the [src].</span>")
						increase_step("wheeled [initial(name)]")
				return

		if(1)
			if(istype(W, /obj/item/weapon/stock_parts/console_screen))
				user.drop_item()
				qdel(W)
				to_chat(user, "<span class='notice'>You add the lights to \the [src].</span>")
				increase_step()
				return

		if(2)
			if(istype(W, /obj/item/weapon/stock_parts/spring))
				user.drop_item()
				qdel(W)
				to_chat(user, "<span class='notice'>You add the control system to \the [src].</span>")
				increase_step()
				return
			if(istype(W, /obj/item/stack/material/steel))
				var/obj/item/stack/material/steel/S = W
				if(S.get_amount() < 5)
					to_chat(user, "<span class='warning'>You need five sheets of steel to convert \the [src] into a trailer.</span>")
				if(do_after(user, 80) && build_stage == 2)
					if(S.use(5))
						var/obj/item/weapon/vehicle_assembly/quadtrailer/Trailer = new(src)
						Trailer.forceMove(get_turf(src))
						Trailer.increase_step("framed [initial(Trailer.name)]")
						to_chat(user, "<span class='notice'>You convert \the [src] into \the [Trailer].</span>")
						user.drop_from_inventory(src)
						qdel(src)
				return

		if(3)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need two coils of wire to wire [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to wire [src].</span>")
				if(do_after(user, 40) && build_stage == 3)
					if(C.use(2))
						to_chat(user, "<span class='notice'>You wire \the [src].</span>")
						increase_step("wired [initial(name)]")
				return

		if(4)
			if(istype(W, /obj/item/weapon/cell))
				user.drop_item()
				W.forceMove(src)
				cell = W
				to_chat(user, "<span class='notice'>You add the power supply to \the [src].</span>")
				increase_step("powered [initial(name)]")
				return

		if(5)
			if(istype(W, /obj/item/weapon/stock_parts/motor))
				user.drop_item()
				qdel(W)
				to_chat(user, "<span class='notice'>You add the motor to \the [src].</span>")
				increase_step()
				return

		if(6)
			if(istype(W, /obj/item/stack/material/plasteel))
				var/obj/item/stack/material/plasteel/PL = W
				if (PL.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need two sheets of plasteel to add reinforcement to \the [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to add reinforcement to [src].</span>")
				if(do_after(user, 40) && build_stage == 6)
					if(PL.use(2))
						to_chat(user, "<span class='notice'>You add reinforcement to \the [src].</span>")
						increase_step("reinforced [initial(name)]")
					return

		if(7)
			if(W.is_wrench() || W.is_screwdriver())
				playsound(loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You begin your finishing touches on \the [src].</span>")
				if(do_after(user, 20) && build_stage == 7)
					playsound(loc, W.usesound, 30, 1)
					var/obj/vehicle/train/engine/quadbike/built/product = new(src)
					to_chat(user, "<span class='notice'>You finish \the [product]</span>")
					product.loc = get_turf(src)
					product.cell = cell
					cell.forceMove(product)
					cell = null
					user.drop_from_inventory(src)
					qdel(src)
				return

/obj/item/weapon/vehicle_assembly/quadtrailer
	name = "all terrain trailer"
	desc = "The frame of a small trailer."
	icon_state = "quadtrailer-frame"

/obj/item/weapon/vehicle_assembly/quadtrailer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()

	switch(build_stage)
		if(0)
			if(istype(W, /obj/item/weapon/vehicle_assembly/quadbike))
				var/obj/item/weapon/vehicle_assembly/quadbike/Q = W
				if(Q.build_stage > 2)
					to_chat(user, "<span class='notice'>\The [Q] is too advanced to be of use with \the [src]</span>")
					return
				user.drop_item()
				qdel(W)
				increase_step("framed [initial(name)]")

		if(1)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need two coils of wire to wire [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to wire [src].</span>")
				if(do_after(user, 40) && build_stage == 1)
					if(C.use(2))
						to_chat(user, "<span class='notice'>You wire \the [src].</span>")
						increase_step("wired [initial(name)]")
				return

		if(2)
			if(W.is_screwdriver())
				playsound(loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You close up \the [src].</span>")
				var/obj/vehicle/train/trolley/trailer/product = new(src)
				product.loc = get_turf(src)
				user.drop_from_inventory(src)
				qdel(src)
				return

/*
 * Space bike.
 */

/obj/item/weapon/vehicle_assembly/spacebike
	name = "vehicle assembly"
	desc = "The frame of some vehicle."
	icon = 'icons/obj/bike.dmi'
	icon_state = "bike-frame"

	pixel_x = 0

/obj/item/weapon/vehicle_assembly/spacebike/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	switch(build_stage)
		if(0)
			if(istype(W, /obj/item/weapon/tank/jetpack) || istype(W, /obj/item/borg/upgrade/jetpack))
				user.drop_item()
				qdel(W)
				increase_step()

		if(1)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/C = W
				if (C.get_amount() < 2)
					to_chat(user, "<span class='warning'>You need two coils of wire to wire [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to wire [src].</span>")
				if(do_after(user, 40) && build_stage == 1)
					if(C.use(2))
						to_chat(user, "<span class='notice'>You wire \the [src].</span>")
						increase_step("wired [initial(name)]")
				return

		if(2)
			if(istype(W, /obj/item/stack/material/plastic))
				var/obj/item/stack/material/plastic/P = W
				if (P.get_amount() < 3)
					to_chat(user, "<span class='warning'>You need three sheets of plastic to add a seat to \the [src].</span>")
					return
				to_chat(user, "<span class='notice'>You start to add a seat to [src].</span>")
				if(do_after(user, 40) && build_stage == 2)
					if(P.use(3))
						to_chat(user, "<span class='notice'>You add a seat to \the [src].</span>")
						increase_step("seated [initial(name)]")
				return

		if(3)
			if(istype(W, /obj/item/weapon/stock_parts/console_screen))
				user.drop_item()
				qdel(W)
				to_chat(user, "<span class='notice'>You add the lights to \the [src].</span>")
				increase_step()
				return

		if(4)
			if(istype(W, /obj/item/weapon/stock_parts/spring))
				user.drop_item()
				qdel(W)
				to_chat(user, "<span class='notice'>You add the control system to \the [src].</span>")
				increase_step()
				return

		if(5)
			if(istype(W, /obj/item/weapon/cell))
				user.drop_item()
				W.forceMove(src)
				cell = W
				to_chat(user, "<span class='notice'>You add the power supply to \the [src].</span>")
				increase_step("powered [initial(name)]")
				return

		if(6)
			if(W.is_wrench() || W.is_screwdriver())
				playsound(loc, W.usesound, 50, 1)
				to_chat(user, "<span class='notice'>You begin your finishing touches on \the [src].</span>")
				if(do_after(user, 20) && build_stage == 6)
					playsound(loc, W.usesound, 30, 1)
					var/obj/vehicle/bike/built/product = new(src)
					to_chat(user, "<span class='notice'>You finish \the [product]</span>")
					product.loc = get_turf(src)
					product.cell = cell
					cell.forceMove(product)
					cell = null
					user.drop_from_inventory(src)
					qdel(src)
				return
