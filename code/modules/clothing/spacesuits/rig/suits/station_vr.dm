
/obj/item/weapon/rig/hazmat/equipped

	req_access = list() //So xenoarch can use them

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/device/drill //The suit has nothing to mine with otherwise.
		)