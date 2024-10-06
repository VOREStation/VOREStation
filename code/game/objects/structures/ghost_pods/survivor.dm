//Based on /manual/human but not created as a child for better control over how we create a mob.
/obj/structure/ghost_pod/manual/survivor
	name = "Emergency Cryopod"
	desc = "A damaged cryopod smeared with blood. An injured body seems frozen in time within."
	description_info = "This contains a body, which may wake at any time. The external controls\
	seem to be functioning, though the warning lights that flash give no solace.."
	ghost_query_type = /datum/ghost_query/shipwreck_survivor
	var/occupant_type = "shipwreck survivor"

	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	icon_state_opened = "sleeper_0"
	density = TRUE

	var/allow_appearance_change = TRUE
	var/special_role = MODE_SURVIVOR //Set this to NULL as GM if you don't want the "survivor" stuff to fire.
	var/list/clothing_possibilities

	var/start_injured = FALSE //failsafe to prevent accidentally making a pod that deals damage when not intended

	var/suffer_brute = FALSE
	var/brute_severity = 20 //We inflict UP TO this much damage. Range is 1 to this value
	var/brute_instances = 3 //We inflict damage this many times. Helps spread it around multiple limbs!


	var/suffer_burn = FALSE
	var/burn_severity = 20
	var/burn_instances = 3

	var/suffer_toxloss = FALSE
	var/tox_severity = 20

	var/suffer_oxloss = FALSE
	var/oxy_severity = 20

	var/suffer_cloneloss = FALSE
	var/clone_severity = 5

/obj/structure/ghost_pod/manual/survivor/Initialize()
	. = ..()

	handle_clothing_setup()

/obj/structure/ghost_pod/manual/survivor/trigger()
	. = ..()
	desc += "\n The Pod's stasis is broken!"
	visible_message(message = span_warning("\The [src] hisses and blinks in a myriad of lights as its stasis ceases! \n \
	What or whoever lays beneath may yet stir once more, but their wounds may be too grevious... "),
	blind_message = span_warning("You hear hissing from [src]!"),
	runemessage = "HISS")


/obj/structure/ghost_pod/manual/survivor/proc/handle_clothing_setup()
	clothing_possibilities = list()

	clothing_possibilities |= subtypesof(/obj/item/clothing/under/utility)
	clothing_possibilities |= subtypesof(/obj/item/clothing/head/beret)
	clothing_possibilities |= /obj/item/clothing/shoes/black
	clothing_possibilities |= /obj/item/radio/headset

/obj/structure/ghost_pod/manual/survivor/create_occupant(var/mob/M)
	..()
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/H = new(src)
	if(M.mind)
		M.mind.transfer_to(H)
	to_chat(M, span_notice("You are a [occupant_type]!"))
	H.ckey = M.ckey
	visible_message(span_warning("As \the [src] opens, the pipes on \the [src] surge, before it grows dark."))
	log_and_message_admins("successfully opened \a [src] and got a [occupant_type].")

	var/list/uniform_options
	var/list/shoe_options
	var/list/head_options
	var/list/headset_options

	if(clothing_possibilities && clothing_possibilities.len)
		for(var/path in clothing_possibilities)
			if(ispath(path, /obj/item/clothing/under))
				if(!uniform_options)
					uniform_options = list()
				uniform_options |= path
			if(ispath(path, /obj/item/clothing/shoes))
				if(!shoe_options)
					shoe_options = list()
				shoe_options |= path
			if(ispath(path, /obj/item/clothing/head))
				if(!head_options)
					head_options = list()
				head_options |= path
			if(ispath(path, /obj/item/radio/headset))
				if(!headset_options)
					headset_options = list()
				headset_options |= path

	if(uniform_options && uniform_options.len)
		var/newpath = pick(uniform_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(shoe_options && shoe_options.len)
		var/newpath = pick(shoe_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(head_options && head_options.len)
		var/newpath = pick(head_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(headset_options && headset_options.len)
		var/newpath = pick(headset_options)
		var/obj/item/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	var/newname = sanitize(tgui_input_text(H, "Your mind feels foggy, and you recall your name might be [H.real_name]. Would you like to change your name?", "Name change", null, MAX_NAME_LEN), MAX_NAME_LEN)
	if (newname)
		H.real_name = newname

	icon_state = icon_state_opened

	H.forceMove(T)

	if(special_role)
		var/datum/antagonist/role = all_antag_types[special_role] //Explicitly NOT an antagonist.
		if(role)
			if(role.add_antagonist(H.mind, 1, 1, 0, 1, 1))
				log_admin("\The [src] made [key_name(src)] into a [role.role_text].")

	if(start_injured) //Doublechecking if we actually want them to be injured
		if(suffer_brute)
			for(var/br = 1, br < brute_instances, br++)
				H.adjustBruteLoss(rand(1,brute_severity))
		if(suffer_burn)
			for(var/bu = 1, bu < burn_instances, bu++)
				H.adjustFireLoss(rand(1,burn_severity))
		if(suffer_oxloss)
			H.adjustOxyLoss(rand(1,oxy_severity))
		if(suffer_toxloss)
			H.adjustToxLoss(rand(1,tox_severity))
		if(suffer_cloneloss)
			H.adjustCloneLoss(rand(1,clone_severity))

	if(allow_appearance_change)
		H.change_appearance(APPEARANCE_ALL, H, check_species_whitelist = 1)

	visible_message(span_alien("\The [src] [pick("gurgles", "seizes", "clangs")] before releasing \the [H]!"))
