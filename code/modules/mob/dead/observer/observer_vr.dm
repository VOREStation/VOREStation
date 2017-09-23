/mob/observer/dead/verb/paialert()
	set category = "Ghost"
	set name = "Blank pAI alert"
	set desc = "Flash an indicator light on available blank pAI devices for a smidgen of hope."
	if(usr.client.prefs.be_special & BE_PAI)
		for(var/obj/item/device/paicard/p in world)
			var/obj/item/device/paicard/PP = p
			if(PP.pai == null)
				PP.icon = 'icons/obj/pda_vr.dmi'
				PP.overlays += "pai-ghostalert"
				spawn(54)
					PP.overlays.Cut()