/obj/structure/trash_pile
	name = "trash pile"
	desc = "A heap of garbage, but maybe there's something interesting inside?"
	icon = 'icons/obj/trash_piles.dmi'
	icon_state = "randompile"
	density = TRUE
	anchored = TRUE

	var/list/searchedby	= list()// Characters that have searched this trashpile, with values of searched time.
	var/mob/living/hider		// A simple animal that might be hiding in the pile

	var/obj/structure/mob_spawner/mouse_nest/mouse_nest = null

	var/chance_alpha	= 40	// Alpha list is junk items and normal random stuff.
	var/chance_beta		= 40	// Beta list is actually maybe some useful illegal items. If it's not alpha or gamma, it's beta.
	var/chance_gamma	= 20		// Gamma list is unique items only, and will only spawn one of each. This is a sub-chance of beta chance.

	//These are types that can only spawn once, and then will be removed from this list.
	//Alpha and beta lists are in their respective procs.
	var/global/list/unique_gamma = list(
		/obj/item/weapon/gun/projectile/pirate,
		/obj/item/clothing/accessory/permit/gun,
		/obj/item/weapon/gun/projectile/dartgun
		)

	var/global/list/allocated_gamma = list()

/obj/structure/trash_pile/Initialize()
	. = ..()
	icon_state = pick(
		"pile1",
		"pile2",
		"pilechair",
		"piletable",
		"pilevending",
		"brtrashpile",
		"microwavepile",
		"rackpile",
		"boxfort",
		"trashbag",
		"brokecomp")
	mouse_nest = new(src)

/obj/structure/trash_pile/Destroy()
	qdel(mouse_nest)
	mouse_nest = null
	return ..()

/obj/structure/trash_pile/attackby(obj/item/W as obj, mob/user as mob)
	var/w_type = W.type
	if(w_type in allocated_gamma)
		to_chat(user,"<span class='notice'>You feel \the [W] slip from your hand, and disappear into the trash pile.</span>")
		user.unEquip(W)
		W.forceMove(src)
		allocated_gamma -= w_type
		unique_gamma += w_type
		qdel(W)

	else
		return ..()

/obj/structure/trash_pile/attack_generic(mob/user)
	//Simple Animal
	if(isanimal(user))
		var/mob/living/L = user
		//They're in it, and want to get out.
		if(L.loc == src)
			var/choice = tgui_alert(user, "Do you want to exit \the [src]?","Un-Hide?",list("Exit","Stay"))
			if(choice == "Exit")
				if(L == hider)
					hider = null
				L.forceMove(get_turf(src))
		else if(!hider)
			var/choice = tgui_alert(user, "Do you want to hide in \the [src]?","Un-Hide?",list("Hide","Stay"))
			if(choice == "Hide" && !hider) //Check again because PROMPT
				L.forceMove(src)
				hider = L
	else
		return ..()

/obj/structure/trash_pile/attack_hand(mob/user)
	//Human mob
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.visible_message("[user] searches through \the [src].","<span class='notice'>You search through \the [src].</span>")
		if(hider)
			to_chat(hider,"<span class='warning'>[user] is searching the trash pile you're in!</span>")

		//Do the searching
		if(do_after(user,rand(4 SECONDS,6 SECONDS),src))

			//If there was a hider, chance to reveal them
			if(hider && prob(50))
				to_chat(hider,"<span class='danger'>You've been discovered!</span>")
				hider.forceMove(get_turf(src))
				hider = null
				to_chat(user,"<span class='danger'>Some sort of creature leaps out of \the [src]!</span>")

			//You already searched this one bruh
			else if(user.ckey in searchedby)
				to_chat(H,"<span class='warning'>There's nothing else for you in \the [src]!</span>")

			//You found an item!
			else
				var/luck = rand(1,100)
				var/obj/item/I
				if(luck <= chance_alpha)
					I = produce_alpha_item()
				else if(luck <= chance_alpha+chance_beta)
					I = produce_beta_item()
				else if(luck <= chance_alpha+chance_beta+chance_gamma)
					I = produce_gamma_item()

				//We either have an item to hand over or we don't, at this point!
				if(I)
					searchedby += user.ckey
					I.forceMove(get_turf(src))
					to_chat(H,"<span class='notice'>You found \a [I]!</span>")

	else
		return ..()

