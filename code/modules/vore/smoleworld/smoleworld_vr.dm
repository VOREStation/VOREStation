// future to do list for anyone who wants to try:
//Make building turf enterable for small people.
//Make buildings enterable then bustable from the inside.
//Tiny cars drivable only by small people, wheel chair code.
//Add details to planet foods as well as diversify options for cargo ordering.
//make water turfs stomp and apply to player sprites.


//turf items

/turf/simulated/floor/smole
	name = "toy floor"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "megablocksturf"
	var/list/crossed_dirs = list()

/turf/simulated/floor/smole/Entered(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.hovering || L.flying) // Flying things shouldn't make footprints.
			if(L.flying)
				L.adjust_nutrition(-0.5)
			return ..()
		if(L.get_effective_size(FALSE) <= RESIZE_NORMAL)
			return ..()
		if(L.get_effective_size(FALSE) >= RESIZE_A_BIGNORMAL)
			playsound(src, 'sound/effects/footstep/giantstep_gigga.ogg', 35, 1, -1, volume_channel = VOLUME_CHANNEL_MASTER)
			var/mdir = "[A.dir]"
			crossed_dirs[mdir] = 1
			update_icon()
	. = ..()

/turf/simulated/floor/smole/update_icon()
	..()
	for(var/d in crossed_dirs)
		add_overlay(image(icon = 'icons/vore/smoleworld_vr.dmi', icon_state = "stomp", dir = text2num(d)))

//Extra micro turfs
/turf/simulated/floor/smole/grass
	name = "grass"
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass/outdoors

/turf/simulated/floor/smole/desert
	icon = 'icons/turf/desert.dmi'
	icon_state = "desert"
	initial_flooring = /decl/flooring/sand/desert

/turf/simulated/floor/smole/megablocks
	name = "block floor"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "megablocksturf"

//Used to make smole objects be able to be built from menu

/datum/material/smolebricks/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("road straight", /obj/structure/smoletrack/roadS, 1, time = 5)
	recipes += new/datum/stack_recipe("road threeway", /obj/structure/smoletrack/roadT, 1, time = 5)
	recipes += new/datum/stack_recipe("road turn ", /obj/structure/smoletrack/roadturn, 1, time = 5)
	recipes += new/datum/stack_recipe("road fourway", /obj/structure/smoletrack/roadF, 1, time = 5)
	recipes += new/datum/stack_recipe("smole houses", /obj/structure/smolebuilding/houses, 2, time = 10)
	recipes += new/datum/stack_recipe("smole business", /obj/structure/smolebuilding/business, 2, time = 10)
	recipes += new/datum/stack_recipe("smole warehouses", /obj/structure/smolebuilding/warehouses, 2, time = 10)
	recipes += new/datum/stack_recipe("smole museum", /obj/structure/smolebuilding/museum, 2, time = 10)

/datum/material/smolebricks
	name = "smolebricks"
	stack_type = /obj/item/stack/material/smolebricks
	icon_base = "solid"
	icon_reinf = "reinf_over"
	destruction_desc = "smashed"
	sheet_singular_name = "bag"
	sheet_plural_name = "bags"

//the actual materials

/obj/item/stack/material/smolebricks
	name = "smolebricks"
	desc = "A collection of tiny colored bricks ready to be built into whatever you want."
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "smolematerial"
	drop_sound = 'sound/items/drop/smolematerial.ogg'
	pickup_sound = 'sound/items/pickup/pillbottle.ogg'
	default_type = "smolebricks"
	w_class = ITEMSIZE_SMALL

//smolebrick case to make for easy bricks.
/obj/item/storage/smolebrickcase
	name = "smolebrick case"
	desc = "You feel the power of imagination."
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "smolestorage"
	throw_speed = 1
	throw_range = 4
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_SMALL * 7 // most code copied from toolbox
	use_sound = 'sound/items/storage/smolecase.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'
	starts_with = list( /obj/item/stack/material/smolebricks,
	/obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks,
	/obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks,
	/obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks, /obj/item/stack/material/smolebricks
	)

//Track code
//defineing actions
/obj/structure/smoletrack
	icon = 'icons/vore/smoleworld_vr.dmi'
	color = "#ffffff"
	density = FALSE

