/obj/item/integrated_circuit/output
	category_text = "Output"

/obj/item/integrated_circuit/output/screen
	name = "small screen"
	desc = "This small screen can display a single piece of data, when the machine is examined closely."
	extended_desc = "This will show the data loaded into it when the machine is examined."
	icon_state = "screen"
	inputs = list("displayed data" = IC_PINTYPE_ANY)
	outputs = list()
	activators = list("load data" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 10
	cooldown_per_use = 0 // Can be updated frequently.
	var/stuff_to_display = null


/obj/item/integrated_circuit/output/screen/disconnect_all()
	..()
	stuff_to_display = null

/obj/item/integrated_circuit/output/screen/any_examine(mob/user)
	return "There is a little screen labeled '[name]', which displays [!isnull(stuff_to_display) ? "'[stuff_to_display]'" : "nothing"]."

/obj/item/integrated_circuit/output/screen/do_work()
	var/datum/integrated_io/I = inputs[1]
	if(isweakref(I.data))
		var/datum/d = I.data_as_type(/datum)
		if(d)
			stuff_to_display = "[d]"
	else
		stuff_to_display = I.data

/obj/item/integrated_circuit/output/screen/medium
	name = "medium screen"
	desc = "This screen allows for people holding the device to see a piece of data."
	extended_desc = "This will display a message to the user holding the assembly when activated."
	icon_state = "screen_medium"
	power_draw_per_use = 20

/obj/item/integrated_circuit/output/screen/medium/do_work()
	..()
	var/list/nearby_things = range(0, get_turf(src))
	for(var/mob/M in nearby_things)
		var/obj/O = assembly ? assembly : src
		to_chat(M, span_notice("[icon2html(O,M.client)] [stuff_to_display]"))

/obj/item/integrated_circuit/output/screen/large
	name = "large screen"
	desc = "This screen allows for people able to see the device to see a piece of data."
	extended_desc = "This will display a message to everyone who can see the assembly when activated."
	icon_state = "screen_large"
	power_draw_per_use = 40
	cooldown_per_use = 1 SECOND // Because everyone will get the output instead of just the user/examiner.

/obj/item/integrated_circuit/output/screen/large/do_work()
	..()
	var/obj/O = assembly ? loc : assembly
	O.visible_message(span_notice("[icon2html(O,viewers(O))] [stuff_to_display]"))

/obj/item/integrated_circuit/output/light
	name = "light"
	desc = "This light can turn on and off on command."
	icon_state = "light"
	complexity = 4
	inputs = list()
	outputs = list()
	activators = list("toggle light" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/light_toggled = 0
	var/light_brightness = 3
	var/light_rgb = "#FFFFFF"
	power_draw_idle = 0 // Adjusted based on brightness.

/obj/item/integrated_circuit/output/light/do_work()
	light_toggled = !light_toggled
	update_lighting()

/obj/item/integrated_circuit/output/light/proc/update_lighting()
	if(light_toggled)
		if(assembly)
			assembly.set_light(l_range = light_brightness, l_power = light_brightness, l_color = light_rgb)
	else
		if(assembly)
			assembly.set_light(0)
	power_draw_idle = light_toggled ? light_brightness * light_brightness : 0 // Should be the same draw as regular lights.

/obj/item/integrated_circuit/output/light/power_fail() // Turns off the flashlight if there's no power left.
	light_toggled = FALSE
	update_lighting()

/obj/item/integrated_circuit/output/light/advanced
	name = "advanced light"
	desc = "This light can turn on and off on command, in any color, and in various brightness levels."
	extended_desc = "The brightness is limited to values between 1 and 6."
	icon_state = "light_adv"
	complexity = 8
	inputs = list(
		"color" = IC_PINTYPE_COLOR,
		"brightness" = IC_PINTYPE_NUMBER
	)
	outputs = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)

/obj/item/integrated_circuit/output/light/advanced/update_lighting()
	var/new_color = get_pin_data(IC_INPUT, 1)
	var/brightness = get_pin_data(IC_INPUT, 2)

	if(new_color && isnum(brightness))
		brightness = CLAMP(brightness, 0, 6)
		light_rgb = new_color
		light_brightness = brightness

	..()

/obj/item/integrated_circuit/output/light/advanced/on_data_written()
	update_lighting()

/obj/item/integrated_circuit/output/text_to_speech
	name = "text-to-speech circuit"
	desc = "A miniature speaker is attached to this component. It is able to transpose any valid text to speech."
	extended_desc = "This will emit an audible message to anyone who can hear the assembly."
	icon_state = "speaker"
	complexity = 12
	cooldown_per_use = 4 SECONDS
	inputs = list("text" = IC_PINTYPE_STRING)
	outputs = list()
	activators = list("to speech" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 60

/obj/item/integrated_circuit/output/text_to_speech/do_work()
	text = get_pin_data(IC_INPUT, 1)
	if(!isnull(text))
		var/obj/O = assembly ? loc : assembly
		audible_message("[icon2html(O,hearers(src))] \The [O.name] states, \"[text]\"", runemessage = text)

/obj/item/integrated_circuit/output/text_to_speech/advanced
	name = "advanced text-to-speech circuit"
	desc = "A miniature speaker is attached to this component. It is able to transpose any valid text to speech, matching a scanned target's voice."
	complexity = 15
	cooldown_per_use = 6 SECONDS
	inputs = list("text" = IC_PINTYPE_STRING, "mimic target" = IC_PINTYPE_REF)
	power_draw_per_use = 100

	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4, TECH_ILLEGAL = 1)

	var/mob/living/voice/my_voice

/obj/item/integrated_circuit/output/text_to_speech/advanced/Initialize()
	. = ..()
	my_voice = new (src)
	mob_list -= my_voice // no life() ticks
	my_voice.name = "TTS Circuit"

/obj/item/integrated_circuit/output/text_to_speech/advanced/do_work()
	text = get_pin_data(IC_INPUT, 1)
	var/mob/living/target_mob = get_pin_data(IC_INPUT, 2)
	my_voice.transfer_identity(target_mob)
	if(!isnull(text) && !isnull(my_voice) && !isnull(my_voice.name))
		my_voice.forceMove(get_turf(src))
		my_voice.say("[text]")
		my_voice.forceMove(src)

/obj/item/integrated_circuit/output/sound
	name = "speaker circuit"
	desc = "A miniature speaker is attached to this component."
	icon_state = "speaker"
	complexity = 8
	cooldown_per_use = 4 SECONDS
	inputs = list(
		"sound ID" = IC_PINTYPE_STRING,
		"volume" = IC_PINTYPE_NUMBER,
		"frequency" = IC_PINTYPE_BOOLEAN
	)
	outputs = list()
	activators = list("play sound" = IC_PINTYPE_PULSE_IN)
	power_draw_per_use = 20
	var/list/sounds = list()

/obj/item/integrated_circuit/output/sound/New()
	..()
	extended_desc = list()
	extended_desc += "The first input pin determines which sound is used. The choices are; "
	extended_desc += jointext(sounds, ", ")
	extended_desc += ". The second pin determines the volume of sound that is played"
	extended_desc += ", and the third determines if the frequency of the sound will vary with each activation."
	extended_desc = jointext(extended_desc, null)

/obj/item/integrated_circuit/output/sound/do_work()
	var/ID = get_pin_data(IC_INPUT, 1)
	var/vol = get_pin_data(IC_INPUT, 2)
	var/freq = get_pin_data(IC_INPUT, 3)
	if(!isnull(ID) && !isnull(vol))
		var/selected_sound = sounds[ID]
		if(!selected_sound)
			return
		vol = between(0, vol, 100)
		playsound(src, selected_sound, vol, freq, -1)

/obj/item/integrated_circuit/output/sound/beeper
	name = "beeper circuit"
	desc = "A miniature speaker is attached to this component.  This is often used in the construction of motherboards, which use \
	the speaker to tell the user if something goes very wrong when booting up.  It can also do other similar synthetic sounds such \
	as buzzing, pinging, chiming, and more."
	sounds = list(
		"beep"			= 'sound/machines/twobeep.ogg',
		"chime"			= 'sound/machines/chime.ogg',
		"buzz sigh"		= 'sound/machines/buzz-sigh.ogg',
		"buzz twice"	= 'sound/machines/buzz-two.ogg',
		"ping"			= 'sound/machines/ping.ogg',
		"synth yes"		= 'sound/machines/synth_yes.ogg',
		"synth no"		= 'sound/machines/synth_no.ogg',
		"warning buzz"	= 'sound/machines/warning-buzzer.ogg'
		)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/output/sound/beepsky
	name = "securitron sound circuit"
	desc = "A miniature speaker is attached to this component.  Considered by some to be the essential component for a securitron."
	sounds = list(
		"creep"			= 'sound/voice/bcreep.ogg',
		"criminal"		= 'sound/voice/bcriminal.ogg',
		"freeze"		= 'sound/voice/bfreeze.ogg',
		"god"			= 'sound/voice/bgod.ogg',
		"i am the law"	= 'sound/voice/biamthelaw.ogg',
		"insult"		= 'sound/voice/binsult.ogg',
		"radio"			= 'sound/voice/bradio.ogg',
		"secure day"	= 'sound/voice/bsecureday.ogg',
		)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_ILLEGAL = 1)

