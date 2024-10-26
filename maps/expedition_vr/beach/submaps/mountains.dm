// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so CI can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#ifdef MAP_TEST
#include "deadBeacon.dmm"
#include "prepper1.dmm"
#include "quarantineshuttle.dmm"
#include "Mineshaft1.dmm"
#include "Scave1.dmm"
#include "crashed_ufo.dmm"
#include "crashed_ufo_frigate.dmm"
#include "crystal1.dmm"
#include "crystal2.dmm"
#include "crystal3.dmm"
#include "lost_explorer.dmm"
#include "CaveTrench.dmm"
#include "Cavelake.dmm"
#include "Rockb1.dmm"
#include "ritual.dmm"
#include "temple.dmm"
#include "CrashedMedShuttle1.dmm"
#include "digsite.dmm"
#include "vault1.dmm"
#include "vault2.dmm"
#include "vault3.dmm"
#include "vault4.dmm"
#include "vault5.dmm"
#include "vault6.dmm"
#include "IceCave1A.dmm"
#include "IceCave1B.dmm"
#include "IceCave1C.dmm"
#include "SwordCave.dmm"
#include "SupplyDrop1.dmm"
#include "BlastMine1.dmm"
#include "crashedcontainmentshuttle.dmm"
#include "deadspy.dmm"
#include "lava_trench.dmm"
#include "Geyser1.dmm"
#include "Geyser2.dmm"
#include "Geyser3.dmm"
#include "Cliff1.dmm"
#include "excavation1.dmm"
#include "spatial_anomaly.dmm"
#include "speakeasy_vr.dmm"
#endif

// The 'mountains' is the mining z-level, and has a lot of caves.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The bottom half should be fairly tame, with perhaps a few enviromental hazards.
// The top half is when things start getting dangerous, but the loot gets better.

/datum/map_template/surface/mountains
	name = "Mountain Content"
	desc = "Don't dig too deep!"

// 'Normal' templates get used on the bottom half, and should be safer.
/datum/map_template/surface/mountains/normal

// 'Deep' templates get used on the top half, and should be more dangerous and rewarding.
/datum/map_template/surface/mountains/deep

// To be added: Templates for cave exploration when they are made.

/****************
 * Normal Caves *
 ****************/

/datum/map_template/surface/mountains/normal/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	mappath = "maps/expedition_vr/beach/submaps/deadBeacon.dmm"
	cost = 10

/datum/map_template/surface/mountains/normal/prepper1
	name = "Prepper Bunker"
	desc = "A little hideaway for someone with more time and money than sense."
	mappath = "maps/expedition_vr/beach/submaps/prepper1.dmm"
	cost = 10

/datum/map_template/surface/mountains/normal/qshuttle
	name = "Quarantined Shuttle"
	desc = "An emergency landing turned viral outbreak turned tragedy."
	mappath = "maps/expedition_vr/beach/submaps/quarantineshuttle.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/Mineshaft1
	name = "Abandoned Mineshaft 1"
	desc = "An abandoned minning tunnel from a lost money making effort."
	mappath = "maps/expedition_vr/beach/submaps/Mineshaft1.dmm"
	cost = 5

/datum/map_template/surface/mountains/normal/crystal1
	name = "Crystal Cave 1"
	desc = "A small cave with glowing gems and diamonds."
	mappath = "maps/expedition_vr/beach/submaps/crystal1.dmm"
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/crystal2
	name = "Crystal Cave 2"
	desc = "A moderate sized cave with glowing gems and diamonds."
	mappath = "maps/expedition_vr/beach/submaps/crystal2.dmm"
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/crystal2
	name = "Crystal Cave 3"
	desc = "A large spiral of crystals with diamonds in the center."
	mappath = "maps/expedition_vr/beach/submaps/crystal3.dmm"
	cost = 15

/datum/map_template/surface/mountains/normal/lost_explorer
	name = "Lost Explorer"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment."
	mappath = "maps/expedition_vr/beach/submaps/lost_explorer.dmm"
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/Rockb1
	name = "Rocky Base 1"
	desc = "Someones underground hidey hole"
	mappath = "maps/expedition_vr/beach/submaps/Rockb1.dmm"
	cost = 15

/datum/map_template/surface/mountains/normal/corgiritual
	name = "Dark Ritual"
	desc = "Who put all these plushies here? What are they doing?"
	mappath = "maps/expedition_vr/beach/submaps/ritual.dmm"
	cost = 15

