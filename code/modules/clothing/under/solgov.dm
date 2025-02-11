//SolGov Uniforms

//Master
/obj/item/clothing/under/solgov
	name = "master solgov uniform"
	desc = "You shouldn't be seeing this."
	icon = 'icons/inventory/uniform/item.dmi'
	item_icons = list(slot_w_uniform_str = 'icons/inventory/uniform/mob.dmi')
	rolled_down = 0
	rolled_sleeves = 0
	armor = list(melee = 5, bullet = 0, laser = 5, energy = 5, bomb = 0, bio = 5, rad = 5)
	siemens_coefficient = 0.8

//PT
/obj/item/clothing/under/solgov/pt
	name = "pt uniform"
	desc = "Shorts! Shirt! Miami! Sexy!"
	icon_state = "miami"
	worn_state = "miami"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	body_parts_covered = CHEST

/obj/item/clothing/under/solgov/pt/sifguard
	name = "\improper SifGuard pt uniform"
	desc = "A baggy shirt bearing the seal of the Sif Defense Force and some dorky looking blue shorts."
	icon_state = "expeditionpt"
	worn_state = "expeditionpt"

/obj/item/clothing/under/solgov/pt/fleet
	name = "fleet pt uniform"
	desc = "A pair of black shorts and two tank tops, seems impractical. Looks good though."
	icon_state = "fleetpt"
	worn_state = "fleetpt"

/obj/item/clothing/under/solgov/pt/army
	name = "marine pt uniform"
	desc = "Does NOT leave much to the imagination."
	icon_state = "armypt"
	worn_state = "armypt"


//Utility
//These are just colored
/obj/item/clothing/under/utility
	name = "utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."
	icon_state = "blackutility"
	worn_state = "blackutility"
	rolled_sleeves = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/utility/blue
	name = "utility uniform"
	desc = "A comfortable blue utility jumpsuit."
	icon_state = "navyutility"
	worn_state = "navyutility"

/obj/item/clothing/under/utility/grey
	name = "utility uniform"
	desc = "A comfortable grey utility jumpsuit."
	icon_state = "greyutility"
	worn_state = "greyutility"

/obj/item/clothing/under/utility/tan
	name = "utility uniform"
	desc = "A comfortable tan utility jumpsuit."
	icon_state = "tanutility"
	worn_state = "tanutility"

/obj/item/clothing/under/utility/green
	name = "utility uniform"
	desc = "A comfortable green utility jumpsuit."
	icon_state = "greenutility"
	worn_state = "greenutility"

//Here's the real ones
/obj/item/clothing/under/solgov/utility/sifguard
	name = "\improper SifGuard uniform"
	desc = "The utility uniform of the Sif Defense Force, made from biohazard resistant material. This one has silver trim."
	icon_state = "blackutility_crew"
	worn_state = "blackutility_crew"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 10)

/obj/item/clothing/under/sifcop
	name = "\improper SifGuard law enforcement uniform"
	desc = "A sturdy law enforcement uniform typical of Vir's civilian law enforcement officers."
	icon_state = "sifcop"
	worn_state = "sifcop"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) //Equivalent to security officer's jumpsuit
	rolled_sleeves = 0

/obj/item/clothing/under/solgov/utility/sifguard_skirt
	name = "\improper SifGuard skirt"
	desc = "A black turtleneck and skirt, the elusive ladies' uniform of the Sif Defense Force."
	icon_state = "blackservicef"
	worn_state = "blackservicefem"

/obj/item/clothing/under/solgov/utility/sifguard_skirt/officer
	name = "\improper NDF officer skirt"
	desc = "A black turtleneck and skirt, the elusive ladies' uniform of the Nanotrasen Defense Force. This one has gold trim."
	icon_state = "blackservicef_com"
	worn_state = "blackservicefem_com"

/obj/item/clothing/under/solgov/utility/sifguard/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command)

/obj/item/clothing/under/solgov/utility/sifguard/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering)

/obj/item/clothing/under/solgov/utility/sifguard/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security)

