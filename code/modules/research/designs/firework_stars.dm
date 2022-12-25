// Firework Stars

/datum/design/item/firework_star/AssembleDesignName()
	name = "Firework star prototype ([item_name])"

/datum/design/item/firework_star/aesthetic
	name = "aesthetic"
	desc = "A firework star, designed for use with launcher. Produces variable amount of joy."
	id = "fireworkaesthetic"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list(MAT_PLASTIC = 500, MAT_GLASS = 500)
	build_path = /obj/item/weapon/firework_star/aesthetic
	sort_string = "IFAAA"

/datum/design/item/firework_star/aesthetic_config
	name = "aesthetic - configurable"
	desc = "A firework star, designed for use with launcher. Produces variable amount of joy. Can be modified to produce specific forms."
	id = "fireworkaestheticconfig"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_PLASTIC = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/weapon/firework_star/aesthetic
	sort_string = "IFAAB"

/datum/design/item/firework_star/weather_clear
	name = "weather - CLEAR"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one clears the sky."
	id = "fireworkclearsky"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_STEEL = 4000)
	build_path = /obj/item/weapon/firework_star/weather/clear
	sort_string = "IFABA"

/datum/design/item/firework_star/weather_overcast
	name = "weather - CLOUDY"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates some clouds."
	id = "fireworkcloudy"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 1000)
	build_path = /obj/item/weapon/firework_star/weather/overcast
	sort_string = "IFABB"

/datum/design/item/firework_star/weather_rain
	name = "weather - RAIN"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates rain."
	id = "fireworkrain"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 4000)
	build_path = /obj/item/weapon/firework_star/weather/rain
	sort_string = "IFABC"

/datum/design/item/firework_star/weather_storm
	name = "weather - STORM"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a rainstorm."
	id = "fireworkstorm"
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000, MAT_GOLD = 1000)
	build_path = /obj/item/weapon/firework_star/weather/storm
	sort_string = "IFABD"

/datum/design/item/firework_star/weather_light_snow
	name = "weather - LIGHT SNOW"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a light snowfall."
	id = "fireworklightsnow"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_LEAD = 2000)
	build_path = /obj/item/weapon/firework_star/weather/light_snow
	sort_string = "IFABE"

/datum/design/item/firework_star/weather_snow
	name = "weather - MODERATE SNOW"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a moderate snowfall."
	id = "fireworksnow"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000, MAT_LEAD = 2000)
	build_path = /obj/item/weapon/firework_star/weather/snow
	sort_string = "IFABF"

/datum/design/item/firework_star/weather_blizzard
	name = "weather - HEAVY SNOW"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a blizzard."
	id = "fireworkblizzard"
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000, MAT_LEAD = 3000)
	build_path = /obj/item/weapon/firework_star/weather/blizzard
	sort_string = "IFABG"

/datum/design/item/firework_star/weather_hail
	name = "weather - HAIL"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a hailstorm. DANGEROUS."
	id = "fireworkhail"
	req_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 5, TECH_ILLEGAL = 2)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_SILVER = 3000, MAT_LEAD = 3000, MAT_PLASTEEL = 4000)
	build_path = /obj/item/weapon/firework_star/weather/hail
	sort_string = "IFABH"

/datum/design/item/firework_star/weather_fallout
	name = "weather - NUCLEAR"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one creates a heavy cloud of nuclear fallout. DANGEROUS."
	id = "fireworkfallout"
	req_tech = list(TECH_MATERIAL = 8, TECH_ENGINEERING = 6, TECH_ILLEGAL = 7)
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 2000, MAT_URANIUM = 12000)
	build_path = /obj/item/weapon/firework_star/weather/fallout
	sort_string = "IFABI"

/datum/design/item/firework_star/weather_confetti
	name = "weather - CONFETTI"
	desc = "A firework star, designed for use with launcher. Modifies current planetary weather effects. This one clears the sky and rains colorful confetti from it."
	id = "fireworkconfetti"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_PLASTIC = 10000, MAT_GLASS = 10000)
	build_path = /obj/item/weapon/firework_star/weather/confetti
	sort_string = "IFABJ"