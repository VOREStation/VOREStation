/obj/machinery/computer/arcade
	name = "random arcade"
	desc = "random arcade machine"
	icon_state = "arcade1"
	icon_keyboard = null
	clicksound = null	//Gets too spammy and makes no sense for arcade to have the console keyboard noise anyway
	var/list/prizes = list(	/obj/item/storage/box/snappops								= 2,
							/obj/item/toy/blink                                         = 2,
							/obj/item/clothing/under/syndicate/tacticool                = 2,
							/obj/item/toy/sword                                         = 2,
							/obj/item/gun/projectile/revolver/capgun					= 2,
							/obj/item/gun/projectile/revolver/toy/crossbow				= 2,
							/obj/item/clothing/suit/syndicatefake                       = 2,
							/obj/item/storage/fancy/crayons								= 2,
							/obj/item/toy/spinningtoy                                   = 2,
							/obj/random/mech_toy                                        = 1,
							/obj/item/reagent_containers/spray/waterflower				= 1,
							/obj/random/action_figure                                   = 1,
							/obj/random/plushie                                         = 1,
							/obj/item/toy/cultsword                                     = 1,
							/obj/item/toy/bouquet/fake                                  = 1,
							/obj/item/clothing/accessory/badge/sheriff                  = 2,
							/obj/item/toy/stickhorse                                    = 2
							)
	var/list/special_prizes = list() // Holds instanced objects, intended for admins to shove surprises inside or something.

/obj/machinery/computer/arcade/Initialize()
	. = ..()
	// If it's a generic arcade machine, pick a random arcade
	// circuit board for it and make the new machine
	if(!circuit)
		var/choice = pick(subtypesof(/obj/item/circuitboard/arcade) - /obj/item/circuitboard/arcade/clawmachine)
		var/obj/item/circuitboard/CB = new choice()
		new CB.build_path(loc, CB)
		return INITIALIZE_HINT_QDEL

/obj/machinery/computer/arcade/proc/prizevend()
	if(LAZYLEN(special_prizes)) // Downstream wanted the 'win things inside contents sans circuitboard' feature kept.
		var/atom/movable/AM = pick_n_take(special_prizes)
		AM.forceMove(get_turf(src))
		special_prizes -= AM

	else if(LAZYLEN(prizes))
		var/prizeselect = pickweight(prizes)
		new prizeselect(src.loc)

		if(istype(prizeselect, /obj/item/clothing/suit/syndicatefake)) //Helmet is part of the suit
			new	/obj/item/clothing/head/syndicatefake(src.loc)

/obj/machinery/computer/arcade/attack_ai(mob/user as mob)
	return attack_hand(user)


/obj/machinery/computer/arcade/emp_act(severity)
	if(stat & (NOPOWER|BROKEN))
		..(severity)
		return
	var/empprize = null
	var/num_of_prizes = 0
	switch(severity)
		if(1)
			num_of_prizes = rand(1,4)
		if(2)
			num_of_prizes = rand(1,3)
		if(3)
			num_of_prizes = rand(0,2)
		if(4)
			num_of_prizes = rand(0,1)
	for(num_of_prizes; num_of_prizes > 0; num_of_prizes--)
		empprize = pickweight(prizes)
		new empprize(src.loc)

	..(severity)

///////////////////
//  BATTLE HERE  //
///////////////////

/obj/machinery/computer/arcade/battle
	name = "Battler"
	desc = "Fight through what space has to offer!"
	icon_state = "arcade2"
	icon_screen = "battler"
	circuit = /obj/item/circuitboard/arcade/battle
	var/enemy_name = "Space Villian"
	var/temp = "Winners don't use space drugs" //Temporary message, for attack messages, etc
	var/enemy_action = ""
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set
	var/turtle = 0

/obj/machinery/computer/arcade/battle/Initialize()
	. = ..()
	randomize_characters()

/obj/machinery/computer/arcade/battle/proc/randomize_characters()
	var/name_action
	var/name_part1
	var/name_part2

	name_action = pick("Defeat ", "Annihilate ", "Save ", "Strike ", "Stop ", "Destroy ", "Robust ", "Romance ", "Pwn ", "Own ", "Ban ")

	name_part1 = pick("the Automatic ", "Farmer ", "Lord ", "Professor ", "the Cuban ", "the Evil ", "the Dread King ", "the Space ", "Lord ", "the Great ", "Duke ", "General ")
	name_part2 = pick("Melonoid", "Murdertron", "Sorcerer", "Ruin", "Jeff", "Ectoplasm", "Crushulon", "Uhangoid", "Vhakoid", "Peteoid", "slime", "Griefer", "ERPer", "Lizard Man", "Unicorn", "Bloopers")

	enemy_name = replacetext((name_part1 + name_part2), "the ", "")
	name = (name_action + name_part1 + name_part2)


/obj/machinery/computer/arcade/battle/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	tgui_interact(user)

/obj/machinery/computer/arcade/battle/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ArcadeBattle", name)
		ui.open()

/obj/machinery/computer/arcade/battle/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["name"] = name
	data["temp"] = temp
	data["enemyAction"] = enemy_action
	data["enemyName"] = enemy_name
	data["playerHP"] = player_hp
	data["playerMP"] = player_mp
	data["enemyHP"] = enemy_hp
	data["gameOver"] = gameover
	return data

