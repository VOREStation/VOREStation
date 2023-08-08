var/global/list/robot_modules = list(
	"Standard"		= /obj/item/weapon/robot_module/robot/standard,
	"Service" 		= /obj/item/weapon/robot_module/robot/clerical/butler/general,
	"Clerical" 		= /obj/item/weapon/robot_module/robot/clerical/general,
	"Research" 		= /obj/item/weapon/robot_module/robot/research/general,
	"Miner" 		= /obj/item/weapon/robot_module/robot/miner/general,
	"Crisis" 		= /obj/item/weapon/robot_module/robot/medical/crisis,
	"Surgeon" 		= /obj/item/weapon/robot_module/robot/medical/surgeon,
	"Security" 		= /obj/item/weapon/robot_module/robot/security/general,
	"Combat" 		= /obj/item/weapon/robot_module/robot/security/combat,
	"Engineering"	= /obj/item/weapon/robot_module/robot/engineering/general,
	"Janitor" 		= /obj/item/weapon/robot_module/robot/janitor/general,
	"Gravekeeper"	= /obj/item/weapon/robot_module/robot/gravekeeper,
	"Lost"			= /obj/item/weapon/robot_module/robot/lost,
	"Protector" 	= /obj/item/weapon/robot_module/robot/syndicate/protector,
	"Mechanist" 	= /obj/item/weapon/robot_module/robot/syndicate/mechanist,
	"Combat Medic"	= /obj/item/weapon/robot_module/robot/syndicate/combat_medic
	)

/obj/item/weapon/robot_module
	name = "robot module"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = ITEMSIZE_NO_CONTAINER
	item_state = "std_mod"
	var/pto_type = null
	var/hide_on_manifest = FALSE
	var/channels = list()
	var/networks = list()
	var/languages = list(LANGUAGE_SOL_COMMON= 1,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_UNATHI		= 0,
					LANGUAGE_SIIK		= 0,
					LANGUAGE_SKRELLIAN	= 0,
					LANGUAGE_GUTTER		= 0,
					LANGUAGE_SCHECHI	= 0,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_BIRDSONG	= 0,
					LANGUAGE_SAGARU		= 0,
					LANGUAGE_CANILUNZT	= 0,
					LANGUAGE_ECUREUILIAN= 0,
					LANGUAGE_DAEMON		= 0,
					LANGUAGE_ENOCHIAN	= 0,
					LANGUAGE_DRUDAKAR	= 0)
	var/can_be_pushed = 0
	var/no_slip = 0
	var/list/modules = list()
	var/list/datum/matter_synth/synths = list()
	var/obj/item/emag = null
	var/obj/item/borg/upgrade/jetpack = null
	var/obj/item/borg/upgrade/advhealth = null
	var/list/subsystems = list()
	var/list/obj/item/borg/upgrade/supported_upgrades = list()

	// Bookkeeping
	var/list/original_languages = list()
	var/list/added_networks = list()

/obj/item/weapon/robot_module/proc/hide_on_manifest()
	. = hide_on_manifest

/obj/item/weapon/robot_module/New(var/mob/living/silicon/robot/R)
	..()
	R.module = src

	add_camera_networks(R)
	add_languages(R)
	add_subsystems(R)
	apply_status_flags(R)
	handle_shell(R)

	if(R.radio)
		if(R.shell)
			channels = R.mainframe.aiRadio.channels
		R.radio.recalculateChannels()

	R.set_default_module_icon()
	R.choose_icon(SSrobot_sprites.get_module_sprites_len(R.modtype) + 1)
	if(!R.client)
		R.icon_selected = FALSE			// It wasnt a player selecting icon? Let them do it later!


	for(var/obj/item/I in modules)
		I.canremove = FALSE

/obj/item/weapon/robot_module/proc/Reset(var/mob/living/silicon/robot/R)
	remove_camera_networks(R)
	remove_languages(R)
	remove_subsystems(R)
	remove_status_flags(R)

	if(R.radio)
		R.radio.recalculateChannels()
	R.choose_icon(0)