/obj/item/integrated_circuit/output/sound/medbot
	name = "medbot sound circuit"
	desc = "A miniature speaker is attached to this component, used to annoy patients while they get pricked by a medbot."
	sounds = list(
		"surgeon"		= 'sound/voice/medbot/msurgeon.ogg',
		"radar"			= 'sound/voice/medbot/mradar.ogg',
		"feel better"	= 'sound/voice/medbot/mfeelbetter.ogg',
		"patched up"	= 'sound/voice/medbot/mpatchedup.ogg',
		"injured"		= 'sound/voice/medbot/minjured.ogg',
		"insult"		= 'sound/voice/medbot/minsult.ogg',
		"coming"		= 'sound/voice/medbot/mcoming.ogg',
		"help"			= 'sound/voice/medbot/mhelp.ogg',
		"live"			= 'sound/voice/medbot/mlive.ogg',
		"lost"			= 'sound/voice/medbot/mlost.ogg',
		"flies"			= 'sound/voice/medbot/mflies.ogg',
		"catch"			= 'sound/voice/medbot/mcatch.ogg',
		"delicious"		= 'sound/voice/medbot/mdelicious.ogg',
		"apple"			= 'sound/voice/medbot/mapple.ogg',
		"no"			= 'sound/voice/medbot/mno.ogg',
		)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 1)

