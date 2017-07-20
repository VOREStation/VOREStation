/atom/proc/stumble_into(mob/living/M)
	playsound(get_turf(M), "punch", 25, 1, -1)
	visible_message("<span class='warning'>[M] [pick("ran", "slammed")] into \the [src]!</span>")
	to_chat(M, "<span class='warning'>You just [pick("ran", "slammed")] into \the [src]!</span>")
	M.apply_damage(5, BRUTE)
	M.Weaken(2)

/obj/structure/table/stumble_into(mob/living/M)
	var/obj/occupied = turf_is_crowded()
	if(occupied)
		return ..()
	if(material)
		playsound(get_turf(src), material.tableslam_noise, 25, 1, -1)
	else
		playsound(get_turf(src), 'sound/weapons/tablehit1.ogg', 25, 1, -1)
	visible_message("<span class='warning'>[M] flopped onto \the [src]!</span>")
	M.apply_damage(5, BRUTE)
	M.Weaken(2)
	M.forceMove(get_turf(src))

/obj/machinery/disposal/stumble_into(mob/living/M)
	playsound(get_turf(src), 'sound/effects/clang.ogg', 25, 1, -1)
	visible_message("<span class='warning'>[M] [pick("tripped", "stumbled")] into \the [src]!</span>")
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.apply_damage(5, BRUTE)
	M.Weaken(2)
	M.forceMove(src)
	update()

/obj/structure/inflatable/stumble_into(mob/living/M)
	playsound(get_turf(M), "sound/effects/Glasshit.ogg", 25, 1, -1)
	visible_message("<span class='warning'>[M] [pick("ran", "slammed")] into \the [src]!</span>")
	M.Weaken(1)

/obj/structure/kitchenspike/stumble_into(mob/living/M)
	playsound(get_turf(M), "sound/weapons/pierce.ogg", 25, 1, -1)
	visible_message("<span class='warning'>[M] [pick("ran", "slammed")] into the spikes on \the [src]!</span>")
	M.apply_damage(15, BRUTE, sharp=1)
	M.Weaken(5)

/obj/structure/m_tray/stumble_into(mob/living/M)
	playsound(get_turf(src), 'sound/weapons/tablehit1.ogg', 25, 1, -1)
	visible_message("<span class='warning'>[M] flopped onto \the [src]!</span>")
	M.apply_damage(5, BRUTE)
	M.Weaken(2)
	M.forceMove(get_turf(src))

/obj/structure/c_tray/stumble_into(mob/living/M)
	playsound(get_turf(src), 'sound/weapons/tablehit1.ogg', 25, 1, -1)
	visible_message("<span class='warning'>[M] flopped onto \the [src]!</span>")
	M.apply_damage(5, BRUTE)
	M.Weaken(2)
	M.forceMove(get_turf(src))

/obj/structure/window/stumble_into(mob/living/M)
	visible_message("<span class='warning'>[M] [pick("ran", "slammed")] into \the [src]!</span>")
	M.apply_damage(5, BRUTE)
	M.Weaken(2)
	hitby(M)

/obj/structure/railing/stumble_into(mob/living/M)
	var/obj/occupied = turf_is_crowded()
	if(occupied)
		return ..()
	playsound(get_turf(src), 'sound/misc/slip.ogg', 25, 1, -1)
	visible_message("<span class='warning'>[M] [pick("tripped", "stumbled")] over \the [src]!</span>")
	M.Weaken(2)
	if(get_turf(M) == get_turf(src))
		M.forceMove(get_step(src, src.dir))
	else
		M.forceMove(get_turf(src))

/obj/machinery/door/stumble_into(mob/living/M)
	..()
	bumpopen(M)

/obj/machinery/cooker/fryer/stumble_into(mob/living/M)
	visible_message("<span class='warning'>[M] [pick("ran", "slammed")] into \the [src]!</span>")
	M.apply_damage(15, BURN)
	M.Weaken(5)
	M.emote("scream")

/obj/machinery/atmospherics/unary/cryo_cell/stumble_into(mob/living/M)
	if((stat & (NOPOWER|BROKEN)) || !istype(M, /mob/living/carbon) || occupant || M.abiotic() || !node)
		return ..()
	playsound(get_turf(src), 'sound/effects/Glasshit.ogg', 25, 1, -1)
	visible_message("<span class='warning'>[M] [pick("tripped", "stumbled")] into \the [src]!</span>")
	M.apply_damage(5, BRUTE)
	M.Weaken(2)
	put_mob(M)

/obj/machinery/porta_turret/stumble_into(mob/living/M)
	..()
	if(!attacked && !emagged)
		attacked = 1
		spawn()
			sleep(60)
			attacked = 0

/obj/machinery/space_heater/stumble_into(mob/living/M)
	..()
	if(on)
		M.apply_damage(10, BURN)
		M.emote("scream")

/obj/machinery/suit_storage_unit/stumble_into(mob/living/M)
	if(!ishuman(M) || !isopen || !ispowered || isbroken || OCCUPANT || HELMET || SUIT)
		return ..()
	playsound(get_turf(src), 'sound/effects/clang.ogg', 25, 1, -1)
	visible_message("<span class='warning'>[M] [pick("tripped", "stumbled")] into \the [src]!</span>")
	if(M.client)
		M.client.perspective = EYE_PERSPECTIVE
		M.client.eye = src
	M.forceMove(src)
	OCCUPANT = M
	isopen = 0
	update_icon()
	add_fingerprint(M)
	updateUsrDialog()

/obj/machinery/vending/stumble_into(mob/living/M)
	..()
	if(prob(2))
		throw_item()