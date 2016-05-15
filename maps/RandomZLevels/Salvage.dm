//Salvage Areas

/area/awaymission/salvage
	name = "\improper Strange Location"
	icon_state = "away"

/area/awaymission/salvage/freighter
	name = "\improper Cargo Freighter \"Artemis\""
	icon_state = "green"

// Each corresponds to a wire in the ship, as opposed to the usual powernet setup. All can be controlled from the bridge.
/area/awaymission/salvage/defense
	name = "CVS \"Oblivion\" Defenses"
	icon_state = "red"

/area/awaymission/salvage/medical
	name = "CVS \"Oblivion\" Medical"
	icon_state = "medbay"

/area/awaymission/salvage/logistics
	name = "CVS \"Oblivion\" Logistics"
	icon_state = "dk_yellow"

/area/awaymission/salvage/main
	name = "CVS \"Oblivion\" Main"
	icon_state = "purple"

/area/awaymission/salvage/miscellaneous
	name = "CVS \"Oblivion\" Miscellaneous"
	icon_state = "blue-red-d"

/area/awaymission/salvage/crew
	name = "CVS \"Oblivion\" Non-Vital"
	icon_state = "green"

///////////////////Salvage items///////////////////

/*
/obj/random/gun/guarenteed/deagle // Must be defined here first or the code below doesn't compile.
	name = "Desert Eagle"
	desc = "This is a random gun"
	icon_state = "deagle"
	item_to_spawn()
		return pick(/obj/item/weapon/gun/projectile/deagle,\
					/obj/item/weapon/gun/projectile/deagle/gold,\
					/obj/item/weapon/gun/projectile/deagle/camo)
*/

/obj/random/gun
	name = "Random Gun"
	desc = "This is a random gun"
	icon = 'icons/obj/gun.dmi'
	icon_state = "p08"
	spawn_nothing_percentage = 75
	item_to_spawn()
		return pick(/obj/random/ammo,\
					/obj/random/ammo,\
					/obj/random/ammo,\
//					/obj/random/gun/guarenteed/deagle,\ // Because otherwise you're more likely to get a D'eagle than any other gun.
					/obj/item/weapon/gun/projectile,\
					/obj/item/weapon/gun/projectile/shotgun/doublebarrel,\
					/obj/item/weapon/gun/projectile/shotgun/pump,\
					/obj/item/weapon/gun/projectile/shotgun/pump/combat,\
					/obj/item/weapon/gun/projectile/pistol,\
					/obj/item/weapon/gun/projectile/luger,\
					/obj/item/weapon/gun/projectile/mateba,\
					/obj/item/weapon/gun/projectile/gyropistol,\
					/obj/item/weapon/gun/projectile/detective/semiauto/fluff/fnfiveseven,\
					/obj/item/weapon/gun/projectile/detective/semiauto/colt,\
					/obj/item/weapon/gun/projectile/detective,\
					/obj/item/weapon/gun/projectile/automatic/saber,\
					/obj/item/weapon/gun/projectile/automatic/c20r,\
					/obj/item/weapon/gun/projectile/automatic/mini_uzi,\
					/obj/item/weapon/gun/energy/gun,\
					/obj/item/weapon/gun/energy/gun/nuclear,\
					/obj/item/weapon/gun/energy/laser,\
					/obj/item/weapon/gun/energy/laser/captain,\
					/obj/item/weapon/gun/energy/laser/retro,\
					/obj/item/weapon/gun/energy/lasercannon,\
					/obj/item/weapon/gun/energy/pulse_rifle,\
					/obj/item/weapon/gun/energy/sniperrifle,\
					/obj/item/weapon/gun/energy/stunrevolver,\
					/obj/item/weapon/gun/energy/xray,\
					/obj/item/weapon/gun/energy/toxgun,\
					/obj/item/weapon/gun/projectile/automatic/shotgun,\
					/obj/item/weapon/gun/projectile/shotgun/doublebarrel/judge,\
				/*	/obj/item/weapon/crossbow,\ */
				/*	/obj/item/weapon/flamethrower/full,\ */
					/obj/item/weapon/gun/projectile/shotgun/pump/rifle,\
					/obj/item/weapon/gun/projectile/automatic/m14,\
					/obj/item/weapon/gun/projectile/automatic/tommygun,\
					/obj/item/weapon/gun/projectile/automatic/stg,
					/obj/item/weapon/gun/grenadelauncher,\
					/obj/item/weapon/gun/rocketlauncher)
// Should set probability for spawns.


/obj/random/gun/guarenteed // For loot spawns.
	spawn_nothing_percentage = 0

/obj/random/ammo
	name = "Random Ammo"
	desc = "This is a random ammo"
	icon = 'icons/obj/ammo.dmi'
	icon_state = "9mm"
	spawn_nothing_percentage = 0
	item_to_spawn()
		return pick(/obj/item/ammo_magazine/a10mmc,\
					/obj/item/ammo_magazine/a12mm,\
					/obj/item/ammo_magazine/a357,\
					/obj/item/ammo_magazine/a12mm,\
				/*	/obj/item/ammo_magazine/a418,\ */ //Suffocation round
					/obj/item/ammo_magazine/a50,\
					/obj/item/ammo_magazine/a51,\
				/*	/obj/item/ammo_magazine/a666,\ */ //Cyanide round
					/obj/item/ammo_magazine/a75,\
					/obj/item/ammo_magazine/a762,\
					/obj/item/ammo_magazine/c28mm,\
					/obj/item/ammo_magazine/c38,\
					/obj/item/ammo_magazine/c45m,\
					/obj/item/ammo_magazine/c45r,\
					/obj/item/ammo_magazine/smg9mm,\
					/obj/item/ammo_magazine/mc9mm,\
					/obj/item/ammo_magazine/rifle_clip,\
					/obj/item/ammo_magazine/stg,\
					/obj/item/ammo_magazine/tommygun,\
					/obj/item/ammo_magazine/uzi,\
					/obj/item/ammo_casing/rocket,\
					/obj/item/weapon/storage/box/shotgun/shell,\
					/obj/item/weapon/storage/box/flashbangs)


