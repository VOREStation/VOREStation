/* Diffrent misc types of tiles
 * Contains:
 *		Prototype
 *		Grass
 *		Wood
 *		Carpet
 * 		Blue Carpet
 *		Linoleum
 *
 * Put your stuff in fifty_stacks_tiles.dm as well.
 */

/obj/item/stack/tile
	name = "tile"
	singular_name = "tile"
	desc = "A non-descript floor tile"
	randpixel = 7
	w_class = ITEMSIZE_NORMAL
	max_amount = 60
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

//crafting / welding vars
	var/datum/material/material //*sigh* i guess this is how we're doing this.
	var/craftable = FALSE //set to TRUE for tiles you can craft stuff from directly, like grass
	var/can_weld = FALSE //set to TRUE for tiles you can reforge into their components via welding, like metal
	var/welds_into = /obj/item/stack/material/steel //what you get from the welding. defaults to steel.
	var/default_type = DEFAULT_WALL_MATERIAL



/obj/item/stack/tile/Initialize()
	. = ..()
	randpixel_xy()
	if(craftable)
		material = get_material_by_name("[default_type]")
		if(!material)
			return INITIALIZE_HINT_QDEL
		if(material) //sanity check
			recipes = material.get_recipes()
			stacktype = material.stack_type

/obj/item/stack/tile/attackby(obj/item/W as obj, mob/user as mob)
	if (W.has_tool_quality(TOOL_WELDER))
		var/obj/item/weapon/weldingtool/WT = W.get_welder()

		if(can_weld == FALSE)
			to_chat("You can't reform these into their original components.")
			return

		if(get_amount() < 4)
			to_chat(user, "<span class='warning'>You need at least four tiles to do this.</span>")
			return

		if(WT.remove_fuel(0,user))
			new welds_into(usr.loc)
			usr.update_icon()
			visible_message("<span class='notice'>\The [src] is shaped by [user.name] with the welding tool.</span>","You hear welding.")
			var/obj/item/stack/tile/T = src
			src = null
			var/replace = (user.get_inactive_hand()==T)
			T.use(4)
			if (!T && replace)
				user.put_in_hands(welds_into)
		return TRUE
	return ..()

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	default_type = "grass"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	origin_tech = list(TECH_BIO = 1)
	no_variants = FALSE
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'
	craftable = TRUE

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile-wood"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	no_variants = FALSE
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/stack/tile/wood/sif
	name = "alien wood tile"
	singular_name = "alien wood tile"
	desc = "An easy to fit wooden floor tile. It's blue!"
	icon_state = "tile-sifwood"

/obj/item/stack/tile/wood/alt
	name = "wood floor tile"
	singular_name = "wood floor tile"
	icon_state = "tile-wood_tile"

/obj/item/stack/tile/wood/parquet
	name = "parquet wood floor tile"
	singular_name = "parquet wood floor tile"
	icon_state = "tile-wood_parquet"

/obj/item/stack/tile/wood/panel
	name = "large wood floor tile"
	singular_name = "large wood floor tile"
	icon_state = "tile-wood_large"

/obj/item/stack/tile/wood/tile
	name = "tiled wood floor tile"
	singular_name = "tiled wood floor tile"
	icon_state = "tile-wood_tile"

/obj/item/stack/tile/wood/cyborg
	name = "wood floor tile synthesizer"
	desc = "A device that makes wood floor tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/wood
	build_type = /obj/item/stack/tile/wood



/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-carpet"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	no_variants = FALSE
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/stack/tile/carpet/teal
	desc = "A piece of teal carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-tealcarpet"

/obj/item/stack/tile/carpet/turcarpet
	desc = "A piece of turqoise carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-turcarpet"

/obj/item/stack/tile/carpet/bcarpet
	desc = "A piece of black diamond-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-bcarpet"

/obj/item/stack/tile/carpet/blucarpet
	desc = "A piece of blue diamond-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-blucarpet"

/obj/item/stack/tile/carpet/sblucarpet
	desc = "A piece of silver-blue diamond-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-sblucarpet"

/obj/item/stack/tile/carpet/gaycarpet
	desc = "A piece of pink diamond-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-gaycarpet"

/obj/item/stack/tile/carpet/purcarpet
	desc = "A piece of purple diamond-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-purcarpet"

/obj/item/stack/tile/carpet/oracarpet
	desc = "A piece of orange diamond-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-oracarpet"

