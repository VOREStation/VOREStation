//SolGov Uniforms

//Master
/obj/item/clothing/under/solgov
	name = "master solgov uniform"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/clothing/uniforms_solgov.dmi'
	rolled_down = 0
	rolled_sleeves = 0
	item_icons = list(slot_w_uniform_str = 'icons/mob/uniform_solgov.dmi')
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
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

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

/obj/item/clothing/under/solgov/pt/marine
	name = "marine pt uniform"
	desc = "Does NOT leave much to the imagination."
	icon_state = "marinept"
	worn_state = "marinept"


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

//Here's the real ones
/obj/item/clothing/under/solgov/utility/sifguard
	name = "\improper SifGuard uniform"
	desc = "The utility uniform of the Sif Defense Force, made from biohazard resistant material. This one has silver trim."
	icon_state = "blackutility_crew"
	worn_state = "blackutility_crew"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 10)

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

/obj/item/clothing/under/solgov/utility/sifguard/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration)

/obj/item/clothing/under/solgov/utility/sifguard/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research)

/obj/item/clothing/under/solgov/utility/sifguard/officer
	name = "\improper Sifuard officer's uniform"
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

/obj/item/clothing/under/solgov/utility/fleet/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/fleet)


/obj/item/clothing/under/solgov/utility/marine
	name = "marine fatigues"
	desc = "The utility uniform of the SCG Marine Corps, made from durable material."
	icon_state = "greyutility"
	worn_state = "greyutility"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/solgov/utility/marine/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/marine)

/obj/item/clothing/under/solgov/utility/marine/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/marine)

/obj/item/clothing/under/solgov/utility/marine/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/marine)

/obj/item/clothing/under/solgov/utility/marine/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/marine)

/obj/item/clothing/under/solgov/utility/marine/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/marine)

/obj/item/clothing/under/solgov/utility/marine/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/marine)

/obj/item/clothing/under/solgov/utility/marine/green
	name = "green fatigues"
	desc = "A green version of the SCG marine utility uniform, made from durable material."
	icon_state = "greenutility"
	worn_state = "greenutility"

/obj/item/clothing/under/solgov/utility/marine/tan
	name = "tan fatigues"
	desc = "A tan version of the SCG marine utility uniform, made from durable material."
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

/obj/item/clothing/under/solgov/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the SCG Fleet, made from immaculate white fabric."
	icon_state = "whiteservice"
	worn_state = "whiteservice"

/obj/item/clothing/under/solgov/service/marine
	name = "marine service uniform"
	desc = "The service uniform of the SCG Marine Corps. Slimming."
	icon_state = "greenservice"
	worn_state = "greenservice"

/obj/item/clothing/under/solgov/service/marine/command
	name = "marine command service uniform"
	desc = "The service uniform of the SCG Marine Corps. Slimming and stylish."
	icon_state = "greenservice_com"
	worn_state = "greenservice_com"

//Dress

/obj/item/clothing/under/solgov/mildress
	name = "dress uniform"
	desc = "A dress uniform of some kind."
	icon_state = "greydress"
	worn_state = "greydress"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/solgov/mildress/sifguard
	name = "\improper SifGuard dress uniform"
	desc = "The dress uniform of the Sif Defense Force in silver trim."

/obj/item/clothing/under/solgov/mildress/sifguard/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/service)

/obj/item/clothing/under/solgov/mildress/sifguard/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/service)

/obj/item/clothing/under/solgov/mildress/sifguard/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/service)

/obj/item/clothing/under/solgov/mildress/sifguard/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/service)

/obj/item/clothing/under/solgov/mildress/sifguard/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/service)

/obj/item/clothing/under/solgov/mildress/sifguard/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/service)

/obj/item/clothing/under/solgov/mildress/sifguard/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/service)

/obj/item/clothing/under/solgov/mildress/sifguard/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/service)

/obj/item/clothing/under/solgov/mildress/sifguard/officer
	name = "\improper SifGuard command dress uniform"
	desc = "The dress uniform of the Sif Defense Force in gold trim."
	icon_state = "greydress_com"
	worn_state = "greydress_com"

/obj/item/clothing/under/solgov/mildress/sifguard/officer/command
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/service)

/obj/item/clothing/under/solgov/mildress/sifguard/officer/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/service)

/obj/item/clothing/under/solgov/mildress/sifguard/officer/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/service)

/obj/item/clothing/under/solgov/mildress/sifguard/officer/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/service)

/obj/item/clothing/under/solgov/mildress/sifguard/officer/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/service)

/obj/item/clothing/under/solgov/mildress/sifguard/officer/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/service)

/obj/item/clothing/under/solgov/mildress/sifguard/officer/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/service)

/obj/item/clothing/under/solgov/mildress/sifguard/officer/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/service)

/obj/item/clothing/under/solgov/mildress/marine
	name = "marine dress uniform"
	desc = "The dress uniform of the SCG Marine Corps, class given form."
	icon_state = "blackdress"
	worn_state = "blackdress"

/obj/item/clothing/under/solgov/mildress/marine/command
	name = "marine command dress uniform"
	desc = "The dress uniform of the SCG Marine Corps, even classier in gold."
	icon_state = "blackdress_com"
	worn_state = "blackdress_com"


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
