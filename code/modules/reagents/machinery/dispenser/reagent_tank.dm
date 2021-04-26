/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	layer = TABLE_LAYER
	density = 1
	anchored = 0
	pressure_resistance = 2*ONE_ATMOSPHERE

	var/obj/item/hose_connector/input/active/InputSocket
	var/obj/item/hose_connector/output/active/OutputSocket

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

/obj/structure/reagent_dispensers/attackby(obj/item/weapon/W as obj, mob/user as mob)
		return

/obj/structure/reagent_dispensers/Destroy()
	QDEL_NULL(InputSocket)
	QDEL_NULL(OutputSocket)

	..()

/obj/structure/reagent_dispensers/Initialize()
	var/datum/reagents/R = new/datum/reagents(5000)
	reagents = R
	R.my_atom = src
	if (!possible_transfer_amounts)
		src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT

	InputSocket = new(src)
	InputSocket.carrier = src
	OutputSocket = new(src)
	OutputSocket.carrier = src

	. = ..()

/obj/structure/reagent_dispensers/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		. += "<span class='notice'>It contains:</span>"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				. += "<span class='notice'>[R.volume] units of [R.name]</span>"
		else
			. += "<span class='notice'>Nothing.</span>"

/obj/structure/reagent_dispensers/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in view(1)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
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
		else
	return

/obj/structure/reagent_dispensers/blob_act()
	qdel(src)



//Dispensers
/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "A watertank."
	icon = 'icons/obj/objects_vr.dmi' //VOREStation Edit
	icon_state = "watertank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/watertank/Initialize()
	. = ..()
	reagents.add_reagent("water", 1000)

/obj/structure/reagent_dispensers/watertank/high
	name = "high-capacity water tank"
	desc = "A highly-pressurized water tank made to hold vast amounts of water.."
	icon_state = "watertank_high"

/obj/structure/reagent_dispensers/watertank/high/Initialize()
	. = ..()
	reagents.add_reagent("water", 4000)

/obj/structure/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "A fueltank."
	icon = 'icons/obj/objects_vr.dmi' //VOREStation Edit
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10
	var/modded = 0
	var/obj/item/device/assembly_holder/rig = null

/obj/structure/reagent_dispensers/fueltank/Initialize()
	. = ..()
	reagents.add_reagent("fuel",1000)

//VOREStation Add
/obj/structure/reagent_dispensers/fueltank/high
	name = "high-capacity fuel tank"
	desc = "A highly-pressurized fuel tank made to hold vast amounts of fuel."
	icon_state = "weldtank_high"

/obj/structure/reagent_dispensers/fueltank/high/Initialize()
	. = ..()
	reagents.add_reagent("fuel",4000)

/obj/structure/reagent_dispensers/foam
	name = "foamtank"
	desc = "A foam tank."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "foamtank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/foam/Initialize()
	. = ..()
	reagents.add_reagent("firefoam",1000)

/obj/structure/reagent_dispensers/fueltank/barrel
	name = "hazardous barrel"
	desc = "An open-topped barrel full of nasty-looking liquid."
	icon_state = "barrel"
	modded = TRUE

/obj/structure/reagent_dispensers/fueltank/barrel/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (W.is_wrench()) //can't wrench it shut, it's always open
		return
	return ..()
//VOREStation Add End

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		if(modded)
			. += "<span class='warning'>Fuel faucet is wrenched open, leaking the fuel!</span>"
		if(rig)
			. += "<span class='notice'>There is some kind of device rigged to the tank.</span>"

