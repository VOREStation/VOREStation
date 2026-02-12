//This is used to check if the gripper is currently being used.
//If it is, we don't allow any other actions to be performed.
//Returns TRUE if we're in use explaining how.
/obj/item/gripper/proc/is_in_use(mob/user, visible = TRUE)
	if(gripper_in_use)
		if(visible)
			to_chat(user, span_danger("You are currently using the gripper on something!"))
		return TRUE

	if(in_radial_menu)
		if(visible)
			to_chat(user, span_danger("You are currently in the radial menu! Close it to use the gripper."))
		return TRUE
	return FALSE

/obj/item/gripper/proc/update_ref(var/datum/weakref/new_ref)
	var/had_item = get_wrapped_item()
	WR = new_ref
	var/holding_item = get_wrapped_item()
	// Feedback
	update_icon()

	if(had_item && !holding_item) // Dropped
		our_robot.playsound_local(get_turf(our_robot), 'sound/machines/click.ogg', 50)
		return

	if(holding_item && !had_item || (holding_item != had_item)) // Pickup or change item
		our_robot.playsound_local(get_turf(our_robot), 'sound/machines/click2.ogg', 50)

///Stops the gripper from being used multiple times when we're performing a do_after
/obj/item/gripper/proc/begin_using()
	gripper_in_use = TRUE

///Allows use of the gripper (and clears the weakref) after do_after is completed. Clears the weakref if the wrapped item is no longer in our borg's contents (items get moved into the borgs contents when using the gripper)
/obj/item/gripper/proc/end_using()
	gripper_in_use = FALSE
	var/obj/item/wrapped = get_wrapped_item()
	if(!wrapped)
		return
	//Checks two things:
	//Is our wrapped object currently in our borg still?
	//AND Is it not a gripper pocket? If not, reset WR.
	if(item_left_gripper(wrapped))
		update_ref(null)

//This is the code that updates our pockets and decides if they should have icons or not.
//This should be called every time we use the gripper and our wrapped item is used up.
/obj/item/gripper/proc/generate_icons()
	if(LAZYLEN(pockets))

		pockets_by_name = list()

		photo_images = list()

		for(var/obj/item/storage/internal/gripper/pocket_to_check in pockets)
			if(!LAZYLEN(pocket_to_check.contents))
				pockets_by_name[pocket_to_check.name] = pocket_to_check
				photo_images[pocket_to_check.name] = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing")
				continue
			var/obj/item/pocket_content = pocket_to_check.contents[1]
			pockets_by_name["[pocket_to_check.name]" + "[pocket_content.name]"] = pocket_content
			var/image/pocket_image = image(icon = pocket_content.icon, icon_state = pocket_content.icon_state)
			if(pocket_content.color)
				pocket_image.color = pocket_content.color
			if(pocket_content.overlays)
				for(var/overlay in pocket_content.overlays)
					pocket_image.overlays += overlay
			photo_images["[pocket_to_check.name]" + "[pocket_content.name]"] = pocket_image

/obj/item/gripper/attack_self(mob/user)
	. = ..()
	if(.)
		return TRUE
	if(special_handling)
		return FALSE
	if(is_in_use(user))
		return FALSE

	generate_icons()

	var/list/options = list()

	for(var/Iname in pockets_by_name)
		options[Iname] = photo_images[Iname]

	var/list/choice = list()

	in_radial_menu = TRUE
	choice = show_radial_menu(user, src, options, radius = 40, require_near = TRUE, autopick_single_option = FALSE)
	in_radial_menu = FALSE

	var/obj/item/wrapped = get_wrapped_item()
	if(choice)
		var/obj/item/storage/internal/gripper/selected_pocket = pockets_by_name[choice]
		if(!isgripperpocket(selected_pocket)) //The pocket we're selecting is NOT a gripper storage
			if(!isgripperpocket(selected_pocket.loc)) //We kept the radial menu opened, used the item, then selected it again.
				clear_and_select_pocket() //Pick the next open pocket.
				return

			update_ref(WEAKREF(selected_pocket))
			return

		current_pocket = selected_pocket
		update_ref(null)
		return

	if(wrapped)
		return wrapped.attack_self(user)

