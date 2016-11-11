//The case the paddles are kept in.
/obj/item/device/defib_kit
	name = "defibrilator kit"
	desc = "This KHI-branded defib kit is a semi-automated model. Remove pads, slap on chest, wait."
	icon = 'icons/obj/device.dmi'
	icon_state = "defib_kit"
	w_class = ITEMSIZE_LARGE

	var/state	 								//0 off, 1 open, 2 working, 3 dead
	var/uses = 3								//Calculates initial uses based on starting cell size
	var/charge_cost								//Set in New() based on uses
	var/obj/item/weapon/cell/cell				//The size is mostly irrelevant, see 'uses'
	var/obj/item/clothing/under/defib_paddles/paddles	//Reference to connected paddles
	var/mob/living/carbon/human/patient			//The person the paddles are on

/obj/item/device/defib_kit/New()
	..()
	//Create cell and determine uses (futureproofing against cell size changes)
	cell = new(src)
	charge_cost = cell.maxcharge / uses

	//Create paddles and associate them with the kit
	paddles = new(src)
	paddles.kit = src

	statechange(0)

/obj/item/device/defib_kit/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		get_paddles(user)
	else
		return ..()

/obj/item/device/defib_kit/MouseDrop(var/mob/living/carbon/human/onto)
	if(istype(onto) && usr == onto && Adjacent(usr) && !usr.restrained() && !usr.stat)
		get_paddles(onto)
	else
		return ..()

/obj/item/device/defib_kit/attackby(var/obj/item/A as obj, mob/living/user as mob)
	..()

	if(istype(A,/obj/item/clothing/under/defib_paddles))
		put_paddles(A, user)

	else if(!cell && istype(A,/obj/item/weapon/cell))
		if(!user.unEquip(A)) return
		user << "You jack \the [A] into \the [src]'s battery mount."
		A.forceMove(src)
		src.cell = A

	else if(istype(A,/obj/item/weapon/screwdriver))
		if(cell)
			user << "<span class='notice'>You remove \the [cell] from \the [src].</span>"
			if(user.r_hand && user.l_hand)
				cell.forceMove(get_turf(user))
			else
				cell.forceMove(user.put_in_hands(cell))
			cell = null
		else
			user << "<span class='warning'>The power source has already been removed!</span>"


/obj/item/device/defib_kit/proc/get_paddles(mob/user)
	if(paddles && state == 0)
		if(paddles.grabbed(src, user))
			statechange(1)
			processing_objects |= src
			playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	else if(paddles && state > 0)
		user << "<span class='warning'>The paddles have already been removed and are on/in [paddles.loc].</span>"
	else if(!paddles)
		user << "<span class='warning'>The paddles are missing!</span>"

/obj/item/device/defib_kit/proc/put_paddles(var/obj/item/clothing/under/defib_paddles/P, mob/user)
	if(state == 0) //Weird case, shouldn't happen unless you're being weird with more than one defib kit.
		user << "<span class='notice'>This defib kit doesn't need more paddles!</span>"
		return

	if(state > 0 && !paddles) //Reconnecting paddles
		if(P.reconnected(src, user))
			playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)

	else if(P == paddles)//Returning paddles
		if(P.replaced(src, user))
			playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
			statechange(0)

/obj/item/device/defib_kit/proc/statechange(var/new_state)
	if(state == new_state) return //Let's just save ourselves some time
	state = new_state
	icon_state = "[initial(icon_state)][state]"
	var/turf/T = get_turf(src)
	var/state_words = ""
	switch(state)
		if(0)
			state_words = "It is currently closed."
		if(1)
			state_words = "A green light is lit; it has charge."
		if(2)
			state_words = "A yellow light is flashing: it's in the process of reviving a patient."
			T.visible_message("<span class='notice'>A yellow light starts flashing on \the [src].</span>")
			playsound(T, 'sound/machines/chime.ogg', 50, 0)
		if(3)
			state_words = "A red light is flashing: the battery needs to be recharged."
			T.visible_message("<span class='warning'>A red light starts flashing on \the [src].</span>")
			playsound(T, 'sound/machines/buzz-sigh.ogg', 50, 0)

	desc = "[initial(desc)] [state_words]"
	update_icon()

