#define T_FIREWORK_WEATHER_STAR(name)	"weather firework star (" + (name) + ")"

/obj/item/weapon/firework_star
	icon = 'icons/obj/firework_stars.dmi'
	name = "firework star"
	desc = "A very tightly compacted ball of chemicals for use with firework launcher."
	icon_state = "star"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)

/obj/item/weapon/firework_star/proc/trigger_firework(var/datum/weather_holder/w_holder)
	return


/obj/item/weapon/firework_star/weather
	name = "weather firework star"
	desc = "A firework star designed to alter a weather, rather than put on a show."
	var/weather_type
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 2)

/obj/item/weapon/firework_star/weather/trigger_firework(var/datum/weather_holder/w_holder)
	if(!w_holder)						// Sanity
		return
	if(w_holder.firework_override)		// Make sure weather-based events can't be interfered with
		return
	if(weather_type && (weather_type in w_holder.allowed_weather_types))
		w_holder.message_all_outdoor_players("Something seems to flash in the sky, as weather suddenly shifts!")
		w_holder.change_weather(weather_type)
		w_holder.rebuild_forecast()

/obj/item/weapon/firework_star/weather/clear
	name = T_FIREWORK_WEATHER_STAR("CLEAR SKY")
	weather_type = WEATHER_CLEAR
	icon_state = "clear"

/obj/item/weapon/firework_star/weather/overcast
	name = T_FIREWORK_WEATHER_STAR("CLOUDY")
	weather_type = WEATHER_OVERCAST
	icon_state = "cloudy"

/obj/item/weapon/firework_star/weather/rain
	name = T_FIREWORK_WEATHER_STAR("RAIN")
	weather_type = WEATHER_RAIN
	icon_state = "rain"

/obj/item/weapon/firework_star/weather/storm
	name = T_FIREWORK_WEATHER_STAR("STORM")
	weather_type = WEATHER_STORM
	icon_state = "rain"

/obj/item/weapon/firework_star/weather/light_snow
	name = T_FIREWORK_WEATHER_STAR("SNOW - LIGHT")
	weather_type = WEATHER_LIGHT_SNOW
	icon_state = "snow"

/obj/item/weapon/firework_star/weather/snow
	name = T_FIREWORK_WEATHER_STAR("SNOW - MEDIUM")
	weather_type = WEATHER_SNOW
	icon_state = "snow"

/obj/item/weapon/firework_star/weather/blizzard
	name = T_FIREWORK_WEATHER_STAR("SNOW - HEAVY")
	weather_type = WEATHER_BLIZZARD
	icon_state = "snow"

/obj/item/weapon/firework_star/weather/hail
	name = T_FIREWORK_WEATHER_STAR("HAIL")
	weather_type = WEATHER_HAIL
	icon_state = "snow"
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 2, TECH_ILLEGAL = 1)

/obj/item/weapon/firework_star/weather/fallout
	name = T_FIREWORK_WEATHER_STAR("NUCLEAR")
	desc = "This is the worst idea ever."
	weather_type = WEATHER_FALLOUT_TEMP
	icon_state = "nuclear"
	origin_tech = list(TECH_MATERIAL = 7, TECH_ENGINEERING = 3, TECH_ILLEGAL = 5)

/obj/item/weapon/firework_star/weather/confetti
	name = T_FIREWORK_WEATHER_STAR("CONFETTI")
	desc = "A firework star designed to alter a weather, rather than put on a show. This one makes colorful confetti rain from the sky."
	weather_type = WEATHER_CONFETTI
	icon_state = "confetti"


/obj/item/weapon/firework_star/aesthetic
	name = "aesthetic firework star"
	desc = "A firework star designed to paint the sky with pretty lights."
	var/list/firework_adjectives = list("beautiful", "pretty", "fancy", "colorful", "bright", "shimmering")
	var/list/firework_colors = list("red", "orange", "yellow", "green", "cyan", "blue", "purple", "pink", "beige", "white")

/obj/item/weapon/firework_star/aesthetic/trigger_firework(var/datum/weather_holder/w_holder)
	if(!w_holder)
		return
	w_holder.message_all_outdoor_players(get_firework_message())

/obj/item/weapon/firework_star/aesthetic/proc/get_firework_message()
	return "You see a [pick(firework_adjectives)] explosion of [pick(firework_colors)] sparks in the sky!"

/obj/item/weapon/firework_star/aesthetic/configurable
	name = "configurable aesthetic firework star"
	desc = "A firework star designed to paint the sky with pretty lights. This one's advanced and can be configured to specific shapes or colors."
	icon_state = "config"
	var/current_color = "white"
	var/current_shape = "Random"
	var/list/firework_shapes = list("none", "Random",
								"a circle", "an oval", "a triangle", "a square", "a pentagon", "a hexagon", "an octagon", "a plus sign", "an x", "a star", "a spiral", "a heart", "a teardrop",
								"a smiling face", "a winking face", "a mouse", "a cat", "a dog", "a fox", "a bird", "a fish", "a lizard", "a bug", "a butterfly", "a robot", "a dragon", "a teppi", "a catslug",
								"a tree", "a leaf", "a flower", "a lightning bolt", "a cloud", "a sun", "a gemstone", "a flame", "a wrench", "a beaker", "a syringe", "a pickaxe", "a pair of handcuffs", "a crown",
								"a bottle", "a boat", "a spaceship",
								"Nanotrasen logo", "a geometric-looking letter S", "a dodecahedron")

/obj/item/weapon/firework_star/aesthetic/configurable/attack_self(var/mob/user)
	var/choice = tgui_alert(usr, "What setting do you want to adjust?", "Firework Star", list("Color", "Shape", "Nothing"))
	if(src.loc != user)
		return

	if(choice == "Color")
		var/color_choice = tgui_input_list(user, "What color would you like firework to be?", "Firework Star", firework_colors)
		if(src.loc != user)
			return
		if(color_choice)
			current_color = color_choice

	if(choice == "Shape")
		var/shape_choice = tgui_input_list(user, "What shape would you like firework to be?", "Firework Star", firework_shapes)
		if(src.loc != user)
			return
		if(shape_choice)
			current_shape = shape_choice

/obj/item/weapon/firework_star/aesthetic/configurable/get_firework_message()
	var/temp_shape = current_shape
	if(temp_shape == "Random")
		var/list/shapes_copy = firework_shapes.Copy()
		shapes_copy -= "Random"
		temp_shape = pick(shapes_copy)

	if(temp_shape == "none" || !temp_shape)
		return "You see a [pick(firework_adjectives)] explosion of [current_color] sparks in the sky!"
	else
		return "You see a [pick(firework_adjectives)] explosion of [current_color] sparks in the sky, forming into shape of [current_shape]!"