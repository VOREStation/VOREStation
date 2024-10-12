/obj/item/clothing/mask/gas/sechailer
	name = "hailer face mask"
	desc = "A compact, durable gas mask that can be connected to an air supply. This one possesses a security hailer."
	description_info = "This mask has a hailer attached, you can activate it on the button or use the Halt! verb, for switching phrases you can alt+click it or change it using the change phrase verb."
	icon_state = "halfgas"
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 55, rad = 0)
	action_button_name = "HALT!"
	body_parts_covered = FACE
	var/obj/item/hailer/hailer
	var/cooldown = 0
	var/phrase = 1
	var/aggressiveness = 1
	var/safety = 1
	var/list/phrase_list = list(
		"halt" 			= "HALT! HALT! HALT! HALT!",
		"bobby" 		= "Stop in the name of the Law.",
		"compliance" 	= "Compliance is in your best interest.",
		"justice"		= "Prepare for justice!",
		"running"		= "Running will only increase your sentence.",
		"dontmove"		= "Don't move, Creep!",
		"floor"			= "Down on the floor, Creep!",
		"robocop"		= "Dead or alive you're coming with me.",
		"god"			= "God made today for the crooks we could not catch yesterday.",
		"freeze"		= "Freeze, Scum Bag!",
		"imperial"		= "Stop right there, criminal scum!",
		"bash"			= "Stop or I'll bash you.",
		"harry"			= "Go ahead, make my day.",
		"asshole"		= "Stop breaking the law, asshole.",
		"stfu"			= "You have the right to shut the fuck up",
		"shutup"		= "Shut up crime!",
		"super"			= "Face the wrath of the golden bolt.",
		"dredd"			= "I am, the LAW!"
		)

/obj/item/clothing/mask/gas/sechailer/swat/hos
	name = "\improper HOS SWAT mask"
	desc = "A close-fitting tactical mask with an especially aggressive Compli-o-nator 3000. It has a tan stripe."
	icon_state = "hosmask"


/obj/item/clothing/mask/gas/sechailer/swat/warden
	name = "\improper " + JOB_WARDEN + " SWAT mask"
	desc = "A close-fitting tactical mask with an especially aggressive Compli-o-nator 3000. It has a blue stripe."
	icon_state = "wardenmask"

/obj/item/clothing/mask/gas/sechailer/swat
	name = "\improper SWAT mask"
	desc = "A close-fitting tactical mask with an especially aggressive Compli-o-nator 3000."
	icon_state = "officermask"
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEFACE|BLOCKHAIR
	aggressiveness = 3
	phrase = 12


/obj/item/clothing/mask/gas/sechailer/ui_action_click()
	halt()

/obj/item/clothing/mask/gas/sechailer/AltClick(mob/user)
	selectphrase()

/obj/item/clothing/mask/gas/sechailer/verb/selectphrase()
	set name = "Select gas mask phrase"
	set category = "Object"
	set desc = "Alter the message shouted by your complionator gas mask."

	var/key = phrase_list[phrase]
	var/message = phrase_list[key]

	if (!safety)
		to_chat(usr, span_notice("You set the restrictor to: FUCK YOUR CUNT YOU SHIT EATING COCKSUCKER MAN EAT A DONG FUCKING ASS RAMMING SHIT FUCK EAT PENISES IN YOUR FUCK FACE AND SHIT OUT ABORTIONS OF FUCK AND DO SHIT IN YOUR ASS YOU COCK FUCK SHIT MONKEY FUCK ASS WANKER FROM THE DEPTHS OF SHIT."))
		return
	switch(aggressiveness)
		if(1)
			phrase = (phrase < 6) ? (phrase + 1) : 1
			key = phrase_list[phrase]
			message = phrase_list[key]
			to_chat(usr,span_notice("You set the restrictor to: [message]"))
		if(2)
			phrase = (phrase < 11 && phrase >= 7) ? (phrase + 1) : 7
			key = phrase_list[phrase]
			message = phrase_list[key]
			to_chat(usr,span_notice("You set the restrictor to: [message]"))
		if(3)
			phrase = (phrase < 18 && phrase >= 12 ) ? (phrase + 1) : 12
			key = phrase_list[phrase]
			message = phrase_list[key]
			to_chat(usr,span_notice("You set the restrictor to: [message]"))
		if(4)
			phrase = (phrase < 18 && phrase >= 1 ) ? (phrase + 1) : 1
			key = phrase_list[phrase]
			message = phrase_list[key]
			to_chat(usr,span_notice("You set the restrictor to: [message]"))
		else
			to_chat(usr, span_notice("It's broken."))

