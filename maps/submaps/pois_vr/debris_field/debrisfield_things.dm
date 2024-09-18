/obj/tether_away_spawner/debrisfield
	atmos_comp = FALSE
	prob_spawn = 100
	prob_fall = 15

/obj/tether_away_spawner/debrisfield/carp
	name = "debris field carp spawner"
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp = 3,
		/mob/living/simple_mob/animal/space/carp/large = 1
	)

/obj/tether_away_spawner/debrisfield/carp/hard
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/space/carp/large = 2,
		/mob/living/simple_mob/animal/space/carp/large/huge = 1
	)

/obj/tether_away_spawner/debrisfield/derelict
	name = "debris field derelict random mob spawner"
	faction = FACTION_DERELICT
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 2,
		/mob/living/simple_mob/mechanical/infectionbot = 3,
		/mob/living/simple_mob/mechanical/combat_drone = 1
	)

/obj/tether_away_spawner/debrisfield/derelict/corrupt_maint_swarm
	name = "debris field derelict maint swarm"
	faction = FACTION_DERELICT
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/corrupt_maint_drone = 4
	)

/obj/tether_away_spawner/debrisfield/derelict/mech_wizard
	name = "debris field derelict wizard lol"
	faction = FACTION_DERELICT
	mobs_to_pick_from = list(
		/mob/living/simple_mob/mechanical/technomancer_golem = 2
	)

//Sciship
/mob/living/simple_mob/tomato/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/tomato/space/Process_Spacemove(var/check_drift = 0)
	return TRUE

//Begin tourist ship stuff
/mob/living/simple_mob/animal/giant_spider/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/animal/giant_spider/space/Process_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_mob/animal/giant_spider/nurse/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/animal/giant_spider/nurse/space/Process_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_mob/animal/giant_spider/hunter/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/animal/giant_spider/hunter/space/Process_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_mob/animal/giant_spider/tunneler/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/animal/giant_spider/tunneler/space/Process_Spacemove(var/check_drift = 0)
	return TRUE

/obj/structure/ghost_pod/manual/survivor/spidership
	name = "Damaged Emergency Cryopod"
	desc = "A damaged cryopod smeared with blood. An badly injured body seems frozen in time within."
	occupant_type = "survivor aboard a spider infested ship"

	start_injured = TRUE
	suffer_brute = TRUE //default damage of 3d20 brute where each dice is rolled for a separate limb is good
	suffer_burn = TRUE
	burn_severity = 15 //Rapid cooling will give frostbite
	burn_instances = 1 //Burning them once for up to 15 burn. Done to increase risk of infection
	suffer_toxloss = TRUE
	tox_severity = 5
	//Damage is minimum 3 brute, 1 burn, 1 toxloss, maximum 60 brute, 15 burn, 5 toxloss - near crit, but still able to walk.



/obj/item/taperecorder/tourist
	name = "Body-Microphone"
	desc = "A sort of liability device worn by security on luxury yachts. Records everything they say. Strange that the captain was wearing it."
	mytape = /obj/item/tape/touristguard

/obj/item/tape/touristguard/New()
	storedinfo += "01:37  *sounds of metal creaking"
	storedinfo += "01:55  *sounds of distant screaming!"
	storedinfo += "01:37  *Sounds of hissing, both airlocks and spiders alike. Screaming continues."
	storedinfo += "06:03	a mechanical voice - perhaps the PA? 'All visitors are to report to the head and follow emergency orders. This is not a drill."
	storedinfo += "07:19	a voice, muffled by an enclosed helmet, 'Get into the cryopods already!! We don't have time! They should keep you safe! Hurry! Hurry!'"
	storedinfo += "09:13	*gruesome sounds of machines exploding, wet splatter and ominous hissing"
	used_capacity = 1755 //almost full

/obj/item/space_spider_egg
	name = "ruptured giant spider egg"
	desc = "An attempt by space-adapted giant spiders to reproduce! Unfortunately, their young cannot yet survive hard vacuum. Yet."
	icon = 'icons/obj/egg_new_vr.dmi'	//VOREStation Edit
	icon_state = "egg_slimeglob"
	origin_tech = list(TECH_BIO = 10)

/obj/item/space_spider_egg/attack_self(mob/user as mob)
	var/turf/drop_loc = user.loc
	to_chat(user, SPAN_WARNING("The egg cracks open, splattering disgusting goop at your feet...\n \
	Whatever life laid within shall never awaken, if it was even alive."))
	new /obj/effect/decal/cleanable/spiderling_remains(drop_loc)
	qdel(src)

