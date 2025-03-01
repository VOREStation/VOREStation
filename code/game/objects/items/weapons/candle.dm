/obj/item/flame/candle
	name = "red candle"
	desc = "a red pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	w_class = ITEMSIZE_TINY
	light_color = "#E09D37"
	var/wax = 2000
	var/icon_type = "candle"

/obj/item/flame/candle/Initialize(mapload)
	. = ..()
	wax -= rand(800, 1000) // Enough for 27-33 minutes. 30 minutes on average.

/obj/item/flame/candle/update_icon()
	var/i
	if(wax > 1500)
		i = 1
	else if(wax > 800)
		i = 2
	else i = 3
	icon_state = "[icon_type][i][lit ? "_lit" : ""]"


/obj/item/flame/candle/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(W.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/WT = W.get_welder()
		if(WT.isOn()) //Badasses dont get blinded by lighting their candle with a welding tool
			light(span_notice("\The [user] casually lights the [src] with [W]."))
	else if(istype(W, /obj/item/flame/lighter))
		var/obj/item/flame/lighter/L = W
		if(L.lit)
			light()
	else if(istype(W, /obj/item/flame/match))
		var/obj/item/flame/match/M = W
		if(M.lit)
			light()
	else if(istype(W, /obj/item/flame/candle))
		var/obj/item/flame/candle/C = W
		if(C.lit)
			light()


/obj/item/flame/candle/proc/light(var/flavor_text = span_notice("\The [usr] lights the [src]."))
	if(!lit)
		lit = TRUE
		visible_message(flavor_text)
		set_light(CANDLE_LUM)
		START_PROCESSING(SSobj, src)

/obj/item/flame/candle/process()
	if(!lit)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		if(istype(src.loc, /mob))
			src.dropped(src.loc)
		qdel(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)

/obj/item/flame/candle/small
	name = "small red candle"
	desc = "a small red candle, for more intimate candle occasions."
	icon = 'icons/obj/candle.dmi'
	icon_state = "smallcandle"
	icon_type = "smallcandle"
	w_class = ITEMSIZE_SMALL

/obj/item/flame/candle/white
	name = "white candle"
	desc = "a white pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "whitecandle"
	icon_type = "whitecandle"
	w_class = ITEMSIZE_SMALL

/obj/item/flame/candle/black
	name = "black candle"
	desc = "a black pillar candle. Ominous."
	icon = 'icons/obj/candle.dmi'
	icon_state = "blackcandle"
	icon_type = "blackcandle"
	w_class = ITEMSIZE_SMALL

/obj/item/flame/candle/candelabra
	name = "candelabra"
	desc = "a small gold candelabra. The cups that hold the candles save some of the wax from dripping off, allowing the candles to burn longer."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candelabra"
	w_class = ITEMSIZE_SMALL
	wax = 20000

/obj/item/flame/candle/candelabra/update_icon()
	if(wax == 0)
		icon_state = "candelabra_melted"
	else
		icon_state = "candelabra[lit ? "_lit" : ""]"

/obj/item/flame/candle/everburn
	wax = 99999

/obj/item/flame/candle/everburn/Initialize()
	. = ..()
	light(span_notice("\The [src] mysteriously lights itself!."))

/obj/item/flame/candle/candelabra/everburn
	wax = 99999

/obj/item/flame/candle/candelabra/everburn/Initialize()
	. = ..()
	light(span_notice("\The [src] mysteriously lights itself!."))
