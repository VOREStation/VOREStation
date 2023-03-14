/obj/item/communicator/desktop
	name = "desktop communicator"
	desc = "A static communicator unit, seen in homes, offices and the receptions of businesses across the galaxy."
	icon_state = "commstatic"
	anchored = 1
	static_name = "fixed communicator"
	can_rename = 0

/obj/item/communicator/desktop/attack_hand(mob/user)
	return attack_self(user)

/obj/item/communicator/desktop/initialize_exonet(mob/user)
	if(!static_name)
		return
	if(!exonet)
		exonet = new(src)
	if(!exonet.address)
		exonet.make_address("communicator-[static_name]")
	if(!node)
		node = get_exonet_node()
	populate_known_devices()

/obj/item/communicator/desktop/register_to_holder()
	if(!static_name)
		return ..()
	register_device(static_name)
	initialize_exonet()