/datum/map_template/surface/mountains/normal/abandonedtemple
	name = "Abandoned Temple"
	desc = "An ancient temple, long since abandoned. Perhaps alien in origin?"
	mappath = "maps/expedition_vr/beach/submaps/temple.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/digsite
	name = "Dig Site"
	desc = "A small abandoned dig site."
	mappath = "maps/expedition_vr/beach/submaps/digsite.dmm"
	cost = 10

/datum/map_template/surface/mountains/normal/vault1
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	mappath = "maps/expedition_vr/beach/submaps/vault1.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/vault2
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	mappath = "maps/expedition_vr/beach/submaps/vault2.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/vault3
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	mappath = "maps/expedition_vr/beach/submaps/vault3.dmm"
	cost = 15
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/IceCave1A
	name = "Ice Cave 1A"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = "maps/expedition_vr/beach/submaps/IceCave1A.dmm"
	cost = 10

/datum/map_template/surface/mountains/normal/IceCave1B
	name = "Ice Cave 1B"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = "maps/expedition_vr/beach/submaps/IceCave1B.dmm"
	cost = 10

/datum/map_template/surface/mountains/normal/IceCave1C
	name = "Ice Cave 1C"
	desc = "This cave's slippery ice makes it hard to navigate, but determined explorers will be rewarded."
	mappath = "maps/expedition_vr/beach/submaps/IceCave1C.dmm"
	cost = 10

/datum/map_template/surface/mountains/normal/SwordCave
	name = "Cursed Sword Cave"
	desc = "An underground lake. The sword on the lake's island holds a terrible secret."
	mappath = "maps/expedition_vr/beach/submaps/SwordCave.dmm"

/datum/map_template/surface/mountains/normal/supplydrop1
	name = "Supply Drop 1"
	desc = "A drop pod that landed deep within the mountains."
	mappath = "maps/expedition_vr/beach/submaps/SupplyDrop1.dmm"
	cost = 10
	allow_duplicates = TRUE

/datum/map_template/surface/mountains/normal/crashedcontainmentshuttle
	name = "Crashed Cargo Shuttle"
	desc = "A severely damaged military shuttle, its cargo seems to remain intact."
	mappath = "maps/expedition_vr/beach/submaps/crashedcontainmentshuttle.dmm"
	cost = 30

/datum/map_template/surface/mountains/normal/deadspy
	name = "Spy Remains"
	desc = "W+M1 = Salt."
	mappath = "maps/expedition_vr/beach/submaps/deadspy.dmm"
	cost = 15

/datum/map_template/surface/mountains/normal/geyser1
	name = "Ore-Rich Geyser"
	desc = "A subterranean geyser that produces steam. This one has a particularly abundant amount of materials surrounding it."
	mappath = "maps/expedition_vr/beach/submaps/Geyser1.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/surface/mountains/normal/geyser2
	name = "Fenced Geyser"
	desc = "A subterranean geyser that produces steam. This one has a damaged fence surrounding it."
	mappath = "maps/expedition_vr/beach/submaps/Geyser2.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/surface/mountains/normal/geyser3
	name = "Magmatic Geyser"
	desc = "A subterranean geyser that produces incendiary gas. It is recessed into the ground, and filled with magma. It's a relatively dormant volcano."
	mappath = "maps/expedition_vr/beach/submaps/Geyser2.dmm"
	cost = 10
	allow_duplicates = TRUE
	template_group = "Underground Geysers"

/datum/map_template/surface/mountains/normal/cliff1
	name = "Ore-Topped Cliff"
	desc = "A raised area of rock created by volcanic forces."
	mappath = "maps/expedition_vr/beach/submaps/Cliff1.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Underground Cliffs"

/datum/map_template/surface/mountains/normal/deadly_rabbit // VOREStation Edit
	name = "The Killer Rabbit"
	desc = "A cave where the Knights of the Round have fallen to a murderous Rabbit."
	mappath = "maps/expedition_vr/beach/submaps/deadly_rabbit_vr.dmm"
	cost = 5
	allow_duplicates = FALSE

/**************
 * Deep Caves *
 **************/

/* Vorestation Removal
/datum/map_template/surface/mountains/deep/lost_explorer
	name = "Lost Explorer, Deep"
	desc = "The remains of an explorer who rotted away ages ago, and their equipment. Again."
	mappath = "maps/expedition_vr/beach/submaps/lost_explorer.dmm"
	cost = 5
	allow_duplicates = TRUE */