/obj/item/weapon/robot_module/Destroy()
	for(var/module in modules)
		qdel(module)
	for(var/synth in synths)
		qdel(synth)
	modules.Cut()
	synths.Cut()
	qdel(emag)
	qdel(jetpack)
	emag = null
	jetpack = null
	return ..()

/obj/item/weapon/robot_module/emp_act(severity)
	if(modules)
		for(var/obj/O in modules)
			O.emp_act(severity)
	if(emag)
		emag.emp_act(severity)
	if(synths)
		for(var/datum/matter_synth/S in synths)
			S.emp_act(severity)
	..()
	return

/obj/item/weapon/robot_module/proc/respawn_consumable(var/mob/living/silicon/robot/R, var/rate)
	if(!synths || !synths.len)
		return

	for(var/datum/matter_synth/T in synths)
		T.add_charge(T.recharge_rate * rate)

/obj/item/weapon/robot_module/proc/rebuild()//Rebuilds the list so it's possible to add/remove items from the module
	var/list/temp_list = modules
	modules = list()
	for(var/obj/O in temp_list)
		if(O)
			modules += O

/obj/item/weapon/robot_module/proc/add_languages(var/mob/living/silicon/robot/R)
	// Stores the languages as they were before receiving the module, and whether they could be synthezized.
	for(var/datum/language/language_datum in R.languages)
		original_languages[language_datum] = (language_datum in R.speech_synthesizer_langs)

	for(var/language in languages)
		R.add_language(language, languages[language])

/obj/item/weapon/robot_module/proc/remove_languages(var/mob/living/silicon/robot/R)
	// Clear all added languages, whether or not we originally had them.
	for(var/language in languages)
		R.remove_language(language)

	// Then add back all the original languages, and the relevant synthezising ability
	for(var/original_language in original_languages)
		R.add_language(original_language, original_languages[original_language])
	original_languages.Cut()

/obj/item/weapon/robot_module/proc/add_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera && (NETWORK_ROBOTS in R.camera.network))
		for(var/network in networks)
			if(!(network in R.camera.network))
				R.camera.add_network(network)
				added_networks |= network

/obj/item/weapon/robot_module/proc/remove_camera_networks(var/mob/living/silicon/robot/R)
	if(R.camera)
		R.camera.remove_networks(added_networks)
	added_networks.Cut()

/obj/item/weapon/robot_module/proc/add_subsystems(var/mob/living/silicon/robot/R)
	R.verbs |= subsystems

/obj/item/weapon/robot_module/proc/remove_subsystems(var/mob/living/silicon/robot/R)
	R.verbs -= subsystems

/obj/item/weapon/robot_module/proc/apply_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags &= ~CANPUSH

/obj/item/weapon/robot_module/proc/remove_status_flags(var/mob/living/silicon/robot/R)
	if(!can_be_pushed)
		R.status_flags |= CANPUSH

/obj/item/weapon/robot_module/proc/handle_shell(var/mob/living/silicon/robot/R)
	if(R.braintype == BORG_BRAINTYPE_AI_SHELL)
		channels = list(
			"Medical" = 1,
			"Engineering" = 1,
			"Security" = 1,
			"Service" = 1,
			"Supply" = 1,
			"Science" = 1,
			"Command" = 1,
			"Away Team" = 1
			)

