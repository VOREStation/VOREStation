// Communicators
//
// Allows ghosts to roleplay with crewmembers without having to commit to joining the round, and also allows communications between two communicators.

var/global/list/obj/item/communicator/all_communicators = list()

// List of core tabs the communicator can switch to
#define HOMETAB 1
#define PHONTAB 2
#define CONTTAB 3
#define MESSTAB 4
#define NEWSTAB 5
#define NOTETAB 6
#define WTHRTAB 7
#define MANITAB 8
#define SETTTAB 9

/obj/item/communicator
	name = "communicator"
	desc = "A personal device used to enable long range dialog between two people, utilizing existing telecommunications infrastructure to allow \
	communications across different stations, planets, or even star systems."
	icon = 'icons/obj/device.dmi'
	icon_state = "communicator"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_ID | SLOT_BELT
	show_messages = 1

	origin_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2, TECH_DATA = 2)
	matter = list(MAT_STEEL = 30,MAT_GLASS = 10)

	var/video_range = 3
	var/obj/machinery/camera/communicator/video_source	// Their camera
	var/obj/machinery/camera/communicator/camera		// Our camera

	var/list/voice_mobs = list()
	var/list/voice_requests = list()
	var/list/voice_invites = list()

	var/list/im_contacts = list()
	var/list/im_list = list()

	var/note = "Thank you for choosing the T-14.2 Communicator, this is your notepad!" //Current note in the notepad function
	var/notehtml = ""

	var/fon = 0 // Internal light
	var/flum = 2 // Brightness

	var/list/modules = list(
							list("module" = "Phone", "icon" = "phone", "number" = PHONTAB),
							list("module" = "Contacts", "icon" = "user", "number" = CONTTAB),
							list("module" = "Messaging", "icon" = "comment-alt", "number" = MESSTAB),
							list("module" = "News", "icon" = "newspaper", "number" = NEWSTAB), // Need a different icon,
							list("module" = "Note", "icon" = "sticky-note", "number" = NOTETAB),
							list("module" = "Weather", "icon" = "sun", "number" = WTHRTAB),
							list("module" = "Crew Manifest", "icon" = "crown", "number" = MANITAB), // Need a different icon,
							list("module" = "Settings", "icon" = "cog", "number" = SETTTAB),
							)	//list("module" = "Name of Module", "icon" = "icon name64", "number" = "what tab is the module")

	var/selected_tab = HOMETAB
	var/owner = ""
	var/occupation = ""
	var/alert_called = 0
	var/obj/machinery/exonet_node/node = null //Reference to the Exonet node, to avoid having to look it up so often.

	var/target_address = ""
	var/target_address_name = ""
	var/network_visibility = 1
	var/ringer = 1
	var/list/known_devices = list()
	var/datum/exonet_protocol/exonet = null
	var/list/communicating = list()
	var/update_ticks = 0
	var/newsfeed_channel = 0

	// If you turn this on, it changes the way communicator video works. User configurable option.
	var/selfie_mode = FALSE

	// Ringtones! (Based on the PDA ones)
	var/ttone = "beep" //The ringtone!
	var/list/ttone_sound = list("beep" = 'sound/machines/twobeep.ogg',
								"boom" = 'sound/effects/explosionfar.ogg',
								"slip" = 'sound/misc/slip.ogg',
								"honk" = 'sound/items/bikehorn.ogg',
								"SKREE" = 'sound/voice/shriek1.ogg',
								// "holy" = 'sound/items/PDA/ambicha4-short.ogg',
								"xeno" = 'sound/voice/hiss1.ogg',
								"dust" = 'sound/effects/supermatter.ogg',
								"spark" = 'sound/effects/sparks4.ogg',
								"rad" = 'sound/items/geiger/high1.ogg',
								"servo" = 'sound/machines/rig/rigservo.ogg')

// Proc: New()
// Parameters: None
// Description: Adds the new communicator to the global list of all communicators, sorts the list, obtains a reference to the Exonet node, then tries to
//				assign the device to the holder's name automatically in a spectacularly shitty way.
/obj/item/communicator/Initialize()
	. = ..()
	all_communicators += src
	all_communicators = sortAtom(all_communicators)
	node = get_exonet_node()
	START_PROCESSING(SSobj, src)
	camera = new(src)
	camera.name = "[src] #[rand(100,999)]"
	camera.c_tag = camera.name

	setup_tgui_camera()

	//This is a pretty terrible way of doing this.
	addtimer(CALLBACK(src, PROC_REF(register_to_holder)), 5 SECONDS)

