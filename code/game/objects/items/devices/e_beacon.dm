/obj/item/device/emergency_beacon
	name = "personal emergency beacon"
	desc = "The hardy PersonaL Emergency Beacon, or PLEB, is a simple device that, once activated, sends out a wideband distress signal that can punch through almost all forms of interference. They are commonly issued to miners and remote exploration teams who may find themselves in need of means to call for assistance whilst being out of conventional communications range."
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "e_beacon_off"
	var/beacon_active = FALSE
	var/list/levels_for_distress

/obj/item/device/emergency_beacon/attack_self(mob/user)
	if(!beacon_active)
		var/answer = tgui_alert(user, "Would you like to activate this personal emergency beacon?","\The [src]", list("Yes", "No"))
		if(answer == "No")
			return
		else if(do_after(user, (5 SECONDS)))	//short delay, so they can still abort if they want to
			user.visible_message("<span class='warning'>[user] activates \the [src]!</span>","<span class='warning'>You activate \the [src]!</span>")
			beacon_active = TRUE
			icon_state = "e_beacon_active"
			admin_chat_message(message = "'[user?.ckey || "Unknown"]' activated a personal emergency beacon", color = "#FF2222") //VOREStation Add
			var/message = "This is an automated distress signal from a MIL-DTL-93352-compliant personal emergency beacon transmitting on [PUB_FREQ*0.1]kHz. \
			This beacon was activated in '\the [get_area(src)]' at X[src.loc.x],Y[src.loc.y]. Due to the limited signal strength, no further information can be provided at this time. \
			Per the Interplanetary Convention on Space SAR, those receiving this message must attempt rescue, \
			or relay the message to those who can."

			if(!levels_for_distress)
				levels_for_distress = list(1)
			for(var/zlevel in levels_for_distress)
				priority_announcement.Announce(message, new_title = "Automated Personal Distress Signal", new_sound = 'sound/AI/sos.ogg', zlevel = zlevel)
	else
		to_chat(user,"\The [src] is already active, or is otherwise malfunctioning. There's nothing you can do but wait. And possibly pray.")