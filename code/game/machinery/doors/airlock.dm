//VOREStation Edit - Redone a lot of airlock things:
/*
- Specific department maintenance doors
- Named doors properly according to type
- Gave them default access levels with the access constants
- Improper'd all of the names in the new()
*/

/obj/machinery/door/airlock
	name = "Airlock"
	description_info = "If you hold left alt whilst left-clicking on an airlock, you can ring the doorbell to announce your presence to anyone on the other side! Alternately if you are on HARM intent when doing this, you will bang loudly on the door!<br><br>AIs and Cyborgs can also quickly open/close, bolt/unbolt, and electrify/de-electrify doors at a distance by holding left shift, left control, or left alt respectively whilst left-clicking."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door_closed"
	power_channel = ENVIRON

	explosion_resistance = 10

	// Doors do their own stuff
	bullet_vulnerability = 0

	blocks_emissive = EMISSIVE_BLOCK_GENERIC // Not quite as nice as /tg/'s custom masks. We should make those sometime

	var/aiControlDisabled = 0 //If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	var/hackProof = 0 // if 1, this door can't be hacked by the AI
	var/electrified_until = 0			//World time when the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/main_power_lost_until = 0	 	//World time when main power is restored.
	var/backup_power_lost_until = -1	//World time when backup power is restored.
	var/has_beeped = 0					//If 1, will not beep on failed closing attempt. Resets when door closes.
	var/spawnPowerRestoreRunning = 0
	var/welded = null
	var/locked = 0
	var/lights = 1 // bolt lights show by default
	var/aiDisabledIdScanner = 0
	var/aiHacking = 0
	var/obj/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/lockdownbyai = 0
	autoclose = 1
	var/assembly_type = /obj/structure/door_assembly
	var/mineral = null
	var/justzap = 0
	var/safe = 1
	normalspeed = 1
	var/obj/item/weapon/airlock_electronics/electronics = null
	var/hasShocked = 0 //Prevents multiple shocks from happening
	var/secured_wires = 0
	var/security_level = 1 //VOREStation Addition - acts as a multiplier on the time required to hack an airlock with a hacktool
	var/datum/wires/airlock/wires = null

	var/open_sound_powered = 'sound/machines/door/covert1o.ogg'
	var/open_sound_unpowered = 'sound/machines/door/airlockforced.ogg'
	var/close_sound_powered = 'sound/machines/door/covert1c.ogg'
	var/legacy_open_powered = 'sound/machines/door/old_airlock.ogg'
	var/legacy_close_powered = 'sound/machines/door/old_airlockclose.ogg'
	var/department_open_powered = null
	var/department_close_powered = null
	var/denied_sound = 'sound/machines/deniedbeep.ogg'
	var/bolt_up_sound = 'sound/machines/door/boltsup.ogg'
	var/bolt_down_sound = 'sound/machines/door/boltsdown.ogg'
	var/knock_sound = 'sound/machines/2beeplow.ogg'
	var/knock_hammer_sound = 'sound/weapons/sonic_jackhammer.ogg'
	var/knock_unpowered_sound = 'sound/machines/door/knock_glass.ogg'

/obj/machinery/door/airlock/attack_generic(var/mob/living/user, var/damage)
	if(stat & (BROKEN|NOPOWER))
		if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
			if(src.locked || src.welded)
				visible_message("<span class='danger'>\The [user] begins breaking into \the [src] internals!</span>")
				user.set_AI_busy(TRUE) // If the mob doesn't have an AI attached, this won't do anything.
				if(do_after(user,10 SECONDS,src))
					src.locked = 0
					src.welded = 0
					update_icon()
					open(1)
					if(prob(25))
						src.shock(user, 100)
				user.set_AI_busy(FALSE)
			else if(src.density)
				visible_message("<span class='danger'>\The [user] forces \the [src] open!</span>")
				open(1)
			else
				visible_message("<span class='danger'>\The [user] forces \the [src] closed!</span>")
				close(1)
		else
			visible_message("<span class='notice'>\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"].</span>")
		return
	..()

/obj/machinery/door/airlock/attack_alien(var/mob/user) //Familiar, right? Doors. -Mechoid
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			if(src.locked || src.welded)
				visible_message("<span class='alium'>\The [user] begins tearing into \the [src] internals!</span>")
				src.do_animate("deny")
				if(do_after(user,15 SECONDS,src))
					visible_message("<span class='danger'>\The [user] tears \the [src] open, sparks flying from its electronics!</span>")
					src.do_animate("spark")
					playsound(src, 'sound/machines/door/airlock_tear_apart.ogg', 100, 1, volume_channel = VOLUME_CHANNEL_DOORS)
					src.locked = 0
					src.welded = 0
					update_icon()
					open(1)
					src.set_broken() //These aren't emags, these be CLAWS
			else if(src.density)
				visible_message("<span class='alium'>\The [user] begins forcing \the [src] open!</span>")
				if(do_after(user, 5 SECONDS,src))
					playsound(src, 'sound/machines/door/airlock_creaking.ogg', 100, 1, volume_channel = VOLUME_CHANNEL_DOORS)
					visible_message("<span class='danger'>\The [user] forces \the [src] open!</span>")
					open(1)
			else
				visible_message("<span class='danger'>\The [user] forces \the [src] closed!</span>")
				close(1)
		else
			src.do_animate("deny")
			visible_message("<span class='notice'>\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"].</span>")
			return
	..()

/obj/machinery/door/airlock/get_material()
	if(mineral)
		return get_material_by_name(mineral)
	return get_material_by_name(MAT_STEEL)

/obj/machinery/door/airlock/command
	name = "Command Airlock"
	icon = 'icons/obj/doors/Doorcom.dmi'
	req_one_access = list(access_heads)
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/cmd3o.ogg'
	department_close_powered = 'sound/machines/door/cmd3c.ogg'
	security_level = 3	//VOREStation Addition

/obj/machinery/door/airlock/security
	name = "Security Airlock"
	icon = 'icons/obj/doors/Doorsec.dmi'
	req_one_access = list(access_security)
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/sec1o.ogg'
	department_close_powered = 'sound/machines/door/sec1c.ogg'
	security_level = 2	//VOREStation Addition