// Cyborgs (non-drones), default loadout. This will be given to every module.
/obj/item/weapon/robot_module/robot/New()
	..()
	src.modules += new /obj/item/device/flash/robot(src)
	src.modules += new /obj/item/weapon/tool/crowbar/cyborg(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/device/gps/robot(src)
	vr_new() // Vorestation Edit: For modules in robot_modules_vr.dm

/obj/item/weapon/robot_module/robot/standard
	name = "standard robot module"
	pto_type = PTO_CIVILIAN

/obj/item/weapon/robot_module/robot/standard/New()
	..()
	src.modules += new /obj/item/weapon/melee/baton/loaded(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.emag = new /obj/item/weapon/melee/energy/sword(src)

/obj/item/weapon/robot_module/robot/medical
	name = "medical robot module"
	channels = list("Medical" = 1)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	pto_type = PTO_MEDICAL

/obj/item/weapon/robot_module/robot/medical/surgeon
	name = "surgeon robot module"


/obj/item/weapon/robot_module/robot/medical/surgeon/New()
	..()
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/surgeon(src)
	src.modules += new /obj/item/weapon/autopsy_scanner(src)
	src.modules += new /obj/item/weapon/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/hemostat/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/retractor/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/cautery/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bonegel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/FixOVein/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bonesetter/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/surgicaldrill/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/bioregen/cyborg(src) //VoreStation Edit: LET ME SUCC
	src.modules += new /obj/item/weapon/gripper/no_use/organ(src)
	src.modules += new /obj/item/weapon/gripper/medical(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot(src)
	src.modules += new /obj/item/weapon/reagent_containers/dropper(src) // Allows surgeon borg to fix necrosis
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(10000)
	synths += medicine

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src) //VoreStation edit: we have burn surgeries so they should be able to do them
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	src.modules += N
	src.modules += B
	src.modules += O

/obj/item/weapon/robot_module/robot/medical/surgeon/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2 * amount)

	..()

/obj/item/weapon/robot_module/robot/medical/crisis
	name = "crisis robot module"

/obj/item/weapon/robot_module/robot/medical/crisis/New()
	..()
	src.modules += new /obj/item/device/healthanalyzer(src)
	src.modules += new /obj/item/device/reagent_scanner/adv(src)
	src.modules += new /obj/item/roller_holder(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/crisis(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.modules += new /obj/item/weapon/gripper/no_use/organ(src)
	src.modules += new /obj/item/weapon/gripper/medical(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot(src)
	src.modules += new /obj/item/weapon/inflatable_dispenser/robot(src) //VOREStation Add - This is kinda important for rescuing people without making it worse for everyone
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("pacid", 250)
	src.emag.name = "Polyacid spray"

	var/datum/matter_synth/medicine = new /datum/matter_synth/medicine(15000)
	synths += medicine

	var/obj/item/stack/medical/advanced/ointment/O = new /obj/item/stack/medical/advanced/ointment(src)
	var/obj/item/stack/medical/advanced/bruise_pack/B = new /obj/item/stack/medical/advanced/bruise_pack(src)
	var/obj/item/stack/medical/splint/S = new /obj/item/stack/medical/splint(src)
	O.uses_charge = 1
	O.charge_costs = list(1000)
	O.synths = list(medicine)
	B.uses_charge = 1
	B.charge_costs = list(1000)
	B.synths = list(medicine)
	S.uses_charge = 1
	S.charge_costs = list(1000)
	S.synths = list(medicine)
	src.modules += O
	src.modules += B
	src.modules += S

/obj/item/weapon/robot_module/robot/medical/crisis/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/PS = src.emag
		PS.reagents.add_reagent("pacid", 2 * amount)

	..()


/obj/item/weapon/robot_module/robot/engineering
	name = "engineering robot module"
	channels = list("Engineering" = 1)
	networks = list(NETWORK_ENGINEERING)
	subsystems = list(/mob/living/silicon/proc/subsystem_power_monitor)
	pto_type = PTO_ENGINEERING

/obj/item/weapon/robot_module/robot/engineering/general/New()
	..()
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/analyzer(src)
	src.modules += new /obj/item/taperoll/engineering(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/weapon/gripper/circuit(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	// RPDs do this already
	//src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/weapon/pipe_dispenser(src)
	src.modules += new /obj/item/device/floor_painter(src)
	src.modules += new /obj/item/weapon/inflatable_dispenser/robot(src)
	src.emag = new /obj/item/weapon/melee/baton/robot/arm(src)
	src.modules += new /obj/item/device/geiger(src)
	src.modules += new /obj/item/weapon/rcd/electric/mounted/borg(src)
	src.modules += new /obj/item/weapon/pickaxe/plasmacutter/borg(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(40000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(40000)
	var/datum/matter_synth/plasteel = new /datum/matter_synth/plasteel(20000)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(40000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(40000)

	var/datum/matter_synth/wire = new /datum/matter_synth/wire()
	synths += metal
	synths += glass
	synths += plasteel
	synths += wood
	synths += plastic
	synths += wire

	var/obj/item/weapon/matter_decompiler/MD = new /obj/item/weapon/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/material/cyborg/plasteel/PS = new (src)
	PS.synths = list(plasteel)
	src.modules += PS

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/tile/roofing/cyborg/CT = new /obj/item/stack/tile/roofing/cyborg(src)
	CT.synths = list(metal)
	src.modules += CT

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	src.modules += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/PL = new (src)
	PL.synths = list(plastic)
	src.modules += PL

/obj/item/weapon/robot_module/robot/security
	name = "security robot module"
	channels = list("Security" = 1)
	networks = list(NETWORK_SECURITY)
	subsystems = list(/mob/living/silicon/proc/subsystem_crew_monitor)
	supported_upgrades = list(/obj/item/borg/upgrade/tasercooler)
	pto_type = PTO_SECURITY

/obj/item/weapon/robot_module/robot/security/general
	name = "security robot module"

/obj/item/weapon/robot_module/robot/security/general/New()
	..()
	src.modules += new /obj/item/weapon/handcuffs/cyborg(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg(src)
	// src.modules += new /obj/item/weapon/gun/energy/taser/xeno/sec/robot(src) // VOREStation Edit - We don't need these
	src.modules += new /obj/item/taperoll/police(src)
	src.modules += new /obj/item/weapon/reagent_containers/spray/pepper(src)
	src.modules += new /obj/item/weapon/gripper/security(src)
	src.modules += new /obj/item/device/ticket_printer(src)	//VOREStation Add
	src.emag = new /obj/item/weapon/gun/energy/laser/mounted(src)

/obj/item/weapon/robot_module/robot/security/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/flash/F = locate() in src.modules
	if(F.broken)
		F.broken = 0
		F.times_used = 0
		F.icon_state = "flash"
	else if(F.times_used)
		F.times_used--
	var/obj/item/weapon/gun/energy/taser/mounted/cyborg/T = locate() in src.modules
	if(T.power_supply.charge < T.power_supply.maxcharge)
		T.power_supply.give(T.charge_cost * amount)
		T.update_icon()
	else
		T.charge_tick = 0

/obj/item/weapon/robot_module/robot/janitor
	name = "janitorial robot module"
	channels = list("Service" = 1)
	pto_type = PTO_CIVILIAN

/obj/item/weapon/robot_module/robot/janitor/general/New()
	..()
	src.modules += new /obj/item/weapon/soap/nanotrasen(src)
	src.modules += new /obj/item/weapon/storage/bag/trash(src)
	src.modules += new /obj/item/weapon/mop(src)
	src.modules += new /obj/item/pupscrubber(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.emag = new /obj/item/weapon/reagent_containers/spray(src)
	src.emag.reagents.add_reagent("lube", 250)
	src.emag.name = "Lube spray"

/obj/item/weapon/robot_module/robot/janitor/general/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/spray/S = src.emag
		S.reagents.add_reagent("lube", 2 * amount)

/obj/item/weapon/robot_module/robot/clerical
	name = "service robot module"
	channels = list(
		"Service" = 1,
		"Command" = 1
		)
	languages = list(
					LANGUAGE_SOL_COMMON	= 1,
					LANGUAGE_TRADEBAND	= 1,
					LANGUAGE_UNATHI		= 1,
					LANGUAGE_SIIK		= 1,
					LANGUAGE_SKRELLIAN	= 1,
					LANGUAGE_ROOTLOCAL	= 0,
					LANGUAGE_GUTTER		= 1,
					LANGUAGE_SCHECHI	= 1,
					LANGUAGE_SIGN		= 0,
					LANGUAGE_BIRDSONG	= 1,
					LANGUAGE_SAGARU		= 1,
					LANGUAGE_CANILUNZT	= 1,
					LANGUAGE_ECUREUILIAN= 1,
					LANGUAGE_DAEMON		= 1,
					LANGUAGE_ENOCHIAN	= 1,
					LANGUAGE_DRUDAKAR	= 1,
					LANGUAGE_TAVAN		= 1
					)
	pto_type = PTO_CIVILIAN

/obj/item/weapon/robot_module/robot/clerical/butler
	channels = list("Service" = 1)

/obj/item/weapon/robot_module/robot/clerical/butler/general
	name = "service robot module"

/obj/item/weapon/robot_module/robot/clerical/butler/general/New()
	..()
	src.modules += new /obj/item/weapon/gripper/service(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/bucket(src)
	src.modules += new /obj/item/weapon/material/minihoe(src)
	src.modules += new /obj/item/weapon/material/knife/machete/hatchet(src)
	src.modules += new /obj/item/device/analyzer/plant_analyzer(src)
	src.modules += new /obj/item/weapon/storage/bag/plants(src)
	src.modules += new /obj/item/weapon/robot_harvester(src)
	src.modules += new /obj/item/weapon/material/knife(src)
	src.modules += new /obj/item/weapon/material/kitchen/rollingpin(src)
	src.modules += new /obj/item/device/multitool(src) //to freeze trays

	var/obj/item/weapon/rsf/M = new /obj/item/weapon/rsf(src)
	M.stored_matter = 30
	src.modules += M

	src.modules += new /obj/item/weapon/reagent_containers/dropper/industrial(src)

	var/obj/item/weapon/flame/lighter/zippo/L = new /obj/item/weapon/flame/lighter/zippo(src)
	L.lit = 1
	src.modules += L

	src.modules += new /obj/item/weapon/tray/robotray(src)
	src.modules += new /obj/item/weapon/reagent_containers/borghypo/service(src)
	src.emag = new /obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer(src)

	var/datum/reagents/R = new/datum/reagents(50)
	src.emag.reagents = R
	R.my_atom = src.emag
	R.add_reagent("beer2", 50)
	src.emag.name = "Auntie Hong's Final Sip"
	src.emag.desc = "A bottle of very special mix of alcohol and poison. Some may argue that there's alcohol to die for, but Auntie Hong took it to next level."

/obj/item/weapon/robot_module/robot/clerical/general
	name = "clerical robot module"

/obj/item/weapon/robot_module/robot/clerical/general/New()
	..()
	src.modules += new /obj/item/weapon/pen/robopen(src)
	src.modules += new /obj/item/weapon/form_printer(src)
	src.modules += new /obj/item/weapon/gripper/paperwork(src)
	src.modules += new /obj/item/weapon/hand_labeler(src)
	src.modules += new /obj/item/weapon/stamp(src)
	src.modules += new /obj/item/weapon/stamp/denied(src)
	src.emag = new /obj/item/weapon/stamp/chameleon(src)
	src.emag = new /obj/item/weapon/pen/chameleon(src)

/obj/item/weapon/robot_module/general/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/weapon/reagent_containers/food/condiment/enzyme/E = locate() in src.modules
	E.reagents.add_reagent("enzyme", 2 * amount)
	if(src.emag)
		var/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer/B = src.emag
		B.reagents.add_reagent("beer2", 2 * amount)

/obj/item/weapon/robot_module/robot/miner
	name = "miner robot module"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)
	supported_upgrades = list(/obj/item/borg/upgrade/pka, /obj/item/borg/upgrade/diamonddrill)
	pto_type = PTO_CARGO

/obj/item/weapon/robot_module/robot/miner/general/New()
	..()
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/storage/bag/ore(src)
	src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.modules += new /obj/item/weapon/gripper/miner(src)
	src.modules += new /obj/item/weapon/mining_scanner(src)
	// New Emag gear for the minebots!
	src.emag = new /obj/item/weapon/kinetic_crusher/machete/dagger(src)

	// No reason for these, upgrade modules replace them.
	//src.emag = new /obj/item/weapon/pickaxe/plasmacutter/borg(src)
	//src.emag = new /obj/item/weapon/pickaxe/diamonddrill(src)

/obj/item/weapon/robot_module/robot/research
	name = "research module"
	channels = list("Science" = 1)
	supported_upgrades = list(/obj/item/borg/upgrade/advrped)
	pto_type = PTO_SCIENCE

/obj/item/weapon/robot_module/robot/research/general/New()
	..()
	src.modules += new /obj/item/weapon/portable_destructive_analyzer(src)
	src.modules += new /obj/item/weapon/gripper/research(src)
	src.modules += new /obj/item/weapon/gripper/circuit(src)
	src.modules += new /obj/item/weapon/gripper/no_use/organ/robotics(src)
	src.modules += new /obj/item/weapon/gripper/no_use/mech(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/device/robotanalyzer(src)
	src.modules += new /obj/item/weapon/card/robot(src)
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/weapon/surgical/scalpel/cyborg(src)
	src.modules += new /obj/item/weapon/surgical/circular_saw/cyborg(src)
	src.modules += new /obj/item/weapon/reagent_containers/syringe(src)
	src.modules += new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	src.modules += new /obj/item/weapon/storage/part_replacer(src)
	src.modules += new /obj/item/weapon/shockpaddles/robot/jumper(src)
	src.modules += new /obj/item/weapon/melee/baton/slime/robot(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/xeno/robot(src)
	src.modules += new /obj/item/device/xenoarch_multi_tool(src)
	src.modules += new /obj/item/weapon/pickaxe/excavationdrill(src)
	//src.modules += new /obj/item/device/cataloguer(src) //VOREStation Removal


	src.modules += new /obj/item/device/dogborg/sleeper/compactor/analyzer(src)

	src.emag = new /obj/item/weapon/hand_tele(src)

	var/datum/matter_synth/nanite = new /datum/matter_synth/nanite(10000)
	synths += nanite
	var/datum/matter_synth/wire = new /datum/matter_synth/wire()						//Added to allow repairs, would rather add cable now than be asked to add it later,
	synths += wire																		//Cable code, taken from engiborg,

	var/obj/item/stack/nanopaste/N = new /obj/item/stack/nanopaste(src)
	N.uses_charge = 1
	N.charge_costs = list(1000)
	N.synths = list(nanite)
	src.modules += N

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)	//Cable code, taken from engiborg,
	C.synths = list(wire)
	src.modules += C

/obj/item/weapon/robot_module/robot/research/general/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)

	var/obj/item/weapon/reagent_containers/syringe/S = locate() in src.modules
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()

	..()


/obj/item/weapon/robot_module/robot/security/combat
	name = "combat robot module"
	hide_on_manifest = TRUE

/obj/item/weapon/robot_module/robot/security/combat/New()
	..()
	src.modules += new /obj/item/device/flash(src)
	//src.modules += new /obj/item/borg/sight/thermal(src) // VOREStation Edit
	src.modules += new /obj/item/weapon/gun/energy/laser/mounted(src)
	src.modules += new /obj/item/weapon/pickaxe/plasmacutter/borg(src)
	src.modules += new /obj/item/borg/combat/shield(src)
	src.modules += new /obj/item/borg/combat/mobility(src)
	src.modules += new /obj/item/device/ticket_printer(src)	//VOREStation Add
	src.emag = new /obj/item/weapon/gun/energy/lasercannon/mounted(src)

	src.modules += new /obj/item/device/dogborg/sleeper/K9/ert(src)


/* Drones */

/obj/item/weapon/robot_module/drone
	name = "drone module"
	hide_on_manifest = TRUE
	no_slip = 1
	networks = list(NETWORK_ENGINEERING)

/obj/item/weapon/robot_module/drone/New(var/mob/living/silicon/robot/robot)
	..()
	src.modules += new /obj/item/borg/sight/meson(src)
	src.modules += new /obj/item/weapon/weldingtool/electric/mounted/cyborg(src)
	src.modules += new /obj/item/weapon/tool/screwdriver/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wrench/cyborg(src)
	src.modules += new /obj/item/weapon/tool/crowbar/cyborg(src)
	src.modules += new /obj/item/weapon/tool/wirecutters/cyborg(src)
	src.modules += new /obj/item/device/t_scanner(src)
	src.modules += new /obj/item/device/multitool(src)
	src.modules += new /obj/item/device/lightreplacer(src)
	src.modules += new /obj/item/weapon/gripper(src)
	src.modules += new /obj/item/weapon/soap(src)
	src.modules += new /obj/item/weapon/gripper/no_use/loader(src)
	src.modules += new /obj/item/weapon/extinguisher(src)
	src.modules += new /obj/item/device/pipe_painter(src)
	src.modules += new /obj/item/device/floor_painter(src)
	src.modules += new /obj/item/weapon/pipe_dispenser(src)

	robot.internals = new/obj/item/weapon/tank/jetpack/carbondioxide(src)
	src.modules += robot.internals

	src.emag = new /obj/item/weapon/pickaxe/plasmacutter/borg(src)
	src.emag.name = "Plasma Cutter"

	var/datum/matter_synth/metal = new /datum/matter_synth/metal(25000)
	var/datum/matter_synth/glass = new /datum/matter_synth/glass(25000)
	var/datum/matter_synth/wood = new /datum/matter_synth/wood(25000)
	var/datum/matter_synth/plastic = new /datum/matter_synth/plastic(25000)
	var/datum/matter_synth/wire = new /datum/matter_synth/wire(30)
	synths += metal
	synths += glass
	synths += wood
	synths += plastic
	synths += wire

	var/obj/item/weapon/matter_decompiler/MD = new /obj/item/weapon/matter_decompiler(src)
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic
	src.modules += MD

	var/obj/item/stack/material/cyborg/steel/M = new (src)
	M.synths = list(metal)
	src.modules += M

	var/obj/item/stack/material/cyborg/glass/G = new (src)
	G.synths = list(glass)
	src.modules += G

	var/obj/item/stack/rods/cyborg/R = new /obj/item/stack/rods/cyborg(src)
	R.synths = list(metal)
	src.modules += R

	var/obj/item/stack/cable_coil/cyborg/C = new /obj/item/stack/cable_coil/cyborg(src)
	C.synths = list(wire)
	src.modules += C

	var/obj/item/stack/tile/floor/cyborg/S = new /obj/item/stack/tile/floor/cyborg(src)
	S.synths = list(metal)
	src.modules += S

	var/obj/item/stack/material/cyborg/glass/reinforced/RG = new (src)
	RG.synths = list(metal, glass)
	src.modules += RG

	var/obj/item/stack/tile/wood/cyborg/WT = new /obj/item/stack/tile/wood/cyborg(src)
	WT.synths = list(wood)
	src.modules += WT

	var/obj/item/stack/material/cyborg/wood/W = new (src)
	W.synths = list(wood)
	src.modules += W

	var/obj/item/stack/material/cyborg/plastic/P = new (src)
	P.synths = list(plastic)
	src.modules += P

/obj/item/weapon/robot_module/drone/construction
	name = "construction drone module"
	hide_on_manifest = TRUE
	channels = list("Engineering" = 1)
	languages = list()

/obj/item/weapon/robot_module/drone/construction/New()
	..()
	src.modules += new /obj/item/weapon/rcd/electric/mounted/borg/lesser(src)

/obj/item/weapon/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/device/lightreplacer/LR = locate() in src.modules
	LR.Charge(R, amount)
	..()
	return

/obj/item/weapon/robot_module/drone/mining
	name = "miner drone module"
	channels = list("Supply" = 1)
	networks = list(NETWORK_MINE)

/obj/item/weapon/robot_module/drone/mining/New()
	..()
	src.modules += new /obj/item/borg/sight/material(src)
	src.modules += new /obj/item/weapon/pickaxe/borgdrill(src)
	src.modules += new /obj/item/weapon/storage/bag/ore(src)
	src.modules += new /obj/item/weapon/storage/bag/sheetsnatcher/borg(src)
	src.emag = new /obj/item/weapon/pickaxe/diamonddrill(src)