/obj/random/food
	name = "Random Food"
	desc = "This is a random food spawner."
	icon = 'icons/obj/food.dmi'
	icon_state = "cheeseburger"
	spawn_nothing_percentage = 75
	item_to_spawn()
		return pick(/obj/item/weapon/reagent_containers/food/snacks/aesirsalad,\
					/obj/item/weapon/reagent_containers/food/snacks/candy,\
					/obj/item/weapon/reagent_containers/food/snacks/candy_corn,\
					/obj/item/weapon/reagent_containers/food/snacks/chips,\
					/obj/item/weapon/reagent_containers/food/snacks/cookie,\
					/obj/item/weapon/reagent_containers/food/snacks/chocolatebar,\
					/obj/item/weapon/reagent_containers/food/snacks/donut,\
					/obj/item/weapon/reagent_containers/food/snacks/boiledegg,\
					/obj/item/weapon/reagent_containers/food/snacks/tofu,\
					/obj/item/weapon/reagent_containers/food/snacks/sausage,\
					/obj/item/weapon/reagent_containers/food/snacks/cheeseburger,\
					/obj/item/weapon/reagent_containers/food/snacks/omelette,\
					/obj/item/weapon/reagent_containers/food/snacks/muffin,\
					/obj/item/weapon/reagent_containers/food/snacks/pie,\
					/obj/item/weapon/reagent_containers/food/snacks/berryclafoutis,\
					/obj/item/weapon/reagent_containers/food/snacks/waffles,\
					/obj/item/weapon/reagent_containers/food/snacks/eggplantparm,\
					/obj/item/weapon/reagent_containers/food/snacks/soylentgreen,\
					/obj/item/weapon/reagent_containers/food/snacks/meatpie,\
					/obj/item/weapon/reagent_containers/food/snacks/amanita_pie,\
					/obj/item/weapon/reagent_containers/food/snacks/plump_pie,\
					/obj/item/weapon/reagent_containers/food/snacks/wingfangchu,\
					/obj/item/weapon/reagent_containers/food/snacks/monkeykabob,\
					/obj/item/weapon/reagent_containers/food/snacks/cubancarp,\
					/obj/item/weapon/reagent_containers/food/snacks/popcorn,\
					/obj/item/weapon/reagent_containers/food/snacks/sosjerky,\
					/obj/item/weapon/reagent_containers/food/snacks/no_raisin,\
					/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie,\
					/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers,\
					/obj/item/weapon/reagent_containers/food/snacks/syndicake,\
					/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato,\
					/obj/item/weapon/reagent_containers/food/snacks/fries,\
					/obj/item/weapon/reagent_containers/food/snacks/cheesyfries,\
					/obj/item/weapon/reagent_containers/food/snacks/meatsteak,\
					/obj/item/weapon/reagent_containers/food/snacks/spacylibertyduff,\
					/obj/item/weapon/reagent_containers/food/snacks/poppypretzel,\
					/obj/item/weapon/reagent_containers/food/snacks/meatballsoup,\
					/obj/item/weapon/reagent_containers/food/snacks/vegetablesoup,\
					/obj/item/weapon/reagent_containers/food/snacks/mysterysoup,\
					/obj/item/weapon/reagent_containers/food/snacks/hotchili,\
					/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger,\
					/obj/item/weapon/reagent_containers/food/snacks/enchiladas,\
					/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight,\
					/obj/item/weapon/reagent_containers/food/snacks/baguette,\
					/obj/item/weapon/reagent_containers/food/snacks/sandwich,\
					/obj/item/weapon/reagent_containers/food/snacks/toastedsandwich,\
					/obj/item/weapon/reagent_containers/food/snacks/grilledcheese,\
					/obj/item/weapon/reagent_containers/food/snacks/tomatosoup,\
					/obj/item/weapon/reagent_containers/food/snacks/stew,\
					/obj/item/weapon/reagent_containers/food/snacks/meatballspagetti,\
					/obj/item/weapon/reagent_containers/food/snacks/spesslaw,\
					/obj/item/weapon/reagent_containers/food/snacks/candiedapple,\
					/obj/item/weapon/reagent_containers/food/snacks/applepie,\
					/obj/item/weapon/reagent_containers/food/snacks/cherrypie,\
					/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit,\
					/obj/item/weapon/reagent_containers/food/snacks/chawanmushi,\
					/obj/item/weapon/reagent_containers/food/snacks/tossedsalad,\
					/obj/item/weapon/reagent_containers/food/snacks/appletart,\
					/obj/item/weapon/reagent_containers/food/snacks/meatbreadslice,\
					/obj/item/weapon/reagent_containers/food/snacks/bananabreadslice,\
					/obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice,\
					/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice,\
					/obj/item/weapon/reagent_containers/food/snacks/plaincakeslice,\
					/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,\
					/obj/item/weapon/reagent_containers/food/snacks/breadslice,\
					/obj/item/weapon/reagent_containers/food/snacks/watermelonslice,\
					/obj/item/weapon/reagent_containers/food/snacks/cracker,\
					/obj/item/weapon/reagent_containers/food/snacks/margheritaslice,\
					/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice,\
					/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice,\
					/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice,\
					/obj/item/weapon/reagent_containers/food/snacks/taco,\
					/obj/item/weapon/reagent_containers/food/snacks/hotdog)

/obj/random/food/guarenteed
	spawn_nothing_percentage = 0

/obj/machinery/computer/shiphud // Currently does nothing but look pretty.
	name = "Heads Up Display"
	desc = "An interface between pilots and the ship's vital navigation and weapon systems. Too bad you don't have the keycodes."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "cellconsole"
	circuit = "/obj/item/weapon/circuitboard/shiphud"
	density = 0
	var/mode = null

/obj/item/weapon/circuitboard/shiphud
	name = "Circuit board (Flight Controls)"
	build_path = "/obj/machinery/computer/shiphud"
	origin_tech = "programming=3"

//////// Unique items from this mission ////////

