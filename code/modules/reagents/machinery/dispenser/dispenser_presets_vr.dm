/obj/machinery/chemical_dispenser/xenoflora
	name = "xenoflora chem dispenser"
	ui_title = "Xenoflora Chemical Dispenser"
	dispense_reagents = list(
		REAGENT_ID_WATER, REAGENT_ID_SUGAR, REAGENT_ID_ETHANOL, REAGENT_ID_RADIUM, REAGENT_ID_AMMONIA, REAGENT_ID_DIETHYLAMINE, REAGENT_ID_PLANTBGONE, REAGENT_ID_MUTAGEN, REAGENT_ID_CALCIUM
		)

/obj/machinery/chemical_dispenser/xenoflora/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/water,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/ethanol,
			/obj/item/reagent_containers/chem_disp_cartridge/radium,
			/obj/item/reagent_containers/chem_disp_cartridge/ammonia,
			/obj/item/reagent_containers/chem_disp_cartridge/diethylamine,
			/obj/item/reagent_containers/chem_disp_cartridge/plantbgone,
			/obj/item/reagent_containers/chem_disp_cartridge/mutagen,
			/obj/item/reagent_containers/chem_disp_cartridge/calcium
		)

/obj/machinery/chemical_dispenser/biochemistry
	name = "bioproduct dispenser"
	ui_title = "Bioproduct Dispenser"
	dispense_reagents = list(
		REAGENT_ID_NUTRIMENT, REAGENT_ID_PROTEIN, REAGENT_ID_MILK
		)

/obj/machinery/chemical_dispenser/biochemistry/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/nutriment,
			/obj/item/reagent_containers/chem_disp_cartridge/protein,
			/obj/item/reagent_containers/chem_disp_cartridge/milk
		)

/obj/machinery/chemical_dispenser/ert/specialops
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/inaprov,
			/obj/item/reagent_containers/chem_disp_cartridge/dylovene,
			/obj/item/reagent_containers/chem_disp_cartridge/ryetalyn,
			/obj/item/reagent_containers/chem_disp_cartridge/tramadol,
			/obj/item/reagent_containers/chem_disp_cartridge/oxycodone,
			/obj/item/reagent_containers/chem_disp_cartridge/sterilizine,
			/obj/item/reagent_containers/chem_disp_cartridge/leporazine,
			/obj/item/reagent_containers/chem_disp_cartridge/kelotane,
			/obj/item/reagent_containers/chem_disp_cartridge/dermaline,
			/obj/item/reagent_containers/chem_disp_cartridge/dexalin,
			/obj/item/reagent_containers/chem_disp_cartridge/dexalin_p,
			/obj/item/reagent_containers/chem_disp_cartridge/synaptizine,
			/obj/item/reagent_containers/chem_disp_cartridge/hyronalin,
			/obj/item/reagent_containers/chem_disp_cartridge/arithrazine,
			/obj/item/reagent_containers/chem_disp_cartridge/alkysine,
			/obj/item/reagent_containers/chem_disp_cartridge/imidazoline,
			/obj/item/reagent_containers/chem_disp_cartridge/peridaxon,
			/obj/item/reagent_containers/chem_disp_cartridge/bicaridine,
			/obj/item/reagent_containers/chem_disp_cartridge/hyperzine,
			/obj/item/reagent_containers/chem_disp_cartridge/rezadone,
			/obj/item/reagent_containers/chem_disp_cartridge/spaceacillin,
			/obj/item/reagent_containers/chem_disp_cartridge/ethylredox,
			/obj/item/reagent_containers/chem_disp_cartridge/carthatoline,
			/obj/item/reagent_containers/chem_disp_cartridge/corophizine,
			/obj/item/reagent_containers/chem_disp_cartridge/myelamine,
			/obj/item/reagent_containers/chem_disp_cartridge/osteodaxon,
			/obj/item/reagent_containers/chem_disp_cartridge/biomass,
			/obj/item/reagent_containers/chem_disp_cartridge/iron,
			/obj/item/reagent_containers/chem_disp_cartridge/nutriment,
			/obj/item/reagent_containers/chem_disp_cartridge/protein
		)

/obj/machinery/chemical_dispenser/ert/specialops/abductor
	name = "chemical dispenser"
	icon_state = "dispenser_2way"
	desc = "A mysterious machine which can fabricate many chemicals."
