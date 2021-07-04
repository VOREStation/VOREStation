/obj/item/rig_module/sprinter
	name = "sprint module"
	desc = "A robust hardsuit-integrated sprint module."
	icon_state = "sprinter"

	var/sprint_speed = 0.5

	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 50
	active_power_cost = 5
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable Sprint"
	deactivate_string = "Disable Sprint"

	interface_name = "sprint system"
	interface_desc = "Increases power to the suit's actuators, allowing faster movement."

/obj/item/rig_module/sprinter/activate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, "<font color='blue'><b>You activate the suit's sprint mode.</b></font>")

	holder.slowdown = initial(holder.slowdown) - sprint_speed

/obj/item/rig_module/sprinter/deactivate()

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, "<span class='danger'>Your hardsuit returns to normal speed.</span>")

	holder.slowdown = initial(holder.slowdown)
