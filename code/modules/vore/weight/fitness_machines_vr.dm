/obj/machinery/workout
	name = "fitness lifter"
	icon = 'code/modules/vore/weight/fit_vr.dmi'
	icon_state = "fitnesslifter" //Sprites ripped from goon.
	desc = "A utility often used to lose weight."
	anchored = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/workout/attackby(obj/item/W, var/mob/living/user)
	if(istype(W, /obj/item/weapon/wrench))
		src.add_fingerprint(user)
		user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		return

/obj/machinery/workout/attack_hand(var/mob/living/user)
	if(!anchored)
		user << "<span class='notice'>For safety reasons, you are required to have this equipment wrenched down before using it!</span>"
		return

	else if(user.loc != src.loc)
		user << "<span class='notice'>For safety reasons, you need to be sitting in the fitness lifter for it to work!</span>"
		return

	else if(user.nutrition > 70 && user.weight > 70) //If they have enough nutrition and body weight, they can exercise.
		user.setClickCooldown(40)
		user.dir = src.dir
		user.nutrition = user.nutrition - 20 //Working out burns a lot of calories!
		user.weight = user.weight - 0.05 //Burn a bit of weight. Not much, but quite a bit. This can't be spammed, as they'll need nutrition to be able to work out.
		flick("fitnesslifter2",src)
		user << "<span class='notice'>You lift some weights.</span>"

	else if(user.nutrition < 70)
		user << "<span class='notice'>You need more energy to workout on the mat!</span>"

	else if(user.weight < 70)
		user << "<span class='notice'>You're too skinny to risk losing any more weight!</span>"

	else
		user << "<span class='notice'>You're unable to use the fitness lifter.</span>"
		return //Something went wrong. They shouldn't see this.

/obj/machinery/workout/shipped
	anchored = 0 // For cargo.


/obj/machinery/punching_bag
	name = "punching bag"
	icon = 'code/modules/vore/weight/fit_vr.dmi'
	icon_state = "punchingbag"
	desc = "A bag often used to releive stress and burn fat."
	anchored = 1
	density = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/punching_bag/attack_hand(var/mob/living/user)

	if(user.nutrition > 35 && user.weight > 70) //If they have enough nutrition and body weight, they can exercise.
		user.setClickCooldown(10)
		user.nutrition = user.nutrition - 10 //A punching bag uses less calories.
		user.weight = user.weight - 0.025 //And burns less weight.
		flick("punchingbag2",src)
		var/message = pick(
			"<span class='notice'>You slam your fist into the punching bag.</span>",
			"<span class='notice'>You jab the punching bag with your elbow.</span>")
		user << message
		playsound(src.loc, "punch", 50, 1)

	else if(user.nutrition < 35)
		user << "<span class='notice'>You need more energy to workout on the mat!</span>"

	else if(user.weight < 70)
		user << "<span class='notice'>You're too skinny to risk losing any more weight!</span>"

	else
		user << "<span class='notice'>You're unable to use the punching bag.</span>"
		return //Something went wrong. They shouldn't see this.


/obj/machinery/punching_clown
	name = "clown punching bag"
	icon = 'code/modules/vore/weight/fit_vr.dmi'
	icon_state = "bopbag"
	desc = "A bag often used to releive stress and burn fat. It has a clown on the front of it."
	anchored = 0
	density = 1
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/punching_clown/attack_hand(var/mob/living/user)

	if(user.nutrition > 35 && user.weight > 70) //If they have enough nutrition and body weight, they can exercise.
		user.setClickCooldown(10)
		user.nutrition = user.nutrition - 10
		user.weight = user.weight - 0.025
		flick("bopbag2",src)
		var/message = pick(
			"<span class='notice'>You slam your fist into the punching bag.</span>",
			"<span class='notice'>You jab the punching bag with your elbow.</span>",
			"<span class='notice'>You hammer the clown right in it's face with your fist.</span>",
			"<span class='notice'>A honk emits from the punching bag as you hit it.</span>")
		var/sound = pick(
			"punch",
			"clownstep",
			'sound/items/bikehorn.ogg')
		user << message
		playsound(src.loc, sound, 50, 1)

	else if(user.nutrition < 35)
		user << "<span class='notice'>You need more energy to workout on the mat!</span>"

	else if(user.weight < 70)
		user << "<span class='notice'>You're too skinny to risk losing any more weight!</span>"

	else
		user << "<span class='notice'>You're unable to use the punching bag.</span>"
		return //Something went wrong. They shouldn't see this.

/obj/machinery/scale
	name = "scale"
	icon = 'code/modules/vore/weight/fit_vr.dmi'
	icon_state = "scale"
	desc = "A scale used to measure ones weight relative to their size and species."
	anchored = 1 // Set to 0 when we can construct or dismantle these.
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0
	var/kilograms

/obj/machinery/scale/attack_hand(var/mob/living/user)
	if(user.loc != src.loc)
		user << "<span class='notice'>You need to be standing on top of the scale for it to work!</span>"
		return
	if(user.weight) //Just in case.
		kilograms = round(text2num(user.weight),4) / 2.20463
		user << "<span class='notice'>Your relative weight is [user.weight]lb / [kilograms]kg.</span>"
		user.visible_message("<span class='warning'>[user]'s relative weight is [user.weight]lb / [kilograms]kg.</span>")