/obj/machinery/door/airlock/engineering
	name = "Engineering Airlock"
	icon = 'icons/obj/doors/Dooreng.dmi'
	req_one_access = list(access_engine)
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/engineeringatmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Doorengatmos.dmi'
	req_one_access = list(access_atmospherics)
	assembly_type = /obj/structure/door_assembly/door_assembly_eat
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/medical
	name = "Medical Airlock"
	icon = 'icons/obj/doors/Doormed.dmi'
	req_one_access = list(access_medical)
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/med1o.ogg'
	department_close_powered = 'sound/machines/door/med1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/maintenance
	name = "Maintenance Access"
	icon = 'icons/obj/doors/Doormaint.dmi'
	//req_one_access = list(access_maint_tunnels) //VOREStation Edit - Maintenance is open access
	assembly_type = /obj/structure/door_assembly/door_assembly_mai
	open_sound_powered = 'sound/machines/door/door2o.ogg'
	close_sound_powered = 'sound/machines/door/door2c.ogg'

/obj/machinery/door/airlock/maintenance/cargo
	icon = 'icons/obj/doors/Doormaint_cargo.dmi'
	req_one_access = list(access_cargo)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/door2o.ogg'
	department_close_powered = 'sound/machines/door/door2c.ogg'

/obj/machinery/door/airlock/maintenance/command
	icon = 'icons/obj/doors/Doormaint_command.dmi'
	req_one_access = list(access_heads)

/obj/machinery/door/airlock/maintenance/common
	icon = 'icons/obj/doors/Doormaint_common.dmi'
	open_sound_powered = 'sound/machines/door/hall3o.ogg'
	close_sound_powered = 'sound/machines/door/hall3c.ogg'

/obj/machinery/door/airlock/maintenance/engi
	icon = 'icons/obj/doors/Doormaint_engi.dmi'
	req_one_access = list(access_engine)

/obj/machinery/door/airlock/maintenance/int
	icon = 'icons/obj/doors/Doormaint_int.dmi'

/obj/machinery/door/airlock/maintenance/medical
	icon = 'icons/obj/doors/Doormaint_med.dmi'
	req_one_access = list(access_medical)

/obj/machinery/door/airlock/maintenance/rnd
	icon = 'icons/obj/doors/Doormaint_rnd.dmi'
	req_one_access = list(access_research)

/obj/machinery/door/airlock/maintenance/sec
	icon = 'icons/obj/doors/Doormaint_sec.dmi'
	req_one_access = list(access_security)

/obj/machinery/door/airlock/external
	name = "External Airlock"
	icon = 'icons/obj/doors/Doorext.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	open_sound_powered = 'sound/machines/door/space1o.ogg'
	close_sound_powered = 'sound/machines/door/space1c.ogg'

/obj/machinery/door/airlock/external/bolted
	icon_state = "door_locked" // So it looks visibly bolted in map editor
	locked = 1

// For convenience in making docking ports: one that is pre-bolted with frequency set!
/obj/machinery/door/airlock/external/bolted/cycling
	frequency = 1379

/obj/machinery/door/airlock/glass_external
	name = "External Airlock"
	icon = 'icons/obj/doors/Doorextglass.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_ext
	opacity = 0
	glass = 1
	req_one_access = list(access_external_airlocks)
	open_sound_powered = 'sound/machines/door/space1o.ogg'
	close_sound_powered = 'sound/machines/door/space1c.ogg'

/obj/machinery/door/airlock/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Doorglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	open_sound_powered = 'sound/machines/door/hall1o.ogg'
	close_sound_powered = 'sound/machines/door/hall1c.ogg'
	legacy_open_powered = 'sound/machines/door/windowdoor.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	glass = 1

/obj/machinery/door/airlock/centcom
	name = "Centcom Airlock"
	icon = 'icons/obj/doors/Doorele.dmi'
	req_one_access = list(access_cent_general)
	opacity = 1
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'
	security_level = 100	//VOREStation Addition

/obj/machinery/door/airlock/glass_centcom
	name = "Airlock"
	icon = 'icons/obj/doors/Dooreleglass.dmi'
	opacity = 0
	glass = 1
	open_sound_powered = 'sound/machines/door/cmd3o.ogg'
	close_sound_powered = 'sound/machines/door/cmd3c.ogg'
	security_level = 100	//VOREStation Addition

/obj/machinery/door/airlock/vault
	name = "Vault"
	icon = 'icons/obj/doors/vault.dmi'
	explosion_resistance = 20
	opacity = 1
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity //Until somebody makes better sprites.
	req_one_access = list(access_heads_vault)
	open_sound_powered = 'sound/machines/door/vault1o.ogg'
	close_sound_powered = 'sound/machines/door/vault1c.ogg'
	security_level = 5	//VOREStation Addition

/obj/machinery/door/airlock/vault/bolted
	icon_state = "door_locked"
	locked = 1

/obj/machinery/door/airlock/freezer
	name = "Freezer Airlock"
	icon = 'icons/obj/doors/Doorfreezer.dmi'
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_fre

/obj/machinery/door/airlock/hatch
	name = "Airtight Hatch"
	icon = 'icons/obj/doors/Doorhatchele.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_hatch
	req_one_access = list(access_maint_tunnels)
	open_sound_powered = 'sound/machines/door/hatchopen.ogg'
	close_sound_powered = 'sound/machines/door/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'

/obj/machinery/door/airlock/maintenance_hatch
	name = "Maintenance Hatch"
	icon = 'icons/obj/doors/Doorhatchmaint2.dmi'
	explosion_resistance = 20
	opacity = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_mhatch
	req_one_access = list(access_maint_tunnels)
	open_sound_powered = 'sound/machines/door/hatchopen.ogg'
	close_sound_powered = 'sound/machines/door/hatchclose.ogg'
	open_sound_unpowered = 'sound/machines/door/hatchforced.ogg'

/obj/machinery/door/airlock/glass_command
	name = "Command Airlock"
	icon = 'icons/obj/doors/Doorcomglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_com
	glass = 1
	req_one_access = list(access_heads)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/cmd1o.ogg'
	department_close_powered = 'sound/machines/door/cmd1c.ogg'
	security_level = 3	//VOREStation Addition

