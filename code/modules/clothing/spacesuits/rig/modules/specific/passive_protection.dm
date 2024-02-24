// contains the Radiation Absorption Device (RAD) and Atmospheric Protective Equipment (APE) modules
// you shits ready for some COPY AND PASTE?
/obj/item/rig_module/rad_shield
	name = "radiation absorption device"
	desc = "The acronym of this device - R.A.D. - and its full name both convey the application of the module."
	description_info = "Through the usage of powered radiation collectors optimized for absorption rather than power generation, it protects the suit's wearer \
	from incoming ionizing radiation and converts it into a significantly less harmful form. This comes at the cost of concerningly high power consumption, \
	and thus should only be used in short bursts."
	icon_state = "radsoak"
	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 25
	active_power_cost = 25
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable Supplemental Radiation Shielding"
	deactivate_string = "Disable Supplemental Radiation Shielding"

	interface_name = "radiation absorption system"
	interface_desc = "Provides passive protection against radiation, at the cost of power."
	var/stored_rad_armor = 0

/obj/item/rig_module/rad_shield/activate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	var/obj/item/clothing/shoes/boots = holder.boots
	var/obj/item/clothing/suit/space/rig/chest = holder.chest
	var/obj/item/clothing/head/helmet/space/rig/helmet = holder.helmet
	var/obj/item/clothing/gloves/gauntlets/rig/gloves = holder.gloves

	to_chat(H, span_blue("<b>You activate your suit's powered radiation shielding.</b>"))
	stored_rad_armor = holder.armor["rad"]
	if(boots)
		boots.armor["rad"] = 100
	if(chest)
		chest.armor["rad"] = 100
	if(helmet)
		helmet.armor["rad"] = 100
	if(gloves)
		gloves.armor["rad"] = 100
	holder.armor["rad"] = 100

/obj/item/rig_module/rad_shield/deactivate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	var/obj/item/clothing/shoes/boots = holder.boots
	var/obj/item/clothing/suit/space/rig/chest = holder.chest
	var/obj/item/clothing/head/helmet/space/rig/helmet = holder.helmet
	var/obj/item/clothing/gloves/gauntlets/rig/gloves = holder.gloves

	to_chat(H, "<span class='danger'>You deactivate your suit's powered radiation shielding.</span>")

	if(boots)
		boots.armor["rad"] = stored_rad_armor
	if(chest)
		chest.armor["rad"] = stored_rad_armor
	if(helmet)
		helmet.armor["rad"] = stored_rad_armor
	if(gloves)
		gloves.armor["rad"] = stored_rad_armor
	holder.armor["rad"] = stored_rad_armor

	stored_rad_armor = 0

/obj/item/rig_module/rad_shield/advanced
	name = "advanced radiation absorption device"
	desc = "The acronym of this device - R.A.D. - and its full name both convey the application of the module. It has a changelog inscribed \
	on the underside of the casing."
	use_power_cost = 5
	active_power_cost = 5

/obj/item/rig_module/atmos_shield
	name = "atmospheric protection enhancement suite"
	desc = "The acronym of this suite - A.P.E. - unlike its loosely related cousin, the R.A.D., is remarkably unintuitive."
	description_info = "Through the usage of powered shielding optimized for protection against the elements rather than from external physical issues, \
	it protects the suit's wearer from atmospheric pressure and temperatures. This comes at the cost of concerningly high power consumption, \
	and thus should only be used in short bursts."
	icon_state = "atmosoak"

	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 25
	active_power_cost = 25
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable Powered Atmospheric Shielding"
	deactivate_string = "Disable Powered Atmospheric Shielding"

	interface_name = "atmospheric protection enhancements"
	interface_desc = "Provides passive protection against the atmosphere, at the cost of power."
	var/stored_max_pressure = 0
	var/stored_max_temp = 0

/obj/item/rig_module/atmos_shield/activate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	var/obj/item/clothing/shoes/boots = holder.boots
	var/obj/item/clothing/suit/space/rig/chest = holder.chest
	var/obj/item/clothing/head/helmet/space/rig/helmet = holder.helmet
	var/obj/item/clothing/gloves/gauntlets/rig/gloves = holder.gloves

	stored_max_pressure = holder.max_pressure_protection
	stored_max_temp = holder.max_heat_protection_temperature

	to_chat(H, span_blue("<b>You activate your suit's powered atmospheric shielding.</b>"))

	if(boots)
		boots.max_pressure_protection = INFINITY
		boots.max_heat_protection_temperature = INFINITY
	if(chest)
		chest.max_pressure_protection = INFINITY
		chest.max_heat_protection_temperature = INFINITY
	if(helmet)
		helmet.max_pressure_protection = INFINITY
		helmet.max_heat_protection_temperature = INFINITY
	if(gloves)
		gloves.max_pressure_protection = INFINITY
		gloves.max_heat_protection_temperature = INFINITY
	holder.max_pressure_protection = INFINITY
	holder.max_heat_protection_temperature = INFINITY

/obj/item/rig_module/atmos_shield/deactivate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer
	var/obj/item/clothing/shoes/boots = holder.boots
	var/obj/item/clothing/suit/space/rig/chest = holder.chest
	var/obj/item/clothing/head/helmet/space/rig/helmet = holder.helmet
	var/obj/item/clothing/gloves/gauntlets/rig/gloves = holder.gloves

	to_chat(H, "<span class='danger'><b>You deactivate your suit's powered atmospheric shielding.</b></span>")

	if(boots)
		boots.max_pressure_protection = stored_max_pressure
		boots.max_heat_protection_temperature = stored_max_temp
	if(chest)
		chest.max_pressure_protection = stored_max_pressure
		chest.max_heat_protection_temperature = stored_max_temp
	if(helmet)
		helmet.max_pressure_protection = stored_max_pressure
		helmet.max_heat_protection_temperature = stored_max_temp
	if(gloves)
		gloves.max_pressure_protection = stored_max_pressure
		gloves.max_heat_protection_temperature = stored_max_temp
	holder.max_pressure_protection = stored_max_pressure
	holder.max_heat_protection_temperature = stored_max_temp

	stored_max_pressure = 0
	stored_max_temp = 0
