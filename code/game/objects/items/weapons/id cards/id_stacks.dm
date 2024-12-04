// This is a defines file for card sprite stacks. If a new card set comes in, this file can just be disabled and a new one made to match the new sprites.
// Generally, if the icon file is card_xxx.dmi, this filename should be sprite_stacks_xxx.dm
// Please make sure that only the relevant sprite_stacks_xxx.file is included, if more are made.

/obj/item/card
	icon = 'icons/obj/card_new_vr.dmi' // These are redefined here so that changing sprites is as easy as clicking the checkbox.
	base_icon = 'icons/obj/card_new_vr.dmi'

	// New sprite stacks can be defined here. You could theoretically change icon-states as well but right now this file compiles before station_ids.dm so those wouldn't be affected.

//IDs

/obj/item/card/id
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n")

/obj/item/card/id/generic
	name = "Generic ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-silhouette", "clip")

//Central

/obj/item/card/id/centcom
	name = "Central Command ID"
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n", "pips-white", "stripe-gold")

/obj/item/card/id/centcom/vip
	name = "VIP ID"
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n", "pips-gold", "stripe-gold")

//ERT

/obj/item/card/id/centcom/ERT
	name = "Emergency Responder ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-red", "stripe-red")

/obj/item/card/id/centcom/ERT/medic
	name = "Emergency Medical Responder ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-medblu", "stripe-medblu")

/obj/item/card/id/centcom/ERT/commander
	name = "Emergency Response Commander ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-gold", "stripe-gold")

/obj/item/card/id/centcom/ERT/engineer
	name = "Emergency Engineering Responder ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-orange", "stripe-orange")

/obj/item/card/id/centcom/ERT/janitor
	name = "Emergency Cleanup Responder ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-purple", "stripe-purple")

//Silver

/obj/item/card/id/silver
	name = "Silver ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n")

/obj/item/card/id/silver/secretary
	name = "Secretary's ID"
	initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n")
	rank = JOB_COMMAND_SECRETARY

/obj/item/card/id/silver/hop
	name = JOB_HEAD_OF_PERSONNEL + " ID"
	initial_sprite_stack = list("base-stamp-silver", "top-blue", "stamp-n", "pips-gold")
	rank = JOB_HEAD_OF_PERSONNEL

//Gold

/obj/item/card/id/gold
	name = "Gold ID"
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n")

/obj/item/card/id/gold/captain
	name = "Captain's ID"
	initial_sprite_stack = list("base-stamp-gold", "top-blue", "stamp-n", "pips-gold")
	rank = JOB_SITE_MANAGER

/obj/item/card/id/gold/captain/spare
	name = "Spare ID"
	initial_sprite_stack = list("base-stamp-gold", "top-gold", "stamp-n")
	rank = JOB_SITE_MANAGER

//Medical

/obj/item/card/id/medical
	name = "Medical ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n")
	rank = JOB_MEDICAL_DOCTOR

/obj/item/card/id/medical/chemist
	name = JOB_CHEMIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-orange")
	rank = JOB_CHEMIST

/obj/item/card/id/medical/geneticist
	name = JOB_GENETICIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-purple")
	rank = JOB_GENETICIST

/obj/item/card/id/medical/psych
	name = JOB_ALT_PSYCHOLOGIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-brown")
	rank = JOB_PSYCHIATRIST

/obj/item/card/id/medical/virologist
	name = JOB_ALT_VIROLOGIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-green")
	rank = JOB_ALT_VIROLOGIST

/obj/item/card/id/medical/emt
	name = JOB_ALT_EMERGENCY_MEDICAL_TECHNICIAN + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-medblu", "stamp-n", "stripe-blue")
	rank = JOB_PARAMEDIC

/obj/item/card/id/medical/head
	name = JOB_CHIEF_MEDICAL_OFFICER + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-medblu", "stamp-n", "pips-gold")
	rank = JOB_CHIEF_MEDICAL_OFFICER

//Security

/obj/item/card/id/security
	name = "Security ID"
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n")
	rank = JOB_SECURITY_OFFICER

/obj/item/card/id/security/detective
	name = JOB_DETECTIVE + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n", "stripe-brown")
	rank = JOB_DETECTIVE

/obj/item/card/id/security/warden
	name = JOB_WARDEN + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-red", "stamp-n", "stripe-white")
	rank = JOB_WARDEN

/obj/item/card/id/security/head
	name = JOB_HEAD_OF_SECURITY + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-red", "stamp-n", "pips-gold")
	rank = JOB_HEAD_OF_SECURITY

//Engineering

/obj/item/card/id/engineering
	name = "Engineering ID"
	initial_sprite_stack = list("base-stamp", "top-orange", "stamp-n")
	rank = JOB_ENGINEER

/obj/item/card/id/engineering/atmos
	name = "Atmospherics ID"
	initial_sprite_stack = list("base-stamp", "top-orange", "stripe-medblu", "stamp-n")
	rank = JOB_ATMOSPHERIC_TECHNICIAN

/obj/item/card/id/engineering/head
	name = JOB_CHIEF_ENGINEER + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-orange", "stamp-n", "pips-gold")
	rank = JOB_CHIEF_ENGINEER

//Science

/obj/item/card/id/science
	name = "Science ID"
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n")
	rank = JOB_SCIENTIST

/obj/item/card/id/science/roboticist
	name = JOB_ROBOTICIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n", "stripe-brown")
	rank = JOB_ROBOTICIST

/obj/item/card/id/science/xenobiologist
	name = JOB_XENOBIOLOGIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n", "stripe-orange")
	rank = JOB_XENOBIOLOGIST

