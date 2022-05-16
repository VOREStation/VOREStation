//Simple borg hand.
//Limited use.
/obj/item/weapon/gripper
	name = "magnetic gripper"
	desc = "A simple grasping tool specialized in construction and engineering work."
	description_info = "Ctrl-Clicking on the gripper will drop whatever it is holding.<br>\
	Using an object on the gripper will interact with the item inside it, if it exists, instead."
	icon = 'icons/obj/device.dmi'
	icon_state = "gripper"

	flags = NOBLUDGEON

	//Has a list of items that it can hold.
	var/list/can_hold = list(
		/obj/item/weapon/cell,
		/obj/item/weapon/airlock_electronics,
		/obj/item/weapon/tracker_electronics,
		/obj/item/weapon/module/power_control,
		/obj/item/weapon/stock_parts,
		/obj/item/frame,
		/obj/item/weapon/camera_assembly,
		/obj/item/weapon/tank,
		/obj/item/weapon/circuitboard,
		/obj/item/weapon/smes_coil,
		/obj/item/weapon/fuel_assembly
		)

	var/obj/item/wrapped = null // Item currently being held.

	var/force_holder = null //

/obj/item/weapon/gripper/examine(mob/user)
	. = ..()
	if(wrapped)
		. += "<span class='notice'>\The [src] is holding \the [wrapped].</span>"
		. += wrapped.examine(user)

/obj/item/weapon/gripper/CtrlClick(mob/user)
	drop_item()
	return

/obj/item/weapon/gripper/AltClick(mob/user)
	drop_item()
	return

/obj/item/weapon/gripper/omni
	name = "omni gripper"
	desc = "A strange grasping tool that can hold anything a human can, but still maintains the limitations of application its more limited cousins have."
	icon_state = "gripper-omni"

	can_hold = list(/obj/item) // Testing and Event gripper.

// VEEEEERY limited version for mining borgs. Basically only for swapping cells and upgrading the drills.
/obj/item/weapon/gripper/miner
	name = "drill maintenance gripper"
	desc = "A simple grasping tool for the maintenance of heavy drilling machines."
	icon_state = "gripper-mining"

	can_hold = list(
	/obj/item/weapon/cell,
	/obj/item/weapon/stock_parts
	)

/obj/item/weapon/gripper/security
	name = "security gripper"
	desc = "A simple grasping tool for corporate security work."
	icon_state = "gripper-sec"

	can_hold = list(
	/obj/item/weapon/paper,
	/obj/item/weapon/paper_bundle,
	/obj/item/weapon/pen,
	/obj/item/weapon/sample,
	/obj/item/weapon/forensics/sample_kit,
	/obj/item/device/taperecorder,
	/obj/item/device/tape,
	/obj/item/device/uv_light
	)

/obj/item/weapon/gripper/paperwork
	name = "paperwork gripper"
	desc = "A simple grasping tool for clerical work."

	can_hold = list(
		/obj/item/weapon/clipboard,
		/obj/item/weapon/paper,
		/obj/item/weapon/paper_bundle,
		/obj/item/weapon/card/id,
		/obj/item/weapon/book,
		/obj/item/weapon/newspaper
		)

/obj/item/weapon/gripper/medical
	name = "medical gripper"
	desc = "A simple grasping tool for medical work."

	can_hold = list(
		/obj/item/weapon/reagent_containers/glass,
		/obj/item/weapon/storage/pill_bottle,
		/obj/item/weapon/reagent_containers/pill,
		/obj/item/weapon/reagent_containers/blood,
		/obj/item/stack/material/phoron
		)

/obj/item/weapon/gripper/research //A general usage gripper, used for toxins/robotics/xenobio/etc
	name = "scientific gripper"
	icon_state = "gripper-sci"
	desc = "A simple grasping tool suited to assist in a wide array of research applications."

	can_hold = list(
		/obj/item/weapon/cell,
		/obj/item/weapon/stock_parts,
		/obj/item/device/mmi,
		/obj/item/robot_parts,
		/obj/item/borg/upgrade,
		/obj/item/device/flash, //to build borgs,
		/obj/item/weapon/disk,
		/obj/item/weapon/circuitboard,
		/obj/item/weapon/reagent_containers/glass,
		/obj/item/device/assembly/prox_sensor,
		/obj/item/device/healthanalyzer, //to build medibots,
		/obj/item/slime_cube,
		/obj/item/slime_crystal,
		/obj/item/weapon/disposable_teleporter/slime,
		/obj/item/slimepotion,
		/obj/item/slime_extract,
		/obj/item/weapon/reagent_containers/food/snacks/monkeycube

		)

