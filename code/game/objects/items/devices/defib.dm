//The case the paddles are kept in.
/obj/item/device/defib_kit
	name = "defibrillator kit"
	desc = "This KHI-branded defib kit is a semi-automated model. Remove pads, slap on chest, wait."
	icon = 'icons/obj/device.dmi'
	icon_state = "defib_kit"
	w_class = ITEMSIZE_LARGE

	var/state	 								//0 off, 1 open, 2 working, 3 dead
	var/uses = 2								//Calculates initial uses based on starting cell size
	var/use_on_synthetic = 0					//If 1, this is only useful on FBPs, if 0, this is only useful on fleshies
	var/pad_name = "defib pads"				//Just the name given for some cosmetic things
	var/chance = 75								//Percent chance of working
	var/charge_cost								//Set in New() based on uses
	var/obj/item/weapon/cell/cell				//The size is mostly irrelevant, see 'uses'
	var/mob/living/carbon/human/patient			//The person the paddles are on

/obj/item/device/defib_kit/New()
	..()
	//Create cell and determine uses (futureproofing against cell size changes)
	cell = new(src)
	charge_cost = cell.maxcharge / uses
	statechange(0)

/obj/item/device/defib_kit/attack_self(mob/user as mob)
	..()
	if(patient)
		patient = null
		user.visible_message("<span class='notice'>[user] returns the pads to \the [src] and closes it.</span>",
		"<span class='notice'>You return the pads to \the [src] and close it.</span>")
		statechange(0)

/obj/item/device/defib_kit/MouseDrop(var/mob/living/carbon/human/onto)
	if(istype(onto) && Adjacent(usr) && !usr.restrained() && !usr.stat)
		var/mob/living/carbon/human/user = usr
		//<--Feel free to code clothing checks right here
		if(can_defib(onto))
			user.visible_message("<span class='warning'>[user] begins applying [pad_name] to [onto].</span>",
			"<span class='warning'>You begin applying [pad_name] to [onto].</span>")
		if(do_after(user, 100, onto))
			patient = onto
			statechange(1,patient)
			user.visible_message("<span class='warning'>[user] applies [pad_name] to [onto].</span>",
			"<span class='warning'>You finish applying [pad_name] to [onto].</span>")


//can_defib() check is where all of the qualifying conditions should go
//Could probably toss in checks here for damage, organs, etc, but for now I'll leave it as just this
/obj/item/device/defib_kit/proc/can_defib(var/mob/living/carbon/human/target)
	var/mob/living/carbon/human/user = usr
	if(use_on_synthetic && !target.isSynthetic())
		to_chat(user, "[src] isn't designed for organics!")
		return 0
	else if(!use_on_synthetic && target.isSynthetic())
		to_chat(user, "[src] isn't designed for synthetics!")
		return 0
	else if(!target.isSynthetic() && ((world.time - target.timeofdeath) > (10 MINUTES)))//Can only revive organics within a few minutes
		to_chat(user, "There is no spark of life in [target.name], they've been dead too long to revive this way.")
		return 0
	return 1


/obj/item/device/defib_kit/attackby(var/obj/item/A as obj, mob/living/user as mob)
	..()

	if(!cell && istype(A,/obj/item/weapon/cell))
		if(!user.unEquip(A)) return
		to_chat(user,"You jack \the [A] into \the [src]'s battery mount.")
		A.forceMove(src)
		src.cell = A

	else if(istype(A,/obj/item/weapon/screwdriver))
		if(cell)
			to_chat(user,"<span class='notice'>You remove \the [cell] from \the [src].</span>")
			if(user.r_hand && user.l_hand)
				cell.forceMove(get_turf(user))
			else
				cell.forceMove(user.put_in_hands(cell))
			cell = null
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		else
			to_chat(user,"<span class='warning'>The power source has already been removed!</span>")