/datum/map_template/surface/mountains/normal/crashed_ufo //VOREStation Edit
	name = "Crashed UFO"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet it still seems to be running..."
	mappath = "maps/expedition_vr/beach/submaps/crashed_ufo.dmm"
	cost = 40
	discard_prob = 50

/datum/map_template/surface/mountains/normal/crashed_ufo_frigate //VOREStation Edit
	name = "Crashed UFO Frigate"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet the combat protocols still seem to be running..."
	mappath = "maps/expedition_vr/beach/submaps/crashed_ufo_frigate.dmm"
	cost = 60
	discard_prob = 50

/datum/map_template/surface/mountains/normal/Scave1 //VOREStation Edit
	name = "Spider Cave 1"
	desc = "A minning tunnel home to an aggressive collection of spiders."
	mappath = "maps/expedition_vr/beach/submaps/Scave1.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/CaveTrench //VOREStation Edit
	name = "Cave River"
	desc = "A strange underground river."
	mappath = "maps/expedition_vr/beach/submaps/CaveTrench.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/Cavelake //VOREStation Edit
	name = "Cave Lake"
	desc = "A large underground lake."
	mappath = "maps/expedition_vr/beach/submaps/Cavelake.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/vault1 //VOREStation Edit
	name = "Mine Vault 1"
	desc = "A small vault with potential loot."
	mappath = "maps/expedition_vr/beach/submaps/vault1.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/vault2 //VOREStation Edit
	name = "Mine Vault 2"
	desc = "A small vault with potential loot."
	mappath = "maps/expedition_vr/beach/submaps/vault2.dmm"
	cost = 5
	allow_duplicates = TRUE
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/vault3 //VOREStation Edit
	name = "Mine Vault 3"
	desc = "A small vault with potential loot. Also a horrible suprise."
	mappath = "maps/expedition_vr/beach/submaps/vault3.dmm"
	cost = 15
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/vault4 //VOREStation Edit
	name = "Mine Vault 4"
	desc = "A small xeno vault with potential loot. Also horrible suprises."
	mappath = "maps/expedition_vr/beach/submaps/vault4.dmm"
	cost = 20
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/vault5 //VOREStation Edit
	name = "Mine Vault 5"
	desc = "A small xeno vault with potential loot. Also major horrible suprises."
	mappath = "maps/expedition_vr/beach/submaps/vault5.dmm"
	cost = 25
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/vault6 //VOREStation Edit
	name = "Mine Vault 6"
	desc = "A small mercenary tower with potential loot."
	mappath = "maps/expedition_vr/beach/submaps/vault6.dmm"
	cost = 25
	template_group = "Buried Vaults"

/datum/map_template/surface/mountains/normal/BlastMine1 //VOREStation Edit
	name = "Blast Mine 1"
	desc = "An abandoned blast mining site, seems that local wildlife has moved in."
	mappath = "maps/expedition_vr/beach/submaps/BlastMine1.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/lava_trench //VOREStation Edit
	name = "lava trench"
	desc = "A long stretch of lava underground, almost river-like, with a small crystal research outpost on the side."
	mappath = "maps/expedition_vr/beach/submaps/lava_trench.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/crashedmedshuttle //VOREStation Edit
	name = "Crashed Med Shuttle"
	desc = "A medical response shuttle that went missing some time ago. So this is where they went."
	mappath = "maps/expedition_vr/beach/submaps/CrashedMedShuttle1.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/excavation1 //VOREStation Edit
	name = "Excavation Site"
	desc = "An abandoned mining site."
	mappath = "maps/expedition_vr/beach/submaps/excavation1.dmm"
	cost = 20

/datum/map_template/surface/mountains/deep/spatial_anomaly
	name = "spatial anomaly"
	desc = "A strange section of the caves that seems twist and turn in ways that shouldn't be physically possible."
	mappath = "maps/expedition_vr/beach/submaps/spatial_anomaly.dmm"
	cost = 20

/datum/map_template/surface/mountains/normal/Speakeasy //VOREStation add
	name = "Speakeasy"
	desc = "A hidden underground bar to serve drinks in secret and in style."
	mappath = "maps/expedition_vr/beach/submaps/speakeasy_vr.dmm"
	cost = 10
	allow_duplicates = FALSE