/obj/item/weapon/gripper/circuit
	name = "circuit assembly gripper"
	icon_state = "gripper-circ"
	desc = "A complex grasping tool used for working with circuitry."

	can_hold = list(
		/obj/item/weapon/cell/device,
		/obj/item/device/electronic_assembly,
		/obj/item/device/assembly/electronic_assembly,
		/obj/item/clothing/under/circuitry,
		/obj/item/clothing/gloves/circuitry,
		/obj/item/clothing/glasses/circuitry,
		/obj/item/clothing/shoes/circuitry,
		/obj/item/clothing/head/circuitry,
		/obj/item/clothing/ears/circuitry,
		/obj/item/clothing/suit/circuitry,
		/obj/item/weapon/implant/integrated_circuit,
		/obj/item/integrated_circuit

		)

/obj/item/weapon/gripper/service //Used to handle food, drinks, and seeds.
	name = "service gripper"
	icon_state = "gripper"
	desc = "A simple grasping tool used to perform tasks in the service sector, such as handling food, drinks, and seeds."

	can_hold = list(
		/obj/item/weapon/reagent_containers/glass,
		/obj/item/weapon/reagent_containers/food,
		/obj/item/seeds,
		/obj/item/weapon/grown,
		/obj/item/trash,
		/obj/item/weapon/reagent_containers/cooking_container
		)

/obj/item/weapon/gripper/gravekeeper	//Used for handling grave things, flowers, etc.
	name = "grave gripper"
	icon_state = "gripper"
	desc = "A specialized grasping tool used in the preparation and maintenance of graves."

	can_hold = list(
		/obj/item/seeds,
		/obj/item/weapon/grown,
		/obj/item/weapon/material/gravemarker
		)

/obj/item/weapon/gripper/no_use/organ
	name = "organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used to preserve and manipulate organic material."

	can_hold = list(
		/obj/item/organ
		)