/obj/item/device/defib_kit/proc/statechange(var/new_state, var/pat)
	if(state == new_state) return //Let's just save ourselves some time
	state = new_state
	icon_state = "[initial(icon_state)][state]"
	var/turf/T = get_turf(src)
	var/state_words = ""
	switch(state)
		if(0)
			state_words = "It is currently closed."
			processing_objects -= src
		if(1)
			state_words = "A green light is lit; it has charge."
			processing_objects |= src
		if(2)
			state_words = "A yellow light is flashing: it's in the process of reviving a patient."
			T.visible_message("<span class='notice'>A yellow light starts flashing on \the [src].</span>")
			playsound(T, 'sound/machines/chime.ogg', 50, 0)
		if(3)
			state_words = "A red light is flashing: the battery needs to be recharged."
			T.visible_message("<span class='warning'>A red light starts flashing on \the [src].</span>")
			playsound(T, 'sound/machines/buzz-sigh.ogg', 50, 0)

	desc = "[initial(desc)] [state_words][pat ? " The pads are attached to [pat]." : ""]"
	update_icon()

/obj/item/device/defib_kit/process()
	if(!state) //0 or null
		statechange(0)
		processing_objects -= src
		return

	//Patient moved too far
	if(patient && !(get_dist(src,patient) <= 1)) //You separated the kit and pads too far
		audible_message("<span class='warning'>There is a clatter as the [pad_name] are yanked off of [patient].</span>")
		statechange(0)
		patient = null
		return

	//Battery died
	if(!cell || cell.charge < charge_cost)
		statechange(3,patient)
		return

	//A patient isn't being worked on, but we have one, so start
	if(patient && patient.stat == DEAD && state != 2)
		statechange(2)
		if(attempt_shock()) //Try to shock them, has timer and such
			patient.visible_message("<span class='warning'>[patient] convulses!</span>")
			playsound(src.loc, 'sound/effects/sparks2.ogg', 75, 1)
			//Actual rezzing code
			if(prob(chance))
				if(!patient.client && patient.mind) //Don't force the dead person to come back if they don't want to.
					for(var/mob/observer/dead/ghost in player_list)
						if(ghost.mind == patient.mind)
							to_chat(ghost, "<b><font color = #330033><font size = 3>Someone is trying to \
							revive you. Return to your body if you want to be revived!</b> \
							(Verbs -> Ghost -> Re-enter corpse). You have 15 seconds to do this!</font></font>")
							sleep(15 SECONDS)
							break

				if(patient.client)
					patient.adjustOxyLoss(-20) //Look, blood stays oxygenated for quite some time, but I'm not recoding the entire oxy system
					patient.stat = CONSCIOUS //Note that if whatever killed them in the first place wasn't fixed, they're likely to die again.
					dead_mob_list -= patient
					living_mob_list += patient
					patient.timeofdeath = null
					patient.visible_message("<span class='notice'>[patient]'s eyes open!</span>")
					log_and_message_admins("[patient] was revived.")
			cell.charge -= charge_cost //Always charge the cost after any attempt, failed or not
		sleep(20) //Wait 2 seconds before next attempt
		statechange(1,patient) //Back to ready

/obj/item/device/defib_kit/proc/attempt_shock()
	if(!patient || cell.charge < charge_cost)
		return

	var/zap_time = world.time + (7 SECONDS)
	var/o_patient_loc = patient.loc
	. = 1

	while(world.time < zap_time) //This is basically a custom do_after() call
		sleep(1)

		//Failed: We lost something important
		if(!patient || !cell || cell.charge < charge_cost)
			. = 0
			break

		//Failed: The locations aren't right
		if((o_patient_loc != patient.loc) || !(get_dist(src,patient) <= 1))
			. = 0
			break

	return

/obj/item/device/defib_kit/jumper_kit
	name = "jumper cable kit"
	desc = "This Morpheus-branded FBP defib kit is a semi-automated model. Apply cables, step back, wait."
	icon_state = "jumper_kit"
	use_on_synthetic = 1
	pad_name = "jumper cables"
