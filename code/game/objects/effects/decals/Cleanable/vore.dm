////////////CHOMP CLEANABLE REAGENT PUDDLES/////////////////////

/obj/effect/decal/cleanable/blood/reagent //Yes, we are using the blood system for this
	name = "liquid"
	dryname = "dried liquid"
	desc = "It's a liquid, how boring and bland."
	drydesc = "It's dry and crusty and boring and bland."
	basecolor = "#FFFFFF"
	var/ckey_source = null		//The person the liquid came from
	var/ckey_spawner = null		//The person who extracted the reagent

	var/custombasename = null
	var/custombasedesc = null
	var/custombasecolor = null

/obj/effect/decal/cleanable/blood/reagent/New(var/spill_name, var/spill_color, var/spill_reagentid, var/new_amount, var/ckey_user, var/ckey_spawn)
	switch(spill_reagentid)	//To ensure that if people spill some liquids, it wont cause issues with spawning, like spilling blood. Also allow for spilling of certain things to
		if("blood")
			return
		if("water")		//Dont recall if we have a water puddle system, but keeping this blacklisted, would be silly with dried water puddles.
			return

	ckey_source = ckey_spawn
	ckey_spawner = ckey_user

	name = "[spill_name]"
	dryname = "dried [spill_name]"
	desc = "It's a puddle of [spill_name]"
	drydesc = "It's a dried puddle of [spill_name]"
	basecolor = spill_color
	amount = new_amount

	custombasename = "[spill_name]"
	custombasedesc = "It's a puddle of [spill_name]"
	custombasecolor = spill_color

	update_icon()
	START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/blood/reagent/update_icon()
	if(custombasecolor == "rainbow") custombasecolor = get_random_colour(1)

	color = custombasecolor
	name = custombasename
	desc = custombasedesc

/obj/effect/decal/cleanable/blood/reagent/Crossed(mob/living/carbon/human/perp)
	//Nothing, we dont wanna spread our mess all over, at least not until people want that
