/datum/artifact_effect/common/sweating
	name = "sweating"
	var/list/reagents = list()
	effect_type = EFFECT_ORGANIC
	effect_state = "oozes"


/datum/artifact_effect/common/sweating/New(datum/component/artifact_master/newmaster)
	reagents += list(list(pick(SSchemistry.chemical_reagents), 0.4, list()))
	if(prob(33))
		reagents += list(list("blood",
		                      0.6,
							  list("blood_colour" = rgb(rand(1,255),rand(1,255),rand(1,255)))))

	// Sample the color of the combined reagents
	var/datum/reagents/R = new(120)
	for(var/list/chem in reagents)
		R.add_reagent(chem[1], chem[2], chem[3])
	effect_color = R.get_color()
	qdel(R)

	..()
	effect = EFFECT_TOUCH


/datum/artifact_effect/common/sweating/proc/disgorge(var/turf/T, var/min_chargelevel = 0.25)
	if(chargelevel < chargelevelmax * min_chargelevel)
		return
	spawn()
		var/obj/effect/vfx/water/splash = new(T)
		splash.create_reagents(15)
		splash.reagents.add_reagent("blood", 10, list("blood_colour" = effect_color))
		splash.set_color()

		splash.set_up(T, 2, 3)

	var/obj/effect/decal/cleanable/chemcoating/blood = locate() in T
	if(!istype(blood))
		blood = new(T)
	for(var/list/chem in reagents)
		blood.reagents.add_reagent(chem[1], chem[2] * chargelevel, LAZYLEN(chem) > 2 ? chem[3] : null)
	blood.update_icon()
	chargelevel = round(0.8 * chargelevel)


// Leave a trail of "disgusting ooze"
/datum/artifact_effect/common/sweating/UpdateMove(var/turf/old_loc)
	disgorge(old_loc)


/datum/artifact_effect/common/sweating/DoEffectTouch(mob/living/carbon/human/user)
	if(ishuman(user))
		user.bloody_hands()
	if(chargelevel >= 40 && prob(20))
		user.visible_message(
			"<span class='alium'>\The [get_master_holder()] shudders at \the [user]'s touch, before spraying a disgusting ooze everywhere.</span>",
			"<span class='alium'>\The [get_master_holder()] shudders at your touch, before spraying a disgusting ooze all over you!</span>",
			"<span class='notice'>A spray of liquid is followed by a fleshy slop hitting the ground.</span>")
		if(ishuman(user))
			user.bloody_body()
		disgorge(get_turf(user), 0)


/datum/artifact_effect/common/sweating/attackby(mob/living/user, obj/item/I)
	if(I.is_open_container())
		to_chat(user, "<span class='alien'>You hold \the [I] against \the [get_master_holder()], and a disgusting pus dribbles into \the [I].</span>")
		for(var/list/chem in reagents)
			I.reagents.add_reagent(chem[0], chem[1] * chargelevel, LAZYLEN(chem) > 2 ? chem[2] : null)
		return TRUE
	else
		I.add_blood(src)
	return FALSE
