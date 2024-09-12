// This is a defines file for card sprite stacks. If a new card set comes in, this file can just be disabled and a new one made to match the new sprites.
// Generally, if the icon file is card_xxx.dmi, this filename should be sprite_stacks_xxx.dm
// Please make sure that only the relevant sprite_stacks_xxx.file is included, if more are made.

/obj/item/weapon/card
	icon = 'icons/obj/card_new_vr.dmi' // These are redefined here so that changing sprites is as easy as clicking the checkbox.
	base_icon = 'icons/obj/card_new_vr.dmi'

	// New sprite stacks can be defined here. You could theoretically change icon-states as well but right now this file compiles before station_ids.dm so those wouldn't be affected.

//IDs

/obj/item/weapon/card/id
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n")

/obj/item/weapon/card/id/generic
	name = "Generic ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-silhouette", "clip")

//Central

/obj/item/weapon/card/id/centcom
	name = "Central Command ID"
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n", "pips-white", "stripe-gold")

/obj/item/weapon/card/id/centcom/vip
	name = "VIP ID"
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n", "pips-gold", "stripe-gold")

//ERT

/obj/item/weapon/card/id/centcom/ERT
	name = "Emergency Responder ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-red", "stripe-red")

/obj/item/weapon/card/id/centcom/ERT/medic
	name = "Emergency Medical Responder ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-medblu", "stripe-medblu")

/obj/item/weapon/card/id/centcom/ERT/commander
	name = "Emergency Response Commander ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-gold", "stripe-gold")

/obj/item/weapon/card/id/centcom/ERT/engineer
	name = "Emergency Engineering Responder ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-orange", "stripe-orange")

/obj/item/weapon/card/id/centcom/ERT/janitor
	name = "Emergency Cleanup Responder ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-purple", "stripe-purple")

//Silver

/obj/item/weapon/card/id/silver
	name = "Silver ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n")

/obj/item/weapon/card/id/silver/secretary
	name = "Secretary's ID"
	initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n")
	rank = JOB_COMMAND_SECRETARY

/obj/item/weapon/card/id/silver/hop
	name = JOB_HEAD_OF_PERSONNEL + " ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-gold")
	rank = JOB_HEAD_OF_PERSONNEL

//Gold

/obj/item/weapon/card/id/gold
	name = "Gold ID"
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n")

/obj/item/weapon/card/id/gold/captain
	name = "Captain's ID"
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n", "pips-gold")

/obj/item/weapon/card/id/gold/captain/spare
	name = "Spare ID"
	initial_sprite_stack = list("base-stamp-gold", "top-gold", "stamp-n")
	rank = JOB_SITE_MANAGER

//Medical

/obj/item/weapon/card/id/medical
	name = "Medical ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n")

/obj/item/weapon/card/id/medical/chemist
	name = "Chemist's ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-orange")

/obj/item/weapon/card/id/medical/geneticist
	name = "Geneticist's ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-purple")

/obj/item/weapon/card/id/medical/psych
	name = "Psychologist's ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-brown")

/obj/item/weapon/card/id/medical/virologist
	name = "Virologist's ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-green")

/obj/item/weapon/card/id/medical/emt
	name = "Emergency Medical Technician's ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-blue")

/obj/item/weapon/card/id/medical/head
	name = "Chief Medical Officer's ID"
	initial_sprite_stack = list("base-stamp-silver", "top-medblu", "stamp-n", "pips-gold")

//Security

/obj/item/weapon/card/id/security
	name = "Security ID"
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n")
	rank = JOB_SECURITY_OFFICER

/obj/item/weapon/card/id/security/detective
	name = JOB_DETECTIVE + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n", "stripe-brown")
	rank = JOB_DETECTIVE

/obj/item/weapon/card/id/security/warden
	name = JOB_WARDEN + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n", "stripe-white")
	rank = JOB_WARDEN

/obj/item/weapon/card/id/security/head
	name = JOB_HEAD_OF_SECURITY + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-red", "stamp-n", "pips-gold")
	rank = JOB_HEAD_OF_SECURITY

//Engineering

/obj/item/weapon/card/id/engineering
	name = "Engineering ID"
	initial_sprite_stack = list("base-stamp", "top-orange", "stamp-n")
	rank = JOB_ENGINEER

/obj/item/weapon/card/id/engineering/atmos
	name = "Atmospherics ID"
	initial_sprite_stack = list("base-stamp", "top-orange", "stripe-medblu", "stamp-n")
	rank = JOB_ATMOSPHERIC_TECHNICIAN