/obj/machinery/computer/arcade/battle/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(!blocked && !gameover)
		switch(action)
			if("attack")
				blocked = 1
				var/attackamt = rand(2,6)
				temp = "You attack for [attackamt] damage!"
				playsound(src, 'sound/arcade/hit.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
				if(turtle > 0)
					turtle--

				sleep(10)
				enemy_hp -= attackamt
				arcade_action()

			if("heal")
				blocked = 1
				var/pointamt = rand(1,3)
				var/healamt = rand(6,8)
				temp = "You use [pointamt] magic to heal for [healamt] damage!"
				playsound(src, 'sound/arcade/heal.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
				turtle++

				sleep(10)
				player_mp -= pointamt
				player_hp += healamt
				blocked = 1
				arcade_action()

			if("charge")
				blocked = 1
				var/chargeamt = rand(4,7)
				temp = "You regain [chargeamt] points"
				playsound(src, 'sound/arcade/mana.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
				player_mp += chargeamt
				if(turtle > 0)
					turtle--

				sleep(10)
				arcade_action()


	if(action == "newgame") //Reset everything
		temp = "New Round"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		turtle = 0

		if(emagged)
			randomize_characters()
			emagged = 0

	add_fingerprint(usr)
	return TRUE

/obj/machinery/computer/arcade/battle/proc/arcade_action()
	if ((enemy_mp <= 0) || (enemy_hp <= 0))
		if(!gameover)
			gameover = 1
			temp = "[enemy_name] has fallen! Rejoice!"
			playsound(src, 'sound/arcade/win.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)

			if(emagged)
				feedback_inc("arcade_win_emagged")
				new /obj/effect/spawner/newbomb/timer/syndicate(src.loc)
				new /obj/item/clothing/head/collectable/petehat(src.loc)
				message_admins("[key_name_admin(usr)] has outbombed Cuban Pete and been awarded a bomb.")
				log_game("[key_name_admin(usr)] has outbombed Cuban Pete and been awarded a bomb.")
				randomize_characters()
				emagged = 0
			else if(!contents.len)
				feedback_inc("arcade_win_normal")
				prizevend()

			else
				feedback_inc("arcade_win_normal")
				prizevend()

	else if (emagged && (turtle >= 4))
		var/boomamt = rand(5,10)
		enemy_action = "[enemy_name] throws a bomb, exploding you for [boomamt] damage!"
		playsound(src, 'sound/arcade/boom.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		player_hp -= boomamt

	else if ((enemy_mp <= 5) && (prob(70)))
		var/stealamt = rand(2,3)
		enemy_action = "[enemy_name] steals [stealamt] of your power!"
		playsound(src, 'sound/arcade/steal.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		player_mp -= stealamt

		if (player_mp <= 0)
			gameover = 1
			sleep(10)
			temp = "You have been drained! GAME OVER"
			if(emagged)
				feedback_inc("arcade_loss_mana_emagged")
				usr.gib()
			else
				feedback_inc("arcade_loss_mana_normal")

	else if ((enemy_hp <= 10) && (enemy_mp > 4))
		enemy_action = "[enemy_name] heals for 4 health!"
		playsound(src, 'sound/arcade/heal.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		enemy_hp += 4
		enemy_mp -= 4

	else
		var/attackamt = rand(3,6)
		enemy_action = "[enemy_name] attacks for [attackamt] damage!"
		playsound(src, 'sound/arcade/hit.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		player_hp -= attackamt

	if ((player_mp <= 0) || (player_hp <= 0))
		gameover = 1
		temp = "You have been crushed! GAME OVER"
		playsound(src, 'sound/arcade/lose.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		if(emagged)
			feedback_inc("arcade_loss_hp_emagged")
			usr.gib()
		else
			feedback_inc("arcade_loss_hp_normal")

	blocked = 0
	return


/obj/machinery/computer/arcade/battle/emag_act(var/charges, var/mob/user)
	if(!emagged)
		to_chat(user, span("notice","You override the cheat code menu and skip to Cheat #[rand(1, 50)]: Hyper-Lethal Mode."))

		temp = "If you die in the game, you die for real!"
		player_hp = 30
		player_mp = 10
		enemy_hp = 45
		enemy_mp = 20
		gameover = 0
		blocked = 0
		emagged = 1

		enemy_name = "Cuban Pete"
		name = "Outbomb Cuban Pete"

		return 1


//////////////////////////
//   ORION TRAIL HERE   //
//////////////////////////
#define ORION_TRAIL_WINTURN		9

//Orion Trail Events
#define ORION_TRAIL_RAIDERS		"Raiders"
#define ORION_TRAIL_FLUX		"Interstellar Flux"
#define ORION_TRAIL_ILLNESS		"Illness"
#define ORION_TRAIL_BREAKDOWN	"Breakdown"
#define ORION_TRAIL_MUTINY		"Mutiny?"
#define ORION_TRAIL_MUTINY_ATTACK "Mutinous Ambush"
#define ORION_TRAIL_MALFUNCTION	"Malfunction"
#define ORION_TRAIL_COLLISION	"Collision"
#define ORION_TRAIL_SPACEPORT	"Spaceport"
#define ORION_TRAIL_BLACKHOLE	"BlackHole"

#define ORION_STATUS_START		1
#define ORION_STATUS_NORMAL		2
#define ORION_STATUS_GAMEOVER	3
#define ORION_STATUS_MARKET		4

/obj/machinery/computer/arcade/orion_trail
	name = "The Orion Trail"
	desc = "Learn how our ancestors got to Orion, and have fun in the process!"
	icon_state = "arcade1"
	icon_screen = "orion"
	circuit = /obj/item/circuitboard/arcade/orion_trail
	var/busy = 0 //prevent clickspam that allowed people to ~speedrun~ the game.
	var/engine = 0
	var/hull = 0
	var/electronics = 0
	var/food = 80
	var/fuel = 60
	var/turns = 4
	var/alive = 4
	var/eventdat = null
	var/event = null
	var/list/settlers = list("Harry","Larry","Bob")
	var/list/events = list(ORION_TRAIL_RAIDERS		= 3,
						   ORION_TRAIL_FLUX			= 1,
						   ORION_TRAIL_ILLNESS		= 3,
						   ORION_TRAIL_BREAKDOWN	= 2,
						   ORION_TRAIL_MUTINY		= 3,
						   ORION_TRAIL_MALFUNCTION	= 2,
						   ORION_TRAIL_COLLISION	= 1,
						   ORION_TRAIL_SPACEPORT	= 2
						   )
	var/list/stops = list()
	var/list/stopblurbs = list()
	var/traitors_aboard = 0
	var/spaceport_raided = 0
	var/spaceport_freebie = 0
	var/last_spaceport_action = ""
	var/gameStatus = ORION_STATUS_START
	var/canContinueEvent = 0

/obj/machinery/computer/arcade/orion_trail/Initialize()
	. = ..()
	// Sets up the main trail
	stops = list("Pluto","Asteroid Belt","Proxima Centauri","Dead Space","Rigel Prime","Tau Ceti Beta","Black Hole","Space Outpost Beta-9","Orion Prime")
	stopblurbs = list(
		"Pluto, long since occupied with long-range sensors and scanners, stands ready to, and indeed continues to probe the far reaches of the galaxy.",
		"At the edge of the Sol system lies a treacherous asteroid belt. Many have been crushed by stray asteroids and misguided judgement.",
		"The nearest star system to Sol, in ages past it stood as a reminder of the boundaries of sub-light travel, now a low-population sanctuary for adventurers and traders.",
		"This region of space is particularly devoid of matter. Such low-density pockets are known to exist, but the vastness of it is astounding.",
		"Rigel Prime, the center of the Rigel system, burns hot, basking its planetary bodies in warmth and radiation.",
		"Tau Ceti Beta has recently become a waypoint for colonists headed towards Orion. There are many ships and makeshift stations in the vicinity.",
		"Sensors indicate that a black hole's gravitational field is affecting the region of space we were headed through. We could stay of course, but risk of being overcome by its gravity, or we could change course to go around, which will take longer.",
		"You have come into range of the first man-made structure in this region of space. It has been constructed not by travellers from Sol, but by colonists from Orion. It stands as a monument to the colonists' success.",
		"You have made it to Orion! Congratulations! Your crew is one of the few to start a new foothold for mankind!"
		)

/obj/machinery/computer/arcade/orion_trail/proc/newgame()
	// Set names of settlers in crew
	settlers = list()
	for(var/i = 1; i <= 3; i++)
		add_crewmember()
	add_crewmember("[usr]")
	// Re-set items to defaults
	engine = 1
	hull = 1
	electronics = 1
	food = 80
	fuel = 60
	alive = 4
	turns = 1
	event = null
	gameStatus = ORION_STATUS_NORMAL
	traitors_aboard = 0

	//spaceport junk
	spaceport_raided = 0
	spaceport_freebie = 0
	last_spaceport_action = ""

/obj/machinery/computer/arcade/orion_trail/attack_hand(mob/living/user)
	if(..())
		return
	if(fuel <= 0 || food <=0 || settlers.len == 0)
		gameStatus = ORION_STATUS_GAMEOVER
		event = null
	user.set_machine(src)
	var/dat = ""
	if(gameStatus == ORION_STATUS_GAMEOVER)
		playsound(src, 'sound/arcade/Ori_fail.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		dat = "<center><h1>Game Over</h1></center>"
		dat += "Like many before you, your crew never made it to Orion, lost to space... <br><b>forever</b>."
		if(settlers.len == 0)
			dat += "<br>Your entire crew died, and your ship joins the fleet of ghost-ships littering the galaxy."
		else
			if(food <= 0)
				dat += "<br>You ran out of food and starved."
				if(emagged)
					user.nutrition = 0 //yeah you pretty hongry
					to_chat(user, span("danger", "<font size=3>Your body instantly contracts to that of one who has not eaten in months. Agonizing cramps seize you as you fall to the floor.</font>"))
			if(fuel <= 0)
				dat += "<br>You ran out of fuel, and drift, slowly, into a star."
				if(emagged)
					var/mob/living/M = user
					M.adjust_fire_stacks(5)
					M.IgniteMob() //flew into a star, so you're on fire
					to_chat(user,span("danger", "<font size=3>You feel an immense wave of heat emanate from \the [src]. Your skin bursts into flames.</font>"))
		dat += "<br><P ALIGN=Right><a href='byond://?src=\ref[src];menu=1'>OK...</a></P>"

		if(emagged)
			to_chat(user, span("danger", "<font size=3>You're never going to make it to Orion...</font>"))
			user.death()
			emagged = 0 //removes the emagged status after you lose
			gameStatus = ORION_STATUS_START
			name = "The Orion Trail"
			desc = "Learn how our ancestors got to Orion, and have fun in the process!"

	else if(event)
		dat = eventdat
	else if(gameStatus == ORION_STATUS_NORMAL)
		var/title = stops[turns]
		var/subtext = stopblurbs[turns]
		dat = "<center><h1>[title]</h1></center>"
		dat += "[subtext]"
		dat += "<h3><b>Crew:</b></h3>"
		dat += english_list(settlers)
		dat += "<br><b>Food: </b>[food] | <b>Fuel: </b>[fuel]"
		dat += "<br><b>Engine Parts: </b>[engine] | <b>Hull Panels: </b>[hull] | <b>Electronics: </b>[electronics]"
		if(turns == 7)
			dat += "<P ALIGN=Right><a href='byond://?src=\ref[src];pastblack=1'>Go Around</a> <a href='byond://?src=\ref[src];blackhole=1'>Continue</a></P>"
		else
			dat += "<P ALIGN=Right><a href='byond://?src=\ref[src];continue=1'>Continue</a></P>"
		dat += "<P ALIGN=Right><a href='byond://?src=\ref[src];killcrew=1'>Kill a crewmember</a></P>"
		dat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
	else
		dat = "<center><h2>The Orion Trail</h2></center>"
		dat += "<br><center><h3>Experience the journey of your ancestors!</h3></center><br><br>"
		dat += "<center><b><a href='byond://?src=\ref[src];newgame=1'>New Game</a></b></center>"
		dat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
	user << browse(dat,"window=arcade")
	return

/obj/machinery/computer/arcade/orion_trail/Topic(href, href_list)
	if(..())
		return
	if(href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=arcade")

	if(busy)
		return
	busy = 1

	if (href_list["continue"]) //Continue your travels
		if(gameStatus == ORION_STATUS_NORMAL && !event && turns != 7)
			if(turns >= ORION_TRAIL_WINTURN)
				win()
			else
				food -= (alive+traitors_aboard)*2
				fuel -= 5
				if(turns == 2 && prob(30))
					event = ORION_TRAIL_COLLISION
					event()
				else if(prob(75))
					event = pickweight(events)
					if(traitors_aboard)
						if(event == ORION_TRAIL_MUTINY || prob(55))
							event = ORION_TRAIL_MUTINY_ATTACK
					event()
				turns += 1
			if(emagged)
				var/mob/living/carbon/M = usr //for some vars
				switch(event)
					if(ORION_TRAIL_RAIDERS)
						if(prob(50))
							to_chat(usr, span("warning", "You hear battle shouts. The tramping of boots on cold metal. Screams of agony. The rush of venting air. Are you going insane?"))
							M.hallucination += 30
						else
							to_chat(usr, span("danger", "Something strikes you from behind! It hurts like hell and feel like a blunt weapon, but nothing is there..."))
							M.take_organ_damage(25)
					if(ORION_TRAIL_ILLNESS)
						var/severity = rand(1,3) //pray to RNGesus. PRAY, PIGS
						if(severity == 1)
							to_chat(M, span("warning", "You suddenly feel slightly nauseous.")) //got off lucky
						if(severity == 2)
							to_chat(usr, span("warning", "You suddenly feel extremely nauseous and hunch over until it passes."))
							M.Stun(3)
						if(severity >= 3) //you didn't pray hard enough
							to_chat(M, span("warning", "An overpowering wave of nausea consumes over you. You hunch over, your stomach's contents preparing for a spectacular exit."))
							spawn(30)
							if(istype(M,/mob/living/carbon/human))
								var/mob/living/carbon/human/H = M
								H.vomit()
					if(ORION_TRAIL_FLUX)
						if(prob(75))
							M.Weaken(3)
							src.visible_message("A sudden gust of powerful wind slams \the [M] into the floor!", "You hear a large fwooshing sound, followed by a bang.")
							M.take_organ_damage(15)
						else
							to_chat(M, span("warning", "A violent gale blows past you, and you barely manage to stay standing!"))
					if(ORION_TRAIL_COLLISION) //by far the most damaging event
						if(prob(90) && !hull)
							var/turf/simulated/floor/F = src.loc
							F.ChangeTurf(/turf/space)
							src.visible_message(span("danger", "Something slams into the floor around \the [src], exposing it to space!"), "You hear something crack and break.")
						else
							src.visible_message("Something slams into the floor around \the [src] - luckily, it didn't get through!", "You hear something crack.")
					if(ORION_TRAIL_MALFUNCTION)
						src.visible_message("\The [src] buzzes and the screen goes blank for a moment before returning to the game.")
						var/oldfood = food
						var/oldfuel = fuel
						food = rand(10,80) / rand(1,2)
						fuel = rand(10,60) / rand(1,2)
						if(electronics)
							sleep(10)
							if(oldfuel > fuel && oldfood > food)
								src.audible_message("\The [src] lets out a somehow reassuring chime.", runemessage = "reassuring chime")
							else if(oldfuel < fuel || oldfood < food)
								src.audible_message("\The [src] lets out a somehow ominous chime.", runemessage = "ominous chime")
							food = oldfood
							fuel = oldfuel

	else if(href_list["newgame"]) //Reset everything
		if(gameStatus == ORION_STATUS_START)
			playsound(src, 'sound/arcade/Ori_begin.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
			newgame()
	else if(href_list["menu"]) //back to the main menu
		if(gameStatus == ORION_STATUS_GAMEOVER)
			gameStatus = ORION_STATUS_START
			event = null
			food = 80
			fuel = 60
			settlers = list("Harry","Larry","Bob")
	else if(href_list["slow"]) //slow down
		if(event == ORION_TRAIL_FLUX)
			food -= (alive+traitors_aboard)*2
			fuel -= 5
		event = null
	else if(href_list["pastblack"]) //slow down
		if(turns == 7)
			food -= ((alive+traitors_aboard)*2)*3
			fuel -= 15
			turns += 1
			event = null
	else if(href_list["useengine"]) //use parts
		if(event == ORION_TRAIL_BREAKDOWN)
			engine = max(0, --engine)
			event = null
	else if(href_list["useelec"]) //use parts
		if(event == ORION_TRAIL_MALFUNCTION)
			electronics = max(0, --electronics)
			event = null
	else if(href_list["usehull"]) //use parts
		if(event == ORION_TRAIL_COLLISION)
			hull = max(0, --hull)
			event = null
	else if(href_list["wait"]) //wait 3 days
		if(event == ORION_TRAIL_BREAKDOWN || event == ORION_TRAIL_MALFUNCTION || event == ORION_TRAIL_COLLISION)
			food -= ((alive+traitors_aboard)*2)*3
			event = null
	else if(href_list["keepspeed"]) //keep speed
		if(event == ORION_TRAIL_FLUX)
			if(prob(75))
				event = "Breakdown"
				event()
			else
				event = null
	else if(href_list["blackhole"]) //keep speed past a black hole
		if(turns == 7)
			if(prob(75))
				event = ORION_TRAIL_BLACKHOLE
				event()
				if(emagged) //has to be here because otherwise it doesn't work
					src.show_message("\The [src] states, 'YOU ARE EXPERIENCING A BLACKHOLE. BE TERRIFIED.","You hear something say, 'YOU ARE EXPERIENCING A BLACKHOLE. BE TERRFIED'")
					to_chat(usr, span("warning", "Something draws you closer and closer to the machine."))
					sleep(10)
					to_chat(usr, span("danger", "This is really starting to hurt!"))
					var i; //spawning a literal blackhole would be fun, but a bit disruptive.
					for(i=0;i<4;i++)
						var/mob/living/L = usr
						if(istype(L))
							L.adjustBruteLoss(25)
						sleep(10)
			else
				event = null
				turns += 1
	else if(href_list["holedeath"])
		if(event == ORION_TRAIL_BLACKHOLE)
			gameStatus = ORION_STATUS_GAMEOVER
			event = null
	else if(href_list["eventclose"]) //end an event
		if(canContinueEvent)
			event = null

	else if(href_list["killcrew"]) //shoot a crewmember
		if(gameStatus == ORION_STATUS_NORMAL || event == ORION_TRAIL_MUTINY)
			playsound(src, 'sound/arcade/kill_crew.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
			var/sheriff = remove_crewmember() //I shot the sheriff
			var/mob/living/L = usr
			if(!istype(L))
				return
			if(settlers.len == 0 || alive == 0)
				src.visible_message("\The [src] states, 'EVERYONE HAS DIED, GAMEOVER.'", "You hear something state, 'EVERYONE HAS DIED, GAMEOVER.'")
				if(emagged)
					src.visible_message("\The [src] produces a loud, gunlike sound.")
					L.adjustBruteLoss(30)
					emagged = 0
				gameStatus = ORION_STATUS_GAMEOVER
				event = null
			else if(emagged)
				if(usr.name == sheriff)
					src.visible_message("\The [src] states, 'THE CREW HAS CHOSEN TO KILL [usr]'. A gunshot can be heard coming from \the [src]", "You hear 'THE CREW HAS CHOSEN TO KILL [usr]' followed by a gunshot")
					L.adjustBruteLoss(30)
			if(event == ORION_TRAIL_MUTINY) //only ends the ORION_TRAIL_MUTINY event, since you can do this action in multiple places
				event = null

	//Spaceport specific interactions
	//they get a header because most of them don't reset event (because it's a shop, you leave when you want to)
	//they also call event() again, to regen the eventdata, which is kind of odd but necessary
	else if(href_list["buycrew"]) //buy a crewmember
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided && food >= 10 && fuel >= 10)
				playsound(src, 'sound/arcade/get_fuel.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
				var/bought = add_crewmember()
				last_spaceport_action = "You hired [bought] as a new crewmember."
				fuel -= 10
				food -= 10
				event()

	else if(href_list["sellcrew"]) //sell a crewmember
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided && settlers.len > 1)
				playsound(src, 'sound/arcade/lose_fuel.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
				var/sold = remove_crewmember()
				last_spaceport_action = "You sold your crewmember, [sold]!"
				fuel += 7
				food += 7
				event()

	else if(href_list["leave_spaceport"])
		if(gameStatus == ORION_STATUS_MARKET)
			event = null
			gameStatus = ORION_STATUS_NORMAL
			spaceport_raided = 0
			spaceport_freebie = 0
			last_spaceport_action = ""

	else if(href_list["raid_spaceport"])
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided)
				playsound(src, 'sound/arcade/raid.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
				var/success = min(15 * alive,100) //default crew (4) have a 60% chance
				spaceport_raided = 1

				var/FU = 0
				var/FO = 0
				if(prob(success))
					FU = rand(5,15)
					FO = rand(5,15)
					last_spaceport_action = "You successfully raided the spaceport! You gained [FU] Fuel and [FO] Food! (+[FU]FU,+[FO]FO)"
				else
					FU = rand(-5,-15)
					FO = rand(-5,-15)
					last_spaceport_action = "You failed to raid the spaceport! You lost [FU*-1] Fuel and [FO*-1] Food in your scramble to escape! ([FU]FU,[FO]FO)"

					//your chance of lose a crewmember is 1/2 your chance of success
					//this makes higher % failures hurt more, don't get cocky space cowboy!
					if(prob(success*5))
						var/lost_crew = remove_crewmember()
						last_spaceport_action = "You failed to raid the spaceport! You lost [FU*-1] Fuel and [FO*-1] Food, AND [lost_crew] in your scramble to escape! ([FU]FI,[FO]FO,-Crew)"
						if(emagged)
							src.visible_message("The machine states, 'YOU ARE UNDER ARREST, RAIDER!' and shoots handcuffs onto [usr]!", "You hear something say 'YOU ARE UNDER ARREST, RAIDER!' and a clinking sound")
							var/obj/item/handcuffs/C = new(src.loc)
							var/mob/living/carbon/human/H = usr
							if(istype(H))
								C.forceMove(H)
								H.handcuffed = C
								H.update_handcuffed()
							else
								C.throw_at(usr,16,3,src)


				fuel += FU
				food += FO
				event()

	else if(href_list["buyparts"])
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided && fuel > 5)
				playsound(src, 'sound/arcade/get_fuel.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
				switch(text2num(href_list["buyparts"]))
					if(1) //Engine Parts
						engine++
						last_spaceport_action = "Bought Engine Parts"
					if(2) //Hull Plates
						hull++
						last_spaceport_action = "Bought Hull Plates"
					if(3) //Spare Electronics
						electronics++
						last_spaceport_action = "Bought Spare Electronics"
				fuel -= 5 //they all cost 5
				event()

	else if(href_list["trade"])
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided)
				playsound(src, 'sound/arcade/get_fuel.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
				switch(text2num(href_list["trade"]))
					if(1) //Fuel
						if(fuel > 5)
							fuel -= 5
							food += 5
							last_spaceport_action = "Traded Fuel for Food"
							event()
					if(2) //Food
						if(food > 5)
							fuel += 5
							food -= 5
							last_spaceport_action = "Traded Food for Fuel"
							event()

	src.add_fingerprint(usr)
	src.updateUsrDialog()
	busy = 0
	return


/obj/machinery/computer/arcade/orion_trail/proc/event()
	eventdat = "<center><h1>[event]</h1></center>"
	canContinueEvent = 0
	switch(event)
		if(ORION_TRAIL_RAIDERS)
			eventdat += "Raiders have come aboard your ship!"
			if(prob(50))
				var/sfood = rand(1,10)
				var/sfuel = rand(1,10)
				food -= sfood
				fuel -= sfuel
				eventdat += "<br>They have stolen [sfood] <b>Food</b> and [sfuel] <b>Fuel</b>."
			else if(prob(10))
				var/deadname = remove_crewmember()
				eventdat += "<br>[deadname] tried to fight back, but was killed."
			else
				eventdat += "<br>Fortunately, you fended them off without any trouble."
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];eventclose=1'>Continue</a></P>"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
			canContinueEvent = 1

		if(ORION_TRAIL_FLUX)
			playsound(src, 'sound/arcade/explo.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
			eventdat += "This region of space is highly turbulent. <br>If we go slowly we may avoid more damage, but if we keep our speed we won't waste supplies."
			eventdat += "<br>What will you do?"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];slow=1'>Slow Down</a> <a href='byond://?src=\ref[src];keepspeed=1'>Continue</a></P>"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"

		if(ORION_TRAIL_ILLNESS)
			eventdat += "A deadly illness has been contracted!"
			var/deadname = remove_crewmember()
			eventdat += "<br>[deadname] was killed by the disease."
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];eventclose=1'>Continue</a></P>"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
			canContinueEvent = 1

		if(ORION_TRAIL_BREAKDOWN)
			playsound(src, 'sound/arcade/explo.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
			eventdat += "Oh no! The engine has broken down!"
			eventdat += "<br>You can repair it with an engine part, or you can make repairs for 3 days."
			if(engine >= 1)
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];useengine=1'>Use Part</a> <a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
			else
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"

		if(ORION_TRAIL_MALFUNCTION)
			eventdat += "The ship's systems are malfunctioning!"
			eventdat += "<br>You can replace the broken electronics with spares, or you can spend 3 days troubleshooting the AI."
			if(electronics >= 1)
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];useelec=1'>Use Part</a> <a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
			else
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"

		if(ORION_TRAIL_COLLISION)
			playsound(src, 'sound/arcade/explo.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
			eventdat += "Something hit us! Looks like there's some hull damage."
			if(prob(25))
				var/sfood = rand(5,15)
				var/sfuel = rand(5,15)
				food -= sfood
				fuel -= sfuel
				eventdat += "<br>[sfood] <b>Food</b> and [sfuel] <b>Fuel</b> was vented out into space."
			if(prob(10))
				var/deadname = remove_crewmember()
				eventdat += "<br>[deadname] was killed by rapid depressurization."
			eventdat += "<br>You can repair the damage with hull plates, or you can spend the next 3 days welding scrap together."
			if(hull >= 1)
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];usehull=1'>Use Part</a> <a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
			else
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];wait=1'>Wait</a></P>"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"

		if(ORION_TRAIL_BLACKHOLE)
			eventdat += "You were swept away into the black hole."
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];holedeath=1'>Oh...</a></P>"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
			settlers = list()

		if(ORION_TRAIL_MUTINY)
			eventdat += "You've been hearing rumors of dissenting opinions amoungst your men."
			if(settlers.len <= 2)
				eventdat += "<br>Your crew's so tiny you don't think anybody would risk an uprising."
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];eventclose=1'>Continue</a></P>"
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
				if(prob(10))
					traitors_aboard = min(++traitors_aboard,2)
			else
				if(traitors_aboard) //less likely to stack traitors
					if(prob(20))
						traitors_aboard = min(++traitors_aboard,2)
				else if(prob(70))
					traitors_aboard = min(++traitors_aboard,2)

				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];killcrew=1'>Kill a crewmember</a></P>"
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];eventclose=1'>Risk it</a></P>"
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
			canContinueEvent = 1

		if(ORION_TRAIL_MUTINY_ATTACK)
			if(traitors_aboard <= 0) //shouldn't trigger, but hey.
				eventdat += "Haha, fooled you, there isn't a mutiny on board!"
				eventdat += "<br>(You should report this to a coder :S)"
			else
				var/trait1 = remove_crewmember()
				var/trait2 = ""
				if(traitors_aboard >= 2)
					trait2 = remove_crewmember()

				eventdat += "Oh no, some of your crew are attempting to mutiny!!"
				if(trait2)
					eventdat += "<br>[trait1] and [trait2]'s have armed themselves with weapons!"
				else
					eventdat += "<br>[trait1]'s armed with a weapon!"

				var/chance2attack = alive*20
				if(prob(chance2attack))
					var/chancetokill = 30*traitors_aboard-(5*alive) //eg: 30*2-(10) = 50%, 2 traitorss, 2 crew is 50% chance
					if(prob(chancetokill))
						var/deadguy = remove_crewmember()
						eventdat += "<br>The traitor[trait2 ? "s":""] run[trait2 ? "":"s"] up to [deadguy] and murder[trait2 ? "" : "s"] them!"
					else
						eventdat += "<br>You valiantly fight off the traitor[trait2 ? "s":""]!"
						eventdat += "<br>You cut the traitor[trait2 ? "s":""] up into meat... Eww"
						if(trait2)
							food += 30
							traitors_aboard = max(0,traitors_aboard-2)
						else
							food += 15
							traitors_aboard = max(0,--traitors_aboard)
				else
					eventdat += "<br>The traitor[trait2 ? "s":""] run[trait2 ? "":"s"] away, What wimps!"
					if(trait2)
						traitors_aboard = max(0,traitors_aboard-2)
					else
						traitors_aboard = max(0,--traitors_aboard)

			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];eventclose=1'>Continue</a></P>"
			eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
			canContinueEvent = 1


		if(ORION_TRAIL_SPACEPORT)
			gameStatus = ORION_STATUS_MARKET
			if(spaceport_raided)
				eventdat += "The Spaceport is on high alert! they wont let you dock since you tried to attack them!"
				if(last_spaceport_action)
					eventdat += "<br>Last Spaceport Action: [last_spaceport_action]"
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];leave_spaceport=1'>Depart Spaceport</a></P>"
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];close=1'>Close</a></P>"
			else
				eventdat += "You pull the ship up to dock at a nearby Spaceport, lucky find!"
				eventdat += "<br>This Spaceport is home to travellers who failed to reach Orion, but managed to find a different home..."
				eventdat += "<br>Trading terms: FU = Fuel, FO = Food"
				if(last_spaceport_action)
					eventdat += "<br>Last Spaceport Action: [last_spaceport_action]"
				eventdat += "<h3><b>Crew:</b></h3>"
				eventdat += english_list(settlers)
				eventdat += "<br><b>Food: </b>[food] | <b>Fuel: </b>[fuel]"
				eventdat += "<br><b>Engine Parts: </b>[engine] | <b>Hull Panels: </b>[hull] | <b>Electronics: </b>[electronics]"


				//If your crew is pathetic you can get freebies (provided you haven't already gotten one from this port)
				if(!spaceport_freebie && (fuel < 20 || food < 20))
					spaceport_freebie++
					var/FU = 10
					var/FO = 10
					var/freecrew = 0
					if(prob(30))
						FU = 25
						FO = 25

					if(prob(10))
						add_crewmember()
						freecrew++

					eventdat += "<br>The traders of the spaceport take pity on you, and give you some supplies. (+[FU]FU,+[FO]FO)"
					if(freecrew)
						eventdat += "<br>You also gain a new crewmember!"

					fuel += FU
					food += FO

				//CREW INTERACTIONS
				eventdat += "<P ALIGN=Right>Crew Management:</P>"

				//Buy crew
				if(food >= 10 && fuel >= 10)
					eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];buycrew=1'>Hire a new Crewmember (-10FU,-10FO)</a></P>"
				else
					eventdat += "<P ALIGN=Right>You cannot afford a new Crewmember</P>"

				//Sell crew
				if(settlers.len > 1)
					eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];sellcrew=1'>Sell crew for Fuel and Food (+7FU,+7FO)</a></P>"
				else
					eventdat += "<P ALIGN=Right>You cannot afford to sell a Crewmember</P>"

				//BUY/SELL STUFF
				eventdat += "<P ALIGN=Right>Spare Parts:</P>"

				//Engine parts
				if(fuel > 5)
					eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];buyparts=1'>Buy Engine Parts (-5FU)</a></P>"
				else
					eventdat += "<P ALIGN=Right>You cannot afford to buy Engine Parts</a>"

				//Hull plates
				if(fuel > 5)
					eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];buyparts=2'>Buy Hull Plates (-5FU)</a></P>"
				else
					eventdat += "<P ALIGN=Right>You cannot afford to buy Hull Plates</a>"

				//Electronics
				if(fuel > 5)
					eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];buyparts=3'>Buy Spare Electronics (-5FU)</a></P>"
				else
					eventdat += "<P ALIGN=Right>You cannot afford to buy Spare Electronics</a>"

				//Trade
				if(fuel > 5)
					eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];trade=1'>Trade Fuel for Food (-5FU,+5FO)</a></P>"
				else
					eventdat += "<P ALIGN=Right>You cannot afford to Trade Fuel for Food</P"

				if(food > 5)
					eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];trade=2'>Trade Food for Fuel (+5FU,-5FO)</a></P>"
				else
					eventdat += "<P ALIGN=Right>You cannot afford to Trade Food for Fuel</P"

				//Raid the spaceport
				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];raid_spaceport=1'>!! Raid Spaceport !!</a></P>"

				eventdat += "<P ALIGN=Right><a href='byond://?src=\ref[src];leave_spaceport=1'>Depart Spaceport</a></P>"