/obj/structure/smoletrack/attack_hand(mob/user)
	if(user.a_intent == I_DISARM)
		if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
			return
		to_chat(user, "<span class='notice'>[src] was dismantaled into bricks.</span>")
		playsound(src, 'sound/items/smolesmallbuild.ogg', 50, 1, -1, volume_channel = VOLUME_CHANNEL_MASTER)
		var/turf/simulated/floor/F = get_turf(src)
		if(istype(F))
			new /obj/item/stack/material/smolebricks(F)
		qdel(src)

//rotates piece
/obj/structure/smoletrack/verb/rotate_clockwise()
	set name = "Rotate Road Clockwise"
	set category = "Object"
	set src in oview(1)
	if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
		return
	src.set_dir(turn(src.dir, 270))

/obj/structure/smoletrack/verb/rotate_counterclockwise()
	set name = "Rotate Road Counter-Clockwise"
	set category = "Object"
	set src in oview(1)
	if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
		return
	src.set_dir(turn(src.dir, 90))

//color roads
/obj/structure/smoletrack/verb/colorpieces()
	set name = "Use Color Pieces"
	set category = "Object"
	set src in oview(1)
	if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
		return
	var/new_color = input(usr, "Please select color.", "Paint Color", color) as color|null
	color = new_color
	return


// probably redundant, allows for direct way to dismantal without knowing intents
/obj/structure/smoletrack/verb/menudismantal()
	set name = "Take Road Apart"
	set category = "Object"
	set src in oview(1)
	if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
		return
	playsound(src, 'sound/items/smolesmallbuild.ogg', 50, 1, -1, volume_channel = VOLUME_CHANNEL_MASTER)
	var/turf/simulated/floor/F = get_turf(src)
	if(istype(F))
		new /obj/item/stack/material/smolebricks(F)
	qdel(src)
	return


// Road pieces

/obj/structure/smoletrack/roadS
	name = "road straight piece"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "carstraight"
	desc = "A long set of tiny road."
	anchored = TRUE

/obj/structure/smoletrack/roadT
	name = "road threeway piece"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "carthreeway"
	desc = "A tiny threeway road piece."
	anchored = TRUE

/obj/structure/smoletrack/roadturn
	name = "road turn piece"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "carturn"
	desc = "A tiny turn road piece."
	anchored = TRUE

/obj/structure/smoletrack/roadF
	name = "road four-way piece"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "carfourway"
	desc = "A four-way road piece."
	anchored = TRUE

//buildings code
//Defining building actions
/obj/structure/smolebuilding
	icon = 'icons/vore/smoleworld_vr.dmi'
	density = TRUE
	anchored = TRUE
	color = "#ffffff"
	micro_target = TRUE	//Now micros can enter and navigate these things!!!
	var/health = 75
	var/damage

//makes it so buildings can be dismaintaled or GodZilla style attacked
/obj/structure/smolebuilding/attack_hand(mob/user)
	if(user.a_intent == I_DISARM)
		if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
			return
		to_chat(user, "<span class='notice'>[src] was dismantaled into bricks.</span>")
		playsound(src, 'sound/items/smolesmallbuild.ogg', 50, 1, -1, volume_channel = VOLUME_CHANNEL_MASTER)
		if(!isnull(loc))
			new /obj/item/stack/material/smolebricks(loc)
			new /obj/item/stack/material/smolebricks(loc)
		qdel(src)

	else if (usr.a_intent == I_HURT)

		if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
			return

		take_damage()
		playsound(src, 'sound/items/smolebuildinghit2.ogg', 50, 1)
		user.do_attack_animation(src)
		usr.visible_message("<span class='danger'>\The [usr] bangs against \the [src]!</span>",
							"<span class='danger'>You bang against \the [src]!</span>",
							"You hear a banging sound.")
	else
		usr.visible_message("[usr.name] knocks on the [src.name].",
							"You knock on the [src.name].")
	return

//takes 3 normal attacks
/obj/structure/smolebuilding/take_damage()
	damage = 25
	health = health - damage

	if(health <= 0)
		dismantle()
	else
		return
	return
