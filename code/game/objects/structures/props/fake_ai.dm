// A fluff structure to visually look like an AI core.
// Unlike the decoy AI mob, this won't explode if someone tries to card it.
/obj/structure/prop/fake_ai
	name = "AI"
	desc = ""
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai"

/obj/structure/prop/fake_ai/attackby(obj/O, mob/user)
	if(istype(O, /obj/item/aicard)) // People trying to card the fake AI will get told its impossible.
		to_chat(user, span("warning", "This core does not appear to have a suitable port to use \the [O] on..."))
		return TRUE
	return ..()

/obj/structure/prop/fake_ai/dead
	icon_state = "ai-crash"

/obj/structure/prop/fake_ai/dead/crashed_med_shuttle
	name = "V.I.T.A."
	icon_state = "ai-heartline-crash"