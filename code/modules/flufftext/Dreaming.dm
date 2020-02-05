
var/list/dreams = list(
	"an ID card","a bottle","a familiar face","a crewmember","a toolbox","a security officer","the Colony Director",
	"voices from all around","deep space","a doctor","the engine","a traitor","an ally","darkness",
	"light","a scientist","a monkey","a catastrophe","a loved one","a gun","warmth","freezing","the sun",
	"a hat","the Luna","a ruined station","a planet","phoron","air","the medical bay","the bridge","blinking lights",
	"a blue light","an abandoned laboratory","NanoTrasen","mercenaries","blood","healing","power","respect",
	"riches","space","a crash","happiness","pride","a fall","water","flames","ice","melons","flying","the eggs","money",
	"the head of personnel","the head of security","a chief engineer","a research director","a chief medical officer",
	"the detective","the warden","a member of the internal affairs","a station engineer","the janitor","atmospheric technician",
	"the quartermaster","a cargo technician","the botanist","a shaft miner","the psychologist","the chemist","the geneticist",
	"the virologist","the roboticist","the chef","the bartender","the chaplain","the librarian","a mouse","an ert member",
	"a beach","the holodeck","a smokey room","a voice","the cold","a mouse","an operating table","the bar","the rain","a skrell",
	"an unathi","a tajaran","the ai core","the mining station","the research station","a beaker of strange liquid",
	//VOREStation Additions after this
	"slimey surroundings","a sexy squirrel","licking their lips","a gaping maw","an unlikely predator","sinking inside",
	"vulpine assets","more dakka","churning guts","pools of fluid","an exceptional grip","mawing in faces","gaping throat",
	"swallowed whole","a fox","a wolf","a cat","a tiger","a dog","a taur","a xenochimera"
	)

mob/living/carbon/proc/dream()
	dreaming = 1

	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			to_chat(src, "<font color='blue'><i>... [pick(dreams)] ...</i></font>")
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return 0
		dreaming = 0
		return 1

mob/living/carbon/proc/handle_dreams()
	if(client && !dreaming && prob(5))
		dream()

mob/living/carbon/var/dreaming = 0