/obj/item/weapon/gripper/no_use/organ/Entered(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 1
		for(var/obj/item/organ/organ in O)
			organ.preserved = 1
	..()

/obj/item/weapon/gripper/no_use/organ/Exited(var/atom/movable/AM)
	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = 0
		for(var/obj/item/organ/organ in O)
			organ.preserved = 0
	..()

/obj/item/weapon/gripper/no_use/organ/robotics
	name = "robotics organ gripper"
	icon_state = "gripper-flesh"
	desc = "A specialized grasping tool used in robotics work."

	can_hold = list(
		/obj/item/organ/external,
		/obj/item/organ/internal/brain, //to insert into MMIs,
		/obj/item/organ/internal/cell,
		/obj/item/organ/internal/eyes/robot
		)

/obj/item/weapon/gripper/no_use/mech
	name = "exosuit gripper"
	icon_state = "gripper-mech"
	desc = "A large, heavy-duty grasping tool used in construction of mechs."

	can_hold = list(
		/obj/item/mecha_parts/part,
		/obj/item/mecha_parts/micro/part,		//VOREStation Edit: Allow construction of micromechs,
		/obj/item/mecha_parts/mecha_equipment,
		/obj/item/mecha_parts/mecha_tracking,
		/obj/item/mecha_parts/component
		)

/obj/item/weapon/gripper/no_use //Used when you want to hold and put items in other things, but not able to 'use' the item

/obj/item/weapon/gripper/no_use/attack_self(mob/user as mob)
	return

/obj/item/weapon/gripper/no_use/loader //This is used to disallow building with metal.
	name = "sheet loader"
	desc = "A specialized loading device, designed to pick up and insert sheets of materials inside machines."
	icon_state = "gripper-sheet"

	can_hold = list(
		/obj/item/stack/material
		)

/obj/item/weapon/gripper/attack_self(mob/user as mob)
	if(wrapped)
		return wrapped.attack_self(user)
	return ..()

/obj/item/weapon/gripper/attackby(var/obj/item/O, var/mob/user)
	if(wrapped) // We're interacting with the item inside. If you can hold a cup with 2 fingers and stick a straw in it, you could do that with a gripper and another robotic arm.
		wrapped.loc = src.loc
		var/resolved = wrapped.attackby(O, user)
		if(QDELETED(wrapped) || wrapped.loc != src.loc)	 //Juuuust in case.
			wrapped = null
		if(!resolved && wrapped && O)
			O.afterattack(wrapped,user,1)
			if(QDELETED(wrapped) || wrapped.loc != src.loc)	 // I don't know of a nicer way to do this.
				wrapped = null
		if(wrapped)
			wrapped.loc = src
		return resolved
	return ..()

/obj/item/weapon/gripper/verb/drop_gripper_item()

	set name = "Drop Item"
	set desc = "Release an item from your magnetic gripper."
	set category = "Robot Commands"

	drop_item()

/obj/item/weapon/gripper/proc/drop_item()
	if(!wrapped)
		//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
		for(var/obj/item/thing in src.contents)
			thing.loc = get_turf(src)
		return

	if(wrapped.loc != src)
		wrapped = null
		return

	to_chat(src.loc, "<span class='notice'>You drop \the [wrapped].</span>")
	wrapped.loc = get_turf(src)
	wrapped = null
	//update_icon()

/obj/item/weapon/gripper/proc/drop_item_nm()

	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			thing.loc = get_turf(src)
		return

	if(wrapped.loc != src)
		wrapped = null
		return

	wrapped.loc = get_turf(src)
	wrapped = null
	//update_icon()

/obj/item/weapon/gripper/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(wrapped) 	//The force of the wrapped obj gets set to zero during the attack() and afterattack().
		force_holder = wrapped.force
		wrapped.force = 0.0
		if(QDELETED(wrapped) || wrapped.loc != src.loc)	 //qdel check here so it doesn't duplicate/spawn ghost items
			wrapped = null
		else
			wrapped.loc = src.loc //To ensure checks pass.
			wrapped.attack(M,user)
			M.attackby(wrapped, user)	//attackby reportedly gets procced by being clicked on, at least according to Anewbe.
			if(QDELETED(wrapped) || wrapped.loc != src.loc)
				wrapped = null
			if(wrapped) //In the event nothing happened to wrapped, go back into the gripper.
				wrapped.loc = src
			return 1
	return 0

/obj/item/weapon/gripper/afterattack(var/atom/target, var/mob/living/user, proximity, params)

	if(!proximity)
		return // This will prevent them using guns at range but adminbuse can add them directly to modules, so eh.

	//There's some weirdness with items being lost inside the arm. Trying to fix all cases. ~Z
	if(!wrapped)
		for(var/obj/item/thing in src.contents)
			wrapped = thing
			break

	if(wrapped) //Already have an item.
		//Temporary put wrapped into user so target's attackby() checks pass.
		wrapped.loc = user

		//Pass the attack on to the target. This might delete/relocate wrapped.
		var/resolved = target.attackby(wrapped,user)
		if(!resolved && wrapped && target)
			wrapped.afterattack(target,user,1)

		//wrapped's force was set to zero.  This resets it to the value it had before.
		if(wrapped)
			wrapped.force = force_holder
		force_holder = null
		//If wrapped was neither deleted nor put into target, put it back into the gripper.
		if(wrapped && user && (wrapped.loc == user))
			wrapped.loc = src
		else
			wrapped = null
			return

	else if(istype(target,/obj/item)) //Check that we're not pocketing a mob.

		//...and that the item is not in a container.
		if(!isturf(target.loc))
			return

		var/obj/item/I = target

		if(I.anchored)
			to_chat(user,"<span class='notice'>You are unable to lift \the [I] from \the [I.loc].</span>")
			return

		//Check if the item is blacklisted.
		var/grab = 0
		for(var/typepath in can_hold)
			if(istype(I,typepath))
				grab = 1
				break

		//We can grab the item, finally.
		if(grab)
			to_chat(user, "You collect \the [I].")
			I.loc = src
			wrapped = I
			return
		else
			to_chat(user, "<span class='danger'>Your gripper cannot hold \the [target].</span>")

	else if(istype(target,/obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(A.opened)
			if(A.cell)

				wrapped = A.cell

				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.cell.loc = src
				A.cell = null

				A.charging = 0
				A.update_icon()

				user.visible_message("<span class='danger'>[user] removes the power cell from [A]!</span>", "You remove the power cell.")

	else if(istype(target,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/A = target
		if(A.opened)
			if(A.cell)

				wrapped = A.cell

				A.cell.add_fingerprint(user)
				A.cell.update_icon()
				A.updateicon()
				A.cell.loc = src
				A.cell = null

				user.visible_message("<span class='danger'>[user] removes the power cell from [A]!</span>", "You remove the power cell.")

//TODO: Matter decompiler.
/obj/item/weapon/matter_decompiler

	name = "matter decompiler"
	desc = "Eating trash, bits of glass, or other debris will replenish your stores."
	icon = 'icons/obj/device.dmi'
	icon_state = "decompiler"

	//Metal, glass, wood, plastic.
	var/datum/matter_synth/metal = null
	var/datum/matter_synth/glass = null
	var/datum/matter_synth/wood = null
	var/datum/matter_synth/plastic = null

/obj/item/weapon/matter_decompiler/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/weapon/matter_decompiler/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity, params)

	if(!proximity) return //Not adjacent.

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(target)
	if(!istype(T))
		return

	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M,/mob/living/simple_mob/animal/passive/lizard) || istype(M,/mob/living/simple_mob/animal/passive/mouse))
			src.loc.visible_message("<span class='danger'>[src.loc] sucks [M] into its decompiler. There's a horrible crunching noise.</span>","<span class='danger'>It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises.</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return

		else if(istype(M,/mob/living/silicon/robot/drone) && !M.client)

			var/mob/living/silicon/robot/D = src.loc

			if(!istype(D))
				return

			to_chat(D, "<span class='danger'>You begin decompiling [M].</span>")

			if(!do_after(D,50))
				to_chat(D, "<span class='danger'>You need to remain still while decompiling such a large object.</span>")
				return

			if(!M || !D) return

			to_chat(D, "<span class='danger'>You carefully and thoroughly decompile [M], storing as much of its resources as you can within yourself.</span>")
			qdel(M)
			new/obj/effect/decal/cleanable/blood/oil(get_turf(src))

			if(metal)
				metal.add_charge(15000)
			if(glass)
				glass.add_charge(15000)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(1000)
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/item/trash/cigbutt))
			if(plastic)
				plastic.add_charge(500)
		else if(istype(W,/obj/effect/spider/spiderling))
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
		else if(istype(W,/obj/item/weapon/light))
			var/obj/item/weapon/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				if(metal)
					metal.add_charge(250)
				if(glass)
					glass.add_charge(250)
			else
				continue
		else if(istype(W,/obj/effect/decal/remains/robot))
			if(metal)
				metal.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/trash))
			if(metal)
				metal.add_charge(1000)
			if(plastic)
				plastic.add_charge(3000)
		else if(istype(W,/obj/effect/decal/cleanable/blood/gibs/robot))
			if(metal)
				metal.add_charge(2000)
			if(glass)
				glass.add_charge(2000)
		else if(istype(W,/obj/item/ammo_casing))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/weapon/material/shard/shrapnel))
			if(metal)
				metal.add_charge(1000)
		else if(istype(W,/obj/item/weapon/material/shard))
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/grown))
			if(wood)
				wood.add_charge(4000)
		else if(istype(W,/obj/item/pipe))
			// This allows drones and engiborgs to clear pipe assemblies from floors.
		else
			continue

		qdel(W)
		grabbed_something = 1

	if(grabbed_something)
		to_chat(user, "<span class='notice'>You deploy your decompiler and clear out the contents of \the [T].</span>")
	else
		to_chat(user, "<span class='danger'>Nothing on \the [T] is useful to you.</span>")
	return