/obj/machinery/door/airlock/glass_engineering
	name = "Engineering Airlock"
	icon = 'icons/obj/doors/Doorengglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eng
	glass = 1
	req_one_access = list(access_engine)
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/glass_engineeringatmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Doorengatmoglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_eat
	glass = 1
	req_one_access = list(access_atmospherics)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/glass_security
	name = "Security Airlock"
	icon = 'icons/obj/doors/Doorsecglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_sec
	glass = 1
	req_one_access = list(access_security)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/sec1o.ogg'
	department_close_powered = 'sound/machines/door/sec1c.ogg'
	security_level = 2	//VOREStation Addition

/obj/machinery/door/airlock/glass_medical
	name = "Medical Airlock"
	icon = 'icons/obj/doors/Doormedglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	glass = 1
	req_one_access = list(access_medical)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/med1o.ogg'
	department_close_powered = 'sound/machines/door/med1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/Doormining.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	req_one_access = list(access_mining)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/cgo1o.ogg'
	department_close_powered = 'sound/machines/door/cgo1c.ogg'

/obj/machinery/door/airlock/atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmo.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	req_one_access = list(access_atmospherics)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/research
	name = "Research Airlock"
	icon = 'icons/obj/doors/Doorresearch.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/sci1o.ogg'
	department_close_powered = 'sound/machines/door/sci1c.ogg'
	security_level = 2	//VOREStation Addition

/obj/machinery/door/airlock/glass_research
	name = "Research Airlock"
	icon = 'icons/obj/doors/Doorresearchglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_research
	glass = 1
	req_one_access = list(access_research)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/sci1o.ogg'
	department_close_powered = 'sound/machines/door/sci1c.ogg'
	security_level = 2	//VOREStation Addition

/obj/machinery/door/airlock/glass_mining
	name = "Mining Airlock"
	icon = 'icons/obj/doors/Doorminingglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_min
	glass = 1
	req_one_access = list(access_mining)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/cgo1o.ogg'
	department_close_powered = 'sound/machines/door/cgo1c.ogg'

/obj/machinery/door/airlock/glass_atmos
	name = "Atmospherics Airlock"
	icon = 'icons/obj/doors/Dooratmoglass.dmi'
	hitsound = 'sound/effects/Glasshit.ogg'
	maxhealth = 300
	explosion_resistance = 5
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_atmo
	glass = 1
	req_one_access = list(access_atmospherics)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/eng1o.ogg'
	department_close_powered = 'sound/machines/door/eng1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/gold
	name = "Gold Airlock"
	icon = 'icons/obj/doors/Doorgold.dmi'
	mineral = "gold"

/obj/machinery/door/airlock/silver
	name = "Silver Airlock"
	icon = 'icons/obj/doors/Doorsilver.dmi'
	mineral = "silver"

/obj/machinery/door/airlock/diamond
	name = "Diamond Airlock"
	icon = 'icons/obj/doors/Doordiamond.dmi'
	mineral = "diamond"

/obj/machinery/door/airlock/uranium
	name = "Uranium Airlock"
	desc = "And they said I was crazy."
	icon = 'icons/obj/doors/Dooruranium.dmi'
	mineral = "uranium"
	var/last_event = 0
	var/rad_power = 7.5

/obj/machinery/door/airlock/process()
	// Deliberate no call to parent.
	if(main_power_lost_until > 0 && world.time >= main_power_lost_until)
		regainMainPower()

	if(backup_power_lost_until > 0 && world.time >= backup_power_lost_until)
		regainBackupPower()

	else if(electrified_until > 0 && world.time >= electrified_until)
		electrify(0)

	if (..() == PROCESS_KILL && !(main_power_lost_until > 0 || backup_power_lost_until > 0 || electrified_until > 0))
		. = PROCESS_KILL

/obj/machinery/door/airlock/uranium/process()
	if(world.time > last_event+20)
		if(prob(50))
			SSradiation.radiate(src, rad_power)
		last_event = world.time
	..()

/obj/machinery/door/airlock/phoron
	name = "Phoron Airlock"
	desc = "No way this can end badly."
	icon = 'icons/obj/doors/Doorphoron.dmi'
	mineral = "phoron"

/obj/machinery/door/airlock/phoron/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/ignite(exposed_temperature)
	if(exposed_temperature > 300)
		PhoronBurn(exposed_temperature)

/obj/machinery/door/airlock/phoron/proc/PhoronBurn(temperature)
	for(var/turf/simulated/floor/target_tile in range(2,loc))
		target_tile.assume_gas("phoron", 35, 400+T0C)
		spawn (0) target_tile.hotspot_expose(temperature, 400)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))//Added so that you can't set off a massive chain reaction with a small flame
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)
	new/obj/structure/door_assembly( src.loc )
	qdel(src)

/obj/machinery/door/airlock/sandstone
	name = "Sandstone Airlock"
	icon = 'icons/obj/doors/Doorsand.dmi'
	mineral = "sandstone"

/obj/machinery/door/airlock/science
	name = "Research Airlock"
	icon = 'icons/obj/doors/Doorsci.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	req_one_access = list(access_research)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/sci1o.ogg'
	department_close_powered = 'sound/machines/door/sci1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/glass_science
	name = "Glass Airlocks"
	icon = 'icons/obj/doors/Doorsciglass.dmi'
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_science
	glass = 1
	req_one_access = list(access_research)
	open_sound_powered = 'sound/machines/door/hall1o.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	close_sound_powered = 'sound/machines/door/hall1c.ogg' // VOREStation Edit: Default door sounds for fancy, department-off.
	department_open_powered = 'sound/machines/door/sci1o.ogg'
	department_close_powered = 'sound/machines/door/sci1c.ogg'
	security_level = 1.5	//VOREStation Addition

/obj/machinery/door/airlock/highsecurity
	name = "Secure Airlock"
	icon = 'icons/obj/doors/hightechsecurity.dmi'
	explosion_resistance = 20
	secured_wires = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_highsecurity
	req_one_access = list(access_heads_vault)
	open_sound_powered = 'sound/machines/door/secure1o.ogg'
	close_sound_powered = 'sound/machines/door/secure1c.ogg'
	security_level = 4	//VOREStation Addition

