/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	description_info = "The input can be opened by Alt-clicking it, allowing you to pour reagents inside."
	icon = 'icons/obj/chemical_tanks.dmi'
	icon_state = "tank"
	layer = TABLE_LAYER
	density = TRUE
	anchored = FALSE
	pressure_resistance = 2*ONE_ATMOSPHERE

	var/has_sockets = TRUE

	var/obj/item/hose_connector/input/active/InputSocket
	var/obj/item/hose_connector/output/active/OutputSocket

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

	var/open_top = FALSE

/obj/structure/reagent_dispensers/attackby(obj/item/W as obj, mob/user as mob)
	return

/obj/structure/reagent_dispensers/Destroy()
	QDEL_NULL(InputSocket)
	QDEL_NULL(OutputSocket)

	. = ..()

/obj/structure/reagent_dispensers/Initialize(mapload)
	var/datum/reagents/R = new/datum/reagents(5000)
	reagents = R
	R.my_atom = src
	if (!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT

	if(has_sockets)
		InputSocket = new(src)
		InputSocket.carrier = src
		OutputSocket = new(src)
		OutputSocket.carrier = src

	. = ..()

/obj/structure/reagent_dispensers/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		. += span_notice("It contains:")
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				. += span_notice("[R.volume] units of [R.name]")
		else
			. += span_notice("Nothing.")

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = tgui_input_list(usr, "Amount per transfer from this:","[src]", possible_transfer_amounts)
	if (N)
		amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				new /obj/effect/effect/water(src.loc)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				new /obj/effect/effect/water(src.loc)
				qdel(src)
				return
	return

/obj/structure/reagent_dispensers/blob_act()
	qdel(src)

/obj/structure/reagent_dispensers/AltClick(mob/user)
	if(!Adjacent(user))
		return

	if(flags & OPENCONTAINER)
		to_chat(user, span_notice("You close the input on \the [src]"))
		flags -= OPENCONTAINER
		open_top = FALSE
	else
		to_chat(user, span_notice("You open the input on \the [src], allowing you to pour reagents in."))
		flags |= OPENCONTAINER
		open_top = TRUE

/*
 * Tanks
 */

//Water
/obj/structure/reagent_dispensers/watertank
	name = "water tank"
	desc = "A water tank."
	icon_state = "water"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/watertank/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_WATER, 1000)

/obj/structure/reagent_dispensers/watertank/high
	name = "high-capacity water tank"
	desc = "A highly-pressurized water tank made to hold vast amounts of water.."
	icon_state = "water_high"

/obj/structure/reagent_dispensers/watertank/high/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_WATER, 4000)

/obj/structure/reagent_dispensers/watertank/barrel
	name = "water barrel"
	desc = "A barrel for holding water."
	icon_state = "waterbarrel"

//Fuel
/obj/structure/reagent_dispensers/fueltank
	name = "fuel tank"
	desc = "A fuel tank."
	icon_state = REAGENT_ID_FUEL
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/obj/item/assembly_holder/rig = null

/obj/structure/reagent_dispensers/fueltank/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_FUEL,1000)

/obj/structure/reagent_dispensers/fueltank/high
	name = "high-capacity fuel tank"
	desc = "A highly-pressurized fuel tank made to hold vast amounts of fuel."
	icon_state = "fuel_high"

/obj/structure/reagent_dispensers/fueltank/high/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_FUEL,4000)

//Foam
/obj/structure/reagent_dispensers/foam
	name = "foam tank"
	desc = "A foam tank."
	icon_state = "foam"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/foam/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_FIREFOAM,1000)

//Helium3
/obj/structure/reagent_dispensers/he3
	name = "/improper He3 tank"
	desc = "A Helium3 tank."
	icon_state = "he3"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispenser/he3/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_HELIUM3,1000)

/*
 * Misc
 */

/obj/structure/reagent_dispensers/fueltank/barrel
	name = "hazardous barrel"
	desc = "An open-topped barrel full of nasty-looking liquid."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "barrel"
	modded = TRUE

