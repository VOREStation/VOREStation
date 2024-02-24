/obj/item/weapon/card/id/event
	var/configured = 0
	var/accessset = 0
	initial_sprite_stack = list()
	var/list/title_strings = list()
	var/preset_rank = FALSE

/obj/item/weapon/card/id/event/attack_self(var/mob/user)
	if(configured == 1)
		return ..()

	if(!preset_rank)
		var/title
		if(user.client.prefs.player_alt_titles[user.job])
			title = user.client.prefs.player_alt_titles[user.job]
		else
			title = user.job
		assignment = title
	user.set_id_info(src)
	if(user.mind && user.mind.initial_account)
		associated_account_number = user.mind.initial_account.account_number
	if(title_strings.len)
		var/tempname = pick(title_strings)
		name = tempname + " ([assignment])"
	else
		name = user.name + "'s ID card" + " ([assignment])"

	configured = 1
	to_chat(user, "<span class='notice'>Card settings set.</span>")

/obj/item/weapon/card/id/event/attackby(obj/item/I as obj, var/mob/user)
	if(istype(I, /obj/item/weapon/card/id) && !accessset)
		var/obj/item/weapon/card/id/O = I
		access |= O.access
		desc = I.desc
		rank = O.rank
		to_chat(user, "<span class='notice'>You copy the access from \the [I] to \the [src].</span>")
		user.drop_from_inventory(I)
		qdel(I)
		accessset = 1
	..()

/obj/item/weapon/card/id/event/accessset
	accessset = 1



/obj/item/weapon/card/id/gold/captain/spare/fakespare
	rank = "null"

/obj/item/weapon/card/id/event/accessset/itg
	name = "identification card"
	desc = "A small card designating affiliation with the Ironcrest Transport Group."
	icon = 'icons/obj/card_vr.dmi'
	base_icon = 'icons/obj/card_vr.dmi'
	icon_state = "itg"

/obj/item/weapon/card/id/event/accessset/itg/green
	icon_state = "itg_green"

/obj/item/weapon/card/id/event/accessset/itg/red
	icon_state = "itg_red"

/obj/item/weapon/card/id/event/accessset/itg/purple
	icon_state = "itg_purple"

/obj/item/weapon/card/id/event/accessset/itg/white
	icon_state = "itg_white"

/obj/item/weapon/card/id/event/accessset/itg/orange
	icon_state = "itg_orange"

/obj/item/weapon/card/id/event/accessset/itg/blue
	icon_state = "itg_blue"

/obj/item/weapon/card/id/event/accessset/itg/crew
	name = "\improper ITG Crew ID"
	assignment = "Crew"
	rank = "Crew"
	access = list(777)
	preset_rank = TRUE

/obj/item/weapon/card/id/event/accessset/itg/crew/pilot
	name = "\improper ITG Pilot's ID"
	desc = "An ID card belonging to the Pilot of an ITG vessel. The Pilot's responsibility is primarily to fly the ship. They may also be tasked to assist with cargo movement duties."
	assignment = "Pilot"
	rank = "Pilot"

/obj/item/weapon/card/id/event/accessset/itg/crew/service
	name = "\improper ITG Cook's ID"
	desc = "An ID card belonging to the Cook of an ITG vessel. The Cook's responsibility is primarily to provide sustinence to the crew and passengers. The Cook answers to the Passenger Liason. In the absence of a Passenger Liason, the Cook is also responsible for tending to passenger related care and duties."
	assignment = "Cook"
	rank = "Cook"
	icon_state = "itg_green"

/obj/item/weapon/card/id/event/accessset/itg/crew/security
	name = "\improper ITG Security's ID"
	desc = "An ID card belonging to Security of an ITG vessel. Security's responsibility is primarily to protect the ship, cargo, or facility. They may also be tasked to assist with cargo movement duties and rescue operations. ITG Security is almost exclusively defensive. They should not start fights, but they are very capable of finishing them."
	assignment = "Security"
	rank = "Security"
	icon_state = "itg_red"

/obj/item/weapon/card/id/event/accessset/itg/crew/research
	name = "\improper ITG Research's ID"
	desc = "An ID card belonging to ITG Research staff. ITG Research staff primarily specializes in starship and starship engine design, and overcoming astronomic phenomena."
	assignment = "Research"
	rank = "Research"
	icon_state = "itg_purple"

/obj/item/weapon/card/id/event/accessset/itg/crew/medical
	name = "\improper ITG Medic's ID"
	desc = "An ID card belonging to the Medic of an ITG vessel. The Medic's responsibility is primarily to treat crew and passenger injuries. They may also be tasked with rescue operations."
	assignment = "Medic"
	rank = "Medic"
	icon_state = "itg_white"

/obj/item/weapon/card/id/event/accessset/itg/crew/engineer
	name = "\improper ITG Engineer's ID"
	desc = "An ID card belonging to the Engineer of an ITG vessel. The Engineer's responsibility is primarily to maintain the ship. They may also be tasked to assist with cargo movement duties."
	assignment = "Engineer"
	rank = "Engineer"
	icon_state = "itg_orange"

/obj/item/weapon/card/id/event/accessset/itg/crew/passengerliason
	name = "\improper ITG Passenger Liason's ID"
	desc = "An ID card belonging to the Passenger Liason of an ITG vessel. The Passenger Liason's responsibility is primarily to manage and tend to passenger needs and maintain supplies and facilities for passenger use."
	assignment = "Passenger Liason"
	rank = "Passenger Liason"
	icon_state = "itg_blue"

/obj/item/weapon/card/id/event/accessset/itg/crew/captain
	name = "\improper ITG Captain's ID"
	desc = "An ID card belonging to the Captain of an ITG vessel. The Captain's responsibility is primarily to manage crew to ensure smooth ship operations. Captains often also often pilot the vessel when no dedicated pilot is assigned."
	assignment = "Captain"
	rank = "Captain"
	icon_state = "itg_blue"
	access = list(777, 778)

