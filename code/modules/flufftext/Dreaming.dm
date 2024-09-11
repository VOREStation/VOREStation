
var/list/dreams = list(
	"an ID card","a bottle","a familiar face","a crewmember","a toolbox","a " + JOB_SECURITY_OFFICER,"the " + JOB_SITE_MANAGER,
	"voices from all around","deep space","a doctor","the engine","a traitor","an ally","darkness",
	"light","a scientist","a monkey","a catastrophe","a loved one","a gun","warmth","freezing","the sun",
	"a hat","the Luna","a ruined station","a planet","phoron","air","the medical bay","the bridge","blinking lights",
	"a blue light","an abandoned laboratory","NanoTrasen","mercenaries","blood","healing","power","respect",
	"riches","space","a crash","happiness","pride","a fall","water","flames","ice","melons","flying","the eggs","money",
	"the " + JOB_HEAD_OF_PERSONNEL,"the " + JOB_HEAD_OF_SECURITY,"the Chief Engineer","the Research Director","the Chief Medical Officer",
	"the " + JOB_DETECTIVE,"the " + JOB_WARDEN,"an Internal Affairs Agent","an Engineer","the Janitor","the Atmospheric Technician",
	"the Quartermaster","a Cargo Technician","the Botanist","a " + JOB_SHAFT_MINER,"the Psychologist","the Chemist","a Geneticist",
	"the Virologist","the Roboticist","the Chef","the Bartender","the Chaplain","the Librarian","a mouse","an ERT member",
	"a beach","the holodeck","a smoky room","a voice","the cold","a mouse","an operating table","the bar","the rain","a Skrell",
	"an Unathi","a Tajaran","the Station Intelligence core","the mining station","the research station","a beaker of strange liquid",
	"a Teshari", "a Diona nymph","the supermatter","Major Bill","a Morpheus ship with a ridiculous name","the Exodus","a star",
	"a Dionaea gestalt","the chapel","a distant scream","endless chittering noises","glowing eyes in the shadows","an empty glass",
	"a disoriented Promethean","towers of plastic","a Gygax","a synthetic","a Man-Machine Interface","maintenance drones",
	"unintelligible writings","a Fleet ship",
	//VOREStation Additions after this
	"slimey surroundings","a sexy squirrel","licking their lips","a gaping maw","an unlikely predator","sinking inside",
	"vulpine assets","more dakka","churning guts","pools of fluid","an exceptional grip","mawing in faces","gaping throat",
	"swallowed whole","a fox","a wolf","a cat","a tiger","a dog","a taur","a xenochimera"
	)

/mob/living/carbon/proc/dream()
	dreaming = 1

	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			to_chat(src, span_blue("<i>... [pick(dreams)] ...</i>"))
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return
		dreaming = 0
		return

/mob/living/carbon/proc/handle_dreams()
	if(client && !dreaming && prob(5))
		dream()

/mob/living/carbon/var/dreaming = 0