// End of Tourist ship stuff

/obj/random/slimecore
	name = "random slime core"
	desc = "Random slime core."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "rainbow slime extract"

/obj/random/slimecore/item_to_spawn()
	return pick(prob(3);/obj/item/slime_extract/metal,
				prob(3);/obj/item/slime_extract/blue,
				prob(3);/obj/item/slime_extract/purple,
				prob(3);/obj/item/slime_extract/orange,
				prob(3);/obj/item/slime_extract/yellow,
				prob(3);/obj/item/slime_extract/gold,
				prob(3);/obj/item/slime_extract/silver,
				prob(3);/obj/item/slime_extract/dark_purple,
				prob(3);/obj/item/slime_extract/dark_blue,
				prob(3);/obj/item/slime_extract/red,
				prob(3);/obj/item/slime_extract/green,
				prob(3);/obj/item/slime_extract/pink,
				prob(2);/obj/item/slime_extract/oil,
				prob(2);/obj/item/slime_extract/bluespace,
				prob(2);/obj/item/slime_extract/cerulean,
				prob(2);/obj/item/slime_extract/amber,
				prob(2);/obj/item/slime_extract/sapphire,
				prob(2);/obj/item/slime_extract/ruby,
				prob(2);/obj/item/slime_extract/emerald,
				prob(2);/obj/item/slime_extract/light_pink,
				prob(1);/obj/item/slime_extract/grey,
				prob(1);/obj/item/slime_extract/rainbow)

/obj/item/paper/robo_escape_pod
	name = "faded note"
	info = {"<i>This paper is old and the shaky writing has faded, rendering it difficult to read.</i><br>\
whichever poor bastard finds this pod<br>\
<br>\
im sorry<br>\
we tried to do everything we could for her<br>\
but in the end the virus was too much<br>\
rnd wanted to take her apart and document what happened<br>\
but after watching her tear through three of my men like they were nothing<br>\
i just. i couldnt. they might fire me, but fuck the suits. the safety of the other staff here matter more.<br>\
her fucking dignity matters more.<br>\
<br>\
we managed to bait her into one of the escape pods. fired her out into the black.<br>\
<br>\
hope nobody ever has to read this. has to find her.<br>\
if you do, im sorry.<br>\
i just hope whatever happens, she finds the mercy we werent equipped to give her.<br>\
<i>The author's signature is smudged beyond recognition.</i>"}

/mob/living/simple_mob/humanoid/merc/melee/drone/tanker_escort
	name = "NED Sigma-Phi "
	desc = "A rudimentary combat drone! You might recognize this as an automated gamma escort for semi-autonomous NanoTrasen vessels."
	tt_desc = "Escort Gamma Drone"
	tt_desc = null
	health = 75
	maxHealth = 75
	ai_holder_type = /datum/ai_holder/simple_mob/merc/tanker_escort
	say_list_type = /datum/say_list/merc/drone/tanker_escort
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone/tanker
	loot_list = list(/obj/item/poi/broken_drone_circuit/phoron_tanker = 100, /obj/item/material/knife/tacknife = 100)
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0


/mob/living/simple_mob/humanoid/merc/melee/sword/drone/tanker_escort
	name = "NED Sigma-Delta "
	desc = "A rudimentary combat drone! You might recognize this as an automated gamma escort for semi-autonomous NanoTrasen vessels."
	tt_desc = "Escort Gamma Drone"
	health = 35 // Glass cannon
	maxHealth = 75
	tt_desc = null
	ai_holder_type = /datum/ai_holder/simple_mob/merc/tanker_escort
	say_list_type = /datum/say_list/merc/drone/tanker_escort
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone/tanker
	loot_list = list(/obj/item/poi/broken_drone_circuit/phoron_tanker = 100,
	/obj/item/shield/energy = 100, /obj/item/melee/energy/sword/color = 20)
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_mob/humanoid/merc/ranged/smg/drone/tanker_escort
	name = "NED Rho-Phi"
	desc = "A rudimentary combat drone! You might recognize this as an automated gamma escort for semi-autonomous NanoTrasen vessels."
	tt_desc = "Escort Gamma Drone"
	health = 100 //Max health stays same, but our guy got hit with a mateba a few times..
	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged/tanker_escort
	say_list_type = /datum/say_list/merc/drone/tanker_escort
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone/tanker
	loot_list = list(/obj/item/poi/broken_drone_circuit/phoron_tanker = 100, /obj/item/gun/projectile/automatic/c20r = 100)
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/obj/effect/landmark/mobcorpse/syndicatesoldier/drone/tanker
	corpsesynthbrand = "NanoTrasen"
	corpseidjob = "Tanker Security"