/obj/item/weapon/gun/projectile/luger
	name = "\improper Luger P08"
	desc = "This gun looks like it belongs in a museum. Still popular among Space Nazis. Uses 9mm rounds."
	icon_state = "p08"
	max_shells = 8
	caliber = "9mm"
	silenced = 0
	origin_tech = "combat=2;materials=2;syndicate=2"
	ammo_type = "/obj/item/ammo_casing/c9mm"
	load_method = 2

/obj/item/weapon/gun/projectile/luger/New()
	..()
	empty_mag = new /obj/item/ammo_magazine/mc9mm/empty(src)
	return

/obj/item/weapon/gun/projectile/luger/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!loaded.len && empty_mag)
		empty_mag.loc = get_turf(src.loc)
		empty_mag = null
	return


/obj/item/weapon/reagent_containers/food/drinks/flask/soviet
	name = "Soviet Flask"
	desc = "An old gold plated flask. Nothing noteworthy about it besides it being gold and the red star on the worn out leather around it."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "yuri_kornienkovich_flask"

/obj/item/clothing/under/rank/centcom_commander/generic
	desc = "It's a navy jumpsuit worn by highest-tier commanders."
	name = "\improper navy captain's jumpsuit"

/obj/item/clothing/head/beret/centcom/captain/generic
	name = "navy captain's beret"
	desc = "A white beret adorned with the shield—a cobalt kite shield with an engraved sword—of the Arvoch Defense Forces, worn only by those captaining a vessel of the Arvoch Navy."

//////// Members of the freighter crew ////////

// See corpse.dm for how to set up corpses properly.

/*
	corpseuniform = null //Set this to an object path to have the slot filled with said object on the corpse.
	corpsesuit = null
	corpseshoes = null
	corpsegloves = null
	corpseradio = null
	corpseglasses = null
	corpsemask = null
	corpsehelmet = null
	corpsebelt = null
	corpsepocket1 = null
	corpsepocket2 = null
	corpseback = null
	corpseid = 0     //Just set to 1 if you want them to have an ID
	corpseidjob = null // Needs to be in quotes, such as "Clown" or "Chef." This just determines what the ID reads as, not their access
	corpseidaccess = null //This is for access. See access.dm for which jobs give what access. Again, put in quotes. Use "Captain" if you want it to be all access.
	corpseidicon = null //For setting it to be a gold, silver, CentCom etc ID
	mutantrace = "human"
*/


/obj/effect/landmark/corpse/salvage_corpses/captain
	name = "Keane Dragic"
	corpseuniform = /obj/item/clothing/under/rank/captain
	corpsesuit = /obj/item/clothing/suit/captunic/capjacket
	corpsemask = /obj/item/clothing/mask/cigarette/cigar/cohiba
	corpsehelmet = /obj/item/clothing/head/helmet/cap
	corpsegloves = /obj/item/clothing/gloves/black
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsepocket1 = /obj/item/weapon/storage/box/matches
//	corpsepocket2 = /obj/item/weapon/paper/salvage/captain/final
	corpseback = /obj/item/weapon/gun/projectile/shotgun/doublebarrel
	corpseid = 1
	corpseidjob = "Captain"

/obj/effect/landmark/corpse/salvage_corpses/first_mate
	name = "Kameron Southgate"
	corpseuniform = /obj/item/clothing/under/fluff/olddressuniform
	corpsesuit = /obj/item/clothing/suit/space
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space
	corpseshoes = /obj/item/clothing/shoes/magboots
	corpsepocket1 = /obj/item/weapon/paper/salvage/first_mate
	corpsepocket2 = /obj/item/device/radio
	corpseback = /obj/item/weapon/tank/jetpack/oxygen
	corpseid = 1
	corpseidjob = "First Mate"

/obj/effect/landmark/corpse/salvage_corpses/quartermaster
	name = "Fergus Turnbull"
	corpseuniform = /obj/item/clothing/under/brown
	corpsesuit = /obj/item/clothing/suit/space/nasavoid
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/nasavoid
	corpsegloves = /obj/item/clothing/gloves/brown
	corpseshoes = /obj/item/clothing/shoes/magboots
	corpsepocket1 = /obj/item/weapon/paper/salvage/quartermaster
	corpsepocket2 = /obj/item/device/radio
	corpseback = /obj/item/weapon/tank/jetpack/void
	corpseid = 1
	corpseidjob = "Quartermaster"

// Doctor - Eusebius Van Achteren

/obj/effect/landmark/corpse/salvage_corpses/doctor
	name = "Dr. Fergus Turnbull"
	corpseuniform = /obj/item/clothing/under/rank/medical
	corpsesuit = /obj/item/clothing/suit/space/syndicate/black/med
	corpseglasses = /obj/item/clothing/glasses/gglasses
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/syndicate/black/med
	corpsegloves = /obj/item/clothing/gloves/latex
	corpseshoes = /obj/item/clothing/shoes/magboots
//	corpsepocket1 = /obj/item/weapon/paper/salvage/doctor
	corpsepocket2 = /obj/item/device/radio
	corpseback = /obj/item/weapon/tank/jetpack/oxygen
	corpseid = 1
	corpseidjob = "Medical Doctor"

/obj/effect/landmark/corpse/salvage_corpses/engineer
	name = "Gerrard Kostelecky"
	corpseuniform = /obj/item/clothing/under/soviet
	corpsesuit = /obj/item/clothing/suit/space/rig
	corpseglasses = /obj/item/clothing/glasses/fluff/arjun_chopra_1
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/rig
	corpsebelt = /obj/item/weapon/storage/belt/utility/full
	corpsegloves = /obj/item/clothing/gloves/yellow
	corpseshoes = /obj/item/clothing/shoes/magboots
	corpsepocket1 = /obj/item/weapon/paper/salvage/engineer
	corpsepocket2 = /obj/item/weapon/reagent_containers/food/drinks/flask/soviet
	corpseback = /obj/item/weapon/tank/jetpack/oxygen
	corpseid = 1
	corpseidjob = "Engineer"