/obj/item/weapon/card/id/event/altcard
	icon = 'icons/obj/card_alt_vr.dmi'
	base_icon = 'icons/obj/card_alt_vr.dmi'
	icon_state = "id"

/obj/item/weapon/card/id/event/altcard/spare
	icon_state = "spare"

/obj/item/weapon/card/id/event/altcard/clown
	icon_state = "Clown"

/obj/item/weapon/card/id/event/altcard/mime
	icon_state = "Mime"

/obj/item/weapon/card/id/event/altcard/centcom
	icon_state = "CentCom Officer"

/obj/item/weapon/card/id/event/altcard/ert
	icon_state = "Emergency Responder"

/obj/item/weapon/card/id/event/altcard/nt
	icon_state = "nanotrasen"

/obj/item/weapon/card/id/event/altcard/syndiegold
	icon_state = "syndieGold"

/obj/item/weapon/card/id/event/altcard/syndie
	icon_state = "syndie"

/obj/item/weapon/card/id/event/altcard/greengold
	icon_state = "greenGold"

/obj/item/weapon/card/id/event/altcard/pink
	icon_state = "pink"

/obj/item/weapon/card/id/event/altcard/pinkgold
	icon_state = "pinkGold"

/obj/item/weapon/card/id/event/polymorphic
	var/base_icon_state

/obj/item/weapon/card/id/event/polymorphic/digest_act(atom/movable/item_storage = null)
	var/gimmeicon = icon
	. = ..()
	icon = gimmeicon
	icon_state = base_icon_state + "_digested"

/obj/item/weapon/card/id/event/polymorphic/altcard/attack_self(var/mob/user)
	if(configured == 1)
		return ..()
	else
		icon_state = user.job
		base_icon_state = user.job
		return ..()

/obj/item/weapon/card/id/event/polymorphic/altcard
	icon = 'icons/obj/card_alt_vr.dmi'
	base_icon = 'icons/obj/card_alt_vr.dmi'
	icon_state = "blank"
	name = "contractor identification card"
	desc = "An ID card typically used by contractors."

/obj/item/weapon/card/id/event/polymorphic/itg/attack_self(var/mob/user)
	if(!configured)
		var/list/jobs_to_icon = list( //ITG only has a few kinds of icons so we have to group them up!
		"Pilot" = "itg",
		"Visitor" = "itg",
		"Quartermaster" = "itg",
		"Cargo Technician" = "itg",
		"Shaft Miner" = "itg",
		"Intern" = "itg",
		"Talon Pilot" = "itg",
		"Talon Miner" = "itg",
		"Bartender" = "itg_green",
		"Botanist" = "itg_green",
		"Chef" = "itg_green",
		"Janitor" = "itg_green",
		"Chaplain" = "itg_green",
		"Entertainer" = "itg_green",
		"Janitor" = "itg_green",
		"Librarian" = "itg_green",
		"Warden" = "itg_red",
		"Detective" = "itg_red",
		"Security Officer" = "itg_red",
		"Talon Guard" = "itg_red",
		"Roboticist" = "itg_purple",
		"Scientist" = "itg_purple",
		"Xenobiologist" = "itg_purple",
		"Xenobotanist" = "itg_purple",
		"Pathfinder" = "itg_purple",
		"Explorer" = "itg_purple",
		"Chemist" = "itg_white",
		"Medical Doctor" = "itg_white",
		"Paramedic" = "itg_white",
		"Psychiatrist" = "itg_white",
		"Field Medic" = "itg_white",
		"Talon Doctor" = "itg_white",
		"Atmospheric Technician" = "itg_orange",
		"Engineer" = "itg_orange",
		"Off-duty Officer" = "itg_red",
		"Off-duty Engineer" = "itg_orange",
		"Off-duty Medic" = "itg_white",
		"Off-duty Scientist" = "itg_purple",
		"Off-duty Cargo" = "itg",
		"Off-duty Explorer" = "itg_purple",
		"Off-duty Worker" = "itg_green"
		)
		var/guess = jobs_to_icon[user.job]

		if(!guess)
			to_chat(user, "<span class='notice'>ITG Cards do not seem to be able to accept the access codes for your ID.</span>")
			return
		else
			icon_state = guess
			base_icon_state = guess
	. = ..()
	name = user.name + "'s ITG ID card" + " ([assignment])"


/obj/item/weapon/card/id/event/polymorphic/itg/attackby(obj/item/I as obj, var/mob/user)
	if(istype(I, /obj/item/weapon/card/id) && !accessset)
		var/obj/item/weapon/card/id/O = I
		var/list/itgdont = list("Site Manager", "Head of Personnel", "Command Secretary", "Head of Security", "Chief Engineer", "Chief Medical Officer", "Research Director", "Clown", "Mime", "Talon Captain") //If you're in as one of these you probably aren't representing ITG
		if(O.rank in itgdont)
			to_chat(user, "<span class='notice'>ITG Cards do not seem to be able to accept the access codes for your ID.</span>")
			return
	. = ..()
	desc = "A small card designating affiliation with the Ironcrest Transport Group. It has a NanoTrasen insignia and a lot of very small print on the back to do with practices and regulations for contractors to use."


/obj/item/weapon/card/id/event/polymorphic/itg
	icon = 'icons/obj/card_vr.dmi'
	base_icon = 'icons/obj/card_vr.dmi'
	icon_state = "itg"
	name = "\improper ITG identification card"
	desc = "A small card designating affiliation with the Ironcrest Transport Group. It has a NanoTrasen insignia and a lot of very small print on the back to do with practices and regulations for contractors to use."
