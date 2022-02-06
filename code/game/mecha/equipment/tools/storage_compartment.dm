/obj/item/mecha_parts/mecha_equipment/storage
    name = "auxillary exosuit storage bay"
    desc = "An auxillary storage compartment, for attaching to exosuits."
    icon_state = "mecha_tiler"
    icon = 'icons/mecha/mecha_equipment_vr.dmi'
    origin_tech = list(TECH_MATERIAL = 3)
    range = 0
    var/storage_added = 5
    equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/storage/attach(obj/mecha/M)
    . = ..()
    M.cargo_capacity += storage_added

/obj/item/mecha_parts/mecha_equipment/storage/detach()
    chassis.cargo_capacity -= storage_added
    ..()

/obj/item/mecha_parts/mecha_equipment/storage/bluespace
    name = "auxillary exosuit storage wormhole"
    desc = "An auxillary storage wormhole, utilizing a localized rip in bluespace for storage. Interestingly enough, teleport-stable, \
    despite its blatant disregard for the fabric of reality or reality-adjacency."
    icon_state = "mecha_phase_array"
    storage_added = 15
    origin_tech = list(TECH_MATERIAL = 6, TECH_ENGINEERING = 4, TECH_MAGNET = 4, TECH_POWER = 5, TECH_BLUESPACE = 3)