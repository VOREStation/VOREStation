/obj/item/stolenpackage
	name = "stolen package"
	desc = "What's in the box?"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate5"
	item_state = "table_parts"
	w_class = ITEMSIZE_HUGE

/obj/item/stolenpackage/attack_self(mob/user as mob)
		// Another way of doing this. Commented out because the other method is better for this application.
		/*var/spawn_chance = rand(1,100)
		switch(spawn_chance)
			if(0 to 49)
				new /obj/random/gun/guarenteed(usr.loc)
				to_chat(usr, "You got a thing!")
			if(50 to 99)
				new /obj/item/weapon/bikehorn/rubberducky(usr.loc)
				new /obj/item/weapon/bikehorn(usr.loc)
				to_chat(usr, "You got two things!")
			if(100)
				to_chat(usr, "The box contained nothing!")
				return
		*/
		var/loot = pick(/obj/effect/landmark/costume,
						/obj/item/clothing/glasses/thermal,
						/obj/item/clothing/gloves/combat,
						/obj/item/clothing/head/bearpelt,
						/obj/item/clothing/mask/balaclava,
						/obj/item/clothing/mask/horsehead,
						/obj/item/clothing/mask/muzzle,
						/obj/item/clothing/suit/armor/heavy,
						/obj/item/clothing/suit/armor/laserproof,
						/obj/item/clothing/suit/armor/vest,
						/obj/item/device/chameleon,
						/obj/item/device/pda/clown,
						/obj/item/device/pda/mime,
						/obj/item/device/pda/syndicate,
						/obj/item/mecha_parts/chassis/phazon,
						/obj/item/mecha_parts/part/phazon_head,
						/obj/item/mecha_parts/part/phazon_left_arm,
						/obj/item/mecha_parts/part/phazon_left_leg,
						/obj/item/mecha_parts/part/phazon_right_arm,
						/obj/item/mecha_parts/part/phazon_right_leg,
						/obj/item/mecha_parts/part/phazon_torso,
						/obj/item/device/bodysnatcher,
						/obj/item/weapon/bluespace_harpoon,
						/obj/item/clothing/accessory/permit/gun,
						/obj/item/device/perfect_tele,
						/obj/item/device/sleevemate,
						/obj/item/weapon/disk/nifsoft/compliance,
						/obj/item/seeds/ambrosiadeusseed,
						/obj/item/seeds/ambrosiavulgarisseed,
						/obj/item/seeds/libertymycelium,
						/obj/fiftyspawner/platinum,
						/obj/item/toy/nanotrasenballoon,
						/obj/item/toy/syndicateballoon,
						/obj/item/weapon/aiModule/syndicate,
						/obj/item/weapon/book/manual/engineering_hacking,
						/obj/item/weapon/card/emag,
						/obj/item/weapon/card/emag_broken,
						/obj/item/weapon/card/id/syndicate,
						/obj/item/poster,
						/obj/item/weapon/disposable_teleporter,
						/obj/item/weapon/grenade/flashbang/clusterbang,
						/obj/item/weapon/grenade/flashbang/clusterbang,
						/obj/item/weapon/grenade/spawnergrenade/spesscarp,
						/obj/item/weapon/melee/energy/sword,
						/obj/item/weapon/melee/telebaton,
						/obj/item/weapon/pen/reagent/paralysis,
						/obj/item/weapon/pickaxe/diamonddrill,
						/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine,
						/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
						/obj/item/weapon/reagent_containers/food/snacks/clownstears,
						/obj/item/weapon/reagent_containers/food/snacks/xenomeat,
						/obj/item/weapon/reagent_containers/glass/beaker/neurotoxin,
						/obj/item/weapon/rig/combat,
						/obj/item/weapon/shield/energy,
						/obj/item/weapon/stamp/centcomm,
						/obj/item/weapon/stamp/solgov,
						/obj/item/weapon/storage/fancy/cigar/havana,
						/obj/item/xenos_claw,
						/obj/random/contraband,
						/obj/random/contraband,
						/obj/random/contraband,
						/obj/random/contraband,
						/obj/random/weapon/guarenteed)
		new loot(usr.loc)
		to_chat(user, "You unwrap the package.")
		qdel(src)

/obj/item/weapon/storage/fancy/cigar/havana // Putting this here 'cuz fuck it. -Spades
	name = "\improper Havana cigar case"
	desc = "Save these for the fancy-pantses at the next CentCom black tie reception. You can't blow the smoke from such majestic stogies in just anyone's face."
	icon_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEMSIZE_TINY
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar/havana)
	icon_type = "cigar"

/obj/item/weapon/miscdisc
	name = "strange artefact"
	desc = "A large disc-shaped item, with a red, opaque crystal embedded in the center. It is some what heavy. There are indentations along the ring of the disc. Alien scripture lines the disc."
	icon_state = "wahdisc"
	icon = 'icons/obj/contraband_vr.dmi'
	w_class = ITEMSIZE_NORMAL

/obj/item/weapon/miscdisc/attack_self(mob/living/user as mob)
	to_chat(user, "As you hold the large disc in your open palm, fingers cusped around the edge, the crystal embedded in the item begins to vibrate. It lifts itself from the disc a few cenimetres, before beginning to glow with a bright red light. The glow lasts for a few seconds, before the crystal embeds itself back into the disc with a quick snap.")