/obj/machinery/door/airlock/voidcraft
	name = "voidcraft hatch"
	desc = "It's an extra resilient airlock intended for spacefaring vessels."
	icon = 'icons/obj/doors/shuttledoors.dmi'
	explosion_resistance = 20
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/door_assembly_voidcraft
	open_sound_powered = 'sound/machines/door/shuttle1o.ogg'
	close_sound_powered = 'sound/machines/door/shuttle1c.ogg'

// Airlock opens from top-bottom instead of left-right.
/obj/machinery/door/airlock/voidcraft/vertical
	icon = 'icons/obj/doors/shuttledoors_vertical.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_voidcraft/vertical
	open_sound_powered = 'sound/machines/door/shuttle1o.ogg'
	close_sound_powered = 'sound/machines/door/shuttle1c.ogg'


/datum/category_item/catalogue/anomalous/precursor_a/alien_airlock
	name = "Precursor Alpha Object - Doors"
	desc = "This object appears to be used in order to restrict or allow access to \
	rooms based on its physical state. In other words, a door. \
	Despite being designed and created by unknown ancient alien hands, this door has \
	a large number of similarities to the conventional airlock, such as being driven by \
	electricity, opening and closing by physically moving, and being air tight. \
	It also operates by responding to signals through internal electrical conduits. \
	These characteristics make it possible for one with experience with a multitool \
	to manipulate the door.\
	<br><br>\
	The symbol on the door does not match any living species' patterns, giving further \
	implications that this door is very old, and yet it remains operational after \
	thousands of years. It is unknown if that is due to superb construction, or \
	unseen autonomous maintenance having been performed."
	value = CATALOGUER_REWARD_EASY

/obj/machinery/door/airlock/alien
	name = "alien airlock"
	desc = "You're fairly sure this is a door."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_airlock)
	icon = 'icons/obj/doors/Dooralien.dmi'
	explosion_resistance = 20
	secured_wires = TRUE
	hackProof = TRUE
	assembly_type = /obj/structure/door_assembly/door_assembly_alien
	req_one_access = list(access_alien)
	security_level = 100	//VOREStation Addition

/obj/machinery/door/airlock/alien/locked
	icon_state = "door_locked"
	locked = TRUE

/obj/machinery/door/airlock/alien/public // Entry to UFO.
	req_one_access = list()
	normalspeed = FALSE // So it closes faster and hopefully keeps the warm air inside.
	hackProof = TRUE //VOREStation Edit - No borgos

/*
About the new airlock wires panel:
*	An airlock wire dialog can be accessed by the normal way or by using wirecutters or a multitool on the door while the wire-panel is open. This would show the following wires, which you can either wirecut/mend or send a multitool pulse through. There are 9 wires.
*		one wire from the ID scanner. Sending a pulse through this flashes the red light on the door (if the door has power). If you cut this wire, the door will stop recognizing valid IDs. (If the door has 0000 access, it still opens and closes, though)
*		two wires for power. Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter). Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be open, but bolts-raising will not work. Cutting these wires may electrocute the user.
*		one wire for door bolts. Sending a pulse through this drops door bolts (whether the door is powered or not) or raises them (if it is). Cutting this wire also drops the door bolts, and mending it does not raise them. If the wire is cut, trying to raise the door bolts will not work.
*		two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter). Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
*		one wire for opening the door. Sending a pulse through this while the door has power makes it open the door if no access is required.
*		one wire for AI control. Sending a pulse through this blocks AI control for a second or so (which is enough to see the AI control light on the panel dialog go off and back on again). Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
*		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
*		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
*		one wire for controlling door speed.  When active, dor closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
*/



/obj/machinery/door/airlock/bumpopen(mob/living/user as mob) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(usr))
		if(src.isElectrified())
			if(!src.justzap)
				if(src.shock(user, 100))
					src.justzap = 1
					spawn (10)
						src.justzap = 0
					return
			else /*if(src.justzap)*/
				return
		else if(user.hallucination > 50 && prob(10) && src.operating == 0)
			to_chat(user, "<span class='danger'>You feel a powerful shock course through your body!</span>")
			user.halloss += 10
			user.stunned += 10
			return
	..(user)

/obj/machinery/door/airlock/proc/isElectrified()
	if(src.electrified_until != 0)
		return 1
	return 0

