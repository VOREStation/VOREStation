//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/**********************************************************************
						Cyborg Spec Items
***********************************************************************/
//Might want to move this into several files later but for now it works here

/obj/item/weapon/melee/baton/robot/arm
	name = "electrified arm"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

	hitcost = 750
	agonyforce = 70

/obj/item/weapon/melee/baton/robot/arm/update_icon()
	if(status)
		set_light(1.5, 1, lightcolor)
	else
		set_light(0)

/obj/item/borg/overdrive
	name = "overdrive"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/**********************************************************************
						HUD/SIGHT things
***********************************************************************/
/obj/item/borg/sight
	icon = 'icons/obj/decals.dmi'
	icon_state = "securearea"
	var/sight_mode = null


/obj/item/borg/sight/xray
	name = "\proper x-ray vision"
	sight_mode = BORGXRAY
	icon_state = "night"
	icon = 'icons/inventory/eyes/item.dmi'


/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "thermal"
	icon = 'icons/inventory/eyes/item.dmi'


/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"
	icon = 'icons/inventory/eyes/item.dmi'

/obj/item/borg/sight/material
	name = "\proper material scanner vision"
	sight_mode = BORGMATERIAL
	icon_state = "material"
	icon = 'icons/inventory/eyes/item.dmi'

/obj/item/borg/sight/janitor
	name = "\proper contaminant detector vision"
	sight_mode = BORGJAN
	icon_state = "janhud"
	icon = 'icons/inventory/eyes/item.dmi'

/obj/item/borg/sight/anomalous
	name = "\proper anomaly vision"
	sight_mode = BORGANOMALOUS
	icon_state = "denight"
	icon = 'icons/inventory/eyes/item.dmi'

/obj/item/borg/sight/hud
	name = "hud"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/borg/sight/hud/med
	name = "medical hud"
	icon_state = "healthhud"
	icon = 'icons/inventory/eyes/item.dmi'

/obj/item/borg/sight/hud/med/New()
	..()
	hud = new /obj/item/clothing/glasses/hud/health(src)
	return


/obj/item/borg/sight/hud/sec
	name = "security hud"
	icon_state = "securityhud"
	icon = 'icons/inventory/eyes/item.dmi'

/obj/item/borg/sight/hud/sec/New()
	..()
	hud = new /obj/item/clothing/glasses/hud/security(src)
	return
