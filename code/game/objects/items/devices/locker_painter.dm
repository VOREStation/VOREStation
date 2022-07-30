/obj/item/closet_painter
	name = "closet painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"

	var/colour =        "plain"
	var/colour_secure = "plain"

	var/list/colours = list(
		"plain" = 				list("open" = "open", "closed" = "closed"),
		"blue" = 				list("open" = "open", "closed" = "blue"),
		"mixed" = 				list("open" = "open", "closed" = "mixed"),
		"grey" = 				list("open" = "open", "closed" = "grey"),
		"green" = 				list("open" = "open", "closed" = "green"),
		"orange" = 				list("open" = "open", "closed" = "orange"),
		"pink" = 				list("open" = "open", "closed" = "pink"),
		"red" = 				list("open" = "open", "closed" = "red"),
		"white" = 				list("open" = "open", "closed" = "white"),
		"yellow" = 				list("open" = "open", "closed" = "yellow"),
		"black" = 				list("open" = "open", "closed" = "black"),
		"bio" = 				list("open" = "bioopen", "closed" = "bio"),
		"bio-virology" = 		list("open" = "bio_virologyopen", "closed" = "bio_virology"),
		"bio-security" = 		list("open" = "bio_securityopen", "closed" = "bio_security"),
		"bio-janitor" = 		list("open" = "bio_janitoropen", "closed" = "bio_janitor"),
		"bio-scientist" = 		list("open" = "bio_scientistopen", "closed" = "bio_scientist"),
		"bombsuit" = 			list("open" = "bombsuitopen", "closed" = "bombsuit"),
		"bombsuit-security" = 	list("open" = "bombsuitsecopen", "closed" = "bombsuitsec"),
		"full-red" = 			list("open" = "syndicateopen", "closed" = "syndicate"),
		"full-green" = 			list("open" = "syndicate1open", "closed" = "syndicate1"),
		"full-purple" = 		list("open" = "aclosetopen", "closed" = "acloset"),
		"mining" = 				list("open" = "miningopen", "closed" = "mining"),
		"emergency" = 			list("open" = "emergencyopen", "closed" = "emergency"),
		"fire" = 				list("open" = "fireclosetopen", "closed" = "firecloset"),
		"tool" = 				list("open" = "toolclosetopen", "closed" = "toolcloset"),
		"radiation" = 			list("open" = "toolclosetopen", "closed" = "radsuitcloset")
		)

	var/list/colours_secure = list(
		"plain" = 				list("open" = "open", "closed" = "secure", "locked" = "secure1", "broken" = "securebroken", "off" = "secureoff"),
		"medical-red" = 		list("open" = "medicalopen", "closed" = "medical", "locked" = "medical1", "broken" = "medicalbroken", "off" = "medicaloff"),
		"medical-green" = 		list("open" = "securemedopen", "closed" = "securemed", "locked" = "securemed1", "broken" = "securemedbroken", "off" = "securemedoff"),
		"CMO" = 				list("open" = "cmosecureopen", "closed" = "cmosecure", "locked" = "cmosecure1", "broken" = "cmosecurebroken", "off" = "cmosecureoff"),
		"cargo" = 				list("open" = "securecargoopen", "closed" = "securecargo", "locked" = "securecargo1", "broken" = "securecargobroken", "off" = "securecargooff"),
		"mining" = 				list("open" = "miningsecopen", "closed" = "miningsec", "locked" = "miningsec1", "broken" = "miningsecbroken", "off" = "miningsecoff"),
		"QM" = 					list("open" = "secureqmopen", "closed" = "secureqm", "locked" = "secureqm1", "broken" = "secureqmbroken", "off" = "secureqmoff"),
		"hydroponics" = 		list("open" = "hydrosecureopen", "closed" = "hydrosecure", "locked" = "hydrosecure1", "broken" = "hydrosecurebroken", "off" = "hydrosecureoff"),
		"atmospherics" = 		list("open" = "secureatmopen", "closed" = "secureatm", "locked" = "secureatm1", "broken" = "secureatmbroken", "off" = "secureatmoff"),
		"engineer" = 			list("open" = "secureengopen", "closed" = "secureeng", "locked" = "secureeng1", "broken" = "secureengbroken", "off" = "secureengoff"),
		"CE" = 					list("open" = "secureceopen", "closed" = "securece", "locked" = "securece1", "broken" = "securecebroken", "off" = "secureceoff"),
		"electrical" = 			list("open" = "toolclosetopen", "closed" = "secureengelec", "locked" = "secureengelec1", "broken" = "secureengelecbroken", "off" = "secureengelecoff"),
		"welding" = 			list("open" = "toolclosetopen", "closed" = "secureengweld", "locked" = "secureengweld1", "broken" = "secureengweldbroken", "off" = "secureengweldoff"),
		"research" = 			list("open" = "secureresopen", "closed" = "secureres", "locked" = "secureres1", "broken" = "secureresbroken", "off" = "secureresoff"),
		"RD" = 					list("open" = "rdsecureopen", "closed" = "rdsecure", "locked" = "rdsecure1", "broken" = "rdsecurebroken", "off" = "rdsecureoff"),
		"security" = 			list("open" = "secopen", "closed" = "sec", "locked" = "sec1", "broken" = "secbroken", "off" = "secoff"),
		"warden" = 				list("open" = "wardensecureopen", "closed" = "wardensecure", "locked" = "wardensecure1", "broken" = "wardensecurebroken", "off" = "wardensecureoff"),
		"HoS" = 				list("open" = "hossecureopen", "closed" = "hossecure", "locked" = "hossecure1", "broken" = "hossecurebroken", "off" = "hossecureoff"),
		"HoP" = 				list("open" = "hopsecureopen", "closed" = "hopsecure", "locked" = "hopsecure1", "broken" = "hopsecurebroken", "off" = "hopsecureoff"),
		"Administrator" = 			list("open" = "capsecureopen", "closed" = "capsecure", "locked" = "capsecure1", "broken" = "capsecurebroken", "off" = "capsecureoff")
		)

	var/forbidden_types = list(
		/obj/structure/closet/alien,
		/obj/structure/closet/body_bag,
		/obj/structure/closet/cabinet,
		/obj/structure/closet/crate,
		/obj/structure/closet/coffin,
		/obj/structure/closet/hydrant,
		/obj/structure/closet/medical_wall,
		/obj/structure/closet/statue,
		/obj/structure/closet/walllocker
		)

