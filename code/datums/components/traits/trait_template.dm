//Some notes:
//How you APPLY a component: Call LoadComponent(/datum/component/template) on the thing you want to apply it to.
//How you CHECK a component: var/datum/component/template/comp = GetComponent(/datum/component/template)
//You can CHECK VARIABLES on a component and adjust them by doing the above and then doing something like: if(comp.energy < 50) comp.energy += 1
//How you GET RID of a component: Just qdel() it. It'll remove itself from the owner and then delete nicely.

/datum/component/template
	//Insert variables here if you require them. Using energy and cooldown as examples.
	var/energy = 100
	var/cooldown

	//Reference to our owner (the person that possesses us)
	//This could be swapped for a different type of mob, but let's use humans as a reference.
	var/mob/living/carbon/human/owner //easy reference

	//dupe_mode = COMPONENT_DUPE_HIGHLANDER //Default mode. See flags.dm

/datum/component/template/Initialize()

	if (!ishuman(parent)) //When we get created, parent is 'whatever we are being applied to' This can be ANYTHING. For this trait, we're doing human only.
		return COMPONENT_INCOMPATIBLE //If it's not a human, we tell the component 'We can't be applied to this' and don't get applied.

	//We then get a reference to the thing we're applied to. In this case, a human.
	owner = parent

	add_verb(owner,/mob/living/carbon/human/proc/example_proc) //We can add verbs to our owner.

	//We add the component to SSprocessing, which means it will do process() every processing tick (~2 seconds)
	//This isn't required if you're just using this as a variable holder, but anything more complex will need it.
	START_PROCESSING(SSprocessing, src)

/datum/component/template/process()
	if (QDELETED(parent))
		return
	energy = min(100, energy+1) //Add one energy per tick, up to 100

/datum/component/template/Destroy(force = FALSE)
	owner = null //MAKE SURE TO CLEAR YOUR REFS!
	..()

/mob/living/carbon/human/proc/example_proc()
	set name = "Example proc"
	set category = "Abilities"
	set desc = "See example."

	if (stat == DEAD)
		return

	var/datum/component/template/comp = GetComponent(/datum/component/template) //This is how we access the component we have.
	if (comp) //We check to see if we actually HAVE the componnent. If we don't, comp will have no value.
		if (comp.energy <= 0) //Check a variable on the component.
			to_chat(src, span_danger("You currently have no energy!"))
		else if (comp.cooldown > world.time) //Check the cooldown variable on the component and compare it.
			var/time_to_wait = (comp.cooldown - world.time) / (1 SECONDS) //Simple cooldown
			to_chat(src, span_warning("You're currently on cooldown! Wait for another [round(time_to_wait,0.1)] seconds!"))
			return
		else
			comp.cooldown = world.time + 5 SECONDS //Set the component on a 5 second cooldown.
			to_chat(src, span_warning("You successfully used the example proc!"))
