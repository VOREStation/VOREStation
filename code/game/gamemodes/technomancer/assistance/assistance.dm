/datum/technomancer/assistance
	var/one_use_only = 0

/datum/technomancer/assistance/apprentice
	name = "Friendly Apprentice"
	desc = "A one-time use teleporter that sends a less powerful manipulator of space to you, who will do their best to protect \
	and serve you.  They get their own catalog and can buy spells for themselves, however they have a smaller pool to buy with.  \
	If you are unable to receive an apprentice, the teleporter can be refunded like most equipment by sliding it into the \
	catalog.  Note that apprentices cannot purchase more apprentices."
	cost = 300
	obj_path = /obj/item/antag_spawner/technomancer_apprentice

/*
// For when no one wants to play support.
/datum/technomancer/assistance/golem
	name = "Friendly GOLEM unit"
	desc = "Teleports a specially designed synthetic unit to you, which is very durable, has an advanced AI, and can also use \
	functions.  It knows Shield, Targeted Blink, Beam, Mend Life, Mend Synthetic, Lightning, Repel Missiles, Corona, Ionic Bolt, Dispel, and Chain Lightning.  \
	It also has a large storage capacity for energy, and due to it's synthetic nature, instability is less of an issue for them."
	cost = 350
	obj_path = null //TODO
	one_use_only = 1

/datum/technomancer/assistance/ninja
	name = "Neutral Cyberassassin"
	desc = "Someone almost as enigmatic as you will also arrive at your destination, with their own goals and motivations.  \
	This could prove to be a problem if they decide to go against you, so this is only recommended as a challenge."
	cost = 100
	obj_path = null //TODO
	one_use_only = 1

// Hardmode.
/datum/technomancer/assistance/enemy_technomancer
	name = "Enemy Technomancer"
	desc = "Another manipulator of space will arrive on the colony in addition to you, most likely wanting to oppose you in \
	some form, if you purchase this.  This is only recommended as a challenge."
	cost = 100
	obj_path = null //TODO
	one_use_only = 1
*/