/obj/item/closet_painter/afterattack(atom/A, var/mob/user, proximity)
	if(!proximity)
		return

	var/non_closet = 0
	if(!istype(A,/obj/structure/closet))
		non_closet = 1
	for(var/ctype in forbidden_types)
		if(istype(A,ctype))
			non_closet = 1
	if(non_closet)
		to_chat(user, "<span class='warning'>\The [src] can only be used on closets.</span>")
		return

	var/config_error

	if(istype(A,/obj/structure/closet/secure_closet))
		var/obj/structure/closet/secure_closet/F = A
		if(F.broken)
			to_chat(user, "<span class='warning'>\The [src] cannot paint broken closets.</span>")
			return

		var/list/colour_data = colours_secure[colour_secure]
		if(!islist(colour_data))
			config_error = 1
		if(!config_error)
			F.icon_opened = colour_data["open"]
			F.icon_closed = colour_data["closed"]
			F.icon_locked = colour_data["locked"]
			F.icon_broken = colour_data["broken"]
			F.icon_off = colour_data["off"]
			F.update_icon()

	else
		var/obj/structure/closet/F = A
		var/list/colour_data = colours[colour]
		if(!islist(colour_data))
			config_error = 1
		if(!config_error)
			F.icon_opened = colour_data["open"]
			F.icon_closed = colour_data["closed"]
			F.update_icon()

	if(config_error)
		to_chat(user, "<span class='warning'>\The [src] flashes an error light. You might need to reconfigure it.</span>")
		return

/obj/item/closet_painter/attack_self(var/mob/user)
	var/choice = tgui_alert(usr, "Do you wish to change the regular closet color or the secure closet color?", "Color Selection", list("Regular Closet Colour","Cancel","Secure Closet Colour"))
	if(choice == "Regular Closet Colour")
		choose_colour()
	else if(choice == "Secure Closet Colour")
		choose_colour_secure()

/obj/item/closet_painter/examine(mob/user)
	. = ..()
	. += "It is configured to produce the '[colour]' paint scheme or the '[colour_secure]' secure closet paint scheme."

/obj/item/closet_painter/verb/choose_colour()
	set name = "Choose Colour"
	set desc = "Choose a regular closet painter colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_colour = tgui_input_list(usr, "Select a color:", "Color Selection", colours)
	if(new_colour && !isnull(colours[new_colour]))
		colour = new_colour
		to_chat(usr, "<span class='notice'>You set \the [src] regular closet colour to '[colour]'.</span>")

/obj/item/closet_painter/verb/choose_colour_secure()
	set name = "Choose Secure Colour"
	set desc = "Choose a secure closet painter colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	var/new_colour_secure = tgui_input_list(usr, "Select a color:", "Color Selection", colours_secure)
	if(new_colour_secure && !isnull(colours_secure[new_colour_secure]))
		colour_secure = new_colour_secure
		to_chat(usr, "<span class='notice'>You set \the [src] secure closet colour to '[colour_secure]'.</span>")
