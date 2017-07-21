/datum/lore/codex/category/political_factions
	name = "Political Factions"
	data = "Those wishing to immigrate to somewhere in Vir, or otherwise plan to stay for a long time should get to know human politics.  \
	There are presently three major political parties that exist throughout SolGov space, being the Icarus Front, the Shadow Coalition, and \
	the Sol Economic Organization, and several smaller ones which tend to align themselves among one of the major parties.  In the Vir system, the \
	Icarus Front's influence is much less than somewhere closer to Sol, and the other two parties being more popular."
	children = list(
		/datum/lore/codex/page/icarus_front,
		/datum/lore/codex/page/shadow_coalition,
		/datum/lore/codex/page/sol_economic_organization,
		/datum/lore/codex/page/mercurials,
		/datum/lore/codex/page/positronic_rights_group,
		/datum/lore/codex/page/church_of_unitarian_god,
		/datum/lore/codex/page/friends_of_ned,
		/datum/lore/codex/page/multinational_movement,
		/datum/lore/codex/page/free_trade_union,
		)


/datum/lore/codex/page/icarus_front/add_content()
	name = "Icarus Front"
	keywords += list("Icarus", "IF")
	data = "The political group with the most seats in the [quick_link("SolGov")] legislature and control over the heartworlds of humanity, the Icarus Front is a \
	conservative body with a long history, tracing its linage back to the political unrest that created the Sol Confederate Government. Icarus calls \
	for severe restrictions on \"transformative technologies\" any technology with the power to fundamentally alter humanity, such as advanced artificial \
	intelligence and human genetic augmentation. Previously an unbeatable political force, recent changes have lead to its power backsliding. It remains a \
	popular party among those from Sol, Tau Ceti, and other heavily settled systems."

/datum/lore/codex/page/shadow_coalition/add_content()
	name = "Shadow Coalition"
	data = "A disorganized liberal party, originating in an anti-[quick_link("Icarus")] shadow government.  'Shadow' in this case, refers to acting as an opposition \
	party to the Icarus majority. The Shadow Coalition calls for the lifting of certain Icarus-restricted technologies, especially medical \
	technologies with the ability to drastically improve quality of life. While fractious and prone to infighting, the Shadow Coalition and affiliated \
	parties remain the most popular political groups in the large towns and small cities of humanity, including Vir."

/datum/lore/codex/page/sol_economic_organization/add_content()
	name = "Sol Economic Organization"
	keywords += list("SEO")
	data = "The newest force in [quick_link("SolGov")] politics, backed by the massive [quick_link("TSC", "Trans-Stellar Corporations")] and the [quick_link("Free Trade Union")], \
	as well as former [quick_link("Icarus")] warhawks. The SEO campaigns for minimal regulation on the development of new technologies, seeing them as anti-capitalist and \
	inefficient, and have gained significant traction among futurists, those wishing for a more impressive human military, and employee-residents of TSC \
	corporate towns, such as the [quick_link("Northern Star")].\
	<br><br>\
	[quick_link("Nanotrasen")], a R&D firm, is generally regarded as the most enthusiastic supporter of the SEO. Other contributing TSCs include the next six largest corporations \
	in human space: "+quick_link(TSC_WT)+" GMC, "+TSC_GIL+" Exports, Grayson Manufacturing Ltd., Aether Atmospherics and Recycling, [quick_link("Zeng-Hu Pharmaceuticals")] and "+TSC_HEPH+" \
	Industries, as well as, notably, [quick_link("Vey-Med")]. The Free Trade Union's participation in the SEO is a contentious issue that many of its members disagree with, but \
	most FTU representatives caucus with the SEO."

/datum/lore/codex/page/mercurials/add_content()
	name = "Mercurials"
	keywords += list("Mercurial")
	data = "[quick_link("Positronics")] and the rare augmented human who want to follow a different cultural path from the rest of humanity, viewing themselves as fundamentally \
	separate from unaugmented biological humans. Previously an illegal movement, proscribed due to the preceived dangers of unfettered self-modification and the threat \
	posed by positronics without human values in mind, self-described Mercurials still often find themselves persecuted or used by bioconservatives as scapegoats \
	and 'boogiemen'. As a technoprogressive group, they tend to vote along with the [quick_link("Shadow Coalition")]."