//Random lists
/obj/structure/trash_pile/proc/produce_alpha_item()
	var/path = pick(prob(1);/obj/item/clothing/gloves/rainbow,
					prob(2);/obj/random/cigarettes,
					prob(2);/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
					prob(3);/obj/item/weapon/spacecash/c1000,
					prob(1);/obj/item/weapon/storage/backpack/satchel,
					prob(1);/obj/item/weapon/storage/briefcase,
					prob(1);/obj/item/clothing/accessory/storage/webbing,
					prob(1);/obj/item/clothing/glasses/meson,
					prob(1);/obj/item/clothing/mask/gas,
					prob(1);/obj/item/clothing/suit/storage/toggle/bomber,
					prob(1);/obj/item/clothing/suit/storage/toggle/leather_jacket,
					prob(3);/obj/item/weapon/storage/box/donkpockets,
					prob(1);/obj/item/weapon/storage/box/mousetraps,
					prob(1);/obj/item/clothing/glasses/meson/prescription,
					prob(3);/obj/item/clothing/gloves/yellow,
					prob(1);/obj/item/clothing/gloves/sterile/latex,
					prob(2);/obj/item/clothing/head/welding,
					prob(2);/obj/item/clothing/under/syndicate/tacticool,
					prob(2);/obj/item/clothing/under/hyperfiber,
					prob(2);/obj/item/device/camera,
					prob(2);/obj/item/weapon/cell/super,
					prob(2);/obj/item/poster,
					prob(3);/obj/item/weapon/storage/box/sinpockets,
					prob(2);/obj/item/weapon/storage/secure/briefcase,
					prob(4);/obj/item/clothing/under/fluff/latexmaid,
					prob(1);/obj/item/clothing/glasses/sunglasses,
					prob(1);/obj/item/clothing/glasses/welding,
					prob(1);/obj/item/clothing/head/ushanka,
					prob(4);/obj/item/clothing/shoes/syndigaloshes,
					prob(6);/obj/item/clothing/under/tactical,
					prob(3);/obj/item/device/paicard,
					prob(5);/obj/item/weapon/card/emag,
					prob(1);/obj/item/clothing/mask/gas/voice,
					prob(1);/obj/item/weapon/spacecash/c100,
					prob(1);/obj/item/weapon/spacecash/c50,
					prob(4);/obj/item/weapon/storage/backpack/dufflebag/syndie,
					prob(4);/obj/item/pizzavoucher,
					prob(1);/obj/item/device/perfect_tele,
					prob(1);/obj/item/weapon/bluespace_harpoon,
					prob(1);/obj/item/clothing/glasses/thermal/syndi,
					prob(1);/obj/item/weapon/gun/energy/netgun,
					prob(1);/obj/item/capture_crystal)

	var/obj/item/I = new path()
	return I

/obj/structure/trash_pile/proc/produce_beta_item()
	var/path = pick(prob(6);/obj/item/weapon/storage/pill_bottle/paracetamol,
					prob(4);/obj/item/weapon/storage/pill_bottle/happy,
					prob(4);/obj/item/weapon/storage/pill_bottle/zoom,
					prob(1);/obj/item/seeds/ambrosiavulgarisseed,
					prob(5);/obj/item/weapon/gun/energy/sizegun,
					prob(1);/obj/item/weapon/material/butterfly,
					prob(1);/obj/item/weapon/material/butterfly/switchblade,
					prob(1);/obj/item/weapon/reagent_containers/syringe/drugs,
					prob(3);/obj/item/weapon/implanter/sizecontrol,
					prob(3);/obj/item/weapon/handcuffs/fuzzy,
					prob(2);/obj/item/weapon/handcuffs/legcuffs/fuzzy,
					prob(2);/obj/item/weapon/storage/box/syndie_kit/spy,
					prob(2);/obj/item/weapon/grenade/anti_photon,
					prob(2);/obj/item/clothing/under/hyperfiber/bluespace,
					prob(2);/obj/item/weapon/reagent_containers/glass/beaker/vial/amorphorovir,
					prob(1);/obj/item/clothing/suit/storage/vest/heavy/merc,
					prob(1);/obj/item/device/nif,
					prob(1);/obj/item/device/radio_jammer,
					prob(3);/obj/item/device/sleevemate,
					prob(1);/obj/item/device/bodysnatcher,
					prob(2);/obj/item/weapon/cell/hyper,
					prob(5);/obj/item/weapon/disk/nifsoft/compliance,
					prob(1);/obj/item/weapon/material/knife/tacknife,
					prob(1);/obj/item/weapon/storage/box/survival/space,
					prob(4);/obj/item/weapon/storage/secure/briefcase/trashmoney,
					prob(1);/obj/item/weapon/reagent_containers/syringe/steroid,
					prob(3);/obj/item/device/perfect_tele,
					prob(1);/obj/item/device/survivalcapsule/popcabin,
					prob(3);/obj/item/weapon/gun/energy/netgun)

	var/obj/item/I = new path()
	return I

/obj/structure/trash_pile/proc/produce_gamma_item()
	var/path = pick_n_take(unique_gamma)
	if(!path) //Tapped out, reallocate?
		for(var/P in allocated_gamma)
			var/obj/item/I = allocated_gamma[P]
			if(QDELETED(I) || istype(I.loc,/obj/machinery/computer/cryopod))
				allocated_gamma -= P
				path = P
				break

	if(path)
		var/obj/item/I = new path()
		allocated_gamma[path] = I
		return I
	else
		return produce_beta_item()

/obj/structure/mob_spawner/mouse_nest
	name = "trash"
	desc = "A small heap of trash, perfect for mice to nest in."
	icon = 'icons/obj/trash_piles.dmi'
	icon_state = "randompile"
	spawn_types = list(/mob/living/simple_mob/animal/passive/mouse)
	simultaneous_spawns = 1
	destructible = 1
	spawn_delay = 5 HOUR

/obj/structure/mob_spawner/mouse_nest/New()
	..()
	last_spawn = rand(world.time - spawn_delay, world.time)
	icon_state = pick(
		"pile1",
		"pile2",
		"pilechair",
		"piletable",
		"pilevending",
		"brtrashpile",
		"microwavepile",
		"rackpile",
		"boxfort",
		"trashbag",
		"brokecomp")

/obj/structure/mob_spawner/mouse_nest/do_spawn(var/mob_path)
	. = ..()
	var/atom/A = get_holder_at_turf_level(src)
	A.visible_message("[.] crawls out of \the [src].")

/obj/structure/mob_spawner/mouse_nest/get_death_report(var/mob/living/L)
	..()
	last_spawn = rand(world.time - spawn_delay, world.time)