/obj/structure/reagent_dispensers/fueltank/attack_hand()
	if (rig)
		usr.visible_message("[usr] begins to detach [rig] from \the [src].", "You begin to detach [rig] from \the [src]")
		if(do_after(usr, 20))
			usr.visible_message("<span class='notice'>[usr] detaches [rig] from \the [src].</span>", "<span class='notice'>You detach [rig] from \the [src]</span>")
			rig.loc = get_turf(usr)
			rig = null
			overlays = new/list()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (W.is_wrench())
		user.visible_message("[user] wrenches [src]'s faucet [modded ? "closed" : "open"].", \
			"You wrench [src]'s faucet [modded ? "closed" : "open"]")
		modded = modded ? 0 : 1
		playsound(src, W.usesound, 75, 1)
		if (modded)
			message_admins("[key_name_admin(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
			log_game("[key_name(user)] opened fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]), leaking fuel.")
			leak_fuel(amount_per_transfer_from_this)
	if (istype(W,/obj/item/device/assembly_holder))
		if (rig)
			to_chat(user, "<span class='warning'>There is another device in the way.</span>")
			return ..()
		user.visible_message("[user] begins rigging [W] to \the [src].", "You begin rigging [W] to \the [src]")
		if(do_after(user, 20))
			user.visible_message("<span class='notice'>[user] rigs [W] to \the [src].</span>", "<span class='notice'>You rig [W] to \the [src]</span>")

			var/obj/item/device/assembly_holder/H = W
			if (istype(H.a_left,/obj/item/device/assembly/igniter) || istype(H.a_right,/obj/item/device/assembly/igniter))
				message_admins("[key_name_admin(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>)")
				log_game("[key_name(user)] rigged fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) for explosion.")

			rig = W
			user.drop_item()
			W.loc = src

			var/icon/test = getFlatIcon(W)
			test.Shift(NORTH,1)
			test.Shift(EAST,6)
			overlays += test

	return ..()


/obj/structure/reagent_dispensers/fueltank/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		if(istype(Proj.firer))
			message_admins("[key_name_admin(Proj.firer)] shot fueltank at [loc.loc.name] ([loc.x],[loc.y],[loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>).")
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
	reagents.remove_reagent("fuel",amount)
	new /obj/effect/decal/cleanable/liquid_fuel(src.loc, amount,1)

/obj/structure/reagent_dispensers/peppertank
	name = "Pepper Spray Refiller"
	desc = "Refills pepper spray canisters."
	icon = 'icons/obj/objects.dmi'
	icon_state = "peppertank"
	anchored = 1
	density = 0
	amount_per_transfer_from_this = 45

/obj/structure/reagent_dispensers/peppertank/Initialize()
	. = ..()
	reagents.add_reagent("condensedcapsaicin",1000)


/obj/structure/reagent_dispensers/water_cooler
	name = "Water-Cooler"
	desc = "A machine that dispenses water to drink."
	amount_per_transfer_from_this = 5
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	possible_transfer_amounts = null
	anchored = 1
	var/bottle = 0
	var/cups = 0
	var/cupholder = 0

/obj/structure/reagent_dispensers/water_cooler/full
	bottle = 1
	cupholder = 1
	cups = 10

/obj/structure/reagent_dispensers/water_cooler/Initialize()
	. = ..()
	if(bottle)
		reagents.add_reagent("water",120)
	update_icon()

/obj/structure/reagent_dispensers/water_cooler/examine(mob/user)
	. = ..()
	if(cupholder)
		. += "<span class='notice'>There are [cups] cups in the cup dispenser.</span>"

/obj/structure/reagent_dispensers/water_cooler/verb/rotate_clockwise()
	set name = "Rotate Cooler Clockwise"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 270))
	return 1