/obj/item/clothing/under/solgov/utility/sifguard/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical)

/obj/item/clothing/under/solgov/utility/sifguard/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply)

/obj/item/clothing/under/solgov/utility/sifguard/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service)

/obj/item/clothing/under/solgov/utility/sifguard/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration)

/obj/item/clothing/under/solgov/utility/sifguard/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research)

/obj/item/clothing/under/solgov/utility/sifguard/officer
	name = "\improper Sifguard officer's uniform"
	desc = "The utility uniform of the Sif Defense Force, made from biohazard resistant material. This one has gold trim."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"

/obj/item/clothing/under/solgov/utility/sifguard/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command)

/obj/item/clothing/under/solgov/utility/sifguard/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering)

/obj/item/clothing/under/solgov/utility/sifguard/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security)

/obj/item/clothing/under/solgov/utility/sifguard/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical)

/obj/item/clothing/under/solgov/utility/sifguard/officer/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply)

/obj/item/clothing/under/solgov/utility/sifguard/officer/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service)

/obj/item/clothing/under/solgov/utility/sifguard/officer/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration)

/obj/item/clothing/under/solgov/utility/sifguard/officer/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research)

/obj/item/clothing/under/solgov/utility/fleet
	name = "fleet coveralls"
	desc = "The utility uniform of the SCG Fleet, made from an insulated material."
	icon_state = "navyutility"
	worn_state = "navyutility"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/under/solgov/utility/fleet/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/fleet)

/obj/item/clothing/under/solgov/utility/fleet/command/pilot
	starting_accessories = list(/obj/item/clothing/accessory/solgov/specialty/pilot)

/obj/item/clothing/under/solgov/utility/fleet/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/fleet)

/obj/item/clothing/under/solgov/utility/fleet/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/fleet)

/obj/item/clothing/under/solgov/utility/fleet/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/fleet)

/obj/item/clothing/under/solgov/utility/fleet/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/fleet)

/obj/item/clothing/under/solgov/utility/fleet/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/fleet)

/obj/item/clothing/under/solgov/utility/fleet/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/fleet)

/obj/item/clothing/under/solgov/utility/fleet/combat
	name = "fleet fatigues"
	desc = "Alternative utility uniform of the SCG Fleet, for when coveralls are impractical."
	icon_state = "navycombat"
	worn_state = "navycombat"

/obj/item/clothing/under/solgov/utility/fleet/combat/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/fleet)

/obj/item/clothing/under/solgov/utility/fleet/combat/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/fleet, /obj/item/clothing/accessory/armband/medblue)

/obj/item/clothing/under/solgov/utility/fleet/combat/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/fleet)

/obj/item/clothing/under/solgov/utility/fleet/combat/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/fleet)

/obj/item/clothing/under/solgov/utility/fleet/officer
	name = "fleet officer's coveralls"
	desc = "Alternative utility uniform of the SCG Fleet, for officers."
	icon_state = "navyutilityoff"
	worn_state = "navyutilityoff"

/obj/item/clothing/under/solgov/utility/fleet/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/fleet)

/obj/item/clothing/under/solgov/utility/fleet/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/fleet)

/obj/item/clothing/under/solgov/utility/fleet/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/fleet)

/obj/item/clothing/under/solgov/utility/fleet/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/fleet)

/obj/item/clothing/under/solgov/utility/army
	name = "marine fatigues"
	desc = "The utility uniform of the SCG Marines, made from durable material."
	icon_state = "greenutility"
	worn_state = "greenutility"

//obj/item/clothing/under/solgov/utility/army/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/army)

/obj/item/clothing/under/solgov/utility/army/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/army)

/obj/item/clothing/under/solgov/utility/army/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/army)

/obj/item/clothing/under/solgov/utility/army/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/army)

/obj/item/clothing/under/solgov/utility/army/medical/banded
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/army, /obj/item/clothing/accessory/armband/medblue)

/obj/item/clothing/under/solgov/utility/army/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/army)

/obj/item/clothing/under/solgov/utility/army/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/army)

