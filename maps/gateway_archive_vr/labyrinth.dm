/area/awaymission/labyrinth
	icon_state = "blank"

/area/awaymission/labyrinth/arrival
	icon_state = "away"
	requires_power = 0

/area/awaymission/labyrinth/cave
	icon_state = "blue"

/area/awaymission/labyrinth/temple
	icon_state = "away"
	ambience = list() // Todo: Add better ambience.

/area/awaymission/labyrinth/temple/entry
	icon_state = "chapel"
	ambience = list('sound/music/TheClownChild.ogg')

// These extra areas must break up the large area, or the game crashes when machinery (like an airlock) makes sparks.
// I have no idea why. It's a nasty bug.
/area/awaymission/labyrinth/temple/south_east
	icon_state = "red"

/area/awaymission/labyrinth/temple/south_west
	icon_state = "bluenew"

/area/awaymission/labyrinth/temple/south
	icon_state = "green"

/area/awaymission/labyrinth/temple/west
	icon_state = "purple"

/area/awaymission/labyrinth/temple/center
	icon_state = "yellow"

/area/awaymission/labyrinth/temple/east
	icon_state = "blue"

/area/awaymission/labyrinth/temple/north_east
	icon_state = "exit"

/area/awaymission/labyrinth/temple/north_west
	icon_state = "away4"

/area/awaymission/labyrinth/temple/north
	icon_state = "blue"

/area/awaymission/labyrinth/boss
	icon_state = "red"

/turf/unsimulated/wall/exterior
	opacity = 0
	// For the outside of a building, or a massive wall.

/turf/unsimulated/floor/lava
	name = "lava"
	icon_state = "lava"
	density = 1
	luminosity = 3

/obj/structure/HonkMother
	name = "The Honk Mother"
	desc = "A monolithic effigy of the legendary Honk Mother, adorned with dazzling rainbow bananium."
	icon = 'icons/effects/160x160.dmi'
	pixel_x = -64

/obj/structure/HonkMother/Apex
	icon_state = "HonkMotherApex"

/obj/structure/HonkMother/Base
	icon_state = "HonkMotherBase"

/obj/effect/decal/mecha_wreckage/honker/cluwne
	name = "cluwne mech wreckage"
	icon_state = "cluwne-broken"
	desc = "Not so funny anymore."

/*
/obj/structure/falsewall/cultspecial
	name = "loose wall"
	desc = "This wall tile seems loose. Try pushing on it."
	icon_state = ""
//	mineral = "cultspecial"
	density = 1
	opacity = 1
*/

/obj/machinery/door/airlock/vault/temple
	name = "Catacombs"
	desc = "In a temple like this, these doors could be booby trapped..."

/obj/machinery/door/airlock/vault/temple/New()
	if(prob(33))
		new /obj/structure/falsewall/cultspecial(src.loc)
		qdel(src)
	if(prob(33))
		safe = 0
	if(prob(33))
		locked = 1
	if(prob(50))
		secured_wires = 0

/obj/mecha/combat/honker/cluwne // What have I done?
	desc = "Mechanized Assault Device for Juggernaughting Against Clown Killers. You've only heard legends about this exosuit..."
	name = "M.A.D. J.A.C.K."
	icon = 'icons/mecha/mecha_vr.dmi'
	icon_state = "cluwne"
	initial_icon = "cluwne"
	step_in = 2
	health = 500
	deflect_chance = 60
	internal_damage_threshold = 60
	damage_absorption = list("brute"=1.2,"fire"=1.5,"bullet"=1,"laser"=1,"energy"=1,"bomb"=1)
	max_temperature = 25000
	infra_luminosity = 5
	operation_req_access = list(access_cent_creed)
	wreckage = /obj/effect/decal/mecha_wreckage/honker/cluwne
	max_equip = 4

/obj/mecha/combat/honker/cluwne/New()
	..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/pulse
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/honker
	ME.attach(src)
	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/banana_mortar
	name = "Banana Mortar"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/bananapeel
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectile_energy_cost = 100
	equip_cooldown = 20

	can_attach(obj/mecha/combat/honker/M as obj)
		if(!istype(M))
			return 0
		return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/honker
	name = "\improper HoNkER BlAsT 5000"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "mecha_honker"
	energy_drain = 200
	equip_cooldown = 150
	range = MELEE|RANGED

	can_attach(obj/mecha/combat/honker/M as obj)
		if(!istype(M))
			return 0
		return ..()

	action(target)
		if(!chassis)
			return 0
		if(energy_drain && chassis.get_charge() < energy_drain)
			return 0
		if(!equip_ready)
			return 0

		playsound(chassis, 'sound/items/AirHorn.ogg', 100, 1)
		chassis.occupant_message(span_red("<font size='5'>HONK</font>"))
		for(var/mob/living/carbon/M in ohearers(6, chassis))
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
					continue
			to_chat(M, span_red("<font size='7'>HONK</font>"))
			M.sleeping = 0
			M.stuttering += 20
			M.ear_deaf += 30
			M.Weaken(3)
			if(prob(30))
				M.Stun(10)
				M.Paralyse(4)
			else
				M.make_jittery(500)
		chassis.use_power(energy_drain)
		log_message("Honked from [src.name]. HONK!")
		do_after_cooldown()
		return

