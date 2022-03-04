/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = 100
	var/delete_me = 0

/obj/effect/landmark/Initialize()
	. = ..()
	tag = text("landmark*[]", name)
	invisibility = 101
	switch(name)			//some of these are probably obsolete
		if("monkey")
			monkeystart += loc
			delete_me = 1
		if("start")
			newplayer_start += loc
			delete_me = 1
		if("JoinLate") // Bit difference, since we need the spawn point to move.
			latejoin += src
			simulated = 1
		if("JoinLateGateway")
			latejoin_gateway += loc
			latejoin += src				//VOREStation Addition
			delete_me = 1
		if("JoinLateElevator")
			latejoin_elevator += loc
			delete_me = 1
		if("JoinLateCheckpoint")
			latejoin_checkpoint += loc
			delete_me = 1
		if("JoinLateCryo")
			latejoin_cryo += loc
			delete_me = 1
		if("JoinLateCyborg")
			latejoin_cyborg += loc
			delete_me = 1
		if("prisonwarp")
			prisonwarp += loc
			delete_me = 1
		if("Holding Facility")
			holdingfacility += loc
		if("tdome1")
			tdome1 += loc
		if("tdome2")
			tdome2 += loc
		if("tdomeadmin")
			tdomeadmin += loc
		if("tdomeobserve")
			tdomeobserve += loc
		if("prisonsecuritywarp")
			prisonsecuritywarp += loc
			delete_me = 1
		if("blobstart")
			blobstart += loc
			delete_me = 1
		if("xeno_spawn")
			xeno_spawn += loc
			delete_me = 1
		if("endgame_exit")
			endgame_safespawns += loc
			delete_me = 1
		if("bluespacerift")
			endgame_exits += loc
			delete_me = 1
		//VOREStation Add Start
		if("vinestart")
			vinestart += loc
			delete_me = 1
			return
		//VORE Station Add End

	if(delete_me)
		return INITIALIZE_HINT_QDEL

		//VOREStation Add Start
		if("vinestart")
			vinestart += loc
			delete_me = 1
			return
		//VORE Station Add End

	landmarks_list += src

/obj/effect/landmark/proc/delete()
	delete_me = 1

/obj/effect/landmark/Destroy(var/force = FALSE)
	if(delete_me || force)
		landmarks_list -= src
		return ..()
	return QDEL_HINT_LETMELIVE

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = TRUE

/obj/effect/landmark/start/Initialize()
	. = ..()
	tag = "start*[name]"
	invisibility = 101

	return 1

/obj/effect/landmark/forbidden_level
	delete_me = 1
/obj/effect/landmark/forbidden_level/Initialize()
	. = ..()
	if(using_map)
		using_map.secret_levels |= z
	else
		log_error("[type] mapped in but no using_map")

/obj/effect/landmark/hidden_level
	delete_me = 1
/obj/effect/landmark/hidden_level/Initialize()
	. = ..()
	if(using_map)
		using_map.hidden_levels |= z
	else
		log_error("[type] mapped in but no using_map")


/obj/effect/landmark/virtual_reality
	name = "virtual_reality"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = TRUE

/obj/effect/landmark/virtual_reality/Initialize()
	. = ..()
	tag = "virtual_reality*[name]"
	invisibility = 101


//Costume spawner landmarks
/obj/effect/landmark/costume/Initialize() //costume spawner, selects a random subclass and disappears
	..()
	if(type == /obj/effect/landmark/costume)
		var/list/options = subtypesof(/obj/effect/landmark/costume)
		var/PICK = options[rand(1,options.len)]
		new PICK(src.loc)
	return INITIALIZE_HINT_QDEL

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/Initialize()
	..()
	new /obj/item/clothing/suit/chickensuit(src.loc)
	new /obj/item/clothing/head/chicken(src.loc)
	new /obj/item/weapon/reagent_containers/food/snacks/egg(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/gladiator/Initialize()
	..()
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/madscientist/Initialize()
	..()
	new /obj/item/clothing/under/suit_jacket/green(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/gglasses(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/elpresidente/Initialize()
	..()
	new /obj/item/clothing/under/suit_jacket/green(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/boots/jackboots(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/nyangirl/Initialize()
	..()
	new /obj/item/clothing/under/schoolgirl(src.loc)
	new /obj/item/clothing/head/kitty(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/maid/Initialize()
	..()
	new /obj/item/clothing/under/skirt(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/butler/Initialize()
	..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/scratch/Initialize()
	..()
	new /obj/item/clothing/gloves/white(src.loc)
	new /obj/item/clothing/shoes/white(src.loc)
	new /obj/item/clothing/under/scratch(src.loc)
	if (prob(30))
		new /obj/item/clothing/head/cueball(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/highlander/Initialize()
	..()
	new /obj/item/clothing/under/kilt(src.loc)
	new /obj/item/clothing/head/beret(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/prig/Initialize()
	..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/weapon/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/plaguedoctor/Initialize()
	..()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/nightowl/Initialize()
	..()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/waiter/Initialize()
	..()
	new /obj/item/clothing/under/waiter(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(src.loc)
	new /obj/item/clothing/suit/storage/apron(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/pirate/Initialize()
	..()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/commie/Initialize()
	..()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/imperium_monk/Initialize()
	..()
	new /obj/item/clothing/suit/imperium_monk(src.loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/holiday_priest/Initialize()
	..()
	new /obj/item/clothing/suit/holidaypriest(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/marisawizard/fake/Initialize()
	..()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/cutewitch/Initialize()
	..()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/weapon/staff/broom(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/fakewizard/Initialize()
	..()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/weapon/staff/(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/sexyclown/Initialize()
	..()
	new /obj/item/clothing/mask/gas/sexyclown(src.loc)
	new /obj/item/clothing/under/sexyclown(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/sexymime/Initialize()
	..()
	new /obj/item/clothing/mask/gas/sexymime(src.loc)
	new /obj/item/clothing/under/sexymime(src.loc)
	return INITIALIZE_HINT_QDEL