/datum/lore/codex/page/positronic_rights_group/add_content()
	name = "Positronic Rights Group"
	keywords += list("PRG")
	data = "The other side of the coin from the [quick_link("Mercurials")], the PRG wants full integration of [quick_link("positronics")] into human society, with equal wages, opportunities \
	to advancement, and representation in the media. Their current pet cause is a tax credit for humans who wish to adopt or sponsor the creation of a positronic, \
	a measure supported due to its potential to counteract the aging positronic population and to bring the average positronic closer to human culture.  They tend to vote \
	along with the [quick_link("Shadow Coalition")], due to being technoprogressive."

/datum/lore/codex/page/church_of_unitarian_god
	name = "The Church of the Unitarian God"
	keywords = list("Unitarian Church")
	data = "An often-imperfect fusion of various human religions such as Christianity, Islam, and Judaism, the Unitarian Church represents the dim voice of \
	religion in a time of increased atheism. With the threat of singularity looming once more, their power is increasing with more converts and more donations, \
	and they use this power to protect the fundamental human soul from corruption by dangerous technologies and to spread their faith among aliens and positronics, \
	who they view as fellow children of God.  They tend to side with bioconservatives."

/datum/lore/codex/page/friends_of_ned/add_content()
	name = "Friends of Ned"
	keywords += list("Ned")
	data = "The metaphorical reincarnation of a human named Ned Ludd's original Luddites, disdaining that name's negative connotations and embracing their original \
	purpose-- the restriction of technology that poses a threat to people's livelihoods. In addition to [quick_link("Icarus Front")] technological restrictions, the Friends demand \
	the complete prohibition of [quick_link("Drone", "drone intelligence and AGI research")], with most also opposing the [quick_link("FTU", "FTU's")] plans for wide spread \
	nanofabrication deployment. While the party refrains from making a definitive statement on their view of [quick_link("positronics")], many Friends have taken it upon themselves to label \
	them \"anti-labor technology\", and nominally-unsanctioned lynchings have marred the faction's reputation."

/datum/lore/codex/page/multinational_movement/add_content()
	name = "Multinational Movement"
	keywords += list("Multinational")
	data = "The barely-unified voice of [quick_link("SolGov", "SolGov's")] various independence movements, encompassing Terran governments wishing for a lighter touch \
	from SolGov, fringe colonies who balk at the call of distant masters, anarchist movements who want the freedom to live without government oversight, and the rare \
	Trans-Stellar who no longer see a benefit in working with SolGov. Full colonial independence is still a political impossibility so long as the \
	[quick_link("Icarus Front")] holds any sway, and so the Movement is focused primarily on securing more autonomy in governance, although a growing revolutionary sub-group \
	wants to force their change on the government en masse. The Multinational Movement finds themselves in an uneasy alliance with the [quick_link("SEO")], connected by their corporate, \
	fringe-system membership, and often provide a dissenting voice to SEO's war hawks."

/datum/lore/codex/page/free_trade_union/add_content()
	name = "Free Trade Union"
	keywords += list("FTU")
	data = "A softer counterpoint to the [quick_link("SEO")], the FTU is a party representing small businesses, workers' syndicates, and trade unions, who advocate for government \
	measures to reduce the amount of power held by the TSCs. In many ways a holdover from the days before the [quick_link("Shadow Coalition")], where corporate malfeasance took \
	the place of technological development as the primary issue of debate, the FTU has found itself adopting technological positions similar to the SEO as a matter \
	of pragmatism, although the views of individual members vary. The FTU is known for their intense lobbying of SolGov to add tax rebates to the purchases of \
	personal lathes and the creation of open-source firmware for experimental autolathes, but have thus far found little success."