/obj/item/weapon/flame/candle
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

/obj/item/weapon/flame/candle/New()
	wax -= rand(800, 1000) // Enough for 27-33 minutes. 30 minutes on average.
	..()

/obj/item/weapon/flame/candle/update_icon()
	var/i
	if(wax > 1500)
		i = 1
	else if(wax > 800)
		i = 2
	else i = 3
	icon_state = "[icon_type][i][lit ? "_lit" : ""]"


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
		set_light(CANDLE_LUM)
		START_PROCESSING(SSobj, src)

/obj/item/weapon/flame/candle/process()
	if(!lit)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		if(istype(src.loc, /mob))
			src.dropped()
		qdel(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/weapon/flame/candle/attack_self(mob/user as mob)
	if(lit)
		lit = 0
		update_icon()
		set_light(0)

/obj/item/weapon/flame/candle/small
	name = "small red candle"
	desc = "a small red candle, for more intimate candle occasions."
	icon = 'icons/obj/candle.dmi'
	icon_state = "smallcandle"
	icon_type = "smallcandle"
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/flame/candle/white
	name = "white candle"
	desc = "a white pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "whitecandle"
	icon_type = "whitecandle"
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/flame/candle/black
	name = "black candle"
	desc = "a black pillar candle. Ominous."
	icon = 'icons/obj/candle.dmi'
	icon_state = "blackcandle"
	icon_type = "blackcandle"
	w_class = ITEMSIZE_SMALL

/obj/item/weapon/flame/candle/candelabra
	name = "candelabra"
	desc = "a small gold candelabra. The cups that hold the candles save some of the wax from dripping off, allowing the candles to burn longer."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candelabra"
	w_class = ITEMSIZE_SMALL
	wax = 20000

/obj/item/weapon/flame/candle/candelabra/update_icon()
	if(wax == 0)
		icon_state = "candelabra_melted"
	else
		icon_state = "candelabra[lit ? "_lit" : ""]"

/obj/item/weapon/flame/candle/everburn
	wax = 99999

/obj/item/weapon/flame/candle/everburn/Initialize()
	. = ..()
	light("<span class='notice'>\The [src] mysteriously lights itself!.</span>")

/obj/item/weapon/flame/candle/candelabra/everburn
	wax = 99999

/obj/item/weapon/flame/candle/candelabra/everburn/Initialize()
	. = ..()
	light("<span class='notice'>\The [src] mysteriously lights itself!.</span>")