/obj/structure/reagent_dispensers/fueltank/barrel/two
	name = "explosive barrel"
	desc = "A barrel with warning labels painted all over it."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "barrel2"
	modded = FALSE

/obj/structure/reagent_dispensers/fueltank/barrel/three
	name = "fuel barrel"
	desc = "An open-topped barrel full of nasty-looking liquid."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "barrel3"
	modded = FALSE

/obj/structure/reagent_dispensers/fueltank/barrel/attackby(obj/item/W as obj, mob/user as mob)
	if (W.has_tool_quality(TOOL_WRENCH)) //can't wrench it shut, it's always open
		return
	return ..()
//VOREStation Add End

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		if(modded)
			. += span_warning("Fuel faucet is wrenched open, leaking the fuel!")
		if(rig)
			. += span_notice("There is some kind of device rigged to the tank.")

/obj/structure/reagent_dispensers/fueltank/attack_hand(mob/user)
	if (rig)
		user.visible_message("[user] begins to detach [rig] from \the [src].", "You begin to detach [rig] from \the [src]")
		if(do_after(user, 20))
			user.visible_message(span_notice("[user] detaches [rig] from \the [src]."), span_notice("You detach [rig] from \the [src]"))
			rig.loc = get_turf(user)
			rig = null
			overlays = new/list()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (W.has_tool_quality(TOOL_WRENCH))
		user.visible_message("[user] wrenches [src]'s faucet [modded ? "closed" : "open"].", \
			"You wrench [src]'s faucet [modded ? "closed" : "open"]")
		modded = modded ? 0 : 1
		playsound(src, W.usesound, 75, 1)
		if (modded)
			message_admins("[key_name_admin(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel. (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
			log_game("[key_name(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel.")
			leak_fuel(amount_per_transfer_from_this)
	if (istype(W,/obj/item/assembly_holder))
		if (rig)
			to_chat(user, span_warning("There is another device in the way."))
			return ..()
		user.visible_message("[user] begins rigging [W] to \the [src].", "You begin rigging [W] to \the [src]")
		if(do_after(user, 20))
			user.visible_message(span_notice("[user] rigs [W] to \the [src]."), span_notice("You rig [W] to \the [src]"))

			var/obj/item/assembly_holder/H = W
			if (istype(H.a_left,/obj/item/assembly/igniter) || istype(H.a_right,/obj/item/assembly/igniter))
				message_admins("[key_name_admin(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion. (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
				log_game("[key_name(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion.")

			rig = W
			user.drop_item()
			W.loc = src

			var/icon/test = getFlatIcon(W)
			test.Shift(NORTH,1)
			test.Shift(EAST,6)
			add_overlay(test)

	return ..()


/obj/structure/reagent_dispensers/fueltank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(istype(Proj.firer))
			message_admins("[key_name_admin(Proj.firer)] shot fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>).")
			log_game("[key_name(Proj.firer)] shot fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]).")

		if(!istype(Proj ,/obj/item/projectile/beam/lasertag) && !istype(Proj ,/obj/item/projectile/beam/practice) )
			explode()

/obj/structure/reagent_dispensers/fueltank/ex_act()
	explode()

/obj/structure/reagent_dispensers/fueltank/blob_act()
	explode()

/obj/structure/reagent_dispensers/fueltank/proc/explode()
	if (reagents.total_volume > 500)
		explosion(src.loc,1,2,4)
	else if (reagents.total_volume > 100)
		explosion(src.loc,0,1,3)
	else if (reagents.total_volume > 50)
		explosion(src.loc,-1,1,2)
	if(src)
		qdel(src)

/obj/structure/reagent_dispensers/fueltank/fire_act(datum/gas_mixture/air, temperature, volume)
	if (modded)
		explode()
	else if (temperature > T0C+500)
		explode()
	return ..()

/obj/structure/reagent_dispensers/fueltank/Move()
	if (..() && modded)
		leak_fuel(amount_per_transfer_from_this/10.0)

/obj/structure/reagent_dispensers/fueltank/proc/leak_fuel(amount)
	if (reagents.total_volume == 0)
		return

	amount = min(amount, reagents.total_volume)
	reagents.remove_reagent(REAGENT_ID_FUEL,amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount,1)

/obj/structure/reagent_dispensers/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refills pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = TRUE
	density = FALSE
	amount_per_transfer_from_this = 45

/obj/structure/reagent_dispensers/peppertank/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_CONDENSEDCAPSAICIN,1000)

/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food. Yum."
	icon = 'icons/obj/virology_vr.dmi'
	icon_state = "virusfoodtank"
	anchored = TRUE
	density = FALSE
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/virusfood/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_VIRUSFOOD, 1000)