/obj/item/stack/tile/carpet/brncarpet
	desc = "A piece of brown ornate-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-brncarpet"

/obj/item/stack/tile/carpet/blucarpet2
	desc = "A piece of blue ornate-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-blucarpet2"

/obj/item/stack/tile/carpet/greencarpet
	desc = "A piece of green ornate-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-greencarpet"

/obj/item/stack/tile/carpet/purplecarpet
	desc = "A piece of purple ornate-pattern carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-purplecarpet"

/obj/item/stack/tile/carpet/geo
	icon_state = "tile-carpet-deco"
	desc = "A piece of carpet with a gnarly geometric design. It is the same size as a normal floor tile!"

/obj/item/stack/tile/carpet/retro
	icon_state = "tile-carpet-retro"
	desc = "A piece of carpet with totally wicked blue space patterns. It is the same size as a normal floor tile!"

/obj/item/stack/tile/carpet/retro_red
	icon_state = "tile-carpet-retro-red"
	desc = "A piece of carpet with red-ical space patterns. It is the same size as a normal floor tile!"

/obj/item/stack/tile/carpet/happy
	icon_state = "tile-carpet-happy"
	desc = "A piece of carpet with happy patterns. It is the same size as a normal floor tile!"

/obj/item/stack/tile/floor
	name = "floor tile"
	singular_name = "floor tile"
	desc = "A metal tile fit for covering a section of floor."
	icon_state = "tile"
	force = 6.0
	matter = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT / 4)
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	no_variants = FALSE
	can_weld = TRUE

/obj/item/stack/tile/floor/red
	name = "red floor tile"
	singular_name = "red floor tile"
	color = COLOR_RED_GRAY
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/techgrey
	name = "grey techfloor tile"
	singular_name = "grey techfloor tile"
	icon_state = "techtile_grey"
	no_variants = FALSE

/obj/item/stack/tile/floor/techgrid
	name = "grid techfloor tile"
	singular_name = "grid techfloor tile"
	icon_state = "techtile_grid"
	no_variants = FALSE

/obj/item/stack/tile/floor/techmaint
	name = "maint techfloor tile"
	singular_name = "maint techfloor tile"
	icon_state = "techtile_maint"
	no_variants = FALSE

/obj/item/stack/tile/floor/steel_dirty
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/plasteel
	no_variants = FALSE

/obj/item/stack/tile/floor/steel
	name = "steel floor tile"
	singular_name = "steel floor tile"
	icon_state = "tile_steel"
	matter = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/plasteel
	no_variants = FALSE

/obj/item/stack/tile/floor/white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	matter = list(MAT_PLASTIC = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/plastic
	no_variants = FALSE

/obj/item/stack/tile/floor/yellow
	name = "yellow floor tile"
	singular_name = "yellow floor tile"
	color = COLOR_BROWN
	icon_state = "tile_white"
	no_variants = FALSE

/obj/item/stack/tile/floor/dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "tile_steel"
	matter = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/plasteel
	no_variants = FALSE

/obj/item/stack/tile/floor/freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	matter = list(MAT_PLASTIC = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/plastic
	no_variants = FALSE

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor
	can_weld = FALSE //we're not going there

/obj/item/stack/tile/linoleum
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile-linoleum"
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	no_variants = FALSE
	can_weld = FALSE

/obj/item/stack/tile/wmarble
	name = "light marble tile"
	singular_name = "light marble tile"
	desc = "Some white marble tiles used for flooring."
	icon_state = "tile-wmarble"
	force = 6.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	no_variants = FALSE
	can_weld = TRUE
	welds_into = /obj/item/stack/material/marble

/obj/item/stack/tile/bmarble
	name = "dark marble tile"
	singular_name = "dark marble tile"
	desc = "Some black marble tiles used for flooring."
	icon_state = "tile-bmarble"
	force = 6.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	flags = 0
	no_variants = FALSE
	can_weld = TRUE
	welds_into = /obj/item/stack/material/marble

/obj/item/stack/tile/roofing
	name = "roofing"
	singular_name = "roofing"
	desc = "A section of roofing material. You can use it to repair the ceiling, or expand it."
	icon_state = "techtile_grid"
	can_weld = FALSE //roofing can also be made from wood, so let's not open that can of worms today

/obj/item/stack/tile/roofing/cyborg
	name = "roofing synthesizer"
	desc = "A device that makes roofing tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/roofing
	build_type = /obj/item/stack/tile/roofing
	can_weld = FALSE