/obj/effect/landmark/corpse/salvage_corpses/dead_soldier
	icon_state = "x3"
	name = "a dead soldier"
	corpseuniform = /obj/item/clothing/under/tactical
	corpseshoes = /obj/item/clothing/shoes/combat
	corpsepocket1 = null
	corpsepocket2 = null

/obj/effect/landmark/corpse/salvage_corpses/dead_soldier/armed
	corpsesuit = /obj/item/clothing/suit/armor/tactical
	corpsegloves = /obj/item/clothing/gloves/black
	corpseradio = /obj/item/device/radio/headset/headset_sec/tactical
	corpseglasses = /obj/item/clothing/glasses/sunglasses/sechud/tactical
	corpsemask = /obj/item/clothing/mask/balaclava/tactical
	corpsehelmet = /obj/item/clothing/head/helmet/tactical
	corpsebelt = /obj/item/weapon/storage/belt/security/tactical
	corpseback = /obj/item/weapon/storage/backpack/security

/obj/effect/landmark/corpse/salvage_corpses/dead_soldier/captain
	name = "unknown navy captain"
	corpseuniform = /obj/item/clothing/under/rank/centcom_commander/generic
	corpsesuit = /obj/item/clothing/suit/armor/tactical/officer
	corpseshoes = /obj/item/clothing/shoes/combat
	corpsegloves = /obj/item/clothing/gloves/combat
	corpseglasses = /obj/item/clothing/glasses/sunglasses
	corpsehelmet = /obj/item/clothing/head/beret/centcom/captain/generic
	corpseback = null
	corpseid = 1
	corpseidjob = "Captain"

/////// Story notes on each of the corpses. ///////

