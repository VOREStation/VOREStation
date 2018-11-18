/datum/gear/utility/saddlebag
    display_name = "saddle bag, horse"
    path = /obj/item/weapon/storage/backpack/saddlebag
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common
    display_name = "saddle bag, common"
    path = /obj/item/weapon/storage/backpack/saddlebag_common
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common/robust
    display_name = "saddle bag, robust"
    path = /obj/item/weapon/storage/backpack/saddlebag_common/robust
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common/vest
    display_name = "taur duty vest (backpack)"
    path = /obj/item/weapon/storage/backpack/saddlebag_common/vest
    slot = slot_back
    cost = 1

/datum/gear/utility/dufflebag
    display_name = "dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag
    slot = slot_back
    cost = 2

/datum/gear/utility/dufflebag/black
    display_name = "black dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/fluff

/datum/gear/utility/dufflebag/med
    display_name = "medical dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/med
    allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist","Psychiatrist","Field Medic")

/datum/gear/utility/dufflebag/med/emt
    display_name = "EMT dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/emt

/datum/gear/utility/dufflebag/sec
    display_name = "security Dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/sec
    allowed_roles = list("Head of Security","Warden","Detective","Security Officer")

/datum/gear/utility/dufflebag/eng
    display_name = "engineering dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/eng
    allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/utility/dufflebag/sci
    display_name = "science dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/sci
    allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist","Explorer","Pathfinder")