/obj/item/integrated_circuit/output/video_camera
	name = "video camera circuit"
	desc = "This small camera allows a remote viewer to see what it sees."
	var/list/networks = list(
		"research"			= NETWORK_CIRCUITS,
		"engine"			= NETWORK_ENGINE,
		"engineering"		= NETWORK_ENGINEERING,
		"mining"			= NETWORK_MINE,
		"medical"			= NETWORK_MEDICAL,
		"entertainment"		= NETWORK_THUNDER,
		"security"			= NETWORK_SECURITY,
		"command"			= NETWORK_COMMAND
		)
	icon_state = "video_camera"
	w_class = ITEMSIZE_SMALL
	complexity = 10
	inputs = list(
		"camera name" = IC_PINTYPE_STRING,
		"camera network" = IC_PINTYPE_STRING,
		"camera active" = IC_PINTYPE_BOOLEAN
		)
	inputs_default = list(
		"1" = "video camera circuit",
		"2" = "research"
		)
	outputs = list()
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_idle = 5 // Raises to 80 when on.
	var/obj/machinery/camera/network/circuits/camera

/obj/item/integrated_circuit/output/video_camera/New()
	..()
	extended_desc = list()
	extended_desc += "Network choices are; "
	extended_desc += jointext(networks, ", ")
	extended_desc += "."
	extended_desc = jointext(extended_desc, null)
	camera = new(src)
	on_data_written()

/obj/item/integrated_circuit/output/video_camera/Destroy()
	QDEL_NULL(camera)
	return ..()

/obj/item/integrated_circuit/output/video_camera/proc/set_camera_status(var/status)
	if(camera)
		camera.set_status(status)
		power_draw_idle = camera.status ? 80 : 5
		if(camera.status) // Ensure that there's actually power.
			if(!draw_idle_power())
				power_fail()

/obj/item/integrated_circuit/output/video_camera/on_data_written()
	if(camera)
		var/cam_name = get_pin_data(IC_INPUT, 1)
		var/cam_network = get_pin_data(IC_INPUT, 2)
		var/cam_active = get_pin_data(IC_INPUT, 3)
		if(!isnull(cam_name))
			camera.c_tag = cam_name
		camera.replace_networks(list(cam_network))
		set_camera_status(cam_active)
		if(isnull(cam_network))
			camera.clear_all_networks()
			return
		var/selected_network = networks[cam_network]
		if(!selected_network)
			camera.clear_all_networks()
			return
		camera.replace_networks(list(selected_network))