/obj/item/gripper/attackby(var/obj/item/O, var/mob/user)
	if(is_in_use(user))
		return FALSE

	var/obj/item/wrapped = get_wrapped_item()
	if(wrapped)
		wrapped.loc = loc //Place it in to the robot.
		var/resolved = wrapped.attackby(O, user)
		wrapped = get_wrapped_item() //We check to see if the object exists after we do attackby.

		//The object has been deleted. Select a new pocket and stop here.
		if(!wrapped)
			clear_and_select_pocket()
			return FALSE

		//Object is not in our contents AND is not in the gripper storage still. AKA, it was moved into something or somewhere. Either way, it's not ours anymore.
		if(item_left_gripper(wrapped))
			clear_and_select_pocket()
			return TRUE

		//We were not given a resolved, the object still exists, AND we hit something. Attack that thing with our wrapped item.
		if(!resolved && wrapped && O)
			O.afterattack(wrapped,user,1)
			wrapped = get_wrapped_item()
			//The object still exists, but is not in our contents OR back in the gripper storage.
			if(item_left_gripper(wrapped))
				clear_and_select_pocket()
			return TRUE

		//Nothing happened to it. Just put it back into our pocket.
		wrapped.loc = current_pocket
		return TRUE

	return ..()

/obj/item/gripper/afterattack(atom/target, mob/living/user, proximity, params)
	if(!proximity)
		return // This will prevent them using guns at range but adminbuse can add them directly to modules, so eh.

	if(is_in_use(user))
		return

	var/obj/item/wrapped = get_wrapped_item()
	if(wrapped && item_left_gripper(wrapped)) // This is used for items that are moved out during other attack chains
		clear_and_select_item()
		return

	if(use_item(target, user, wrapped)) //Already have an item.
		return
	update_ref(WEAKREF(wrapped))

	if(pick_up_item(target, user))
		return

	if(handle_afterattack_special(target, user))
		return

	if(item_left_gripper(wrapped))
		clear_and_select_item()