//results of attacks will remove building and spawn in ruins.
/obj/structure/smolebuilding/proc/dismantle()
	visible_message("<span class='danger'>\The [src] falls apart!</span>")
	playsound(src, 'sound/items/smolebuildingdestoryed.ogg', 50, 1, -1, volume_channel = VOLUME_CHANNEL_MASTER)
	new /obj/structure/smoleruins(loc)
	qdel(src)
	return

//checks for items and does the same as dismaintle but spawns material instead.
/obj/structure/smolebuilding/attackby(obj/item/W as obj, mob/user as mob)
	dismantle()
	return
//checks for projectile damage and does the same as dismaintle but spawns material instead.
/obj/structure/smolebuilding/bullet_act(var/obj/item/projectile/Proj)
	displode()
	return
//is the same as dismaintal but instead of ruins it just makes it all explode
/obj/structure/smolebuilding/proc/displode()
	visible_message("<span class='danger'>\The [src] explodes into pieces!</span>")
	playsound(src, 'sound/items/smolebuildingdestoryedshort.ogg', 50, 1, -1, volume_channel = VOLUME_CHANNEL_MASTER)
	new /obj/item/stack/material/smolebricks(loc)
	new /obj/item/stack/material/smolebricks(loc)
	qdel(src)
	return

//get material from ruins
/obj/structure/smoleruins/attack_hand(mob/user)
	if(user.a_intent == I_DISARM)
		if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
			return
		to_chat(user, "<span class='notice'>[src] was dismantaled into bricks.</span>")
		playsound(src, 'sound/items/smolelargeunbuild.ogg', 50, 1, volume_channel = VOLUME_CHANNEL_MASTER)
		if(!isnull(loc))
			new /obj/item/stack/material/smolebricks(loc)
			new /obj/item/stack/material/smolebricks(loc)
		qdel(src)

//Ruins go asplode same as buildings if attacked
/obj/structure/smoleruins/attackby(obj/item/W as obj, mob/user as mob)
	displode()
	return

/obj/structure/smoleruins/bullet_act(var/obj/item/projectile/Proj)
	displode()
	return

/obj/structure/smoleruins/proc/displode()
	visible_message("<span class='danger'>\The [src] explodes into pieces!</span>")
	playsound(src, 'sound/items/smolebuildingdestoryedshort.ogg', 50, 1, -1, volume_channel = VOLUME_CHANNEL_MASTER)
	new /obj/item/stack/material/smolebricks(loc)
	new /obj/item/stack/material/smolebricks(loc)
	qdel(src)
	return

//color buildings
/obj/structure/smolebuilding/verb/colorpieces()
	set name = "Use Color Pieces"
	set category = "Object"
	set src in oview(1)
	if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
		return
	var/new_color = input(usr, "Please select color.", "Paint Color", color) as color|null
	color = new_color
	return

//probably a bit redundant but gives a more direct way to disassemble buildings without using intents
/obj/structure/smolebuilding/verb/menudismantal()
	set name = "Take Building Apart"
	set category = "Object"
	set src in oview(1)
	if(ismouse(usr) || (isobserver(usr) && !config.ghost_interaction))
		return
	playsound(src, 'sound/items/smolesmallbuild.ogg', 50, 1, -1, volume_channel = VOLUME_CHANNEL_MASTER)
	if(!isnull(loc))
		new /obj/item/stack/material/smolebricks(loc)
		new /obj/item/stack/material/smolebricks(loc)
	qdel(src)
	return

//buildings
/obj/structure/smoleruins
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "ruins"
	density = FALSE

/obj/structure/smolebuilding/houses
	name = "smole houses"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "smolehouses"
	color = "#ffffff"

/obj/structure/smolebuilding/business
	name = "smole business"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "smolebusiness"
	color = "#ffffff"

/obj/structure/smolebuilding/warehouses
	name = "smole warehouses"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "smolewarehouses"
	color = "#ffffff"

/obj/structure/smolebuilding/museum
	name = "smole museum"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "smolemuseum"
	color = "#ffffff"
