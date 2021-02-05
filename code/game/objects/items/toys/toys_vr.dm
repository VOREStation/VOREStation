/obj/item/toy/mistletoe
	name = "mistletoe"
	desc = "You are supposed to kiss someone under these"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "mistletoe"

/obj/item/toy/plushie/lizardplushie
	name = "lizard plushie"
	desc = "An adorable stuffed toy that resembles a lizardperson."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_lizard"
	attack_verb = list("clawed", "hissed", "tail slapped")

/obj/item/toy/plushie/lizardplushie/kobold
	name = "kobold plushie"
	desc = "An adorable stuffed toy that resembles a kobold."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "kobold"
	pokephrase = "Wehhh!"
	drop_sound = 'sound/voice/weh.ogg'
	attack_verb = list("raided", "kobolded", "weh'd")

/obj/item/toy/plushie/lizardplushie/resh
	name = "security unathi plushie"
	desc = "An adorable stuffed toy that resembles an unathi wearing a head of security uniform. Perfect example of a monitor lizard."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "marketable_resh"
	pokephrase = "Halt! Sssecurity!"		//"Butts!" would be too obvious
	attack_verb = list("valided", "justiced", "batoned")

/obj/item/toy/plushie/slimeplushie
	name = "slime plushie"
	desc = "An adorable stuffed toy that resembles a slime. It is practically just a hacky sack."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_slime"
	attack_verb = list("blorbled", "slimed", "absorbed", "glomped")
	gender = FEMALE	//given all the jokes and drawings, I'm not sure the xenobiologists would make a slimeboy

/obj/item/toy/plushie/box
	name = "cardboard plushie"
	desc = "A toy box plushie, it holds cotten. Only a baddie would place a bomb through the postal system..."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "box"
	attack_verb = list("open", "closed", "packed", "hidden", "rigged", "bombed", "sent", "gave")

/obj/item/toy/plushie/borgplushie
	name = "robot plushie"
	desc = "An adorable stuffed toy of a robot."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "securityk9"
	attack_verb = list("beeped", "booped", "pinged")

/obj/item/toy/plushie/borgplushie/medihound
	icon_state = "medihound"

/obj/item/toy/plushie/borgplushie/scrubpuppy
	icon_state = "scrubpuppy"

/obj/item/toy/plushie/borgplushie/drakiesec
	icon = 'icons/obj/drakietoy_vr.dmi'
	icon_state = "secdrake"

/obj/item/toy/plushie/borgplushie/drakiemed
	icon = 'icons/obj/drakietoy_vr.dmi'
	icon_state = "meddrake"

/obj/item/toy/plushie/foxbear
	name = "toy fox"
	desc = "Issa fox!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "fox"

/obj/item/toy/plushie/nukeplushie
	name = "operative plushie"
	desc = "A stuffed toy that resembles a syndicate nuclear operative. The tag claims operatives to be purely fictitious."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_nuke"
	attack_verb = list("shot", "nuked", "detonated")

/obj/item/toy/plushie/otter
	name = "otter plush"
	desc = "A perfectly sized snuggable river weasel! Keep away from Clams."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_otter"

/obj/item/toy/plushie/vox
	name = "vox plushie"
	desc = "A stitched-together vox, fresh from the skipjack. Press its belly to hear it skree!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_vox"
	var/cooldown = 0

/obj/item/toy/plushie/vox/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/voice/shriek1.ogg', 10, 0)
		src.visible_message("<span class='danger'>Skreee!</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

/obj/item/toy/plushie/vox/proc/cooldownreset()
	cooldown = 0