/obj/machinery/computer/arcade/orion_trail/proc/add_crewmember(var/specific = "")
	var/newcrew = ""
	if(specific)
		newcrew = specific
	else
		if(prob(50))
			newcrew = pick(first_names_male)
		else
			newcrew = pick(first_names_female)
	if(newcrew)
		settlers += newcrew
		alive++
	return newcrew

/obj/machinery/computer/arcade/orion_trail/proc/remove_crewmember(var/specific = "", var/dont_remove = "")
	var/list/safe2remove = settlers
	var/removed = ""
	if(dont_remove)
		safe2remove -= dont_remove
	if(specific && specific != dont_remove)
		safe2remove = list(specific)
	else
		removed = pick(safe2remove)

	if(removed)
		if(traitors_aboard && prob(40*traitors_aboard)) //if there are 2 traitors you're twice as likely to get one, obviously
			traitors_aboard = max(0,--traitors_aboard)
		settlers -= removed
		alive--
	return removed


/obj/machinery/computer/arcade/orion_trail/proc/win()
	gameStatus = ORION_STATUS_START
	src.visible_message("\The [src] plays a triumpant tune, stating 'CONGRATULATIONS, YOU HAVE MADE IT TO ORION.'")
	playsound(src, 'sound/arcade/Ori_win.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
	if(emagged)
		new /obj/item/orion_ship(src.loc)
		message_admins("[key_name_admin(usr)] made it to Orion on an emagged machine and got an explosive toy ship.")
		log_game("[key_name(usr)] made it to Orion on an emagged machine and got an explosive toy ship.")
	else
		prizevend()
	emagged = 0
	name = "The Orion Trail"
	desc = "Learn how our ancestors got to Orion, and have fun in the process!"

/obj/machinery/computer/arcade/orion_trail/emag_act(mob/user)
	if(!emagged)
		to_chat(user, span("notice", "You override the cheat code menu and skip to Cheat #[rand(1, 50)]: Realism Mode."))
		name = "The Orion Trail: Realism Edition"
		desc = "Learn how our ancestors got to Orion, and try not to die in the process!"
		newgame()
		emagged = 1
		return 1

/obj/item/orion_ship
	name = "model settler ship"
	desc = "A model spaceship, it looks like those used back in the day when travelling to Orion! It even has a miniature FX-293 reactor, which was renowned for its instability and tendency to explode..."
	icon = 'icons/obj/toy.dmi'
	icon_state = "ship"
	w_class = ITEMSIZE_SMALL
	var/active = 0 //if the ship is on

/obj/item/orion_ship/examine(mob/user)
	. = ..()
	if(in_range(user, src))
		if(!active)
			. += span("notice", "There's a little switch on the bottom. It's flipped down.")
		else
			. += span("notice", "There's a little switch on the bottom. It's flipped up.")

/obj/item/orion_ship/attack_self(mob/user)
	if(active)
		return

	message_admins("[key_name_admin(usr)] primed an explosive Orion ship for detonation.")
	log_game("[key_name(usr)] primed an explosive Orion ship for detonation.")

	to_chat(user, span("warning", "You flip the switch on the underside of [src]."))
	active = 1
	src.visible_message(span("notice", "[src] softly beeps and whirs to life!"))
	src.audible_message("<b>\The [src]</b> says, 'This is ship ID #[rand(1,1000)] to Orion Port Authority. We're coming in for landing, over.'")
	sleep(20)
	src.visible_message(span("warning", "[src] begins to vibrate..."))
	src.audible_message("<b>\The [src]</b> says, 'Uh, Port? Having some issues with our reactor, could you check it out? Over.'")
	sleep(30)
	src.audible_message("<b>\The [src]</b> says, 'Oh, God! Code Eight! CODE EIGHT! IT'S GONNA BL-'")
	sleep(3.6)
	src.visible_message(span("danger", "[src] explodes!"))
	explosion(src.loc, 1,2,4)
	qdel(src)

#undef ORION_TRAIL_WINTURN
#undef ORION_TRAIL_RAIDERS
#undef ORION_TRAIL_FLUX
#undef ORION_TRAIL_ILLNESS
#undef ORION_TRAIL_BREAKDOWN
#undef ORION_TRAIL_MUTINY
#undef ORION_TRAIL_MUTINY_ATTACK
#undef ORION_TRAIL_MALFUNCTION
#undef ORION_TRAIL_COLLISION
#undef ORION_TRAIL_SPACEPORT
#undef ORION_TRAIL_BLACKHOLE

#undef ORION_STATUS_START
#undef ORION_STATUS_NORMAL
#undef ORION_STATUS_GAMEOVER
#undef ORION_STATUS_MARKET

//////////////////
// Claw Machine //
//////////////////

/obj/machinery/computer/arcade/clawmachine
	name = "AlliCo Grab-a-Gift"
	desc = "Show off your arcade skills for that special someone!"
	icon_state = "clawmachine_new"
	icon_keyboard = null
	icon_screen = null
	circuit = /obj/item/circuitboard/arcade/clawmachine
	prizes = list(/obj/random/plushie)
	var/wintick = 0
	var/winprob = 0
	var/instructions = "Insert 1 thaler or swipe a card to play!"
	var/gameStatus = "CLAWMACHINE_NEW"
	var/gamepaid = 0
	var/gameprice = 1
	var/winscreen = ""

/// Payment
/obj/machinery/computer/arcade/clawmachine/attackby(obj/item/I as obj, mob/user as mob)
	if(..())
		return

	if(gamepaid == 0 && vendor_account && !vendor_account.suspended)
		var/paid = 0
		var/obj/item/card/id/W = I.GetID()
		if(W) //for IDs and PDAs and wallets with IDs
			paid = pay_with_card(W,I)
		else if(istype(I, /obj/item/spacecash/ewallet))
			var/obj/item/spacecash/ewallet/C = I
			paid = pay_with_ewallet(C)
		else if(istype(I, /obj/item/spacecash))
			var/obj/item/spacecash/C = I
			paid = pay_with_cash(C, user)
		if(paid)
			gamepaid = 1
			instructions = "Hit start to play!"
			return
		return

////// Cash
/obj/machinery/computer/arcade/clawmachine/proc/pay_with_cash(var/obj/item/spacecash/cashmoney, mob/user)
	if(!emagged)
		if(gameprice > cashmoney.worth)

			// This is not a status display message, since it's something the character
			// themselves is meant to see BEFORE putting the money in
			to_chat(usr, "\icon[cashmoney][bicon(cashmoney)] <span class='warning'>That is not enough money.</span>")
			return 0

		if(istype(cashmoney, /obj/item/spacecash))

			visible_message("<span class='info'>\The [usr] inserts some cash into \the [src].</span>")
			cashmoney.worth -= gameprice

			if(cashmoney.worth <= 0)
				usr.drop_from_inventory(cashmoney)
				qdel(cashmoney)
			else
				cashmoney.update_icon()

		// Machine has no idea who paid with cash
		credit_purchase("(cash)")
		return 1
	if(emagged)
		playsound(src, 'sound/arcade/steal.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		to_chat(user, "<span class='info'>It doesn't seem to accept that! Seem you'll need to swipe a valid ID.</span>")


///// Ewallet
/obj/machinery/computer/arcade/clawmachine/proc/pay_with_ewallet(var/obj/item/spacecash/ewallet/wallet)
	if(!emagged)
		visible_message("<span class='info'>\The [usr] swipes \the [wallet] through \the [src].</span>")
		playsound(src, 'sound/machines/id_swipe.ogg', 50, 1)
		if(gameprice > wallet.worth)
			visible_message("<span class='info'>Insufficient funds.</span>")
			return 0
		else
			wallet.worth -= gameprice
			credit_purchase("[wallet.owner_name] (chargecard)")
			return 1
	if(emagged)
		playsound(src, 'sound/arcade/steal.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		to_chat(usr, "<span class='info'>It doesn't seem to accept that! Seem you'll need to swipe a valid ID.</span>")

///// ID
/obj/machinery/computer/arcade/clawmachine/proc/pay_with_card(var/obj/item/card/id/I, var/obj/item/ID_container)
	if(I==ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
	playsound(src, 'sound/machines/id_swipe.ogg', 50, 1)
	var/datum/money_account/customer_account = get_account(I.associated_account_number)
	if(!customer_account)
		visible_message("<span class='info'>Error: Unable to access account. Please contact technical support if problem persists.</span>")
		return 0

	if(customer_account.suspended)
		visible_message("<span class='info'>Unable to access account: account suspended.</span>")
		return 0

	// Have the customer punch in the PIN before checking if there's enough money. Prevents people from figuring out acct is
	// empty at high security levels
	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = tgui_input_number(usr, "Enter pin code", "Vendor transaction")
		customer_account = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			visible_message("<span class='info'>Unable to access account: incorrect credentials.</span>")
			return 0

	if(gameprice > customer_account.money)
		visible_message("<span class='info'>Insufficient funds in account.</span>")
		return 0
	else
		// Okay to move the money at this point
		if(emagged)
			gameprice = customer_account.money
		// debit money from the purchaser's account
		customer_account.money -= gameprice

		// create entry in the purchaser's account log
		var/datum/transaction/T = new()
		T.target_name = "[vendor_account.owner_name] (via [name])"
		T.purpose = "Purchase of arcade game([name])"
		if(gameprice > 0)
			T.amount = "([gameprice])"
		else
			T.amount = "[gameprice]"
		T.source_terminal = name
		T.date = current_date_string
		T.time = stationtime2text()
		customer_account.transaction_log.Add(T)

		// Give the vendor the money. We use the account owner name, which means
		// that purchases made with stolen/borrowed card will look like the card
		// owner made them
		credit_purchase(customer_account.owner_name)
		return 1

/// Add to vendor account

/obj/machinery/computer/arcade/clawmachine/proc/credit_purchase(var/target as text)
	vendor_account.money += gameprice

	var/datum/transaction/T = new()
	T.target_name = target
	T.purpose = "Purchase of arcade game([name])"
	T.amount = "[gameprice]"
	T.source_terminal = name
	T.date = current_date_string
	T.time = stationtime2text()
	vendor_account.transaction_log.Add(T)

/// End Payment

/obj/machinery/computer/arcade/clawmachine/Initialize()
	. = ..()

/obj/machinery/computer/arcade/clawmachine/attack_hand(mob/living/user)
	if(..())
		return
	tgui_interact(user)

/// TGUI Stuff

/obj/machinery/computer/arcade/clawmachine/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ClawMachine", name, ui_x = 300, ui_y = 400)
		ui.autoupdate = TRUE
		ui.open()

/obj/machinery/computer/arcade/clawmachine/tgui_data(mob/user)
	var/list/data = list()

	data["wintick"] = wintick
	data["instructions"] = instructions
	data["gameStatus"] = gameStatus
	data["winscreen"] = winscreen

	return data

/obj/machinery/computer/arcade/clawmachine/tgui_act(action, params)
	if(..())
		return

	if(action == "newgame" && gamepaid == 0)
		playsound(src, 'sound/arcade/steal.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)

	if(action == "newgame" && gamepaid == 1)
		gameStatus = "CLAWMACHINE_ON"
		icon_state = "clawmachine_new_move"
		instructions = "Guide the claw to the prize you want!"
		wintick = 0

	if(action == "return" && gameStatus == "CLAWMACHINE_END")
		gameStatus = "CLAWMACHINE_NEW"

	if(action == "pointless" && wintick < 10)
		wintick += 1

	if(action == "pointless" && wintick >= 10)
		instructions = "Insert 1 thaler or swipe a card to play!"
		clawvend()

/obj/machinery/computer/arcade/clawmachine/proc/clawvend() /// True to a real claw machine, it's NEARLY impossible to win.
	winprob += 1 /// Yeah.

	if(prob(winprob)) /// YEAH.
		if(!emagged)
			prizevend()
			winscreen = "You won!"
		else if(emagged)
			gameprice = 1
			emagged = 0
			winscreen = "You won...?"
			var/obj/item/grenade/G = new /obj/item/grenade/explosive(get_turf(src)) /// YEAAAAAAAAAAAAAAAAAAH!!!!!!!!!!
			G.activate()
			G.throw_at(get_turf(usr),10,10) /// Play stupid games, win stupid prizes.

		playsound(src, 'sound/arcade/Ori_win.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		winprob = 0

	else
		playsound(src, 'sound/arcade/Ori_fail.ogg', 50, 1, extrarange = -3, falloff = 0.1, ignore_walls = FALSE)
		winscreen = "Aw, shucks. Try again!"
	wintick = 0
	gamepaid = 0
	icon_state = "clawmachine_new"
	gameStatus = "CLAWMACHINE_END"

/obj/machinery/computer/arcade/clawmachine/emag_act(mob/user)
	if(!emagged)
		to_chat(user, "<span class='info'>You modify the claw of the machine. The next one is sure to win! You just have to pay...</span>")
		name = "AlliCo Snag-A-Prize"
		desc = "Get some goodies, all for you!"
		instructions = "Swipe a card to play!"
		winprob = 100
		gamepaid = 0
		wintick = 0
		gameStatus = "CLAWMACHINE_NEW"
		emagged = 1
		return 1

/obj/machinery/computer/arcade/attackby(obj/item/O, mob/user, params)
	..()
	if(istype(O, /obj/item/stack/arcadeticket))
		var/obj/item/stack/arcadeticket/T = O
		var/amount = T.get_amount()
		if(amount <2)
			to_chat(user, "<span class='warning'>You need 2 tickets to claim a prize!</span>")
			return
		prizevend(user)
		T.pay_tickets()
		T.update_icon()
		O = T
		to_chat(user, "<span class='notice'>You turn in 2 tickets to the [src] and claim a prize!</span>")
		return