/obj/item/integrated_circuit/output/video_camera/power_fail()
	if(camera)
		set_camera_status(0)
		set_pin_data(IC_INPUT, 2, FALSE)

/obj/item/integrated_circuit/output/led
	name = "light-emitting diode"
	desc = "This a LED that is lit whenever there is TRUE-equivalent data on its input."
	extended_desc = "TRUE-equivalent values are: Non-empty strings, non-zero numbers, and valid refs."
	complexity = 0.1
	icon_state = "led"
	inputs = list("lit" = IC_PINTYPE_BOOLEAN)
	outputs = list()
	activators = list()
	power_draw_idle = 0 // Raises to 1 when lit.
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/led_color

/obj/item/integrated_circuit/output/led/on_data_written()
	power_draw_idle = get_pin_data(IC_INPUT, 1) ? 1 : 0

/obj/item/integrated_circuit/output/led/power_fail()
	set_pin_data(IC_INPUT, 1, FALSE)

/obj/item/integrated_circuit/output/led/any_examine(mob/user)
	var/text_output = list()
	var/initial_name = initial(name)

	// Doing all this work just to have a color-blind friendly output.
	text_output += "There is "
	if(name == initial_name)
		text_output += "\an [name]"
	else
		text_output += "\an ["\improper[initial_name]"] labeled '[name]'"
	text_output += " which is currently [get_pin_data(IC_INPUT, 1) ? "lit <font color=[led_color]>¤</font>" : "unlit."]"
	return jointext(text_output,null)

/obj/item/integrated_circuit/output/led/red
	name = "red LED"
	led_color = COLOR_RED

/obj/item/integrated_circuit/output/led/orange
	name = "orange LED"
	led_color = COLOR_ORANGE

/obj/item/integrated_circuit/output/led/yellow
	name = "yellow LED"
	led_color = COLOR_YELLOW

/obj/item/integrated_circuit/output/led/green
	name = "green LED"
	led_color = COLOR_GREEN

/obj/item/integrated_circuit/output/led/blue
	name = "blue LED"
	led_color = COLOR_BLUE

/obj/item/integrated_circuit/output/led/purple
	name = "purple LED"
	led_color = COLOR_PURPLE

/obj/item/integrated_circuit/output/led/cyan
	name = "cyan LED"
	led_color = COLOR_CYAN

/obj/item/integrated_circuit/output/led/white
	name = "white LED"
	led_color = COLOR_WHITE

/obj/item/integrated_circuit/output/led/pink
	name = "pink LED"
	led_color = COLOR_PINK



/obj/item/integrated_circuit/output/holographic_projector
	name = "holographic projector"
	desc = "This projects a holographic copy of an object."
	extended_desc = "If the assembly moves, the hologram will also move.<br>\
	Position coordinates are relative to the assembly, and are capped between -7 and 7.<br>\
	The assembly must be able to see the object to make a holographic copy of it.<br>\
	Scaling is capped between -2 and 2.<br>\
	The rotation pin uses degrees.<br>\
	Imitated object cannot be changed while projecting. Position, \
	scale, and rotation can be updated without restarting by pulsing the update hologram pin."
	complexity = 40
	icon_state = "holo_projector"
	inputs = list(
		"project hologram" = IC_PINTYPE_BOOLEAN,
		"object to copy" = IC_PINTYPE_REF,
		"hologram color" = IC_PINTYPE_COLOR,
		"hologram X pos" = IC_PINTYPE_NUMBER,
		"hologram Y pos" = IC_PINTYPE_NUMBER,
		"hologram scale" = IC_PINTYPE_NUMBER,
		"hologram rotation" = IC_PINTYPE_NUMBER
		)
	inputs_default = list(
		"3" = "#7DB4E1",
		"4" = 0,
		"5" = 0,
		"6" = 1,
		"7" = 0
		)
	outputs = list()
	activators = list(
		"update hologram" = IC_PINTYPE_PULSE_IN,
		"on drawn hologram" = IC_PINTYPE_PULSE_OUT
		)
	power_draw_idle = 0 // Raises to 500 when active, like a regular holopad.
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	var/obj/effect/overlay/holographic/hologram = null // Reference to the hologram effect, and also used to see if component is active.
	var/icon/holo_base = null // Uncolored holographic icon.
