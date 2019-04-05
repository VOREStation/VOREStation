/obj/item/mecha_parts/mecha_equipment/weapon
	name = "mecha weapon"
	range = RANGED
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	var/projectile //Type of projectile fired.
	var/projectiles = 1 //Amount of projectiles loaded.
	var/projectiles_per_shot = 1 //Amount of projectiles fired per single shot.
	var/deviation = 0 //Inaccuracy of shots.
	var/fire_cooldown = 0 //Duration of sleep between firing projectiles in single shot.
	var/fire_sound //Sound played while firing.
	var/fire_volume = 50 //How loud it is played.
	var/auto_rearm = 0 //Does the weapon reload itself after each shot?
	required_type = list(/obj/mecha/combat, /obj/mecha/working/hoverpod/combatpod)

	equip_type = EQUIP_WEAPON

/obj/item/mecha_parts/mecha_equipment/weapon/action_checks(atom/target)
	if(projectiles <= 0)
		return 0
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/action(atom/target, params)
	if(!action_checks(target))
		return
	var/turf/curloc = chassis.loc
	var/turf/targloc = get_turf(target)
	if(!curloc || !targloc)
		return
	chassis.use_power(energy_drain)
	chassis.visible_message("<span class='warning'>[chassis] fires [src]!</span>")
	occupant_message("<span class='warning'>You fire [src]!</span>")
	log_message("Fired from [src], targeting [target].")
	for(var/i = 1 to min(projectiles, projectiles_per_shot))
		var/turf/aimloc = targloc
		if(deviation)
			aimloc = locate(targloc.x+GaussRandRound(deviation,1),targloc.y+GaussRandRound(deviation,1),targloc.z)
		if(!aimloc || aimloc == curloc)
			break
		playsound(chassis, fire_sound, fire_volume, 1)
		projectiles--
		var/P = new projectile(curloc)
		Fire(P, target, params)
		if(i == 1)
			set_ready_state(0)
		if(fire_cooldown)
			sleep(fire_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
//	set_ready_state(0)

	var/target_for_log
	if(ismob(target))
		target_for_log = target
	else
		target_for_log = "[target.name]"

	add_attack_logs(chassis.occupant,target_for_log,"Fired exosuit weapon [src.name] (MANUAL)")

	do_after_cooldown()

	return

/obj/item/mecha_parts/mecha_equipment/weapon/proc/Fire(atom/A, atom/target, params)
	var/obj/item/projectile/P = A
	P.dispersion = deviation
	process_accuracy(P, chassis.occupant, target)
	P.preparePixelProjectile(target, chassis.occupant, params)
	P.fire()

/obj/item/mecha_parts/mecha_equipment/weapon/proc/process_accuracy(obj/projectile, mob/living/user, atom/target)
	var/obj/item/projectile/P = projectile
	if(!istype(P))
		return

	P.accuracy -= user.get_accuracy_penalty()

	// Some modifiers make it harder or easier to hit things.
	for(var/datum/modifier/M in user.modifiers)
		if(!isnull(M.accuracy))
			P.accuracy += M.accuracy
		if(!isnull(M.accuracy_dispersion))
			P.dispersion = max(P.dispersion + M.accuracy_dispersion, 0)

/obj/item/mecha_parts/mecha_equipment/weapon/energy
	name = "general energy weapon"
	auto_rearm = 1

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	equip_cooldown = 8
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "A laser carbine's firing system mounted on a high-powered exosuit weapon socket."
	icon_state = "mecha_laser"
	energy_drain = 30
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'

	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 3, TECH_MAGNET = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray
	equip_cooldown = 6
	name = "\improper CH-XS \"Penetrator\" laser"
	desc = "A large, mounted variant of the anti-armor xray rifle."
	icon_state = "mecha_xray"
	energy_drain = 150
	projectile = /obj/item/projectile/beam/xray
	fire_sound = 'sound/weapons/eluger.ogg'

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_POWER = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray/rigged
	equip_cooldown = 12
	name = "jury-rigged xray rifle"
	desc = "A modified wormhole modulation array and meson-scanning control system allow this abomination to produce concentrated blasts of xrays."
	energy_drain = 175
	icon_state = "mecha_xray-rig"

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser
	equip_cooldown = 15
	name = "jury-rigged welder-laser"
	desc = "While not regulation, this inefficient weapon can be attached to working exo-suits in desperate, or malicious, times."
	icon_state = "mecha_laser-rig"
	energy_drain = 60
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'
	required_type = list(/obj/mecha/combat, /obj/mecha/working)

	equip_type = EQUIP_UTILITY

	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2, TECH_MAGNET = 2)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	equip_cooldown = 15
	name = "\improper CH-LC \"Solaris\" laser cannon"
	desc = "In the Solaris, the lasing medium is enclosed in a tube lined with plutonium-239 and subjected to extreme neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with massive laser volumes!"
	icon_state = "mecha_laser"
	energy_drain = 60
	projectile = /obj/item/projectile/beam/heavylaser
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 4, TECH_MAGNET = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/rigged
	equip_cooldown = 25
	name = "jury-rigged emitter cannon"
	desc = "While not regulation, this mining tool can be used as an inefficient weapon on working exo-suits in desperate, or malicious, times."
	icon_state = "mecha_emitter"
	energy_drain = 80
	projectile = /obj/item/projectile/beam/heavylaser/fakeemitter
	fire_sound = 'sound/weapons/emitter.ogg'

	equip_type = EQUIP_UTILITY

	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_PHORON = 3, TECH_ILLEGAL = 1)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/phase
	equip_cooldown = 6
	name = "\improper NT-PE \"Scorpio\" phase-emitter"
	desc = "A specialist energy weapon intended for use against hostile wildlife."
	description_fluff = "Essentially an Orion mounted inside a modified Gaia case."
	icon_state = "mecha_phase"
	energy_drain = 25
	projectile = /obj/item/projectile/energy/phase/heavy
	fire_sound = 'sound/weapons/Taser.ogg'

	equip_type = EQUIP_UTILITY

	origin_tech = list(TECH_MATERIAL = 1, TECH_COMBAT = 2, TECH_MAGNET = 2)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	equip_cooldown = 40
	name = "mkIV ion heavy cannon"
	desc = "An upscaled variant of anti-mechanical weaponry constructed by NT, such as the EW Halicon."
	icon_state = "mecha_ion"
	energy_drain = 120
	projectile = /obj/item/projectile/ion
	fire_sound = 'sound/weapons/Laser.ogg'

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 4, TECH_MAGNET = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion/rigged
	equip_cooldown = 30
	name = "jury-rigged ion cannon"
	desc = "A tesla coil modified to amplify an ionic wave, and use it as a projectile."
	icon_state = "mecha_ion-rig"
	energy_drain = 100
	projectile = /obj/item/projectile/ion/pistol

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse
	equip_cooldown = 30
	name = "eZ-13 mk2 heavy pulse rifle"
	desc = "An experimental Anti-Everything weapon."
	icon_state = "mecha_pulse"
	energy_drain = 120
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 6, TECH_POWER = 4)
	projectile = /obj/item/projectile/beam/pulse/heavy
	fire_sound = 'sound/weapons/gauss_shoot.ogg'

