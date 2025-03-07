/obj/item/archaeological_find
	name = "object"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano01"
	var/find_type = 0

/// Find spawning debug tool. Can be called on any /mob to spawn it at their location.
/mob/proc/artifact_spawn_debug_tool()
	set name = "Artifact Debug"
	set desc = "Spawn an artifact."
	set category = "Debug"
	if(!src.loc)
		to_chat(usr, "You need to select a mob with a proper LOC to spawn a minor artifact!")
		return

	var/type_to_spawn = tgui_input_number(usr, "Desired type to spawn. Consult xenoarcheaology.dm for the spawn list", "Spawn Artifact", 0)
	new /obj/item/archaeological_find(src.loc, type_to_spawn)

/obj/item/archaeological_find/Initialize(mapload, var/new_item_type)
	. = ..()
	if(new_item_type)
		find_type = new_item_type
	else
		find_type = rand(1, MAX_ARCHAEO)

	var/item_type = "object"
	var/secondary_item_type = "object"
	icon_state = "unknown[rand(1,4)]"
	var/additional_desc = "" //Description for the item we find!
	var/secondary_item_desc = "" //Description for the secondary item that can be found
	var/obj/item/new_item //The item we're finding!
	var/obj/item/secondary_item //Allows for more than one item to be found at a time.
	var/source_material = ""
	var/apply_material_decorations = TRUE
	var/apply_image_decorations = FALSE
	var/material_descriptor = ""
	var/apply_prefix = TRUE

	var/become_anomalous = FALSE //This, simply put, gives the item either precursor or an arcane tech level, along with setting a random tech level to 4-7.

	/// Used for the below material type generation code.
	var/list/banned_materials = list(
		/datum/material/flesh,
		/datum/material/fluff,
		/datum/material/darkglass,
		/datum/material/fancyblack,
		/datum/material/steel/hull,
		/datum/material/plasteel/hull,
		/datum/material/durasteel/hull,
		/datum/material/titanium/hull,
		/datum/material/morphium/hull,
		/datum/material/steel/holographic,
		/datum/material/plastic/holographic,
		/datum/material/wood/holographic,
		/datum/material/alienalloy,
		/datum/material/alienalloy/elevatorium,
		/datum/material/alienalloy/dungeonium,
		/datum/material/alienalloy/bedrock,
		/datum/material/alienalloy/alium
		///datum/material/debug //Enable if ticked in the .dme
		)

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
			new_item = new /obj/item/reagent_containers/glass/replenishing(src.loc)
			if(prob(33))
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "bowl"
			apply_image_decorations = TRUE
			new_item.color = rgb(rand(0,255),rand(0,255),rand(0,255))
			additional_desc = "There appear to be [pick("dark","faintly glowing","pungent","bright")] [pick("red","purple","green","blue")] stains inside."
		if(ARCHAEO_URN)
			item_type = "urn"
			new_item = new /obj/item/reagent_containers/glass/replenishing(src.loc)
			if(prob(33))
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
			new_item = new /obj/item/reagent_containers/glass/beaker(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "urn[rand(1,2)]"
			apply_image_decorations = TRUE
			additional_desc = "It [pick("whispers faintly","makes a quiet roaring sound","whistles softly","thrums quietly","throbs")] if you put it to your ear."
		if(ARCHAEO_STATUETTE)
			name = "statuette"
			icon = 'icons/obj/xenoarchaeology.dmi'
			item_type = "statuette"
			icon_state = "statuette[rand(1,3)]"
			additional_desc = "It depicts a [pick("small","ferocious","wild","pleasing","hulking")] \
			[pick("alien figure","rodent-like creature","reptilian alien","primate","unidentifiable object")] \
			[pick("performing unspeakable acts","posing heroically","in a fetal position","cheering","sobbing","making a plaintive gesture","making a rude gesture")]. \
			[pick("It glares at anything that makes sound", "Any nearby sounds attract it's gaze", "Its eyes glow crimson when noises are made nearby")]]."
			new_item = new /obj/item/vampiric(src.loc) //Possibly make multiple subtypes of this?
			LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
		if(ARCHAEO_INSTRUMENT)
			name = "instrument"
			icon = 'icons/obj/xenoarchaeology.dmi'
			item_type = "instrument"
			icon_state = "instrument"
			var/possible_object_paths = list()
			possible_object_paths += subtypesof(/obj/item/instrument)
			var/new_instrument = pick(possible_object_paths)
			new_item = new new_instrument(src.loc)
			if(prob(30))
				become_anomalous = TRUE
			apply_image_decorations = TRUE
			additional_desc = "[pick("You're not sure how anyone could have played this",\
			"You wonder how many mouths the creator had",\
			"You wonder what it sounds like",\
			"You wonder what kind of music was made with it")]."
		if(ARCHAEO_KNIFE)
			item_type = "[pick("bladed knife","serrated blade","sharp cutting implement")]"
			var/possible_object_paths = list(/obj/item/material/knife) //As far as I can tell, this is more 'random' than using typesof, as it just picks a random one vs going down the list with a prob (as seen below)
			possible_object_paths += subtypesof(/obj/item/material/knife)
			var/obj/item/material/knife/new_knife = pick(possible_object_paths)
			new_item = new new_knife(src.loc)
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
			var/possible_object_paths = list(/obj/item/handcuffs)
			possible_object_paths += subtypesof(/obj/item/handcuffs)
			var/new_cuffs = pick(possible_object_paths)
			new_item = new new_cuffs(src.loc)
			additional_desc = "[pick("They appear to be for securing two things together","Looks kinky","Doesn't seem like a children's toy")]."
		if(ARCHAEO_BEARTRAP)
			item_type = "[pick("wicked","evil","byzantine","dangerous")] looking [pick("device","contraption","thing","trap")]"
			apply_prefix = FALSE
			var/list/possible_trap = list(/obj/item/beartrap,
			/obj/item/beartrap/hunting)

			var/new_trap = pick(possible_trap)
			new_item = new new_trap(src.loc)
			new_item.color = rgb(rand(0,255),rand(0,255),rand(0,255))
			additional_desc = "[pick("It looks like it could take a limb off",\
			"Could be some kind of animal trap",\
			"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along part of it")]."
		if(ARCHAEO_LIGHTER)
			item_type = "[pick("cylinder","tank","chamber")]"
			var/possible_object_paths = list()
			possible_object_paths += subtypesof(/obj/item/flame)
			var/new_lighter = pick(possible_object_paths)
			new_item = new new_lighter(src.loc)
			additional_desc = "There is a tiny device attached."
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
			var/possible_object_paths = list()
			possible_object_paths += subtypesof(/obj/item/tank)
			var/new_tank = pick(possible_object_paths)
			new_item = new new_tank(src.loc)
			icon_state = pick("oxygen","oxygen_fr","oxygen_f","phoron","anesthetic")
			additional_desc = "It [pick("gloops","sloshes")] slightly when you shake it."
		if(ARCHAEO_TOOL)
			item_type = "tool"
			var/possible_object_paths = list()
			possible_object_paths += subtypesof(/obj/item/tool)
			var/new_tool = pick(possible_object_paths)
			new_item = new new_tool(src.loc)
			new_item.color = rgb(rand(0,255),rand(0,255),rand(0,255))
			apply_image_decorations = TRUE
			additional_desc = "[pick("It doesn't look safe.",\
			"You wonder what it was used for",\
			"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains on it")]."
		if(ARCHAEO_METAL)
			apply_material_decorations = FALSE
			var/possible_object_paths = list()
			possible_object_paths += subtypesof(/obj/item/stack/material)
			possible_object_paths -= typesof(/obj/item/stack/material/cyborg)
			//I looked through the code for any materials that should be banned...Most of the "DO NOT EVER GIVE THESE TO ANYONE EVER" materials are only in their /datum form and the ones that have sheets spawn in as normal sheets (ex: hull datums) so...This is here in case it's needed in the future.
			var/list/banned_sheet_materials = list(
				// Include if you enable in the .dme /obj/item/stack/material/debug
				)
			var/new_metal = /obj/item/stack/material/supermatter
			for(var/x=1;x<=10;x++) //You got 10 chances to hit a metal that is NOT banned.
				var/picked_metal = pick(possible_object_paths) //We select
				if(picked_metal in banned_sheet_materials)
					continue
				else
					new_metal = picked_metal
					break
			new_item = new new_metal(src.loc)
			new_item:amount = rand(5,45)
		if(ARCHAEO_PEN)
			var/new_pen = pick(/obj/item/pen, /obj/item/pen/blade/fountain, /obj/item/pen/reagent/sleepy) //There are WAY too many pen blade variants that it'd drown out the others in this list.
			new_item = new new_pen(src.loc)
			if(istype(new_item, /obj/item/pen/blade))
				additional_desc = "There seems to be a needle inside of the pen tip."
			if(istype(new_item, /obj/item/pen/reagent/sleepy))
				additional_desc = "It sloshes when you move it around."
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
				new_item.name = "Redspace Gem"
				new_item.desc = "A glowing stone made of what appears to be a pure chunk of redspace. It seems to have the power to transfer the consciousness of dead or nearly-dead humanoids into it."
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 2)
		if(ARCHAEO_CULTBLADE)
			//cultblade
			apply_prefix = FALSE
			new_item = new /obj/item/melee/artifact_blade(src.loc) //Changed to an artifact one.
			additional_desc = "This sword emanates terrifying power"
			apply_material_decorations = FALSE
			apply_image_decorations = FALSE
		if(ARCHAEO_TOME)
			apply_prefix = FALSE
			new_item = new /obj/item/book/tome(src.loc) //Also obtainable via library. Useless unless you're an ACTUAL cultist antag, but it looks SPOOOKY.
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
			//Funnily enough, this was just helmets before I edited it, with no robes.
			apply_prefix = FALSE
			var/list/possible_headwear = list(/obj/item/clothing/head/culthood,
			/obj/item/clothing/head/culthood/magus,
			/obj/item/clothing/head/culthood/alt,
			/obj/item/clothing/head/helmet/space/cult)

			var/new_helmet = pick(possible_headwear)
			var/new_robes
			///Makes sets spawn. Quick, dirty, easy. Simplest thing I could think of without reinventing the wheel.
			if(new_helmet == /obj/item/clothing/head/culthood)
				new_robes = /obj/item/clothing/suit/cultrobes
			else if(new_helmet == /obj/item/clothing/head/culthood/magus)
				new_robes = /obj/item/clothing/suit/cultrobes/magusred
			else if(new_helmet == /obj/item/clothing/head/culthood/alt)
				new_robes = /obj/item/clothing/suit/cultrobes/alt
			else if(new_helmet == /obj/item/clothing/head/helmet/space/cult)
				new_robes = /obj/item/clothing/suit/space/cult

			new_item = new new_helmet(src.loc)
			secondary_item = new new_robes(src.loc)
			LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
			LAZYSET(secondary_item.origin_tech, TECH_ARCANE, 1)
		if(ARCHAEO_SOULSTONE)
			//soulstone
			become_anomalous = TRUE
			apply_prefix = FALSE
			new_item = new /obj/item/soulstone(src.loc)
			item_type = new_item.name
			apply_material_decorations = FALSE
			LAZYSET(new_item.origin_tech, TECH_ARCANE, 2)
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
			var/obj/item/gun/energy/new_gun = new /obj/item/gun/energy/laser/xenoarch(src.loc)
			var/possible_laser_paths = list()
			possible_laser_paths += subtypesof(/obj/item/projectile/beam)
			// possible_laser_paths += /obj/item/projectile/animate //Funny 'turns object into mimic' beam. Currently unticked in the .dme, but here in case it gets toggled!
			possible_laser_paths += /obj/item/projectile/ion
			possible_laser_paths += subtypesof(/obj/item/projectile/energy/floramut)
			// THE BLACKLIST
			possible_laser_paths -= list(/obj/item/projectile/beam/pulse, /obj/item/projectile/beam/pulse/heavy)
			var/new_laser = pick(possible_laser_paths)
			new_gun.projectile_type = new_laser
			new_item = new_gun
			new_item.icon_state = "egun[rand(1,18)]"
			new_gun.desc = "This is an antique energy weapon."

			//10% chance to have an unchargeable cell
			//15% chance to gain a random amount of starting energy, otherwise start with an empty cell
			if(prob(10))
				new_gun.power_supply.maxcharge = 0
				LAZYSET(new_gun.origin_tech, TECH_ARCANE, rand(0, 1))
			if(prob(15))
				new_gun.power_supply.charge = rand(0, new_gun.power_supply.maxcharge)
				LAZYSET(new_gun.origin_tech, TECH_ARCANE, 1)
			else
				new_gun.power_supply.charge = 0
			item_type = "Relic Laser Gun"


		/// Artifact type gun that requires a random caliber and selects a random bullet type it shoots out!.
		if(ARCHAEO_GUN)
			var/obj/item/gun/projectile/artifact/new_gun = new /obj/item/gun/projectile/artifact(src.loc)
			new_item = new_gun
			new_item.icon_state = "gun[rand(1,7)]"
			item_type = "Relic Gun"
			//There is no 'global list of all the gun caliber types' so...Whatever. This will have to do. (Side note: After further review, making it a global list would result in the gun requiring unobtainable calibers, so this is ideal.)
			//When someone does make a global list of all the calibers, replace the below with it.
			new_gun.caliber = "[pick(".357", "12g", ".38", "7.62mm", ".38", "9mm", "10mm", ".45", "5.45mm", "7.62mm")]" //A list of gun calibers that are obtainable.
			additional_desc = "[pick("A dusty engraving on the side says" + span_bold("[new_gun.caliber]") + " The ammo slot seems like it'd only fit single shells at a time.",\
			"The gun's barrel has " + span_bold("[new_gun.caliber]") + " barely visible on it. The ammo slot seems like it'd only fit single shells at a time.")]"
			var/possible_bullet_paths = list()
			possible_bullet_paths += subtypesof(/obj/item/projectile/bullet) //As funny as it would be to have your pistol shoot pulse rifle rounds, sorry.
			//You COULD add a bullet blacklist here. Look at the material code below if you want an example of how to do so.
			//During testing I found nothing EXTRAORDINARILY gamebreaking (although supermatter fuel rod gun rounds were VERY comical, but still obtainable in game)
			//But maybe someone will add in a projectile/bullet/admin_instakills_you that needs to be blacklisted!
			var/new_bullet = pick(possible_bullet_paths)
			new_gun.projectile_type = new_bullet //Instead, you can get anything from chem darts to rifle rounds to everything in between.

			new_gun.max_shells = rand(1,12)
			var/num_bullets = rand(1,new_gun.max_shells)
			new_gun.loaded.Cut() //Remove all the bullets we spawned with.
			new_gun.contents.Cut()
			for(var/i = 1, i <= num_bullets, i++)//Load our gun with the special artifact ammo.
				new_gun.loaded += new /obj/item/ammo_casing/artifact(new_gun)

		if(ARCHAEO_UNKNOWN) //This previously spawned NOTHING...Are you kidding me?
			var/new_sample = new /obj/item/research_sample/rare(src.loc) //So instead, you get a really good research sample. Eat your heart out, science.
			become_anomalous = TRUE
			new_item = new_sample
			item_type = new_item.name

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
			additional_desc = "A fossilised shred of alien plant matter. " + span_bold("The genetic material inside would allow for seed extraction.") //A hint to give this to xenobotany.
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
			apply_prefix = FALSE
		if(ARCHAEO_REMAINS_HUMANOID)
			//humanoid remains
			apply_prefix = FALSE
			item_type = "humanoid organ"
			icon = 'icons/effects/blood.dmi'
			icon_state = "remains"
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE

			//We get a list of random internal organs and spawn it. Yes. You can get a still beating heart. Xenoarch is spooky.
			var/possible_object_paths = list()
			possible_object_paths += subtypesof(/obj/item/organ/internal)

			//BLACKLIST BELOW
			possible_object_paths -= list(/obj/item/organ/internal/mmi_holder, /obj/item/organ/internal/stack/vox)
			//BLACKLIST ABOVE

			var/new_organ = pick(possible_object_paths)
			new_item = new new_organ(src.loc)

		if(ARCHAEO_REMAINS_ROBOT)
			//robot remains
			apply_prefix = FALSE
			item_type = "Alien cybernetic pod"
			icon = 'icons/mob/robots.dmi'
			icon_state = "remainsrobot"
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
			new_item = new /obj/structure/ghost_pod/manual/lost_drone/dogborg(src.loc) //We find a lost drone pod!
		if(ARCHAEO_REMAINS_XENO)
			//xenos remains
			apply_prefix = FALSE
			item_type = "alien plasma organ"
			secondary_item_type = "alien gland"
			additional_desc = pick("The organ pulses and writhes.",\
			"The mass of flesh is unsettling.",\
			"There is a faint aura of unease about them.",\
			"It doesn't look human.")
			apply_image_decorations = FALSE
			apply_material_decorations = FALSE
			var/list/possible_plasma_vessel = list(/obj/item/organ/internal/xenos/plasmavessel,
			/obj/item/organ/internal/xenos/plasmavessel/queen,
			/obj/item/organ/internal/xenos/plasmavessel/sentinel,
			/obj/item/organ/internal/xenos/plasmavessel/hunter)
			var/list/possible_organ = list(/obj/item/organ/internal/xenos/acidgland,
			/obj/item/organ/internal/xenos/hivenode,
			/obj/item/organ/internal/xenos/resinspinner)

			var/new_vessel = pick(possible_plasma_vessel)
			var/new_organ = pick(possible_organ)
			new_item = new new_vessel(src.loc)
			secondary_item = new new_organ(src.loc)
		if(ARCHAEO_GASMASK)
			//gas mask
			if(prob(50))
				new_item = new /obj/item/clothing/mask/gas/poltergeist(src.loc)
				LAZYSET(new_item.origin_tech, TECH_ARCANE, 1)
			else
				new_item = new /obj/item/clothing/mask/gas/voice(src.loc)
			if(prob(40))
				new_item.color = rgb(rand(0,255),rand(0,255),rand(0,255))
		if(ARCHAEO_ALIEN_ITEM)
			// Alien stuff.
			apply_prefix = FALSE
			apply_material_decorations = FALSE

			var/list/alien_tool = list(
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
			)
			var/list/alien_clothes = list(
				/obj/item/clothing/suit/armor/alien,
				/obj/item/clothing/head/helmet/alien,
				/obj/item/clothing/head/psy_crown/wrath,
				/obj/item/clothing/head/psy_crown/gluttony,

			)
			var/new_tool = pick(alien_tool)
			var/new_clothes = pick(alien_clothes)
			new_item = new new_tool(src.loc)
			secondary_item = new new_clothes(src.loc)
			item_type = new_item.name
			secondary_item_type = secondary_item.name
			secondary_item_desc = ""
			LAZYSET(new_item.origin_tech, TECH_ARCANE, 2)
			LAZYSET(new_item.origin_tech, TECH_PRECURSOR, 1)

		if(ARCHAEO_ALIEN_BOAT)
			// Alien boats.
			var/list/boat_types = list(
				/obj/vehicle/boat,
				/obj/vehicle/boat/dragon
				)
			apply_prefix = FALSE
			var/possible_object_paths = list()
			possible_object_paths += subtypesof(/datum/material)
			var/new_boat_mat = "MAT_STEEL"
			for(var/x=1;x<=5;x++) //You got 5 chances to hit a metal that is NOT banned.
				var/datum/material/picked_metal = pick(possible_object_paths) //We select
				if(picked_metal in banned_materials)
					continue
				else
					new_boat_mat = "[picked_metal.name]" //set_material requires NAME.
					break
			new /obj/item/oar(src.loc, new_boat_mat)
			var/obj/vehicle/boat/new_boat = pick(boat_types)
			new_item = new new_boat(src.loc, new_boat_mat)
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

			S.volume = 15
			//If S hasn't initialized yet, S.reagents will be null.
			//However, in that case Initialize will set the maximum volume to the volume for us, so we don't need to do anything.
			S.reagents?.maximum_volume = 15
			item_type = new_item.name
			//Taken from hydroponics/seed.dm...This should be a global list at some point and reworked in both places.
			var/list/banned_chems = list(
				REAGENT_ID_ADMINORDRAZINE,
				REAGENT_ID_NUTRIMENT,
				REAGENT_ID_MACROCILLIN,
				REAGENT_ID_MICROCILLIN,
				REAGENT_ID_NORMALCILLIN,
				REAGENT_ID_MAGICDUST
				)
			var/additional_chems = 5 //5 random chems added to the syringe! 15u of RANDOM stuff! (I tried to keep this 30, but this was...Horribly bugged. There is no icon_state for 16-30, so the icon was invisible when filled.)
			for(var/x=1;x<=additional_chems;x++)
				var/new_chem = pick(SSchemistry.chemical_reagents)
				if(new_chem in banned_chems)
					continue
				banned_chems += new_chem
				S.reagents.add_reagent(new_chem, 3)

		if(ARCHAEO_RING)
			// Ring.
			if(prob(15))
				apply_prefix = FALSE
			apply_image_decorations = TRUE //It's a ring. Let's just allow you to have fancy decorations on it.
			new_item = new /obj/item/clothing/accessory/ring/material(src.loc)
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
		var/possible_object_paths = list()
		possible_object_paths += subtypesof(/datum/material)
		var/new_item_mat = "MAT_STEEL"
		for(var/x=1;x<=5;x++) //You got 5 chances to hit a metal that is NOT banned.
			var/datum/material/picked_metal = pick(possible_object_paths) //We select
			if(picked_metal in banned_materials)
				continue
			else
				new_item_mat = "[picked_metal.name]" //set_material requires NAME.
				break
		var/obj/item/material/MW = new_item
		MW.applies_material_colour = TRUE
		MW.set_material(new_item_mat)
		if(istype(MW, /obj/item/material/twohanded))
			var/obj/item/material/twohanded/TH = MW
			TH.force_unwielded *= 0.7
			TH.force_wielded *= 0.5
		else
			MW.force *= 0.3

	if(istype(secondary_item, /obj/item/material))
		var/possible_object_paths = list()
		possible_object_paths += subtypesof(/datum/material)
		var/new_item_mat = "MAT_STEEL"
		for(var/x=1;x<=5;x++)
			var/datum/material/picked_metal = pick(possible_object_paths)
			if(picked_metal in banned_materials)
				continue
			else
				new_item_mat = "[picked_metal.name]"
				break
		var/obj/item/material/MW = secondary_item
		MW.applies_material_colour = TRUE
		MW.set_material(new_item_mat)
		if(istype(MW, /obj/item/material/twohanded))
			var/obj/item/material/twohanded/TH = MW
			TH.force_unwielded *= 0.7
			TH.force_wielded *= 0.5
		else
			MW.force *= 0.3

	//Why is ring/material and item/material two different things (and have the same /datum/material var) instead of datum/material being on /obj ? Hell if I know. Someone should fix that eventually. Outside of the scope of this PR.
	if(istype(new_item, /obj/item/clothing/accessory/ring/material))
		var/possible_object_paths = list()
		possible_object_paths += subtypesof(/datum/material)
		var/new_item_mat = "MAT_STEEL"
		for(var/x=1;x<=5;x++) //You got 5 chances to hit a metal that is NOT banned.
			var/datum/material/picked_metal = pick(possible_object_paths) //We select
			if(picked_metal in banned_materials)
				continue
			else
				new_item_mat = "[picked_metal.name]" //set_material requires NAME.
				break
		var/obj/item/clothing/accessory/ring/material/MW = new_item
		MW.set_material(new_item_mat)

	if(istype(secondary_item, /obj/item/clothing/accessory/ring/material))
		var/possible_object_paths = list()
		possible_object_paths += subtypesof(/datum/material)
		var/new_item_mat = "MAT_STEEL"
		for(var/x=1;x<=5;x++)
			var/datum/material/picked_metal = pick(possible_object_paths)
			if(picked_metal in banned_materials)
				continue
			else
				new_item_mat = "[picked_metal.name]"
				break
		var/obj/item/clothing/accessory/ring/material/MW = secondary_item
		MW.set_material(new_item_mat)

	var/decorations = ""
	var/secondary_item_decorations = ""
	if(apply_material_decorations)
		source_material = pick("cordite","quadrinium","chromium","roentgenium","aluminium","ferritic-alloy","meitnerium","tin","hafnium","zirconium","duranium","an unidentifiable alloy","palladium","copper")

		//If we have a material that has a display_name, let's use that! If not, we'll use the random fancy sounding one above.
		if(istype(new_item, /obj/item/material))
			var/obj/item/material/MW = new_item
			if(MW.material && MW.material.display_name)
				source_material = MW.material.display_name

		if(istype(new_item, /obj/item/clothing/accessory/ring/material))
			var/obj/item/clothing/accessory/ring/material/MW = new_item
			if(MW.material && MW.material.display_name)
				source_material = MW.material.display_name

		if(istype(new_item, /obj/vehicle/boat))
			var/obj/vehicle/boat/B = new_item
			if(B.material && B.material.display_name)
				source_material = B.material.display_name

		//I split these apart. Above here is the primary item. Below here is the secondary item.
		if(secondary_item)
			if(istype(secondary_item, /obj/item/material))
				var/obj/item/material/SMW = secondary_item
				if(SMW.material && SMW.material.display_name)
					source_material = SMW.material.display_name

			if(istype(secondary_item, /obj/item/clothing/accessory/ring/material))
				var/obj/item/clothing/accessory/ring/material/SMW = secondary_item
				if(SMW.material && SMW.material.display_name)
					source_material = SMW.material.display_name

			if(istype(secondary_item, /obj/vehicle/boat))
				var/obj/vehicle/boat/SB = secondary_item
				if(SB.material && SB.material.display_name)
					source_material = SB.material.display_name

		desc = "A [material_descriptor ? "[material_descriptor] " : ""][item_type] made of [source_material], all craftsmanship is of [pick("the lowest","low","average","high","the highest")] quality."
		if(secondary_item)
			secondary_item.desc = "A [material_descriptor ? "[material_descriptor] " : ""][secondary_item_type] made of [source_material], all craftsmanship is of [pick("the lowest","low","average","high","the highest")] quality."

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
		if(secondary_item && secondary_item_decorations)
			secondary_item.desc += " " + decorations

	var/engravings = ""
	var/secondary_item_engravings = ""
	if(apply_image_decorations)
		engravings = "[pick("Engraved","Carved","Etched")] on the item is [pick("an image of","a frieze of","a depiction of")] \
		[pick("an alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")] \
		[pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")] \
		[pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")]"
		if(prob(50))
			engravings += ", [pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are making gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")]"
		engravings += "."
		if(secondary_item)
			secondary_item_engravings += "."

		if(desc)
			desc += " "
		desc += engravings
		if(secondary_item && secondary_item.desc)
			desc += " "
			secondary_item.desc += secondary_item_engravings

	if(apply_prefix)
		name = "[pick("Strange","Ancient","Alien","")] [item_type]"
		if(secondary_item)
			secondary_item.name = "[pick("Strange","Ancient","Alien","")] [secondary_item_type]"
	else
		name = item_type
		if(secondary_item)
			secondary_item.name = secondary_item_type

	if(desc)
		desc += " "
	desc += additional_desc
	if(secondary_item && secondary_item.desc)
		secondary_item.desc += secondary_item_desc
	if(!desc)
		desc = "This item is completely [pick("alien","bizarre")]."

	//icon and icon_state should have already been set
	if(new_item)
		new_item.name = name
		new_item.desc = src.desc

		if(talkative)
			new_item.talking_atom = new(new_item)
			if("origin_tech" in new_item.vars)
				var/list/new_tech
				if(new_item.origin_tech)
					new_tech = new_item.origin_tech.Copy()
				else
					new_tech = list()
				new_tech[TECH_ARCANE] += 1
				new_tech[TECH_PRECURSOR] += 1
				new_item.origin_tech = new_tech

		if(become_anomalous)
			new_item.become_anomalous()

		var/turf/simulated/mineral/T = get_turf(new_item)
		if(istype(T))
			T.last_find = new_item
		if(secondary_item) //Is this part of a set?
			if(talkative)
				secondary_item.talking_atom = new(secondary_item)
				LAZYINITLIST(secondary_item.origin_tech)
				secondary_item.origin_tech[TECH_ARCANE] += 1
				secondary_item.origin_tech[TECH_PRECURSOR] += 1

			if(become_anomalous)
				secondary_item.become_anomalous()

		qdel(src)
		return

	else if(talkative)
		src.talking_atom = new(src)
		var/list/new_tech
		if(origin_tech)
			new_tech = origin_tech.Copy()
		else
			new_tech = list()
		new_tech[TECH_ARCANE] += 1
		new_tech[TECH_PRECURSOR] += 1
		origin_tech = new_tech

	if(become_anomalous)
		become_anomalous()


/obj/item/archaeological_find/Destroy()
	if(src.is_anomalous())
		var/datum/component/artifact_master/arti_mstr = GetComponent(/datum/component/artifact_master)
		arti_mstr.RemoveComponent()
		if(!QDELETED(arti_mstr))
			qdel(arti_mstr)

	. = ..()
