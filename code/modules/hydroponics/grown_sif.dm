/obj/item/food/grown/sif
	var/seeds = 0

/obj/item/food/grown/sif/Initialize(mapload, planttype) // Wild Sifplants have some seeds you can extract with a knife.
	. = ..()
	seeds = rand(1, 2)

/obj/item/food/grown/sif/examine(mob/user)
	. = ..()
	if(seeds)
		to_chat(user, span_notice("You can see [seeds] seed\s in \the [src]. You might be able to extract them with a sharp object."))

/obj/item/food/grown/sif/attackby(var/obj/item/W, var/mob/living/user)
	if(seed && W.sharp && seeds > 0)
		var/take_seeds = min(seeds, rand(1,2))
		seeds -= take_seeds
		to_chat(user, span_notice("You stick \the [W] into \the [src] and lever out [take_seeds] seed\s."))
		for(var/i = 1 to take_seeds)
			new /obj/item/seeds(get_turf(src), seed.name)
		return
	. = ..()

/obj/item/food/grown/sif/sifpod
	plantname = PLANT_SIFBULB

/obj/item/food/grown/sif/wabback
	plantname = PLANT_WHITEWABBACK

/obj/item/food/grown/sif/blackwabback
	plantname = PLANT_BLACKWABBACK

/obj/item/food/grown/sif/wildwabback
	plantname = PLANT_WILDWABBACK

/obj/item/food/grown/sif/eyebulbs
	plantname = "eyebulbs"

/obj/item/food/grown/sif/cavebulbs
	plantname = "cavebulbs"
