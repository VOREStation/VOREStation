/obj/item/weapon/storage/box/syndicate/initialize()
	switch (pickweight(list("bloodyspai" = 1, "stealth" = 1, "screwed" = 1, "guns" = 1, "murder" = 1, "freedom" = 1, "hacker" = 1, "lordsingulo" = 1, "smoothoperator" = 1)))
		if("bloodyspai")
			new /obj/item/clothing/under/chameleon(src)
			new /obj/item/clothing/mask/gas/voice(src)
			new /obj/item/weapon/card/id/syndicate(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)

		if("stealth")
			new /obj/item/weapon/gun/energy/crossbow(src)
			new /obj/item/weapon/pen/reagent/paralysis(src)
			new /obj/item/device/chameleon(src)

		if("screwed")
			new /obj/effect/spawner/newbomb/timer/syndicate(src)
			new /obj/effect/spawner/newbomb/timer/syndicate(src)
			new /obj/item/device/powersink(src)
			new /obj/item/clothing/suit/space/syndicate(src)
			new /obj/item/clothing/head/helmet/space/syndicate(src)
			new /obj/item/clothing/mask/gas/syndicate(src)
			new /obj/item/weapon/tank/emergency/oxygen/double(src)

		if("guns")
			new /obj/item/weapon/gun/projectile/revolver(src)
			new /obj/item/ammo_magazine/s357(src)
			new /obj/item/weapon/card/emag(src)
			new /obj/item/weapon/plastique(src)
			new /obj/item/weapon/plastique(src)

		if("murder")
			new /obj/item/weapon/melee/energy/sword(src)
			new /obj/item/clothing/glasses/thermal/syndi(src)
			new /obj/item/weapon/card/emag(src)
			new /obj/item/clothing/shoes/syndigaloshes(src)

		if("freedom")
			var/obj/item/weapon/implanter/O = new /obj/item/weapon/implanter(src)
			O.imp = new /obj/item/weapon/implant/freedom(O)
			var/obj/item/weapon/implanter/U = new /obj/item/weapon/implanter(src)
			U.imp = new /obj/item/weapon/implant/uplink(U)

		if("hacker")
			new /obj/item/device/encryptionkey/syndicate(src)
			new /obj/item/weapon/aiModule/syndicate(src)
			new /obj/item/weapon/card/emag(src)
			new /obj/item/device/encryptionkey/binary(src)

		if("lordsingulo")
			new /obj/item/device/radio/beacon/syndicate(src)
			new /obj/item/clothing/suit/space/syndicate(src)
			new /obj/item/clothing/head/helmet/space/syndicate(src)
			new /obj/item/clothing/mask/gas/syndicate(src)
			new /obj/item/weapon/tank/emergency/oxygen/double(src)
			new /obj/item/weapon/card/emag(src)

		if("smoothoperator")
			new /obj/item/weapon/storage/box/syndie_kit/g9mm(src)
			new /obj/item/weapon/storage/bag/trash(src)
			new /obj/item/weapon/soap/syndie(src)
			new /obj/item/bodybag(src)
			new /obj/item/clothing/under/suit_jacket(src)
			new /obj/item/clothing/shoes/laceup(src)
	. = ..()

/obj/item/weapon/storage/box/syndie_kit
	name = "box"
	desc = "A sleek, sturdy box"
	icon_state = "box_of_doom"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom
	name = "boxed freedom implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_freedom/initialize()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/freedom(O)
	O.update()
	. = ..()

/obj/item/weapon/storage/box/syndie_kit/imp_compress
	name = "box (C)"
	starts_with = list(/obj/item/weapon/implanter/compressed)

/obj/item/weapon/storage/box/syndie_kit/imp_explosive
	name = "box (E)"
	starts_with = list(/obj/item/weapon/implanter/explosive)

/obj/item/weapon/storage/box/syndie_kit/imp_uplink
	name = "boxed uplink implant (with injector)"

/obj/item/weapon/storage/box/syndie_kit/imp_uplink/initialize()
	var/obj/item/weapon/implanter/O = new(src)
	O.imp = new /obj/item/weapon/implant/uplink(O)
	O.update()
	. = ..()

/obj/item/weapon/storage/box/syndie_kit/space
	name = "boxed space suit and helmet"
	starts_with = list(
		/obj/item/clothing/suit/space/syndicate,
		/obj/item/clothing/head/helmet/space/syndicate,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/weapon/tank/emergency/oxygen/double
	)

/obj/item/weapon/storage/box/syndie_kit/chameleon
	name = "chameleon kit"
	desc = "Comes with all the clothes you need to impersonate most people.  Acting lessons sold seperately."
	starts_with = list(
		/obj/item/clothing/under/chameleon,
		/obj/item/clothing/head/chameleon,
		/obj/item/clothing/suit/chameleon,
		/obj/item/clothing/shoes/chameleon,
		/obj/item/weapon/storage/backpack/chameleon,
		/obj/item/clothing/gloves/chameleon,
		/obj/item/clothing/mask/chameleon,
		/obj/item/clothing/glasses/chameleon,
		/obj/item/clothing/accessory/chameleon,
		/obj/item/weapon/gun/energy/chameleon
	)

/obj/item/weapon/storage/box/syndie_kit/clerical
	name = "clerical kit"
	desc = "Comes with all you need to fake paperwork. Assumes you have passed basic writing lessons."
	starts_with = list(
		/obj/item/weapon/stamp/chameleon,
		/obj/item/weapon/pen/chameleon,
		/obj/item/device/destTagger,
		/obj/item/weapon/packageWrap,
		/obj/item/weapon/hand_labeler
	)