// Proc: register_to_holder()
// Parameters: None
// Description: Tries to register ourselves to the mob that we've presumably spawned in. Not the most amazing way of doing this.
/obj/item/communicator/proc/register_to_holder()
	if(ismob(loc))
		register_device(loc.name)
		initialize_exonet(loc)
	else if(istype(loc, /obj/item/storage))
		var/obj/item/storage/S = loc
		if(ismob(S.loc))
			register_device(S.loc.name)
			initialize_exonet(S.loc)


// Proc: initialize_exonet()
// Parameters: 1 (user - the person the communicator belongs to)
// Description: Sets up the exonet datum, gives the device an address, and then gets a node reference.  Afterwards, populates the device
//				list.
/obj/item/communicator/proc/initialize_exonet(mob/user)
	if(!user || !istype(user, /mob/living))
		return
	if(!exonet)
		exonet = new(src)
	if(!exonet.address)
		exonet.make_address("communicator-[user.client]-[user.name]")
	if(!node)
		node = get_exonet_node()
	populate_known_devices()

// Proc: examine()
// Parameters: 1 (user - the person examining the device)
// Description: Shows all the voice mobs inside the device, and their status.
/obj/item/communicator/examine(mob/user)
	. = ..()

	for(var/mob/living/voice/voice in contents)
		. += span_notice("On the screen, you can see a image feed of [voice].")

		if(voice && voice.key)
			switch(voice.stat)
				if(CONSCIOUS)
					if(!voice.client)
						. += span_warning("[voice] appears to be asleep.") //afk
				if(UNCONSCIOUS)
					. += span_warning("[voice] doesn't appear to be conscious.")
				if(DEAD)
					. += span_deadsay("[voice] appears to have died...") //Hopefully this never has to be used.
		else
			. += span_notice("The device doesn't appear to be transmitting any data.")

// Proc: emp_act()
// Parameters: None
// Description: Drops all calls when EMPed, so the holder can then get murdered by the antagonist.
/obj/item/communicator/emp_act()
	close_connection(reason = "Hardware error de%#_^@%-BZZZZZZZT")

// Proc: add_to_EPv2()
// Parameters: 1 (hex - a single hexadecimal character)
// Description: Called when someone is manually dialing with nanoUI.  Adds colons when appropiate.
/obj/item/communicator/proc/add_to_EPv2(var/hex)
	var/length = length(target_address)
	if(length >= 24)
		return
	if(length == 4 || length == 9 || length == 14 || length == 19 || length == 24 || length == 29)
		target_address += ":[hex]"
		return
	target_address += hex

// Proc: populate_known_devices()
// Parameters: 1 (user - the person using the device)
// Description: Searches all communicators and ghosts in the world, and adds them to the known_devices list if they are 'visible'.
/obj/item/communicator/proc/populate_known_devices(mob/user)
	if(!exonet)
		exonet = new(src)
	src.known_devices.Cut()
	if(!get_connection_to_tcomms()) //If the network's down, we can't see anything.
		return
	for(var/obj/item/communicator/comm in all_communicators)
		if(!comm || !comm.exonet || !comm.exonet.address || comm.exonet.address == src.exonet.address) //Don't add addressless devices, and don't add ourselves.
			continue
		src.known_devices |= comm
	for(var/mob/observer/dead/O in dead_mob_list)
		if(!O.client || O.client.prefs.communicator_visibility == 0)
			continue
		src.known_devices |= O

// Proc: get_connection_to_tcomms()
// Parameters: None
// Description: Simple check to see if the exonet node is active.
/obj/item/communicator/proc/get_connection_to_tcomms()
	if(node && node.on && node.allow_external_communicators)
		return can_telecomm(src,node)
	return 0

// Proc: process()
// Parameters: None
// Description: Ticks the update_ticks variable, and checks to see if it needs to disconnect communicators every five ticks..
/obj/item/communicator/process()
	update_ticks++
	if(update_ticks % 5)
		if(!node)
			node = get_exonet_node()
		if(!get_connection_to_tcomms())
			close_connection(reason = "Connection timed out")

// Proc: attackby()
// Parameters: 2 (C - what is used on the communicator. user - the mob that has the communicator)
// Description: When an ID is swiped on the communicator, the communicator reads the job and checks it against the Owner name, if success, the occupation is added.
/obj/item/communicator/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(istype(C, /obj/item/card/id))
		var/obj/item/card/id/idcard = C
		if(!idcard.registered_name || !idcard.assignment)
			to_chat(user, span_notice("\The [src] rejects the ID."))
		else if(!owner)
			to_chat(user, span_notice("\The [src] rejects the ID."))
		else if(owner == idcard.registered_name)
			occupation = idcard.assignment
			to_chat(user, span_notice("Occupation updated."))

	return