/obj/item/weapon/card/id/engineering/head
	name = JOB_CHIEF_ENGINEER + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-orange", "stamp-n", "pips-gold")
	rank = JOB_CHIEF_ENGINEER

//Science

/obj/item/weapon/card/id/science
	name = "Science ID"
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n")

/obj/item/weapon/card/id/science/roboticist
	name = "Roboticist's ID"
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n", "stripe-brown")

/obj/item/weapon/card/id/science/xenobiologist
	name = "Xenobiologist's ID"
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n", "stripe-orange")

/obj/item/weapon/card/id/science/xenobotanist
	name = "Xenobotanist's ID"
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n", "stripe-green")

/obj/item/weapon/card/id/science/head
	name = JOB_RESEARCH_DIRECTOR + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-purple", "stamp-n", "pips-gold")
	rank = JOB_RESEARCH_DIRECTOR

//Cargo

/obj/item/weapon/card/id/cargo
	name = "Cargo ID"
	initial_sprite_stack = list("base-stamp", "top-brown", "stamp-n")

/obj/item/weapon/card/id/cargo/miner
	name = "Miner's ID"
	initial_sprite_stack = list("base-stamp", "top-brown", "stamp-n", "stripe-purple")
	rank = JOB_SHAFT_MINER

/obj/item/weapon/card/id/cargo/head
	name = "Quartermaster's ID"
	initial_sprite_stack = list("base-stamp-silver", "top-brown", "stamp-n", "pips-white")

//Civilian

/obj/item/weapon/card/id/civilian
	name = "Civilian ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n")

/obj/item/weapon/card/id/civilian/chaplain
	name = "Chaplain's ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-cross", "stripe-white")

/obj/item/weapon/card/id/civilian/journalist
	name = "Journalist's ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "stripe-red")

/obj/item/weapon/card/id/civilian/pilot
	name = "Pilot's ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "stripe-olive")

/obj/item/weapon/card/id/civilian/entertainer
	name = "Entertainer's ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "stripe-brown")

/obj/item/weapon/card/id/civilian/entrepreneur
	name = "Entrepreneur's ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "stripe-gold")

/obj/item/weapon/card/id/civilian/clown
	name = "Clown's ID"
	initial_sprite_stack = list("base-stamp", "top-rainbow", "stamp-n")

/obj/item/weapon/card/id/civilian/mime
	name = "Mime's ID"
	initial_sprite_stack = list("base-stamp", "top-white", "stamp-n", "stripe-black")

/obj/item/weapon/card/id/civilian/internal_affairs
	name = "Internal Affairs ID"
	initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n", "stripe-black")

//Service

/obj/item/weapon/card/id/civilian/service
	name = "Service ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n")

/obj/item/weapon/card/id/civilian/service/botanist
	name = "Botanist's ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "stripe-darkgreen")

/obj/item/weapon/card/id/civilian/service/bartender
	name = "Bartender's ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "stripe-black")

/obj/item/weapon/card/id/civilian/service/chef
	name = "Chef's ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "stripe-white")

/obj/item/weapon/card/id/civilian/service/janitor
	name = "Janitor's ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "stripe-purple")

//Exploration

/obj/item/weapon/card/id/exploration
	name = "Exploration ID"
	initial_sprite_stack = list("base-stamp", "top-olive", "stamp-n")

/obj/item/weapon/card/id/exploration/fm
	name = "Field Medic's ID"
	initial_sprite_stack = list("base-stamp", "top-olive", "stamp-n", "stripe-medblu")

/obj/item/weapon/card/id/exploration/head
	name = "Pathfinder's ID"
	initial_sprite_stack = list("base-stamp-silver", "top-olive", "stamp-n", "pips-white")

//Talon

/obj/item/weapon/card/id/talon
	name = "Talon ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette")

/obj/item/weapon/card/id/talon/doctor
	name = "Talon Medical ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-medblu", "stripe-medblu")

/obj/item/weapon/card/id/talon/engineer
	name = "Talon Engineering ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-orange", "stripe-orange")

/obj/item/weapon/card/id/talon/officer
	name = "Talon Security ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-red", "stripe-red")

/obj/item/weapon/card/id/talon/pilot
	name = "Talon Pilot ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-purple", "stripe-purple")

/obj/item/weapon/card/id/talon/miner
	name = "Talon Mining ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-brown", "stripe-brown")

/obj/item/weapon/card/id/talon/captain
	name = "Talon Captain ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-gold", "stripe-gold")

//Antags

/obj/item/weapon/card/id/syndicate
	name = "Syndicate ID"
	initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s")

/obj/item/weapon/card/id/syndicate/officer
	name = "Syndicate Officer ID"
	initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s", "pips-gold", "stripe-gold")