/obj/structure/reagent_dispensers/acid
	name = "Sulphuric Acid Dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	anchored = TRUE
	density = FALSE
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/acid/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_SACID, 1000)

/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = TRUE
	has_sockets = FALSE
	var/bottle = 0
	var/cups = 0
	var/cupholder = 0

/obj/structure/reagent_dispensers/water_cooler/full
	bottle = 1
	cupholder = 1
	cups = 10

/obj/structure/reagent_dispensers/water_cooler/Initialize(mapload)
	. = ..()
	if(bottle)
		reagents.add_reagent(REAGENT_ID_WATER,2000)
	update_icon()

/obj/structure/reagent_dispensers/water_cooler/examine(mob/user)
	. = ..()
	if(cupholder)
		. += span_notice("There are [cups] cups in the cup dispenser.")

/obj/structure/reagent_dispensers/water_cooler/verb/rotate_clockwise()
	set name = "Rotate Cooler Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

//VOREstation edit: counter-clockwise rotation
/obj/structure/reagent_dispensers/water_cooler/verb/rotate_counterclockwise()
	set name = "Rotate Cooler Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1
//VOREstation edit end

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/I as obj, mob/user as mob)
	if(I.has_tool_quality(TOOL_WRENCH))
		src.add_fingerprint(user)
		if(bottle)
			playsound(src, I.usesound, 50, 1)
			if(do_after(user, 20) && bottle)
				to_chat(user, span_notice("You unfasten the jug."))
				var/obj/item/reagent_containers/glass/cooler_bottle/G = new /obj/item/reagent_containers/glass/cooler_bottle( src.loc )
				for(var/datum/reagent/R in reagents.reagent_list)
					var/total_reagent = reagents.get_reagent_amount(R.id)
					G.reagents.add_reagent(R.id, total_reagent)
				reagents.clear_reagents()
				bottle = 0
				update_icon()
		else
			if(anchored)
				user.visible_message("\The [user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
			else
				user.visible_message("\The [user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")
			if(do_after(user, 20 * I.toolspeed, src))
				if(!src) return
				to_chat(user, span_notice("You [anchored? "un" : ""]secured \the [src]!"))
				anchored = !anchored
				playsound(src, I.usesound, 50, 1)
		return

	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		if(cupholder)
			playsound(src, I.usesound, 50, 1)
			to_chat(user, span_notice("You take the cup dispenser off."))
			new /obj/item/stack/material/plastic( src.loc )
			if(cups)
				for(var/i = 0 to cups)
					new /obj/item/reagent_containers/food/drinks/sillycup(src.loc)
			cups = 0
			cupholder = 0
			update_icon()
			return
		if(!bottle && !cupholder)
			playsound(src, I.usesound, 50, 1)
			to_chat(user, span_notice("You start taking the water-cooler apart."))
			if(do_after(user, 20 * I.toolspeed) && !bottle && !cupholder)
				to_chat(user, span_notice("You take the water-cooler apart."))
				new /obj/item/stack/material/plastic( src.loc, 4 )
				qdel(src)
		return

	if(istype(I, /obj/item/reagent_containers/glass/cooler_bottle))
		src.add_fingerprint(user)
		if(!bottle)
			if(anchored)
				var/obj/item/reagent_containers/glass/cooler_bottle/G = I
				to_chat(user, span_notice("You start to screw the bottle onto the water-cooler."))
				if(do_after(user, 20) && !bottle && anchored)
					bottle = 1
					update_icon()
					to_chat(user, span_notice("You screw the bottle onto the water-cooler!"))
					for(var/datum/reagent/R in G.reagents.reagent_list)
						var/total_reagent = G.reagents.get_reagent_amount(R.id)
						reagents.add_reagent(R.id, total_reagent)
					qdel(G)
			else
				to_chat(user, span_warning("You need to wrench down the cooler first."))
		else
			to_chat(user, span_warning("There is already a bottle there!"))
		return 1

	if(istype(I, /obj/item/stack/material/plastic))
		if(!cupholder)
			if(anchored)
				var/obj/item/stack/material/plastic/P = I
				src.add_fingerprint(user)
				to_chat(user, span_notice("You start to attach a cup dispenser onto the water-cooler."))
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20) && !cupholder && anchored)
					if (P.use(1))
						to_chat(user, span_notice("You attach a cup dispenser onto the water-cooler."))
						cupholder = 1
						update_icon()
			else
				to_chat(user, span_warning("You need to wrench down the cooler first."))
		else
			to_chat(user, span_warning("There is already a cup dispenser there!"))
		return

