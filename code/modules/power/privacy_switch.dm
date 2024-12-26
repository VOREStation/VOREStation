/obj/structure/privacyswitch
	name = "privacy switch"
	desc = "A special switch to increase the room's privavy. (Blocks ghosts from seeing the area)"
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "light0"
	var/nextUse = 0

/obj/structure/privacyswitch/Initialize()
	var/area/A = get_area(src)
	if(A?.flag_check(AREA_BLOCK_GHOST_SIGHT))
		icon_state = "light1"
	. = ..()

/obj/structure/privacyswitch/attack_ai(mob/user)
	attack_hand()
	return

/obj/structure/privacyswitch/attack_hand(mob/user)
	if(nextUse - world.time > 0)
		to_chat(user, span_warning("The area can not be altered so soon again!"))
		return
	var/area/A = get_area(src)
	if(!A)
		return

	if(tgui_alert(user, "Do you want to toggle ghost vision for this area [A.flag_check(AREA_BLOCK_GHOST_SIGHT) ? "on" : "off"]?", "Toggle ghost vision?", list("Yes", "No")) != "Yes")
		return

	if(A.flag_check(AREA_BLOCK_GHOST_SIGHT))
		A.flags ^= AREA_BLOCK_GHOST_SIGHT
		icon_state = "light0"
		ghostnet.removeArea(A)
		to_chat(user, span_notice("The area is no longer protected from ghost vison."))
		log_and_message_admins("toggled ghost vision in [A] on.", user)
	else
		A.flags ^= AREA_BLOCK_GHOST_SIGHT
		icon_state = "light1"
		ghostnet.addArea(A)
		to_chat(user, span_notice("The area is now protected from ghost vison."))
		log_and_message_admins("toggled ghost vision in [A] off.", user)
	nextUse = world.time + 5 MINUTES
