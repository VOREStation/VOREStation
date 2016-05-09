///////////////////////////////////////////////////////////////////////////////////
/// Micro/Macro chemicals

/datum/chemical_reaction/sizeoxadone
	name = "sizeoxadone"
	id = "sizeoxadone"
	result = "sizeoxadone"
	required_reagents = list("clonexadone" = 1, "tramadol" = 3, "phoron" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 5

/datum/chemical_reaction/macrocillin
	name = "Macrocillin"
	id = "macrocillin"
	result = "macrocillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "diethylamine" = 20)
	result_amount = 1

/datum/chemical_reaction/microcillin
	name = "Microcillin"
	id = "microcillin"
	result = "microcillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "sodiumchloride" = 20)
	result_amount = 1

/datum/chemical_reaction/normalcillin
	name = "Normalcillin"
	id = "normalcillin"
	result = "normalcillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "leporazine" = 20)
	result_amount = 1

/datum/chemical_reaction/dontcrossthebeams
	name = "Don't Cross The Beams"
	id = "dontcrossthebeams"
	result = null
	required_reagents = list("microcillin" = 1, "macrocillin" = 1)

/datum/chemical_reaction/dontcrossthebeams/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/weapons/gauss_shoot.ogg', 50, 1)
	var/datum/effect/effect/system/grav_pull/s = new /datum/effect/effect/system/grav_pull
	s.set_up(3, 3, location)
	s.start()
	holder.clear_reagents()

///////////////////////////////////////////////////////////////////////////////////
/// Vore Drugs

/datum/chemical_reaction/ickypak
	name = "Ickypak"
	id = "ickypak"
	result = "ickypak"
	required_reagents = list("hyperzine" = 4, "fluorosurfactant" = 1)
	result_amount = 5

/datum/chemical_reaction/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	result = "unsorbitol"
	required_reagents = list("mutagen" = 3, "lipozine" = 2)
	result_amount = 5