/obj/item/clothing/under/solgov/utility/army/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/army)

/obj/item/clothing/under/solgov/utility/army/urban
	name = "urban fatigues"
	desc = "An urban version of the SCG Marines utility uniform, made from durable material."
	icon_state = "greyutility"
	worn_state = "greyutility"

/obj/item/clothing/under/solgov/utility/army/tan
	name = "tan fatigues"
	desc = "A tan version of the SCG Marines utility uniform, made from durable material."
	icon_state = "tanutility"
	worn_state = "tanutility"

//Service

/obj/item/clothing/under/solgov/service
	name = "service uniform"
	desc = "A service uniform of some kind."
	icon_state = "whiteservice"
	worn_state = "whiteservice"
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 5, rad = 0)
	siemens_coefficient = 0.9
	siemens_coefficient = 0.9

/obj/item/clothing/under/solgov/service/sifguard
	name = "\improper SifGuard service uniform"
	desc = "The service uniform of the Sif Defense Force in silver trim."
	icon_state = "greydress"
	worn_state = "greydress"

/obj/item/clothing/under/solgov/service/sifguard/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/jumper)

/obj/item/clothing/under/solgov/service/sifguard/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/jumper)

/obj/item/clothing/under/solgov/service/sifguard/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/jumper)

/obj/item/clothing/under/solgov/service/sifguard/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/jumper)

/obj/item/clothing/under/solgov/service/sifguard/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/jumper)

/obj/item/clothing/under/solgov/service/sifguard/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/jumper)

/obj/item/clothing/under/solgov/service/sifguard/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/jumper)

/obj/item/clothing/under/solgov/service/sifguard/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/jumper)

/obj/item/clothing/under/solgov/service/sifguard/skirt
	name = "\improper SifGuard service skirt"
	desc = "A feminine version of the Sif Defense Force service uniform in silver trim."
	icon_state = "greydressfem"
	worn_state = "greydressfem"

/obj/item/clothing/under/solgov/service/sifguard/skirt/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/jumper)

/obj/item/clothing/under/solgov/service/sifguard/skirt/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/jumper)

/obj/item/clothing/under/solgov/service/sifguard/skirt/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/jumper)

/obj/item/clothing/under/solgov/service/sifguard/skirt/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/jumper)

/obj/item/clothing/under/solgov/service/sifguard/skirt/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/jumper)

/obj/item/clothing/under/solgov/service/sifguard/skirt/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/jumper)

/obj/item/clothing/under/solgov/service/sifguard/skirt/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/jumper)

/obj/item/clothing/under/solgov/service/sifguard/skirt/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command
	name = "\improper SifGuard officer's service uniform"
	desc = "The service uniform of the Sif Defense Force in gold trim."
	icon_state = "greydress_com"
	worn_state = "greydress_com"

/obj/item/clothing/under/solgov/service/sifguard/command/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/skirt
	name = "\improper SifGuard officer's service skirt"
	desc = "A feminine version of the Sif Defense Force service uniform in gold trim."
	icon_state = "greydressfem_com"
	worn_state = "greydressfem_com"

/obj/item/clothing/under/solgov/service/sifguard/command/skirt/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/skirt/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/skirt/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/skirt/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/skirt/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/skirt/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/skirt/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/jumper)

/obj/item/clothing/under/solgov/service/sifguard/command/skirt/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/jumper)

/obj/item/clothing/under/solgov/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservice"
	worn_state = "whiteservice"
	starting_accessories = list(/obj/item/clothing/accessory/tie/navy)

/obj/item/clothing/under/solgov/service/fleet/skirt
	name = "fleet service skirt"
	desc = "The service uniform skirt of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservicefem"
	worn_state = "whiteservicefem"

/obj/item/clothing/under/solgov/service/army
	name = "marine service uniform"
	desc = "The service uniform of the SCG Marines. Slimming."
	icon_state = "greenservice"
	worn_state = "greenservice"
	starting_accessories = list(/obj/item/clothing/accessory/tie/darkgreen)