/obj/item/projectile/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"
	var/life = 20

/obj/item/projectile/beam/pulse/heavy/Bump(atom/A)
	A.bullet_act(src, def_zone)
	src.life -= 10
	if(life <= 0)
		qdel(src)
	return

/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser
	name = "\improper PBT \"Pacifier\" mounted taser"
	desc = "A large taser of similar design as those used in standard NT turrets, for use on an Exosuit."
	icon_state = "mecha_taser"
	energy_drain = 20
	equip_cooldown = 8
	projectile = /obj/item/projectile/beam/stun
	fire_sound = 'sound/weapons/Taser.ogg'

/obj/item/mecha_parts/mecha_equipment/weapon/energy/taser/rigged
	name = "jury-rigged static rifle"
	desc = "A vaguely functional taser analog, inside an extinguisher casing."
	icon_state = "mecha_taser-rig"
	energy_drain = 30
	projectile = /obj/item/projectile/beam/stun/weak

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/honker
	name = "sound emission device"
	desc = "A perfectly normal bike-horn, for your exosuit."
	icon_state = "mecha_honker"
	energy_drain = 300
	equip_cooldown = 150
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 4, TECH_ILLEGAL = 1)

	equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/weapon/honker/action(target)
	if(!chassis)
		return 0
	if(energy_drain && chassis.get_charge() < energy_drain)
		return 0
	if(!equip_ready)
		return 0

	playsound(chassis, 'sound/effects/bang.ogg', 30, 1, 30)
	chassis.occupant_message("<span class='warning'>You emit a high-pitched noise from the mech.</span>")
	for(var/mob/living/carbon/M in ohearers(6, chassis))
		if(istype(M, /mob/living/carbon/human))
			var/ear_safety = 0
			ear_safety = M.get_ear_protection()
			if(ear_safety > 0)
				return
		to_chat(M, "<span class='warning'>Your ears feel like they're bleeding!</span>")
		playsound(M, 'sound/effects/bang.ogg', 70, 1, 30)
		M.sleeping = 0
		M.ear_deaf += 30
		M.ear_damage += rand(5, 20)
		M.Weaken(3)
		M.Stun(5)
	chassis.use_power(energy_drain)
	log_message("Used a sound emission device.")
	do_after_cooldown()
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic
	name = "general ballisic weapon"
	var/projectile_energy_cost

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/get_equip_info()
	return "[..()]\[[src.projectiles]\][(src.projectiles < initial(src.projectiles))?" - <a href='?src=\ref[src];rearm=1'>Rearm</a>":null]"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/proc/rearm()
	if(projectiles < initial(projectiles))
		var/projectiles_to_add = initial(projectiles) - projectiles
		while(chassis.get_charge() >= projectile_energy_cost && projectiles_to_add)
			projectiles++
			projectiles_to_add--
			chassis.use_power(projectile_energy_cost)
	send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
	log_message("Rearmed [src.name].")
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/Topic(href, href_list)
	..()
	if (href_list["rearm"])
		src.rearm()
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/mortar
	name = "\improper HEP RC 4 \"Skyfall\""
	desc = "A Hephaestus exosuit-mounted mortar for use on planetary-or-similar bodies."
	description_info = "This weapon cannot be fired indoors, underground, or on-station."
	icon_state = "mecha_mortar"
	equip_cooldown = 30
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg'
	fire_volume = 100
	projectiles = 3
	deviation = 0.6
	projectile = /obj/item/projectile/arc/fragmentation/mortar
	projectile_energy_cost = 600

	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 5, TECH_ILLEGAL = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/mortar/action_checks(atom/target)
	var/turf/MT = get_turf(chassis)
	var/turf/TT = get_turf(target)
	if(!MT.outdoors || !TT.outdoors)
		to_chat(chassis.occupant, "<span class='notice'>\The [src]'s control system prevents you from firing due to a blocked firing arc.</span>")
		return 0
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	name = "\improper LBX AC 10 \"Scattershot\""
	desc = "A massive shotgun designed to fill a large area with pellets."
	icon_state = "mecha_scatter"
	equip_cooldown = 20
	projectile = /obj/item/projectile/bullet/pellet/shotgun/flak
	fire_sound = 'sound/weapons/Gunshot_shotgun.ogg'
	fire_volume = 80
	projectiles = 40
	projectiles_per_shot = 4
	deviation = 0.7
	projectile_energy_cost = 25

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot/rigged
	name = "jury-rigged shrapnel cannon"
	desc = "The remains of some unfortunate RCD now doomed to kill, rather than construct."
	icon_state = "mecha_scatter-rig"
	equip_cooldown = 30
	fire_volume = 100
	projectiles = 20
	deviation = 1

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	name = "\improper Ultra AC 2"
	desc = "A superior version of the standard Solgov Autocannon MK2 design."
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/pistol/medium
	fire_sound = 'sound/weapons/Gunshot_machinegun.ogg'
	projectiles = 30 //10 bursts, matching the Scattershot's 10. Also, conveniently, doesn't eat your powercell when reloading like 300 bullets does.
	projectiles_per_shot = 3
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 2

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg/rigged
	name = "jury-rigged machinegun"
	desc = "The cross between a jackhammer and a whole lot of zipguns."
	icon_state = "mecha_uac2-rig"
	equip_cooldown = 12
	projectile = /obj/item/projectile/bullet/pistol
	deviation = 0.5

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	var/missile_speed = 2
	var/missile_range = 30

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/Fire(atom/movable/AM, atom/target, turf/aimloc)
	AM.throw_at(target,missile_range, missile_speed, chassis)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	name = "\improper BNI Flare Launcher"
	desc = "A flare-gun, but bigger."
	icon_state = "mecha_flaregun"
	projectile = /obj/item/device/flashlight/flare
	fire_sound = 'sound/weapons/tablehit1.ogg'
	auto_rearm = 1
	fire_cooldown = 20
	projectiles_per_shot = 1
	projectile_energy_cost = 20
	missile_speed = 1
	missile_range = 15
	required_type = /obj/mecha  //Why restrict it to just mining or combat mechs?

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/device/flashlight/flare/fired = AM
	fired.ignite()
	..()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	name = "\improper SRM-8 missile rack"
	desc = "A missile battery that holds eight missiles."
	icon_state = "mecha_missilerack"
	projectile = /obj/item/missile
	fire_sound = 'sound/weapons/rpg.ogg'
	projectiles = 8
	projectile_energy_cost = 1000
	equip_cooldown = 60

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/Fire(atom/movable/AM, atom/target)
	var/obj/item/missile/M = AM
	M.primed = 1
	..()