/obj/item/weapon/paper/salvage/captain/log1
	name = "Captain's Log 1"
	info = {"<b>Captain's Log</b><br>
			<b>0307-2558</b><br>
			--------------------
			<br>
			This will be my first entry as the proud new owner of the Artemis. While she's not the most
			robust of the ships I've seen for sale, she's a reasonable price and I'm sure with a few
			missions, we'll have the money to upgrade her into to a great vessel.<br>
			<br>
			I met with my new crew today on Sapphire at Nova planetside spaceport. Kameron Southgate is my new first mate.
			He's a former Head of Personnel on one of Nanotrasen's Plasma Research Facilities called Goonstation.
			He has experience in command and combat, and he's got the scars to prove it. He's a man with a
			zero-tolerance policy for bullshit. Funny thing is, it's what got him fired.
			Fortunately for him, it's exactly what I'm looking for in my right hand man.<br>
			<br>
			Fergus Turnbull, our Quartermaster, he's a bit of a weird one. I think this guy was homeless when
			I met him. He was pushing around a shopping cart full of what looked like junk when I stumbled on him
			in Nova while ship shopping. I wouldn't call him dumb, but let's just say his brain's got a few wires
			crossed. He was fiddling with his spoons and clanking them on his bowl annoying the shit out of Kameron during the meet,
			but Kameron hasn't seen this guy in action yet. He's like a fucking encyclopaedia with legs. Like,
			when I was buying the Artemis, she had a faulty power converter. Fergus overheard me talking with the
			salesman (haggling, naturally) and suddenly just barged in on our conversation saying how unreliable
			and wasteful it was to have a power converter on a plasma-oxygen fueled engine system. He started
			rambling on about an antimatter power core. Salesman said they were expensive to buy. Fergus says
			he can get a working one from the junkyard if I'd feed him for a week. Salesman called bullshit.
			So I made a wager. Needless to say, I won, and got a big fat discount on the Artemis thanks to Fergus.
			You give him a hunk of tech, he can tell you what it is, where it came from, what it's for,
			how much it's worth, and where to get more of them. Kept me from getting ripped off. The guy's social
			skills aren't great. He barely spoke a word at the meet, and when he did, it was totally off topic
			and made things kind of awkward for everyone because he'd derail the conversation. I don't think he
			even realizes it, but, doesn't matter. Yea, his brain's got a few wires crossed, but that brain's
			got more than enough processing power to make up for a few glitches.<br>
			<br>
			Dr. Eusebius Van Achteren is... sketchy as fuck to put it lightly. His resumé says he used to work
			at a big Nanotrasen University as the dean. Constantly bitches about some chick named Dr. Helen Page
			who I guess took his job when he got fired. He's a capable doctor, though. I just wish he knew more
			about human anatomy than he does about fucking Xenomorphs. (I think he has a fetish for them. Like
			I said, SKETCHY AS FUCK.) He started getting all... how do I put this? Horny. Like, we were talking
			about the hazards of space and the topic of Xenos came up and how they'd deal with it. I know he was
			trying to hide it but I could fucking hear it in his voice the way he described their, and I quote,
			<i>smooth, glistening exoskeleton</i>. See, Kameron and I were talking about what kind of weapons
			would punch through its hide, and Dr. Xenophile here is daydreaming about fucking it. Still... the
			guy's willing to work for dirt cheap and he knows enough about basic medical to keep us alive if
			something goes wrong. Not like we need him to do surgery. Just stabilize us until we can rush to the
			nearest orbital hospital.<br>
			<br>
			Finally there's the engineer, Gerrard Kostelecky. He's a bit weird too but not as weird as Fergus.
			Sol Basic isn't his first language. He's a former engineer who used to serve the Space Soviets. He
			is very good at what he does and managed to install that antimatter core that Fergus found in the
			scrap heap. In fact, he and Fergus work very well together. Fergus can ramble off a manual from the
			top of his head for whatever Gerrard wants to fix, but where Gerrard is special is that he can
			improvise like no one I've ever seen. The core wasn't compatible with the frigate and would have
			probably exploded if we installed it wrong, and this crazy Ruskie manages to strap it together with
			duct tape, paper clips, and scrap metal. His work looks more sketchy than the doc, but he proved his
			point when he bashed on the thing with a wrench (scaring the shit out of me and Fergus who were
			watching) to prove it was structurally sound. He's done all kinds of neat shit. He's built aircraft
			out of scrap and wood and old rover parts. He turned a vacuum cleaner and an air tank into a kinetic
			weapon. The only problem is he's a little hard to talk to. He speaks in third person and calls the
			rest of us 'comrades' but I guess that last part is a good thing. Kameron gets along with him anyway.
			He's an honest worker who can do a lot with limited resources. I think he learned that from his time
			with the Soviets. He'll make a great addition to our crew.<br>
			<br>
			<br>
			We mostly just talked details about the mission and discussed what sectors we should visit first.
			Possible contracts include mining operations, courier services, private shuttling, search and salvage,
			and a few others. I figure we'll save the armed escort missions until we've earned some money to outfit
			the Artemis with some better weapons.<br>
			<br>
			I think we've got some potential among us. Who knows? Maybe we'll strike it rich. We launch tomorrow."}

/obj/item/weapon/paper/salvage/captain/log2
	name = "Captain's Log 2"
	info = {"<b>Captain's Log</b><br>
			<b>0407-2558</b><br>
			--------------------
			<br>
			For them this might be about the money but for me it's about the dream. Ever since I was a kid, I'd
			always wanted to be a spaceman. Earlier today the Artemis was moved onto the launch pad and the
			final countdown started at noon. I had never been so excited in my life. When the boosters lit off
			and the force of takeoff pressed me into the seat, the adrenaline rush I had was like nothing I'd
			experienced in my life! Like the very first men to blast off from Sol, I was a real spaceman. Funny
			how in almost 600 years of development, we still use old fashioned methods with some ships. The
			Artemis is a pretty old model in fact. She's like an ancient galleon is to an aircraft carrier. She
			can travel the galaxy, but, save for a few modern aids like starmaps and hypernet, she lacks a lot
			of things that most spacefaring crews take for granted. Not to mention she's slow. At the same time
			it's what makes her such a thrill to pilot--because she's not completely automated. For example, her
			life support system is only the most basic. Gerrard bought us some air scrubbers at the last minute
			that we'll have to turn on manually if it starts getting hard to breathe. There's a stock of high
			capacity air canisters in the back for cycling the airlock and keeping us alive. He also installed
			a vending machine to supply us with enough rations to fly to the next system over. The FTL engine
			is an older model, so it takes a few weeks to get between stars but after a few jobs we'll be able
			to refit her with a bluespace drive thanks to the money I saved because of Fergus.<br>
			<br>
			Kameron and I decided we should head for the Rucker system. There's money to be made in buying up
			ore from the miners in Sapphire and shipping it to the spaceport on Pearl. We can buy for more than
			the local refineries, and undercut the competition on Pearl where things like gold, silver, diamonds,
			and uranium are scarce compared to things like iron or plasma. Then buy up their plasma and fly back
			to Sapphire and sell all our plasma to Evochron station. Buy their ores, fly to Pearl, sell it, buy
			their plasma, fly back to Sapphire, repeat. If we're careful to buy all our fuel in the Virgo system,
			we'll have enough money to buy that bluespace drive in no time, and then we can worry about saving up
			to buy some weapons for the ship. Then we can start buying and selling the hyperdrives themselves.
			Considering how often there are skirmishes at Pearl, lord knows they'll be buying up new hyperdrives
			to replace any blown out in combat."}

/obj/item/weapon/paper/salvage/captain/log3
	name = "Captain's Log 3"
	info = {"<b>Captain's Log</b><br>
			<b>1007-2558</b><br>
			--------------------
			<br>
			We briefly stopped by the Virgo system and bought a full stock of plasma and O2 canisters. Not a
			moment too soon, either. Maybe when we get good at this we'll be able to use the FTL drive to launch
			us right into position so we can save time and fuel not doing orbital adjustments each time we come
			out of hyperspace.<br>
			<br>
			Not a whole lot of interest happened, but we did bump into some curious folks while planetside. There
			was this guy with cat ears--I swear they had to be fake--and the most stupid looking pointy orange
			glasses. Clumsy moron walked right into me 'cuz he was too busy fucking around on his PDA to watch
			where he was going. I think he broke his stupid glasses. Serves him right. Nerd.<br>
			<br>
			Gerrard and I went for pizza while Doc and Kameron went to buy the fuel from the NT Supply Depot.
			Saw the most knarly fucking tajaran (I think it was a Tajaran?) buying like a whole stack of five
			meatlover pizzas. He spoke more broken than Gerrard does and kept making these chirping noises when
			he walked out with his order.<br>
			<br>
			Kameron and Doc returned about the same time we did. Fergus just stayed on the ship the whole day.
			We set course for Pearl and launched for the next system. Rucker is the last stop on our route
			before we arrive in Pearl. I admit I'm a little nervous about flying through that system. Pirates
			are a common site there. Kameron suggested we alter our course slightly to avoid the pirates, but
			Fergus is worried we'll miss our warp trajectory and wind up in the wrong system--or worse--smacked
			into the side of a star. Kameron and Fergus got into a pretty heated fight over the issue but I'm
			going to trust Kameron this time around. Fergus doesn't have any experience working in space, while
			Kameron does. I think Kameron knows what he's doing. We held a vote. Gerrard and the Doc agreed.
			We follow Kameron's course."}

/obj/item/weapon/paper/salvage/captain/log4
	name = "Captain's Log 4"
	info = {"<b>Captain's Log</b><br>
			<b>1507-2558</b><br>
			--------------------
			<br>
			We launched into the Rucker system orbiting the star rather than the planet where most of the usual
			cargo routes go through (and where most of the pirates hunt). Seems Kameron was right. No vessels
			on our sensors. Not even scouts. Gerrard has been acting like a smartass and messing with Fergus by
			banging on the pipes and hull with his wrench to frighten him, although I eventually told him to
			knock it the fuck off because it was making me jumpy too. The whole crew is on edge and Fergus is
			getting the worst of it. Well, except Doc. At least Doc manages to keep himself sane with a bit of
			music. Hell, I think a little violin is the only thing that's keeping the rest of us sane either.<br>
			<br>
			I guess this is just one of those days where we'll be at each others' throats. Living in a cramped
			spaceship will do that to anyone. I know we'll get over it eventually."}

/obj/item/weapon/paper/salvage/captain/log5
	name = "Captain's Log 5"
	info = {"<b>Captain's Log</b><br>
			<b>1707-2558</b><br>
			--------------------
			<br>
			We woke up to a loud bang today--loud enough that it shook the whole ship. At first I thought it was
			Gerrard fucking with us again but I could see it in his face he was as freaked out as I was, and
			that's when I knew it wasn't a joke. Alarms were going off in the cockpit that we flew right through
			an ion storm and it threw the antimatter engine into flux. We lost power on the ship for almost ten
			minutes--and did things go to hell in a handbasket when they did. Gerrard managed to run into the
			engine block and stabilize the core before it vaporized us, but that's when the blame game started.<br>
			<br>
			Kameron and Gerrard were busy screaming at each other and Fergus got dragged into it too. The doc
			did his best to calm everyone down but that was a big failure. Kameron was blaming Gerrard for being
			a fucking moron and Gerrard was yelling at him in broken Sol Basic and Russian and ranting about
			how the damage wasn't his fault and the only reason he was banging on the hull was to make Fergus
			man up. Fergus responded by punching Gerrard in the jaw. Next thing I know these two are brawling
			so Kameron and I have to break it up. Doc pulled them both into medbay and I stood guard while
			they were treated for their cuts and bruises.<br>
			<br>
			Kameron meanwhile went back to the bridge to figure out what system we were in and start transmitting
			an SOS on the hypernet. I keep telling everyone we'll be fine. We have enough oxygen and rations to
			last us a while if we can't get the supermatter core repaired. Gerrard is keeping it running on low
			power for now. Enough to keep the ship and all its functions running, but not enough to use the
			hyperdrive. For now we'll put ourselves in a stable orbit and sit idle until rescue shows up or
			we get the hyperdrive fixed."}

/obj/item/weapon/paper/salvage/captain/final
	name = "Captain's Log 6"
	info = {"<b>Captain's Log</b><br>
			<b>Fuck if I know-2558</b><br>
			--------------------
			<br>
			We've been out here for days now. Maybe weeks. I've lost track of time. I keep blacking out even in
			the middle of vital tasks and waking up on the floor or in my bed if the crew is nice enough to drag
			me there. Doc says I'm suffering from Space Sleeping Disorder. The whole crew's starting to come down
			with it. Apparently it's very common for space travel and he says it's because I've not been following
			a strict sleep schedule, making the darkness of space confuse my body's physiological cues.<br>
			<br>
			I think we got lucky, though. We drifted up alongside an old battlecruiser when we went into orbit.
			There's just one problem. We tried to contact them for help, but got no response. We think it used
			to be a destroyer or a light carrier, probably human built. I instructed the crew to go out under
			Kameron's lead and investigate the ghost ship. We might have hit the jackpot on this one. We found
			what Kameron calls a Bluespace Gateway in the back of the ship. Fergus said if we got it running,
			we might be able to use it to teleport ourselves to a Nanotrasen station where we could get help.
			I made Gerrard take it apart and rebuild it connected to our ship's power grid. It can't fit it inside
			so we stole some metal from their engineer supplies and built a platform and used a tow cable to keep
			it anchored to our ship. We have just barely enough power to spare in order to run the thing, but
			Kameron won't let us go through it yet. Says that if we don't calibrate it properly, we might end up
			god-knows-where-else and get ourselves killed, or worse. He said there might be a chance it's already
			calibrated, but until we know for sure, I figured we'd best not play a game of Russian Roulette with
			that thing.<br>
			<br>
			I told them to go back and get to the battleship's bridge if they can. Maybe one of the computers
			has some record on the gateway. Gerrard meanwhile went to where he tore the gate out to search for
			clues there. Fergus didn't want to go back out. Says that whatever got the crew might still be on
			board, but Kameron says the ship looks like it's been there for decades. Whatever 'it' was probably
			starved to death by now. I told Fergus just to bring back absolutely anything that looked valuable
			or useful and stick it in the cargo hold for later. In about an hour, he filled the place up,
			although he hasn't been back since then, probably deciding what's more valuable to take or dump.
			Or maybe he's pissed off at me. As for Doc? I told him just keep floating around on standby just
			in case someone gets hurt.<br>
			<br>
			After all this shit is over I'd love nothing more than to just lay down and pass out and sleep for a
			whole day. This spaceman shit is much more stressful than I thought it'd be. But hey, I'm living the
			dream, right?<br>
			<br>
			Although I keep seeing shit floating outside the window. I know it's just debris, but with Fergus
			making us all paranoid, it's really starting to"}
//	icon_state = "scrap_bloodied" // Doesn't actually change the icon, unfortunately.

/obj/item/weapon/paper/salvage/doctor
	name = "Dear Diary"
	info = {"Dear Diary,<br>
			<br>
			Jackpot ;)<br>
			<br>
			Sincerely,<br>
			Dr. Fergus Turnbull<br>
			<br>
			P.S. If I'm going to die out here in the fucking void like this, I'm going to die happy."}

/obj/item/weapon/paper/salvage/engineer
	name = "NO TOUCH WIRES!"
	info = {"gerrard put lot of hard work to take gate thing! gerrard not want to get zapped AGAIN because some
			first mate think fixing wires good thing like flying through ion storm because he is smart man.
			WIRES BROKEN ON PURPOSE so gerrard can take gateway WITHOUT GETTING ZAPPED AGAIN!!"}

/obj/item/weapon/paper/salvage/quartermaster
	name = "I'm sorry"
	info = {"Kameron doesn't get it. We're screwed with him in charge. I don't know why the Captain insisted on
			hiring him in the first place. The doc wandered off, and Kameron is being his usual cocky know-it-all
			self. He's probably on the bridge thinking he can call for help using their long range comms. This is
			AFTER he nearly electrocuted Gerrard by 'fixing' a wire to the gateway when Gerrard was trying to take
			it down. Doesn't he realize that if the comms even worked, the old crew probably would have done that by now?
			Or maybe they tried, and they were killed by one of those drones. I knew I should have stayed on
			Sapphire. Maybe I was better off on the streets than I am on this crew. I respect the Captain,
			he's the only one who treats me with any respect in return, but I just wish he knew better than to
			trust Kameron. I knew he was out for us since the moment I met him. He's a traitor and nothing more.
			Probably sent us all to die like this on purpose so some pirates could pick
			off the remains and he could get a fat paycheck at the cost of our lives.<br>
			<br>
			Well I won't allow it.<br>
			<br>
			Captain, when you come to search for us, and you find this note, it means I am already dead. I am
			sorry. Hopefully Kameron is already dead by the time you find this as well. Take Gerrard and the
			Doctor (wherever he ran off to) and continue your mission. This a CVS-class starship commonly called
			Leviathan. The CVS means Carrier, Fixed-Wing, Spacefighter. The four fighters in the hangar are
			actually Moray-class gunships. Both the Leviathan and the Moray gunships are produced by a company
			called Cybersun Industries, which not only supplies the Syndicate, but sells weapons to civilian and
			government bodies throughout the Virgo cluster--including all except the star system Virgo its self
			and Sapphire. There were only three Leviathan-class vessels ever built. Two of them were lost in
			the Battle of Polaris-Alpha. Beligerent factions include the United Earth Federation with sub-factions
			including the United Nations Space Command, Joint Special Operations Command, and several others,
			against rebelling human colonies attempting to establish sovereignty over their home systems.
			Cybersun Industries supplied both sides, prior to its involvement with the Syndicate. On the opposing
			side was the Polaris Confederacy which had aid from the Second Soviet Union and included sub-factions
			like the Novar Trade Union and the mining company Silar Group (which would later go on to discover
			Plasma after Nanotrasen bought them out). In this battle, one battleship was captured by the UEF and
			subsequently destroyed. The other crashed into a star after a hyperdrive malfunction caused by battle
			damage caused it to warp in at a sub-orbital trajectory that ultimately doomed the ship. Records
			confirm the loss of this second ship because the crew was able to escape on vessels in the hangars which
			served as lifeboats for everyone on board. The final ship, the CVS Leviathan-class "Oblivion", survived
			the war and was purchased by Air/Space Combat Escort Services and retrofitted with the latest in space
			military technology. This included drones and upgraded turrets as well as a pair of experimental
			Zero-point lasers mounted at the bow of the vessel. She is powered by six supermatter crystals located
			inside the spire of the vessel's stern which powered the Zero-point lasers. Judging by the layout of
			this ship, I believe this to be the Oblivion. I believe it must have suffered the same fate as we had
			and somehow flown through an ion storm or otherwise lost power midway through its voyage. She was never
			found--until now. I think I know why. All the turrets going haywire and the drones on the fritz must
			have killed off the crew before an SOS could be transmitted. Consequently, all the ship's power is, in
			the same way as ours, unable to power its most costly systems, such as the four hyperdrive engines, or
			the Zero-point lasers (although they can be fired, but at much lower power than should be possible).<br>
			<br>
			I'm sure Gerrard can jury-rig the ship's hyper drive just as he did with the antimatter core. Using parts
			from each of the hyperdrive cores, he could easily get ours working again and get the rest of you home
			safely. If you're worried about pirates, utilize the powerful laser cannons which can be ripped off the
			fighters (I would not recommend trying to take the ship's main defense turrets without shutting them down)
			and fitting them aboard your frigate for self defense. Alternatively, the weapons may be used by hand with
			some simple modifications. Aside from the weapons, you may be able to find more secrets aboard this ship
			if you have the time to search. The A.C.E.S. company was known for participation in high priority smuggling
			operations. Who knows what you could find if you were to rip apart the vessel's interior? Obviously though
			you'd have to kill all the drones first though.<br>
			<br>
			Captain, although this brief journey was a tragic one, it has none the less been an honor serving you.<br>
			<br>
			Thank you for treating me like a person again."}

/obj/item/weapon/paper/salvage/first_mate
	name = "Last words"
	info = {"drone shot me<br>
			<br>
			hard to breathe, feeling faint<br>
			<br>
			Traitor faggot Fergus tried killing me, killed him first, drone got me when I was distracted.<br>
			<br>
			Doc wont pick up radio, Gerrard not responding either. Heard yells on his radio. Told him not to
			have cut power or he'd alert the drones on the borg chargers and wake them. Probably got shot by them
			too.<br>
			<br>
			a bunch of fucking idiots just like my old crew<br>
			<br>
			and now we all die, just like they did, all their fault, but no clones this time<br>
			<br>
			The drone is starting to glitch again. Its going to finish me off this time.<br>
			<br>
			I guess this is it. Fuck you Fergus."}




//Malfunctioning combat drones, now with 100% less exploding! Or all the drones might be dead before players arrive.
/mob/living/simple_animal/hostile/retaliate/defense_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone3"
	icon_living = "drone3"
	icon_dead = "drone_dead"
	ranged = 1
	rapid = 1
	speak_chance = 5
	turns_per_move = 3
	response_help = "pokes the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speak = list("ALERT.","Hostile-ile-ile entities dee-twhoooo-wected.","Threat parameterszzzz- szzet.","Bring sub-sub-sub-systems uuuup to combat alert alpha-a-a.")
	emote_see = list("beeps menacingly","whirrs threateningly","scans its immediate vicinity")
	a_intent = "harm"
	stop_automated_movement_when_pulled = 0
	health = 300
	maxHealth = 300
	speed = 8
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'
	destroy_surroundings = 0
	var/datum/effect/effect/system/ion_trail_follow/ion_trail

	//the drone randomly switches between these states because it's malfunctioning
	var/hostile_drone = 0
	//0 - retaliate, only attack enemies that attack it
	//1 - hostile, attack everything that comes near

	var/turf/patrol_target
//	var/explode_chance = 0
	var/disabled = 0
//	var/exploding = 0

	//Drones aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	var/has_loot = 1
	faction = "defense_drone"

/mob/living/simple_animal/hostile/retaliate/defense_drone/New()
	..()
	if(prob(5))
		projectiletype = /obj/item/projectile/beam/pulse/drone
		projectilesound = 'sound/weapons/pulse2.ogg'
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

/mob/living/simple_animal/hostile/retaliate/defense_drone/Process_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/retaliate/defense_drone/ListTargets()
	if(hostile_drone)
		return view(src, 10)
	else
		return ..()

//self repair systems have a chance to bring the drone back to life
/mob/living/simple_animal/hostile/retaliate/defense_drone/Life()

	//emps and lots of damage can temporarily shut us down
	if(disabled > 0)
		stat = UNCONSCIOUS
		icon_state = "drone_dead"
		disabled--
		wander = 0
		speak_chance = 0
		if(disabled <= 0)
			stat = CONSCIOUS
			icon_state = "drone0"
			wander = 1
			speak_chance = 5

	//repair a bit of damage
	if(prob(1))
		src.visible_message("\red \icon[src] [src] shudders and shakes as some of it's damaged systems come back online.")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		health += rand(25,100)

	//spark for no reason
	if(prob(5))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	//sometimes our targetting sensors malfunction, and we attack anyone nearby
	if(prob(disabled ? 0 : 1))
		if(hostile_drone)
			src.visible_message("\blue \icon[src] [src] retracts several targetting vanes, and dulls it's running lights.")
			hostile_drone = 0
		else
			src.visible_message("\red \icon[src] [src] suddenly lights up, and additional targetting vanes slide into place.")
			hostile_drone = 1

	if(health / maxHealth > 0.9)
		icon_state = "drone3"
//		explode_chance = 0
	else if(health / maxHealth > 0.7)
		icon_state = "drone2"
//		explode_chance = 0
	else if(health / maxHealth > 0.5)
		icon_state = "drone1"
//		explode_chance = 0
	else if(health / maxHealth > 0.3)
		icon_state = "drone0"
//		explode_chance = 0.5
	else if(health > 0)
		//if health gets too low, shut down
		icon_state = "drone_dead"
//		exploding = 0
//		explode_chance = 5
		if(!disabled)
			if(prob(50))
				src.visible_message("\blue \icon[src] [src] suddenly shuts down!")
			else
				src.visible_message("\blue \icon[src] [src] suddenly lies still and quiet.")
			disabled = rand(150, 600)
			walk(src,0)

/*	if(exploding && prob(20))
		if(prob(50))
			src.visible_message("\red \icon[src] [src] begins to spark and shake violenty!")
		else
			src.visible_message("\red \icon[src] [src] sparks and shakes like it's about to explode!")
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()

	if(!exploding && !disabled && prob(explode_chance))
		exploding = 1
		stat = UNCONSCIOUS
		wander = 1
		walk(src,0)
		spawn(rand(50,150))
			if(!disabled && exploding)
				explosion(get_turf(src), 0, 1, 4, 7)
				//proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1)
*/
	..()

//ion rifle!
/mob/living/simple_animal/hostile/retaliate/defense_drone/emp_act(severity)
	health -= rand(3,15) * (severity + 1)
	disabled = rand(150, 600)
	hostile_drone = 0
	walk(src,0)

/mob/living/simple_animal/hostile/retaliate/defense_drone/Die()
	src.visible_message("\blue \icon[src] [src] suddenly breaks apart.")
	..()
	del(src)

/mob/living/simple_animal/hostile/retaliate/defense_drone/Del()
	//some random debris left behind
	if(has_loot)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, src)
		s.start()
		var/obj/O

		//shards
		O = new /obj/item/weapon/shard(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/weapon/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/weapon/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/weapon/shard(src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//rods
		O = new /obj/item/stack/rods(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/rods(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/rods(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/rods(src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//plasteel
		O = new /obj/item/stack/sheet/plasteel(src.loc)
		step_to(O, get_turf(pick(view(7, src))))
		if(prob(75))
			O = new /obj/item/stack/sheet/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(50))
			O = new /obj/item/stack/sheet/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))
		if(prob(25))
			O = new /obj/item/stack/sheet/plasteel(src.loc)
			step_to(O, get_turf(pick(view(7, src))))

		//also drop dummy circuit boards deconstructable for research (loot)
		var/obj/item/weapon/circuitboard/C

		//spawn 1-4 boards of a random type
		var/spawnees = 0
		var/num_boards = rand(1,4)
		var/list/options = list(1,2,4,8,16,32,64,128,256, 512)
		for(var/i=0, i<num_boards, i++)
			var/chosen = pick(options)
			options.Remove(options.Find(chosen))
			spawnees |= chosen

		if(spawnees & 1)
			C = new(src.loc)
			C.name = "Drone CPU motherboard"
			C.origin_tech = "programming=[rand(3,6)]"

		if(spawnees & 2)
			C = new(src.loc)
			C.name = "Drone neural interface"
			C.origin_tech = "biotech=[rand(3,6)]"

		if(spawnees & 4)
			C = new(src.loc)
			C.name = "Drone suspension processor"
			C.origin_tech = "magnets=[rand(3,6)]"

		if(spawnees & 8)
			C = new(src.loc)
			C.name = "Drone shielding controller"
			C.origin_tech = "bluespace=[rand(3,6)]"

		if(spawnees & 16)
			C = new(src.loc)
			C.name = "Drone power capacitor"
			C.origin_tech = "powerstorage=[rand(3,6)]"

		if(spawnees & 32)
			C = new(src.loc)
			C.name = "Drone hull reinforcer"
			C.origin_tech = "materials=[rand(3,6)]"

		if(spawnees & 64)
			C = new(src.loc)
			C.name = "Drone auto-repair system"
			C.origin_tech = "engineering=[rand(3,6)]"

		if(spawnees & 128)
			C = new(src.loc)
			C.name = "Drone plasma overcharge counter"
			C.origin_tech = "plasma=[rand(3,6)]"

		if(spawnees & 256)
			C = new(src.loc)
			C.name = "Drone targetting circuitboard"
			C.origin_tech = "combat=[rand(3,6)]"

		if(spawnees & 512)
			C = new(src.loc)
			C.name = "Corrupted drone morality core"
			C.origin_tech = "illegal=[rand(3,6)]"

	..()