/obj/item/card/id/science/xenobotanist
	name = JOB_XENOBOTANIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-purple", "stamp-n", "stripe-green")
	rank = JOB_XENOBOTANIST

/obj/item/card/id/science/head
	name = JOB_RESEARCH_DIRECTOR + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-purple", "stamp-n", "pips-gold")
	rank = JOB_RESEARCH_DIRECTOR

//Cargo

/obj/item/card/id/cargo
	name = "Cargo ID"
	initial_sprite_stack = list("base-stamp", "top-brown", "stamp-n")
	rank = JOB_CARGO_TECHNICIAN

/obj/item/card/id/cargo/miner
	name = "Miner's ID"
	initial_sprite_stack = list("base-stamp", "top-brown", "stamp-n", "stripe-purple")
	rank = JOB_SHAFT_MINER

/obj/item/card/id/cargo/head
	name = JOB_QUARTERMASTER + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-brown", "stamp-n", "pips-white")
	rank = JOB_QUARTERMASTER

//Civilian

/obj/item/card/id/civilian
	name = "Civilian ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n")

/obj/item/card/id/civilian/chaplain
	name = JOB_CHAPLAIN + "'s ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-cross", "stripe-white")
	rank = JOB_CHAPLAIN

/obj/item/card/id/civilian/journalist
	name = JOB_ALT_JOURNALIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "stripe-red")
	rank = JOB_ALT_JOURNALIST

/obj/item/card/id/civilian/pilot
	name = JOB_PILOT + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "stripe-olive")
	rank = JOB_PILOT

/obj/item/card/id/civilian/entertainer
	name = JOB_ENTERTAINER + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "stripe-brown")
	rank = JOB_ENTERTAINER

/obj/item/card/id/civilian/entrepreneur
	name = JOB_ENTREPRENEUR + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-generic", "stamp-n", "stripe-gold")
	rank = JOB_ENTREPRENEUR

/obj/item/card/id/civilian/clown
	name = JOB_CLOWN + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-rainbow", "stamp-n")
	rank = JOB_CLOWN

/obj/item/card/id/civilian/mime
	name = JOB_MIME + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-white", "stamp-n", "stripe-black")
	rank = JOB_MIME

/obj/item/card/id/civilian/internal_affairs
	name = "Internal Affairs ID"
	initial_sprite_stack = list("base-stamp", "top-blue", "stamp-n", "stripe-black")
	rank = JOB_INTERNAL_AFFAIRS_AGENT

//Service

/obj/item/card/id/civilian/service
	name = "Service ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n")

/obj/item/card/id/civilian/service/botanist
	name = JOB_BOTANIST + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "stripe-darkgreen")
	rank = JOB_BOTANIST

/obj/item/card/id/civilian/service/bartender
	name = JOB_BARTENDER + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "stripe-black")
	rank = JOB_BARTENDER

/obj/item/card/id/civilian/service/chef
	name = JOB_CHEF + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "stripe-white")
	rank = JOB_CHEF

/obj/item/card/id/civilian/service/janitor
	name = JOB_JANITOR + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-green", "stamp-n", "stripe-purple")
	rank = JOB_JANITOR

//Exploration

/obj/item/card/id/exploration
	name = "Exploration ID"
	initial_sprite_stack = list("base-stamp", "top-olive", "stamp-n")
	rank = JOB_EXPLORER

/obj/item/card/id/exploration/fm
	name = JOB_FIELD_MEDIC + "'s ID"
	initial_sprite_stack = list("base-stamp", "top-olive", "stamp-n", "stripe-medblu")
	rank = JOB_FIELD_MEDIC

/obj/item/card/id/exploration/head
	name = JOB_PATHFINDER + "'s ID"
	initial_sprite_stack = list("base-stamp-silver", "top-olive", "stamp-n", "pips-white")
	rank = JOB_PATHFINDER

//Talon

/obj/item/card/id/talon
	name = "Talon ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette")

/obj/item/card/id/talon/doctor
	name = "Talon Medical ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-medblu", "stripe-medblu")
	rank = JOB_TALON_DOCTOR

/obj/item/card/id/talon/engineer
	name = "Talon Engineering ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-orange", "stripe-orange")
	rank = JOB_TALON_ENGINEER

/obj/item/card/id/talon/officer
	name = "Talon Security ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-red", "stripe-red")
	rank = JOB_TALON_GUARD

/obj/item/card/id/talon/pilot
	name = JOB_TALON_PILOT + " ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-purple", "stripe-purple")
	rank = JOB_TALON_PILOT

/obj/item/card/id/talon/miner
	name = "Talon Mining ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-brown", "stripe-brown")
	rank = JOB_TALON_MINER

/obj/item/card/id/talon/captain
	name = JOB_TALON_CAPTAIN + " ID"
	initial_sprite_stack = list("base-stamp-dark", "top-dark", "stamp-silhouette", "pips-gold", "stripe-gold")
	rank = JOB_TALON_CAPTAIN

//Antags

/obj/item/card/id/syndicate
	name = "Syndicate ID"
	initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s")
	rank = JOB_SYNDICATE

/obj/item/card/id/syndicate/officer
	name = "Syndicate Officer ID"
	initial_sprite_stack = list("base-stamp-dark", "top-syndicate", "stamp-s", "pips-gold", "stripe-gold")

//Special

/obj/item/card/id/civilian/lurker
	name = "Outdated ID"
	initial_sprite_stack = list("base-stamp", "stamp-silhouette", "top-olive", "digested")
