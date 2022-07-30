/obj/item/archaeological_find
	name = "object"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano01"
	var/find_type = 0

/obj/item/archaeological_find/Initialize(var/ml, var/new_item_type)
	. = ..()
	if(new_item_type)
		find_type = new_item_type
	else
		find_type = rand(1, MAX_ARCHAEO)

	var/item_type = "object"
	icon_state = "unknown[rand(1,4)]"
	var/additional_desc = ""
	var/obj/item/new_item
	var/source_material = ""
	var/apply_material_decorations = TRUE
	var/apply_image_decorations = FALSE
	var/material_descriptor = ""
	var/apply_prefix = TRUE

	var/become_anomalous = FALSE

	if(prob(40))
		material_descriptor = pick("rusted ","dusty ","archaic ","fragile ", "damaged", "pristine")
	source_material = pick("cordite","quadrinium","steel","titanium","aluminium","ferritic-alloy","plasteel","duranium")

	var/talkative = FALSE
	if(prob(5))
		talkative = TRUE

	//for all items here:
	//icon_state
	//item_state
	switch(find_type)
		if(ARCHAEO_BOWL)
			item_type = "bowl"
			if(prob(33))
				new_item = new /obj/item/reagent_containers/glass/replenishing(src.loc)
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
			else
				new_item = new /obj/item/reagent_containers/glass/beaker(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "bowl"
			apply_image_decorations = TRUE
			if(prob(40))
				new_item.color = rgb(rand(0,255),rand(0,255),rand(0,255))
			if(prob(20))
				additional_desc = "There appear to be [pick("dark","faintly glowing","pungent","bright")] [pick("red","purple","green","blue")] stains inside."
		if(ARCHAEO_URN)
			item_type = "urn"
			if(prob(33))
				new_item = new /obj/item/reagent_containers/glass/replenishing(src.loc)
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
			else
				new_item = new /obj/item/reagent_containers/glass/beaker(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "urn[rand(1,2)]"
			apply_image_decorations = TRUE
			if(prob(20))
				additional_desc = "It [pick("whispers faintly","makes a quiet roaring sound","whistles softly","thrums quietly","throbs")] if you put it to your ear."
		if(ARCHAEO_CUTLERY)
			item_type = "[pick("fork","spoon","knife")]"
			if(prob(25))
				new_item = new /obj/item/material/kitchen/utensil/fork(src.loc)
			else if(prob(50))
				new_item = new /obj/item/material/knife(src.loc)
			else
				new_item = new /obj/item/material/kitchen/utensil/spoon(src.loc)
			if(prob(60))
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
			additional_desc = "[pick("It's like no [item_type] you've ever seen before",\
			"It's a mystery how anyone is supposed to eat with this",\
			"You wonder what the creator's mouth was shaped like")]."
		if(ARCHAEO_STATUETTE)
			name = "statuette"
			icon = 'icons/obj/xenoarchaeology.dmi'
			item_type = "statuette"
			icon_state = "statuette[rand(1,3)]"
			additional_desc = "It depicts a [pick("small","ferocious","wild","pleasing","hulking")] \
			[pick("alien figure","rodent-like creature","reptilian alien","primate","unidentifiable object")] \
			[pick("performing unspeakable acts","posing heroically","in a fetal position","cheering","sobbing","making a plaintive gesture","making a rude gesture")]."
			if(prob(25))
				new_item = new /obj/item/vampiric(src.loc)
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
		if(ARCHAEO_INSTRUMENT)
			name = "instrument"
			icon = 'icons/obj/xenoarchaeology.dmi'
			item_type = "instrument"
			icon_state = "instrument"
			if(prob(30))
				become_anomalous = TRUE
			if(prob(30))
				apply_image_decorations = TRUE
				additional_desc = "[pick("You're not sure how anyone could have played this",\
				"You wonder how many mouths the creator had",\
				"You wonder what it sounds like",\
				"You wonder what kind of music was made with it")]."
		if(ARCHAEO_KNIFE)
			item_type = "[pick("bladed knife","serrated blade","sharp cutting implement")]"
			new_item = new /obj/item/material/knife(src.loc)
			additional_desc = "[pick("It doesn't look safe.",\
			"It looks wickedly jagged",\
			"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along the edges")]."
		if(ARCHAEO_COIN)
			//assuming there are 12 types of coins
			var/chance = 8
			for(var/type in typesof(/obj/item/coin))
				if(prob(chance))
					new_item = new type(src.loc)
					break
				chance += 10

			item_type = new_item.name
			apply_prefix = FALSE
			apply_material_decorations = FALSE
			apply_image_decorations = TRUE
		if(ARCHAEO_HANDCUFFS)
			item_type = "handcuffs"
			new_item = new /obj/item/handcuffs(src.loc)
			additional_desc = "[pick("They appear to be for securing two things together","Looks kinky","Doesn't seem like a children's toy")]."
		if(ARCHAEO_BEARTRAP)
			item_type = "[pick("wicked","evil","byzantine","dangerous")] looking [pick("device","contraption","thing","trap")]"
			apply_prefix = FALSE
			new_item = new /obj/item/beartrap(src.loc)
			if(prob(40))
				new_item.color = rgb(rand(0,255),rand(0,255),rand(0,255))
			additional_desc = "[pick("It looks like it could take a limb off",\
			"Could be some kind of animal trap",\
			"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along part of it")]."
		if(ARCHAEO_LIGHTER)
			item_type = "[pick("cylinder","tank","chamber")]"
			new_item = new /obj/item/flame/lighter(src.loc)
			additional_desc = "There is a tiny device attached."
			if(prob(30))
				apply_image_decorations = TRUE
		if(ARCHAEO_BOX)
			item_type = "box"
			new_item = new /obj/item/storage/box(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "box"
			var/obj/item/storage/box/new_box = new_item
			new_box.max_w_class = pick(1,2,2,3,3,3,4,4)
			var/storage_amount = 2**(new_box.max_w_class-1)
			new_box.max_storage_space = rand(storage_amount, storage_amount * 10)
			if(prob(30))
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
				apply_image_decorations = TRUE
		if(ARCHAEO_GASTANK)
			item_type = "[pick("cylinder","tank","chamber")]"
			if(prob(25))
				new_item = new /obj/item/tank/air(src.loc)
			else if(prob(50))
				new_item = new /obj/item/tank/anesthetic(src.loc)
			else
				new_item = new /obj/item/tank/phoron(src.loc)
			icon_state = pick("oxygen","oxygen_fr","oxygen_f","phoron","anesthetic")
			additional_desc = "It [pick("gloops","sloshes")] slightly when you shake it."
		if(ARCHAEO_TOOL)
			item_type = "tool"
			if(prob(25))
				new_item = new /obj/item/tool/wrench(src.loc)
			else if(prob(25))
				new_item = new /obj/item/tool/crowbar(src.loc)
			else
				new_item = new /obj/item/tool/screwdriver(src.loc)
			if(prob(40))
				new_item.color = rgb(rand(0,255),rand(0,255),rand(0,255))
				apply_image_decorations = TRUE
			additional_desc = "[pick("It doesn't look safe.",\
			"You wonder what it was used for",\
			"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains on it")]."
		if(ARCHAEO_METAL)
			apply_material_decorations = FALSE
			var/list/possible_spawns = list()
			possible_spawns += /obj/item/stack/material/steel
			possible_spawns += /obj/item/stack/material/plasteel
			possible_spawns += /obj/item/stack/material/glass
			possible_spawns += /obj/item/stack/material/glass/reinforced
			possible_spawns += /obj/item/stack/material/phoron
			possible_spawns += /obj/item/stack/material/gold
			possible_spawns += /obj/item/stack/material/silver
			possible_spawns += /obj/item/stack/material/uranium
			possible_spawns += /obj/item/stack/material/sandstone
			possible_spawns += /obj/item/stack/material/silver

			var/new_type = pick(possible_spawns)
			new_item = new new_type(src.loc)
			new_item:amount = rand(5,45)
		if(ARCHAEO_PEN)
			if(prob(75))
				new_item = new /obj/item/pen(src.loc)
			else
				new_item = new /obj/item/pen/reagent/sleepy(src.loc)
			if(prob(30))
				icon = 'icons/obj/xenoarchaeology.dmi'
				icon_state = "pen1"
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
				apply_image_decorations = TRUE
		if(ARCHAEO_CRYSTAL)
			if(prob(40))
				become_anomalous = TRUE
			apply_prefix = FALSE
			if(prob(25))
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "smooth green crystal"
				icon_state = "Green lump"
			else if(prob(33))
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "irregular purple crystal"
				icon_state = "Phazon"
			else
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "rough red crystal"
				icon_state = "changerock"
			additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")

			apply_material_decorations = FALSE
			if(prob(10))
				apply_image_decorations = TRUE
			if(prob(25))
				new_item = new /obj/item/soulstone(src.loc)
				new_item.icon = 'icons/obj/xenoarchaeology.dmi'
				new_item.icon_state = icon_state
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 2)
		if(ARCHAEO_CULTBLADE)
			//cultblade
			apply_prefix = FALSE
			new_item = new /obj/item/melee/cultblade(src.loc)
			apply_material_decorations = FALSE
			apply_image_decorations = FALSE
		if(ARCHAEO_TELEBEACON)
			new_item = new /obj/item/radio/beacon(src.loc)
			talkative = FALSE
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "unknown[rand(1,4)]"
			new_item.desc = ""
		if(ARCHAEO_CLAYMORE)
			apply_prefix = FALSE
			new_item = new /obj/item/material/sword(src.loc)
			new_item.force = 10
			new_item.name = pick("great-sword","claymore","longsword","broadsword","shortsword","gladius")
			item_type = new_item.name
			if(prob(30))
				new_item.icon = 'icons/obj/xenoarchaeology.dmi'
				new_item.icon_state = "blade1"
		if(ARCHAEO_CULTROBES)
			//arcane clothing
			apply_prefix = FALSE
			var/list/possible_spawns = list(/obj/item/clothing/head/culthood,
			/obj/item/clothing/head/culthood/magus,
			/obj/item/clothing/head/culthood/alt,
			/obj/item/clothing/head/helmet/space/cult)

			var/new_type = pick(possible_spawns)
			new_item = new new_type(src.loc)
			LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
		if(ARCHAEO_SOULSTONE)
			//soulstone
			become_anomalous = TRUE
			apply_prefix = FALSE
			new_item = new /obj/item/soulstone(src.loc)
			item_type = new_item.name
			apply_material_decorations = FALSE
			LAZYSET(new_item.origin_tech, TECH_ARCANE, 2)
		if(ARCHAEO_SHARD)
			if(prob(50))
				new_item = new /obj/item/material/shard(src.loc)
			else
				new_item = new /obj/item/material/shard/phoron(src.loc)
			apply_prefix = FALSE
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
		if(ARCHAEO_RODS)
			apply_prefix = FALSE
			new_item = new /obj/item/stack/rods(src.loc)
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
		if(ARCHAEO_STOCKPARTS)
			if(prob(30))
				become_anomalous = TRUE
			var/list/possible_spawns = typesof(/obj/item/stock_parts)
			possible_spawns -= /obj/item/stock_parts
			possible_spawns -= /obj/item/stock_parts/subspace

			var/new_type = pick(possible_spawns)
			new_item = new new_type(src.loc)
			item_type = new_item.name
			apply_material_decorations = FALSE
		if(ARCHAEO_KATANA)
			apply_prefix = FALSE
			new_item = new /obj/item/material/sword/katana(src.loc)
			new_item.force = 10
			new_item.name = "katana"
			item_type = new_item.name
		if(ARCHAEO_LASER)
			//energy gun
			var/spawn_type = pick(\
			/obj/item/gun/energy/laser/practice/xenoarch,\
			/obj/item/gun/energy/laser/xenoarch,\
			/obj/item/gun/energy/xray/xenoarch,\
			/obj/item/gun/energy/captain/xenoarch)
			if(spawn_type)
				var/obj/item/gun/energy/new_gun = new spawn_type(src.loc)
				new_item = new_gun
				new_item.icon_state = "egun[rand(1,6)]" //VOREStation Edit: max value is 6 since xenoarcheoloy_vr only has 6 egun variants
				new_gun.desc = "This is an antique energy weapon, you're not sure if it will fire or not."

				//5% chance to explode when first fired
				//10% chance to have an unchargeable cell
				//15% chance to gain a random amount of starting energy, otherwise start with an empty cell
				if(prob(5))
					new_gun.power_supply.rigged = 1
				if(prob(10))
					new_gun.power_supply.maxcharge = 0
					LAZYSET(new_gun.origin_tech, TECH_ARCANE, rand(0, 1))
				if(prob(15))
					new_gun.power_supply.charge = rand(0, new_gun.power_supply.maxcharge)
					LAZYSET(new_gun.origin_tech, TECH_ARCANE, 1)
				else
					new_gun.power_supply.charge = 0

			item_type = "gun"
		if(ARCHAEO_GUN)
			//revolver
			var/obj/item/gun/projectile/new_gun = new /obj/item/gun/projectile/revolver(src.loc)
			new_item = new_gun
			new_item.icon_state = "gun[rand(1,7)]"
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'

			//33% chance to be able to reload the gun with human ammunition
			if(prob(66))
				new_gun.caliber = "999"

			//33% chance to fill it with a random amount of bullets
			new_gun.max_shells = rand(1,12)
			if(prob(33))
				var/num_bullets = rand(1,new_gun.max_shells)
				if(num_bullets < new_gun.loaded.len)
					new_gun.loaded.Cut()
					for(var/i = 1, i <= num_bullets, i++)
						var/A = new_gun.ammo_type
						new_gun.loaded += new A(new_gun)
				else
					for(var/obj/item/I in new_gun)
						if(new_gun.loaded.len > num_bullets)
							if(I in new_gun.loaded)
								new_gun.loaded.Remove(I)
								I.loc = null
						else
							break
			else
				for(var/obj/item/I in new_gun)
					if(I in new_gun.loaded)
						new_gun.loaded.Remove(I)
						I.loc = null

			item_type = "gun"
		if(ARCHAEO_UNKNOWN)
			if(prob(20))
				become_anomalous = TRUE
			//completely unknown alien device
			if(prob(50))
				apply_image_decorations = FALSE
		if(ARCHAEO_FOSSIL)
			//fossil bone/skull
			//new_item = new /obj/item/fossil/base(src.loc)

			//the replacement item propogation isn't working, and it's messy code anyway so just do it here
			var/list/candidates = list(/obj/item/fossil/bone = 9,/obj/item/fossil/skull = 3,
			/obj/item/fossil/skull/horned = 2)
			var/spawn_type = pickweight(candidates)
			new_item = new spawn_type(src.loc)

			apply_prefix = FALSE
			additional_desc = "A fossilised part of an alien, long dead."
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
		if(ARCHAEO_SHELL)
			//fossil shell
			new_item = new /obj/item/fossil/shell(src.loc)
			apply_prefix = FALSE
			additional_desc = "A fossilised, pre-Stygian alien crustacean."
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
			if(prob(10))
				apply_image_decorations = TRUE
		if(ARCHAEO_PLANT)
			//fossil plant
			new_item = new /obj/item/fossil/plant(src.loc)
			item_type = new_item.name
			additional_desc = "A fossilised shred of alien plant matter."
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
			apply_prefix = FALSE
		if(ARCHAEO_REMAINS_HUMANOID)
			//humanoid remains
			apply_prefix = FALSE
			item_type = "humanoid [pick("remains","skeleton")]"
			icon = 'icons/effects/blood.dmi'
			icon_state = "remains"
			additional_desc = pick("They appear almost human.",\
			"They are contorted in a most gruesome way.",\
			"They look almost peaceful.",\
			"The bones are yellowing and old, but remarkably well preserved.",\
			"The bones are scored by numerous burns and partially melted.",\
			"The are battered and broken, in some cases less than splinters are left.",\
			"The mouth is wide open in a death rictus, the victim would appear to have died screaming.")
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
		if(ARCHAEO_REMAINS_ROBOT)
			//robot remains
			apply_prefix = FALSE
			item_type = "[pick("mechanical","robotic","cyborg")] [pick("remains","chassis","debris")]"
			icon = 'icons/mob/robots.dmi'
			icon_state = "remainsrobot"
			additional_desc = pick("Almost mistakeable for the remains of a modern cyborg.",\
			"They are barely recognisable as anything other than a pile of waste metals.",\
			"It looks like the battered remains of an ancient robot chassis.",\
			"The chassis is rusting and old, but remarkably well preserved.",\
			"The chassis is scored by numerous burns and partially melted.",\
			"The chassis is battered and broken, in some cases only chunks of metal are left.",\
			"A pile of wires and crap metal that looks vaguely robotic.")
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
		if(ARCHAEO_REMAINS_XENO)
			//xenos remains
			apply_prefix = FALSE
			item_type = "alien [pick("remains","skeleton")]"
			icon = 'icons/effects/blood.dmi'
			icon_state = "remainsxeno"
			additional_desc = pick("It looks vaguely reptilian, but with more teeth.",\
			"They are faintly unsettling.",\
			"There is a faint aura of unease about them.",\
			"The bones are yellowing and old, but remarkably well preserved.",\
			"The bones are scored by numerous burns and partially melted.",\
			"The are battered and broken, in some cases less than splinters are left.",\
			"This creature would have been twisted and monstrous when it was alive.",\
			"It doesn't look human.")
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
		if(ARCHAEO_GASMASK)
			//gas mask
			if(prob(25))
				new_item = new /obj/item/clothing/mask/gas/poltergeist(src.loc)
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
			else
				new_item = new /obj/item/clothing/mask/gas(src.loc)
			if(prob(40))
				new_item.color = rgb(rand(0,255),rand(0,255),rand(0,255))
		if(ARCHAEO_ALIEN_ITEM)
			// Alien stuff.
			apply_prefix = FALSE
			apply_material_decorations = FALSE

			var/list/alien_stuff = list(
				/obj/item/multitool/alien,
				/obj/item/stack/cable_coil/alien,
				/obj/item/tool/crowbar/alien,
				/obj/item/tool/screwdriver/alien,
				/obj/item/weldingtool/alien,
				/obj/item/tool/wirecutters/alien,
				/obj/item/tool/wrench/alien,
				/obj/item/surgical/FixOVein/alien,
				/obj/item/surgical/bone_clamp/alien,
				/obj/item/surgical/cautery/alien,
				/obj/item/surgical/circular_saw/alien,
				/obj/item/surgical/hemostat/alien,
				/obj/item/surgical/retractor/alien,
				/obj/item/surgical/scalpel/alien,
				/obj/item/surgical/surgicaldrill/alien,
				/obj/item/cell/device/weapon/recharge/alien,
				/obj/item/clothing/suit/armor/alien,
				/obj/item/clothing/head/helmet/alien,
				/obj/item/clothing/head/psy_crown/wrath
			)

			var/new_type = pick(alien_stuff)
			new_item = new new_type(src.loc)
			LAZYSET(new_item.origin_tech, TECH_ARCANE, 2)
			LAZYSET(new_item.origin_tech, TECH_PRECURSOR, 1)
			item_type = new_item.name

		if(ARCHAEO_ALIEN_BOAT)
			// Alien boats.
			apply_prefix = FALSE
			var/new_boat_mat = pickweight(list(
				MAT_WOOD = 100,
				MAT_SIFWOOD = 200,
				MAT_STEEL = 60,
				MAT_URANIUM = 14,
				MAT_MARBLE = 16,
				MAT_GOLD = 20,
				MAT_SILVER = 24,
				MAT_PLASTEEL = 10,
				MAT_TITANIUM = 6,
				MAT_IRON = 30,
				MAT_PHORON = 4,
				MAT_VERDANTIUM = 2,
				MAT_DIAMOND = 4,
				MAT_DURASTEEL = 2,
				MAT_MORPHIUM = 2,
				MAT_SUPERMATTER = 1
				))
			var/list/alien_stuff = list(
				/obj/vehicle/boat,
				/obj/vehicle/boat/dragon
				)
			if(prob(30))
				new /obj/item/oar(src.loc, new_boat_mat)
			var/new_type = pick(alien_stuff)
			new_item = new new_type(src.loc, new_boat_mat)
			item_type = new_item.name

		if(ARCHAEO_IMPERION_CIRCUIT)
			// Imperion circuit.
			apply_prefix = FALSE
			apply_image_decorations = FALSE
			var/possible_circuits = subtypesof(/obj/item/circuitboard/mecha/imperion)
			var/new_type = pick(possible_circuits)
			new_item = new new_type(src.loc)
			name = new_item.name
			desc = new_item.desc
			item_type = new_item.name

		if(ARCHAEO_TELECUBE)
			// Telecube.
			if(prob(25))
				apply_prefix = FALSE
			if(prob(75))
				apply_image_decorations = TRUE
			if(prob(25))
				apply_material_decorations = FALSE
			new_item = new /obj/item/telecube/randomized(src.loc)
			item_type = new_item.name

		if(ARCHAEO_BATTERY)
			// Battery!
			var/new_path = pick(subtypesof(/obj/item/cell))
			new_item = new new_path(src.loc)
			new_item.name = pick("cell", "battery", "device")

			if(prob(30))
				apply_prefix = FALSE
			if(prob(5))
				apply_image_decorations = TRUE
			if(prob(15))
				apply_material_decorations = FALSE

			item_type = new_item.name

		if(ARCHAEO_SYRINGE)
			// Syringe.
			if(prob(25))
				apply_prefix = FALSE
			if(prob(75))
				apply_image_decorations = TRUE
			if(prob(25))
				apply_material_decorations = FALSE
			new_item = new /obj/item/reagent_containers/syringe(src.loc)
			var/obj/item/reagent_containers/syringe/S = new_item

			S.volume = 30
			//If S hasn't initialized yet, S.reagents will be null.
			//However, in that case Initialize will set the maximum volume to the volume for us, so we don't need to do anything.
			S.reagents?.maximum_volume = 30

			item_type = new_item.name

		if(ARCHAEO_RING)
			// Ring.
			if(prob(15))
				apply_prefix = FALSE
			if(prob(40))
				apply_image_decorations = TRUE
			if(prob(25))
				apply_material_decorations = FALSE
			new_item = new /obj/item/clothing/gloves/ring/material(src.loc)
			item_type = new_item.name

		if(ARCHAEO_CLUB)
			// Baseball Bat
			if(prob(30))
				apply_prefix = FALSE
			if(prob(80))
				apply_image_decorations = TRUE
			if(prob(10))
				apply_material_decorations = FALSE

			new_item = new /obj/item/material/twohanded/baseballbat(src.loc)
			new_item.name = pick("great-club","club","billyclub","mace","tenderizer","maul","bat")
			item_type = new_item.name

	if(istype(new_item, /obj/item/material))
		var/new_item_mat = pickweight(list(
			MAT_STEEL = 80,
			MAT_WOOD = 20,
			MAT_SIFWOOD = 40,
			MAT_URANIUM = 14,
			MAT_MARBLE = 16,
			MAT_GOLD = 20,
			MAT_SILVER = 24,
			MAT_PLASTEEL = 10,
			MAT_TITANIUM = 6,
			MAT_IRON = 30,
			MAT_PHORON = 4,
			MAT_VERDANTIUM = 2,
			MAT_DIAMOND = 4,
			MAT_DURASTEEL = 2,
			MAT_MORPHIUM = 2,
			MAT_SUPERMATTER = 1
			))
		var/obj/item/material/MW = new_item
		MW.applies_material_colour = TRUE
		MW.set_material(new_item_mat)
		if(istype(MW, /obj/item/material/twohanded))
			var/obj/item/material/twohanded/TH = MW
			TH.force_unwielded *= 0.7
			TH.force_wielded *= 0.5
		else
			MW.force *= 0.3

	var/decorations = ""
	if(apply_material_decorations)
		source_material = pick("cordite","quadrinium","steel","titanium","aluminium","ferritic-alloy","plasteel","duranium")

		if(istype(new_item, /obj/item/material))
			var/obj/item/material/MW = new_item
			source_material = MW.material.display_name
		if(istype(new_item, /obj/vehicle/boat))
			var/obj/vehicle/boat/B = new_item
			source_material = B.material.display_name
		desc = "A [material_descriptor ? "[material_descriptor] " : ""][item_type] made of [source_material], all craftsmanship is of [pick("the lowest","low","average","high","the highest")] quality."

		var/list/descriptors = list()
		if(prob(30))
			descriptors.Add("is encrusted with [pick("","synthetic ","multi-faceted ","uncut ","sparkling ") + pick("rubies","emeralds","diamonds","opals","lapiz lazuli")]")
		if(prob(30))
			descriptors.Add("is studded with [pick("gold","silver","aluminium","titanium")]")
		if(prob(30))
			descriptors.Add("is encircled with bands of [pick("quadrinium","cordite","ferritic-alloy","plasteel","duranium")]")
		if(prob(30))
			descriptors.Add("menaces with spikes of [pick("solid phoron","uranium","white pearl","black steel")]")
		if(descriptors.len > 0)
			decorations = "It "
			for(var/index=1, index <= descriptors.len, index++)
				if(index > 1)
					if(index == descriptors.len)
						decorations += " and "
					else
						decorations += ", "
				decorations += descriptors[index]
			decorations += "."
		if(decorations)
			desc += " " + decorations

	var/engravings = ""
	if(apply_image_decorations)
		engravings = "[pick("Engraved","Carved","Etched")] on the item is [pick("an image of","a frieze of","a depiction of")] \
		[pick("an alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")] \
		[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
		[pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")]"
		if(prob(50))
			engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
		engravings += "."

		if(desc)
			desc += " "
		desc += engravings

	if(apply_prefix)
		name = "[pick("Strange","Ancient","Alien","")] [item_type]"
	else
		name = item_type

	if(desc)
		desc += " "
	desc += additional_desc
	if(!desc)
		desc = "This item is completely [pick("alien","bizarre")]."

	//icon and icon_state should have already been set
	if(new_item)
		new_item.name = name
		new_item.desc = src.desc

		if(talkative)
			new_item.talking_atom = new(new_item)
			LAZYINITLIST(new_item.origin_tech)
			new_item.origin_tech[TECH_ARCANE] += 1
			new_item.origin_tech[TECH_PRECURSOR] += 1

		if(become_anomalous)
			new_item.become_anomalous()

		var/turf/simulated/mineral/T = get_turf(new_item)
		if(istype(T))
			T.last_find = new_item

		qdel(src)

	else if(talkative)
		src.talking_atom = new(src)
		LAZYINITLIST(origin_tech)
		origin_tech[TECH_ARCANE] += 1
		origin_tech[TECH_PRECURSOR] += 1

	if(become_anomalous)
		become_anomalous()