/obj/effect/landmark/mobcorpse/syndicatesoldier/drone/tanker/generateCorpseName()
	var/letter = "NED"
	var/number = rand(0,999)
	return "[letter]-[number] Guard Drone"

/datum/ai_holder/simple_mob/merc/tanker_escort
	threaten = FALSE //We're jumping from shadows!

/datum/ai_holder/simple_mob/merc/ranged/tanker_escort
	threaten_delay = 3 SECONDS //Bugged escort drones, we give a warning, take aim... FIRE!

/datum/say_list/merc/drone/tanker_escort
	speak = list( "Attempt Do-dock... Do-dock... Err-",
	"Re-resc . . . Rescind. Rescind Tanker!",
	"Evaluate Asteroid",
	"Report Al-Al-Al-Al...",
	"Find Fax!"
	)
	say_threaten = list("INTRU-INT-INT")
	say_escalate = list("Janitorial Engaged!", "Shoot to-ta-te stun!")

/obj/item/poi/broken_drone_circuit/phoron_tanker
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_DATA = 4, TECH_COMBAT = 6)
	var/static/area/submap/debrisfield/phoron_tanker/tanker	//Doing this to save some perf
	examine_multitool = "ERR- ERR- KZZZHT \n \
	designation: <b>kzth!</b> \n assignment: <b>CRACKLE</b> \n \
	ZRRRRRRRRRRRRR  \n \
	goal: RETURN HOME status: Successful \n \
	goal: PRO-PRO"

/obj/item/poi/broken_drone_circuit/phoron_tanker/New()
	drone_name = "NED-[pick(list("ADA","DOS","GNU","MAC","WIN","NJS","SKS","DRD","IOS","CRM","IBM","TEX","LVM","BSD",))]-[rand(1000, 9999)]]"
	tanker = locate("POI_NT_TANKER_BOAT")	//actual .dmm area has this
	var/tankername = "Unknown Ship"
	if(tanker)
		tankername = tanker.ic_name

	examine_canalyzer = "<b>UNIT DESIGNATION</b>: [drone_name] \n <b>UNIT ASSIGNMENT</b>: [tankername] \n \
	<b>TASKING</b>: Accompany & Protect <b>STATUS</b>: INTERRUPTED \n \
	<b>TASKING</b>: HIJACK DETECTED <b>STATUS</b>: RESOLVED \n \
	<b>TASKING</b>: RETURN HOME <b>STATUS</b>: SUCCESSFULLY RETURNED TO NSB ADEGAPHIA \n \
	<b>TASKING</b>: WAIT HANDOFF AUTHORITY <b>STATUS</b>: ACTIVE"
	examine_canalyzer_printed =  "<b>UNIT DESIGNATION</b>: [drone_name] <br> <b>UNIT ASSIGNMENT</b>: [tankername] <br> \
	<b>TASKING</b>: Accompany & Protect <b>STATUS</b>: INTERRUPTED <br> \
	<b>EVENT</b>: POWER SURGE DETECTED   <br><b>STATUS</b>: 069 082 082 079 082 <br> \
	<b>DIAG</b>: SENSORS  <br> <b>STATUS</b>: 070 065 073 076 <br>\
	<b>EVENT</b>: POWER SURGE DETECTED  <br> <b>STATUS</b>: RESE7 COMPLEvE <br> \
	<b>DIAG</b>: SENSORS  <br> <b>STATUS</b>: PPAAS <br> \
	<b>TASKING</b>: HIJACK DETECTED  <br> <b>STATUS</b>: RESsOLV3D <br> \
	<b>EVENT</b>: DISCHARGE <b>STATUS</b>: CONfIVED <br> \
	<b>DIAG</b>: PLATING <b>STATUS</b>: DENtED <br> \
	<b>TASKING</b>: RETURN HOME  <br> <b>STATUS</b>: S8CCeSSFULLY RETURnED tO NSB AD3GAPhIA <br> \
	<b>EVENT</b> IMPACT  <br> <b>STATUS</b>: NOTE HArD DOCkING <br> \
	<b>TASKING</b>: WAIT HANDOFF AUTHORITY <b>STATUS</b>: 4CTIVE <br> \
	<b>EVENT</b>: TRESPAS <b>STATUS</b>: 3Limited"
