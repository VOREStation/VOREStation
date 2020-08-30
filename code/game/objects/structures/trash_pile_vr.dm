/obj/structure/trash_pile
	name = "trash pile"
	desc = "A heap of garbage, but maybe there's something interesting inside?"
	icon = 'icons/obj/trash_piles.dmi'
	icon_state = "randompile"
	density = 1
	anchored = 1.0

	var/list/searchedby	= list()// Characters that have searched this trashpile, with values of searched time.
	var/mob/living/hider		// A simple animal that might be hiding in the pile

	var/obj/structure/mob_spawner/mouse_nest/mouse_nest = null

	var/chance_alpha	= 79	// Alpha list is junk items and normal random stuff.
	var/chance_beta		= 20	// Beta list is actually maybe some useful illegal items. If it's not alpha or gamma, it's beta.
	var/chance_gamma	= 1		// Gamma list is unique items only, and will only spawn one of each. This is a sub-chance of beta chance.

	//These are types that can only spawn once, and then will be removed from this list.
	//Alpha and beta lists are in their respective procs.
	var/global/list/unique_gamma = list(
		/obj/item/device/perfect_tele,
		/obj/item/weapon/bluespace_harpoon,
		/obj/item/clothing/glasses/thermal/syndi,
		/obj/item/weapon/gun/energy/netgun,
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
			var/choice = alert("Do you want to exit \the [src]?","Un-Hide?","Exit","Stay")
			if(choice == "Exit")
				if(L == hider)
					hider = null
				L.forceMove(get_turf(src))
		else if(!hider)
			var/choice = alert("Do you want to hide in \the [src]?","Un-Hide?","Hide","Stay")
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
	var/path = pick(/obj/item/clothing/gloves/rainbow,
					/obj/item/clothing/gloves/white,
					/obj/item/weapon/storage/backpack,
					/obj/item/weapon/storage/backpack/satchel/norm,
					/obj/item/weapon/storage/box,
					prob(80);/obj/item/broken_device/random,
					prob(80);/obj/item/clothing/head/hardhat,
					prob(80);/obj/item/clothing/mask/breath,
					prob(80);/obj/item/clothing/shoes/black,
					prob(80);/obj/item/clothing/shoes/black,
					prob(80);/obj/item/clothing/shoes/laceup,
					prob(80);/obj/item/clothing/shoes/laceup/brown,
					prob(80);/obj/item/clothing/suit/storage/hazardvest,
					prob(80);/obj/item/clothing/under/color/grey,
					prob(80);/obj/item/clothing/suit/caution,
					prob(80);/obj/item/weapon/cell,
					prob(80);/obj/item/weapon/cell/device,
					prob(80);/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
					prob(80);/obj/item/weapon/spacecash/c1,
					prob(80);/obj/item/weapon/storage/backpack/satchel,
					prob(80);/obj/item/weapon/storage/briefcase,
					prob(60);/obj/item/clothing/accessory/storage/webbing,
					prob(60);/obj/item/clothing/glasses/meson,
					prob(60);/obj/item/clothing/gloves/botanic_leather,
					prob(60);/obj/item/clothing/head/hardhat/red,
					prob(60);/obj/item/clothing/mask/gas,
					prob(60);/obj/item/clothing/suit/storage/apron,
					prob(60);/obj/item/clothing/suit/storage/toggle/bomber,
					prob(60);/obj/item/clothing/suit/storage/toggle/brown_jacket,
					prob(60);/obj/item/clothing/suit/storage/toggle/hoodie/black,
					prob(60);/obj/item/clothing/suit/storage/toggle/hoodie/blue,
					prob(60);/obj/item/clothing/suit/storage/toggle/hoodie/red,
					prob(60);/obj/item/clothing/suit/storage/toggle/hoodie/yellow,
					prob(60);/obj/item/clothing/suit/storage/toggle/leather_jacket,
					prob(60);/obj/item/device/pda,
					prob(60);/obj/item/device/radio/headset,
					prob(60);/obj/item/weapon/camera_assembly,
					prob(60);/obj/item/clothing/head/cone,
					prob(60);/obj/item/weapon/cell/high,
					prob(60);/obj/item/weapon/spacecash/c10,
					prob(60);/obj/item/weapon/spacecash/c20,
					prob(60);/obj/item/weapon/storage/backpack/dufflebag,
					prob(60);/obj/item/weapon/storage/box/donkpockets,
					prob(60);/obj/item/weapon/storage/box/mousetraps,
					prob(60);/obj/item/weapon/storage/wallet,
					prob(40);/obj/item/clothing/glasses/meson/prescription,
					prob(40);/obj/item/clothing/gloves/fyellow,
					prob(40);/obj/item/clothing/gloves/sterile/latex,
					prob(40);/obj/item/clothing/head/welding,
					prob(40);/obj/item/clothing/mask/gas/half,
					prob(40);/obj/item/clothing/shoes/galoshes,
					prob(40);/obj/item/clothing/under/pants/camo,
					prob(40);/obj/item/clothing/under/syndicate/tacticool,
					prob(40);/obj/item/device/camera,
					prob(40);/obj/item/device/flashlight/flare,
					prob(40);/obj/item/device/flashlight/glowstick,
					prob(40);/obj/item/device/flashlight/glowstick/blue,
					prob(40);/obj/item/weapon/card/emag_broken,
					prob(40);/obj/item/weapon/cell/super,
					prob(40);/obj/item/weapon/contraband/poster,
					prob(40);/obj/item/weapon/reagent_containers/glass/rag,
					prob(40);/obj/item/weapon/storage/box/sinpockets,
					prob(40);/obj/item/weapon/storage/secure/briefcase,
					prob(40);/obj/item/clothing/under/fluff/latexmaid,
					prob(40);/obj/item/toy/tennis,
					prob(40);/obj/item/toy/tennis/red,
					prob(40);/obj/item/toy/tennis/yellow,
					prob(40);/obj/item/toy/tennis/green,
					prob(40);/obj/item/toy/tennis/cyan,
					prob(40);/obj/item/toy/tennis/blue,
					prob(40);/obj/item/toy/tennis/purple,
					prob(20);/obj/item/clothing/glasses/sunglasses,
					prob(20);/obj/item/clothing/glasses/welding,
					prob(20);/obj/item/clothing/gloves/yellow,
					prob(20);/obj/item/clothing/head/bio_hood/general,
					prob(20);/obj/item/clothing/head/ushanka,
					prob(20);/obj/item/clothing/shoes/syndigaloshes,
					prob(20);/obj/item/clothing/suit/bio_suit/general,
					prob(20);/obj/item/clothing/suit/space/emergency,
					prob(20);/obj/item/clothing/under/harness,
					prob(20);/obj/item/clothing/under/tactical,
					prob(20);/obj/item/clothing/suit/armor/material/makeshift,
					prob(20);/obj/item/device/flashlight/glowstick/orange,
					prob(20);/obj/item/device/flashlight/glowstick/red,
					prob(20);/obj/item/device/flashlight/glowstick/yellow,
					prob(20);/obj/item/device/flashlight/pen,
					prob(20);/obj/item/device/paicard,
					prob(20);/obj/item/clothing/mask/gas/voice,
					prob(20);/obj/item/weapon/spacecash/c100,
					prob(20);/obj/item/weapon/spacecash/c50,
					prob(20);/obj/item/weapon/storage/backpack/dufflebag/syndie,
					prob(20);/obj/item/weapon/storage/box/cups,
					prob(20);/obj/item/pizzavoucher,
					prob(10);/obj/item/weapon/card/emag)

	var/obj/item/I = new path()
	return I

/obj/structure/trash_pile/proc/produce_beta_item()
	var/path = pick(/obj/item/weapon/storage/pill_bottle/paracetamol,
					prob(70);/obj/item/weapon/storage/pill_bottle/happy,
					prob(70);/obj/item/weapon/storage/pill_bottle/zoom,
					prob(70);/obj/item/seeds/ambrosiavulgarisseed,
					prob(70);/obj/item/weapon/gun/energy/sizegun,
					prob(50);/obj/item/weapon/material/butterfly,
					prob(50);/obj/item/weapon/material/butterfly/switchblade,
					prob(50);/obj/item/clothing/gloves/knuckledusters,
					prob(50);/obj/item/weapon/reagent_containers/syringe/drugs,
					prob(34);/obj/item/weapon/implanter/sizecontrol,
					prob(34);/obj/item/weapon/handcuffs/fuzzy,
					prob(34);/obj/item/weapon/handcuffs/legcuffs/fuzzy,
					prob(34);/obj/item/weapon/storage/box/syndie_kit/spy,
					prob(34);/obj/item/weapon/grenade/anti_photon,
					prob(17);/obj/item/clothing/suit/storage/vest/heavy/merc,
					prob(17);/obj/item/device/nif/bad,
					prob(17);/obj/item/device/radio_jammer,
					prob(17);/obj/item/device/sleevemate,
					prob(17);/obj/item/device/bodysnatcher,
					prob(17);/obj/item/weapon/beartrap,
					prob(17);/obj/item/weapon/cell/hyper/empty,
					prob(17);/obj/item/weapon/disk/nifsoft/compliance,
					prob(17);/obj/item/weapon/material/knife/tacknife,
					prob(17);/obj/item/weapon/storage/box/survival/space,
					prob(17);/obj/item/weapon/storage/secure/briefcase/trashmoney,
					prob(17);/obj/item/weapon/reagent_containers/syringe/steroid)

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