/obj/effect/landmark/mobcorpse/tunnelclown
	name = "dead tunnel clown"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpsesuit = /obj/item/clothing/suit/storage/hooded/chaplain_hoodie
	corpsegloves = /obj/item/clothing/gloves/black
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn

/obj/effect/landmark/mobcorpse/tunnelclown/sentinel
	name = "dead clown sentinel"
	corpsesuit = /obj/item/clothing/suit/cultrobes
	corpsehelmet = /obj/item/clothing/head/culthood

/mob/living/simple_mob/hostile/tunnelclown
	name = "tunnel clown"
	desc = "A clown driven to madness in the depths of the Honk Mother's Catacombs."
	faction = FACTION_TUNNELCLOWN
	icon = 'icons/mob/clowns_vr.dmi'
	icon_state = "tunnelclown"
	icon_living = "tunnelclown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
//	speak = list("HONK", "Honk!")
//	emote_hear = list("honks")
//	speak_chance = 1
	a_intent = "harm"
	var/corpse = /obj/effect/landmark/mobcorpse/tunnelclown
	var/weapon1 = /obj/item/twohanded/fireaxe
	stop_when_pulled = 0
	maxHealth = 100
	health = 100
	speed = 4
	harm_intent_damage = 8
	melee_damage_lower = 30
	melee_damage_upper = 40
	attacktext = "cleaved"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 270
	maxbodytemp = 370
	heat_damage_per_tick = 15
	cold_damage_per_tick = 10
	unsuitable_atoms_damage = 10

/mob/living/simple_mob/hostile/tunnelclown/sentinel
	name = "tunnel clown sentinel"
	desc = "A clown warrior tasked with guarding the Honk Mother's Catacombs."
	faction = FACTION_TUNNELCLOWN
	icon = 'icons/mob/clowns_vr.dmi'
	icon_state = "sentinelclown"
	icon_living = "sentinelclown"
	icon_dead = "clown_dead"
	corpse = /obj/effect/landmark/mobcorpse/tunnelclown/sentinel
	weapon1 = /obj/item/material/twohanded/spear
	maxHealth = 150
	health = 150
	melee_damage_lower = 15
	melee_damage_upper = 20

/mob/living/simple_mob/hostile/tunnelclown/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	del src
	return

/mob/living/simple_mob/hostile/cluwne
	name = "cluwne"
	desc = "A mutated clown alleged to have been cursed by the Honk Mother and permanently banished to these catacombs for once being an unfunny shitter who brought grief instead of laughter."
	faction = FACTION_TUNNELCLOWN
	icon = 'icons/mob/clowns_vr.dmi'
	icon_state = "cluwne"
	icon_living = "cluwne"
	icon_dead = "cluwne_dead"
	icon_gib = "clown_gib"
	speak_chance = 5
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "euthanizes"
//	speak = list("HONK!", "Honk!", "H-Honk...", "Honk... Please...","Kill me... Honk.", "It hurts to live... Honk...","The pain... HONK!")
//	emote_hear = list("honks", "wheeps","sobs","whimpers","honks uncontrollably")
	a_intent = "harm"
	stop_when_pulled = 0
	maxHealth = 10
	health = 10
	speed = 1
	harm_intent_damage = 8
	melee_damage_lower = 1 // Pathetic creatures.
	melee_damage_upper = 1
	attacktext = "honked"
	attack_sound = 'sound/items/bikehorn.ogg'
	status_flags = CANPUSH
	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 270
	maxbodytemp = 370
	heat_damage_per_tick = 15
	cold_damage_per_tick = 10
	unsuitable_atoms_damage = 10

/obj/random/mob/clown
	name = "Random Clown Mob"
	desc = "This is a random clown spawn. You aren't supposed to see this. Call an admin because reality has broken into the meta."
	icon = 'icons/mob/clowns_vr.dmi'
	icon_state = "clown"
	spawn_nothing_percentage = 50
	item_to_spawn()
		return pick(prob(3);/mob/living/simple_mob/hostile/cluwne,
					prob(2);/mob/living/simple_mob/hostile/tunnelclown/sentinel,
					prob(1);/mob/living/simple_mob/hostile/tunnelclown)

