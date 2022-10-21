// Detects reagents inside most containers, and acts as an infinite identification system for reagent-based unidentified objects.

/obj/machinery/chemical_analyzer
	name = "chem analyzer"
	desc = "Used to precisely scan chemicals and other liquids inside various containers. \
	It may also identify the liquid contents of unknown objects."
	description_info = "This machine will try to tell you what reagents are inside of something capable of holding reagents. \
	It is also used to 'identify' specific reagent-based objects with their properties obscured from inspection by normal means."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "chem_analyzer"
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 20
	clicksound = "button"
	var/analyzing = FALSE

/obj/machinery/chemical_analyzer/update_icon()
	icon_state = "chem_analyzer[analyzing ? "-working":""]"

/obj/machinery/chemical_analyzer/attackby(obj/item/I, mob/living/user)
	if(!istype(I))
		return ..()

	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return

	if(istype(I,/obj/item/weapon/reagent_containers))
		analyzing = TRUE
		update_icon()
		to_chat(user, span("notice", "Analyzing \the [I], please stand by..."))

		if(!do_after(user, 2 SECONDS, src))
			to_chat(user, span("warning", "Sample moved outside of scan range, please try again and remain still."))
			analyzing = FALSE
			update_icon()
			return

		// First, identify it if it isn't already.
		if(!I.is_identified(IDENTITY_FULL))
			var/datum/identification/ID = I.identity
			if(ID.identification_type == IDENTITY_TYPE_CHEMICAL) // This only solves chemical-based mysteries.
				I.identify(IDENTITY_FULL, user)

		// Now tell us everything that is inside.
		if(I.reagents && I.reagents.reagent_list.len)
			to_chat(user, "<br>") // To add padding between regular chat and the output.
			for(var/datum/reagent/R in I.reagents.reagent_list)
				if(!R.name)
					continue
				to_chat(user, span("notice", "Contains [R.volume]u of <b>[R.name]</b>.<br>[R.description]<br>"))

		// Last, unseal it if it's an autoinjector.
<<<<<<< HEAD
		if(istype(I,/obj/item/weapon/reagent_containers/hypospray/autoinjector/biginjector) && !(I.flags & OPENCONTAINER))
			I.flags |= OPENCONTAINER
=======
		if(istype(I,/obj/item/reagent_containers/hypospray/autoinjector/biginjector) && !(I.atom_flags & ATOM_REAGENTS_IS_OPEN))
			I.atom_flags |= ATOM_REAGENTS_IS_OPEN
>>>>>>> 56bf74c21f8... Merge pull request #8762 from Spookerton/spkrtn/sys/flagging
			to_chat(user, span("notice", "Sample container unsealed.<br>"))

		to_chat(user, span("notice", "Scanning of \the [I] complete."))
		analyzing = FALSE
		update_icon()
		return
