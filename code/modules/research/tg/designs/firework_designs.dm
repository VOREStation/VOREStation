// Firework Stars

/datum/design_techweb/firework_star/New()
	. = ..()
	name = "Firework Star ([name])"

/datum/design_techweb/firework_star/aesthetic
	name = "aesthetic"
	desc = "A firework star, designed for use with launcher. Produces variable amount of joy."
	id = "fireworkaesthetic"
	// req_tech = list(TECH_MATERIAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 500, MAT_GLASS = 500)
	build_path = /obj/item/firework_star/aesthetic
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/aesthetic_config
	name = "aesthetic - configurable"
	desc = "A firework star, designed for use with launcher. Produces variable amount of joy. Can be modified to produce specific forms."
	id = "fireworkaestheticconfig"
	// req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/firework_star/aesthetic/configurable
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_clear
	name = "weather - CLEAR"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one clears the sky."
	id = "fireworkclearsky"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_STEEL = 4000)
	build_path = /obj/item/firework_star/weather/clear
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_overcast
	name = "weather - CLOUDY"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates some clouds."
	id = "fireworkcloudy"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 1000)
	build_path = /obj/item/firework_star/weather/overcast
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_fog
	name = "weather - FOG"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates fog."
	id = "fireworkfog"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 2000)
	build_path = /obj/item/firework_star/weather/fog
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_rain
	name = "weather - RAIN"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates rain."
	id = "fireworkrain"
	// req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 4000)
	build_path = /obj/item/firework_star/weather/rain
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_storm
	name = "weather - STORM"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a rainstorm."
	id = "fireworkstorm"
	// req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000, MAT_GOLD = 1000)
	build_path = /obj/item/firework_star/weather/storm
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_light_snow
	name = "weather - LIGHT SNOW"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a light snowfall."
	id = "fireworklightsnow"
	// req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_LEAD = 2000)
	build_path = /obj/item/firework_star/weather/light_snow
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_snow
	name = "weather - MODERATE SNOW"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a moderate snowfall."
	id = "fireworksnow"
	// req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000, MAT_LEAD = 2000)
	build_path = /obj/item/firework_star/weather/snow
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_blizzard
	name = "weather - HEAVY SNOW"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a blizzard."
	id = "fireworkblizzard"
	// req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000, MAT_LEAD = 3000)
	build_path = /obj/item/firework_star/weather/blizzard
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_hail
	name = "weather - HAIL"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a hailstorm. DANGEROUS."
	id = "fireworkhail"
	// req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_ILLEGAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000, MAT_LEAD = 3000, MAT_PLASTEEL = 4000)
	build_path = /obj/item/firework_star/weather/hail
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_confetti
	name = "weather - CONFETTI"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one clears the sky and rains colorful confetti from it."
	id = "fireworkconfetti"
	// req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 10000, MAT_GLASS = 10000)
	build_path = /obj/item/firework_star/weather/confetti
	category = list(
		RND_CATEGORY_FIREWORKS
	)

/datum/design_techweb/firework_star/weather_fallout
	name = "weather - NUCLEAR"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a heavy cloud of nuclear fallout. DANGEROUS."
	id = "fireworkfallout"
	// req_tech = list(TECH_MATERIAL = 8, TECH_ENGINEERING = 6, TECH_ILLEGAL = 7)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_URANIUM = 12000)
	build_path = /obj/item/firework_star/weather/fallout
	category = list(
		RND_CATEGORY_FIREWORKS
	)