/obj/item/paper/awaygate/labyrinth/calypso
	name = "copy of the Final Flight of Calypso"
	info = {"<h3>THIS IS A COPY OF THE LOGBOOKS AS COPIED BY GREYSON MAXIMUS, CAPTAIN V.O.R.E. NANOTRASEN.</h3>
			<p><b>//BEGIN//</b>
			</p><p>Penned by Captain Honkington.&nbsp;
			</p><p><b>2554-11-24</b>
			</p><p>Base camp has been established at survey site A and construction of planetside shuttle dock has been completed. The dig team have been waiting for this moment for years, a chance to unearth a monument that has lain untouched for thousands of years. So many secrets, so many lost treasures, and we will be the ones to bring them to the fore once again, to show that our civilisation is not a joke. This will be a momentous occasion.
			</p><p><b>2554-11-29</b>
			</p><p>The dig team have located a small structure 2.3km SSW of the shuttle dock. Upon further investigation, the entire hill upon which it sits appears to have been artificially constructed! Further survey equipment is en-route, initial scans indicate some sort of vast complex beneath, and the team believe they may have found the entrance.
			</p><p><b>2554-12-01</b>
			</p><p>Well, they found the entrance. A great stone door with a lead seal. We have yet to translate the markings. Probably telling us to stay out, but since when have our people ever done that? Honk.
			</p><p><b>2554-12-02</b>
			</p><p>The dig team have reported vast halls filled with writings, huge inscriptions upon the far wall facing the door - the images are truly breathtaking! I haven't seen a translation, but the markings on the door apparently warned of some terrible curse. It doesn't seem to have dissuaded the dig team though. If anything, they're in better spirits than ever.
			</p><p><b>2554-12-04</b>
			</p><p>Security had to break up a fight in the mess today. One of the archaeologists had a joke to tell and became violent upon being told we'd probably heard it before. Ruffled everyone's feathers a bit, but everyone seemed to laugh it off.
			</p><p><b>2554-12-07</b>
			</p><p>Security was stepped up to condition blue today. Something about the joke, the crew are getting obsessed with it, graffiti on the walls, smashing windows and screaming over comms. Tooters and I didn't hear what they said, what little we did make out was.. just noise. Medical have been doing what they can, but so far haven't isolated any kind of virus.
			</p><p><b>2554-12-08:1</b>
			</p><p>Red alert authorised by Captain Honkington and First Officer Tooters. Things have progressed to a full-on riot. Contact with medical has been lost.
			</p><p>It's the joke, they brought them there, passed it on, the doctors heard it. Warden Clankers managed to get the earmuffs from the firing range, we're going to try and make a break for the launch.
			</p><p><b>2554-12-08:2</b>
			</p><p>Dear god, they got Tooters. Pulled the earmuffs right off his head and screamed in his ears, the poor sod just started.. giggling. Clankers and I got away, we're holed up in the engine room.
			</p><p>We're going to rig the engines to blow. God, code Delta? How did a joke come to this?
			</p><p><b>Date unknown</b>
			</p><p>Clankers didn't make it. Last I saw, he was shutting off the coolant and pouring plasma into the gas mix, then... nothing but fire. I just managed to make it to the launch before the core blew, didn't even reach the cockpit, just hit the emergency boosters. I have no idea what the hell they found down there, what sort of thing could twist a crew of upstanding clowns into such... parodies of their former selves. I don't know how long I've been drifting, it could be days and I haven't been able to bring myself to even take the helm. I can only hope that whatever horrible secrets they dug up down there died with them.
			</p><p><b>Date unknown</b>
			</p><p>I just heard a noise. Oh god, please let me be alone.
			</p><p><b>Date unknown</b>
			</p><p>Oh god they're here. Some of them made it, I can hear them. What the hell did I do to deserve this? I can't even count the sounds, there must be over a dozen of them, dear god how did they fit so many of them into that tiny cockpit?
			</p><p>Oh holy honkmonther preserve me, this isn't funny. This isn't funny at a-
			</p><p>HONK</p>
			<b>//END//</b>"}

/obj/item/paper/awaygate/labyrinth/research
	name = "research notes"
	info = {"This must be the location of the alleged dig site mentioned in the Calypso's logs. These are the coordinates recovered from the wreck, and everything checks out.
			My excavation team discovered two monoliths; one near the surface, and another at an underground shrine. I think this is it, but Dr. Madison hasn't come back with his team
			to confirm. I'm about to leave and check it out for myself. I've translated some of the writing we copied, and it looks like a riddle. Maybe Dr. Madison has already figured
			it out. He was excited to head back down with the team after I translated it. I wonder what it means. I'll translate the rest when I get back."}

/obj/effect/spawner/lootdrop/labyrinth
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	lootcount = 1		//how many items will be spawned
	lootdoubles = 0		//if the same item can be spawned twice
	loot = ""			//a list of possible items to spawn- a string of paths
