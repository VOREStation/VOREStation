////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	unacidable = 1
	volume = 30
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/gun.ogg'
	pickup_sound = 'sound/items/pickup/gun.ogg'
	preserve_item = 1
	var/filled = 0
	var/list/filled_reagents = list()
	var/hyposound	// What sound do we play on use?

/obj/item/weapon/reagent_containers/hypospray/Initialize()
	. = ..()
	if(filled)
		if(filled_reagents)
			for(var/r in filled_reagents)
				reagents.add_reagent(r, filled_reagents[r])
	update_icon()

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M as mob, mob/user as mob)
	if(!reagents.total_volume)
		to_chat(user, "<span class='warning'>[src] is empty.</span>")
		return
	if (!istype(M))
		return

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
		if(!affected)
			to_chat(user, "<span class='danger'>\The [H] is missing that limb!</span>")
			return
		/* since synths have oil/coolant streams now, it only makes sense that you should be able to inject stuff. preserved for posterity.
		else if(affected.robotic >= ORGAN_ROBOT)
			to_chat(user, "<span class='danger'>You cannot inject a robotic limb.</span>")
			return
		*/

		//VOREStation Add Start - Adds Prototype Hypo functionality
		if(H != user && prototype)
			to_chat(user, "<span class='notice'>You begin injecting [H] with \the [src].</span>")
			to_chat(H, "<span class='danger'> [user] is trying to inject you with \the [src]!</span>")
			if(!do_after(user, 30, H))
				return
		//VOREstation Add End
		else if(!H.stat && !prototype) //VOREStation Edit
			if(H != user)
				if(H.a_intent != I_HELP)
					to_chat(user, "<span class='notice'>[H] is resisting your attempt to inject them with \the [src].</span>")
					to_chat(H, "<span class='danger'> [user] is trying to inject you with \the [src]!</span>")
					if(!do_after(user, 30, H))
						return

	do_injection(H, user)
	return

// This does the actual injection and transfer.
/obj/item/weapon/reagent_containers/hypospray/proc/do_injection(mob/living/carbon/human/H, mob/living/user)
	if(!istype(H) || !istype(user))
		return FALSE

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	to_chat(user, span("notice", "You inject \the [H] with \the [src]."))
	to_chat(H, span("warning", "You feel a tiny prick!"))

	if(hyposound)
		playsound(src, hyposound, 25)

	if(H.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(H, amount_per_transfer_from_this, CHEM_BLOOD)
		add_attack_logs(user,H,"Injected with [src.name] containing [contained], trasferred [trans] units")
		to_chat(user, span("notice", "[trans] units injected. [reagents.total_volume] units remaining in \the [src]."))
		return TRUE
	return FALSE

//A vial-loaded hypospray. Cartridge-based!
/obj/item/weapon/reagent_containers/hypospray/vial
	name = "hypospray mkII"
	desc = "A new development from DeForest Medical, this new hypospray takes 30-unit vials as the drug supply for easy swapping."
	var/obj/item/weapon/reagent_containers/glass/beaker/vial/loaded_vial //Wow, what a name.
	volume = 0

/obj/item/weapon/reagent_containers/hypospray/vial/Initialize()
	. = ..()
	loaded_vial = new /obj/item/weapon/reagent_containers/glass/beaker/vial(src) //Comes with an empty vial
	volume = loaded_vial.volume
	reagents.maximum_volume = loaded_vial.reagents.maximum_volume

/obj/item/weapon/reagent_containers/hypospray/vial/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(loaded_vial)
			reagents.trans_to_holder(loaded_vial.reagents,volume)
			reagents.maximum_volume = 0
			loaded_vial.update_icon()
			user.put_in_hands(loaded_vial)
			loaded_vial = null
			to_chat(user, "<span class='notice'>You remove the vial from the [src].</span>")
			update_icon()
			playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
			return
		..()
	else
		return ..()

/obj/item/weapon/reagent_containers/hypospray/vial/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers/glass/beaker/vial))
		if(!loaded_vial)
			user.visible_message("<span class='notice'>[user] begins loading [W] into \the [src].</span>","<span class='notice'>You start loading [W] into \the [src].</span>")
			if(!do_after(user,30) || loaded_vial || !(W in user))
				return 0
			if(W.is_open_container())
				W.flags ^= OPENCONTAINER
				W.update_icon()
			user.drop_item()
			W.loc = src
			loaded_vial = W
			reagents.maximum_volume = loaded_vial.reagents.maximum_volume
			loaded_vial.reagents.trans_to_holder(reagents,volume)
			user.visible_message("<span class='notice'>[user] has loaded [W] into \the [src].</span>","<span class='notice'>You have loaded [W] into \the [src].</span>")
			update_icon()
			playsound(src, 'sound/weapons/empty.ogg', 50, 1)
		else
			to_chat(user, "<span class='notice'>\The [src] already has a vial.</span>")
	else
		..()

