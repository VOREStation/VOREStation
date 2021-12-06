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

	var/chance_alpha	= 50	// Alpha list is minor legal stuff. May be useful, but not particularly so.
	var/chance_beta		= 30	// Beta list is primarily items used to enable scenes in one way or another.
	var/chance_gamma	= 19	// Gamma list is illegal mechanical items. All the cool gamer loot is stored here.
	var/chance_delta	= 1		// Delta list is unique items that will be spawned only once per round.
								// The REAL cool gamer loot is in here. Mixed bag between exceptionally practical items that would fit in Beta or Gamma pools.

	//These are types that can only spawn once, and then will be removed from this list.
	//Alpha and beta lists are in their respective procs.
	var/global/list/unique_delta = list(
		/obj/item/device/perfect_tele,
		/obj/item/weapon/bluespace_harpoon,
		/obj/item/clothing/glasses/thermal/syndi,
		/obj/item/weapon/gun/energy/netgun,
		/obj/item/weapon/gun/projectile/pirate,
		/obj/item/clothing/accessory/permit/gun,
		/obj/item/weapon/gun/projectile/dartgun
		)

	var/global/list/allocated_delta = list()

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
	if(w_type in allocated_delta)
		to_chat(user,"<span class='notice'>You feel \the [W] slip from your hand, and disappear into the trash pile.</span>")
		user.unEquip(W)
		W.forceMove(src)
		allocated_delta -= w_type
		unique_delta += w_type
		qdel(W)

	else
		return ..()

/obj/structure/trash_pile/attack_generic(mob/user)
	//Simple Animal
	if(isanimal(user))
		var/mob/living/L = user
		//They're in it, and want to get out.
		if(L.loc == src)
			var/choice = tgui_alert(usr, "Do you want to exit \the [src]?","Un-Hide?",list("Exit","Stay"))
			if(choice == "Exit")
				if(L == hider)
					hider = null
				L.forceMove(get_turf(src))
		else if(!hider)
			var/choice = tgui_alert(usr, "Do you want to hide in \the [src]?","Un-Hide?",list("Hide","Stay"))
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
				else if(luck <= chance_alpha+chance_beta+chance_gamma+chance_delta)
					I = produce_delta_item()

				//We either have an item to hand over or we don't, at this point!
				if(I)
					searchedby += user.ckey
					I.forceMove(get_turf(src))
					to_chat(H,"<span class='notice'>You found \a [I] among the useless trash!</span>")

	else
		return ..()

//Random lists
/obj/structure/trash_pile/proc/produce_alpha_item()
	var/path = pick(prob(4);/obj/item/weapon/cell,
					prob(3);/obj/item/weapon/cell/high,
					prob(2);/obj/item/weapon/cell/super,
					prob(1);/obj/item/weapon/cell/hyper,
					prob(3);/obj/item/clothing/head/welding,
					prob(1);/obj/item/clothing/glasses/welding,
					prob(2);/obj/item/clothing/shoes/galoshes,
					prob(1);/obj/item/clothing/shoes/syndigaloshes,
					prob(2);/obj/item/clothing/under/syndicate/tacticool,
					prob(1);/obj/item/clothing/gloves/yellow,
					prob(1);/obj/item/weapon/storage/backpack/dufflebag/syndie,
					prob(1);/obj/item/weapon/storage/box/survival/space,
					prob(4);/obj/item/device/pda,
					prob(4);/obj/item/device/radio/headset,
					prob(2);/obj/item/device/paicard,
					prob(3);/obj/item/weapon/storage/box/sinpockets,
					prob(2);/obj/item/weapon/storage/pill_bottle/paracetamol,
					prob(1);/obj/item/pizzavoucher,
					prob(2);/obj/item/device/nif/bad,
					prob(2);/obj/item/weapon/card/emag_broken)

	var/obj/item/I = new path()
	return I

/obj/structure/trash_pile/proc/produce_beta_item()
	var/path = pick(prob(2);/obj/item/clothing/under/fluff/latexmaid,
					prob(2);/obj/item/clothing/under/hyperfiber,
					prob(4);/obj/item/weapon/gun/energy/sizegun,
					prob(2);/obj/item/clothing/under/hyperfiber/bluespace,
					prob(1);/obj/item/weapon/implanter/sizecontrol,
					prob(2);/obj/item/weapon/handcuffs/fuzzy,
					prob(2);/obj/item/weapon/handcuffs/legcuffs/fuzzy,
					prob(1);/obj/item/weapon/reagent_containers/glass/beaker/vial/amorphorovir,
					prob(2);/obj/item/device/sleevemate,
					prob(1);/obj/item/device/bodysnatcher,
					prob(1);/obj/item/capture_crystal,
					prob(1);/obj/item/device/survivalcapsule/popcabin)

	var/obj/item/I = new path()
	return I

/obj/structure/trash_pile/proc/produce_gamma_item()
	var/path = pick(prob(4);/obj/item/weapon/material/butterfly,
					prob(4);/obj/item/weapon/material/butterfly/switchblade,
					prob(4);/obj/item/clothing/gloves/knuckledusters,
					prob(2);/obj/item/weapon/material/knife/tacknife,
					prob(3);/obj/item/clothing/suit/armor/material/makeshift,
					prob(2);/obj/item/clothing/suit/storage/vest/heavy/merc,
					prob(4);/obj/item/seeds/ambrosiavulgarisseed,
					prob(4);/obj/item/weapon/storage/pill_bottle/happy,
					prob(4);/obj/item/weapon/storage/pill_bottle/zoom,
					prob(3);/obj/item/weapon/reagent_containers/syringe/drugs,
					prob(2);/obj/item/weapon/reagent_containers/syringe/steroid,
					prob(3);/obj/item/weapon/storage/box/syndie_kit/spy,
					prob(3);/obj/item/weapon/grenade/anti_photon,
					prob(2);/obj/item/device/radio_jammer,
					prob(1);/obj/item/clothing/mask/gas/voice,
					prob(1);/obj/item/weapon/card/emag,
					prob(3);/obj/item/weapon/handcuffs,
					prob(3);/obj/item/weapon/handcuffs/legcuffs,
					prob(1);/obj/item/weapon/storage/secure/briefcase/trashmoney)

	var/obj/item/I = new path()
	return I

/obj/structure/trash_pile/proc/produce_delta_item()
	var/path = pick_n_take(unique_delta)
	if(!path) //Tapped out, reallocate?
		for(var/P in allocated_delta)
			var/obj/item/I = allocated_delta[P]
			if(QDELETED(I) || istype(I.loc,/obj/machinery/computer/cryopod))
				allocated_delta -= P
				path = P
				break

	if(path)
		var/obj/item/I = new path()
		allocated_delta[path] = I
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
	spawn_delay = 1 HOUR

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