/obj/structure/reagent_dispensers/water_cooler/attackby(obj/item/I as obj, mob/user as mob)
	if(I.is_wrench())
		src.add_fingerprint(user)
		if(bottle)
			playsound(src, I.usesound, 50, 1)
			if(do_after(user, 20) && bottle)
				to_chat(user, "<span class='notice'>You unfasten the jug.</span>")
				var/obj/item/weapon/reagent_containers/glass/cooler_bottle/G = new /obj/item/weapon/reagent_containers/glass/cooler_bottle( src.loc )
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
				to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
				anchored = !anchored
				playsound(src, I.usesound, 50, 1)
		return

	if(I.is_screwdriver())
		if(cupholder)
			playsound(src, I.usesound, 50, 1)
			to_chat(user, "<span class='notice'>You take the cup dispenser off.</span>")
			new /obj/item/stack/material/plastic( src.loc )
			if(cups)
				for(var/i = 0 to cups)
					new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src.loc)
			cups = 0
			cupholder = 0
			update_icon()
			return
		if(!bottle && !cupholder)
			playsound(src, I.usesound, 50, 1)
			to_chat(user, "<span class='notice'>You start taking the water-cooler apart.</span>")
			if(do_after(user, 20 * I.toolspeed) && !bottle && !cupholder)
				to_chat(user, "<span class='notice'>You take the water-cooler apart.</span>")
				new /obj/item/stack/material/plastic( src.loc, 4 )
				qdel(src)
		return

	if(istype(I, /obj/item/weapon/reagent_containers/glass/cooler_bottle))
		src.add_fingerprint(user)
		if(!bottle)
			if(anchored)
				var/obj/item/weapon/reagent_containers/glass/cooler_bottle/G = I
				to_chat(user, "<span class='notice'>You start to screw the bottle onto the water-cooler.</span>")
				if(do_after(user, 20) && !bottle && anchored)
					bottle = 1
					update_icon()
					to_chat(user, "<span class='notice'>You screw the bottle onto the water-cooler!</span>")
					for(var/datum/reagent/R in G.reagents.reagent_list)
						var/total_reagent = G.reagents.get_reagent_amount(R.id)
						reagents.add_reagent(R.id, total_reagent)
					qdel(G)
			else
				to_chat(user, "<span class='warning'>You need to wrench down the cooler first.</span>")
		else
			to_chat(user, "<span class='warning'>There is already a bottle there!</span>")
		return 1

	if(istype(I, /obj/item/stack/material/plastic))
		if(!cupholder)
			if(anchored)
				var/obj/item/stack/material/plastic/P = I
				src.add_fingerprint(user)
				to_chat(user, "<span class='notice'>You start to attach a cup dispenser onto the water-cooler.</span>")
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 20) && !cupholder && anchored)
					if (P.use(1))
						to_chat(user, "<span class='notice'>You attach a cup dispenser onto the water-cooler.</span>")
						cupholder = 1
						update_icon()
			else
				to_chat(user, "<span class='warning'>You need to wrench down the cooler first.</span>")
		else
			to_chat(user, "<span class='warning'>There is already a cup dispenser there!</span>")
		return

/obj/structure/reagent_dispensers/water_cooler/attack_hand(mob/user)
	if(cups)
		new /obj/item/weapon/reagent_containers/food/drinks/sillycup(src.loc)
		cups--
		flick("[icon_state]-vend", src)
		return

/obj/structure/reagent_dispensers/water_cooler/update_icon()
	icon_state = "water_cooler"
	overlays.Cut()
	var/image/I
	if(bottle)
		I = image(icon, "water_cooler_bottle")
		overlays += I
	return

/obj/structure/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispensers/beerkeg/Initialize()
	. = ..()
	reagents.add_reagent("beer",1000)

/obj/structure/reagent_dispensers/beerkeg/fakenuke
	name = "nuclear beer keg"
	desc = "A beer keg in the form of a nuclear bomb! An absolute blast at parties!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"

/obj/structure/reagent_dispensers/virusfood
	name = "Virus Food Dispenser"
	desc = "A dispenser of virus food. Yum."
	icon = 'icons/obj/objects.dmi'
	icon_state = "virusfoodtank"
	amount_per_transfer_from_this = 10
	anchored = 1

/obj/structure/reagent_dispensers/virusfood/Initialize()
	. = ..()
	reagents.add_reagent("virusfood", 1000)

/obj/structure/reagent_dispensers/acid
	name = "Sulphuric Acid Dispenser"
	desc = "A dispenser of acid for industrial processes."
	icon = 'icons/obj/objects.dmi'
	icon_state = "acidtank"
	amount_per_transfer_from_this = 10
	anchored = 1

/obj/structure/reagent_dispensers/acid/Initialize()
	. = ..()
	reagents.add_reagent("sacid", 1000)
	
//Cooking oil refill tank
/obj/structure/reagent_dispensers/cookingoil
	name = "cooking oil tank"
	desc = "A fifty-litre tank of commercial-grade corn oil, intended for use in large scale deep fryers. Store in a cool, dark place"
	icon = 'icons/obj/objects.dmi'
	icon_state = "oiltank"
	amount_per_transfer_from_this = 120

/obj/structure/reagent_dispensers/cookingoil/New()
		..()
		reagents.add_reagent("cornoil",5000)

/obj/structure/reagent_dispensers/cookingoil/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		explode()

/obj/structure/reagent_dispensers/cookingoil/ex_act()
	explode()

/obj/structure/reagent_dispensers/cookingoil/proc/explode()
	reagents.splash_area(get_turf(src), 3)
	visible_message(span("danger", "The [src] bursts open, spreading oil all over the area."))
	qdel(src)

/obj/structure/reagent_dispensers/he3
	name = "fueltank"
	desc = "A fueltank."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 10

/obj/structure/reagent_dispenser/he3/Initialize()
	..()
	reagents.add_reagent("helium3",1000)
