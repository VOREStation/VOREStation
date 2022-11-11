/decl/chemical_reaction/instant/vox_protoslurry
	name = "Vox Protoslurry"
	id = "voxslurry"
	result = "protoslurry"
	result_amount = 4
	required_reagents = list(
		"iron" =    1,
		"carbon" =  1,
		"protein" = 2
	)
	catalysts = list("voxenzyme" = 5)

/decl/chemical_reaction/instant/vox_medication
	name = "Vox Medication"
	id = "vox_medication"
	result = "voxmeds"
	result_amount = 2
	required_reagents = list(
		"voxslurry" = 2,
		"protein" = 2,
		"silicon" = 1
	)

/decl/chemical_reaction/instant/vox_dissolve
	result_amount = 1
	catalysts = list("voxenzyme" = 1)

/decl/chemical_reaction/instant/vox_dissolve/egg
	name = "Vox Egg Dissolution"
	id = "vox_dissolve_egg"
	result = "protein"
	required_reagents = list("egg" = 1)

/decl/chemical_reaction/instant/vox_dissolve/woodpulp
	name = "Vox Wood Pulp Dissolution"
	id = "vox_dissolve_woodpulp"
	result = "carbon"
	required_reagents = list("woodpulp" = 1)

/decl/chemical_reaction/instant/vox_dissolve/plasticide
	name = "Vox Plasticide Dissolution"
	id = "vox_dissolve_plasticide"
	result = "carbon"
	required_reagents = list("plasticide" = 1)

/decl/chemical_reaction/instant/vox_dissolve/blood
	name = "Vox Blood Dissolution"
	id = "vox_dissolve_blood"
	result = "iron"
	result_amount = 0.5
	required_reagents = list("blood" = 1)

/decl/chemical_reaction/instant/vox_dissolve/blood/on_reaction(var/datum/reagents/holder, var/created_volume)
	. = ..()
	if(created_volume)
		holder.add_reagent("protein", created_volume)

/decl/chemical_reaction/instant/vox_booze
	name = "Riaaak"
	id = "voxbooze"
	result = "voxbooze"
	required_reagents = list(
		"voxslurry" = 5,
		"fuel" = 5,
		"hydrogen" = 5
	)
	catalysts = list("voxenzyme" = 5)
	result_amount = 15
