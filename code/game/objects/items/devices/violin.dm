//copy pasta of the space piano, don't hurt me -Pete
/obj/item/instrument
	name = "generic instrument"
	var/datum/song/handheld/song
	var/instrumentId = "generic"
	var/instrumentExt = "mid"
	icon = 'icons/obj/musician.dmi'
	force = 10

/obj/item/instrument/Initialize()
	. = ..()
	song = new(instrumentId, src)
	song.instrumentExt = instrumentExt

/obj/item/instrument/Destroy()
	qdel(song)
	song = null
	..()

/obj/item/instrument/attack_self(mob/user as mob)
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return 1
	interact(user)

/obj/item/instrument/interact(mob/user as mob)
	if(!user)
		return

	if(user.incapacitated() || user.lying)
		return

	user.set_machine(src)
	song.interact(user)

/obj/item/instrument/violin
	name = "space violin"
	desc = "A wooden musical instrument with four strings and a bow. \"The devil went down to space, he was looking for an assistant to grief.\""
	icon_state = "violin"
	attack_verb = list("smashed")
	instrumentId = "violin"
