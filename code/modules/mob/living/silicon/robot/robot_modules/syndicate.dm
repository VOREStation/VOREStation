/* Syndicate modules */

/obj/item/weapon/robot_module/robot/syndicate
	name = "illegal robot module"
	hide_on_manifest = 1
	languages = list(
					LANGUAGE_SOL_COMMON = 1,
					LANGUAGE_TRADEBAND = 1,
					LANGUAGE_UNATHI = 0,
					LANGUAGE_SIIK	= 0,
					LANGUAGE_SKRELLIAN = 0,
					LANGUAGE_ROOTLOCAL = 0,
					LANGUAGE_GUTTER = 1,
					LANGUAGE_SCHECHI = 0,
					LANGUAGE_EAL	 = 1,
					LANGUAGE_SIGN	 = 0
					)
	sprites = list(
					"Cerberus" = "syndie_bloodhound",
					"Cerberus - Treaded" = "syndie_treadhound",
					"Ares" = "squats",
					"Telemachus" = "toiletbotantag",
					"WTOperator" = "hosborg",
					"XI-GUS" = "spidersyndi",
					"XI-ALP" = "syndi-heavy"
				)
	var/id

/obj/item/weapon/robot_module/robot/syndicate/New(var/mob/living/silicon/robot/R)
	..()
	loc = R
	src.modules += new /obj/item/weapon/melee/energy/sword(src)
	src.modules += new /obj/item/weapon/gun/energy/pulse_rifle/destroyer(src)
	src.modules += new /obj/item/weapon/card/emag(src)
	var/jetpack = new/obj/item/weapon/tank/jetpack/carbondioxide(src)
	src.modules += jetpack
	R.internals = jetpack

	id = R.idcard
	src.modules += id

/obj/item/weapon/robot_module/robot/syndicate/Destroy()
	src.modules -= id
	id = null
	return ..()
