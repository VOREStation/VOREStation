/obj/machinery/chemical_dispenser/xenoflora
	name = "xenoflora chem dispenser"
	icon = 'icons/obj/chemical_vr.dmi'
	icon_state = "dispenser-small-green"
	ui_title = "Xenoflora Chemical Dispenser"
	dispense_reagents = list(
		"water", "sugar", "ethanol", "radium", "ammonia", "diethylamine", "plantbgone", "mutagen", "calcium"
		)

/obj/machinery/chemical_dispenser/xenoflora/full
	spawn_cartridges = list(
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/water,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/ethanol,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/radium,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/ammonia,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/diethylamine,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/plantbgone,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/mutagen,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/calcium
		)

/obj/machinery/chemical_dispenser/biochemistry
	name = "bioproduct dispenser"
	icon = 'icons/obj/chemical_vr.dmi'
	icon_state = "dispenser-small"
	ui_title = "Bioproduct Dispenser"
	dispense_reagents = list(
		"nutriment", "protein", "milk"
		)

/obj/machinery/chemical_dispenser/biochemistry/full
	spawn_cartridges = list(
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/nutriment,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/protein,
			/obj/item/weapon/reagent_containers/chem_disp_cartridge/milk
		)