// Proc: attack_self()
// Parameters: 1 (user - the mob that clicked the device in their hand)
// Description: Makes an exonet datum if one does not exist, allocates an address for it, maintains the lists of all devies, clears the alert icon, and
//				finally makes NanoUI appear.
/obj/item/communicator/attack_self(mob/user)
	initialize_exonet(user)
	alert_called = 0
	update_icon()
	tgui_interact(user)

// Proc: MouseDrop()
//Same thing PDAs do
/obj/item/communicator/MouseDrop(obj/over_object as obj)
	var/mob/M = usr
	if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
		return
	if(!istype(over_object, /obj/screen))
		return attack_self(M)
	return


// Proc: attack_ghost()
// Parameters: 1 (user - the ghost clicking on the device)
// Description: Recreates the known_devices list, so that the ghost looking at the device can see themselves, then calls ..() so that NanoUI appears.
/obj/item/communicator/attack_ghost(mob/user)
	populate_known_devices() //Update the devices so ghosts can see the list on NanoUI.
	..()

/mob/observer/dead
	var/datum/exonet_protocol/exonet = null
	var/list/exonet_messages = list()

// Proc: New()
// Parameters: None
// Description: Gives ghosts an exonet address based on their key and ghost name.
/mob/observer/dead/Initialize()
	. = ..()
	exonet = new(src)
	if(client)
		exonet.make_address("communicator-[src.client]-[src.client.prefs.real_name]")
	else
		exonet.make_address("communicator-[key]-[src.real_name]")

// Proc: Destroy()
// Parameters: None
// Description: Removes the ghost's address and nulls the exonet datum, to allow qdel()ing.
/mob/observer/dead/Destroy()
	. = ..()
	if(exonet)
		exonet.remove_address()
		qdel_null(exonet)
	return ..()

// Proc: register_device()
// Parameters: 1 (user - the person to use their name for)
// Description: Updates the owner's name and the device's name.
/obj/item/communicator/proc/register_device(new_name)
	if(!new_name)
		return
	owner = new_name

	name = "[new_name]'s [initial(name)]"
	if(camera)
		camera.name = name
		camera.c_tag = name

// Proc: Destroy()
// Parameters: None
// Description: Deletes all the voice mobs, disconnects all linked communicators, and cuts lists to allow successful qdel()
/obj/item/communicator/Destroy()
	for(var/mob/living/voice/voice in contents)
		voice_mobs.Remove(voice)
		to_chat(voice, span_danger("[icon2html(src, voice.client)] Connection timed out with remote host."))
		qdel(voice)
	close_connection(reason = "Connection timed out")

	//Clean up all references we might have to others
	communicating.Cut()
	voice_requests.Cut()
	voice_invites.Cut()
	node = null

	//Clean up references that might point at us
	all_communicators -= src
	STOP_PROCESSING(SSobj, src)
	listening_objects.Remove(src)
	QDEL_NULL(camera)
	QDEL_NULL(exonet)

	last_camera_turf = null
	qdel(cam_screen)
	QDEL_LIST(cam_plane_masters)
	qdel(cam_background)

	return ..()

// Proc: update_icon()
// Parameters: None
// Description: Self explanatory
/obj/item/communicator/update_icon()
	if(video_source)
		icon_state = "communicator-video"
		return

	if(voice_mobs.len || communicating.len)
		icon_state = "communicator-active"
		return

	if(alert_called)
		icon_state = "communicator-called"
		return

	icon_state = initial(icon_state)

// A camera preset for spawning in the communicator
/obj/machinery/camera/communicator
	network = list(NETWORK_COMMUNICATORS)

/obj/machinery/camera/communicator/New()
	..()
	client_huds |= global_hud.whitense
	client_huds |= global_hud.darkMask

//It's the 26th century. We should have smart watches by now.
/obj/item/communicator/watch
	name = "communicator watch"
	desc = "A personal device used to enable long range dialog between two people, utilizing existing telecommunications infrastructure to allow \
	communications across different stations, planets, or even star systems. You can wear this one on your wrist!"
	icon = 'icons/obj/device.dmi'
	icon_state = "commwatch"
	slot_flags = SLOT_GLOVES

/obj/item/communicator/watch/update_icon()
	if(video_source)
		icon_state = "commwatch-video"
		return

	if(voice_mobs.len || communicating.len)
		icon_state = "commwatch-active"
		return

	if(alert_called)
		icon_state = "commwatch-called"
		return

	icon_state = initial(icon_state)

#undef HOMETAB
#undef PHONTAB
#undef CONTTAB
#undef MESSTAB
#undef NEWSTAB
#undef NOTETAB
#undef WTHRTAB
#undef MANITAB
#undef SETTTAB
