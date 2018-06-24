/*

	This module contains an AI implementation designed to be (mostly) mobtype-agnostic, by being held inside a datum instead of being on the mob directly.


Seperation:

The ai_holder datum is designed to be fairly distant from its mob holder, in terms of coupling.
This presents some advantages.
  * Not being tied to the mob's Life() cycle allows for a different tick rate.
  * Being seperate from the mob simplifies mob code greatly.
  * It allows for better encapsulation and seperation of duties from the mob.
  * It is more logical to think that the mob is the 'body', where as its ai_holder is the 'mind'.
  * It can be made mobtype-independant with the use of Interfaces.


	The datum is held by the mob that it should control, called the holder, and is not processed by the mob itself (as Life() did so in previous implementations).
Instead, each instance of /datum/ai_holder is processed by the 'AI' master controller subsystem. The datum itself has two seperate process tracks instead of one,
as most other objects ( process() ) or mobs ( Life() ) do.




Flow of Execution:

	AI Subsystem
				- > Every 0.5s - > /datum/ai_holder/handle_tactics() - > /datum/ai_holder/handle_stance_tactical() - > switch(stance)...
				- > Every 2.0s - > /datum/ai_holder/handle_strategicals() - > /datum/ai_holder/handle_stance_strategical() - > switch(stance)...

	The datum is not driven by its mob, as previous implementations did, meaning Life() is not involved. Instead, it is processed by a specific Master Controller Subsystem
titled 'AI', which by default ticks every half a second. Each instance of the ai_holder datum that is not 'asleep' is part of a list, containing ai_holders that are awake.
When the subsystem runs, each ai_holder instance inside the list is iterated on, and calls one or two procs on it.
Every tick, each instance has handle_tactics() called on it, and every four ticks, handle_strategicals(), meaning every half a second and very two seconds, respectively.
This means that the ai_holder datum has two seperate types of processing, for the purposes of efficency.

	handle_tactics() is used for 'cheap' processing that needs to happen fast, such as walking along a path, initiating an attack, or firing a gun.
The rate that it is called allows for the ai_holder to interact with the world through its mob very often, giving a more convincing appearance of intelligence,
allowing for faster reaction times to certain events, and allowing for variable attack speeds that would not be possible when bound to a two second Life() cycle.

	handle_strategicals() on the other hand, is for 'expensive' processing that might be too demanding on the CPU to do every half a second, such as re/calculating an A* path, or
running a complicated tension assessment to determine how brave the mob is feeling. This is the same delay used for certain tasks in the old implementation.

	Having two seperate process procs allows for 'fast' and 'slow' actions to be more easily encapsulated, and ensures that all ai_holders are syncronized with each other,
as opposed to having individual tick counters inside all of the ai_holder instances.  It should be noted that handle_tactics() is called first,
before handle_strategicals() every two seconds.

	Both process procs work in a similar fashion, using a large amount of 'stances' to act in a specific way, effectively creating a state pattern.
There are 10 stances implemented, and more can easily be added by defining them and switching to them with the set_stance() proc.
This is similar to the old implementation, except with a vastly larger amount of options for the AI to make use of.
See code/__defines/mob.dm for the stance defines and descriptions about their purpose.

Each stance is evaluated once per tick, meaning that switching the stance takes effect on the next tick.




*/