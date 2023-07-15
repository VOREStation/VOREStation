/obj/effect/landmark/mobcorpse/syndicatecommando
	name = "Mercenary Commando"

/obj/effect/landmark/mobcorpse/syndicatesoldier/drone
	name = "Mercenary Drone"
	corpseidjob = "Operative"
	corpsesynthtype = 1
	corpsesynthbrand = "Xion"

/obj/effect/landmark/mobcorpse/syndicatesoldier/drone/generateCorpseName()
	var/letter = pick(list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega"))
	var/number = rand(0,999)
	var/purpose = pick(list("Recon","Combat","Kill","Guard","Scout","Murder","Capture","Raid","Attack","Battle"))
	return "[letter]-[number] [purpose] Droid"

/obj/effect/landmark/mobcorpse/syndicatecommando/drone
	name = "Mercenary Drone"
	corpseidjob = "Operative"
	corpsesynthtype = 1
	corpsesynthbrand = "Xion"

/obj/effect/landmark/mobcorpse/syndicatecommando/drone/generateCorpseName()
	var/letter = pick(list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega"))
	var/number = rand(0,999)
	var/purpose = pick(list("Recon","Combat","Kill","Guard","Scout","Murder","Capture","Raid","Attack","Battle"))
	return "[letter]-[number] [purpose] Droid"

/obj/effect/landmark/mobcorpse/altevian
	name = "Altevian Naval Officer"
	corpseuniform = /obj/item/clothing/under/altevian
	corpsesuit = /obj/item/clothing/suit/space/void/altevian_heartbreaker
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/device/radio/headset
	corpsemask = /obj/item/clothing/mask/altevian_breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/altevian_heartbreaker
	corpseid = 1
	corpseidjob = "Altevian Navy"
	corpseidaccess = "Syndicate"
	species = SPECIES_ALTEVIAN
	ear_type = list(/datum/sprite_accessory/ears/altevian, "#777777", "#FFCCFF")
	tail_type = list(/datum/sprite_accessory/tail/altevian, "#FF9999")