/obj/item/missile
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	var/primed = null
	throwforce = 15
	var/devastation = 0
	var/heavy_blast = 1
	var/light_blast = 2
	var/flash_blast = 4

/obj/item/missile/proc/warhead_special(var/target)
	explosion(target, devastation, heavy_blast, light_blast, flash_blast)
	return

/obj/item/missile/throw_impact(atom/hit_atom)
	if(primed)
		warhead_special(hit_atom)
		qdel(src)
	else
		..()
	return

/obj/item/missile/light
	throwforce = 10
	heavy_blast = 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/rigged
	name = "jury-rigged rocket pod"
	desc = "A series of pipes, tubes, and cables that resembles a rocket pod."
	icon_state = "mecha_missilerack-rig"
	projectile = /obj/item/missile/light
	projectiles = 3
	projectile_energy_cost = 800

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade
	name = "\improper SGL-6 grenade launcher"
	desc = "A grenade launcher produced for SWAT use; fires flashbangs."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/weapon/grenade/flashbang
	fire_sound = 'sound/effects/bang.ogg'
	projectiles = 6
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 60
	var/det_time = 20

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/rigged
	name = "jury-rigged pneumatic flashlauncher"
	desc = "A grenade launcher constructed out of estranged blueprints; fires flashbangs."
	icon_state = "mecha_grenadelnchr-rig"
	projectiles = 3
	missile_speed = 1
	det_time = 25

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/weapon/grenade/G = AM
	if(istype(G))
		G.det_time = det_time
		G.activate(chassis.occupant) //Grenades actually look primed and dangerous, handle their own stuff.
	AM.throw_at(target,missile_range, missile_speed, chassis)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang//Because I am a heartless bastard -Sieve
	name = "\improper SOP-6 grenade launcher"
	desc = "A grenade launcher produced for use by government uprising subjugation forces, or that's what you might guess; fires matryoshka flashbangs."
	projectile = /obj/item/weapon/grenade/flashbang/clusterbang

	origin_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang/limited/get_equip_info()//Limited version of the clusterbang launcher that can't reload
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"]\[[src.projectiles]\]"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang/limited/rearm()
	return//Extra bit of security

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/concussion
	name = "\improper SGL-9 grenade launcher"
	desc = "A military-grade grenade launcher that fires disorienting concussion grenades."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/weapon/grenade/concussion
	missile_speed = 1
	projectile_energy_cost = 900
	equip_cooldown = 50
	det_time = 25

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 1)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/frag
	name = "\improper HEP-I 5 grenade launcher"
	desc = "A military-grade grenade launcher that fires anti-personnel fragmentation grenades."
	icon_state = "mecha_fraglnchr"
	projectile = /obj/item/weapon/grenade/explosive
	projectiles = 4
	missile_speed = 1

	origin_tech = list(TECH_COMBAT = 5, TECH_ENGINEERING = 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/frag/mini
	name = "\improper HEP-MI 6 grenade launcher"
	desc = "A military-grade grenade launcher that fires miniaturized anti-personnel fragmentation grenades."
	projectile = /obj/item/weapon/grenade/explosive/mini
	projectile_energy_cost = 500
	equip_cooldown = 25

	origin_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_ILLEGAL = 2)