/obj/item/weapon/storage/box/syndie_kit/spy
	name = "spy kit"
	desc = "For when you want to conduct voyeurism from afar."
	starts_with = list(
		/obj/item/device/camerabug/spy = 6,
		/obj/item/device/bug_monitor/spy
	)

/obj/item/weapon/storage/box/syndie_kit/g9mm
	name = "\improper Smooth operator"
	desc = "Compact 9mm with silencer kit."
	starts_with = list(
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/weapon/silencer
	)

/obj/item/weapon/storage/box/syndie_kit/toxin
	name = "toxin kit"
	desc = "An apple will not be enough to keep the doctor away after this."
	starts_with = list(
		/obj/item/weapon/reagent_containers/glass/beaker/vial/random/toxin,
		/obj/item/weapon/reagent_containers/syringe
	)

/obj/item/weapon/storage/box/syndie_kit/cigarette
	name = "\improper Tricky smokes"
	desc = "Comes with the following brands of cigarettes, in this order: 2xFlash, 2xSmoke, 1xMindBreaker, 1xTricordrazine. Avoid mixing them up."

/obj/item/weapon/storage/box/syndie_kit/cigarette/initialize()
	. = ..()
	var/obj/item/weapon/storage/fancy/cigarettes/pack

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("aluminum" = 5, "potassium" = 5, "sulfur" = 5))
	pack.desc += " 'F' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	fill_cigarre_package(pack, list("potassium" = 5, "sugar" = 5, "phosphorus" = 5))
	pack.desc += " 'S' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	// Dylovene. Going with 1.5 rather than 1.6666666...
	fill_cigarre_package(pack, list("potassium" = 1.5, "nitrogen" = 1.5, "silicon" = 1.5))
	// Mindbreaker
	fill_cigarre_package(pack, list("silicon" = 4.5, "hydrogen" = 4.5))

	pack.desc += " 'MB' has been scribbled on it."

	pack = new /obj/item/weapon/storage/fancy/cigarettes(src)
	pack.reagents.add_reagent("tricordrazine", 15 * pack.storage_slots)
	pack.desc += " 'T' has been scribbled on it."

	new /obj/item/weapon/flame/lighter/zippo(src)

	calibrate_size()

/proc/fill_cigarre_package(var/obj/item/weapon/storage/fancy/cigarettes/C, var/list/reagents)
	for(var/reagent in reagents)
		C.reagents.add_reagent(reagent, reagents[reagent] * C.storage_slots)

/obj/item/weapon/storage/box/syndie_kit/ewar_voice
	name = "Electrowarfare and Voice Synthesiser kit"
	desc = "Kit for confounding organic and synthetic entities alike."
	starts_with = list(
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice
	)

/obj/item/weapon/storage/secure/briefcase/money
	name = "suspicious briefcase"
	desc = "An ominous briefcase that has the unmistakeable smell of old, stale, cigarette smoke, and gives those who look at it a bad feeling."
	starts_with = list(/obj/item/weapon/spacecash/c1000 = 10)

/obj/item/weapon/storage/box/syndie_kit/combat_armor
	name = "combat armor kit"
	desc = "Contains a full set of combat armor."
	starts_with = list(
		/obj/item/clothing/head/helmet/combat,
		/obj/item/clothing/suit/armor/combat,
		/obj/item/clothing/gloves/arm_guard/combat,
		/obj/item/clothing/shoes/leg_guard/combat
	)

/obj/item/weapon/storage/box/syndie_kit/demolitions
	starts_with = list(
		/obj/item/weapon/syndie/c4explosive,
		/obj/item/weapon/tool/screwdriver
	)

/obj/item/weapon/storage/box/syndie_kit/demolitions_heavy
	starts_with = list(
		/obj/item/weapon/syndie/c4explosive/heavy,
		/obj/item/weapon/tool/screwdriver
	)

/obj/item/weapon/storage/box/syndie_kit/demolitions_super_heavy
	starts_with = list(
		/obj/item/weapon/syndie/c4explosive/heavy/super_heavy,
		/obj/item/weapon/tool/screwdriver
	)

/obj/item/weapon/storage/secure/briefcase/rifle
	name = "secure briefcase"
	starts_with = list(
		/obj/item/sniper_rifle_part/barrel,
		/obj/item/sniper_rifle_part/stock,
		/obj/item/sniper_rifle_part/trigger_group,
		/obj/item/ammo_casing/a145 = 4
	)

/obj/item/weapon/storage/secure/briefcase/fuelrod
	name = "heavy briefcase"
	desc = "A heavy, locked briefcase."
	description_fluff = "The container, upon opening, looks to have a few oddly shaped indentations in its packing."
	description_antag = "This case will likely contain a charged fuel rod gun, and a few fuel rods to go with it. It can only hold the fuel rod gun, fuel rods, batteries, a screwdriver, and stock machine parts."
	force = 12 //Anti-rad lined i.e. Lead, probably gonna hurt a bit if you get bashed with it.
	can_hold = list(/obj/item/weapon/gun/magnetic/fuelrod, /obj/item/weapon/fuel_assembly, /obj/item/weapon/cell, /obj/item/weapon/stock_parts, /obj/item/weapon/tool/screwdriver)
	cant_hold = list(/obj/item/weapon/tool/screwdriver/power)
	starts_with = list(
		/obj/item/weapon/gun/magnetic/fuelrod,
		/obj/item/weapon/fuel_assembly/deuterium,
		/obj/item/weapon/fuel_assembly/deuterium,
		/obj/item/weapon/fuel_assembly/tritium,
		/obj/item/weapon/fuel_assembly/tritium,
		/obj/item/weapon/fuel_assembly/phoron,
		/obj/item/weapon/tool/screwdriver
	)
