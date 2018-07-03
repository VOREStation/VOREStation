/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner
	name = "Emergency trauma injector"
	desc = "A rapid injector for emergency treatment of injuries. The warning label advises that it is not a substitute for proper medical treatment."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 10
	volume = 10

/obj/item/weapon/reagent_containers/hypospray/autoinjector/miner/New()
	..()
	reagents.add_reagent("bicaridine", 5)
	reagents.add_reagent("tricordrazine", 3)
	reagents.add_reagent("tramadol", 2)
	update_icon()

/obj/item/weapon/storage/box/traumainjectors
	name = "box of emergency trauma injectors"
	desc = "Contains emergency trauma autoinjectors."
	icon_state = "syringe"

/obj/item/weapon/storage/box/traumainjectors/New()
	..()
	for (var/i = 1 to 7)
		new /obj/item/weapon/reagent_containers/hypospray/autoinjector/miner(src)

/obj/item/weapon/reagent_containers/hypospray/science
	name = "prototype hypospray"
	desc = "This reproduction hypospray is nearly a perfect replica of the early model DeForest hyposprays, sharing many of the same features. However, there are additional safety measures installed to prevent unwanted injections."

/obj/item/weapon/reagent_containers/hypospray/science/attack(mob/living/M as mob, mob/user as mob)
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
		else if(affected.robotic >= ORGAN_ROBOT)
			to_chat(user, "<span class='danger'>You cannot inject a robotic limb.</span>")
			return

		if(H != user)
			to_chat(user, "<span class='notice'>You begin injecting [H] with \the [src].</span>")
			to_chat(H, "<span class='danger'> [user] is trying to inject you with \the [src]!</span>")
			if(!do_after(user, 30))
				return

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	to_chat(user, "<span class='notice'>You inject [M] with \the [src].</span>")
	to_chat(M, "<span class='notice'>You feel a tiny prick!</span>")
	
	playsound(src, 'sound/effects/hypospray.ogg',25)

	if(M.reagents)
		var/contained = reagentlist()
		var/trans = reagents.trans_to_mob(M, amount_per_transfer_from_this, CHEM_BLOOD)
		add_attack_logs(user,M,"Injected with [src.name] containing [contained], trasferred [trans] units")
		to_chat(user, "<span class='notice'>[trans] units injected. [reagents.total_volume] units remaining in \the [src].</span>")

	return
