///////////////////////////////////////////////////////////////////////////////////
/// Micro/Macro chemicals

/decl/chemical_reaction/instant/sizeoxadone
	name = "sizeoxadone"
	id = "sizeoxadone"
	result = "sizeoxadone"
	required_reagents = list("clonexadone" = 1, "tramadol" = 3, "phoron" = 1)
	catalysts = list("phoron" = 5)
	result_amount = 5

/decl/chemical_reaction/instant/macrocillin
	name = "Macrocillin"
	id = "macrocillin"
	result = "macrocillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "diethylamine" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/microcillin
	name = "Microcillin"
	id = "microcillin"
	result = "microcillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "sodiumchloride" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/normalcillin
	name = "Normalcillin"
	id = "normalcillin"
	result = "normalcillin"
	// POLARISTODO requires_heating = 1
	required_reagents = list("sizeoxadone" = 20, "leporazine" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/dontcrossthebeams
	name = "Don't Cross The Beams"
	id = "dontcrossthebeams"
	result = null
	required_reagents = list("microcillin" = 1, "macrocillin" = 1)

/decl/chemical_reaction/instant/dontcrossthebeams/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	playsound(location, 'sound/weapons/gauss_shoot.ogg', 50, 1)
	var/datum/effect/effect/system/grav_pull/s = new /datum/effect/effect/system/grav_pull
	s.set_up(3, 3, location)
	s.start()
	holder.clear_reagents()

///////////////////////////////////////////////////////////////////////////////////
/// TF chemicals
/decl/chemical_reaction/instant/amorphorovir
	name = "Amorphorovir"
	id = "amorphorovir"
	result = "amorphorovir"
	required_reagents = list("cryptobiolin" = 30, "biomass" = 30, "hyperzine" = 20)
	catalysts = list("phoron" = 5)
	result_amount = 1

/decl/chemical_reaction/instant/androrovir
	name = "Androrovir"
	id = "androrovir"
	result = "androrovir"
	required_reagents = list("amorphorovir" = 1, "bicaridine" = 20, "iron" = 20, "ethanol" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/gynorovir
	name = "Gynorovir"
	id = "gynorovir"
	result = "gynorovir"
	required_reagents = list("amorphorovir" = 1, "inaprovaline" = 20, "silicon" = 20, "sugar" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/androgynorovir
	name = "Androgynorovir"
	id = "androgynorovir"
	result = "androgynorovir"
	required_reagents = list("amorphorovir" = 1, "anti_toxin" = 20, "fluorine" = 20, "tungsten" = 20)
	result_amount = 1

/decl/chemical_reaction/instant/androrovir_bootleg
	name = "Bootleg Androrovir"
	id = "androrovir_bootleg"
	result = "androrovir"
	required_reagents = list("amorphorovir" = 1, "protein" = 10, "capsaicin" = 10)
	result_amount = 1

/decl/chemical_reaction/instant/gynorovir_bootleg
	name = "Bootleg Gynorovir"
	id = "gynorovir_bootleg"
	result = "gynorovir"
	required_reagents = list("amorphorovir" = 1, "soymilk" = 10, "sugar" = 10)
	result_amount = 1

/decl/chemical_reaction/instant/androgynorovir_bootleg
	name = "Bootleg Androgynorovir"
	id = "androgynorovir_bootleg"
	result = "androgynorovir"
	required_reagents = list("amorphorovir" = 1, "cola" = 10, "berryjuice" = 10)
	result_amount = 1

///////////////////////////////////////////////////////////////////////////////////
/// Miscellaneous Reactions

/decl/chemical_reaction/instant/foam/softdrink
	required_reagents = list("cola" = 1, "mint" = 1)

/decl/chemical_reaction/instant/firefightingfoam //TODO: Make it so we can add this to the foam tanks to refill them
    name = "Firefighting Foam"
    id = "firefighting foam"
    result = "firefoam"
    required_reagents = list("water" = 1)
    catalysts = list("fluorine" = 10)
    result_amount = 1

/decl/chemical_reaction/instant/firefightingfoamqol //Please don't abuse this and make us remove it. Seriously.
    name = "Firefighting Foam EZ"
    id = "firefighting foam ez"
    result = "firefoam"
    required_reagents = list("water" = 1)
    catalysts = list("firefoam" = 5)
    inhibitors = list("fluorine" = 0.01)
    result_amount = 1

///////////////////////////////////////////////////////////////////////////////////
/// Vore Drugs

/decl/chemical_reaction/instant/ickypak
	name = "Ickypak"
	id = "ickypak"
	result = "ickypak"
	required_reagents = list("hyperzine" = 4, "fluorosurfactant" = 1)
	result_amount = 5

/decl/chemical_reaction/instant/unsorbitol
	name = "Unsorbitol"
	id = "unsorbitol"
	result = "unsorbitol"
	required_reagents = list("mutagen" = 3, "lipozine" = 2)
	result_amount = 5

///////////////////////////////////////////////////////////////////////////////////
/// Other Drugs
/decl/chemical_reaction/instant/adranol
	name = "Adranol"
	id = "adranol"
	result = "adranol"
	required_reagents = list("milk" = 2, "hydrogen" = 1, "potassium" = 1)
	result_amount = 3

/decl/chemical_reaction/instant/vermicetol
	name = "Vermicetol"
	id = "vermicetol"
	result = "vermicetol"
	required_reagents = list("bicaridine" = 2, "shockchem" = 1, "phoron" = 0.1)
	catalysts = list("phoron" = 5)
	result_amount = 3

/decl/chemical_reaction/instant/prussian_blue
	name = "Prussian Blue"
	id = "prussian_blue"
	result = "prussian_blue"
	required_reagents = list("carbon" = 3, "iron" = 1, "nitrogen" = 3)
	result_amount = 7

/decl/chemical_reaction/instant/lipozilase
	name = "Lipozilase"
	id = "Lipozilase"
	result = "lipozilase"
	required_reagents = list("lipozine" = 1, "diethylamine" = 1)
	result_amount = 2

/decl/chemical_reaction/instant/lipostipo
	name = "Lipostipo"
	id = "Lipostipo"
	result = "lipostipo"
	required_reagents = list("lipozine" = 1, "nutriment" = 1, "fluorine" = 1)
	result_amount = 3

///////////////////////////////////////////////////////////////////////////////////
/// Reagent colonies.
/decl/chemical_reaction/instant/meatcolony
	name = "protein"
	id = "meatcolony"
	result = "protein"
	required_reagents = list("meatcolony" = 5, "virusfood" = 5)
	result_amount = 60

/decl/chemical_reaction/instant/plantcolony
	name = "nutriment"
	id = "plantcolony"
	result = "nutriment"
	required_reagents = list("plantcolony" = 5, "virusfood" = 5)
	result_amount = 60

///////////////////////////////////////////////////////////////////////////////////
/// Upstream Adjustments
/decl/chemical_reaction/instant/biomass
	result_amount = 6	// Roughly 120u per phoron sheet

///////////////////////////////
//SLIME-RELATED BELOW HERE///////
///////////////////////////////
/decl/chemical_reaction/instant/slimeify
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin2"
	result = "advmutationtoxin"
	required_reagents = list("phoron" = 15, "slimejelly" = 15, "mutationtoxin" = 15) //In case a xenobiologist wants to become a fully fledged slime person.
	result_amount = 1