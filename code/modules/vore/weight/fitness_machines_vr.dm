/obj/machinery/fitness
	name = "workout equipment"
	desc = "A utility often used to lose weight."
	icon = 'icons/obj/machines/fitness_machines_vr.dmi'
	anchored = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/messages
	var/workout_sounds
	var/cooldown = 10
	var/weightloss_power = 1

/obj/machinery/fitness/attack_hand(var/mob/living/user)
	if(user.nutrition < 70)
		to_chat(user, "<span class='notice'>You need more energy to workout with the [src]!</span>")

	else if(user.weight < 70)
		to_chat(user, "<span class='notice'>You're too skinny to risk losing any more weight!</span>")

	else //If they have enough nutrition and body weight, they can exercise.
		user.setClickCooldown(cooldown)
		user.nutrition -= 10 * weightloss_power
		user.weight -= 0.025 * weightloss_power * (0.01*user.weight_loss)
		flick("[icon_state]2",src)
		var/message = pick(messages)
		to_chat(user, "<span class='notice'>[message].</span>")
		for(var/s in workout_sounds)
			playsound(src.loc, s, 50, 1)

/obj/machinery/fitness/punching_bag
	name = "punching bag"
	desc = "A bag often used to relieve stress and burn fat."
	icon_state = "punchingbag"
	anchored = 0
	density = 1
	workout_sounds = list(
		"punch")
	messages = list(
		"You slam your fist into the punching bag",
			"You jab the punching bag with your elbow")

/obj/machinery/fitness/punching_bag/clown
	name = "clown punching bag"
	desc = "A bag often used to releive stress and burn fat. It has a clown on the front of it."
	icon_state = "bopbag"
	workout_sounds = list(
		"punch",
		"clownstep",
		"sound/items/bikehorn.ogg")
	messages = list(
		"You slam your fist into the punching bag",
			"You jab the punching bag with your elbow",
			"You hammer the clown right in it's face with your fist",
			"A honk emits from the punching bag as you hit it")

/obj/machinery/fitness/heavy/attackby(obj/item/W, var/mob/living/user)
	if(W.is_wrench())
		src.add_fingerprint(user)
		user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		return

/obj/machinery/fitness/heavy/attack_hand(var/mob/living/user)
	if(!anchored)
		to_chat(user, "<span class='notice'>For safety reasons, you are required to have this equipment wrenched down before using it!</span>")
		return

	else if(user.loc != src.loc)
		to_chat(user, "<span class='notice'>For safety reasons, you need to be sitting in the [src] for it to work!</span>")
		return

	else
		..()

/obj/machinery/fitness/heavy/lifter
	name = "fitness lifter"
	desc = "A specialized machine that can be used for an assortment of excercises involving moving some weight repeatedly. Often used with the goal of losing weight."
	icon_state = "fitnesslifter" //Sprites ripped from goon.
	messages = list("You lift some weights")
	weightloss_power = 2
	cooldown = 40

/obj/machinery/scale
	name = "scale"
	icon = 'icons/obj/machines/fitness_machines_vr.dmi'
	icon_state = "scale"
	desc = "A scale used to measure ones weight relative to their size and species."
	anchored = 1 // Set to 0 when we can construct or dismantle these.
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/scale/attack_hand(var/mob/living/user)
	if(user.loc != loc)
		to_chat(user, "<span class='notice'>You need to be standing on top of the scale for it to work!</span>")
		return
	if(user.weight) //Just in case.
		var/kilograms = round(text2num(user.weight),4) / 2.20463
		visible_message("<span class='notice'>[src] displays a reading of [user.weight]lb / [kilograms]kg when [user] stands on it.</span>")