/obj/item/device/defib_kit/process()
	if(!state) //0 or null
		statechange(0)
		processing_objects -= src
		return

	//Battery died
	if(!cell || cell.charge < charge_cost)
		statechange(3)
		return

	//Everything below here requires paddles
	if(!paddles) return

	//Paddles moved too far
	if(!(get_dist(src,paddles) <= 1)) //You separated the kit and pads too far
		audible_message("<span class='warning'>There's a clatter as \the [paddles] connector cables are yanked out of \the [src].</span>")
		paddles.kit = null
		paddles = null
		patient = null
		return

	//A patient isn't being worked on, but we have one, so start
	if(patient && patient.stat == DEAD && state != 2)
		statechange(2)
		if(attempt_shock()) //Try to shock them, has timer and such
			patient.visible_message("<span class='warning'>[patient] convulses!</span>")
			playsound(src.loc, 'sound/effects/sparks2.ogg', 50, 1)
			//Actual rezzing code
			if(prob(75) && !((world.time - patient.tod) > (10 MINUTES))) //Can only revive within a few minutes
				if(!patient.client && patient.mind) //Don't force the dead person to come back if they don't want to.
					for(var/mob/observer/dead/ghost in player_list)
						if(ghost.mind == patient.mind)
							ghost << "<b><font color = #330033><font size = 3>Someone is trying to \
							revive you. Return to your body if you want to be revived!</b> \
							(Verbs -> Ghost -> Re-enter corpse). You have 15 seconds to do this!</font></font>"
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
		statechange(1) //Back to ready

/obj/item/device/defib_kit/proc/attempt_shock()
	if(!paddles || !patient || cell.charge < charge_cost) return

	var/zap_time = world.time + (5 SECONDS)
	var/o_patient_loc = patient.loc
	. = 1

	while(world.time < zap_time) //This is basically a custom do_after() call
		sleep(1)

		//Failed: We lost something important
		if(!paddles || !patient || !cell || cell.charge < charge_cost)
			. = 0
			break

		//Failed: The locations aren't right
		if((o_patient_loc != patient.loc) || !(get_dist(src,paddles) <= 1))
			. = 0
			break

		//Failed: The paddles aren't on the patient
		if(patient.w_uniform != paddles)
			patient = null
			. = 0
			break

	return


// --------------------------------------
//The paddles themselves. ZAP.
/obj/item/clothing/under/defib_paddles
	name = "defibrilator pads"
	desc = "Adhesive! Apply to dead person."
	icon = 'icons/obj/device.dmi'
	icon_override = 'icons/obj/device.dmi'
	icon_state = "defib_pads"

	var/obj/item/device/defib_kit/kit
	has_sensor = 0 //Naaah.

/obj/item/clothing/under/defib_paddles/proc/replaced(var/obj/item/device/defib_kit/K, var/mob/user)
	if(!kit) //Sanity: should not fire due to logic in kit
		return

	if(kit && K != kit)
		user << "<span class='warning'>The pads are connected to a different kit!</span>"
		return

	user.visible_message("[user] returns \the [src] and closes \the [kit].", "<span class='notice'>You return \the [src] and close \the [kit].</span>")
	user.remove_from_mob(src)
	src.forceMove(K)
	layer = initial(layer)
	return 1

/obj/item/clothing/under/defib_paddles/proc/reconnected(var/obj/item/device/defib_kit/K, var/mob/user)
	if(kit && K != kit)
		user << "<span class='warning'>The pads are connected to a different kit!</span>"
		return

	user.visible_message("[user] reconnects \the [src] to \the [K].", "<span class='notice'>You reconnect \the [src] to \the [K].</span>")
	kit = K
	kit.paddles = src
	return 1

/obj/item/clothing/under/defib_paddles/proc/grabbed(var/obj/item/device/defib_kit/K, var/mob/user)
	if(K != kit && istype(K)) //Mostly for sanity
		K.paddles = null //Stop talking to me!
		return

	user.visible_message("[user] removes \the [src] from \the [kit].", "<span class='notice'>You remove \the [src] from \the [kit].</span>")
	if(!user.put_in_hands(src))
		src.forceMove(get_turf(src))
	return 1

/obj/item/clothing/under/defib_paddles/equipped(var/mob/living/carbon/human/user, var/slot)
	. = ..()
	if(kit && istype(user) && slot == slot_w_uniform)
		kit.patient = user
		if(kit.patient.stat == DEAD)
			kit.patient.dir = 2 //Looks better this way
