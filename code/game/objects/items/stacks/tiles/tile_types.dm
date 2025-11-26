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



/obj/item/stack/tile/Initialize(mapload)
	. = ..()
	randpixel_xy()
	if(craftable)
		material = get_material_by_name("[default_type]")
		if(!material)
			stack_trace("Material of type: [default_type] does not exist.")
			return INITIALIZE_HINT_QDEL
		if(material) //sanity check
			recipes = material.get_recipes()
			stacktype = material.stack_type

/obj/item/stack/tile/attackby(obj/item/W as obj, mob/user as mob)
	if (W.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/WT = W.get_welder()

		if(can_weld == FALSE)
			to_chat(user, "You can't reform these into their original components.")
			return

		if(get_amount() < 4)
			to_chat(user, span_warning("You need at least four tiles to do this."))
			return

		if(WT.remove_fuel(0,user))
			new welds_into(user.loc)
			user.update_icon()
			visible_message(span_notice("\The [src] is shaped by [user.name] with the welding tool."),"You hear welding.")
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
	default_type = MAT_GRASS
	force = 1.0
	throwforce = 1.0
	throw_speed = 5
	throw_range = 20
	flags = NONE
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
	flags = NONE
	no_variants = FALSE
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/stack/tile/wood/alt
	name = "wood floor tile"
	singular_name = "wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs"
	color = "#593c1c"

/obj/item/stack/tile/wood/parquet
	name = "parquet wood floor tile"
	singular_name = "parquet wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs_parquet"
	color = "#593c1c"

/obj/item/stack/tile/wood/panel
	name = "large wood floor tile"
	singular_name = "large wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs_large"
	color = "#593c1c"

/obj/item/stack/tile/wood/tile
	name = "tiled wood floor tile"
	singular_name = "tiled wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs_tile"
	color = "#593c1c"

/obj/item/stack/tile/wood/vert
	name = "vertical wood floor tile"
	singular_name = "vertical wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-vert-gs"
	color = "#593c1c"

/obj/item/stack/tile/wood/vert_panel
	name = "large vertical wood floor tile"
	singular_name = "large vertical wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-vert-gs_large"
	color = "#593c1c"

/obj/item/stack/tile/wood/sif
	name = "alien wood tile"
	singular_name = "alien wood tile"
	desc = "An easy to fit wooden floor tile. It's blue!"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs"
	color = "#293c50"

/obj/item/stack/tile/wood/sif/parquet
	name = "alien wood parquet tile"
	singular_name = "alien wood parquet tile"
	icon_state = "tile-wood-gs_parquet"

/obj/item/stack/tile/wood/sif/panel
	name = "large alien wood tile"
	singular_name = "large alien wood tile"
	icon_state = "tile-wood-gs_large"

/obj/item/stack/tile/wood/sif/tile
	name = "tiled alien wood tile"
	singular_name = "tiled alien wood tile"
	icon_state = "tile-wood-gs_tile"

/obj/item/stack/tile/wood/sif/vert
	name = "vertical alien wood floor tile"
	singular_name = "vertical alien wood floor tile"
	icon_state = "tile-wood-vert-gs"

/obj/item/stack/tile/wood/sif/vert_panel
	name = "large vertical alien wood floor tile"
	singular_name = "large vertical alien wood floor tile"
	icon_state = "tile-wood-vert-gs_large"

/obj/item/stack/tile/wood/acacia
	name = "acacia wood floor tile"
	singular_name = "wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs"
	color = "#b75e12"

/obj/item/stack/tile/wood/acacia/parquet
	name = "acacia parquet floor tile"
	singular_name = "parquet wood floor tile"
	icon_state = "tile-wood-gs_parquet"

/obj/item/stack/tile/wood/acacia/panel
	name = "large acacia floor tile"
	singular_name = "large wood floor tile"
	icon_state = "tile-wood-gs_large"

/obj/item/stack/tile/wood/acacia/tile
	name = "tiled acacia floor tile"
	singular_name = "tiled wood floor tile"
	icon_state = "tile-wood-gs_tile"

/obj/item/stack/tile/wood/acacia/vert
	name = "vertical acacia wood floor tile"
	singular_name = "vertical acacia wood floor tile"
	icon_state = "tile-wood-vert-gs"

/obj/item/stack/tile/wood/acacia/vert_panel
	name = "large vertical acacia wood floor tile"
	singular_name = "large vertical acacia wood floor tile"
	icon_state = "tile-wood-vert-gs_large"

/obj/item/stack/tile/wood/birch
	name = "birch wood floor tile"
	singular_name = "wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs"
	color = "#f6dec0"

/obj/item/stack/tile/wood/birch/parquet
	name = "birch parquet floor tile"
	singular_name = "parquet wood floor tile"
	icon_state = "tile-wood-gs_parquet"

/obj/item/stack/tile/wood/birch/panel
	name = "large birch floor tile"
	singular_name = "large wood floor tile"
	icon_state = "tile-wood-gs_large"

/obj/item/stack/tile/wood/birch/tile
	name = "tiled birch floor tile"
	singular_name = "tiled wood floor tile"
	icon_state = "tile-wood-gs_tile"

/obj/item/stack/tile/wood/birch/vert
	name = "vertical birch wood floor tile"
	singular_name = "vertical birch wood floor tile"
	icon_state = "tile-wood-vert-gs"

/obj/item/stack/tile/wood/birch/vert_panel
	name = "large vertical birch wood floor tile"
	singular_name = "large vertical birch wood floor tile"
	icon_state = "tile-wood-vert-gs_large"

/obj/item/stack/tile/wood/hardwood
	name = "hardwood wood floor tile"
	singular_name = "wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs"
	color = "#42291a"

/obj/item/stack/tile/wood/hardwood/parquet
	name = "hardwood parquet floor tile"
	singular_name = "parquet wood floor tile"
	icon_state = "tile-wood-gs_parquet"

/obj/item/stack/tile/wood/hardwood/panel
	name = "large hardwood floor tile"
	singular_name = "large wood floor tile"
	icon_state = "tile-wood-gs_large"

/obj/item/stack/tile/wood/hardwood/tile
	name = "tiled hardwood floor tile"
	singular_name = "tiled wood floor tile"
	icon_state = "tile-wood-gs_tile"

/obj/item/stack/tile/wood/hardwood/vert
	name = "vertical hardwood wood floor tile"
	singular_name = "vertical hardwood wood floor tile"
	icon_state = "tile-wood-vert-gs"

/obj/item/stack/tile/wood/hardwood/vert_panel
	name = "large vertical hardwood wood floor tile"
	singular_name = "large vertical hardwood wood floor tile"
	icon_state = "tile-wood-vert-gs_large"

/obj/item/stack/tile/wood/pine
	name = "pine wood floor tile"
	singular_name = "wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs"
	color = "#cd9d6f"

/obj/item/stack/tile/wood/pine/parquet
	name = "pine parquet floor tile"
	singular_name = "parquet wood floor tile"
	icon_state = "tile-wood-gs_parquet"

/obj/item/stack/tile/wood/pine/panel
	name = "large pine floor tile"
	singular_name = "large wood floor tile"
	icon_state = "tile-wood-gs_large"

/obj/item/stack/tile/wood/pine/tile
	name = "tiled pine floor tile"
	singular_name = "tiled wood floor tile"
	icon_state = "tile-wood-gs_tile"

/obj/item/stack/tile/wood/pine/vert
	name = "vertical pine wood floor tile"
	singular_name = "vertical pine wood floor tile"
	icon_state = "tile-wood-vert-gs"

/obj/item/stack/tile/wood/pine/vert_panel
	name = "large vertical pine wood floor tile"
	singular_name = "large vertical pine wood floor tile"
	icon_state = "tile-wood-vert-gs_large"

/obj/item/stack/tile/wood/oak
	name = "oak wood floor tile"
	singular_name = "wood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs"
	color = "#674928"

/obj/item/stack/tile/wood/oak/parquet
	name = "oak parquet floor tile"
	singular_name = "parquet wood floor tile"
	icon_state = "tile-wood-gs_parquet"

/obj/item/stack/tile/wood/oak/panel
	name = "large oak floor tile"
	singular_name = "large wood floor tile"
	icon_state = "tile-wood-gs_large"

/obj/item/stack/tile/wood/oak/tile
	name = "tiled oak floor tile"
	singular_name = "tiled wood floor tile"
	icon_state = "tile-wood-gs_tile"

/obj/item/stack/tile/wood/oak/vert
	name = "vertical oak wood floor tile"
	singular_name = "vertical oak wood floor tile"
	icon_state = "tile-wood-vert-gs"

/obj/item/stack/tile/wood/oak/vert_panel
	name = "large vertical oak wood floor tile"
	singular_name = "large vertical oak wood floor tile"
	icon_state = "tile-wood-vert-gs_large"

/obj/item/stack/tile/wood/redwood
	name = "redwood floor tile"
	singular_name = "redwood floor tile"
	icon = 'icons/obj/stacks_vr.dmi'
	icon_state = "tile-wood-gs"
	color = "#a45a52"

/obj/item/stack/tile/wood/redwood/parquet
	name = "redwood parquet floor tile"
	singular_name = "parquet redwood floor tile"
	icon_state = "tile-wood-gs_parquet"

/obj/item/stack/tile/wood/redwood/panel
	name = "large redwood floor tile"
	singular_name = "large redwood floor tile"
	icon_state = "tile-wood-gs_large"

/obj/item/stack/tile/wood/redwood/tile
	name = "tiled redwood floor tile"
	singular_name = "tiled redwood floor tile"
	icon_state = "tile-wood-gs_tile"

/obj/item/stack/tile/wood/redwood/vert
	name = "vertical redwood wood floor tile"
	singular_name = "vertical redwood wood floor tile"
	icon_state = "tile-wood-vert-gs"

/obj/item/stack/tile/wood/redwood/vert_panel
	name = "large vertical redwood wood floor tile"
	singular_name = "large vertical redwood wood floor tile"
	icon_state = "tile-wood-vert-gs_large"

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
	flags = NONE
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

/obj/item/stack/tile/floor/steelgrip
	name = "steel hi-grip tile"
	singular_name = "steel hi-grip tile"
	icon_state = "steeltile_grip"
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

/obj/item/stack/tile/floor/purple
	name = "purple floor tile"
	singular_name = "purple floor tile"
	color = COLOR_PURPLE_GRAY
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
	flags = NONE
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
	flags = NONE
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
	flags = NONE
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

/obj/item/stack/tile/floor/gold
	name = "gold floor tile"
	singular_name = "gold floor tile"
	icon_state = "tile-gold"
	matter = list(MAT_GOLD = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/gold
	no_variants = FALSE

/obj/item/stack/tile/floor/silver
	name = "silver floor tile"
	singular_name = "silver floor tile"
	icon_state = "tile-silver"
	matter = list(MAT_SILVER = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/silver
	no_variants = FALSE

/obj/item/stack/tile/floor/phoron
	name = "phoron floor tile"
	singular_name = "phoron floor tile"
	icon_state = "tile-phoron"
	matter = list(MAT_PHORON = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/phoron
	no_variants = FALSE

/obj/item/stack/tile/floor/diamond
	name = "diamond floor tile"
	singular_name = "diamond floor tile"
	icon_state = "tile-diamond"
	matter = list(MAT_DIAMOND = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/diamond
	no_variants = FALSE

/obj/item/stack/tile/floor/uranium
	name = "uranium floor tile"
	singular_name = "uranium floor tile"
	icon_state = "tile-uranium"
	matter = list(MAT_URANIUM = SHEET_MATERIAL_AMOUNT / 4)
	welds_into = /obj/item/stack/material/uranium
	no_variants = FALSE