//	var/datum/beam/holo_beam = null // A visual effect, to make it easy to know where a hologram is coming from.
	// It is commented out due to picking up the assembly killing the beam.

/obj/item/integrated_circuit/output/holographic_projector/Initialize()
	. = ..()
	AddComponent(/datum/component/recursive_move)
	RegisterSignal(src, COMSIG_OBSERVER_MOVED, PROC_REF(on_moved))

/obj/item/integrated_circuit/output/holographic_projector/Destroy()
	destroy_hologram()
	UnregisterSignal(src, COMSIG_OBSERVER_MOVED)
	return ..()

/obj/item/integrated_circuit/output/holographic_projector/do_work()
	var/toggled = get_pin_data(IC_INPUT, 1)

	if(hologram) // Currently active.
		if(!toggled) // Being turned off.
			destroy_hologram()

		else // Updating position/dir/etc.
			update_hologram()

	else // Currently not active.
		if(toggled) // We're gonna turn on.
			create_hologram()

	activate_pin(2)

// Updates some changable aspects of the hologram like the size or position.
/obj/item/integrated_circuit/output/holographic_projector/proc/update_hologram()
	if(!hologram)
		return FALSE

	var/holo_scale = get_pin_data(IC_INPUT, 6)
	var/holo_rotation = get_pin_data(IC_INPUT, 7)

	if(!isnum(holo_scale) || !isnum(holo_rotation) )
		return FALSE // Invalid.

	hologram.adjust_scale(between(-2, holo_scale, 2) )
	hologram.adjust_rotation(holo_rotation)
	update_hologram_position()

	return TRUE

// This is a seperate function because other things besides do_work() might warrant updating position, like movement, without bothering with other parts.
/obj/item/integrated_circuit/output/holographic_projector/proc/update_hologram_position()
	var/holo_x = get_pin_data(IC_INPUT, 4)
	var/holo_y = get_pin_data(IC_INPUT, 5)
	if(!isnum(holo_x) || !isnum(holo_y) )
		return FALSE

	holo_x = between(-7, holo_x, 7)
	holo_y = between(-7, holo_y, 7)

	var/turf/T = get_turf(src)
	if(T)
		// Absolute coordinates.
		var/holo_abs_x = T.x + holo_x
		var/holo_abs_y = T.y + holo_y
		var/turf/W = locate(holo_abs_x, holo_abs_y, T.z)
		if(W) // Make sure we're not out of bounds.
			hologram.forceMove(W)
		return TRUE
	return FALSE

/obj/item/integrated_circuit/output/holographic_projector/proc/create_hologram()
	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)
	var/holo_color = get_pin_data(IC_INPUT, 3)

	if(istype(AM) && assembly)
		if(AM in view(get_turf(src))) // It must be able to 'see' the object it will copy.
			hologram = new(src)
			var/icon/holo_icon = getHologramIcon(getFlatIcon(AM), no_color = TRUE)
		//	holo_icon.GrayScale() // So it looks better colored.
			if(holo_color) // The color pin should ensure that it is a valid hex.
				holo_icon.ColorTone(holo_color)
			hologram.icon = holo_icon
			hologram.name = "[AM.name] (Hologram)"
			update_hologram()

	//		holo_beam = assembly.Beam(hologram, icon_state = "holo_beam", time = INFINITY, maxdistance = world.view)
			power_draw_idle = 500
			return TRUE
	return FALSE



/obj/item/integrated_circuit/output/holographic_projector/proc/destroy_hologram()
	QDEL_NULL(hologram)

//	holo_beam.End()
//	QDEL_NULL(holo_beam)

	power_draw_idle = 0

/obj/item/integrated_circuit/output/holographic_projector/on_data_written()
	if(hologram)
		update_hologram()

/obj/item/integrated_circuit/output/holographic_projector/proc/on_moved()
	if(hologram)
		update_hologram_position()

/obj/item/integrated_circuit/output/holographic_projector/power_fail()
	if(hologram)
		destroy_hologram()
		set_pin_data(IC_INPUT, 1, FALSE)
