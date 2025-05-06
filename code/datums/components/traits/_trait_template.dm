//Some notes:
//How you APPLY a component: Call LoadComponent(/datum/component/template) on the thing you want to apply it to.
//How you CHECK a component: var/datum/component/template/comp = GetComponent(/datum/component/template)
//You can CHECK VARIABLES on a component and adjust them by doing the above and then doing something like: if(comp.energy < 50) comp.energy += 1
//How you GET RID of a component: Just qdel() it. It'll remove itself from the owner and then delete nicely.


//BIG NOTE: As the README.md notes: Using GetComponent is a crutch and should be avoided.
//Traits shouldn't NEED for external code to check for their components. It should be self-contained.
//However, for something more complex like xenochimera or shadekin, signals should be used...But we aren't at that point yet, so we're using GetComponent

/datum/component/template
	//Insert variables here if you require them. Using energy and cooldown as examples.
	var/energy = 100
	var/cooldown

	//Reference to our owner (the person that possesses us)
	//This can be anything that is our owner that we want to reference. Swap out with mob/living/carbon/human/owner as needed.
	var/mob/living/owner //easy reference

	//dupe_mode = COMPONENT_DUPE_HIGHLANDER //Default mode. See flags.dm

/datum/component/template/Initialize()

	if (!isliving(parent)) //When we get created, parent is 'whatever we are being applied to' This can be ANYTHING. For this trait, we're doing living only.
		return COMPONENT_INCOMPATIBLE //If it's not a living mob, we tell the component 'We can't be applied to this' and don't get applied.

	//We then get a reference to the thing we're applied to. In this case, a living mob.
	owner = parent

	add_verb(owner,/mob/living/proc/example_proc) //We can add verbs to our owner.
	RegisterSignal(owner, COMSIG_EXAMPLE_SIGNAL, PROC_REF(example_proc)) //To put this easily: Owner is the person we're attached to, COMSIG_EXAMPLE_SIGNAL is the signal we expect them to send out when they want us to use our 'example_proc'

	//Register this to a signal that is sent out whenever you want this to be called. For example: We want this trait to happen every life() tick, so we register it to the COMSIG_LIVING_LIFE signal that is sent every time life() is called on a /mob.
	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(process))

/datum/component/template/process()
	if (QDELETED(parent))
		return
	energy = min(100, energy+1) //Add one energy per tick, up to 100

/datum/component/template/Destroy(force = FALSE)
	UnregisterSignal(owner, COMSIG_LIVING_LIFE) //IF we registered a signal, we need to unregister it.
	UnregisterSignal(owner, COMSIG_EXAMPLE_SIGNAL) //MAKE SURE TO UNREGISTER YOUR SIGNALS. SERIOUSLY. OR THE SERVER WILL DIE.
	owner = null //MAKE SURE TO CLEAR YOUR REFS!
	. = ..()

/mob/living/proc/example_proc()
	set name = "Example proc"
	set category = "Abilities"
	set desc = "See example."
	SEND_SIGNAL(src, COMSIG_EXAMPLE_SIGNAL)
	//This sends a signal to the world saying 'We did this thing!' This is then interpreed by the component and the component calls whatever proc it needs to.


/datum/component/template/proc/example_proc()
	if (stat == DEAD)
		return
	if (energy <= 0) //Check a variable on the component.
		to_chat(owner, span_danger("You currently have no energy!"))
	else if (cooldown > world.time) //Check the cooldown variable on the component and compare it.
		var/time_to_wait = (cooldown - world.time) / (1 SECONDS) //Simple cooldown
		to_chat(owner, span_warning("You're currently on cooldown! Wait for another [round(time_to_wait,0.1)] seconds!"))
		return
	else
		cooldown = world.time + 5 SECONDS //Set the component on a 5 second cooldown.
		to_chat(owner, span_warning("You successfully used the example proc!"))