/obj/item/weapon/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "blue"
	item_state = "blue"
	amount_per_transfer_from_this = 5
	volume = 5
	filled = 1
	filled_reagents = list("inaprovaline" = 5)
	preserve_item = 0
	hyposound = 'sound/effects/hypospray.ogg'

/obj/item/weapon/reagent_containers/hypospray/autoinjector/on_reagent_change()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/empty
	filled = 0
	filled_reagents = list()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/used/Initialize()
	. = ..()
	flags &= ~OPENCONTAINER
	icon_state = "[initial(icon_state)]0"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/do_injection(mob/living/carbon/human/H, mob/living/user)
	. = ..()
	if(.) // Will occur if successfully injected.
		flags &= ~OPENCONTAINER
		update_icon()

/obj/item/weapon/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/examine(mob/user)
	. = ..()
	if(reagents && reagents.reagent_list.len)
		. += "<span class='notice'>It is currently loaded.</span>"
	else
		. += "<span class='notice'>It is spent.</span>"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/detox
	name = "autoinjector (antitox)"
	icon_state = "green"
	filled_reagents = list("anti_toxin" = 5)

// These have a 15u capacity, somewhat higher tech level, and generally more useful chems, but are otherwise the same as the regular autoinjectors.
/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector
	name = "empty hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	volume = 15
	origin_tech = list(TECH_BIO = 4)
	filled_reagents = list("inaprovaline" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/brute
	name = "trauma hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to be used on victims of \
	moderate blunt trauma."
	filled_reagents = list("bicaridine" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/burn
	name = "burn hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to be used on burn victims, \
	featuring an optimized chemical mixture to allow for rapid healing."
	filled_reagents = list("kelotane" = 7.5, "dermaline" = 7.5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/toxin
	name = "toxin hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to counteract toxins."
	filled_reagents = list("anti_toxin" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/oxy
	name = "oxy hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one is made to counteract oxygen \
	deprivation."
	filled_reagents = list("dexalinp" = 10, "tricordrazine" = 5)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/purity
	name = "purity hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This variant excels at \
	resolving viruses, infections, radiation, and genetic maladies."
	filled_reagents = list("spaceacillin" = 9, "arithrazine" = 5, "ryetalyn" = 1)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/pain
	name = "pain hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This one contains potent painkillers."
	filled_reagents = list("tramadol" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/organ
	name = "organ hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  Organ damage is resolved by this variant."
	filled_reagents = list("alkysine" = 3, "imidazoline" = 2, "peridaxon" = 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/combat
	name = "combat hypo"
	desc = "A refined version of the standard autoinjector, allowing greater capacity.  This is a more dangerous and potentially \
	addictive hypo compared to others, as it contains a potent cocktail of various chemicals to optimize the recipient's combat \
	ability."
	filled_reagents = list("bicaridine" = 3, "kelotane" = 1.5, "dermaline" = 1.5, "oxycodone" = 3, "hyperzine" = 3, "tricordrazine" = 3)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/clotting
	name = "clotting agent"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. This variant excels at treating bleeding wounds and internal bleeding."
	filled_reagents = list("inaprovaline" = 5, "myelamine" = 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/bonemed
	name = "bone repair injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. This one excels at treating damage to bones."
	filled_reagents = list("inaprovaline" = 5, "osteodaxon" = 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/glucose
	name = "glucose hypo"
	desc = "A hypoinjector filled with glucose, used for critically malnourished patients and voidsuited workers."
	filled_reagents = list("glucose" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/stimm
	name = "stimm injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one is filled with a home-made stimulant, with some serious side-effects."
	filled_reagents = list("stimm" = 10) // More than 10u will OD.

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/expired
	name = "expired injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one has had its contents expire a long time ago, using it now will probably make someone sick, or worse."
	filled_reagents = list("expired_medicine" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/soporific
	name = "soporific injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one is sometimes used by orderlies, as it has soporifics, which make someone tired and fall asleep."
	filled_reagents = list("stoxin" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/cyanide
	name = "cyanide injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one contains cyanide, a lethal poison. It being inside a medical autoinjector has certain unsettling implications."
	filled_reagents = list("cyanide" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/serotrotium
	name = "serotrotium injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one is filled with serotrotium, which causes concentrated production of the serotonin neurotransmitter in humans."
	filled_reagents = list("serotrotium" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/space_drugs
	name = "illicit injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one contains various illicit drugs, held inside a hypospray to make smuggling easier."
	filled_reagents = list("space_drugs" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/cryptobiolin
	name = "cryptobiolin injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one contains cryptobiolin, which causes confusion."
	filled_reagents = list("cryptobiolin" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/impedrezene
	name = "impedrezene injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one has impedrezene inside, a narcotic that impairs higher brain functioning. \
	This autoinjector is almost certainly created illegitimately."
	filled_reagents = list("impedrezene" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/mindbreaker
	name = "mindbreaker injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This one stores the dangerous hallucinogen called 'Mindbreaker', likely put in place \
	by illicit groups hoping to hide their product."
	filled_reagents = list("mindbreaker" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/psilocybin
	name = "psilocybin injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This has psilocybin inside, which is a strong psychotropic derived from certain species of mushroom. \
	This autoinjector likely was made by criminal elements to avoid detection from casual inspection."
	filled_reagents = list("psilocybin" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/mutagen
	name = "unstable mutagen injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This contains unstable mutagen, which makes using this a very bad idea. It will either \
	ruin your genetic health, turn you into a Five Points violation, or both!"
	filled_reagents = list("mutagen" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/lexorin
	name = "lexorin injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	This contains lexorin, a dangerous toxin that stops respiration, and has been \
	implicated in several high-profile assassinations in the past."
	filled_reagents = list("lexorin" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/healing_nanites
	name = "medical nanite injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	The injector stores a slurry of highly advanced and specialized nanomachines designed \
	to restore bodily health from within. The nanomachines are short-lived but degrade \
	harmlessly, and cannot self-replicate in order to remain Five Points compliant."
	filled_reagents = list("healing_nanites" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/defective_nanites
	name = "defective nanite injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	The injector stores a slurry of highly advanced and specialized nanomachines that \
	are unfortunately malfunctioning, making them unsafe to use inside of a living body. \
	Because of the Five Points, these nanites cannot self-replicate."
	filled_reagents = list("defective_nanites" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/contaminated
	name = "contaminated injector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity. \
	The hypospray contains a viral agent inside, as well as a liquid substance that encourages \
	the growth of the virus inside."
	filled_reagents = list("virusfood" = 15)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector/contaminated/do_injection(mob/living/carbon/human/H, mob/living/user)
	. = ..()
	if(.) // Will occur if successfully injected.
		infect_mob_random_lesser(H)
		add_attack_logs(user, H, "Infected \the [H] with \the [src], by \the [user].")
