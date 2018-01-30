/datum/gear/utility/saddlebag
    display_name = "Saddle Bag, Horse"
    path = /obj/item/weapon/storage/backpack/saddlebag
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common
    display_name = "Saddle Bag, Common"
    path = /obj/item/weapon/storage/backpack/saddlebag_common
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common/robust
    display_name = "Saddle Bag, Robust"
    path = /obj/item/weapon/storage/backpack/saddlebag_common/robust
    slot = slot_back
    cost = 2

/datum/gear/utility/saddlebag_common/vest
    display_name = "Taur Duty Vest (backpack)"
    path = /obj/item/weapon/storage/backpack/saddlebag_common/vest
    slot = slot_back
    cost = 1

/datum/gear/utility/dufflebag
    display_name = "Dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag
    slot = slot_back
    cost = 2

/datum/gear/utility/dufflebag/black
    display_name = "Black Dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/fluff

/datum/gear/utility/dufflebag/med
    display_name = "Medical Dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/med
    allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist","Psychiatrist","Search and Rescue")

/datum/gear/utility/dufflebag/med/emt
    display_name = "EMT Dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/emt

/datum/gear/utility/dufflebag/sec
    display_name = "Security Dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/sec
    allowed_roles = list("Head of Security","Warden","Detective","Security Officer")

/datum/gear/utility/dufflebag/eng
    display_name = "Engineering Dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/eng
    allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

/datum/gear/utility/dufflebag/sci
    display_name = "Science Dufflebag"
    path = /obj/item/weapon/storage/backpack/dufflebag/sci
    allowed_roles = list("Research Director","Scientist","Roboticist","Xenobiologist","Explorer")