/obj/machinery/door/airlock/proc/canAIControl()
	return ((src.aiControlDisabled!=1) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((src.aiControlDisabled==1) && (!hackProof) && (!src.isAllPowerLoss()));

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if (stat & (NOPOWER|BROKEN))
		return 0
	return (src.main_power_lost_until==0 || src.backup_power_lost_until==0)

/obj/machinery/door/airlock/requiresID()
	return !(wires.is_cut(WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(stat & (NOPOWER|BROKEN))
		return 1
	if(mainPowerCablesCut() && backupPowerCablesCut())
		return 1
	return 0

/obj/machinery/door/airlock/proc/mainPowerCablesCut()
	return wires.is_cut(WIRE_MAIN_POWER1) || wires.is_cut(WIRE_MAIN_POWER2)

/obj/machinery/door/airlock/proc/backupPowerCablesCut()
	return wires.is_cut(WIRE_BACKUP_POWER1) || wires.is_cut(WIRE_BACKUP_POWER2)

/obj/machinery/door/airlock/proc/loseMainPower()
	main_power_lost_until = mainPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)

	// If backup power is permanently disabled then activate in 10 seconds if possible, otherwise it's already enabled or a timer is already running
	if(backup_power_lost_until == -1 && !backupPowerCablesCut())
		backup_power_lost_until = world.time + SecondsToTicks(10)

	if(main_power_lost_until > 0 || backup_power_lost_until > 0)
		START_MACHINE_PROCESSING(src)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/loseBackupPower()
	backup_power_lost_until = backupPowerCablesCut() ? -1 : world.time + SecondsToTicks(60)

	if(backup_power_lost_until > 0)
		START_MACHINE_PROCESSING(src)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/regainMainPower()
	if(!mainPowerCablesCut())
		main_power_lost_until = 0
		// If backup power is currently active then disable, otherwise let it count down and disable itself later
		if(!backup_power_lost_until)
			backup_power_lost_until = -1

	update_icon()

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(!backupPowerCablesCut())
		// Restore backup power only if main power is offline, otherwise permanently disable
		backup_power_lost_until = main_power_lost_until == 0 ? -1 : 0

	update_icon()

/obj/machinery/door/airlock/proc/electrify(var/duration, var/feedback = 0)
	var/message = ""
	if(wires.is_cut(WIRE_ELECTRIFY) && arePowerSystemsOn())
		message = text("The electrification wire is cut - Door permanently electrified.")
		src.electrified_until = -1
	else if(duration && !arePowerSystemsOn())
		message = text("The door is unpowered - Cannot electrify the door.")
		src.electrified_until = 0
	else if(!duration && electrified_until != 0)
		message = "The door is now un-electrified."
		src.electrified_until = 0
	else if(duration)	//electrify door for the given duration seconds
		if(usr)
			shockedby += text("\[[time_stamp()]\] - [usr](ckey:[usr.ckey])")
			add_attack_logs(usr,name,"Electrified a door")
		else
			shockedby += text("\[[time_stamp()]\] - EMP)")
		message = "The door is now electrified [duration == -1 ? "permanently" : "for [duration] second\s"]."
		src.electrified_until = duration == -1 ? -1 : world.time + SecondsToTicks(duration)

	if(electrified_until > 0)
		START_MACHINE_PROCESSING(src)

	if(feedback && message)
		to_chat(usr,message)

/obj/machinery/door/airlock/proc/set_idscan(var/activate, var/feedback = 0)
	var/message = ""
	if(wires.is_cut(WIRE_IDSCAN))
		message = "The IdScan wire is cut - IdScan feature permanently disabled."
	else if(activate && src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 0
		message = "IdScan feature has been enabled."
	else if(!activate && !src.aiDisabledIdScanner)
		src.aiDisabledIdScanner = 1
		message = "IdScan feature has been disabled."

	if(feedback && message)
		to_chat(usr,message)

/obj/machinery/door/airlock/proc/set_safeties(var/activate, var/feedback = 0)
	var/message = ""
	// Safeties!  We don't need no stinking safeties!
	if (wires.is_cut(WIRE_SAFETY))
		message = text("The safety wire is cut - Cannot enable safeties.")
	else if (!activate && src.safe)
		safe = 0
	else if (activate && !src.safe)
		safe = 1

	if(feedback && message)
		to_chat(usr,message)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return 0
	if(hasShocked)
		return 0	//Already shocked someone recently?
	if(..())
		hasShocked = 1
		sleep(10)
		hasShocked = 0
		return 1
	else
		return 0


/obj/machinery/door/airlock/update_icon()
	cut_overlays()
	if(density)
		if(locked && lights && src.arePowerSystemsOn())
			icon_state = "door_locked"
		else
			icon_state = "door_closed"
		if(p_open || welded)
			if(p_open)
				add_overlay("panel_open")
			if (!(stat & NOPOWER))
				if(stat & BROKEN)
					add_overlay("sparks_broken")
				else if (health < maxhealth * 3/4)
					add_overlay("sparks_damaged")
			if(welded)
				add_overlay("welded")
		else if (health < maxhealth * 3/4 && !(stat & NOPOWER))
			add_overlay("sparks_damaged")
	else
		icon_state = "door_open"
		if((stat & BROKEN) && !(stat & NOPOWER))
			add_overlay("sparks_open")
	return

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			cut_overlay()
			if(p_open)
				flick("o_door_opening", src)  //can not use flick due to BYOND bug updating overlays right before flicking
				update_icon()
			else
				flick("door_opening", src)//[stat ? "_stat":]
				update_icon()
		if("closing")
			cut_overlay()
			if(p_open)
				flick("o_door_closing", src)
				update_icon()
			else
				flick("door_closing", src)
				update_icon()
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && src.arePowerSystemsOn())
				flick("door_deny", src)
				playsound(src, denied_sound, 50, 0, 3)
	return

/obj/machinery/door/airlock/attack_ai(mob/user as mob)
	tgui_interact(user)

/obj/machinery/door/airlock/attack_ghost(mob/user)
	tgui_interact(user)

/obj/machinery/door/airlock/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, datum/tgui_state/custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiAirlock", name)
		ui.open()
	if(custom_state)
		ui.set_state(custom_state)
	return TRUE

/obj/machinery/door/airlock/tgui_data(mob/user)
	var/list/data = list()

	var/list/power = list()
	power["main"] = main_power_lost_until > 0 ? 0 : 2
	power["main_timeleft"] = round(main_power_lost_until > 0 ? max(main_power_lost_until - world.time,	0) / 10 : main_power_lost_until, 1)
	power["backup"] = backup_power_lost_until > 0 ? 0 : 2
	power["backup_timeleft"] = round(backup_power_lost_until > 0 ? max(backup_power_lost_until - world.time, 0) / 10 : backup_power_lost_until, 1)
	data["power"] = power

	data["shock"] = (electrified_until == 0) ? 2 : 0
	data["shock_timeleft"] = round(electrified_until > 0 ? max(electrified_until - world.time, 	0) / 10 : electrified_until, 1)
	data["id_scanner"] = !aiDisabledIdScanner
	data["locked"] = locked // bolted
	data["lights"] = lights // bolt lights
	data["safe"] = safe // safeties
	data["speed"] = normalspeed // safe speed
	data["welded"] = welded // welded
	data["opened"] = !density // opened

	var/list/wire = list()
	wire["main_1"] = !wires.is_cut(WIRE_MAIN_POWER1)
	wire["main_2"] = !wires.is_cut(WIRE_MAIN_POWER2)
	wire["backup_1"] = !wires.is_cut(WIRE_BACKUP_POWER1)
	wire["backup_2"] = !wires.is_cut(WIRE_BACKUP_POWER2)
	wire["shock"] = !wires.is_cut(WIRE_ELECTRIFY)
	wire["id_scanner"] = !wires.is_cut(WIRE_IDSCAN)
	wire["bolts"] = !wires.is_cut(WIRE_DOOR_BOLTS)
	wire["lights"] = !wires.is_cut(WIRE_BOLT_LIGHT)
	wire["safe"] = !wires.is_cut(WIRE_SAFETY)
	wire["timing"] = !wires.is_cut(WIRE_SPEED)

	data["wires"] = wire
	return data

/obj/machinery/door/airlock/proc/hack(mob/user as mob)
	if(src.aiHacking==0)
		src.aiHacking=1
		spawn(20)
			//TODO: Make this take a minute
			to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
			sleep(50)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
			sleep(20)
			to_chat(user, "Attempting to hack into airlock. This may take some time.")
			sleep(200)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
			sleep(170)
			if(src.canAIControl())
				to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
				src.aiHacking=0
				return
			else if(!src.canAIHack(user))
				to_chat(user, "We've lost our connection! Unable to hack airlock.")
				src.aiHacking=0
				return
			to_chat(user, "Transfer complete. Forcing airlock to execute program.")
			sleep(50)
			//disable blocked control
			src.aiControlDisabled = 2
			to_chat(user, "Receiving control information from airlock.")
			sleep(10)
			//bring up airlock dialog
			src.aiHacking = 0
			if (user)
				src.attack_ai(user)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target)
	if (src.isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if (i.matter && (MAT_STEEL in i.matter) && i.matter[MAT_STEEL] > 0)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
	return ..()

/obj/machinery/door/airlock/attack_hand(mob/user as mob)
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return

	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			src.attack_alien(user)
			return

	if(src.p_open)
		user.set_machine(src)
		wires.Interact(user)
	else
		..(user)
	return

/obj/machinery/door/airlock/AltClick(mob/user as mob)
	. = ..()
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!Adjacent(user))
		return
	else if(user.a_intent == I_HURT)
		src.visible_message("<span class='warning'>[user] hammers on \the [src]!</span>", "<span class='warning'>Someone hammers loudly on \the [src]!</span>")
		src.add_fingerprint(user)
		if(icon_state == "door_closed" && arePowerSystemsOn())
			flick("door_deny", src)
		playsound(src, knock_hammer_sound, 50, 0, 3)
	else if(arePowerSystemsOn() && user.a_intent == I_HELP)
		src.visible_message("[user] presses the door bell on \the [src].", "\The [src]'s bell rings.")
		src.add_fingerprint(user)
		if(icon_state == "door_closed")
			flick("door_deny", src)
		playsound(src, knock_sound, 50, 0, 3)
	else if(user.a_intent == I_HELP)
		src.visible_message("[user] knocks on \the [src].", "Someone knocks on \the [src].")
		src.add_fingerprint(user)
		playsound(src, knock_unpowered_sound, 50, 0, 3)
	return

/obj/machinery/door/airlock/tgui_act(action, params)
	if(..())
		return TRUE
	if(!user_allowed(usr))
		return TRUE

	switch(action)
		if("disrupt-main")
			if(!main_power_lost_until)
				loseMainPower()
				update_icon()
			else
				to_chat(usr, "<span class='warning'>Main power is already offline.</span>")
			. = TRUE
		if("disrupt-backup")
			if(!backup_power_lost_until)
				loseBackupPower()
				update_icon()
			else
				to_chat(usr, "<span class='warning'>Backup power is already offline.</span>")
			. = TRUE
		if("shock-restore")
			electrify(0, 1)
			. = TRUE
		if("shock-temp")
			electrify(30, 1)
			. = TRUE
		if("shock-perm")
			electrify(-1, 1)
			. = TRUE
		if("idscan-toggle")
			set_idscan(aiDisabledIdScanner, 1)
			. = TRUE
		// if("emergency-toggle")
		// 	toggle_emergency(usr)
		// 	. = TRUE
		if("bolt-toggle")
			toggle_bolt(usr)
			. = TRUE
		if("light-toggle")
			if(wires.is_cut(WIRE_BOLT_LIGHT))
				to_chat(usr, "The bolt lights wire is cut - The door bolt lights are permanently disabled.")
				return
			lights = !lights
			update_icon()
			. = TRUE
		if("safe-toggle")
			set_safeties(!safe, 1)
			. = TRUE
		if("speed-toggle")
			if(wires.is_cut(WIRE_SPEED))
				to_chat(usr, "The timing wire is cut - Cannot alter timing.")
				return
			normalspeed = !normalspeed
			. = TRUE
		if("open-close")
			user_toggle_open(usr)
			. = TRUE

	update_icon()
	return 1

/obj/machinery/door/airlock/proc/user_allowed(mob/user)
	var/allowed = (issilicon(user) && canAIControl(user))
	if(!allowed && isobserver(user))
		var/mob/observer/dead/D = user
		if(D.can_admin_interact())
			allowed = TRUE
	return allowed

/obj/machinery/door/airlock/proc/toggle_bolt(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_DOOR_BOLTS))
		to_chat(user, "<span class='warning'>The door bolt drop wire is cut - you can't toggle the door bolts.</span>")
		return
	if(locked)
		if(!arePowerSystemsOn())
			to_chat(user, "<span class='warning'>The door has no power - you can't raise the door bolts.</span>")
		else
			unlock()
			to_chat(user, "<span class='notice'>The door bolts have been raised.</span>")
			// log_combat(user, src, "unbolted")
	else
		lock()
		to_chat(user, "<span class='warning'>The door bolts have been dropped.</span>")
		// log_combat(user, src, "bolted")

