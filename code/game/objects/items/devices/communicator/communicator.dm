// Communicators
//
// Allows ghosts to roleplay with crewmembers without having to commit to joining the round, and also allows communications between two communicators.

var/global/list/obj/item/device/communicator/all_communicators = list()

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
#define EXTRTAB 10

/obj/item/device/communicator
	name = "communicator"
	desc = "A personal device used to enable long range dialog between two people, utilizing existing telecommunications infrastructure to allow \
	communications across different stations, planets, or even star systems."
	icon = 'icons/obj/device.dmi'
	icon_state = "communicator"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_ID | SLOT_BELT
	show_messages = 1

	origin_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2, TECH_DATA = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 10)

	var/video_range = 4
	var/obj/machinery/camera/communicator/video_source	// Their camera
	var/obj/machinery/camera/communicator/camera		// Our camera

	var/list/voice_mobs = list()
	var/list/voice_requests = list()
	var/list/voice_invites = list()

	var/list/im_contacts = list()
	var/list/im_list = list()

	var/note = "Thank you for choosing the T-14.2 Communicator, this is your notepad!" //Current note in the notepad function
	var/notehtml = ""

	var/obj/item/weapon/commcard/cartridge = null //current cartridge
	var/fon = 0 // Internal light
	var/flum = 2 // Brightness

	var/list/modules = list(
							list("module" = "Phone", "icon" = "phone64", "number" = PHONTAB),
							list("module" = "Contacts", "icon" = "person64", "number" = CONTTAB),
							list("module" = "Messaging", "icon" = "comment64", "number" = MESSTAB),
							list("module" = "News", "icon" = "note64", "number" = NEWSTAB), // Need a different icon,
							list("module" = "Note", "icon" = "note64", "number" = NOTETAB),
							list("module" = "Weather", "icon" = "sun64", "number" = WTHRTAB),
							list("module" = "Crew Manifest", "icon" = "note64", "number" = MANITAB), // Need a different icon,
							list("module" = "Settings", "icon" = "gear64", "number" = SETTTAB),
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

// Proc: New()
// Parameters: None
// Description: Adds the new communicator to the global list of all communicators, sorts the list, obtains a reference to the Exonet node, then tries to
//				assign the device to the holder's name automatically in a spectacularly shitty way.
/obj/item/device/communicator/New()
	..()
	all_communicators += src
	all_communicators = sortAtom(all_communicators)
	node = get_exonet_node()
	START_PROCESSING(SSobj, src)
	camera = new(src)
	camera.name = "[src] #[rand(100,999)]"
	camera.c_tag = camera.name
	//This is a pretty terrible way of doing this.
	spawn(5 SECONDS) //Wait for our mob to finish spawning.
		if(ismob(loc))
			register_device(loc.name)
			initialize_exonet(loc)
		else if(istype(loc, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = loc
			if(ismob(S.loc))
				register_device(S.loc.name)
				initialize_exonet(S.loc)

// Proc: examine()
// Parameters: user - the user doing the examining
// Description: Allows the user to click a link when examining to look at video if one is going.
/obj/item/device/communicator/examine(mob/user)
	. = ..(user, 1)
	if(. && video_source)
		to_chat(user, "<span class='notice'>It looks like it's on a video call: <a href='?src=\ref[src];watchvideo=1'>\[view\]</a></span>")

// Proc: initialize_exonet()
// Parameters: 1 (user - the person the communicator belongs to)
// Description: Sets up the exonet datum, gives the device an address, and then gets a node reference.  Afterwards, populates the device
//				list.
/obj/item/device/communicator/proc/initialize_exonet(mob/user)
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
/obj/item/device/communicator/examine(mob/user)
	if(!..(user))
		return

	var/msg = ""
	for(var/mob/living/voice/voice in contents)
		msg += "<span class='notice'>On the screen, you can see a image feed of [voice].</span>\n"
		msg += "<span class='warning'>"

		if(voice && voice.key)
			switch(voice.stat)
				if(CONSCIOUS)
					if(!voice.client)
						msg += "[voice] appears to be asleep.\n" //afk
				if(UNCONSCIOUS)
					msg += "[voice] doesn't appear to be conscious.\n"
				if(DEAD)
					msg += "<span class='deadsay'>[voice] appears to have died...</span>\n" //Hopefully this never has to be used.
		else
			msg += "<span class='notice'>The device doesn't appear to be transmitting any data.</span>\n"
		msg += "</span>"
	to_chat(user, msg)
	return

// Proc: emp_act()
// Parameters: None
// Description: Drops all calls when EMPed, so the holder can then get murdered by the antagonist.
/obj/item/device/communicator/emp_act()
	close_connection(reason = "Hardware error de%#_^@%-BZZZZZZZT")

// Proc: add_to_EPv2()
// Parameters: 1 (hex - a single hexadecimal character)
// Description: Called when someone is manually dialing with nanoUI.  Adds colons when appropiate.
/obj/item/device/communicator/proc/add_to_EPv2(var/hex)
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
/obj/item/device/communicator/proc/populate_known_devices(mob/user)
	if(!exonet)
		exonet = new(src)
	src.known_devices.Cut()
	if(!get_connection_to_tcomms()) //If the network's down, we can't see anything.
		return
	for(var/obj/item/device/communicator/comm in all_communicators)
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
/obj/item/device/communicator/proc/get_connection_to_tcomms()
	if(node && node.on && node.allow_external_communicators)
		return can_telecomm(src,node)
	return 0

// Proc: process()
// Parameters: None
// Description: Ticks the update_ticks variable, and checks to see if it needs to disconnect communicators every five ticks..
/obj/item/device/communicator/process()
	update_ticks++
	if(update_ticks % 5)
		if(!node)
			node = get_exonet_node()
		if(!get_connection_to_tcomms())
			close_connection(reason = "Connection timed out")

// Proc: attack()
// Parameters: 2 (M - what is being attacked. user - the mob that has the communicator)
// Description: When the communicator has an attached commcard with internal devices, relay the attack() through to those devices.
// 		Contents of the for loop are copied from gripper code, because that does approximately what we want to do.
/obj/item/device/communicator/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(cartridge && cartridge.active_devices)
		for(var/obj/item/wrapped in cartridge.active_devices)
			if(wrapped) 	//The force of the wrapped obj gets set to zero during the attack() and afterattack().
				wrapped.attack(M,user)
	return 0

// Proc: attackby()
// Parameters: 2 (C - what is used on the communicator. user - the mob that has the communicator)
// Description: When an ID is swiped on the communicator, the communicator reads the job and checks it against the Owner name, if success, the occupation is added.
/obj/item/device/communicator/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(istype(C, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = C
		if(!idcard.registered_name || !idcard.assignment)
			to_chat(user, "<span class='notice'>\The [src] rejects the ID.</span>")
		else if(!owner)
			to_chat(user, "<span class='notice'>\The [src] rejects the ID.</span>")
		else if(owner == idcard.registered_name)
			occupation = idcard.assignment
			to_chat(user, "<span class='notice'>Occupation updated.</span>")

	if(istype(C, /obj/item/weapon/commcard) && !cartridge)
		cartridge = C
		user.drop_item()
		cartridge.forceMove(src)
		to_chat(usr, "<span class='notice'>You slot \the [cartridge] into \the [src].</span>")
		modules[++modules.len] = list("module" = "External Device", "icon" = "external64", "number" = EXTRTAB)
		SSnanoui.update_uis(src) // update all UIs attached to src
	return

// Proc: attack_self()
// Parameters: 1 (user - the mob that clicked the device in their hand)
// Description: Makes an exonet datum if one does not exist, allocates an address for it, maintains the lists of all devies, clears the alert icon, and
//				finally makes NanoUI appear.
/obj/item/device/communicator/attack_self(mob/user)
	initialize_exonet(user)
	alert_called = 0
	update_icon()
	ui_interact(user)
	if(video_source)
		watch_video(user)

// Proc: MouseDrop()
//Same thing PDAs do
/obj/item/device/communicator/MouseDrop(obj/over_object as obj)
	var/mob/M = usr
	if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
		return
	if(!istype(over_object, /obj/screen))
		return attack_self(M)
	return


// Proc: attack_ghost()
// Parameters: 1 (user - the ghost clicking on the device)
// Description: Recreates the known_devices list, so that the ghost looking at the device can see themselves, then calls ..() so that NanoUI appears.
/obj/item/device/communicator/attack_ghost(mob/user)
	populate_known_devices() //Update the devices so ghosts can see the list on NanoUI.
	..()

/mob/observer/dead
	var/datum/exonet_protocol/exonet = null
	var/list/exonet_messages = list()

// Proc: New()
// Parameters: None
// Description: Gives ghosts an exonet address based on their key and ghost name.
/mob/observer/dead/New()
	. = ..()
	spawn(20)
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
		exonet = null
	return ..()

// Proc: register_device()
// Parameters: 1 (user - the person to use their name for)
// Description: Updates the owner's name and the device's name.
/obj/item/device/communicator/proc/register_device(new_name)
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
/obj/item/device/communicator/Destroy()
	for(var/mob/living/voice/voice in contents)
		voice_mobs.Remove(voice)
		to_chat(voice, "<span class='danger'>[bicon(src)] Connection timed out with remote host.</span>")
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

	return ..()

// Proc: update_icon()
// Parameters: None
// Description: Self explanatory
/obj/item/device/communicator/update_icon()
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

/obj/item/device/communicator/verb/verb_remove_cartridge()
	set category = "Object"
	set name = "Remove commcard"
	set src in usr

	// Can't remove what isn't there
	if(!cartridge)
		to_chat(usr, "<span class='notice'>There isn't a commcard to remove!</span>")
		return

	// Can't remove if you're physically unable to
	if(usr.stat || usr.restrained() || usr.paralysis || usr.stunned || usr.weakened)
		to_chat(usr, "<span class='notice'>You cannot do this while restrained.</span>")
		return

	var/turf/T = get_turf(src)
	cartridge.loc = T
	// If it's in someone, put the cartridge in their hands
	if (ismob(loc))
		var/mob/M = loc
		M.put_in_hands(cartridge)
	// Else just set it on the ground
	else
		cartridge.loc = get_turf(src)
	cartridge = null
	// We have to iterate through the modules to find EXTRTAB, because list procs don't play nice with a list of lists
	for(var/i = 1, i <= modules.len, i++)
		if(modules[i]["number"] == EXTRTAB)
			modules.Cut(i, i+1)
			break
	to_chat(usr, "<span class='notice'>You remove \the [cartridge] from the [name].</span>")

//It's the 26th century. We should have smart watches by now.
/obj/item/device/communicator/watch
	name = "communicator watch"
	desc = "A personal device used to enable long range dialog between two people, utilizing existing telecommunications infrastructure to allow \
	communications across different stations, planets, or even star systems. You can wear this one on your wrist!"
	icon = 'icons/obj/device.dmi'
	icon_state = "commwatch"
	slot_flags = SLOT_GLOVES

/obj/item/device/communicator/watch/update_icon()
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

