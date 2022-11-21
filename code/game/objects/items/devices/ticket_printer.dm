/obj/item/device/ticket_printer
	name = "ticket printer"
	desc = "It prints security citations!"
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "sec_ticket_printer"
	var/print_cooldown = 1 MINUTE
	var/last_print

/obj/item/device/ticket_printer/attack_self(mob/user)
	. = ..()
	if(last_print + print_cooldown <= world.time)
		print_a_ticket(user)
	else
		to_chat(user, "<span class = 'warning'>\The [src] is not ready to print another ticket yet.</span>")

/obj/item/device/ticket_printer/proc/print_a_ticket(mob/user)

	var/ticket_name = sanitize(tgui_input_text(user, "The Name of the person you are issuing the ticket to.", "Name", max_length = 100))

	var/details = sanitize(tgui_input_text(user, "What is the ticket for? Avoid entering personally identafiable information in this section. (Max length: 200)", "Ticket Details", max_length = 200))

	var/turf/our_turf = get_turf(user)

	var/final = "<head><style>body {font-family: Verdana; background-color: #C1BDA3;}</style></head><center><h3>Nanotrasen Security Citation</h3><hr>This security citation has been issued to </br><big>[capitalize(ticket_name)]</big></center><b>Reason</b>:<br><i>[details]</i><hr><center><small>See your local representative at Central Command after the shift is over to resolve this issue.</small><br><img src = ntlogo.png></font></center>"

	var/obj/item/weapon/paper/sec_ticket/p = new /obj/item/weapon/paper/sec_ticket(our_turf)

	p.info = final
	p.name = "Security Citation: [ticket_name]"

	GLOB.security_tickets |= details
	GLOB.security_ticket_counter++
	log_and_message_admins("has issued '[ticket_name]' a security citation: \"[details]\"", user)
	last_print = world.time
	playsound(src, 'sound/items/ticket_printer.ogg', vary = TRUE)

/obj/item/weapon/paper/sec_ticket
	name = "Security Citation"
	desc = "A citation issued by security for some kind of infraction!"
	icon = 'icons/obj/bureaucracy_vr.dmi'
	icon_state = "sec_ticket"

/obj/item/weapon/paper/sec_ticket/Initialize(mapload, text, title)
	. = ..()
	icon = 'icons/obj/bureaucracy_vr.dmi'
	icon_state = "sec_ticket"

/obj/item/weapon/paper/sec_ticket/update_icon()
	icon = icon
	icon_state = icon_state