//PRETTIER TOOL LIST.
/mob/living/silicon/robot/drone/installed_modules()

	if(weapon_lock)
		to_chat(src, "<span class='danger'>Weapon lock active, unable to use modules! Count:[weaponlock_time]</span>")
		return

	if(!module)
		module = new /obj/item/weapon/robot_module/drone(src)

	var/dat = "<HEAD><TITLE>Drone modules</TITLE></HEAD><BODY>\n"
	dat += {"
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_1]>[module_state_1]<A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_2]>[module_state_2]<A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A HREF=?src=\ref[src];mod=\ref[module_state_3]>[module_state_3]<A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}


	var/tools = "<B>Tools and devices</B><BR>"
	var/resources = "<BR><B>Resources</B><BR>"

	for (var/O in module.modules)

		var/module_string = ""

		if (!O)
			module_string += text("<B>Resource depleted</B><BR>")
		else if(activated(O))
			module_string += text("[O]: <B>Activated</B><BR>")
		else
			module_string += text("[O]: <A HREF=?src=\ref[src];act=\ref[O]>Activate</A><BR>")

		if((istype(O,/obj/item/weapon) || istype(O,/obj/item/device)) && !(istype(O,/obj/item/stack/cable_coil)))
			tools += module_string
		else
			resources += module_string

	dat += tools

	if (emagged)
		if (!module.emag)
			dat += text("<B>Resource depleted</B><BR>")
		else if(activated(module.emag))
			dat += text("[module.emag]: <B>Activated</B><BR>")
		else
			dat += text("[module.emag]: <A HREF=?src=\ref[src];act=\ref[module.emag]>Activate</A><BR>")

	dat += resources

	src << browse(dat, "window=robotmod")
