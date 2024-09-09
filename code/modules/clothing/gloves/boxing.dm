/obj/item/clothing/gloves/boxing
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state_slots = list(slot_r_hand_str = "red", slot_l_hand_str = "red")

/*
/obj/item/clothing/gloves/boxing/attackby(obj/item/W, mob/user)
	if(W.has_tool_quality(TOOL_WIRECUTTER) || istype(W, /obj/item/surgical/scalpel))
		to_chat(user, "<span class='notice'>That won't work.</span>")	//Nope
		return
	..()
*/

/obj/item/clothing/gloves/boxing/green
	icon_state = "boxinggreen"
	item_state_slots = list(slot_r_hand_str = "green", slot_l_hand_str = "green")

/obj/item/clothing/gloves/boxing/blue
	icon_state = "boxingblue"
	item_state_slots = list(slot_r_hand_str = "blue", slot_l_hand_str = "blue")

/obj/item/clothing/gloves/boxing/yellow
	icon_state = "boxingyellow"
	item_state_slots = list(slot_r_hand_str = "yellow", slot_l_hand_str = "yellow")

/obj/item/clothing/gloves/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "latex"
	item_state_slots = list(slot_r_hand_str = "white", slot_l_hand_str = "white")