/obj/item/clothing/mask/gas/sechailer/emag_act(mob/user)
	if(safety)
		safety = 0
		to_chat(user, span_warning("You silently fry [src]'s vocal circuit with the cryptographic sequencer."))
	else
		return

/obj/item/clothing/mask/gas/sechailer/attackby(obj/item/I, mob/user)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		switch(aggressiveness)
			if(1)
				to_chat(user, span_notice("You set the aggressiveness restrictor to the second position."))
				aggressiveness = 2
				phrase = 7
			if(2)
				to_chat(user, span_notice("You set the aggressiveness restrictor to the third position."))
				aggressiveness = 3
				phrase = 13
			if(3)
				to_chat(user, span_notice("You set the aggressiveness restrictor to the fourth position."))
				aggressiveness = 4
				phrase = 1
			if(4)
				to_chat(user, span_notice("You set the aggressiveness restrictor to the first position."))
				aggressiveness = 1
				phrase = 1
			if(5)
				to_chat(user, span_warning("You adjust the restrictor but nothing happens, probably because its broken."))
	if(I.has_tool_quality(TOOL_WIRECUTTER))
		if(aggressiveness != 5)
			to_chat(user, span_warning("You broke it!"))
			aggressiveness = 5
	if(I.has_tool_quality(TOOL_CROWBAR))
		if(!hailer)
			to_chat(user, span_warning("This mask has an integrated hailer, you can't remove it!"))
		else
			var/obj/N = new /obj/item/clothing/mask/gas/half(src.loc)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			N.fingerprints = src.fingerprints
			N.fingerprintshidden = src.fingerprintshidden
			N.fingerprintslast = src.fingerprintslast
			N.suit_fibers = src.suit_fibers
			if(!isturf(N.loc))
				user.put_in_hands(hailer)
				user.put_in_hands(N)
			else
				hailer.loc = N.loc
			qdel(src)
			return
	..()

/obj/item/clothing/mask/gas/sechailer/verb/halt()
	set name = "HALT!"
	set category = "Objects"
	set desc = "Activate your face mask hailer."
	var/key = phrase_list[phrase]
	var/message = phrase_list[key]

	if(cooldown < world.time - 35) // A cooldown, to stop people being jerks
		if(!safety)
			message = "FUCK YOUR CUNT YOU SHIT EATING COCKSUCKER MAN EAT A DONG FUCKING ASS RAMMING SHIT FUCK EAT PENISES IN YOUR FUCK FACE AND SHIT OUT ABORTIONS OF FUCK AND DO SHIT IN YOUR ASS YOU COCK FUCK SHIT MONKEY FUCK ASS WANKER FROM THE DEPTHS OF SHIT."
			usr.visible_message("[usr]'s Compli-o-Nator: [span_red("<font size='4'><b>[message]</b></font>")]")
			playsound(src, 'sound/voice/binsult.ogg', 50, 0, 4) //Future sound channel = something like SFX
			cooldown = world.time
			return

		usr.visible_message("[usr]'s Compli-o-Nator: [span_red("<font size='4'><b>[message]</b></font>")]")
		playsound(src, "sound/voice/complionator/[key].ogg", 50, 0, 4) //future sound channel = something like SFX
		cooldown = world.time
