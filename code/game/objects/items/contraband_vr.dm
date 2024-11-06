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
			new /obj/item/bikehorn/rubberducky(usr.loc)
			new /obj/item/bikehorn(usr.loc)
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
					/obj/item/chameleon,
					/obj/item/pda/clown,
					/obj/item/pda/mime,
					/obj/item/pda/syndicate,
					/obj/item/mecha_parts/chassis/phazon,
					/obj/item/mecha_parts/part/phazon_head,
					/obj/item/mecha_parts/part/phazon_left_arm,
					/obj/item/mecha_parts/part/phazon_left_leg,
					/obj/item/mecha_parts/part/phazon_right_arm,
					/obj/item/mecha_parts/part/phazon_right_leg,
					/obj/item/mecha_parts/part/phazon_torso,
					/obj/item/circuitboard/mecha/phazon/targeting,
					/obj/item/circuitboard/mecha/phazon/peripherals,
					/obj/item/circuitboard/mecha/phazon/main,
					/obj/item/bodysnatcher,
					/obj/item/bluespace_harpoon,
					/obj/item/clothing/accessory/permit/gun,
					/obj/item/perfect_tele,
					/obj/item/sleevemate,
					/obj/item/disk/nifsoft/compliance,
					/obj/item/implanter/compliance,
					/obj/item/seeds/ambrosiadeusseed,
					/obj/item/seeds/ambrosiavulgarisseed,
					/obj/item/seeds/libertymycelium,
					/obj/fiftyspawner/platinum,
					/obj/item/toy/nanotrasenballoon,
					/obj/item/toy/syndicateballoon,
					/obj/item/aiModule/syndicate,
					/obj/item/book/manual/wiki/engineering_hacking,
					/obj/item/card/emag,
					/obj/item/card/emag_broken,
					/obj/item/card/id/syndicate,
					/obj/item/poster,
					/obj/item/disposable_teleporter,
					/obj/item/grenade/flashbang/clusterbang,
					/obj/item/grenade/flashbang/clusterbang,
					/obj/item/grenade/spawnergrenade/spesscarp,
					/obj/item/melee/energy/sword,
					/obj/item/melee/telebaton,
					/obj/item/pen/reagent/paralysis,
					/obj/item/pickaxe/diamonddrill,
					/obj/item/reagent_containers/food/drinks/bottle/pwine,
					/obj/item/reagent_containers/food/snacks/carpmeat,
					/obj/item/reagent_containers/food/snacks/clownstears,
					/obj/item/reagent_containers/food/snacks/xenomeat,
					/obj/item/reagent_containers/glass/beaker/neurotoxin,
					/obj/item/rig/combat,
					/obj/item/shield/energy,
					/obj/item/stamp/centcomm,
					/obj/item/stamp/solgov,
					/obj/item/storage/fancy/cigar/havana,
					/obj/item/xenos_claw,
					/obj/random/contraband,
					/obj/random/contraband,
					/obj/random/contraband,
					/obj/random/contraband,
					/obj/random/weapon/guarenteed)
	//VOREstation edit - Randomized map objects were put in loot piles, so handle them...
	if(istype(loot,/obj/random))
		var/obj/random/randy = loot
		var/new_I = randy.spawn_item()
		qdel(loot)
		loot = new_I // swap it
	//VOREstation edit end
	new loot(usr.loc)
	to_chat(user, "You unwrap the package.")
	qdel(src)

/obj/item/miscdisc
	name = "strange artefact"
	desc = "A large disc-shaped item, with a red, opaque crystal embedded in the center. It is some what heavy. There are indentations along the ring of the disc. Alien scripture lines the disc."
	icon_state = "wahdisc"
	icon = 'icons/obj/contraband_vr.dmi'
	w_class = ITEMSIZE_NORMAL

/obj/item/miscdisc/attack_self(mob/living/user as mob)
	to_chat(user, "As you hold the large disc in your open palm, fingers cusped around the edge, the crystal embedded in the item begins to vibrate. It lifts itself from the disc a few cenimetres, before beginning to glow with a bright red light. The glow lasts for a few seconds, before the crystal embeds itself back into the disc with a quick snap.")
