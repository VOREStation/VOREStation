/obj/item/weapon/flame/candle
	name = "candle"
	desc = "A small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	w_class = ITEMSIZE_TINY
	light_color = "#E09D37"

	var/available_colours = list(COLOR_WHITE, COLOR_DARK_GRAY, COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_GREEN, COLOR_BLUE, COLOR_INDIGO, COLOR_VIOLET)
	var/wax
	var/last_lit
	var/icon_set = "candle"
	var/candle_max_bright = 0.3
	var/candle_inner_range = 0.1
	var/candle_outer_range = 4
	var/candle_falloff = 2

/obj/item/weapon/flame/candle/Initialize()
	wax -= rand(800, 1000) // Enough for 27-33 minutes. 30 minutes on average
	if(available_colours)
		color = pick(available_colours)
	. = ..()

/obj/item/weapon/flame/candle/update_icon()
	switch(wax)
		if(1500 to INFINITY)
			icon_state = "[icon_set]1"
		if(800 to 1500)
			icon_state = "[icon_set]2"
		else
			icon_state = "[icon_set]3"

	if(lit != last_lit)
		last_lit = lit
		overlays.Cut()
		if(lit)
			overlays += image(icon, "[icon_state]_lit", flags=RESET_COLOR)

/obj/item/weapon/flame/candle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light("<span class='notice'>\The [user] casually lights the [src] with [W].</span>")
	else if(istype(W, /obj/item/weapon/flame/lighter))
		var/obj/item/weapon/flame/lighter/L = W
		if(L.lit)
			light()
	else if(istype(W, /obj/item/weapon/flame/match))
		var/obj/item/weapon/flame/match/M = W
		if(M.lit)
			light()
	else if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/C = W
		if(C.lit)
			light()

/obj/item/weapon/flame/candle/proc/light(var/flavor_text = "<span class='notice'>\The [usr] lights the [src].</span>")
	if(!lit)
		lit = TRUE
		visible_message(flavor_text)
		set_light(candle_max_bright, candle_inner_range, candle_outer_range, candle_falloff)
		START_PROCESSING(SSobj, src)

/obj/item/weapon/flame/candle/process()
	if(!lit)
		return
	wax--
	if(!wax)
		var/obj/item/trash/candle/C = new(loc)
		C.color = color
		qdel(src)
		return
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/weapon/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)
		remove_extension(src, /datum/scent)