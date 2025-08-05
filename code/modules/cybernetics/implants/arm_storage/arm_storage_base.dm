/*
Arm storage. Toolbox, Medical tools. Cable. Weapons. Etc.
Items are set up with a component to return to the implant if ever dropped.
*/

/obj/item/endoware/item_storage
	name = "Integrated Storage"
	desc = "A long, thin implant usually embedded in the user's forearm during installation, acting as a supplement to the bone."


	var/list/starts_with = list()
	var/list/stored_items = list()

	var/list/accepted_item_types = list() //don't need to worry about this if we're doing a "premade" list
	allowed_in = list(BP_L_ARM,BP_R_ARM)
	var/sticky_mode = TRUE //if we're using preset items, we use the "on drop, return to me" behavior
	is_activatable = TRUE
	image_text = "DEPLOY"

/obj/item/endoware/item_storage/Initialize(mapload)
	. = ..()
	for(var/type in starts_with)
		var/obj/item/x = new type()
		x.forceMove(src)
		stored_items += x

/obj/item/endoware/item_storage/Destroy()
	. = ..()
	for(var/obj/item/i in stored_items)
		if(i.loc == src) qdel(i)
		else LAZYREMOVE(stored_items,i)
	stored_items = null


	//networkNode = new /datum/commandline_network_node/endoware/item_storage()
//	networkNode.assigned_to = src
//	networkNode.Initialize()
/obj/item/endoware/item_storage/proc/isLeftie()
	if(!installed_in || installed_in == "") return FALSE //I guess?
	return installed_in[1] == "l"

/obj/item/endoware/item_storage/proc/gen_radial_icons()
	if(LAZYLEN(stored_items) == 0) return
	var/list/options = list()
	for(var/obj/item/x in stored_items)
		options["\ref[x]"] = image(x,dir=SOUTH)
	return options

/obj/item/endoware/item_storage/activate(external)
	if(!ishuman(host)) return ..()

	var/obj/item/held = (isLeftie())? host.l_hand : host.r_hand
	if(held)
		to_chat(host,span_warning("Your [(isLeftie())? "Left Hand" : "Right Hand"]'s already occupied!"))
		return

	var/list/options = gen_radial_icons()
	var/choice = show_radial_menu(host, host, options, require_near = TRUE)
	if(choice == null)
		return
	var/obj/item/found = locate(choice) in stored_items
	if(!found)
		to_chat(host,span_warning("Could not find item!"))
		return

	if(isLeftie())
		host.put_in_l_hand(found)
	else host.put_in_r_hand(found)

	//check if host has full hand, if so, play sad buzz.
	//if external, pick a random one to slot in
	//otherwise, slot stuff up
	. = ..()

/obj/item/endoware/item_storage/added_to_human(mob/living/carbon/human/human)
	.=..()
	if(sticky_mode)
		for(var/obj/item/x in stored_items)
			x.AddComponent(/datum/component/bind_to_hand,home_ref = src,secondary_ref = host, message_to_display = get_return_message(x,human), message_updater = CALLBACK(src,PROC_REF(get_return_message)) , left_handed = isLeftie())

/obj/item/endoware/item_storage/proc/get_return_message(var/obj/item/returning,var/mob/user)
	return span_notice("[returning] snaps back into its slot!")

/obj/item/endoware/item_storage/proc/get_deploy_message(var/obj/item/deploying, var/mob/user)
	return span_notice("[user] deploys [deploying] from their [src]!")