/obj/item/clothing/under/solgov/service/army/skirt
	name = "marine service skirt"
	desc = "The service uniform skirt of the SCG Marines. Slimming."
	icon_state = "greenservicefem"
	worn_state = "greenservicefem"

/obj/item/clothing/under/solgov/service/army/command
	name = "marine officer's service uniform"
	desc = "The service uniform of the SCG Marines. Slimming and stylish."
	icon_state = "greenservice_com"
	worn_state = "greenservice_com"
	starting_accessories = list(/obj/item/clothing/accessory/tie/darkgreen)

/obj/item/clothing/under/solgov/service/army/command/skirt
	name = "marine officer's service skirt"
	desc = "The service uniform skirt of the SCG Marines. Slimming and stylish."
	icon_state = "greenservicefem_com"
	worn_state = "greenservicefem_com"

//Dress

/obj/item/clothing/under/solgov/mildress
	name = "dress uniform"
	desc = "A dress uniform of some kind."
	icon_state = "greydress"
	worn_state = "greydress"

/obj/item/clothing/under/solgov/mildress/army
	name = "marine dress uniform"
	desc = "The dress uniform of the SCG Marines, class given form."
	icon_state = "blackdress"
	worn_state = "blackdress"

/obj/item/clothing/under/solgov/mildress/army/skirt
	name = "marine dress skirt"
	desc = "A  feminine version of the SCG Marines dress uniform, class given form."
	icon_state = "blackdressfem"
	worn_state = "blackdressfem"

/obj/item/clothing/under/solgov/mildress/army/command
	name = "marine officer's dress uniform"
	desc = "The dress uniform of the SCG Marines, even classier in gold."
	icon_state = "blackdress"
	worn_state = "blackdress_com"

/obj/item/clothing/under/solgov/mildress/army/command/skirt
	name = "marine officer's dress skirt"
	desc = "A feminine version of the SCG Marines dress uniform, even classier in gold."
	icon_state = "blackdressfem"
	worn_state = "blackdressfem_com"


//Misc

/obj/item/clothing/under/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon_state = "hazard"
	worn_state = "hazard"
	siemens_coefficient = 0.8
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 20, bio = 0, rad = 20)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/under/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon_state = "sterile"
	worn_state = "sterile"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 30, rad = 0)

//SAARE

/obj/item/clothing/under/saare
	name = "master SAARE uniform"
	desc = "You shouldn't be seeing this."
	icon = 'icons/inventory/uniform/item.dmi'
	item_icons = list(slot_w_uniform_str = 'icons/inventory/uniform/mob.dmi')
	armor = list(melee = 5, bullet = 0, laser = 5, energy = 5, bomb = 0, bio = 5, rad = 5)
	siemens_coefficient = 0.8

/obj/item/clothing/under/saare/utility
	name = "SAARE utility uniform"
	desc = "A comfortable black utility jumpsuit. Worn by Stealth Assault Enterprises mercenaries."
	icon_state = "terranutility"
	worn_state = "terranutility"

/obj/item/clothing/under/saare/service
	name = "SAARE service uniform"
	desc = "The service uniform of Stealth Assault Enterprises, for low-ranking mercenaries."
	icon_state = "terranservice"
	worn_state = "terranservice"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 5, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/saare/service/command
	name = "SAARE command service uniform"
	desc = "The service uniform of Stealth Assault Enterprises, for high-ranking mercenaries."
	icon_state = "terranservice_comm"
	worn_state = "terranservice_comm"

//Galactic Survey

/obj/item/clothing/under/gsa
	name = "\improper Galactic Survey utility uniform"
	desc = "A jumpsuit belonging to the Galactic Survey Administration, SolGov's scientific exploration division."
	icon_state = "gsa"
	worn_state = "gsa"
	rolled_sleeves = 0

/obj/item/clothing/under/gsa_work
	name = "\improper Galactic Survey worksuit"
	desc = "A padded work suit belonging to the Galactic Survey Administration, SolGov's scientific exploration division. It has minor radiation shielding."
	icon_state = "gsa_work"
	worn_state = "gsa_work"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	rolled_sleeves = 0