/obj/machinery/door/airlock/proc/user_toggle_open(mob/user)
	if(!user_allowed(user))
		return
	if(welded)
		to_chat(user, text("<span class='warning'>The airlock has been welded shut!</span>"))
	else if(locked)
		to_chat(user, text("<span class='warning'>The door bolts are down!</span>"))
	else if(!density)
		close()
	else
		open()

/obj/machinery/door/airlock/proc/can_remove_electronics()
	return src.p_open && (operating < 0 || (!operating && welded && !src.arePowerSystemsOn() && density && (!src.locked || (stat & BROKEN))))

/obj/machinery/door/airlock/attackby(obj/item/C, mob/user as mob)
	//to_world("airlock attackby src [src] obj [C] mob [user]")
	if(!istype(usr, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 75))
				return
	if(istype(C, /obj/item/taperoll))
		return

	src.add_fingerprint(user)
	if (attempt_vr(src,"attackby_vr",list(C, user))) return
	if(istype(C, /mob/living))
		..()
		return
	 //VOREstation Edit: Removing material cost from repair requirements
	if(C.has_tool_quality(TOOL_WELDER) && !( src.operating > 0 ) && src.density)
		if(health < maxhealth && user.a_intent == I_HELP)
			..()
			return
		var/obj/item/weapon/weldingtool/W = C.get_welder()
		if(W.remove_fuel(0,user))
			if(!src.welded)
				src.welded = 1
			else
				src.welded = null
			playsound(src, C.usesound, 75, 1)
			src.update_icon()
			return
		else
			return
	else if(C.has_tool_quality(TOOL_SCREWDRIVER))
		if (src.p_open)
			if (stat & BROKEN)
				to_chat(usr, "<span class='warning'>The panel is broken and cannot be closed.</span>")
			else
				src.p_open = FALSE
				playsound(src, C.usesound, 50, 1)
				src.update_icon()
				return
		else
			src.p_open = TRUE
			playsound(src, C.usesound, 50, 1)
			src.update_icon()
			return src.attack_hand(user)
	else if(C.has_tool_quality(TOOL_WIRECUTTER))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/device/multitool))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/device/assembly/signaler))
		return src.attack_hand(user)
	else if(istype(C, /obj/item/weapon/pai_cable))	// -- TLE
		var/obj/item/weapon/pai_cable/cable = C
		cable.plugin(src, user)
	else if(C.has_tool_quality(TOOL_CROWBAR))
		if(can_remove_electronics())
			playsound(src, C.usesound, 75, 1)
			user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to remove electronics from the airlock assembly.")
			if(do_after(user,40 * C.toolspeed))
				to_chat(user, "<span class='notice'>You removed the airlock electronics!</span>")

				var/obj/structure/door_assembly/da = new assembly_type(src.loc)
				if (istype(da, /obj/structure/door_assembly/multi_tile))
					da.set_dir(src.dir)

				da.anchored = TRUE
				if(mineral)
					da.glass = mineral
				//else if(glass)
				else if(glass && !da.glass)
					da.glass = 1
				da.state = 1
				da.created_name = src.name
				da.update_state()

				if(operating == -1 || (stat & BROKEN))
					new /obj/item/weapon/circuitboard/broken(src.loc)
					operating = 0
				else
					if (!electronics) create_electronics()

					electronics.loc = src.loc
					electronics = null

				qdel(src)
				return
		else if(arePowerSystemsOn())
			to_chat(user, "<span class='notice'>The airlock's motors resist your efforts to force it.</span>")
		else if(locked)
			to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
		else
			if(density)
				spawn(0)	open(1)
			else
				spawn(0)	close(1)

	// Check if we're using a crowbar or armblade, and if the airlock's unpowered for whatever reason (off, broken, etc).
	else if(istype(C, /obj/item/weapon))
		var/obj/item/weapon/W = C
		if((W.pry == 1) && !arePowerSystemsOn())
			if(locked)
				to_chat(user, "<span class='notice'>The airlock's bolts prevent it from being forced.</span>")
			else if( !welded && !operating )
				if(istype(C, /obj/item/weapon/material/twohanded/fireaxe)) // If this is a fireaxe, make sure it's held in two hands.
					var/obj/item/weapon/material/twohanded/fireaxe/F = C
					if(!F.wielded)
						to_chat(user, "<span class='warning'>You need to be wielding \the [F] to do that.</span>")
						return
				// At this point, it's an armblade or a fireaxe that passed the wielded test, let's try to open it.
				if(density)
					spawn(0)
						open(1)
				else
					spawn(0)
						close(1)
		else
			..()
	else
		..()
	return

