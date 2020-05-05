/obj/item/weapon/melee/cultsword
	name = "strange blade"
	desc = "An arcane weapon."
	icon_state = "cultblade"
	origin_tech = list(TECH_COMBAT = 1, TECH_ARCANE = 1)
	w_class = ITEMSIZE_LARGE
	force = 30
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	edge = 1
	sharp = 1


/obj/item/device/bloodstone
	name = "strange stone"
	desc = "It pulsates with a strange, arcane crackle of energy..."
	icon = 'icons/obj/cult_vr.dmi'
	icon_state = "soulstone1"
	var/activated = FALSE

/obj/item/device/bloodstone/attack_self(var/mob/user)
    activated = !activated
    icon_state = activated ? "soulstone2" : "soulstone1"
    to_chat(user, "<span class='warning'>The stone powers [activated ? "up" : "down"]!</span>")
