/obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in most ranged weapons, ballistic and energy.  \
	The first and second inputs need to be numbers.  They are coordinates for the gun to fire at, relative to the machine itself.  \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the coordinates, if possible.  Note that the \
	normal limitations to firearms, such as ammunition requirements and firing delays, still hold true if fired by the mechanism."
	complexity = 20
	inputs = list(
		"target X rel",
		"target Y rel"
		)
	outputs = list()
	activators = list(
		"fire"
	)
	var/obj/item/weapon/gun/installed_gun = null
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)

/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	qdel(installed_gun)
	..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/weapon/gun))
		var/obj/item/weapon/gun/gun = O
		if(installed_gun)
			user << "<span class='warning'>There's already a weapon installed.</span>"
			return
		user.drop_from_inventory(gun)
		installed_gun = gun
		gun.forceMove(src)
		user << "<span class='notice'>You slide \the [gun] into the firing mechanism.</span>"
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
	else
		..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attack_self(var/mob/user)
	if(installed_gun)
		installed_gun.forceMove(get_turf(src))
		user << "<span class='notice'>You slide \the [installed_gun] out of the firing mechanism.</span>"
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, 1)
		installed_gun = null
	else
		user << "<span class='notice'>There's no weapon to remove from the mechanism.</span>"

/obj/item/integrated_circuit/manipulation/weapon_firing/do_work()
	if(..())
		if(!installed_gun)
			return

		var/datum/integrated_io/target_x = inputs[1]
		var/datum/integrated_io/target_y = inputs[2]

		if(target_x.data && target_y.data && isnum(target_x.data) && isnum(target_y.data))
			var/turf/T = get_turf(src)

			if(target_x.data == 0 && target_y.data == 0) // Don't shoot ourselves.
				return

			// We need to do this in order to enable relative coordinates, as locate() only works for absolute coordinates.
			var/i
			if(target_x.data > 0)
				i = abs(target_x.data)
				while(i)
					T = get_step(T, EAST)
					i--
			else if(target_x.data < 0)
				i = abs(target_x.data)
				while(i)
					T = get_step(T, WEST)
					i--

			if(target_y.data > 0)
				i = abs(target_y.data)
				while(i)
					T = get_step(T, NORTH)
					i--
			else if(target_y.data < 0)
				i = abs(target_y.data)
				while(i)
					T = get_step(T, SOUTH)
					i--

			if(!T)
				return
			installed_gun.Fire_userless(T)

/obj/item/integrated_circuit/manipulation/locomotion
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
	icon_state = "locomotion"
	extended_desc = "The circuit accepts a number as a direction to move towards.<br>  \
	North/Fore = 1,<br>\
	South/Aft = 2,<br>\
	East/Starboard = 4,<br>\
	West/Port = 8,<br>\
	Northeast = 5,<br>\
	Northwest = 9,<br>\
	Southeast = 6,<br>\
	Southwest = 10<br>\
	<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move a meter in that direction, assuming it is not \
	being held, or anchored in some way.  It should be noted that the ability to move is dependant on the type of assembly that this circuit inhabits."
	complexity = 20
	inputs = list("dir num")
	outputs = list()
	activators = list("step towards dir")
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(src)
	if(T && istype(loc, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/machine = loc
		if(machine.anchored || !machine.can_move())
			return
		if(machine.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum(wanted_dir.data))
				step(machine, wanted_dir.data)