/obj/machinery/door/airlock/phoron/attackby(C as obj, mob/user as mob)
	if(C)
		ignite(is_hot(C))
	..()

/obj/machinery/door/airlock/set_broken()
	src.p_open = TRUE
	stat |= BROKEN
	if (secured_wires)
		lock()
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[src.name]'s control panel bursts open, sparks spewing out!")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()

	update_icon()
	return

/obj/machinery/door/airlock/open(var/forced=0)
	if(!can_open(forced))
		return 0
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

	//if the door is unpowered then it doesn't make sense to hear the woosh of a pneumatic actuator
	for(var/mob/M as anything in player_list)
		if(!M || !M.client)
			continue
		var/old_sounds = M.read_preference(/datum/preference/toggle/old_door_sounds)
		var/department_door_sounds = M.read_preference(/datum/preference/toggle/department_door_sounds)
		var/sound
		var/volume
		if(old_sounds) // Do we have old sounds enabled? Play these even if we have department door sounds enabled.
			if(arePowerSystemsOn())
				sound = legacy_open_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75
		else if(!old_sounds && department_door_sounds && src.department_open_powered) // Else, we have old sounds disabled, the door has per-department door sounds, and we have chosen to play department door sounds, use these.
			if(arePowerSystemsOn())
				sound = department_open_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75
		else // Else, play these.
			if(arePowerSystemsOn())
				sound = open_sound_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75

		var/turf/T = get_turf(M)
		var/distance = get_dist(T, get_turf(src))
		if(distance <= world.view * 2)
			if(T && T.z == get_z(src))
				M.playsound_local(get_turf(src), sound, volume, 1, null, 0, TRUE, sound(sound), volume_channel = VOLUME_CHANNEL_DOORS)

	if(src.closeOther != null && istype(src.closeOther, /obj/machinery/door/airlock/) && !src.closeOther.density)
		src.closeOther.close()
	return ..()

/obj/machinery/door/airlock/can_open(var/forced=0)
	if(!forced)
		if(!arePowerSystemsOn() || wires.is_cut(WIRE_OPEN_DOOR))
			return 0

	if(locked || welded)
		return 0
	return ..()

/obj/machinery/door/airlock/can_close(var/forced=0)
	if(locked || welded)
		return 0

	if(!forced)
		//despite the name, this wire is for general door control.
		if(!arePowerSystemsOn() || wires.is_cut(WIRE_OPEN_DOOR))
			return	0

	return ..()

/atom/movable/proc/blocks_airlock()
	return density

/obj/machinery/door/blocks_airlock()
	return 0

/obj/machinery/mech_sensor/blocks_airlock()
	return 0

/mob/living/blocks_airlock()
	return 1

/atom/movable/proc/airlock_crush(var/crush_damage)
	return 0

/obj/machinery/portable_atmospherics/canister/airlock_crush(var/crush_damage)
	. = ..()
	health -= crush_damage
	healthcheck()

