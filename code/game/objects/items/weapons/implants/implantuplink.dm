/obj/item/implant/uplink
	name = "uplink"
	desc = "Summon things."
	var/activation_emote = "chuckle"

<<<<<<< HEAD
/obj/item/weapon/implant/uplink/New()
=======
/obj/item/implant/uplink/Initialize()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	activation_emote = pick("blink", "blink_r", "eyebrow", "chuckle", "twitch", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	hidden_uplink = new(src)
	//hidden_uplink.uses = 5
	//Code currently uses a mind var for telecrystals, balancing is currently an issue. Will investigate.
	..()
	return

<<<<<<< HEAD
/obj/item/weapon/implant/uplink/post_implant(mob/source)
	var/choices = list("blink", "blink_r", "eyebrow", "chuckle", "twitch", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	activation_emote = tgui_input_list(usr, "Choose activation emote. If you cancel this, one will be picked at random.", "Implant Activation", choices)
	if(!activation_emote)
		activation_emote = pick(choices)
=======
/obj/item/implant/uplink/post_implant(mob/source)
	listening_objects |= src
	activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	source.mind.store_memory("Uplink implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted uplink implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")

/obj/item/implant/uplink/trigger(emote, mob/source as mob)
	if(hidden_uplink && usr == source) // Let's not have another people activate our uplink
		hidden_uplink.check_trigger(source, emote, activation_emote)
	return