/obj/item/gripper/proc/use_item(atom/target, mob/user, obj/item/wrapped)
	if(!wrapped)
		return FALSE

	var/obj/item/storage/internal/gripper/previous_pocket
	if(isgripperpocket(wrapped.loc))
		previous_pocket = wrapped.loc
	else
		previous_pocket = current_pocket

	var/original_amount = 0
	if(istype(wrapped, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/wrapped_container = wrapped
		original_amount = wrapped_container.reagents?.total_volume

	wrapped.loc = user

	var/resolved = target.attackby(wrapped, user)
	if(!resolved && wrapped && target)
		wrapped.afterattack(target, user, TRUE)

	if(item_left_gripper(wrapped))
		clear_and_select_pocket()
		return TRUE

	if(istype(wrapped, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/wrapped_container = wrapped
		if(wrapped_container.reagents?.total_volume != original_amount || (istype(target, /obj/item/reagent_containers)))
			wrapped.loc = previous_pocket
			update_ref(WEAKREF(wrapped))
			return TRUE

	wrapped.loc = previous_pocket
	update_ref(WEAKREF(wrapped))
	return FALSE

/obj/item/gripper/proc/pick_up_item(atom/target, mob/user)
	if(!isitem(target))
		return FALSE

	var/obj/item/I = target

	if(!isturf(I.loc))
		return FALSE

	if(I.anchored)
		to_chat(user, span_notice("You are unable to lift \the [I]."))
		return FALSE

	var/obj/item/storage/internal/gripper/selected_pocket = find_empty_pocket()
	if(!selected_pocket)
		to_chat(user, "Your gripper is full!")
		return FALSE

	if(!is_type_in_list(I, can_hold))
		to_chat(user, span_danger("Your gripper cannot hold \the [I]."))
		return FALSE

	to_chat(user, "You collect \the [I].")
	I.loc = selected_pocket
	current_pocket = selected_pocket
	update_ref(WEAKREF(I))
	return TRUE

/obj/item/gripper/proc/handle_afterattack_special(atom/target, mob/living/user)
	if(istype(target, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = target
		if(!A.opened)
			return TRUE

		if(!A.cell || !is_type_in_list(A.cell, can_hold))
			return TRUE

		if(!grab_cell(A.cell, user))
			return TRUE

		A.cell = null
		A.charging = FALSE
		A.update_icon()

		user.visible_message(
			span_danger("[user] removes the power cell from [A]!"),
			"You remove the power cell."
		)

		return TRUE

	if(isrobot(target))
		var/mob/living/silicon/robot/A = target
		if(!A.opened)
			return TRUE

		if(!A.cell || !is_type_in_list(A.cell, can_hold))
			return TRUE

		if(!grab_cell(A.cell, user))
			return TRUE

		var/datum/robot_component/cell_component = A.components["power cell"]


		A.cell = null
		cell_component.uninstall(TRUE)
		A.update_icon()

		user.visible_message(
			span_danger("[user] removes the power cell from [A]!"),
			"You remove the power cell."
		)

		return TRUE

	return FALSE

/// Returns the first empty gripper pocket, or null
/obj/item/gripper/proc/find_empty_pocket()
	for(var/obj/item/storage/internal/gripper/P in pockets)
		if(!LAZYLEN(P.contents))
			return P
	return null

/// Returns TRUE if item is no longer in the gripper
/obj/item/gripper/proc/item_left_gripper(obj/item/I)
	if(QDELETED(I))
		return TRUE

	if(isgripperpocket(I.loc))
		return FALSE

	if(I.loc == loc)
		return FALSE

	return TRUE


/// Sets current_pocket to a valid pocket (never an item)
/obj/item/gripper/proc/select_pocket(obj/item/storage/internal/gripper/P)
	if(!P)
		P = pick(pockets)

	current_pocket = P

/// Clears the currently wrapped item and selects the pocket
/obj/item/gripper/proc/clear_and_select_pocket()
	update_ref(null)
	select_empty_pocket()

/// Clears the currently wrapped item and selects next item
/obj/item/gripper/proc/clear_and_select_item()
	update_ref(null)
	select_next_item()

/// Selects the first empty pocket, or a random one
/obj/item/gripper/proc/select_empty_pocket()
	var/obj/item/storage/internal/gripper/P = find_empty_pocket()
	select_pocket(P)

/obj/item/gripper/proc/select_next_item()
	for(var/obj/item/storage/internal/gripper/P in reverseList(pockets))
		if(!LAZYLEN(P.contents))
			continue
		var/obj/item/next_item = P.contents[1]
		update_ref(WEAKREF(next_item))
		return

/obj/item/gripper/proc/drop_item(mob/user)
	var/obj/item/wrapped = get_wrapped_item()
	if(!wrapped)
		to_chat(user, span_warning("You have nothing to drop!"))
		return

	if(is_in_use(user))
		return

	if((item_left_gripper(wrapped)))
		clear_and_select_pocket()
		generate_icons()
		return

	to_chat(user, span_notice("You drop \the [wrapped]."))
	wrapped.forceMove(get_turf(user))
	clear_and_select_pocket()
	generate_icons()

//FORCES the item onto the ground and resets.
/obj/item/gripper/proc/drop_item_nm(atom/taget)
	var/obj/item/wrapped = get_wrapped_item()
	if(!wrapped)
		return

	if((item_left_gripper(wrapped)))
		clear_and_select_pocket()
		generate_icons()
		return

	wrapped.forceMove(taget ? taget : get_turf(src))
	clear_and_select_pocket()
	generate_icons()

/obj/item/gripper/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(is_in_use(user))
		return FALSE

	var/obj/item/wrapped = get_wrapped_item()
	//The force of the wrapped obj gets set to zero during the attack() and afterattack().
	if(!wrapped)
		return FALSE

	//If our wrapper was deleted OR it's no longer in our internal gripper storage
	if(item_left_gripper(wrapped))
		update_ref(null)
		return FALSE

	wrapped.attack(M, user)
	//attackby reportedly gets procced by being clicked on, at least according to Anewbe.
	M.attackby(wrapped, user)

	//If our wrapper was deleted OR it's no longer in our internal gripper storage
	if(item_left_gripper(wrapped))
		update_ref(null)

	return TRUE

/obj/item/gripper/update_icon()
	cut_overlays()
	var/obj/item/wrapped = get_wrapped_item()
	if(!wrapped)
		return

	// Draw the held item as a mini-image in the gripper itself
	var/mutable_appearance/item_display = new(wrapped)
	item_display.SetTransform(0.75, offset_y = -8)
	item_display.pixel_x = 0
	item_display.pixel_y = 0
	item_display.plane = plane
	item_display.layer = layer + 0.01
	add_overlay(item_display)

//HELPER PROCS
///Use this to get what the current pocket is. Returns NULL if no
/obj/item/gripper/proc/get_wrapped_item() //done as a proc so snowflake code can be found later down the line and consolidated.
	var/obj/item/wrapped = WR?.resolve()
	return wrapped

/// Consolidates material stacks by searching our pockets to see if we currently have any stacks. Done in /obj/item/stack/attackby
/obj/item/gripper/proc/consolidate_stacks(var/obj/item/stack/stack_to_consolidate)
	if(!stack_to_consolidate || !istype(stack_to_consolidate, /obj/item/stack))
		return

	for(var/obj/item/storage/internal/gripper/pocket in pockets)
		if(!LAZYLEN(pocket.contents))
			continue
		for(var/obj/item/stack/stack in pocket.contents)
			if(istype(stack_to_consolidate, stack))
				stack_to_consolidate.transfer_to(stack)
				return

/obj/item/gripper/proc/grab_cell(obj/item/cell, mob/user)
	var/obj/item/storage/internal/gripper/P = find_empty_pocket()
	if(!P)
		to_chat(user, "Your gripper is full!")
		return FALSE

	cell.add_fingerprint(user)
	cell.update_icon()
	cell.forceMove(P)

	current_pocket = P
	update_ref(WEAKREF(cell))
	return TRUE
