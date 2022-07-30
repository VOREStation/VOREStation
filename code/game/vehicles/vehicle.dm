

/obj/vehicle
	name = "Vehicle"
	icon = 'icons/vehicles/vehicles.dmi'
	density = TRUE
	anchored = TRUE
	unacidable = TRUE //To avoid the pilot-deleting shit that came with mechas
	layer = MOB_LAYER
	//var/can_move = 1
	var/mob/living/carbon/occupant = null
	//var/step_in = 10 //make a step in step_in/10 sec.
	//var/dir_in = 2//What direction will the mech face when entered/powered on? Defaults to South.
	//var/step_energy_drain = 10
	var/health = 300 //health is health
	//var/deflect_chance = 10 //chance to deflect the incoming projectiles, hits, or lesser the effect of ex_act.
	//the values in this list show how much damage will pass through, not how much will be absorbed.
	var/list/damage_absorption = list("brute"=0.8,"fire"=1.2,"bullet"=0.9,"laser"=1,"energy"=1,"bomb"=1)
	var/obj/item/cell/cell //Our power source
	var/state = 0
	var/list/log = new
	var/last_message = 0
	var/add_req_access = 1
	var/maint_access = 1
	//var/dna	//dna-locking the mech
	var/list/proc_res = list() //stores proc owners, like proc_res["functionname"] = owner reference
	var/datum/effect_system/spark_spread/spark_system = new
	var/lights = 0
	var/lights_power = 6

	//inner atmos 						//These go in airtight.dm, not all vehicles are space-faring -Agouri
	//var/use_internal_tank = 0
	//var/internal_tank_valve = ONE_ATMOSPHERE
	//var/obj/machinery/portable_atmospherics/canister/internal_tank
	//var/datum/gas_mixture/cabin_air
	//var/obj/machinery/atmospherics/portables_connector/connected_port = null

	var/obj/item/radio/radio = null

	var/max_temperature = 2500
	//var/internal_damage_threshold = 50 //health percentage below which internal damage is possible
	var/internal_damage = 0 //contains bitflags

	var/list/operation_req_access = list()//required access level for mecha operation
	var/list/internals_req_access = list(access_engine,access_robotics)//required access level to open cell compartment

	var/wreckage

	var/list/equipment = new
	var/obj/selected
	//var/max_equip = 3




/obj/vehicle/Initialize()
	. = ..()
	icon_state += "-unmanned"
	add_radio()

	spark_system.set_up(2, 0, src)
	spark_system.attach(src)
	add_cell()
	removeVerb(/atom/movable/verb/pull)
	log_message("[src.name]'s functions initialised. Work protocols active - Entering IDLE mode.")


//################ Helpers ###########################################################


/obj/vehicle/proc/removeVerb(verb_path)
	verbs -= verb_path

/obj/vehicle/proc/addVerb(verb_path)
	verbs += verb_path

/obj/vehicle/proc/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/mech(src)

/obj/vehicle/proc/add_radio()
	radio = new(src)
	radio.name = "[src] radio"
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = 1

/obj/vehicle/proc/check_for_support()
	if(locate(/obj/structure/grille, orange(1, src)) || locate(/obj/structure/lattice, orange(1, src)) || locate(/turf/simulated, orange(1, src)) || locate(/turf/unsimulated, orange(1, src)))
		return 1
	else
		return 0

//################ Logs and messages ############################################


/obj/vehicle/proc/log_message(message as text,red=null)
	log.len++
	log[log.len] = list("time"=world.timeofday,"message"="[red?"<font color='red'>":null][message][red?"</font>":null]")
	return log.len