//
//CAR STUFF < WILL BE MESSED WITH IN A LATER UPDATE COMMENTED OUT FOR NOW
///obj/item/smolecar
//	name = "toy car"
//	desc = "A toy car ready to be snapped together and burn rubber!"
//	icon = 'icons/vore/smoleworld_vr.dmi'
//	icon_state = "smolecarA_folded"
//	item_state = "smolecarA"
//	unfolded_type = /obj/structure/bed/chair/wheelchair/smolecar
//
///obj/structure/smolecar
//	name = "Toy Car"
//	desc = "Lets burn rubber!"
//	icon = 'icons/vore/smoleworld_vr.dmi'
//	icon_state = "smolecarA"
//	anchored = FALSE
//	buckle_movable = 1
//	var/carry_type = /obj/item/smolecar
//
///obj/structure/bed/chair/wheelchair/smolecar/can_buckle_check(mob/living/M, forced = FALSE)
//	. = ..()
//	if(.)
//
//		if(M.get_effective_size(TRUE) > RESIZE_TINY)
//			to_chat(M, SPAN_WARNING("You are to big to fit in \the [src]."))
	//		. = FALSE
//
//
//snack planets, currently just plopped out will be organized later.
/obj/item/trash/candychunk
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "sp_sugarchunk"
	name = "chunk of candy"
	desc = "A solid chunk of candy crumbs, looks like it could be messy."

/obj/item/trash/Asteroidlarge
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "sp_asteriodA"
	name = "asteriod"
	desc = "A solid chunk of candy crumb that looks like a asteriod."

/obj/item/trash/Asteroidmulti
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "sp_asteriodC"
	name = "asteriod"
	desc = "Several chunks of sugar crumbs that looks like asteriods."

/obj/item/bikehorn/tinytether
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "tether_trash"
	name = "tether"
	desc = "Its a tiny bit of plastic in the shape of the tether. There seems to be a small button on top."

/obj/item/bikehorn/tinytether/attack_self(mob/user as mob)
	if(spam_flag == 0)
		spam_flag = 1
		playsound(src, 'sound/items/tinytether.ogg', 30, 1, volume_channel = VOLUME_CHANNEL_MASTER)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/reagent_containers/food/snacks/snackplanet/moon
	name = "moon"
	desc = "A firm solid mass of white powdery sugar in the shape of a moon!"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "sp_moon"
	bitesize = 1
	nutriment_amt = 2
	nutriment_desc = list("sugar" = 2)
	drop_sound = 'sound/items/drop/basketball.ogg'

/obj/item/reagent_containers/food/snacks/snackplanet/virgo3b
	name = "Virgo 3B"
	desc = "A sticky jelly jaw breaker in the shape of Virgo-3B, it even has a tiny tether!"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "sp_Virgo3B"
	bitesize = 3
	trash = /obj/item/bikehorn/tinytether
	nutriment_amt = 2
	nutriment_desc = list("spicy" = 2, "tang" = 2)
	drop_sound = 'sound/items/drop/basketball.ogg'

/obj/item/reagent_containers/food/snacks/snackplanet/phoron
	name = "phoron giant"
	desc = "A spicy jaw breaker that seems to swirl in the light."
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "sp_phoron"
	bitesize = 3
	trash = /obj/item/trash/candychunk
	nutriment_amt = 2
	nutriment_desc = list("spicy" = 2)
	drop_sound = 'sound/items/drop/basketball.ogg'

/obj/item/reagent_containers/food/snacks/snackplanet/virgoprime
	name = "Virgo Prime"
	desc = "It's a orange jaw breaker in the shape of Virgo Prime!"
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "sp_virgoprime"
	bitesize = 3
	trash = /obj/item/trash/candychunk
	nutriment_amt = 2
	nutriment_desc = list("salty" = 2)
	drop_sound = 'sound/items/drop/basketball.ogg'

/obj/item/storage/bagoplanets
	name = "bag o' planets"
	desc = "A cosmic bag of fist-sized candy planets."
	icon = 'icons/vore/smoleworld_vr.dmi'
	icon_state = "sp_storage"
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_SMALL * 7 // most code copied from toolbox
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'
	starts_with = list(/obj/item/reagent_containers/food/snacks/snackplanet/phoron,
	/obj/item/reagent_containers/food/snacks/snackplanet/virgo3b,/obj/item/reagent_containers/food/snacks/snackplanet/moon,
	/obj/item/reagent_containers/food/snacks/snackplanet/virgoprime
	)