//////////////
//Fire-based//
//////////////

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/incendiary
	name = "\improper DR-AC 3"
	desc = "Dual-barrel rotary machinegun that fires small, incendiary rounds. Ages ten and up."
	description_fluff = "A weapon designed by Hephaestus Industries, the DR-AC 3's design was plagued by prototype faults including but not limited to: Spontaneous combustion, spontaneous detonation, and excessive collateral conflagration."
	icon_state = "mecha_drac3"
	equip_cooldown = 20
	projectile = /obj/item/projectile/bullet/incendiary
	fire_sound = 'sound/weapons/Gunshot_machinegun.ogg'
	projectiles = 30
	projectiles_per_shot = 2
	deviation = 0.4
	projectile_energy_cost = 40
	fire_cooldown = 3
	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 5, TECH_PHORON = 2, TECH_ILLEGAL = 1)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer
	equip_cooldown = 30
	name = "\improper CR-3 Mark 8"
	desc = "An imposing device, this weapon hurls balls of fire."
	description_fluff = "A weapon designed by Hephaestus for anti-infantry combat, the CR-3 is capable of outputting a large volume of synthesized fuel. Initially designed by a small company, later purchased by Aether, on Earth as a device made for clearing underbrush and co-operating with firefighting operations. Obviously, Hephaestus has found an 'improved' use for the Aether designs."
	icon_state = "mecha_cremate"

	energy_drain = 30

	projectile = /obj/item/projectile/bullet/incendiary/flamethrower/large
	fire_sound = 'sound/weapons/towelwipe.ogg'

	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 6, TECH_PHORON = 4, TECH_ILLEGAL = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged
	name = "\improper AA-CR-1 Mark 4"
	description_fluff = "A firefighting tool maintained by Aether Atmospherics, whose initial design originated from a small Earth company. This one seems to have been jury rigged."
	icon_state = "mecha_cremate-rig"

	energy_drain = 50
	required_type = list(/obj/mecha/combat, /obj/mecha/working)

	projectile = /obj/item/projectile/bullet/incendiary/flamethrower

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_ILLEGAL = 2)

	equip_type = EQUIP_UTILITY

//////////////
//Defensive//
//////////////

/obj/item/mecha_parts/mecha_equipment/shocker
	name = "exosuit electrifier"
	desc = "A device to electrify the external portions of a mecha in order to increase its defensive capabilities."
	icon_state = "mecha_coil"
	equip_cooldown = 10
	energy_drain = 100
	range = RANGED
	origin_tech = list(TECH_COMBAT = 3, TECH_POWER = 6)
	var/shock_damage = 15
	var/active

	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/shocker/can_attach(obj/mecha/M as obj)
	if(..())
		if(!M.proc_res["dynattackby"] && !M.proc_res["dynattackhand"] && !M.proc_res["dynattackalien"])
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/shocker/attach(obj/mecha/M as obj)
	..()
	chassis.proc_res["dynattackby"] = src
	return

/obj/item/mecha_parts/mecha_equipment/shocker/proc/dynattackby(obj/item/weapon/W, mob/living/user)
	if(!action_checks(user) || !active)
		return
	user.electrocute_act(shock_damage, src)
	return chassis.dynattackby(W,user)
