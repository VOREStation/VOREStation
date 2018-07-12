/mob/living/silicon/ai
	var/mob/living/silicon/robot/drone/controlling_drone

/mob/living/silicon/robot/drone
	var/mob/living/silicon/ai/controlling_ai

/mob/living/silicon/robot/drone/attack_ai(var/mob/living/silicon/ai/user)

	if(!istype(user) || controlling_ai || !config.allow_drone_spawn || !config.allow_ai_drones)
		return

	if(client || key)
		to_chat(user, "<span class='warning'>You cannot take control of an autonomous, active drone.</span>")
		return

	if(health < -35 || emagged)
		to_chat(user, "<span class='notice'><b>WARNING:</b> connection timed out.</span>")
		return

	user.controlling_drone = src
	user.teleop = src
	radio.channels = user.aiRadio.keyslot2.channels
	controlling_ai = user
	verbs += /mob/living/silicon/robot/drone/proc/release_ai_control_verb
	local_transmit = FALSE
	languages = controlling_ai.languages.Copy()
	speech_synthesizer_langs = controlling_ai.speech_synthesizer_langs.Copy()
	stat = CONSCIOUS
	if(user.mind)
		user.mind.transfer_to(src)
	else
		key = user.key
	updatename()
	to_chat(src, "<span class='notice'><b>You have shunted your primary control loop into \a [initial(name)].</b> Use the <b>Release Control</b> verb to return to your core.</span>")

/obj/machinery/drone_fabricator/attack_ai(var/mob/living/silicon/ai/user as mob)

	if(!istype(user) || user.controlling_drone || !config.allow_drone_spawn || !config.allow_ai_drones)
		return

	if(stat & NOPOWER)
		to_chat(user, "<span class='warning'>\The [src] is unpowered.</span>")
		return

	if(!produce_drones)
		to_chat(user, "<span class='warning'>\The [src] is disabled.</span>")
		return

	if(drone_progress < 100)
		to_chat(user, "<span class='warning'>\The [src] is not ready to produce a new drone.</span>")
		return

	if(count_drones() >= config.max_maint_drones)
		to_chat(user, "<span class='warning'>The drone control subsystems are tasked to capacity; they cannot support any more drones.</span>")
		return

	var/mob/living/silicon/robot/drone/new_drone = create_drone()
	user.controlling_drone = new_drone
	user.teleop = new_drone
	new_drone.radio.channels = user.aiRadio.keyslot2.channels
	new_drone.controlling_ai = user
	new_drone.verbs += /mob/living/silicon/robot/drone/proc/release_ai_control_verb
	new_drone.local_transmit = FALSE
	new_drone.languages = new_drone.controlling_ai.languages.Copy()
	new_drone.speech_synthesizer_langs = new_drone.controlling_ai.speech_synthesizer_langs.Copy()

	if(user.mind)
		user.mind.transfer_to(new_drone)
	else
		new_drone.key = user.key
	new_drone.updatename()

	to_chat(new_drone, "<span class='notice'><b>You have shunted your primary control loop into \a [initial(new_drone.name)].</b> Use the <b>Release Control</b> verb to return to your core.</span>")

/mob/living/silicon/robot/drone/proc/release_ai_control_verb()
	set name = "Release Control"
	set desc = "Release control of a remote drone."
	set category = "Silicon Commands"

	release_ai_control("Remote session terminated.")

/mob/living/silicon/robot/drone/proc/release_ai_control(var/message = "Connection terminated.")

	if(controlling_ai)
		if(mind)
			mind.transfer_to(controlling_ai)
		else
			controlling_ai.key = key
		to_chat(controlling_ai, "<span class='notice'>[message]</span>")
		controlling_ai.controlling_drone = null
		controlling_ai.teleop = null
		controlling_ai = null

	radio.channels = module.channels
	verbs -= /mob/living/silicon/robot/drone/proc/release_ai_control_verb
	module.remove_languages(src) //Removes excess, adds 'default'.
	remove_language("Robot Talk")
	add_language("Robot Talk", 0)
	add_language("Drone Talk", 1)
	local_transmit = TRUE
	full_law_reset()
	updatename()
	death()