/obj/structure/reagent_dispensers/water_cooler/attack_hand(mob/user)
	if(cups)
		new /obj/item/reagent_containers/food/drinks/sillycup(src.loc)
		cups--
		flick("[icon_state]-vend", src)
		return

/obj/structure/reagent_dispensers/water_cooler/update_icon()
	icon_state = "water_cooler"
	cut_overlays()
	if(bottle)
		add_overlay("water_cooler_bottle")

/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/beerkeg/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_BEER,1000)

/obj/structure/reagent_dispensers/beerkeg/wood
	name = "beer keg"
	desc = "A beer keg with a tap on it."
	icon_state = "beertankfantasy"

/obj/structure/reagent_dispensers/beerkeg/wine
	name = "wine barrel"
	desc = "A wine casket with a tap on it."
	icon_state = "beertankfantasy"

/obj/structure/reagent_dispensers/beerkeg/wine/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_REDWINE,1000)

/obj/structure/reagent_dispensers/beerkeg/fakenuke
	name = "nuclear beer keg"
	desc = "A beer keg in the form of a nuclear bomb! An absolute blast at parties!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"

//Cooking oil refill tank
/obj/structure/reagent_dispensers/cookingoil
	name = "cooking oil tank"
	desc = "A fifty-litre tank of commercial-grade corn oil, intended for use in large scale deep fryers. Store in a cool, dark place"
	icon = 'icons/obj/objects.dmi'
	icon_state = "oiltank"
	amount_per_transfer_from_this = 120

/obj/structure/reagent_dispensers/cookingoil/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_COOKINGOIL,5000)

/obj/structure/reagent_dispensers/cookingoil/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		explode()

/obj/structure/reagent_dispensers/cookingoil/ex_act()
	explode()

/obj/structure/reagent_dispensers/cookingoil/proc/explode()
	reagents.splash_area(get_turf(src), 3)
	visible_message(span_danger("The [src] bursts open, spreading oil all over the area."))
	qdel(src)

/obj/structure/reagent_dispensers/bloodbarrel
	name = "blood barrel"
	desc = "A beer keg."
	icon = 'icons/obj/chemical_tanks.dmi'
	icon_state = "bloodbarrel"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/bloodbarrel/Initialize(mapload)
	. = ..()
	reagents.add_reagent(REAGENT_ID_BLOOD, 1000, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"="O-","resistances"=null,"trace_chem"=null))
