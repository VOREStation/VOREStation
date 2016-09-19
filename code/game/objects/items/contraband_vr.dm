/obj/item/stolenpackage
	name = "stolen package"
	desc = "What's in the box?"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate4"
	item_state = "table_parts"
	w_class = 5

	attack_self(mob/user as mob)
		// Another way of doing this. Commented out because the other method is better for this application.
		/*var/spawn_chance = rand(1,100)
		switch(spawn_chance)
			if(0 to 49)
				new /obj/random/gun/guarenteed(usr.loc)
				usr << "You got a thing!"
			if(50 to 99)
				new /obj/item/weapon/bikehorn/rubberducky(usr.loc)
				new /obj/item/weapon/bikehorn(usr.loc)
				usr << "You got two things!"
			if(100)
				usr << "The box contained nothing!"
				return
		*/
		var/loot = pick(/obj/random/contraband,
						/obj/random/contraband,
						/obj/item/weapon/book/manual/engineering_hacking,
						/obj/item/device/chameleon,
						/obj/item/weapon/contraband/poster,
						/obj/item/seeds/ambrosiadeusseed,
						/obj/item/seeds/ambrosiavulgarisseed,
						/obj/item/seeds/libertymycelium,
						/obj/item/xenos_claw,
						/obj/item/weapon/reagent_containers/food/snacks/xenomeat,
						/obj/item/weapon/reagent_containers/food/snacks/clownstears,
						/obj/item/weapon/reagent_containers/food/snacks/carpmeat,
						/obj/item/clothing/glasses/thermal,
						/obj/item/clothing/gloves/combat,
						/obj/item/clothing/head/bearpelt,
						/obj/item/clothing/mask/balaclava,
						/obj/item/weapon/storage/fancy/cigar/havana,
						/obj/item/clothing/mask/horsehead,
						/obj/item/clothing/mask/muzzle,
						/obj/item/weapon/storage/toolbox/syndicate,
						/obj/item/weapon/stamp/centcomm,
						/obj/item/weapon/stamp/solgov,
						/obj/item/weapon/storage/bible/booze,
						/obj/item/weapon/pen/reagent/paralysis,
						/obj/item/weapon/grenade/flashbang/clusterbang,
						/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine,
						/obj/item/weapon/reagent_containers/glass/beaker/neurotoxin,
						/obj/item/weapon/grenade/flashbang/clusterbang,
						/obj/item/weapon/grenade/spawnergrenade/spesscarp,
						/obj/item/weapon/card/emag,
						/obj/item/weapon/card/emag_broken,
						/obj/item/device/pda/syndicate,
						/obj/item/weapon/shield/energy,
						/obj/item/weapon/melee/energy/sword,
						/obj/item/weapon/melee/telebaton,
						/obj/item/weapon/melee/classic_baton,
						/obj/item/clothing/suit/armor/heavy,
						/obj/item/clothing/suit/armor/vest,
						/obj/item/clothing/suit/armor/laserproof,
						/obj/random/weapon/guarenteed,
						/obj/item/weapon/material/knuckledusters,
						/obj/effect/landmark/costume,
						/obj/item/mecha_parts/chassis/phazon,
						/obj/item/mecha_parts/part/phazon_torso,
						/obj/item/mecha_parts/part/phazon_head,
						/obj/item/mecha_parts/part/phazon_left_arm,
						/obj/item/mecha_parts/part/phazon_right_arm,
						/obj/item/mecha_parts/part/phazon_left_leg,
						/obj/item/mecha_parts/part/phazon_right_leg)
		new loot(usr.loc)
		usr << "You unwrap the package."
		del(src)

/obj/item/weapon/storage/fancy/cigar/havana // Putting this here 'cuz fuck it. -Spades
	name = "\improper Havana cigar case"
	desc = "Save these for the fancy-pantses at the next CentCom black tie reception. You can't blow the smoke from such majestic stogies in just anyone's face."
	icon_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar/havana)
	icon_type = "cigar"