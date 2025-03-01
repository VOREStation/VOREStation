/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = 100
	var/delete_me = 0

/obj/effect/landmark/Initialize(mapload)
	. = ..()
	tag = text("landmark*[]", name)
	invisibility = 101

	switch(name)			//some of these are probably obsolete
		if("monkey")
			monkeystart += loc
			delete_me = TRUE
		if("start")
			newplayer_start += loc
			delete_me = TRUE
		if("JoinLate") // Bit difference, since we need the spawn point to move.
			latejoin += src
			simulated = TRUE
		//	delete_me = TRUE
		if("JoinLateGateway")
			latejoin_gateway += loc
			latejoin += src				//VOREStation Addition
			// delete_me = TRUE
		if("JoinLateElevator")
			latejoin_elevator += loc
			delete_me = TRUE
		if("JoinLateCryo")
			latejoin_cryo += loc
			delete_me = TRUE
		if("JoinLateCyborg")
			latejoin_cyborg += loc
			delete_me = TRUE
		if("prisonwarp")
			prisonwarp += loc
			delete_me = TRUE
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
			delete_me = TRUE
		if("blobstart")
			blobstart += loc
			delete_me = TRUE
		if("xeno_spawn")
			xeno_spawn += loc
			delete_me = TRUE
		if("endgame_exit")
			endgame_safespawns += loc
			delete_me = TRUE
		if("bluespacerift")
			endgame_exits += loc
			delete_me = TRUE
		//VOREStation Add Start
		if("vinestart")
			vinestart += loc
			delete_me = TRUE
		//VORE Station Add End

	landmarks_list += src

	if(delete_me)
		return INITIALIZE_HINT_QDEL

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

/obj/effect/landmark/start/Initialize(mapload)
	. = ..()
	tag = "start*[name]"

	return 1

/obj/effect/landmark/forbidden_level
	delete_me = TRUE

/obj/effect/landmark/forbidden_level/Initialize(mapload)
	. = ..()
	if(using_map)
		using_map.secret_levels |= z
	else
		log_error("[type] mapped in but no using_map")

/obj/effect/landmark/hidden_level
	delete_me = TRUE

/obj/effect/landmark/hidden_level/Initialize(mapload)
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

/obj/effect/landmark/virtual_reality/Initialize(mapload)
	. = ..()
	tag = "virtual_reality*[name]"

/obj/effect/landmark/costume
	delete_me = TRUE

//Costume spawner landmarks
/obj/effect/landmark/costume/Initialize(mapload) //costume spawner, selects a random subclass and disappears
	. = ..()
	if(type == /obj/effect/landmark/costume)
		var/list/options = subtypesof(/obj/effect/landmark/costume)
		var/PICK= options[rand(1,options.len)]
		new PICK(src.loc)

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/chickensuit(src.loc)
	new /obj/item/clothing/head/chicken(src.loc)
	new /obj/item/reagent_containers/food/snacks/egg(src.loc)

/obj/effect/landmark/costume/gladiator/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)

/obj/effect/landmark/costume/madscientist/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/suit_jacket/green(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/gglasses(src.loc)

/obj/effect/landmark/costume/elpresidente/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/suit_jacket/green(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/boots/jackboots(src.loc)

/obj/effect/landmark/costume/nyangirl/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/schoolgirl(src.loc)
	new /obj/item/clothing/head/kitty(src.loc)

/obj/effect/landmark/costume/maid/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/skirt(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)

/obj/effect/landmark/costume/butler/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)

/obj/effect/landmark/costume/scratch/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/gloves/white(src.loc)
	new /obj/item/clothing/shoes/white(src.loc)
	new /obj/item/clothing/under/scratch(src.loc)
	if (prob(30))
		new /obj/item/clothing/head/cueball(src.loc)

/obj/effect/landmark/costume/highlander/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/kilt(src.loc)
	new /obj/item/clothing/head/beret(src.loc)

/obj/effect/landmark/costume/prig/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)

/obj/effect/landmark/costume/plaguedoctor/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)

/obj/effect/landmark/costume/nightowl/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)

/obj/effect/landmark/costume/waiter/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/waiter(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(src.loc)
	new /obj/item/clothing/suit/storage/apron(src.loc)

/obj/effect/landmark/costume/pirate/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)

/obj/effect/landmark/costume/commie/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)

/obj/effect/landmark/costume/imperium_monk/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/imperium_monk(src.loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(src.loc)

/obj/effect/landmark/costume/holiday_priest/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/holidaypriest(src.loc)

/obj/effect/landmark/costume/marisawizard/fake/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)

/obj/effect/landmark/costume/cutewitch/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/staff/broom(src.loc)

/obj/effect/landmark/costume/fakewizard/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)

/obj/effect/landmark/costume/sexyclown/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/mask/gas/sexyclown(src.loc)
	new /obj/item/clothing/under/sexyclown(src.loc)

/obj/effect/landmark/costume/sexymime/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/mask/gas/sexymime(src.loc)
	new /obj/item/clothing/under/sexymime(src.loc)
