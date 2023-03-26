/obj/effect/landmark/mobcorpse/syndicatecommando
	name = "Mercenary Commando"

/obj/effect/landmark/mobcorpse/syndicatesoldier/drone
	name = "Mercenary Drone"
	corpseidjob = "Operative"
	corpsesynthtype = 2
	corpsesynthbrand = "Xion"

/obj/effect/landmark/mobcorpse/syndicatesoldier/drone/generateCorpseName()
	var/letter = pick(list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega"))
	var/number = rand(0,999)
	var/purpose = pick(list("Recon","Combat","Kill","Guard","Scout","Murder","Capture","Raid","Attack","Battle"))
	return "[letter]-[number] [purpose] Droid"

/obj/effect/landmark/mobcorpse/syndicatecommando/drone
	name = "Mercenary Drone"
	corpseidjob = "Operative"
	corpsesynthtype = 2
	corpsesynthbrand = "Xion"

/obj/effect/landmark/mobcorpse/syndicatecommando/drone/generateCorpseName()
	var/letter = pick(list("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega"))
	var/number = rand(0,999)
	var/purpose = pick(list("Recon","Combat","Kill","Guard","Scout","Murder","Capture","Raid","Attack","Battle"))
	return "[letter]-[number] [purpose] Droid"