/obj/effect/energy_field/airlock_crush(var/crush_damage)
	adjust_strength(crush_damage)

/obj/structure/closet/airlock_crush(var/crush_damage)
	..()
	damage(crush_damage)
	for(var/atom/movable/AM in src)
		AM.airlock_crush()
	return 1

/mob/living/airlock_crush(var/crush_damage)
	. = ..()
	adjustBruteLoss(crush_damage)
	SetStunned(5)
	SetWeakened(5)
	var/turf/T = get_turf(src)
	T.add_blood(src)
	return 1

/mob/living/carbon/airlock_crush(var/crush_damage)
	. = ..()
	if(can_feel_pain())
		emote("scream")

/mob/living/silicon/robot/airlock_crush(var/crush_damage)
	adjustBruteLoss(crush_damage)
	return 0

/obj/machinery/door/airlock/close(var/forced=0)
	if(!can_close(forced))
		return 0

	if(safe)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					if(!has_beeped)
						playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)
						has_beeped = 1
					autoclose_in(6)
					return

	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(DOOR_CRUSH_DAMAGE))
				take_damage(DOOR_CRUSH_DAMAGE)

	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	has_beeped = 0
	for(var/mob/M as anything in player_list)
		if(!M || !M.client)
			continue
		var/old_sounds = M.read_preference(/datum/preference/toggle/old_door_sounds)
		var/department_door_sounds = M.read_preference(/datum/preference/toggle/department_door_sounds)
		var/sound
		var/volume
		if(old_sounds)
			if(arePowerSystemsOn())
				sound = legacy_close_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75
		else if(!old_sounds && department_door_sounds && src.department_close_powered) // Else, we have old sounds disabled, the door has per-department door sounds, and we have chosen to play department door sounds, use these.
			if(arePowerSystemsOn())
				sound = department_close_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75
		else
			if(arePowerSystemsOn())
				sound = close_sound_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75

		var/turf/T = get_turf(M)
		var/distance = get_dist(T, get_turf(src))
		if(distance <= world.view * 2)
			if(T && T.z == get_z(src))
				M.playsound_local(get_turf(src), sound, volume, 1, null, 0, TRUE, sound(sound), volume_channel = VOLUME_CHANNEL_DOORS)
	for(var/turf/turf in locs)
		var/obj/structure/window/killthis = (locate(/obj/structure/window) in turf)
		if(killthis)
			killthis.ex_act(2)//Smashin windows
	return ..()

/obj/machinery/door/airlock/proc/lock(var/forced=0)
	if(locked)
		return 0

	if (operating && !forced) return 0

	src.locked = 1
	playsound(src, bolt_down_sound, 30, 0, 3, volume_channel = VOLUME_CHANNEL_DOORS)
	for(var/mob/M in range(1,src))
		M.show_message("You hear a click from the bottom of the door.", 2)
	update_icon()
	return 1

/obj/machinery/door/airlock/proc/unlock(var/forced=0)
	if(!src.locked)
		return

	if (!forced)
		if(operating || !src.arePowerSystemsOn() || wires.is_cut(WIRE_DOOR_BOLTS)) return

	src.locked = 0
	playsound(src, bolt_up_sound, 30, 0, 3, volume_channel = VOLUME_CHANNEL_DOORS)
	for(var/mob/M in range(1,src))
		M.show_message("You hear a click from the bottom of the door.", 2)
	update_icon()
	return 1

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return 0
	return ..(M)

/obj/machinery/door/airlock/New(var/newloc, var/obj/structure/door_assembly/assembly=null)
	..()

	//if assembly is given, create the new door from the assembly
	if (assembly && istype(assembly))
		assembly_type = assembly.type

		electronics = assembly.electronics
		electronics.loc = src

		//update the door's access to match the electronics'
		secured_wires = electronics.secure
		if(electronics.one_access)
			LAZYCLEARLIST(req_access)
			req_one_access = src.electronics.conf_access
		else
			LAZYCLEARLIST(req_one_access)
			req_access = src.electronics.conf_access

		//get the name from the assembly
		if(assembly.created_name)
			name = assembly.created_name
		else
			name = "[istext(assembly.glass) ? "[assembly.glass] airlock" : assembly.base_name]"

		//get the dir from the assembly
		set_dir(assembly.dir)

	//wires
	var/turf/T = get_turf(newloc)
	if(T && (T.z in using_map.admin_levels))
		secured_wires = 1
	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

/obj/machinery/door/airlock/Initialize()
	if(src.closeOtherId != null)
		for (var/obj/machinery/door/airlock/A in machines)
			if(A.closeOtherId == src.closeOtherId && A != src)
				src.closeOther = A
				break
	name = "\improper [name]"
	. = ..()

/obj/machinery/door/airlock/Destroy()
	qdel(wires)
	wires = null
	return ..()

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/airlock/proc/create_electronics()
	//create new electronics
	if (secured_wires)
		src.electronics = new/obj/item/weapon/airlock_electronics/secure( src.loc )
	else
		src.electronics = new/obj/item/weapon/airlock_electronics( src.loc )

	//update the electronics to match the door's access
	if(LAZYLEN(req_access))
		electronics.conf_access = req_access
	else if (LAZYLEN(req_one_access))
		electronics.conf_access = req_one_access
		electronics.one_access = 1

/obj/machinery/door/airlock/emp_act(var/severity)
	if(prob(40/severity))
		var/duration = world.time + SecondsToTicks(30 / severity)
		if(duration > electrified_until)
			electrify(duration)
	..()

/obj/machinery/door/airlock/power_change() //putting this is obj/machinery/door itself makes non-airlock doors turn invisible for some reason
	..()
	if(stat & NOPOWER)
		// If we lost power, disable electrification
		// Keeping door lights on, runs on internal battery or something.
		electrified_until = 0
	update_icon()

/obj/machinery/door/airlock/proc/prison_open()
	if(arePowerSystemsOn())
		src.unlock()
		src.open()
		src.lock()
	return


/obj/machinery/door/airlock/rcd_values(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			// Old RCD code made it cost 10 units to decon an airlock.
			// Now the new one costs ten "sheets".
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 10
			)
	return FALSE

/obj/machinery/door/airlock/rcd_act(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span("notice", "You deconstruct \the [src]."))
			qdel(src)
			return TRUE
	return FALSE
