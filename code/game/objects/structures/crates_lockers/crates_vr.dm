/obj/structure/closet/crate/secure
	var/tamper_proof = 0

/obj/structure/closet/crate/secure/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(locked && tamper_proof && health <= Proj.damage)
		if(tamper_proof == 2) // Mainly used for events to prevent any chance of opening the box improperly.
			visible_message("<font color='red'><b>The anti-tamper mechanism of [src] triggers an explosion!</b></font>")
			var/turf/T = get_turf(src.loc)
			explosion(T, 0, 0, 0, 1) // Non-damaging, but it'll alert security.
			qdel(src)
			return
		var/open_chance = rand(1,5)
		switch(open_chance)
			if(1)
				visible_message("<font color='red'><b>The anti-tamper mechanism of [src] causes an explosion!</b></font>")
				var/turf/T = get_turf(src.loc)
				explosion(T, 0, 0, 0, 1) // Non-damaging, but it'll alert security.
				qdel(src)
			if(2 to 4)
				visible_message("<font color='red'><b>The anti-tamper mechanism of [src] causes a small fire!</b></font>")
				for(var/atom/movable/A as mob|obj in src) // For every item in the box, we spawn a pile of ash.
					new /obj/effect/decal/cleanable/ash(src.loc)
				new /obj/fire(src.loc)
				qdel(src)
			if(5)
				visible_message("<font color='green'><b>The anti-tamper mechanism of [src] fails!</b></font>")
		return

	..()

	return

/obj/structure/closet/crate/medical/blood
	icon_state = "blood"
	icon_opened = "bloodopen"
	icon_closed = "blood"