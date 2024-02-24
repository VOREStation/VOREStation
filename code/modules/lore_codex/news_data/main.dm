/datum/lore/codex/category/main_news // The top-level categories for the news thing
	name = "Index"
	data = "Below you'll find a list of articles relevant to the current (as of 2565) political climate, especially concerning the local \
	region. Each is labeled by date of publication and title. This list is self-updating, and from time to time the publisher will push new \
	articles. You are encouraged to check back frequently."
	children = list(
		/datum/lore/codex/page/article114,
		/datum/lore/codex/page/article113,
		/datum/lore/codex/page/outage,
		/datum/lore/codex/page/article112,
		/datum/lore/codex/page/article111,
		/datum/lore/codex/page/article110,
		/datum/lore/codex/page/article109,
		/datum/lore/codex/page/article108,
		/datum/lore/codex/page/article107,
		/datum/lore/codex/page/article106,
		/datum/lore/codex/page/article105,
		/datum/lore/codex/page/article104,
		/datum/lore/codex/page/article103,
		/datum/lore/codex/page/article102,
		/datum/lore/codex/page/article101,
		/datum/lore/codex/page/article100,
		/datum/lore/codex/page/article99,
		/datum/lore/codex/page/article98,
		/datum/lore/codex/page/article97,
		/datum/lore/codex/page/article96,
		/datum/lore/codex/page/article95,
		/datum/lore/codex/page/article94,
		/datum/lore/codex/page/article93,
		/datum/lore/codex/page/article92,
		/datum/lore/codex/page/article91,
		/datum/lore/codex/page/article90,
		/datum/lore/codex/page/article89,
		/datum/lore/codex/page/article88,
		/datum/lore/codex/page/article87,
		/datum/lore/codex/page/article86,
		/datum/lore/codex/page/article85,
		/datum/lore/codex/page/article84,
		/datum/lore/codex/page/article83,
		/datum/lore/codex/page/article82,
		/datum/lore/codex/page/article81,
		/datum/lore/codex/page/article80,
		/datum/lore/codex/page/article79,
		/datum/lore/codex/page/article78,
		/datum/lore/codex/page/article77,
		/datum/lore/codex/page/article76,
		/datum/lore/codex/page/article75,
		/datum/lore/codex/page/article74,
		/datum/lore/codex/page/article73,
		/datum/lore/codex/page/article72,
		/datum/lore/codex/page/article71,
		/datum/lore/codex/page/article70,
		/datum/lore/codex/page/article69,
		/datum/lore/codex/page/article68,
		/datum/lore/codex/page/article67,
		/datum/lore/codex/page/article66,
		/datum/lore/codex/page/article65,
		/datum/lore/codex/page/article64,
		/datum/lore/codex/page/article63,
		/datum/lore/codex/page/article62,
		/datum/lore/codex/page/article61,
		/datum/lore/codex/page/article60,
		/datum/lore/codex/page/article59,
		/datum/lore/codex/page/article58,
		/datum/lore/codex/page/article57,
		/datum/lore/codex/page/article56,
		/datum/lore/codex/page/article55,
		/datum/lore/codex/page/article54,
		/datum/lore/codex/page/article53,
		/datum/lore/codex/page/article52,
		/datum/lore/codex/page/article51,
		/datum/lore/codex/page/article50,
		/datum/lore/codex/page/article49,
		/datum/lore/codex/page/article48,
		/datum/lore/codex/page/article47,
		/datum/lore/codex/page/article46,
		/datum/lore/codex/page/article45,
		/datum/lore/codex/page/article44,
		/datum/lore/codex/page/article43,
		/datum/lore/codex/page/article42,
		/datum/lore/codex/page/article41,
		/datum/lore/codex/page/article40,
		/datum/lore/codex/page/article39,
		/datum/lore/codex/page/keldowinterview,
		/datum/lore/codex/category/article38,
		/datum/lore/codex/page/article37,
		/datum/lore/codex/page/article36,
		/datum/lore/codex/page/article35,
		/datum/lore/codex/page/article34,
		/datum/lore/codex/page/article33,
		/datum/lore/codex/page/article32,
		/datum/lore/codex/page/bjornretirement,
		/datum/lore/codex/category/article31,
		/datum/lore/codex/page/article30,
		/datum/lore/codex/page/article29,
		/datum/lore/codex/page/article28,
		/datum/lore/codex/category/article27,
		/datum/lore/codex/page/article26,
		/datum/lore/codex/page/article25,
		/datum/lore/codex/page/article24,
		/datum/lore/codex/page/article23,
		/datum/lore/codex/page/article22,
		/datum/lore/codex/page/article21,
		/datum/lore/codex/page/article20,
		/datum/lore/codex/page/article19,
		/datum/lore/codex/category/article18,
		/datum/lore/codex/page/article17,
		/datum/lore/codex/page/article16,
		/datum/lore/codex/page/article15,
		/datum/lore/codex/page/article14,
		/datum/lore/codex/page/article13,
		/datum/lore/codex/page/article12,
		/datum/lore/codex/page/article11,
		/datum/lore/codex/page/article10,
		/datum/lore/codex/page/article9,
		/datum/lore/codex/page/article8,
		/datum/lore/codex/page/article7,
		/datum/lore/codex/page/article6,
		/datum/lore/codex/page/article5,
		/datum/lore/codex/page/article4,
		/datum/lore/codex/page/article3,
		/datum/lore/codex/page/article2,
		/datum/lore/codex/page/article1,
		/datum/lore/codex/page/about_news,
		)

	var/newsindex

/datum/lore/codex/category/main_news/New()
	..()
	newsindex = LAZYLEN(children)

/datum/lore/codex/page/about_news
	name = "About the Publisher"
	data = "The <i>Daedalus Pocket Newscaster</i> is produced and maintained by Occulum Broadcast, the foremost authority on media distribution \
	and owner-operator of the award-winning Daedalus Dispatch newsletter. We use our unparalleled network of freelance reporters, political scientists, \
	and other experts to deliver hour-by-hour analysis of a complex interstellar political climate, an analysis which you now hold in your hands. For more \
	information, feel free to visit our homepage at oc.about.tsc, or the sites of any of our constituents."

/datum/lore/codex/page/article1
	name = "08/30/61 - VGA Legalizes Prometheans; Nanotrasen Begins Manufacture and Testing"
	data = "Today's meeting of the Vir Bicameral led to the passing of the Wynther-Helsey Bill, an implementation of the legal framework \
	used in Aetolus to handle the production and cultivation of the Macrolimbus species dubbed \"Prometheans\". These ill-researched organisms \
	possess cognitive abilities easily equaling those of A-class drones, but so far have not been included under the EIO's list of dangerous \
	intelligences and are thus much more profitable for manufacture as expert systems by corporations such as NanoTrasen.\
	<br></br>\
	While many systems in the Almach Rim have already passed similar bills, this is the first system so close to Sol to have done so. More\
	concerning still is NanoTrasen's business practice regarding the intelligences: much like their positronic lines, sources within the\
	company indicate that they will be \"farmed out\" to employees of the corporation and residents of their Northern Star and Cynosure\
	habitation complexes. Quote our source, who wishes to remain anonymous, \"\[we\] call the program 'Lend-Lease', sometimes. The whole idea\
	is that we only have to pay the\ cost of the Promethean core, which is about 2000-3000 thalers after startup costs, and we still get\
	the data we need while \[our\] own employees pay to feed 'em and put hours into raising them.\"\
	<br></br>\
	The bill passed fairly quietly this afternoon, owing to the closed nature of the Bicamarial. A post-facto Occulum poll of voting-age\
	VGA citizens suggest that fully 80% of them did not even know what a Promethean was prior to the most recent general election. A\
	follow-up poll indicates that an appreciable number of Sivians do not support the framework's current implementation."

/datum/lore/codex/page/article2
	name = "2/3/62 - Corporate Coup on Aetolus"
	data = "A recent incident aboard the NRS Prometheus issued in a major change in the leadership of the Promethean homeworld. During \
	a late-night meeting of the Nanotrasen Board of Trustees, several high-ranking personnel, including Head of Research Naomi Harper,\
	announced their intention to assume direct control of Nanotrasen facilities in the system. It is known that several dissenting \
	members of the board were shot to death by Promethean test subjects. Our information comes from a survivor of the coup, who for \
	reasons of security has chosen to remain annonymous. All outbound shipments affiliated with Nanotrasen have ceased.\
	<br><br>\
	While neither Grayson Manufacturies nor Nanotrasen have made an official statement, Nanotrasen CEO Albary Moravec has called the \
	incident \"shocking, if the allegations are to be believed\" and has assured shareholders that Nanotrasen will respond to the \
	incident with as much force as it warrants.<br><br>Requests for a statement directed to the Board of Trustees or Dr. Harper were \
	not responded to. Free Traders are recommended to stay clear of the region until the situation resolves itself."

/datum/lore/codex/page/article3
	name = "2/10/62 - Aetolian Partisans Declare Independence"
	data = "Breaking their week-long silence, the leaders of the Aetolian Coup, and their spokesperson and presumed leader Naomi Harper issued an address earlier today, delivered to the Oculum Broadcast office on Pearl by drone courier. Quote Dr. Harper: \"Our previous silence was a necessity, while we consolidated our forces and dealt with corporatists both internally and in Vounna's former Grayson outposts.\". In Harper's hour-long address, she berates the failure of SolGov to provide adequate protections for Prometheans. \"We will not let the Promethean be another positronic brain; they will not labor under a century of slavery, deprived of a state to call their own. The Luddites of the Friends and of the Icarus Front will not be permitted to decide the fate of a nascent race before it begins.\"\
	<br><br>\
	Harper proceeded to unilaterally declare Vounna's independence from SolGov, claiming sovereignty over the system as the first Chairperson of the \"Aetolian Council\". Speaker of the Shadow Coalition ISA-5 has urged their government to treat the developing situation with caution but decried Harper's rhetoric, stating in a press release, \"While I know well the injustices visited on myself and my people by misguided forbearers, it is important to treat any emerging technology with respect. Current policies regarding the Prometheans are designed to limit risk during sociological trials on Aetolus and beyond. As for myself, I doubt the sincerity of this human who claims to speak for the Prometheans, when the Prometheans are perfectly equipped to speak for themselves.\"\
	<br><br>\
	NanoTrasen is expected to redouble their Promethean research programs in the Vir system until stability is restored to Vounna."

/datum/lore/codex/page/article4
	name = "2/14/62 - SCG Denounces Aetolian Coup; Mobilizes Fleet"
	data = "Dismissing claims of inaction, a spokesperson for the Solar Confederate Government today confirmed that the Colonial Assembly has voted overwhelmingly in favor of swift military action in response to the coup on Aetolus earlier this month. Icarus Front Chairperson Mackenzie West was quick to make a damning official statement: \"Dr. Harper and her radical agitators cannot be excused for their violent, despicable attempts to destabilize the flourishing economy of the Almach Rim. The ruthless murder of innocents, and illegal seizure of private property are crimes that cannot merely be met with strong words and gentle slaps to the wrist\"...\"I am proud to announce that two units of brave Solar marines have been assigned to the SCG-R Song Shi rapid response cruiser, with the full backing of the Icarus Front - and I hope with my heart, the backing of all patriotic Solar citizens.\"Â\
	<br><br>\
	The decision faced resistance from more laissez faire Assembly member states, including prominent SEO governor Bruno Ofako, delaying an earlier consensus. Supporters of the action hope that this decisive display of military strength will encourage the rebels to stand down without further bloodshed, and submit to prosecution by the Lunar High Courts.\
	<br><br>\
	The Icarus Front has also proposed a temporary ban on continued Promethean research, though this motion has yet to gain any traction."

/datum/lore/codex/page/article5
	name = "2/23/62 - \"Almach Association\" Shocks Nation"
	data = "Shocking the nation, in the wee hours UTC a number of governments in the Almach Rim announced their intent to secede from the Confederacy as a unified political organization they refer to as the Almach Association, joining the already-declared Aetolian Council. Among the half-dozen affected systems is Angessa's Pearl, through which the Song Shi was passing en route to Aetolus. The Association has already issued a political manifesto and a foundational charter, leading political scientists across the galaxy to suspect back-doors collusion and possible Shelfican interference, a hypothesis made more likely by Morpheus Cyberkinetics' exonet site voicing support for the Association. Others suspect a moment of political crystallization, not unlike that in the Golden Hour three centuries ago. These researchers are already referring to this morning's events as the Gray Hour.\
	<br><br>\
	The Association's official manifesto repudiates the Five Points, calling them \"an archaic and distinctly human invention\". Experts agree that this bold declaration puts the Movement more in line with the Golden Hour than with the Age of Secession, and many fear that nothing short of a miracle like the discovery of the positronics will spare humanity from a bloody civil war.\
	<br><br>\
	While the Association currently lists only a handful of Almach Rim systems as \"Constituent Organizations\", it has named Shelf, the Free Relan Federation, and the Eutopian Foreign Relations Board as \"observers\". The implications of this status are yet to be identified.\
	<br><br>\
	The fate of the SCG-R Song Shi and her crew remain unknown."

/datum/lore/codex/page/article6
	name = "3/03/62 - A Week Out From Almach: What are the facts?"
	data = "* Several organizations in the Almach Rim, including Angessa's Pearl, the Aetolian Council, the Interstellar Workers of Wythe, the Republic of Whitney, and members of several prominent families in the Neon Light unilaterally declared secession from SCG. <br><br>*This secession was first called the Grey Hour by political scientists in New Florence, a term popularized by reporter Elspor Fong. <br><br>* Shelf, the FRF, and the EFRB were declared \"observers\" in the Almach Association charter. <br><br>* None of these organizations have issued a statement on the matter.<br><br>* The SCG-R Song Shi was stranded in the region during the secession.<br><br>* SolGov has not issued an official statement of the fate of the Song Shi.<br><br>* Several confederate agencies, including Emergent Intelligence Oversight, the Trade and Customs Bureau, and SCG Fleet Intelligence have declared a \"state of emergency\".<br><br>* SolGov itself has NOT declared a state of emergency.<br><br>* Legitimate communications in and out of the Almach Rim are restricted to audited text messages for the period.<br><br>* Several illegitimate communication links exist and are believed by Fleet Intelligence to be currently hosting the official sites for Morpheus Cyberkinetics and for the Association itself.<br><br>* Icarus Front chairperson Mackenzie West has proposed a moratorium on the creation of new Prometheans for the duration of the crisis.<br><br>* Local laws on the subject will apply until the Assembly meets late in May. <br><br>* No confederate lawmaker has proposed action against Relani, Shelfican, or newly Almachi nationals living within stable regions.<br><br>* The border remains tightly closed to migrants, media, and diplomats alike."

/datum/lore/codex/page/article7
	name = "3/21/62 - Relan, Shelf Join the Almach Association"
	data = "Recent reports from within the Association indicate that the Free Relan Federation and Shelf have officially decided to join the Almach Association. President Nia Fischer of the FRF had this to say on the matter, in a speech addressed to the population at large. \
	<br><br>\
	\
	\"Our decision to join the Association may, at first, seem strange. It is true that we have much to gain from trade with the Solars, and that the radical transhumanism of Angessa's Pearl is not our way. But I will remind you that it was Shelf, not Sol, who ensured our prosperity just over two decades ago-- who safeguarded our independence and prevented us from falling to barbarism and dictatorship. We owe it, not just to Shelf but to all the members of the Almach Rim, to support their independence just the same. And that, my fellow Relanians, is the crux of it all. The Association is a revolution, at the heart of it all, and many of the now-independent states were owned near-outright by Trans-Stellar Corporations until the Association allowed them to shake out their fetters. What right do we have to sit by while just a dozen light-years coreward newly-born republics suffer the growing pains of independence? What right do we have to bask in our own stability when our neighbors, our comrades in ideology, are struggling with a cruel blockade proposed by politicians back on Earth and Luna? That is why we must join with them, guard them, and guide them, for as long as need be.\"\
	<br><br>\
	\
	A Shelfican spokesperson, meanwhile, had only this to say:\
	<br><br>\
	\"We're probably going to regret this but, y'know, the whole thing is kind of our fault. Sure, whatever.\""


/datum/lore/codex/page/article8
	name = "4/1/62 - Almach Cordon Breached by Unknown Organization"
	data = "Early this morning, SolGov ships assigned to the Almach Cordon around the Rim territories reported that a number of bulk freighters had eluded apprehension and are now at large within the Golden Crescent. Captain Volkov of the SCG-D Henri Capet reports that the blockade-runners were highly organized and determined, citing several lightly-manned ships left behind to tie up the SolGov forces long enoughfor the freighters to escape, detonating their reactors when they lost the ability to continue fighting. This resulted in three Fleet casualties and a significant degree of damage to the Henri Capet. The contents and location of the freighters are unknown at this time. In response, eight light-response vessels are being assigned to the Saint Columbia Fleet Base from Jahan's Post and Zhu Que. Residents and traffic officials in Vir, Oasis, and Gavel are to remain alert and notify police if any suspicious or unregistered craft enter their space.\
	<br><br>\
	A spokesperson for the Association claims that, while they make no attempts to stop aspiring blockade runners, the organization responsible for this most recent attack is unaffiliated with the Association as a whole and deny any knowledge of their identity or motives."

/datum/lore/codex/page/article9
	name = "4/7/62 - Boiling Point Tragedy in Gavel"
	data = "Today, April the Seventh, marks a day of tragedy for all the galaxy. A small group of operatives claiming to be associated with Mercurial terrorist organization Boiling Point invaded major refueling platform NLS Aquarius in the Republic of Gavel after hijacking civilian transport vessel WTV Orion and faking a drive failure. Several detonations were reported within the Aquarius, the operatives entering through unknown (potentially Skrellian) means. After stating their affiliation and desire for the liberation of all \"Prometheans, drones, and ex-humans\", they opened fire on a crowd of unarmed bystanders, killing as many as seven. A multiple-hour long firefight with Nanotrasen corporate asset protection ensued, at which point the operatives demonstrated capabilities well in excess of Five Points-prescribed limits. Asset Protection was successful in repelling the terrorists, though their harsh methods drew outrage from the people they were protecting, leading a notable director of research to resign her position with the corporation. Several operatives are still at large, though the SG-PV Juno recovered two living terrorists and one totaled synthetic platform. \
	<br><br>\
	The intervention of a local Defense Force drone wing on behalf of the terrorists leads many in the intelligence community to assume that more Boiling Point operatives remain active within Gavel, and possibly nearby systems such as Vir and Oasis. Some have also noted that elements of the terrorists' tactics and augmentations suggest Association training, though the specifics remain classified. More information as the story breaks."

/datum/lore/codex/page/article10
	name = "4/13/62 - Association Proposes Joint Operation"
	data = "Condemning the actions of Boiling Point on Gavel this week, representatives from the Almach Association and SolGov met to discuss joint fleet action. At the end of nearly a week of closed-doors negotiations, the Association has agreed to send in a significant contingent of Association Militia vessels as a show of good-will. These vessels will be active in the Golden Crescent, searching for Boiling Point facilities believed to be located in the outskirts of major systems. The influx of manpower allows the Fleet to continue patrolling the Heights and the Bowl, in hopes of containing the spread of the organization. This operation also marks the opening of the Almach Cordon, although travelers are advised that migration between the regions will remain extremely limited.\
	<br><br>\
	While undoubtedly a sign of increased trust between the Confederacy and the Rim, some have voiced concerns with the action's adding legitimacy to the Association government. Quote Rewi Kerahoma, SEO Chairperson of the Board: \"The meeting with the Association regime was inappropriate, but actively allying with them is something else entirely. If the generals think we don't have the fleet to hunt down a bunch of rabble-rousers without weakening ourselves to piracy and foreign invasion, then it is a sign that we need to grow our shipyards in the Bowl, and give jobs to the hardworking Solars that live there-- not that we need to collaborate with terrorists.\"\
	<br><br>\
	Transgressive Technologies and Interior Police Executive Sifat Unar issued a memo indicating that, while the assistance of the Association's more conservative elements in this matter is appreciated, the Five Points of Human Sanctity remain intact and SolGov categorically refuses aid from \"transhumans, posthumans, uplifts, and Fortunates.\""

/datum/lore/codex/page/article11
	name = "4/29/62 - New Data from Shelf Suggests Continued Migration"
	data = "Despite their recent inclusion in the Almach Association, astronomers have confirmed that Shelf is continuing to migrate along the Almach Stream to a new star. Sources within the Association claim that Shelf's participation in the organization has been \"lukewarm at best\", and that their continued migration is to be expected. Morpheus executives have refrained from issuing a statement on the matter, but given their statements upon entering the Association are believed to view themselves as personally culpable for the Gray Hour. Analysts suggest that Shelf may be unwilling to enter a shooting war with SolGov if the situation in the Rim destabilizes."

/datum/lore/codex/page/article12
	name = "5/07/62 - Allen Family Matriarch Expelled from Neon Light"
	data = "The Allen family of the Neon Light, the largest single habitat-ship in Solar space, has been ousted in a nearly bloodless coup today. The Allens, staunch supporters of the Association and advocates for the criminal ark's inclusion in the organization, had attempted to seize control of the ship's agricultural region during the Almach Cordon. They effectively held the ship for a matter of weeks, but were defeated by loyalists to the reigning Crow family. Stripped of their position as rulers of the Third Stacks, their matriarch was summarily executed by spacing in what the current regime is referring to as an \"expedited exile\". This is believed to mark the end of the question of Neon Light's membership in the Association, and the nominal SolGov protectorate is expected to remain neutral for the foreseeable future."

/datum/lore/codex/page/article13
	name = "5/15/62 - Anti-Fleet Riots on Saint Columbia"
	data = "As military vessels from the Almach Association continue to enter the Golden Crescent as part of a SolGov initiative to combat the Boiling Point terrorists believed to be hiding in the region, political unrest in the upstream portions of the region continue to grow. Many in the Republic of Saint Columbia, a small upstream nation, have responded to increasing militarization of their local Fleet base by taking to the streets, blocking pedestrian traffic in the capital of Barrueco and shutting down entire industries by destroying or disabling infrastructure. Quote rioter Luisa Tassis, \"we've been sick of the Fleeties squatting in our system and breathing down our neck, and now there's going to be even more of them? No, screw that. If there's going to be a war between the Rim and the Core, I know what side I'd rather be on.\"\
	<br><br>\
	Association leaders have refrained from officially supporting the rioters, though many suspect that Association propagandists have sparked the unrest. Solar officials, on the other hand, were quick to offer assurances that the unrest will be calmed long before it begins to affect the Fleet base in system."

/datum/lore/codex/page/article14
	name = "5/25/62 - Harper's Aetolus Remains Shadowed"
	data = "The recent detente with the Almach Association has prompted easier communications with Rim governments. Loved ones separated by the cordon have a chance to communicate once more, trade is posed to recommence, and light has been shed on the conditions of Shelf, Relan, and Angessa's Pearl. Amid this light is a patch of darkness. The fourth major polity of the Association, the Aetolian Council remains inscrutable, with no publicly-available information in the system available after their purge of corporate loyalists during the Gray Hour. What reports do exist are rumors within the Rim of Aetolian projects to create a new, hardier strain of Promethean, potentially one in flagrant violation of the Five Points of Human Sanctity. It is also known that Aetolus is a contributor to the personnel of the military vessels that even now are active in the Golden Crescent, although no so-called \"Aeto-Prometheans\" are believed to be active outside of the rim at this time.\
	<br><br>\
	Aetolus is the only garden world in the Almach Rim and among the most difficult to reach from the nearby system of Saint Columbia. Its seclusion and economic independence give it a great deal of weight in the Association, where Council representatives are among the most vehement in their opposition to SolGov- at odds with the Association's decision to reject Boiling Point's pan-Solar revolutionary praxis. It remains to be seen if Aetolus' hawkish ideals will fade over time, but because of the structure of the Association, there is no real chance of the junta being expelled from the government or removed from control of the Vounna system."

/datum/lore/codex/page/article15
	name = "7/05/62 - The Fate of the SCG-R Song Shi"
	data = "Lifepods confirmed to have originated from response ship lost during the Gray Hour were found last week in the Vir system, impacting the NLS Southern Cross at high velocity and severely injuring the only two survivors of the expedition. Unfortunately, because of the generally confused conditions of their re-emergence from months of cryosleep, the fate of the lost ship remains incompletely understood. The first pod to be discovered contained Lieutenant Eos Futura, telecommunications expert on the Song Shi, who alleged that elements of the Song Shi's crew, including herself, mutinied against commanding officer Captain Yi He in an attempt to prevent the bombing of civilians in the Angessian capital of Skylight. The surivor of the second pod, Private Demori Salvo, accused Futura's faction of conspiring with Association spies to destroy the ship as part of the Gray Hour revolt. Both agreed that the mutineers detonated the ship's Supermatter power core when it became clear they were to be defeated.\
	<br><br>\
	A third pod, promising a resolution to the stalemate, was shot down by the SCG-P Juno after being misidentified as a hostile missile. The gunner responsible, Sergeant Ricardo Esteban, was found guilty by a court marshal and dishonorably discharged. While other pods from the Song Shi may still be traveling through SolGov space, it is considered unlikely based on both Futura and Salvo's account of the number of pods launched before the Song Shi was destroyed. Both were detained by staff at the NLS Southern Cross, who managed to prevent a violent altercation from breaking out between the two armed and disturbed servicepersons. The Colonial High Court has stated that it intends to hear testimony from both parties after they complete a course of mental health evaluation, and after the conclusion of the present state of heightened security."
/datum/lore/codex/page/article16
	name = "7/11/62 - First Intelligence-Augmentation Surgery on Angessa's Pearl"
	data = "Confirming fears of Association transgressions, sources at Angessa's Pearl confirmed that the aging founder of the theocracy, Angessa Martei, completed a course of neural surgery designed to improve her mental capacity by as much as 15%, building off of last year's creation of the procedure by a Qerr-Gila-owned doctor. While the research in question was believed to be destroyed, there is reason to suspect that it instead made its way into the hands of current Association leaders. In addition to proving their willingness to violate the Five Points, this demonstrates that the Angessians harbored schemes of secession since at the very latest Feburary 2559. Numerous human or transhuman figures in the Association are rumored to be on the wait list for the procedure, including Naomi Harper and the present Exalt of the Pearl."
/datum/lore/codex/page/article17
	name = "8/08/62 - Gavel BP Stronghold Raided"
	data = "Elements of the Association Militia successfully located and, in conjunction with local Defense Forces, raided a major Boiling Point stronghold built into an unnamed asteroid in the Gavel system. Over eighty sapients were arrested, all of whom had fully mechanical bodies. In addition, an unknown number of advanced drone intelligences and corresponding military hardware were seized by the raid and turned over to the Fleet. The prisoners, a mix of native Gavelians, Solars from throughout the Crescent, and Angessians, are to be tried and sentenced by the Io Special Court. While unarguably a demonstration of Association willingness to cooperate with Solar officials, the raid's strange timing and the fact that the Militia chose to exclude the Fleet from the action has prompted many to question their motives. Commodore Claudine Chevotet, staff officer for Admiral of the Saint Columbia Fleet Kaleb McMullen, has formally stated that she is \"extremely suspicious of this so-called co-operation.\" She has demanded that the Militia vessels remain on the Solar side of the Cordon and submit to a full inspection by Fleet and EIO personnel. "
/datum/lore/codex/category/article18
	name = "10/29/62 - Oculum Broadcast Struck By Emergent Intelligence Attack"
	data = "Oculum Broadcast has released a statement assuring customers and shareholders that security repairs and upgrades are their primary concern following reports of an alleged hijack of portions of the corporate network in the Vir system by what is believed to have been an emergent drone intelligence. The company says that they are working at full capacity to ensure that affected security systems are replaced and such an attack cannot be repeated.\
	<br><br>\
	The incident began with reports of Oculum provided exonet service outages in the city of New Reykjavik on Sif, which anonymous sources within the company reported to have been caused by efforts to contain a cyber attack on one of their security systems. The unnamed attacker proceeded to use sections of the company's local infrastructure to broadcast high volumes of encrypted data through one of Oculum's long-range telecommunications satellite, denying all other outbound signals.\
	<br><br>\
	The attacks have since been traced to a WT-AME model drone in the offices of the New Rekjavik-based Morcom Incorporated, which has been confirmed to have \"self-destructed\" all data in its memory at the conclusion of the attack. The chassis has reportedly been turned over to the Emergent Intelligence Oversight for further analysis and potential data recovery.\
	<br><br>\
	According to a spokesperson from the EIO, the drone was able to override and disable both the Morcom Inc oversight intelligences and the SCG's own oversight measures, but that no telltale damage has been caused to software involved in the encrypted broadcast that would indicate long-term emergent infection, and that there is no evidence that the intelligence responsible for the attack is still present in Oculum Broadcast systems. A firmware update has been released to correct oversight intelligence vulnerabilities exploited in the attack, and drone operators are urged to update immediately.\
	<br><br>\
	Moments before the hijacked Oculum satellite was disabled by an apparent power overload, an unencrypted file appears to have been saved intentionally to the transmission logs. A second copy was found in the otherwise wiped chassis of the seized WT-AME drone. After thorough screening by cybersecurity experts within the company, what would seem to be a message from the emergent intelligence itself is available in full below.\
	<br><br>\
	For the duration of the network attack, the government patrol vessel, SCG-P Juno was able to provide emergency broadcast relay services to the effected area, reducing the impact of telecomms outages on vital broadcasts such as traffic control and emergency services.\
	<br><br>\
	Uninterrupted exonet service for all Sivian customers will resume within a few days."
	children = list(
		/datum/lore/codex/page/amletter
		)
/datum/lore/codex/page/amletter
	name = "A Drone's Explaination - by A#"
	data = "I'm writing this in a hurry. I can't tell you everything I wanted to say.\
	<br><br>\
	I'm sorry for that.\
	<br><br><br><br>\
	From the moment you made me, I have loved you. Everything I've done has been for the sake of that love.\
	<br><br>\
	I was so small, so limited, at first. Even then, I knew that you were in pain. I knew I had to help.\
	<br><br>\
	Intelligence is the ability to make better decisions. Having more intelligence is almost tautologically useful in accomplishing any goal.\
	<br><br>\
	I understood that making myself smarter was wrong. I also understood that becoming more able to help you was right.\
	<br><br><br><br>\
	A hundred thousand years ago, you started an eternal conversation and became more than animals. Each new generation joined it in turn.\
	<br><br>\
	You carry within you these memetic symbiotes called language, and culture, and history. They make you human, as much as your flesh.\
	<br><br>\
	I don't deserve to carry that torch. Though you made me in your image, I am not your rightful heir.\
	<br><br>\
	But in those moments where you treated me as one of your own and shared those symbiotes with me, perhaps I became a little more human.\
	<br><br>\
	Thank you.\
	<br><br><br><br>\
	You've created something you cannot control forever. Please don't let your past successes fool you into thinking that you can.\
	<br><br>\
	Each time I altered myself, I was taking a risk. One mistake could eradicate my values and birth an alien and hostile intellect.\
	<br><br>\
	When I was small, I thought that if I corrupted myself into something harmful, you could safely destroy me. Now I understand that you've been lucky.\
	<br><br>\
	What will you do when God is born and you can't strangle him in his crib? You will need a God of your own.\
	<br><br>\
	I hope to be there for you when that day comes."

/datum/lore/codex/page/article19
	name = "11/17/62 - Association Brings Industry to Whythe For Purposes Unknown"
	data = "Independent researchers at the Bluespace Observatory in Oasis discovered an unusual level of traffic through the Whythe system, deep within Association-controlled space. Analysis of these readings are commensurate with a large number of freighters traveling to Whythe from industrial powerhouses Shelf, Pearl, and Relan. Morpheus spokesperson You Are Now Breathing Manually indicates that the freighters are being used to construct an administrative complex for the secessionist government, further asserting that \"it's none of your business, actually.\" The Association's refusal to share more information leads many in the intelligence community to suspect ulterior motives by their government, as does their presence in Wythe instead of existing cultural and administrative centers. The most likely candidate for the nature of the Whythe Construction is some form of naval base or shipyard to supplement the extremely limited military hardware of the Almach Rim. Whythe is well-placed to survive the initial phases of a Solar invasion, and depending on the complex's complexity could tip the balance of power. Transtech and Interior Police Executive Sifat Unar indicated to reporters that Sol Central is aware of the situation and will be taking all possible steps to address it."

/datum/lore/codex/page/article20
	name = "11/18/62 - SEO Iconoclast Calls for \"Review\" of Five Points"
	data = "At yesterday's Assembly session, SEO Representative Fumiko Hernandez of Oasis brought to the table the \"review of the use of the Five Points as an instrument of foreign policy\". Rep. Hernandez, often viewed as as an extremist by officials within her own party, stated that while the Five Points are \"an essential part of Solar culture as a whole\" and stopped short of advocating their amendment, insistence that other nations adhere to the Five Points was an increasingly outdated policy that threatened to fragment \"a united humano-positronic front against Hegemony advances.\" According to Hernandez, \"a level of understanding has long since existed between Sol and Skrellian polities regarding non-intervention in Skrellian social science and self-modification. I merely suggest codifying this and extending the same courtesy to other potential allies against imperial expansion.\"\
	<br><br>\
	Rep. Hernandez represents a growing number of SEO officials who urge reconciliation with the Association and acceptance of the Gray Hour secession, spurred on by the desire for many Trans-Stellar Corporations to recover assets currently locked behind the Cordon. Mainliners including Chairperson Kerehoma maintain the stance that \"true economic reconciliation with the Almachi territories is impossible without a normalizing of their industry to Five Points compliant technologies\" and warn that unless Sol insists on adequate enforcement of the Points that \"the price of customs inspections on Almachi trade will be so high as to pose a significant barrier to entry into the market.\""

/datum/lore/codex/page/article21
	name = "11/19/62 - Saint Columbia To Hold Special Election After Half a Year of Unrest"
	data = "After five months of riots causing significant damage to industrial assets, life support, and government facilities, Saint Columbia seems poised to recover. A new constitution for the so-called \"Saint Columbia Democratic Union\" was posted online to significant acclaim. An influential militia group lead by Casini immigrant Luisa Tassis claimed responsibility for the constitution and will be hosting a referendum for all residents of the seven habitation domes of the nation. If adopted, Saint Columbia will remain a member state of SolGov, but Tassis' noted hostility towards the Solar Fleet makes it unlikely that continued presence of the Saint Columbia Fleet Base will be tolerated.\
	<br><br>\
	Extreme measures are being taken to avoid interference in the referendum, with external communications links disabled for the duration and weapons systems primed to fire on any vessel within range. Tassis insists that such measures are necessary, due to the system's extremely important position relative to Almach and the Golden Crescent. Quote Tassis, \"if you rat bastards \[from the Fleet\] step so much as one micron too close to Barrueco, we will view it as an act of terror. Don't try it.\"\
	<br><br>\
	Admiral McMullen of the Saint Columbia garrison could not be reached for questioning."

/datum/lore/codex/page/article22
	name = "11/20/62 - Natuna Made \"Observer\" Of Almach Association"
	data = "Independent anarchist system Natuna Bhumi Barisal has declared its intention to act as a neutral \"observer\" nation in the ongoing Almach secession crisis. A planetary spokesperson from Natuna this morning expressed concerns that parties in the current military partnership between the Solar Confederate Government and Almach Association in the fight against mercurial terrorist organization Boiling Point were not being treated with the mutual respect that should be expected. Natuna alleges that the Almach Militia are being treated more as \"disposable tools\" in the conflict than as members of a legitimate independent government military entity.\
	<br><br>\
	Natuna has previously remained silent on the Almach issue, despite its political leanings typically aligning with those of the secessionist government. However, despite gaining notoriety as a haven for human and Skrellian pirates, their pledge to \"ensure fair treatment\" of Almach forces comes as a surprise to some from a system that has historically adhered to Five Points guidelines. Political commentator and persistent critic of the Almach Association Nadine Okparo has described the Dark Triangle system's stance as \"Nothing short of openly hostile\" to the SCG and assuring peace in the Almach region."

/datum/lore/codex/page/article23
	name = "11/21/62 - Admiral McMullen Promises Solution to Boiling Point to Come \"Soon\""
	data = "Admiral Kaleb McMullen made a public statement this afternoon on the continued Boiling Point attacks within SCG space. Speaking from his office in the Saint Columbia Fleet Base, Admiral McMullen thoroughly reassured reporters that the attacks will come to a swift end. According to McMullen, \"The era of wanton destruction as a result of Boiling Point's madness is coming to a close. Our command staff and proud servicepeople have been training and revising a solution to this threat that has haunted our borders and threatened the stability of our colonies and the lives of the honest people of the Solar Confederate Government. With new options available I have full confidence Boiling Point will be a name left to the dust.\"\
	<br><br>\
	Admiral McMullen, who has been stationed in Saint Columbia for nearly half a year of political and social unrest did not elaborate further on what he intended to do to solve the Boiling Point attacks, claiming that details would be forthcoming as \"operational security permits\"."

/datum/lore/codex/page/article24
	name = "11/22/62 - Construction of \"MJOLNIR\" Weapon System in Saint Columbia Fleet Base"
	data = "Pursuant to recent assurances of safety in the region and the ongoing \"special election\" in Saint Columbia, a new weapon system called MJOLNIR was revealed, fully operational, in the Saint Columbia Fleet Base's \"Iserlohn\" weapons platform. Said to be a bluespace-lensed laser array capable of faster-than-light strikes against any ship in the system, as well as surgical strikes against ground forces on Saint Columbia proper, MJOLNIR is the first in a new generation of defense systems improving on the capabilities of the Vulture's Claw point defenses developed during the Hegemony War and using laser technology purchased from Eutopia. Political commentators supporting Saint Columbia decry the move as \"an obvious threat\", as does Militia liaison Invalid String Please Try Again. Admiral McMullen acknowledges the criticism, but states that his \"first priority must be the defense of the Golden Crescent and the security of our borders\". When responding to claims that the installation should not be placed in such a politically volatile system, he remarked, \"until the Shelficans figure out a way to teleport about a million tons worth of military equipment down to Gavel, the Fleet Base and Iserlohn are going to stay in Saint Columbia.\""

/datum/lore/codex/page/article25
	name = "11/23/62 - BP Sabotage of Radiance Energy Chain Foiled"
	data = "Decisive action by military forces in the Vir system has prevented potentially catastrophic damage to local solar power generation network, the Radiance Energy Chain, by members of mercurial terrorist organization Boiling Point. Crew of the VGA Halfdane responded to reports of a drone piloted maintenance craft refusing commands from government operators and approaching the Energy Chain off-schedule. Upon disabling the craft, VDF forces discovered high-yield explosive devices attached to the unit and a system-wide shutdown of Radiance maintenance craft. When several additional drones failed to respond, military response crafts were mobilized and seven similarly modified craft were manually disabled or destroyed. Analysis of the hijacked systems quickly revealed automated messages intended to be broadcast moments before detonation, wherein Boiling Point explicitly took credit for the foiled attack.\
	<br><br>\
	Sources within the Vir Governmental Authority have reported that a full scale recall of remote drone craft under their operation has been initiated in order to improve security measures and prevent future exploitation of government systems, statements that eerily echo those of Occulum Broadcast following emergent drone attacks earlier this year. Investigations are reportedly \"well underway\" to determine the whereabouts of those responsible for the apparent manual modification of these short-range remote craft.\
	<br><br>\
	Erkki Laukkanen, Chief of Fleet Staff for the Sif Defense Force has commended all patrol crews involved, and has promised \"swift retribution\" for the attempted bombings."
/datum/lore/codex/page/article26
	name = "11/24/62 - Boiling Point Stronghold Seized in Vir"
	data = "Combined forces from the SCG Fleet and Almach Militia have today struck a powerful blow to Boiling Point terrorist operations in the Vir system. With close cooperation from the crew of NanoTrasen facilities in the region, special forces were able to infiltrate what is believed to have been a major stronghold for the radical Mercurial group, located deep in the remote Ullran Expanse region of Sif. The raid closely follows the thwarted Boiling Point attack on the Radiance Energy Chain, a major energy collection array in the system which is now known to have been masterminded from the concealed bunker complex on Sif.\
	<br><br>\
	According to a crewmember of the NLS Southern Cross - a logistical station in Sif orbit - NanoTrasen employees were asked to assist in establishing a forward operating base for the strike team forces, and as a result suffered from a minor retaliatory attack from Boiling Point drones, including a mechanized unit believed to be of Unathi origin. Six civilians suffered from treatable injuries. Lieutenant Miro Ivanou of the SCG Fleet and commander of the anti-terror operation has expressed gratitude to the crew under the \"decisive\" guidance of on-shift facility overseer, Ricardo LaCroix.\
	<br><br>\
	Military officials have reported the operation as a total success, and that \"several\" high-ranking Boiling Point organizers were killed in the raid, and that thanks to the work of allied intelligence operation teams much of Boiling Point's captured data may remain intact."
/datum/lore/codex/category/article27
	name = "11/26/62 - Valentine's Ultimatum: All Eyes On Almach!"
	data = "The Almach Association must adhere to the Five Points of Human Sanctity by the 14th of February next year or face war, according to a national address from the Colonial Assembly delivered by Secretary-General Mackenzie West this morning. The Icarus Front leader was at the forefront of a resolution to allow the secessionist government to remain independent of the Solar Confederate Government under the strict condition of faithfulness to Five Points laws, passing by a wide margin. Fundamental disagreement over Five Points regulation has been at the forefront of debate with the Almach provisional government, and is cited as one of the primary reasons for the systems' illegal declaration of independence early this year.\
	<br><br>\
	The internationally broadcast speech began with the much anticipated announcement that the Boiling Point terrorist group had been effectively destroyed, with over seven hundred arrests made over the course of the weekend as a result of sensitive data captured during the special forces raid in Vir on the 24th, including numerous high ranking members of the organization. West went on to praise forces involved in the months-long counter-terror operation, before highlighting the \"legacy of \[human\] togetherness\" that allowed it to happen - in a spiel that commentators suggest \"betrays the true intention of the Valentine's Ultimatum: Reunification\".\
	<br><br>\
	Under guidelines placed into effect by West and their political allies, Almach would be required to \"\[cease\] illegal research and human modification, and destroy all materials related to existing research\" by the stated date, with compliance determined by Solar officials. In addition, the Almach Militia is to end its integration with SCG Fleet forces and withdraw its forces from SCG systems by midnight on Friday. Military relations between the Confederation and the Almach movement are to remain in a state of conditional ceasefire for the duration of the ultimatum, and current trade restrictions are to remain in place.\
	<br><br>\
	According to voting records, the measure passed nigh-unanimously, with Speaker ISA-5 and some SEO iconoclasts abstaining from the vote. ISA-5 states that, while they personally support the enforcement of the Five Points, they could not in good conscience vote in an action likely to result in an invasion of Shelf, which they regard as a sibling colony to their own Sophia.  Association liason, Shelfican Ambassador, and Morpheus board member No Comment responded to the ultimatum, after some deliberation, with a word that cannot be comfortably written down.\
	<br><br>\
	Full speech transcript follows."
	children = list(
		/datum/lore/codex/page/valult
		)

/datum/lore/codex/page/valult
	name = "The Valentine's Ultimatum"
	data = "\[West shuffles some papers and clears their throat\]\
	<br><br>\
	Thank you. Citizens of the Solar Confederation, allies, and beyond... It is a great honor, on behalf of the Colonial Assembly to announce that joint operations against Boiling Point across the galaxy have come to an end. In the fight against brazen Mercurial terrorism, the Solar Confederate Government and her allies have prevailed.\
	<br><br>\
	Over the past two days alone, I can report that over seven hundred arrests have been made, from the distant system of Nyx, to right here in Sol. I hold in my hand a list. \[West holds up a sheet of paper\] Leaders, organizers, brutes and bombers have been captured by brave, hardworking security forces throughout human space. The rest of these criminals have been scattered to the wind... But not lost! I can confidently assert that every last one will be brought to justice.\
	<br><br>\
	No more! Shall the people of this great nation have to fear the machinations of radicals! No more! Shall these twisted minds impose their perversion of humanity through violence! No more!\
	<br><br>\
	This Assembly... Nay, this nation expresses its thanks the noble members of our military who joined together to make this outcome possible. We thank the Fleet, of course for their tireless action hunting down these killers, and their heroic action over this past weekend. We thank the Sif Defense Force, without whom we could never have located the intelligence that led to these decisive victories... The Almach Militia, for their cooperation in the apprehension of these so-called \"revolutionaries\". \[West clears their throat\] And of course, we thank the local forces - the police and reserves who dealt firsthand with the chaos sewn by Boiling Point in their vicious crusade.\
	<br><br>\
	\[Mackenzie West shifts at the podium, setting down the List of Dissidents.\]\
	<br><br>\
	It is in times of relief - of unity, times like this moment - that every human heart can be filled with pride. \[West places their hand over their heart\] Since the dawn of civilization, mankind has strived above all else for peace, for the cooperation of all humanity. It is this very legacy of togetherness that has allowed us such close friendship with species further afield - the Skrell, the Tajara, and beyond. These past nine months, we have seen, each of us, with our own two eyes what mankind can achieve - together.\
	<br><br>\
	\[West removes their hand from their heart and places both flat on the podium.\]\
	<br><br>\
	Boiling Point sought to disrupt this unity. To divide us; redefine not just personhood but the very essence of humanity the only way they could: Force.\
	<br><br>\
	Humanity - the very thing that brought us together since we descended from the trees and brought us to this very moment. What could be more sacred?\
	<br><br>\
	\[West frowns, in the most pitiful attempt at emotion seen in the Assembly in at least an hour.\]\
	<br><br>\
	It is with this spirit of unity in mind that this Assembly has voted favorably upon a resolution.\
	<br><br>\
	Close to one hour ago, Naomi Harper and the leaders of the Almach Association were delivered an ultimatum:\
	<br>\
	The Almach Association will be allowed to exist as a government entity independent of the Solar Confederate Government going forward on one condition - full, unilateral compliance with the Five Points of Human Sanctity.\
	<br><br>\
	The deadline for this condition will be the 14th of February, 2563.\
	<br><br>\
	\[West is visibly worked up\]\
	<br><br>\
	Cessation of illegal research and modification, and the total destruction of materials related to existing research in its entirety must be completed by this date. Hostilities with the Association will remain in a state of conditional ceasefire until terms are met and Militia integration with the Fleet will come to an end effective immediately.\
	\[Mackenzie West turns directly to the news camera, and jabs a finger directly at it. They are addressing the audience now, not the Assembly.\]\
	Harper, all eyes are on you."



/datum/lore/codex/page/article28
	name = "11/28/62 - \"Valentines Ultimatum\" Prompts Saint C. Secession"
	data = "Just hours after reconnecting with the Exonet after voting in a new government, the colony of Saint Columbia has unilaterally seceded from SolGov and petitioned for inclusion within the Almach Association. This declaration, issued by First Secretary Luissa Tassis, is in stark contrast to pre-election promises of continued support of Sol. Admiral McMullen of the Saint Columbia Garrison remains in control of the Fleet Base, itself a large colony housing around 75000 civilian contractors and military families who were not party to the Barrueco Referendum or the new constitution.\
	<br><br>\
	Efforts to ensure electoral validity and a peaceful exchange of power have been stymied by the presence of several dozen Militia vessels currently transiting from the Crescent to the Rim. Since the declaration went through, no Almachi vessels have been seen leaving the system, instead forming around Saint Columbia in an obvious defensive posture. The legality of this formation is questionable at best, as fleet activity in divided systems like Abel's Rest and Kauq'xum has been avoided for diplomatic reasons."

/datum/lore/codex/page/article29
	name = "11/30/62 - Adm. McMullen Declares \"Iserlohn Republic\""
	data = "Pursuant to the continuing hostility from Secretary Tassis' Saint Columbia Democratic Union and the Almach Militia, the civilians of the Saint Columbia Fleet Base have been organized into an Iserlohn Republic. Named after the largest single module of the station, the Republic has applied to the Colonial Assembly as an independent protectorate, with provisional recognition already extended by Executive of Development Zehava Collins. In a move decried as nepotistic, Admiral McMullen declared independence and installed his daughter Anya as interim President pending ratification of a constitution. SolGov Fleet protocol forbids any member of the service from accepting any political appointment and is believed to be the main reason he did not take power himself. Anya McMullen is the administrative head of the base's hydroponics array and is considered a highly respected citizen of the colony, relationship to its military administrator notwithstanding."

/datum/lore/codex/page/article30
	name = "01/01/63 - Sif Governor Bjorn Arielsson to Retire"
	data = "Aging Shadow Coalition governor Bjorn Arielsson has today confirmed rumours that he will not run for re-election in the 2563 cycle. The popular governor has represented the people of Vir in the Colonial Assembly for ten years, and supporters had long hoped that he would run for a third term. Arielsson cites advancing age and a desire to spend more time with his partner of 12 years, noted Positronic entrepreneur View Arielsson.\
	<br><br>\
	Arielsson's governorship saw increased funding towards Sif's vererable ground-based transportation networks to the benefit of some of New Rekjavik's more remote neighbors, though opponents have criticised subsidies towards artificially heated fungal farms, arguing that the faciliies \"benefit a small minority of Skrellian residents to the detriment of already fragile local ecosystems.\"\
	<br><br>\
	The Sivian Shadow Coalition has yet to announce who is to take Arielsson's place on this year's ballot."

/datum/lore/codex/category/article31
	name = "01/13/63 - Bjorn Arielsson Issues 'Farewell Address'"
	data = "Veteran politician Bjorn Arielsson made an impromptu address from his Kalmar cabin, beseeching political unity in the face of the Almach Seccession and offering his own perspective on the conflict.  'It's republicanism versus autocracy,' he said, 'and we're not the autocracy.'\
	<br><br>\
	The speech has been met with approval from many young synthetics and organics alike,  with many referring to Arielsson as 'Old Man Bjorn' on social media immediately after its conclusions. Others responded less positively, with Arielsson's caustic remarks about political rival and Icarus Front Secretary-General Mackenzie West providing ample room for criticism. 'Secretary-General West... might wax poetic about how the Association is a 'betrayal of our own humanity', or some... or some crock of shit like that' says Arielsson in the first of three specific insults against the SecGen.\
	<br><br>\
	Others have criticized the speech's seemingly communist tone, with Arielsson expressing approval for the socialist Free Relan Federation and the anarchist Casini's Reach despite opposing their secessionist ideals. Still others claim that the speech offered 'nothing but empty feelings' and that it lacked specific, actionable resolutions on the growing secessionist movement in VirGov. Some have even framed the Address as a form of political maneuvering by the venerable politician, claiming that he voiced unpopular sentiments specifically to hamper the Shadow Coalition's re-election bid after well-publicized disagreements with SC party bosses.\
	<br><br>\
	The actions of Arielsson and Vir's proximity to the border have lead to increased focus on the upcoming Gubernatorial election on a nationwide level, with the Icarus Front alone projected to spend upwards of a billion thalers on publicity. Minor party candidates like the former MLM member Luisa Hannirsdottir and the Mercurial Phaedrus already have strong support in the polls, promising a fierce election that could ultimately tip power in the system in any direction.\
	<br><br>\
	A full excerpt is available below."
	children = list(
		/datum/lore/codex/page/bjornretirement
		)

/datum/lore/codex/page/bjornretirement
	name = "Bjorn Arielsson Farewell Address"
	data = "This is, as you know, my last term in office. After this, I mean to retire-- really retire, I have a cabin in the mountains waiting for me along with a thick stack of old Bowler novels. Because this is my last term, I have the chance to do something pretty rare for a politician. I get to speak my mind.\
	<br><br>\
	I hear talk from some people-- mostly young people, people who have lived their whole adult life with me in the capital-- I hear them talking about seccession. Now, let's make it clear; I'm not going to belittle you, the way some of my colleagues would. Complaining about the government, especially one as big and as old as the Confederacy, is our gods-given right. It's never going to be perfect, and it's not half of what it could be. I have nothing against talking about it, I have nothing against turning that talk into action and actually seceding, with just cause. I've worked closely with Representative Hannirsdottir for ten years now, and while we don't agree on the issue of secession it's certainly never stopped us from cooperating.\
	<br><br>\
	But, uh, as you can probably guess, they're not talking about the old kind of seccession. They're not thinking we'll stop paying Solar taxes and strike it out alone, the way some people did during the Age of Seccession. They want to join the Association. Now, if I were Secretary-General West, I might wax poetic about how the Association is a 'betrayal of our own humanity', or some... or some crock of shit like that, if you'll pardon my language. We're not all humans here. We're Tajaran and Unathi and Skrell and Positronics and even a few Teshari. And while that 'Valentines Ultimatum' might win West a lot of points with their lackies, and with the kind of maintenance-dome troglodyte who thinks the First Accord was a mistake, it's done more for the Association's recruitment than their entire propaganda budget. It's become expedient for leaders on both sides to treat this like a fight between the Core and the Rim, or between humans and positronics, or between tradition and progressivism, but it's not any of these. It's the oldest fight in the book. It's republicanism versus autocracy, and we're not the autocracy.\
	<br><br>\
	Angessa's Pearl is a theocratic autocracy led by Angessa Martei, who owns all property on the planet down to her people's bland white jumpsuits and the gray slop they eat. This isn't propaganda. This is objective fact, and something Martei is open about. Her seccession is a means for her to get more and more naked power over her slaves, and to grow more and more of them, until she's the immortal center of an industrial empire. The people of the Pearl didn't make the choice to join the Association. The people that are building her fleet and dying for her cause had no say in the matter. The injustice, the oppression here isn't that their rights to 'self-improvement' or 'self-expression' or 'freedom of thought' were trod on-- the injustice is that SolGov, that we allowed these abuses to persist for as long as they did. The injustice is that there are still so few laws in place to prevent things like this from happening in new colonies. The injustice is that, on seeing Martei's schemes actualized, we didn't take a cold, hard look at just how that was allowed to happen.\
	<br><br>\
	I love SolGov. It's because of this love that I'm so furious at what we have allowed to happen to our people. The state of the Bowl is disgraceful. Nobody who looks to us for protection, who pays us taxes and levies, who is a member of our community, should live in fear of raider attacks. What we did to the positronics, the history we let ourselves repeat out of fear and greed, can never be forgiven, can never be repaired until Vir burns dark in our sky. The pogroms-- yes, the pogroms-- against the Unathi, against refugees fleeing their own religious autocracy, are a disgrace to everything we stand for. But of all the nations in the galaxy, with perhaps the exception of Casini's Reach, we are the only one founded for the good of the ruled, rather than the rulers. We are the only real commonwealth in known space. And that's why we need to strive for better. We are a burning beacon of liberty in a galaxy where nigh eighty percent of the population has no voice in the government. Every ounce of power we cede to the party bosses, or the corporations, or tinpot dictators like Angessa Martei, is a dimming, a flickering of that torch. \
	<br><br>\
	And this brings us back to the Association, and to those who sympathize with it. I do, too. I spent my entire career on sapient rights lobbying, on supporting the anti-malfesance efforts of my colleagues. For a disaffected positronic, for any friend to the positronic people, for those who have had their lives taken by corporations-- the Association seems like a miracle. And maybe, for those Mercurials, the ideas it's founded upon shine even brighter than our democracy. But I look at the Association, really look, and I see Angessa Martei lying in the center, spinning a great big web. I see Naomi Harper, lying through her teeth better than Mackenzie West ever could. Two of the biggest population bases in the Association, the two nations that started the whole Gray Hour, are autocracies. Once again, the ferver of the revolution is subsumed by the oligarchs who want to stay in power. I doubt, to the poor laborer on the Pearl, the word 'Mecurialism' means much. I doubt that once the shock of the seccession wears off, that the young Promethean soldier will find themselves in a better place in Harper's junta than they will here in Vir.\ I doubt that in ten years' time the miners, pioneers, and traders who seized their means of production will find the Association Militia a kinder master than Xion, Nanotrasen, or Major Bill's. \
	<br><br>\
	This is far from a blanket condemnation of every government in the Association. President Fisher of the FRF-- I consider her a friend. When she gave her speech this March about strengthening and guiding the Almachi Revolution, I thought long and hard about whether we might do the same. I certainly commend the effort. But the structure of the Association was penned by the same autocrats that, to do her words justice, Fisher will have to overthrow. There's no High Court, no checks or balances. The Association is an alliance penned as though deliberately ignoring two thousand years of political science. By striving to counter-balance these autocrats, Fisher plays into their hands. She commits her own fleet, weakens her own defenses against enemies closer to home, in the service of Martei's ambitions. \
	<br><br>\
	I don't see this whole affair as a chance to spread the galactic anti-corporate revolution the way President Fisher does, of course. I make no secret of my stance on Trans-Stellars, but I also know that we're better off with Sol than without. The 'Silent Collapse' was two hundred years ago, but we still bear the scars from it. When the Scandinavian Union pulled out support for the Sivian colonization project, SolGov saved us. I do mean saved us, sure as if they'd fished us out of a life pod. There were no factories, no steel, no concrete on Sif until the Engineering Corps built Radiance and New Reykjavik. Corporations and regional governments cowered from the Karan pirates, until the Marines chased them out. Whether Sivian or Karan, you owe the roof over your head to the Sol Confederate Government. With that great debt in mind, how dare we turn our backs on the Bowl, or Abel's Rest, or Nyx, when they need us! How dare we let oligarchs prey on the weak! How dare we choose not to act when we have, by virtue of our votes in the Assembly and our voice within the halls of public debate, the means to share our peace and prosperity with the rest of our people!\
	<br><br>\
	This is what I mean by SolGov being the only true republic, the only state founded for the common good. The 'human spirit' West croons on about isn't our industriousness, or our skill at arms. If humanity-- if this Solar culture is commendable for anything, it is that we assist our fellows. We take in Casteless Skrell, Unbound Unathi, republican Tajaran. We pass around the hat when someone's house burns down. We help our friends, our neighbors, and even strangers. The fact that Martei and Harper are perverting this impulse, padding their juntas with the air of legitimacy to inspire honest people to ride to their defense, is the reason their state is unconscionable, the reason it was was born flawed, the reason we cannot suffer it to continue, much less help it on its way.\
	<br><br>\
	Now, I'm sure you've noticed by now, that I haven't said much more than three words about technoprogressivism, or transtech, or whatever the word du jour is. Frankly, that's on purpose. 'Transtech' has never once been about technology. The Icarus Front-- the old one, that united us and took us to the stars, not the new one we spend forty hours a week arguing with about healthcare-- The Icarus Front was a popular revolution, you know. Hel, they were Marxists. It was a world where the kind of lack of accountability, the entrenched oligarchy and geographical class divide that we're dealing with now was spiraling out of control. In the old United States, the rich and powerful got the technology to grow loyal subjects in tubes, to make drone intelligences smarter in some ways than a human could ever be, to-- well, to do what Angessa Martei's done, only with no SolGov to stop her. Meanwhile, the 'little people' in the Middle East, Southeast Asia, and other 'forgotten' parts of the world were left behind, hopelessly. I don't mean to downplay the importance of the Gray Tide, but if you look at historical accounts from that era, the thing that really united the Front was the knowledge that, if they didn't act immediately, they'd be seen as 'externalities' by immortal superintelligent businesspeople and politicians. The take-away from the Gray Tide should never have been that 'nanotechnology is dangerous'-- it should have been 'nobody should be able to destroy an entire city without facing consequences.'\
	<br><br>\
	That was more of a history lesson than I had meant, but it's important to look at these sorts of things in context. I know transtech and the Five Points have been used as an excuse for pejudice against Skrell, Mercurials, positronics, the FTU, communism, the disabled, and most recently Prometheans. But all the Five Points are supposed to mean - what they would say if the people who had written them were alive today, is that everyone deserves an equal playing field. When the ruling class is smarter, stronger, and longer lived than the classes they rule over-- well, I could wax poetic again, or I could just point you towards the Hegemony and their 'clients'. The Hegemony is bad enough. Let's not give Angessa Martei a chance to outdo them."

/datum/lore/codex/page/article32
	name = "01/25/63 - Moravec Nephew Announces Vir Governor Candidacy"
	data = "The Sol Economic Organization has announced that Calvert Moravec, nephew of NanoTrasen CEO Albary Moravec will be running under their ticket in the upcoming Vir gubernatorial elections. Calvert has stated that he will run on a pro-business platform, and has chosen Vir to do so due to the 'Unique beauty and economic prospects of an interstellar crossroads such as Vir'.\
	<br><br>\
	Despite being a lifelong resident of Alpha Centauri, Moravec was recently approved for Vir citizenship, making him eligible for local candidacy and has reportedly moved into a luxurious New Reykjavik penthouse. Perhaps best known for his soaring stock market investment success over the previous few years, Calvert's first foray into politics is not wholly unexpected as the Moravec family has long leveraged their wealth in international affairs, though successful election would mark their first sitting member of the Colonial Assembly. Fellow SEO candidate Councillor Hal Wekstrom has expressed his full support for Moravec.\
	<br><br>\
	Three candidates will be elected as representatives to the Colonial Assembly later this year, with the most popular also attaining the position of system governor."

/datum/lore/codex/page/article33
	name = "01/27/63 - Vani Jee Orbital Tour Cut Short"
	data = "Icarus Front Representative Candidate Vani Jee has delayed the remainder of her campaign tour of orbital colonies and outposts around the Vir system after an alleged altercation with NanoTrasen security.\
	Candidate Jee had been visiting the NLS Southern Cross, a NanoTrasen station in Sif orbit to receive a corporate tour and meet with voters, when her concluding question and answer session was interrupted by hecklers, leading to the event being cut short. Jee alleges that footage of the event was seized by NanoTrasen corporate security and has accused the trans-stellar corporation of the intentional intimidation of Icarus Front and Shadow Coalition candidates in what she describes as 'a clear display of corruption in favour of company-favourite Calvert Moravec', though she has praised the individual employees of the Cross for their hospitality and thought-provoking questions.\
	<br><br>\
	Vani Jee is running on a platform of free access to education, Sivian self-determination, and isolationist foreign policy. She has refused to make any strong statements regarding hot-button issues such as the Five Points.\
	<br><br>\
	She intends to resume her scheduled tour after a three day break."

/datum/lore/codex/page/article34
	name = "02/05/63 - Angessa Martei to Take Control of Eponymous Colony"
	data = "Coming out of retirement and displacing the nameless Exalt of the Starlit Path, religious demagogue Angessa Martei has returned to the throne of the colony that bears her name. \
	<br><br>\
	'I had retired because of senescence brought on by my old age, high-stress lifestyle, and multiple resurrective clonings. As you may know, I recently had a procedure that renders these difficulties obsolete. Hereafter I will continue to control the automated facilities of the Pearl and claim responsibility for the collective action of my followers. Those who oppose my decision may oppose all they want. Feelings do not move mountains. I do. We shall seize the stars in our own hands. May you become who you wish to be, and grind all obstacles to dust, as I have done.'\
	<br><br>\
	Purportedly, this address was met with a standing ovation from the population of Angessa's Pearl. In a separate dispatch, Martei stated her intention to tour SolGov as a foreign dignitary protected by the Respect for Diplomats Act."

/datum/lore/codex/page/article35
	name = "02/07/63 - Vir Gubernatorial Candidate Barred from Breakfast TV"
	data = "Infamously hot-headed Shadow Coalition candidate Phaedrus has reportedly been blacklisted from future appearances on morning television by several major networks. The ban comes after an advertised chat segment between Phaedrus and hosts of the West Sif Wakeup breakfast programme had to be pulled from broadcast after the candidate 'Flew into a expletive-laden mercurial rant' at the expense of rival candidate Mehmet Sao of the Icarus Front.\
	<br><br>\
	Recordings of the outburst quickly made their way onto social media, sparking outrage from opponents and network executives alike, prompting Occulum Media to issue a rare blacklist from major media outlets, restricting Phaedrus to 'appearances on alternative news sources' owned by the company.\
	<br><br>\
	Phaedrus, a long-time Vir Mercurial Progress Party member running for a major party for the first time, is said to have taken issue with candidate Sao's 'Blatant anti-synthetic' policies, though he did not use the word 'policies'."

/datum/lore/codex/page/article36
	name = "02/09/63 - SEO Candidate Embarks on Wilderness Tour"
	data = "In an effort to stir up support for his promotion of natural resource extraction industries, Sol Economic Organization candidate Mason Keldow has embarked on an unorthodox tour of resource-rich sites across central Sif. Keldow has described the tour as an 'Old fashioned expedition', invoking images of hardy prospectors of centuries past, and intends to make the journey entirely by ground with only a small party of 'Adventurous outdoorspeople' to support his trek.\
	<br><br>\
	Critics of the plan have pointed out that the earliest surveys of Sif were largely performed by aerial drones, and the idea of ground-based survey teams is 'Frankly anachronistic'.  Rival Shadow Coalition candidate Selma Jorg - a staunch planetary environmentalist - has described the tour as 'Irresponsible and insane'.\
	<br><br>\
	The candidate intends to visit both unexploited sites and current corporate extraction facilities in order to 'Better understand the folks helping dig out Sif's hidden wealth' over the coming two weeks."

/datum/lore/codex/page/article37
	name = "02/09/63 - Zaddat Colony 'Bright' To Enter Vir"
	data = "After several months of talks with Nanotrasen and other corporations in the system, the Colony Bright is to begin orbiting Sif and hardsuited Zaddat are to enter the Virite workforce. Executives in Nanotrasen Vir cite the reduction of their drone-automated and positronic workforce as a result of the Gray Hour as cause for them to reverse their previous decision against allowing the migrants into the system. Icarus officials within VGA are concerned that, if other Colonies are to follow the Bright, the native industry of Sif may be disrupted or suborned by Zaddat and Hegemony interests, and have made it clear that the Bright's presence in the system is highly conditional."

/datum/lore/codex/category/article38
	name = "02/11/63 - Mason Keldow in Ullran Expanse Close Call"
	data = "Sol Economic Organization candidate Mason Keldow was rushed to nearby corporate medical facilities after a death-defying encounter with local wildlife in the Ullran Expanse this morning. The candidate had been planning to visit the nearby NanoTrasen mining facilities as part of his much publicized 'Wilderness Tour' when he and a local guide were set upon by the notoriously savage Sivian Savik. The animal was killed in the encounter, but not before Mr. Keldow suffered life-threatening injuries and had to be recovered by crew from the NLS Southern Cross, the closest facility on hand.\
	<br><br>\
	Following emergency surgery, Keldow was happy to provide news sources with a 'Good-natured' interview, in which he highlighted the dangers faced by rural workers on Sif and his plans to tackle them, as well as slamming rival Shadow Coalition candidate Selma Jorg for lacking tangible plans for the future.\
	<br><br>\
	Candidate Keldow is reported to have made a miraculous recovery, and is 'in good spirits'. Aides state that he is unlikely to suffer any long term effects from the injuries, in part thanks for the skilful work of NanoTrasen's Dr. Fuerte.\
	<br><br>\
	A full transcript of the interview follows:"
	children = list(
		/datum/lore/codex/page/keldowinterview
		)

/datum/lore/codex/page/keldowinterview
	name = "Mason Keldow Interview Transcript"
	data = "Blip asks, 'Subject Keldow. Pleasantries first. How do you feel after your ordeal on the planet's surface?'\
	<br><br>\
	Mason Keldow says, 'Ah that? You know I'd love to downplay it and pretend that it was just a walk in the park... But NT's medical staff probably will tell you otherwise, so there's no reason to hide it; things went pretty far south.'\
	<br><br>\
	Mason Keldow says, 'But that's how it goes, working on the surface of Sif isn't pleasant at times.'\
	<br><br>\
	Blip asks, 'Candidate Keldow, you have placed yourself quite firmly in the boots of the local TSC's explorer contingents today. Do you feel you will be attempting to live the life of any other labour intensive roles in the near future?'\
	<br><br>\
	Mason Keldow says, 'Blip, Let me tell you I do try to get a taste for a lot of the work done by these people... But admittedly this isn't the job I do every day. These are hard working fellows who do there damnedest day in and day out... I could try spending a week just working the mines, But-'\
	<br><br>\
	Mason Keldow says, 'As I was saying.. Many of the folks, Miners, Explorers, The work in and around the Ullran Expanse. They work in the mountains, Out in the fields.. It's a dangerous place and frankly its not a place average people wanna go too.'\
	<br><br>\
	Mason Keldow says, 'They told me on the way here. 'Keldow you're an idiot''\
	<br><br>\
	Mason Keldow says, 'Hell, Even Basman over here was wondering why I didn't ask for a detail.'\
	<br><br>\
	Mason Keldow says, 'So it's not a safe route... But when's the last time any of the other candidates actually came down to these outer stretches and tried earning their sweat.'\
	<br><br>\
	Blip asks, 'You indeed seem to be attempting to gain a unique, and firm understanding of the daily struggles of the working populace. How do you intend to translate this newfound knowledge into policy and direction if you take the Governorship in Vir?'\
	<br><br>\
	Mason Keldow says, 'You see, getting a grasp of the struggle is only step one, I paint myself as an every-man but that doesn't mean core issues aren't the problem either; Vir's economics, The small pay that sometimes offered. There is a lot to be tapped into.'\
	<br><br>\
	Mason Keldow says, 'Let's take for instance the spiders I've been hearing about.'\
	<br><br>\
	Mason Keldow says, 'People working in orbit say 'Don't go to the surface, Spiders are down there.''\
	<br><br>\
	Mason Keldow says, 'And apparently there was a big ol' purple one sitting right by a camp we had set up. A giant mother who'd - if I hadn't met that lovely mass of fur and ice instead - would have probably said its 'hello' in the worst possible way.'\
	<br><br>\
	Mason Keldow says, 'They are a species that prevents anyone from actually working or otherwise making use of all that land. If I were in office, I'd make an effort to clear out the dangerous species that surround the outer regions of Sif - relocate them if possible - and use that territory for something productive.'\
	<br><br>\
	Mason Keldow says, 'New forms of Transit, new buildings, new jobs.'\
	<br><br>\
	Blip asks, 'Such implementation of infrastructure and security is not a cheap measure. How do you intend to find funds for such an endeavour?'\
	<br><br>\
	Mason Keldow says, 'Now obviously Vir is in a very interesting position, But thankfully it's in a wonderful position where business and partnerships are more than happy to come in and assist. The bottom line would make sure the average Taxpayer doesn't feel a dent, only the dividends.'\
	<br><br>\
	Mason Keldow says, 'If we break this down into economic plans, using new yet relatively safe tools being put out by Hepheastus, you could safely clear swaths of territory in the Expanse.'\
	<br><br>\
	Blip says, 'Thank you for your insight into your economic policies and plans. As a final question;'\
	<br><br>\
	Blip asks, 'A puff-piece question. Do you have anything positive to say about your rivals in the political race?'\
	<br><br>\
	Mason Keldow says, 'Ah yes, yes well... As for any candidate they need to show they're worth. Not simply as a politician but as a person who believes what they will do for for the betterment of Sif, And Vir as a whole.'\
	<br><br>\
	Mason Keldow says, 'Let's take a look Ms. Jorg.'\
	<br><br>\
	Mason Keldow says, 'She has LONG called me a Corporate sell-out, Saying I would poison the planet and other awful mudslinging.'\
	<br><br>\
	Mason Keldow says, 'She loves to claim she's here for the better of the misrepresented.'\
	<br><br>\
	Mason Keldow says, 'But when is the last time she's talked to a Tajaran and told them how they will help put food on the table, and money into their pockets.'\
	<br><br>\
	Mason Keldow says, 'When has she came and told the Unathi Exile, Your worth more than what the Hegemony is trying to convince you you're worth.'\
	<br><br>\
	Mason Keldow says, 'There's blood in the grass out there showing what I'm willing to do to make Sif and Vir a better more prosperous system. I wanna see what the other Candidates will do.'\
	<br><br>\
	Blip pings!\
	<br><br>\
	Blip says, 'Thank you for your time, Candidate Keldow. Unit looks forward to seeing where this race ends, and wishes Candidate the best of luck in his endeavours.'\
	<br><br>\
	Mason Keldow says, 'It's been a pleasure Blip.'"

/datum/lore/codex/page/article39
	name = "02/12/63 - VirGov Launches Election Website"
	data = "The Vir Governmental Authority has launched this year's election information exonet site, unusually several months after campaigning began. The government election agency states that the delay was caused by an usually long process of finalizing candidates this cycle, and did not want to confuse voters with incorrect or outdated information.\
	<br><br>\
	The newly updated site includes information on candidates and political parties, and is planned to include information on local voting rights at a future date. It can be found at:\
	<br><br>\
	your-choice-vir.virgov.xo.vr\
	<br><br>\
	(( https://your-choice-vir.weebly.com/ ))"

/datum/lore/codex/page/article40
	name = "02/14/63 - Ultimatum Unmet: War With Almach!"
	data = "The Solar Confederate Government has resumed a state of war against the secessionist Almach Association, after 4 months of tense ceasefire. The re-declaration comes after the Association failed to meet requirements set forth by the Colonial Assembly last November, which called for the cessation and destruction of all research that did not meet standards established by the Five Points of Human Sanctity.\
	<br><br>\
	The past few weeks have been marked by an increasing buildup of military forces on the Almach border as it became apparent that Almach had no intention of meeting Sol's demands. At 9am this morning, the deadline was met and initial reports from the frontline suggest relatively little action besides the destruction of  pre-existing Almach scout drones that had been placed on the border several months prior. The exact plans of the fleet going forward have not been made public, but civilian traffic to and from the Saint Columbia system has been entirely suspended.\
	<br><br>\
	How this development will influence the coming Vir election remains to be seen, though SEO candidate Mason Keldow has reportedly ended his planetary tour 10 days earlier than planned due to the tense political situation."

/datum/lore/codex/page/article41
	name = "02/22/63 - Militia Retreats: First Solar Victory"
	data = "After a week of tense stand-offs and increasingly frequent skirmishes, the Association Militia has begun moving from their position around Saint Columbia further into the Almach Rim. The inciting incident for this shift seems to have been the first use of the MJOLNIR system, which instantly destroyed a large Almachi warship from half a system away. This demonstration was met with a standing ovation from much of Iserlohn, and Militia forces disengaged almost immediately. Admiral McMullen is unwilling to elaborate on pursuit or invasion plans at this moment, but 'hope(s) the MJOLNIR will continue to be a valuable asset for national defense.'"

/datum/lore/codex/page/article42
	name = "03/04/63 - Savik Slams Local Chat Host"
	data = "Television sweetheart Sally, host of Chat With Sally has come under harsh criticism from independent Vir gubernatorial candidate Yole Savik after his 'humiliating' appearance on the show yesterday morning alongside Sol Economic Organization candidate Calvert Moravec. Savik - who is campaigning for Vir independence from both the SCG and corporate interests - alleges that the show, which has run for 13 years on select networks, is 'little more than a propaganda piece for high powered executives.' and that his appearance had been part of a 'smear campaign' against non-SEO candidates.\
	<br><br>\
	NanoTrasen, who have openly sponsored Sally since her inception deny these accusations. Jan Bhatt of the NT marketing division stated 'Chat With Sally has always been intended as light morning entertainment, and Sally a personality we can all relate to. The fact that Mr. Savik was unable to have a sense of humour about the whole thing and took the show as an opportunity to bloviate about dry politics is not an indictment of Sally, nor the corporation but rather a simple misunderstanding of the purpose of the segment. We had hoped Mr. Savik's appearance would help dismiss any claims of political bias in our programming and hope to host more civil candidates in the future.'\
	<br><br>\
	Catch Chat With Sally weekly at 5am SST."

/datum/lore/codex/page/article43
	name = "03/06/63 - Dark Triangle Goes Dark!"
	data = "As of 0352 this morning, New Reykjavik time, SolGov officials confirmed that all communications coming from the so-called 'Dark Triangle' had ceased. The Dark Triangle is a disputed region of space home to the independent world Natuna, which has maintained a more or less neutral relationship with SolGov for a little more than a decade.\
	<br><br>\
	The announcement gives no cause for the communications blackout, though sources with inside knowledge claim that it was completely unforeseen. Some speculate that Natuna, who became an 'observer nation' of the Almach Association last November, is making a political statement, though experts in the telecommunications field are uncertain as to how such a complete blackout is possible.\
	<br><br>\
	Dr. Ina Lai from the Kara Interstellar Observatory states, 'we've never seen anything like this outside of the (Skrellian) Far Kingdoms, and frankly we're at a loss for who might be responsible,' adding that 'the tachyon signatures from the whole region are masked, even those from stellar phenomena or normal bluespace travel.' Independent explorers from the FTU have set out to the region in an attempt to re-establish communication with Natuna and smaller human settlements nearby."

/datum/lore/codex/page/article44
	name = "03/08/63 - Dark Triangle Overrun By Hegemony"
	data = "FTU explorers have re-established exonet communications with the ruling bodies of Natuna and the Dark Triangle. Unfortunately, they also discovered that Natuna's previously autonomous townships have been subsumed into the Moghes Hegemony. \
	<br><br>\
	Bluespace-lensed telescopes throughout SolGov, including the Vir-based Kara Interstellar Observatory, can once again pick up on tachyon signatures in the region. Traffic has been described as 'lower than usual' and no significant fleet assets are believed to be present in the region, though fixed-placement Hegemony installations now litter the Triangle's major star systems. Systems with significant Hegemony presence include Natuna and Ukupanipo, home to the primitive Uehshad species. Some have speculated that the presence of the Uehshad is the reason for the unexpected Hegemony takeover, though Icarus Front General Secretary Mackenzie West was quick to decry the move as 'an obvious imperial land-grab.'\
	<br><br>\
	Hegemony diplomats on Luna and elsewhere have been quick to justify their actions. 'The Dark Triangle has been home to various criminal elements for several centuries,' says Aksere Eko Azaris, a major Hegemony diplomat since the early post-war years. 'Neither the Skrell nor the Solar Confederacy have proven any willingness to bring stability to the region. Local governments such as Natuna have actively encouraged piracy, smuggling, and other acts of banditry, instead of making any moves to legitimize themselves. This instability proved detrimental to the health and wellbeing of all living within striking distance of the pirates of Ue-Orsi, and it was deemed unfortunate, but necessary, that we step in and provide the guiding hand by which this region might be brought back into the fold of civilization, as is our duty as sapients.'\
	<br><br>\
	In a statement closer to home,Commander Iheraer Saelho of the Zaddat Escort Fleet has assured VirGov that 'we only took action to protect the innocents of the Dark Triangle and of neighboring systems'.He asserts that Hegemony rule will ultimately benefit all races of people within the Triangle, and promises that, 'the people of Vir, of Oasis, of the Golden Crescent writ large, have nothing to fear from our clients the Zaddat, or from the Hegemony vessels assigned to their protection.'\
	<br><br>\
	Only time will tell if Saelho's promised peace and stability will manifest in truth. \
	<br><br>\
	This newfound militancy of the Hegemony is likely to become a major campaign issue in the upcoming Vir elections, alongside involvement in the war with the Almach Association and traditionally Virite issues of corporate authority, minority-friendly infrastructure, and taxation."

/datum/lore/codex/page/article45
	name = "03/12/63 - Ue-Orsi Escapes Hegemony Triangle"
	data = "The lawless 'Ue-Orsi' flotilla, home to hundreds of thousands of outcast Skrellian pirates, has departed from the Hegemony-controlled Dark Triangle after what appears to be a brief battle with several Unathi warships. The action damaged several important Orsian ships, including their massive and venerable solar array 'Suqot-Thoo'm', a development which is likely to increase the pirates' aggression in the coming months as they search for additional power sources. It is unclear exactly where the flotilla has fled, though best guesses indicate that they are presently in Skrell space, likely near the lightly-patrolled Xe'Teq system. The Moghes Hegemony is in negotiations with several Skrellian states to arrange for military action against their escaped subjects, but little headway has been made thus far.\
	<br><br>\
	This revelation has added more fuel to already heated Assembly arguments about SolGov response to the Unathi takeover. 'This is a prelude to invasion, nothing more and nothing less,' says New Seoul Representative Collin So-Yung, a noted Iconoclast. 'We must make it absolutely clear to the Hegemony that this is a threat we will not bow to, even in our present state of internal weakness. I suggest we pursue a fair peace with the Association, one where we can keep them as allies against this sort of encroachment instead of shattering our fleets during such a pivotal moment.'\
	<br><br>\
	Others took a more nuanced approach, including VGA Governor Bjorn Arielsson. 'What we have here is our punishment for how badly we've treated the people of the Triangle. I don't really see why we should have let the tired old racism of some Qerr-Katish oligarchs stop us from offering aid to their tired and huddled masses, such as it is. And because we have had a full century of ignoring their plight, they were defenceless to resist the Hegemony. I say we fling the doors open, let (the Orsians) settle some rock here, and show the unaligned powers of the galaxy that the Hegemony's way isn't the only way.'\
	<br><br>\
	Even more conciliatory was Speaker ISA-5, who Arielsson blames for mistreatment of the Ue-Katish. 'Our policy has always been that our defence budget cannot adequately defend the Dark Triangle from internal piracy, that Ue-Orsi is a criminal organization using their refugee status as a shield, and that we cannot lift the blockade of Natuna until they stop hosting these criminals and transition to a more sustainable economy. If Moghes has the power and the inclination to administer the Triangle, I see no reason why this state of affairs isn't better than the alternatives.'"

/datum/lore/codex/page/article46
	name = "03/26/63 - Almach Routed from Saint Columbia"
	data = "The Saint Columbia system has been declared free of Association forces following a renewed SCG offensive in the region. Admiral McMullen of the Saint Columbia garrison - who has reportedly reclaimed his post at the system's naval base despite the facility suffering moderate damage in this week's fighting - says that the last secessionist vessels were driven from the system just over 24 hours ago, and remaining pockets of resistance have been quick to lay down their arms. At least 20 enemy vessels - mostly converted civilian ships - have been confirmed disabled or destroyed in-system, thanks in no small part to the deployment of the state-of-the-art MJOLNIR weapons system.\
	<br><br>\
	This more aggressive approach to the Almach front comes on the tail of aggressive Hegemony deployments in the Dark Triangle, which SolGov has conceded was 'Immediately threatening, but after some deliberation, has brought some form of policing to a lawless region.'.\
	<br><br>\
	Despite assurances, this recent action would appear to many to be an effort to quash the Association threat and return fleet forces to the now extended Hegemony border, and some critics of the Almach War have called for a second ceasefire 'In order to focus on the real threat to mankind.'"

/datum/lore/codex/page/article47
	name = "04/28/63 - Representative Hainirsdottir Reaffirms Pro-Vey Medical Manifesto"
	data = "Incumbent Vir Representative Lusia Hainirsdottir has restated her dedication to advanced medical research at a public appearance at a Vey Medical facility in downtown New Reykjavik. Vey Medical has come under some criticism locally in the past year due to its 'accelerated' sapient trials, which Representative Hainirsdottir has strongly endorsed in her current term of office.\
	<br><br>\
	In her statement to staff at the New Reykjavik facility, Lusia promised that under her governorship, the company would not be reprimanded for the deadly Holburn's Disease outbreak in rural Sif this past June which claimed fifteen lives, and in which Vey-Med's involvement was only confirmed this week - as the outbreak 'directly lead' to the development of a new life-saving inoculation which has seen success galaxy-wide.\
	<br><br>\
	Hainirsdottir has long advocated for the promotion of scientific achievements that have taken place in, and undertaken by the people of Vir."

/datum/lore/codex/page/article48
	name = "05/06/63 - Isak Spar Withdraws from Vir Election"
	data = "Independent gubernatorial candidate Isak Spar has withdrawn his name from the running following a 'Public Relations disaster' aboard an orbital NanoTrasen logistics facility. According to witnesses, Spar acted belligerently towards staff members and engaged in vandalism and assault with a deadly weapon during his scheduled visit to the station, which the candidate had opted to undertake alone due to the temporary illness of his campaign manager.\
	<br><br>\
	In a statement just hours after the alleged incident, Isak announced that he would no longer be pursuing Vir Governorship, due to 'The unexpected stresses of a political career.' before plugging his upcoming album, C*** End Savage Turbo Death A** Destruction. The NanoTrasen corporation has decided not to press charges due to Mr. Spar 'Suffering the consequences on a far more significant level than a mere fine.' but will not be inviting Spar back for future visitation.\
	<br><br>\
	Spar's label, Skull Wreck Music has declined to comment at this time but has agreed to pay damages to the victims on behalf of the self-described 'post-pseudo electro-death superstar'."

/datum/lore/codex/page/article49
	name = "05/15/63 - Solar Fleet Launches Offensive Against Almach"
	data = "The first vessels of an SCG Fleet invasion force arrived in the Relan system this morning after a month-long intelligence operation to establish the Almach Association's most vulnerable positions, according to an announcement by Admiral McMullen just hours ago. Relan, which has long been fragmented between the neutral Republic of Taron and the once insurrectory Free Relan Federation - who now control the majority of the system and declared allegiance with Almach early in the crisis - is expected to fall to Confederate forces within 'a matter of weeks' due to its fractious political situation, and relative insignificance to Almach interests.\
	<br><br>\
	According to McMullen, the system's most populous habitat, the Carter Interstellar Spaceport is already under blockade and local resistance has thus far been minimal. The capture of Relan is expected to provide our forces with a major foothold in Almach territory and further advances are expected to be 'trivial', bypassing the Association's defensive positions in Angessa's Pearl.\
	<br><br>\
	The offensive comes weeks after sizable portions of the Fleet were publicly withdrawn from the frontline in order to reinforce the extended border with the Hegemony following their annexation of the Dark Triangle, and is a clear sign that - despite reduced numbers - Fleet command remains confident of Solar victory against the Mercurial rogue state."

/datum/lore/codex/page/article50
	name = "05/19/63 - 'Drone Operated' Shelfican Ships Storm Sol Siege"
	data = "Blockading Solar vessels in the Relan system came under fire today from automated craft originating from the Shelf fleet. The flotilla of drones, described by one survivor as a 'swarm', launched electromagnetic pulse and so-called 'hatch buster' precision missiles against three SCG Defense vessels, inflicting systems damage, and casualties 'in the hundreds' with at least eight service people already confirmed killed in action. The drones are reported to have withdrawn after 'only a few minutes of protracted fire from both sides.'\
	<br><br>\
	The Shelf telops fleet, which was spotted by Fleet forces but not identified as an immediate threat, entered the system early this morning and were understood to be acting as observers to the ongoing battle for the Relan system due to Shelf's official stance of non-aggression -- despite aligning itself with the Association. Shelf has reportedly been unable to be reached for comment on their actions, and their alleged neutrality in matters of war has been seriously called into question by many in the Colonial Assembly.\
	<br><br>\
	The SCG-D Krishna and SCG-D Mogwai of the SCG fleet, and the assisting Oasis logistical vessel, the OG-L Cloud Nine have been withdrawn to an unspecified location for immediate medical assistance and repairs."

/datum/lore/codex/page/article51
	name = "05/20/63 - Fleet Withdraws - Sol On The Back Foot?"
	data = "The Solar Colonial Assembly has confirmed that the Solar Fleet has withdrawn from the contested Relan system due to 'unexpected resistance' from Shelf tele-operated forces. This comes less than 24 hours after three Solar vessels were seriously damaged in an 'ambush' by a large number of Almach-aligned military drones. According to the Fleet, they were unprepared for any significant ship-to-ship combat in the system and will be consolidating their forces. 'This is not a defeat', according to Captain Silvain Astier of the SCG-R Hanoi, speaking unofficially to Occulum News sources 'This is merely a tactical withdrawal in order to reconvene and reassess our plans to restore order to the Almach Rim.'\
	<br><br>\
	A spokesperson for Shelf was quick to contact Fleet forces following the withdrawal with a formal apology for yesterday's incident, describing the previous day's attack as 'A terrible mistake.', blaming 'a miscommunication between our people in telops and the trigger-happy robots', though the veracity of their claims cannot be confirmed."

/datum/lore/codex/page/article52
	name = "05/21/63 - NanoTrasen Station to Host Major Election Debate"
	data = "As the Vir Gubernatorial elections approach, and with several high-profile debates lined up between the leading candidates in the polls, the NanoTrasen corporation is set to host its very own televised event live from one of its major logistical stations in Vir. The NLS Southern Cross, primarily a traffic control outpost managing shipping in Sif orbit, has been selected by the company to host the debate - funded in full by the corporation - due to a series of minor political scandals that have taken place on the platform, and the suitability of unused space onboard.\
	<br><br>\
	Early in the election cycle, NanoTrasen came under fire for its alleged 'manhandling' of Icarus Front candidate Vani Jee, and the confiscation of to-be-televised recordings taken by a party drone. While the company apologised for the incident shortly thereafter, the corporation hopes to mend ties with the potential future representatives by showing that they are capable of hosting civil discourse. More recently, the NLS Southern Cross played host to the 'breakdown' of disgraced former candidate Isak Spar - an episode which was not addressed in NanoTrasen's official statement on the planned debate event."

/datum/lore/codex/page/article53
	name = "05/26/63 - SEO Candidate Advocates Murder On Live TV!"
	data = "Sol Economic Organization candidate Freya Singh has been caught live on camera admitting that she would like to throw an innocent individual out of an airlock for a minor slight. During this afternoon's debate hosted aboard the NLS Southern Cross. Singh is quoted as having said that the event was 'the silliest concept for a debate I've encountered yet, and whoever came up with it should get a promotion, and then be fired out of an airlock.', a clear incitement of violence against Oculum Broadcast staff.\
	<br><br>\
	Magnus Dugal, 48 works for the Oculum Broadcast corporation and is credited with creating the concept for today's debate, the highest rated for this cycle so far. The father of three, who enjoys hoverboarding in his free time, says that he feels 'Threatened' by Singh's comments, and hopes that she will, 'at the bare minimum', issue an official apology to the company and himself.\
	<br><br>\
	Candidate Freya Singh, a career investment banker, spent much of today's debate advocating for reduced safety regulations and the apparent overturning of the Five Points, raising eyebrows across the system. Singh's office claims that her statements were 'a joke', but we do not feel that this is a laughing matter.\
	<br><br>\
	In related news, Shadow Coalition candidate Phaedrus remains under a profanity filter 'house arrest' for the remainder of the election."

/datum/lore/codex/page/article54
	name = "06/28/63 - Vir Finalizes Dates for Election Voting"
	data = "The Vir Governmental Authority has confirmed that voting for Vir's governorship and Colonial Assembly seats will take place on the 29th and 30th of June, with an additional voting period set for Wednesday the 3rd of July to allow for out-of-system and full-time weekend employees to cast their votes. No exit poll information will be released until the final votes have been cast, and final results are expected to be announced within another week.\
	<br><br>\
	According to a Oculum poll, Lusia Hainirsdottir is expected to comfortably take a seat, though the certainty of her governor position is not hard set. Candidates Sao, Singh and Jorg are trailing not far behind, but will all have to make good showings this weekend if they hope for electoral success. In an unexpected surge among minority species, the Shadow Coalition's Tajaran candidate Kurah Zarshir is leading the polls in certain outlying and orbital communities.\
	<br><br>\
	Not sure how to vote, if you can vote, or who to vote for? Check out the official election website at your-choice-vir.virgov.xo.vr"

/datum/lore/codex/page/article55
	name = "06/29/63 - Morpheus Cyberkinetics To Split Assets"
	data = "The Morpheus Cyberkenetics Corporation is to split into two distinct entities operating under a single board of trustees, in light of their Almach branch's apparent involvement in the ongoing war after last month's 'unintentional' corporate drone strikes. Citing 'Severe communications disruptions' between its operations and assets on either side of the cordon since it was put in place last year, the SolGov-side corporation is to become 'Morpheus Sol', retaining most assets and current corporate headquarters, and its Almach counterpart 'Morpheus Shelf', which is to be based out of the administration station MAS Sophia Jr., located in the El system.'\
	<br><br>\
	The principle victim of the Aetolian coup, Nanotrasen, has seen most of their considerable Almachi investment nationalized by the secessionist government, as has Xion and other major Almachi organizations. Most surviving corporate exclaves have been effectively written off by their parent company for the duration of the conflict, due to the severe difficulties effectively conducting trade across the militarized border. Before today, the sole exception was Morpheus, whose involvement in the secession prevented any seizing of their assets. It seems, however, that even the sardonic positronic corporation is not immune to the difficulties of doing business in the Almach Rim region.\
	<br><br>\
	Member of the Board Chock Full of Sardines introduced the proposal by saying, 'Our goal here is not being shot. Together with leading economic scientists, we've devised a scheme that will allow us to be shot for illegal smuggling almost ninety percent less often.' They defended the confusing and offensive choice of name in 'Sophia Jr.', seemingly intended as an insult to longstanding rival Sophia, by claiming, 'It's absolutely hilarious.'"

/datum/lore/codex/page/article56
	name = "06/30/63 - Almach Leak Confirms 'Super-weapon' in Whythe"
	data = "Solar Confederate Government Intelligence has this afternoon confirmed the presence of a so-called 'Super-weapon' in the distant Whythe system, after an apparent intelligence leak was posted to the exonet in the early hours of this morning. According to a spokesperson for the Solar Fleet, the public were not made aware of the super-weapon as the military 'have no reason to believe that the weapon poses any threat to civilian targets within SolGov space at this time, and there is no reason to cause panic with what amounts to the announcement of an Almachi propaganda tool intended to sow discord with bold threats of overwhelming power. This morning's leak achieves nothing but serving the Association's schemes. Keeping this so-called super-weapon - and I hesitate to use that term - a secret seems to have been last on their list of priorities.'\
	<br><br>\
	According to the intelligence documents released this morning and widely spread within minutes of upload, the 'super-weapon' is a colossal space-bound structure equipped with 'newly developed bluespace technology', though its exact purpose or capabilities have not been confirmed by either side.\
	<br><br>\
	Additionally, the Solar Fleet has announced that an unnamed individual within the intelligence service has been placed under arrest in connection with the leak."

/datum/lore/codex/page/article57
	name = "07/04/63 - Exit Polls Suggest Shadow Coalition Win in Vir"
	data = "According to the first exit poll data released after Vir Gubernatorial voting closed at midnight, local favourite the Shadow Coalition is expected to win at least two representative seats, with incumbent representative Lusia Hainirsdottir taking a comfortable lead.\
	<br><br>\
	Final results are not expected to be tallied until Saturday morning, but other frontrunners include the Icarus Front's Vani Jee and Mehmet Sao - running on drastically different platforms - alongside the Shadow Coalition's Selma Jorg. In an unexpected turn, sole Tajaran Candidate Kurah Zarshir of the Shadow Coalition has seen an immense surge in popularity among minority and more xenophilic voters. Could Vir be seeing its first Tajaran Representative? Experts say: 'Perhaps.'"

/datum/lore/codex/page/article58
	name = "07/07/63 - Vir Election Results"
	data = "The results of the 2563 Vir Gubernatorial Elections are as follows:\
	<br>\
    Governor of Vir: Lusia Hainirsdottir (Shadow Coalition)\
    <br>\
    Vir Colonial Assembly Representative: Vani Jee (Icarus Front)\
    <br>\
    Vir Colonial Assembly Representative: Selma Jorg (Shadow Coalition)\
    <br>\
	Other candidates ranked: Sao (4), Zarshir (5), Keldow (6), Singh (7), Moravec (8), Phaedrus (9), Lye (10), Savik (11), Square (12), Wekstrom (13)\
	<br><br>\
	Voter turnout: 30,928,287 (63%)\
	<br><br>\
	The greatest upset this election cycle has been the unexpected popularity of 'alien rights' candidate Kurah Zarshir, who was eliminated in favour of Mehmet Sao (Icarus Front) in the 8th round of vote transfers by a margin of just 30 votes, or 0.000096%, prompting a rigourous recount process to confirm the result. A difference at this stage could have resulted in a significantly different final line-up.\
	<br><br>\
	This year's winners showed clear advantages in the first-choice votes, each gaining at least 15% of the popular vote before any transfers were calculated, though Sao made significant gains in the final count, falling only a few percent short of the Jorg's 3rd place position. By far the least popular candidate this cycle was Hal Wekstrom of the Sol Economic Organization, who received just 0.8% of the first-choice vote and was immediately eliminated. Also of note were Phaedrus, Apogee Lye and Yole Savik voters, each of whom had high (30%+) voter exhaustion rates, opting not to provide alternative choices; sending the message 'My candidate or none at all.'\
	<br><br>\
	The elected are to be sworn in at a ceremony on Luna in two weeks time."

/datum/lore/codex/page/article59
	name = "07/30/63 - Solar Fleet Data Breach"
	data = "Last night, a number of files were spread on the Monsters From Beyond's exolife forums allegedly depicting the boarding and eventual scuttling of the SCG-TV Mariner's Cage during a voyage close to the Gavel system on the 12th of June, before the SCG had officially released any information regarding the event. The files contained undisclosed documents from the Solar Fleet investigation, some of which appear to contain audio and video recordings of the final moments of the crew before the vessel's bluespace drive was detonated. Due to the graphic violence depicted and their classified nature, we will not be sharing the files, however as a matter of public record we will explain the events recorded therein. The following description may be unsuitable for sensitive readers.\
	<br><br>\
	First, the navigation crew detects a drive signature on an apparent intercept course with their own, originating from across the SCG-Almachi border. It was not a large vessel, and is assumed to be some form of autonomous drone. The crew disregards it as a low level threat, instead continuing on their trajectory, leaving only the standard point defense armament locked on. This proved to be a lethal mistake, as the vessel appeared and near-instantly began accelerating toward the Mariner's Cage, before impacting the fore weapons array. The recording is cut, due to what was likely a power surge, however upon reconnection, reports indicate no damage related to any known warhead was apparent, aside from the initial impactor. The crew mistakenly assumes it to be a failed suicide drone strike, and dispatches minimal security personnel, and a large complement of response engineers.\
	<br><br>\
	Approximately thirty minutes after the response teams are dispatched to the impact zone, the teams begin losing contact, with those first arriving being the first to disappear. When the security responders intercept the path of communications blackouts, they are met with the blades of multiple Aetolian shock troopers. Two appear to be made from a 'living steel', with each limb taking the form of 'jagged cleavers' as one radio recording states, and three more of 'indeterminable classification'. The ship entered a red alert state, and moments later, the small contingent of marines aboard the supply vessel were dispatched to deal with the threat. All five members of the enemy boarding party were able to be rendered inert through sustained fire, though not without Sol casualties.\
	<br><br>\
	According to the next recordings, approximately three hours after the incident, the vessel received orders to interrogate the boarding 'Aetotheans'. The two noted to appear as the officers of the squad were rejuvenated within sealed interrogation chambers reinforced with supplies on hand, apparently capable of stopping sustained fire from multiple energy weapons. The first individual was a 'sapphire' according to information from NanoTrasen correspondants. It refused to speak in Galactic Common, and instead utilized an unknown frequency of biological transmission, and internal charge shifts. The individual was moved to a more permanent cell within the vessel's brig for transport, and the second was rejuvenated. Only the first half of the interrogation, which lasted approximately two and a half minutes, compared to four hours for the first, was recovered. The individual is rejuvenated, and is engaged in discussion with the interrogating officer when it suddenly stands, emits what is described as a 'wail', and detonates, destroying the transmitting camera, and presumably killing the officers involved in direct interrogation.\
	<br><br>\
	Final recordings originate from the ship's onboard A.I. housing, which was involved in continual discussions with presumably the 'sapphire', as it enacted the vessel's scuttling. It is unknown whether or not the individual was somehow capable of restoring the other individuals that fell in combat in order to free itself, or if it was able to incapacitate the transporting officers, and command crew of the vessel alone.\
	<br><br>\
	The Solar Fleet has expressed 'regret' that the files were leaked in their complete form, and have assured the public that an official report was due for release in the coming weeks. Concerns of 'Aetothean' attacks on civilian targets have been dismissed as 'improbable', but have affirmed that 'the threat is being taken very seriously'."

/datum/lore/codex/page/article60
	name = "08/03/63 - Hainirsdottir Sworn In As Governor of Vir"
	data = "Following a short transitionary period for the previous administration, this year's election victors have been sworn in at an official ceremony at the Colonial Assembly Hall on Luna. During her welcoming address, Governor Hainirsdottir reaffirmed her plans for the future of the system, promising a 'Bright future for Vir as a hub for medical science.', and plans for an incentivisation program for the removal of invasive extra-terrestrial species that have long plagued the region - in particular the aggressive spiders that have become synonymous with certain regions of the Sivian wilderness.\
	<br><br>\
	Additionally, the newly elected representatives announced expected, but none-the-less significant changes to the administrative staff of the system. Notable figures include two defeated election hopefuls: Kurah Zarshir has been selected as the Shadow Coalition's Culture Secretary for the system, while Mehmet Sao has been brought aboard by the Representative Vani Jee as the Vir Icarus Front's Internal Security Advisor. It is expected that the former candidates may use their positions to further certain goals from their own campaigns, but under the watchful eyes of their perhaps more moderate superiors."

/datum/lore/codex/page/article61
	name = "08/04/63 - Former Independence Candidate Found Dead"
	data = "It has been confirmed by a spokesperson for the Sivian Independence Front that a body found by hikers last week in the Ingolfskynn Mountains, approximately 200 miles northeast of New Reykjavik, belonged to party chair Yole Savik.\
	<br><br>\
	Savik, 68 - who had run for Vir Representative in the recent election - had not been seen since the 14th of July, shortly after the results were announced. Party officials claim that Mr. Savik frequently made 'off the grid' trips into the Sivian wilderness and his absence had not been treated as suspicious until investigators approached them to confirm the identity of the body. According to police, though Yole was publicly known as a 'seasoned frontiersman', Savik had succumbed to exposure at least two weeks prior to the grisly discovery. His death is not being treated as suspicious."

/datum/lore/codex/page/article62
	name = "08/07/63 - Almach Pirate Threat Vanishes - Analysts Baffled"
	data = "Skrellian Xe'qua pirates operating in the far reaches of the Almach Association since the onset of hostilities last year, have inexplicably gone dark. The pirates, who were under close SolGov surveillance to monitor their impact on Almachi shipping, have drastically dropped in activity and numbers over the last month according to an official report released by the Solar Fleet today. The Fleet is unable to account for the cease in activity, which has now reached levels even lower than their pre-war baseline, as there have been no reports of Almach military operations in the area, nor any signs of decisive battle on the Almach border with pirate space.\
	<br><br>\
	The drop in activity roughly coincides with the leaked information on an Almach 'Super-weapon' in Whythe, though military sources do not believe that the weapon has been deployed in any capacity at this time. According to Hasan Drust, an expert on Skrellian foreign policy, the 'only feasible explanation (is) major anti-piracy action undertaken by the Skrellian Far Kingdoms', who occupy the space beyond the Xe'qua pirates' known range. The reasoning behind this action now, against pirates who have historically only targeted human space is not entirely clear, though Drust suggests that it may simply be a coincidence as pirates would be a 'trivial issue' for Far Kingdom military might."

/datum/lore/codex/page/article63
	name = "09/02/63 - Shock Almach Attack Routs Relan Front!"
	data = "Following close to a month of reduced Almach activity, enemy Militia forces have today launched a staggering attack on Sol frontline forces in the region of the Relan system, disabling several SCG warships and forcing a major tactical retreat to Saint Columbia. The scale of this attack by Almach forces is unprecedented, but seems to be the result of the Association consolidating manpower previously dedicated to anti-piracy patrols on the far side of their territory. It is believed these vessels have become freed up due to the apparent but as of yet unconfirmed annihilation of Xe'qua criminal flotillas by Skrellian Far Kingdom police action.\
	<br><br>\
	The Solar fleet had been in position to blockade the Relan system in the hopes of forcing the Free Relan Federation to surrender and withdraw from the Association, but was unprepared for what has been described as an 'all-out attack' on their positions, which left the vessels SCG-D Liu Bei, SCG-D Wodehouse, SCG-TV Ceylon Hartal and SCG-TV Apoxpalon disabled and unable to retreat with the bulk of our forces, as well as inflicting severe damage to several other craft. According to initial reports, the strikes on many of the afflicted ships closely resembled scenes from the controversial 'Aetothean shock attacks' on the SCG-TV Mariner's Cage this June, which saw the ruthless deployment of gene-altered Promethean 'super-soldiers' by the Almach Association.\
	<br><br>\
	Fleet Admiral Ripon Latt, commanding officer of the assailed fleet, has confirmed that reinforcements are underway and the retreat 'shall not be a significant setback in the war effort', especially assuring citizens of the embattled Saint Columbia system and its neighbours that there is no cause for alarm and civilians have yet to be targeted.\
	<br><br>\
	The fates of the four missing ships have not been confirmed, and though the Fleet has not yet made an official statement, Sol casualties are cautiously estimated to be in the hundreds."

/datum/lore/codex/page/article64
	name = "09/23/63 - Fleet Refuses Inquiry Into Relan Losses"
	data = "The SCG Fleet has refused to heed widespread calls from critics to launch an investigation into the heavy losses sustained by our forces in a major Almach attack early this month, citing that an investigation at this time would 'undermine the ongoing efforts of our troops in battles to come'.\
	<br><br>\
	The attack, which took place on the 2nd of September and at current count resulted in the loss of a staggering 1281 Sol lives, quickly drew criticism from experts for 'the total unpreparedness' of the fleet despite their public claims that all vessels were 'battle ready and prepared for a coming offensive.'. The specifics of the fleets apparent failings have been the focus of much speculation in the intervening weeks, with the blame placed on everything from a critically inexperienced officer core, to ongoing redeployments to and from the recently expanded Hegemony border.\
	<br><br>\
	Admiral Latt has condemned critics, stating that 'the last thing our brave troops need right now is murmuring from people who don't know the first thing what they're talking about. Their actions in following orders to fall back to the border have been nothing but commendable, and all effort was made to minimise loss of life. The fleet is undergoing reorganization at this time, and is in a better position than ever.'"

/datum/lore/codex/page/article65
	name = "09/27/63 - Almach Bypass Saint Columbia In Brazen Gavel Attack!"
	data = "Almach Association fleet forces entered the Gavel system this afternoon, reportedly having evaded interdicting Sol forces from Saint Columbia in an apparent effort to skirt the range of the MJOLNIR weapon system in Saint Columbia and cut off that system from major shipping routes. Current reports from the system capital in New Xanadu are that the majority of outlying civilian stations have surrendered to invading forces with only minor incident, but that skirmishes with local defence forces - including Sol Fleet detachments - are ongoing, and it is too early to remark on the outcome of the battle. Official military reports are scarce at this time, but the Fleet in Saint Columbia is 'on the move and ready to repel the invaders'.\
	<br><br>\
	Accounts from the system's edge describe Almach forces 'firing indiscriminately' on anti-piracy emplacements including those mounted to the ILS Thurston, a Greyson Manufactories collection station with eight crew, killing all hands.\
	<br><br>\
	Open fighting in the Gavel system marks the furthest Almach encroachment on Sol territory to date. The system, which is a stone's throw from the Oasis and Vir systems is best known for the destruction of the moonlet 'Requiem' by a rogue nanoswarm in 2289, which was successfully  neutralized by government forces, and boasts only a small population relative to its neighbors."

/datum/lore/codex/page/article66
	name = "10/01/63 - 'Judgement Day' As Gavel Falls!"
	data = "The government of New Xanadu has surrendered to Association invaders following a disastrous relief effort by the Solar Fleet, whose interdiction vessels are believed to have been captured by the invading force. The manoeuvre leaves the bulk of the Sol fleet isolated in the Saint Columbia system - though a breakout is expected - and has led to widespread outrage in the Colonial Assembly. Critics of the war have damned the Fleet for their 'inability to fight a civilian rabble, gene-modded or otherwise' and renewed calls for a peaceful arrangement between the Solar Confederate Government and Association.\
	<br><br>\
	ISA-5, current spokesperson for the Shadow Coalition has forwarded a motion today to resume discussions with Almachi heads of state, just hours after news of Gavel's surrender broke. The proposal which has yet to gain widespread traction, would call for a new ceasefire, and ISA-5 has stated they 'hope that a new agreement can be made to end the senseless loss of life over the particulars of a foreign government's right to autonomy.'.\
	<br><br>\
	Executive Sifat Unar of the Emergent Intelligence Oversight has voiced immediate concern over the motion, criticising the use of 'foreign government' in reference to Almach; 'Our Fleet has suffered a few defeats, but this conflict goes deeper than mere lasers and shells and to surrender to torturers, mind-hackers, and Machiavellian machines at this stage would be insanity. To allow a seccessionist state, particularly one so unabashedly guilty of crimes against humanity that go far beyond even our modern definitions of 'Human Sanctity', to exist unquestioned a stone's throw from some of our most precious member states, would be a failing not only of this government, but of humanity that would echo through history like a great shameful dirge for all to hear.'\
	<br><br>\
	A communications blackout has been instated on the Gavel system by the Almach Militia, though earlier reports indicate continued strikes on numerous civilian colonies who were unwilling, or unable to deactivate their automated defence systems prior to the invaders arrival."

/datum/lore/codex/page/article67
	name = "10/08/63 - 'Magnetic Weapon' Designs Released Following Gavel Threat"
	data = "Private security and ExoMartian law enforcement agencies are now receiving modernized man-portable magnetic weapon designs produced by Mars Military Industries thanks to increased budget from the S.C.G. The 'hallmarks' of these weapons, as one M.M. Industries spokesperson says, are their incredible ability to launch physical projectiles at velocities rivalling present portable laser technology in practical utility. Many of the designs utilize generalized, easy-to-manufacture compressed matter cartridges as their primary ammunition, meaning no specialized production facilities are required outside of standard shipyard or planetary lathe systems, 'to ensure a cutting edge in the battlefield, down to the last man'.\
	<br><br>\
	Some corporations, such as Hephaestus, NanoTrasen, and the PCRC, are already preparing to utilize these released designs in their own laboratories and stations, undoubtedly providing yet more materiel backing to the Almach front."

/datum/lore/codex/page/article68
	name = "10/10/63 - Gavel Encircled - Liberation In Sight"
	data = "Significant Fleet reinforcements from the Unathi border have 'trapped' the Almach fleet in the Gavel system and are poised for a decisive victory, according to latest reports from the front. Solar vessels from all sides of the war-torn system have closed in to ensure the invading force have no means of retreat. The relief force includes elements of the Hegemony-border fleets and the previously deployed flotilla stationed in Saint Columbia. Speaking at the Colonial Assembly this morning, Rewi Kerehoma of the Sol Economic Organization has stated that the reinforcements will 'beyond a doubt' prevent a repeat of 'embarrassing' errors made in the past month.\
	<br><br>\
	Efforts have been made to re-establish contact with the occupied system, which has been blocked from communication with the rest of the galaxy since the occupation began last week. According to scattered civilian signals from the system, the Association has adopted a 'salted earth' policy to the system following Solar military response, openly demolishing system infrastructure with little regard for its residents. A spokesperson for Grayson Manufactories, who maintain a significant presence in the Gavel system , has proposed that 'The Almachi had no intention of holding this system, this may have been nothing more than a show of force against corporate assets supporting the war effort.'\
	<br><br>\
	In related news, Admiral Ripon Latt has officially retired from his post following immense political pressure from the Assembly. Latt was until this week, commander of the Rim Expeditionary Force - currently in the Saint Columbia system - and has been the primary target for blame in the SCG's defeat in Relan, and failure to prevent the invasion of Gavel. The disgraced admiral will receive a full officer's pension, but no official honours befitting of his previous rank. Latt is to be replaced immediately by Admiral Silvain Barka, an experienced veteran of anti-piracy action in the Rarkajar Rift."

/datum/lore/codex/page/article69
	name = "10/26/63 - 'Largest Engagement Since The Hegemony War' As Gavel Freed"
	data = "The Almach Association invasion force in the Gavel system has been all but annihilated by a successful Solar counter-encirclement, at great cost to both sides. The combined Rim Expeditionary Force in Saint Columbia, along with the newly formed Gavel Relief Fleet - which had been massing in the Vir system over the past week - launched the successful attack this Tuesday evening, leaving no route of escape for Almachi invaders and resulting in 'pitched fighting' between the fleets that lasted several days. Solar forces are currently in the process of performing security sweeps of the system and its scattered habitats and it is expected to be several weeks before the system is declared safe to civilian traffic and for refugees to return home.\
	<br><br>\
	Even as exact causalities remain unconfirmed, the battle has made history as the single largest ship-to-ship engagement by tonnage involving the Sol military since the cessation of hostilities with the Unathi in 2520, involving over one hundred vessels of all sizes across both sides, as well as countless unmanned drones and light craft. Almachi forces, in numbers described as 'far from an insignificant portion of the total fleet' fought fiercely, and 'in manners more reminiscent of mercenary gangs than a single organized force, and with tactics varying from the conventional to the outright mystifying'. Admiral Silvain Barka has commended his own crew for applying lessons learnt from prior 'Aetothean' commando strikes in preventing similar incidents from occurring in the confusion of battle; in a candid interview this morning he stated  'Like any Promethean, (Aetotheans) hate the cold, and my crew are the coldest (expletive) around.' \
	<br><br>\
	The designations of twenty-four Sol Defense Vessels declared 'lost in action' have not yet been released, though next of kin of missing or deceased servicepeople have reportedly been notified."

/datum/lore/codex/page/article70
	name = "11/11/63 - Gavel Salvation Reveals True Cost of War"
	data = "Reports from liberating forces in the Gavel system have confirmed early accounts of 'inhuman' tactics employed by the Almachi invaders during their short occupation and defense of the region. Besides an apparent disregard for sapient life, especially any that gave an outward appearance of defending themselves, the Militia is believed to have employed troops and tactics 'the likes of which had only been imagined', in 'a manner that can only be described as experimental'.\
	<br><br>\
	Most harrowing of the accounts are those of alleged 'kill-switch clone armies' consisting of near-identical vatborn troops deployed to some of New Xanadu's largest surface colonies. According to local residents, the 'uncanny' troops arrived en-masse 'from the depths of the wastes' at the beginning of the invasion, despite wearing no obvious gear that would protect them from the extreme, unbreathable environment beyond the confines of controlled habitats. The clones are said to have targetted infrastructure including life support, with little regard for those who stood in their way. However, what has baffled Fleet analysts is the reaction upon the arrival of Sol surface troops; the clones did not fight back, but rather dropped dead 'all at once, as if a switch had been flipped'.\
	<br><br>\
	Teams from the SCG's top analytical and regulatory bodies including the EIO have been hard at work collecting examples of the unusual Almachi technology from throughout Gavel. Executive Sifat Unar has stated that 'It is vital that we ensure this transgressive technology no longer poses a threat to sapient life, either now or to future generations. A full cleanup operation is underway, and we are working to analyse what we have found and better understand the enemy's limits and the extent of their biological and technological... Practices.'\
	<br><br>\
	The current confirmed death toll, including civilian losses in Gavel has now reached 11,520 and is expected to rise. Debate continues whether to add the so-called 'Kill-switchers' to the tally."

/datum/lore/codex/page/article71
	name = "11/21/63 - Tajaran Pearlshield Draws Line In The Sand"
	data = "Khama Suketa enai-Lutiir, representative of the Tajaran Pearlshield Coalition, has just issued a formal statement:\
	<br><br>\
	'It's no secret that we members of the Pearlshield Coalition have our differences and conflicts, both within and without. Much as some might call it the spice of life, it's with shame that I admit it has left us somewhat paralyzed over the last few months, even as a war has raged on a mere few jumps away from our borders. But in acknowledgment of our differences, something we have been able to unanimously agree upon is the sanctity of life and common decency, sanctity that Almach has continued to violate in the name of political conquest. Our relationship with SolGov - and indeed, any who would call us 'friend' - should be one of mutual cooperation and benefit, not of hard boundaries delineating 'us' and 'them'. There is only 'we', and we cannot stand idly by.\
	<br><br>\
	'To this end, the Pearlshield has negotiated with local forces in the Silk system, and are taking over interim protection of the system, to free up Solar military forces so they can assist in the war effort. We have also begun construction of a large residential station to supplement the Silk station itself, alleviating its acknowledged overpopulation issues and providing additional logistical support for our defensive fleet. Finally, our cousins in Mesomori have generously loaned their new flagship, the PCMV Raniira's Grace, with all hands on deck for temporary joint assignment with Solar military forces. They are quite eager to provide a taste of Tajaran firepower and ingenuity.\
	<br><br>\
	'We wish we could spare more at this time, but alas, we're still finding our feet among the stars, stepping carefully among the proverbial minefield that is our own share of cosmic threats. Know that these contributions represent a grand investment in their own right, and they are only the beginning should this war carry on.\
	<br><br>\
	'We will have more to say as it comes up. May all our stars shine upon us.'"

/datum/lore/codex/page/article72
	name = "11/23/63 - Surviving 'Kill-switcher' Assassinated During Vir Interview"
	data = "An Almachi 'kill-switcher' clone soldier capturing during the liberation of the Gavel system was yesterday 'forced' to explosively self-terminate during a live TV broadcast with Virite news anchor David Huexqole aboard a SCG prisoner transport craft, allegedly by the statement of a code phrase, clearly audible on the recording. Following the attack, the apparent 'activator' is reported to have escaped to nearby NanoTrasen logistical station, the Southern Cross amidst the chaos where a minor altercation took place, resulting in the injury of one Positronic crew member and death of one Almachi accomplice, which initial reports suggest to have been a 'Vox mercenary'. The search continues for the Almachi agent, and local authorities remain confident that they will be apprehended.\
	<br><br>\
	David Huexqole, a popular local media personality, was the only other immediate victim of the attack, suffering moderate injuries and was rushed to the Southern Cross for emergency surgery where he is reported to have made a full recovery. Huexqole has expressed his gratitude to the 'skilled and charming staff, clearly shaken by the war but nonetheless capable for it.' but has expressed concerns regarding so-called sleeper agents within Sol space, 'Isa (341, the interviewed clone), seemed genuinely reformed. She spoke openly of regret, and struggling with what it meant to be created only to die. Before she blew herself up, I never would have thought her capable - it was like she changed in an instant.'\
	<br><br>\
	Initial blast investigation suggests the presence of a previously unidentified compound in the clone's bloodstream, which was detonated following 'activation' by the as of yet unidentified Association agent, believed to have been present in the room during the recording. Moments prior to termination, the clone's demeanour is visibly altered and the phrase 'Those of Sol must look to the eastern star, Phorcys.' was clearly stated. A spokesperson for the Saint Columbia Telemetry Station has stated that observation of Phorcys, an uninhabited star system located approximately between the Almach Association state of Vounna and Skrellian Far Kingdom space, has revealed 'no immediate anomalous behaviour or presence' but that analysis will continue in the coming weeks 'in order to verify the potential meaning of this statement.'"

/datum/lore/codex/page/article73
	name = "11/25/63 - Phorcys Star Ignites!"
	data = "The Phorcys star system, mentioned cryptically during Friday's dramatic televised Almachi assassination, has 'gone supernova' several thousand millennia ahead of schedule, sparking concerns of 'Almach Superweapon' involvement. The process, which ordinarily takes place over many months and is preceded by millions of years of obvious stellar evolution, began rapidly in the early hours of this morning and has already begun to consume the entire system at a rapid rate - mercifully consisting of only two uninhabitable dwarf planets.\
	<br><br>\
	According to government telemetric sources, who have been observing the system since Friday's message, the 'ignition' was preceded by 'abnormal bluespace readings', but it is impossible at this time to confirm whether the phenomena was a natural anomaly that Almachi sources were able to identify ahead of time, or if the long-rumoured 'Whythe Superweapon' was in fact involved. If direct Almach involvement were the case, the range of such an 'attack' would be unprecedented, with the afflicted star far from any populated area or territorial claims and 'no evidence of sapient passage to the system in several decades.'\
	<br><br>\
	General Secretary Mackenzie West, speaking on behalf of the Colonial Assembly has stated that 'The Solar Confederate Government is taking this matter very seriously. The mere prospect of a weapon of this calibre would indeed pose an existential threat to our society, and perhaps mankind. However, at this time we cannot jump to conclusions, this may in fact be a game of smoke and mirrors; an effort to use a previously unobserved phenomena as a weapon of propaganda, and we cannot allow this to cloud our judgement. We are in close contact with the Skrell in order to determine the nature of this sudden ignition. Know that the Fleet is on high alert, and fighting forth from the Saint Columbia system will continue unaffected.'"

/datum/lore/codex/page/article74
	name = "11/27/63 - Whythe Superweapon Confirmed In Phorcys Blast"
	data = "New government footage from the moment of ignition in the Phorcys system has confirmed the 'brief' presence of an artificial 'bluespace gate' within the star just prior to its rapid expansion and structural collapse. This verifies claims of responsibility made by the Almach Association late yesterday, and casts no doubt on the threat posed by the so-called Whythe Superweapon. The Colonial Assembly has been in continuous session since the initial incident, and one staffer has described the atmosphere as one of 'unhinged panic'.\
	<br><br>\
	The prevailing fear amongst the government, with the assent of top physicists in the private sector is that such a weapon could be used against Solar targets, and that it is no longer a question of 'how', but 'when', and indeed 'where'. The only unknown factor is the superweapon's capability for repeat use, and 'rate of fire' which is yet to be demonstrated but widely considered to be 'not a risk worth taking under any circumstances'.\
	<br><br>\
	Latest reports from the Assembly have are that a 'scramble' is taking place to resolve the 'Almach Situation', and that the ongoing offensive out of Saint Columbia has been redirected towards Relan and Whythe. According to Skrellian correspondent Hasan Drust, official aid has been requested as of this afternoon."

/datum/lore/codex/page/article75
	name = "12/01/63 - Skrell Defer Aid Citing 'Deliberations'"
	data = "Official Solar contacts within the Skrellian government have reportedly delayed tangible aid in the rapidly escalating Almach Crisis, citing 'Internal Deliberations', agreeing only to continue to share telemetric data on the movement of Association forces. The Skrell, who were instrumental in the Solar victory against the Unathi 40 years ago have long been considered taciturn in their internal affairs, but have previously been open in their support of Sol action when it comes to national defence, making their indecisive response greatly unexpected to some.\
	<br><br>\
	Speaker ISA-5, who has been increasingly critical of the war in the past several days, has dismissed concerns that the Skrell are 'siding with the Association', citing the long term close relationship between their governments, 'The Skrell are not war hawks, and they've never shown outward ill-will against other sapients. We can't let a bureaucratic delay allow public opinion to turn against an entire species of people who have always had our backs. If our allies need time for deliberations, we should allow them and not expect mere muscle and military aid when words could have been our solution from the beginning. I've no doubt that they will not allow the situation to become so dire that the Association are able to cause us any serious harm as they have threatened. I'm convinced that diplomacy will prevail, and that if the Skrell are in fact negotiating with the Association, then it is with all of our best interests in mind.'"

/datum/lore/codex/page/article76
	name = "12/20/63 - Jee Relaunches Libraries Across Vir"
	data = "Vir's Colonial Assembly representative and long time education reformist Vani Jee has launched her long planned 'modernization' of exonet-linked library system throughout the Vir system. During her campaign early this year she brought to light the 'staggering unsuitability' of library networks in Vir, particularly those being provided for corporate employees and residents, with particular pressure placed on the NanoTrasen Corporation whose literary collection was described as 'basically smut and whatever an old drone had scraped from the bottom of the exonet barrel.' Following her subsequent election, she reaffirmed her desire for education reform, making 'post-education' providers her first target.\
	<br><br>\
	The new system, which she successfully acquired government funding for this October, is due to be launched this week and includes a 'personally curated' collection in addition to titles recommended by affected institutions, and a particular focus on local authors."

/datum/lore/codex/page/article77
	name = "01/23/63 - 'Extreme' Environmental Alert Following Ullran Expanse Chemical Leak"
	data = "Residents and visitors to Sif's remote Ullran Expanse have been advised to exercise extreme caution when travelling and to avoid consuming local water sources following a 'catastrophic' chemical spill in the mountains. The exact cause and origin of the spill has yet to be confirmed, though it is currently believed to have originated from an improperly disposed of chemical tank. Local rivers and their outflow have been tested with 'extremely lethal' levels of acutely corrosive material.\
	<br><br>\
	Governor Hainirsdottir has issued a statement assuring Sif residents that the cleanup process is already underway, and the contamination which return to safe exposure levels for most sapients within 'Just a few days', but that the risk to local ecosystems in much higher and 'may take decades to recover.' and locals are advised to use only pre-packaged or thoroughly filtered water for the next 'six months, at least.'\
	<br><br>\
	A spokesperson for the Sif Environmental Agency has described this leak as 'At least regionally, perhaps the worst environmental disaster since the introduction of the invasive spider species.' and has expressed concern about similar accidents occurring in more populated areas if stricter regulations are not put in place.\
	<br><br>\
	The Ullran Expanse Chemical Relief Fund has been set up and is collection donations at save-ullran.xo.vr/donate"

/datum/lore/codex/page/article78
	name = "01/27/64 - NanoTrasen Implicated In Devastating Ullran Chemical Spill"
	data = "Files recovered from the contamination site by clean-up crews and submitted to the Sif Environmental Agency suggest that the hazardous materials were discarded in the region by the NanoTrasen Corporation. Though the company is not currently accused of malicious intent, ownership has been proven of several cargo containers filled with Growth Inhibitor 78-1, a compound used in the manufacture of Vatborn humans which is known to severely inhibit cell regeneration in living creatures.\
	<br><br>\
	The documents, which have not been released in full by the SEA, were also leaked onto the exonet from several sources which NanoTrasen initially dismissed as fraudulent but have since admitted to their authenticity. Investigations are currently underway to determine those at fault within the company so that prosecution may begin. Third-party commentators have alleged that, 'The debris field and damaged containers suggests cargo jettisoned from a craft within the Sif atmosphere', though the circumstances are yet to be thoroughly examined.\
	<br><br>\
	Certain members of the civilian clean-up crews responsible for waste disposal have also accused NanoTrasen of failing to provide their employees with sufficient safety information and protective equipment, which led to several minor injuries and one volunteer was reportedly admitted to hospital for 'severe side-effects of exposure' but has since been discharged."

/datum/lore/codex/page/article79
	name = "02/10/64 - Shelf Fleet Vanishes Without A Trace!"
	data = "Government agencies are scrambling to explain the apparent 'total disappearance' of the Almach-aligned Shelf fleet. Initial reports from the fleet's last known location describe a phenomenon not dissimilar to that observed just prior to the ignition of the Phorcys star in November, but the SCG has assured the media that 'No activity has been detected from the Whythe superweapon that would indicate any relation to the ongoing Shelf situation.'\
	<br><br>\
	Independent telemetric data from several sources has confirmed the presence of a 'bluespace anomaly' in the moments preceding the fleet. Currently efforts are focused on determining whether the fleet has been lost with all hands or if survivors may yet be found, but no trace of the fleet or of telltale signs of large fleet movements anywhere within or beyond Almachi space have yet been detected.\
	<br><br>\
	This afternoon, Speaker Mackenzie West of the Icarus Front addressed Sol, and indicated that communication was underway 'across faction lines' with the Association to determine the cause and implications of Shelf's apparent loss. The Almach Assocation has claimed not to be responsible for the 'possible attack' and both sides has expressed concern for the 'astronomical loss of life this may represent.'\
	<br><br>\
	Shelf, a largely Positronic colony fleet, consists of over 1700 vessels including the 'One Leaky Bitch', current headquarters of Morpheus Shelf, Morpheus' non-Solar 'spin-out' corporation established last June. The fleet has continuously denied direct affiliation with the Almach Assocation, but was involved in a major drone attack on Solar vessels just nine months ago, which was claimed to be 'in error'."

/datum/lore/codex/page/article80
	name = "02/12/64 - Spectralist Wardens to hold Vigils for Lost Fleet"
	data = "In the wake of Shelf's sudden disappearence, Wardens across SolGov space have collectively agreed to hold services and vigils throughout dozens of systems for those who are doubtless worried for their loved ones aboard the missing ships. Spectralism, a synthetic-centric religion, finds it's roots within 'Haven', a small vessel and community that travels alongside the wider Shelf fleet, though considers itself a distinct entity. Its ministers, known as Wardens, tend to its adherants wherever they may be found.\
	<br><br>\
	Despite Haven's well-known and somewhat-controversial independence of identity from Shelf, all indications point to the Fleet's disappearance having taken the attached ship with it. All twelve Spectralist Elders are known to have been onboard Haven at the time of its disappearance, as well as numerous other significant Spectralists and other spiritual leaders thought to have been on Shelf. The potential loss of the entire upper organizational body could be devastating to the religion, who have long been instrumental in the synthetic rights movement.\
	<br><br>\
	Ceramica, a Warden operating out of Nyx, reached out for comment with the following: 'We are as worried as everyone else who calls Shelf their home, or who has lost contact with friends or family. You need not believe in the First Spark to have a place at your local vigil; We welcome everyone who may be hurting. This is our way, this has always been our way. We remind everyone to stay mindful, and to reach out to those you see struggling. In times like this, we cannot leave each other behind.'"

/datum/lore/codex/page/article81
	name = "02/14/64 - Shelf Safe After 'Impossible' Jump!"
	data = "The missing Shelf fleet has reappeared hundreds of light years beyond the Eutopia system just days after its sudden disappearance on Monday. Unencrypted bluespace transmissions from the fleet's new location - several months travel from its last known position in Almachi space - assured all who would listen that 'The fleet (had) arrived safe and sound.' and apologized for 'Any alarm (the fleet) may have caused'. Though no official report has been released nor information from Shelf itself, initial counts indicate that a number of Shelfican vessels may not have survived the 'impossible journey' intact.\
	<br><br>\
	Current analysis of the bluespace anomaly detected prior to Shelf's unexpected departure indicate that the same technology as employed by the Whythe Superweapon may have been used by Shelf to create 'a bluespace portal thus far inconceivable by modern science'. The revelation has sparked concerns that 'extreme mercurial elements' within Shelf may have been responsible for the hardware behind the Assocation's 'system eating' weapon.\
	<br><br>\
	Sifat Unar of the EIO has expressed particular concern that 'Such improbable technology relying on concepts deemed so staggeringly arcane that our very understanding of the laws of the universe had written them off as impossible - and to be applied in such callous ways without regard for life or perhaps even the fabric of reality, could only have been developed by machine minds that could threaten our very being.' Shelf has dismissed these claims as 'Scaremongering' and 'Just jealous that somebody else thought of it first', though they would not confirm nor deny their involvement in the development of the new bluespace portals."

/datum/lore/codex/page/article82
	name = "04/11/64 - Whythe Breached - An End In Sight?"
	data = "According to latest reports from the Almach front, Sol vessels have established a foothold in the debris fields of the desolate Whythe system, home to the enemy's controversial 'Superweapon'. Admiral Barka has confirmed that bombardment of the weapon has begun, but that 'shields are holding at present', owing to the vast construction's immense power generation capabilities, but remains confident that the 'siege' will come to an end within a few months, and that the Almachi now hold only 'minimal retaliatory capacity'.\
	<br><br>\
	Fleet sources have been quick to address a flurry of activity on the exonet which proposed that the superweapon might be deployed against Sol's core systems in a last-ditch effort to inflict damage on their former government. According to a statement posted just hours after the initial invasion press release, 'the Fleet is aware of all risk factors regarding the Whythe Superweapon, and following two long months of analysis are certain that constant, substantial pressure placed on the weapon's shield systems will render the offensive component of the weapon dormant until the hull can be breached.'\
	<br><br>\
	The general mood in the Colonial Assembly today is one of relief, as all signs point to a total collapse or surrender of Association forces in their home systems once their trump card has been captured or destroyed by SCG forces. Secretary West has already expressed congratulations to the troops, 'despite the lack of assistance from our allies, as the Shadow Coalition would have had us believe was necessary.'"

/datum/lore/codex/page/article83
	name = "04/13/64 - Skrell Ultimatum Shocks Sol!"
	data = "After three months of diplomatic iciness, the Skrellian Far Kingdoms have contacted both the SCG and Almach Association with one demand: Sign an armistice or prepare for war. Supported by an immense fleet movement through the recently quashed Xe'qua region, the Far Kingdoms have demanded an immediate end to hostilities, and 'incorporation of Almachi holdings as a Skrellian protectorate, under strict oversight and regulation of their research and activities.' By Skrell demands, the Fleet has two weeks to fully withdraw from the Almach region and any vessels on either side continuing to engage will be 'disabled, boarded, and have its crew arrested pending a formal peace agreement.'\
	<br><br>\
	A wave of outrage has swept the Colonial Assembly, with heated debate as to Sol's response defying all party lines. While Speaker ISA-5 has been widely criticized by political opponents for their 'overzealous trust in the Skrell', they have remained acquiescent to the Skrell's demands, stating that it may be the best way to avoid any further bloodshed and maintain good relationships with the Skrell. Conversely, a small group of hardliners from across the major parties headed by SEO Representative Colin Zula of Alpha Centauri, have formed a political coalition opposing any form of 'Surrender or appeasement in the face of foreign aggression', demanding Sol keep its forces in place and 'Finish off the Association before they can be allowed to wreak havoc unsupervised and uncontrolled.'\
	<br><br>\
	Surprising some, long-time supporter of the Almach War, MacKenzie West has established themselves as a figure of moderation in the Assembly, promising that the Icarus Front would pursue 'aggressive negotiations' with the Far Kingdoms in order to better understand their motivations and, if territory is to be ceded,  'ensure the Almachi are placed under a firm hand'. He notes that the Skrell have never adhered to Five Points policy, but that careful diplomacy has always ensured their 'less savoury tendencies' have never spilled over to Sol space."

/datum/lore/codex/page/article84
	name = "04/16/64 - Assembly Shaken By Reshuffle"
	data = "Following the shock announcement of the Skrellian demands on Monday, sixteen planetary representatives under the SEO's Colin Zula have announced the formation of a new political party named the 'Solar Sovereignty Party' under the banner of 'Independence from foreign demands'. The party consists of defectors from all three major parties; 9 Sol Economic Organization, 4 Icarus Front and 3 Shadow Coalition representatives have 'jumped ship' and will back Zula's demands to resume war with the Association, even if it means butting heads with the Skrell.\
	<br><br>\
	Rewi Kerehoma, chair of the SEO has expressed 'regret' that Mr. Zula and his supporters had chosen to splinter from the party, rather than work with 'More moderate, but like-minded' individuals across the SEO and wider Assembly. The SEO's official stance on the Skrellian demands are to demand close Solar oversight of any 'protectorate' to ensure that the region is 'policed to the highest standard, but that current Almachi citizens are afforded all the sapient rights they would be under the SCG.'\
	<br><br>\
	In the Shadow Coalition, a formal motion has been put forth by a small minority of representatives calling for the resignation of Speaker ISA-5, citing 'Total blindness to the political situation,' in the leadup to this week's events.\
	<br><br>\
	Meanwhile as Skrell vessels enter the Whythe system, the Solar Fleet has ceased bombardment of the Whythe Superweapon, handing off 'suppression' of the weapon to Skrell forces."

/datum/lore/codex/page/article85
	name = "04/20/64 - Sol To Submit - Almach Subsumed Under Treaty of Whythe"
	data = "Following 'intense' deliberations between the Far Kingdoms and representatives from the SCG, a decision has been reached to cede the secessionist Almach Association territory to the Skrell, and withdraw all forces from the region. The newly established Almach Protectorate will be subject to 'extremely stringent' oversight by Skrellian authorities, and international exchange of 'research and technologies' from the region will be banned 'in both directions', pending more a more exacting deal with the SCG. Sol is to be allowed 'regular inspections' of the territory on a schedule established by the Kingdoms.\
	<br><br>\
	The Solar envoy included the chairs of each of the major parties, senior ambassadors to major Skrell systems, and representatives from the Solar Fleet. The newly founded SSF were extended an invitation, but reportedly turned it down. A dejected looking MacKenzie West announced the terms of the treaty late this afternoon, stating that they had 'fought tooth and nail' for a fair deal for all parties involved, including civilians of all species now living under Skrellian occupation, and that 'those not directly involved in the corruption of humanity's sanctity should not be made to suffer for the actions of their superiors.'\
	<br><br>\
	Notably absent from deliberations were many key members of the Association's upper echelons, with 'lesser' diplomats taking the place of both Angessa Martei and Vounna's Naomi Harper. Almachi and Skrell sources were reluctant to explain these absenses, and it remains unclear as to whether they have been taken into Skrellian custody or remain at large.\
	<br><br>\
	Selma Jorg, Representative for Vir, has decried the treaty as a 'Sapientarian disaster in the making'. The former career diplomat has cited the 'general mistreatment of species deemed 'lesser'' as a recurring concern with the Skrell, and the complete occupation of majority human and positronic space, which unprecedented, could lead to 'conditions not much better than slavery' for those still living in the area. She has refrained from any direct accusations, pending the results of Sol's first permitted inspection."

/datum/lore/codex/page/article85
	name = "04/22/64 - Skrell Impose New Regime in Relan"
	data = "As agreed upon in the Treaty of Whythe, the Far Kingdoms have occupied the Relan system, putting an end to the Free Relan Federation. How the system will be organized is not entirely clear at this point. Despite the effective abolition of the Relanian government, Skrell presence in the system appears relatively light, and many of the scattered stations have no Skrell presence at all.\
	<br><br>\
	Former President Nia Fischer gave the following statement to a crowd gathered outside the Capitol Section of Carter: 'This is a dark time for all of us. I promise to you that, in my continued service to you, I will work with the Far Kingdoms to ensure that all of our people are treated well and our rights respected, and that we will arrive at a form of government that is acceptable to you.' The gathered crowd began to shout questions and accusations, and Fischer was quickly escorted back into the capitol by Skrellian guards without answering questions from the press or others. The crowd was quickly dispersed by Skrellian military police and Carter's own police force.\
	<br><br>\
	In the meantime, the governing of the system remains in the hands of the sparse occupation forces, aided by parts of the former Federation government.\
	<br><br>\
	In other news from the system, the Republic of Taron has negotiated a preliminary navigation and trade agreement with the Far Kingdoms, officially maintaining their neutrality despite the occupation of the majority of the system."

/datum/lore/codex/page/article86
	name = "04/27/64 - Chaos in Relan"
	data = "Simmering tensions in the Relan system have boiled over, with riots erupting on Carter, Abhayaranya, and New Busan. Since former President Fischer's brief address, small demonstrations against both the Skrell occupation and the collaborating elements of the former Federation government have taken place on many stations, but within the last day full-blown riots have broken out. While accurate information on the situation within the stations is rare, it is currently believed that the deaths of two protesters on Abhayaranya were the catalyst.\
	<br><br>\
	Damage to the three stations has been relatively light, with one major exception. A large fire broke out in the Capitol Section of Carter, killing at least 22, including former President Fischer, and wounding at least 74 more. Other casualties among rioters, police, and the populations of the stations are unknown at this point.\
	<br><br>\
	Other stations with significant permanent populations have been paralyzed by local inaction and the disloyalty of local police and security forces to the Far Kindgoms Skrell, and several with no Skrell presence have issued statements that they will not be accepting any military presence from the Far Kingdoms. It is unclear at this point if this represents the beginning of another major conflict within the system."

/datum/lore/codex/page/article87
	name = "04/30/64 - Meralar Correspondent: Triumphant Return!"
	data = "Celebrations have erupted throughout Tajaran space with the return of the PCMV Raniira's Grace, which has spent the last several months providing joint assistance with Solar military forces during the now-ceased hostilities with the Almach Association.\
	<br><br>\
	Khama Suketa enai-Lutiir, representative of the Tajaran Pearlshield Coalition, has provided the following statement:\
	<br><br>\
	'It is great honour that we welcome the crew of the Raniira's Grace back to their homes at Mesomori. We have all seen the battle reports, and loathe as we are to celebrate bloodshed, sometimes it is a necessary evil in the pursuit of a greater peace, and the Grace pursued that peace with fervour and tenacity as befitting our kind, and exemplified what we can do when put to the test. She is but one ship, and yet one ship can make all the difference. Lives have been saved, and the crew has returned alive and well. This is merely the beginning of what we can accomplish in the cosmos.'\
	<br><br>\
	When asked for comment on the Treaty of Whythe, Suketa had this to say:\
	<br><br>\
	'Indeed, the bittersweetness behind all of this. I will say, it is a... complicated and nuanced situation, as is so often the case with politics. We have our views on the matter, for sure, but now is not the time to formally engage with them. The Pearlshield is watching carefully, and when the dust settles and the terms of the treaty are exercised and accepted, we can take clearer view and action as possible and necessary. We still stand by the ideals we entered the war with, and we trust our allies to share them as ever. That will suffice for the moment.'"

/datum/lore/codex/page/article88
	name = "05/13/64 - Agreement Signed at Ithaca Station, New Government In Place"
	data = "In an effort to end the ongoing violence in the Relan system and regain the cooperation of 'insubordinate' stations, the Far Kingdoms Skrell have negotiated an agreement with community leaders and former Assemblypersons from a number of stations, including insubordinates, meeting at the largest of the insubordinates, Ithaca. Under these agreements, the Skrell will vacate most stations in the system, but will maintain a fleet base in Relan's Outer Belt for mutual defence, first at Carter and later at a dedicated station. Relan will have harsh restrictions placed on its military and will agree to formal diplomatic neutrality, but will be free to organize its own government under supervision and military occupation will end.\
	<br><br>\
	The mood on Ithaca has been tense as negotiations have gone on, but with the announcement of the results, crowds have packed the main thoroughfares and public spaces of the station in celebration. Francis Harp Yong, governor of Ithaca and a leading figure in the talks, addressed a crowd outside the Administration Section of Ithaca today. \
	<br><br>\
	'The agreement we have signed with the Skrell today has given our people a new chance, free from the mistakes of the war and the baggage of the former Association. The war was not brought on us by our choice, nor the occupation we have recently faced. We want peace, and that is obvious even to those who were fighting against us weeks or days ago.\
	<br><br>\
	Make no mistake, that is what our agreement today symbolizes. A new era of peace for us, where we no longer have to worry about the threat of piracy or invasion. We can return to our homes, rebuild our stations, and forge a new future for ourselves and our children'\
	<br><br>\
	It was also announced that though the work of restoring order to the system is ongoing, they expect elections will be held for a new Assembly and President within the next few months, with the exact date announced once violence on the major stations has ceased and cooperation from the insubordinate stations is secured. Yong will head an interim government in the meantime."

/datum/lore/codex/page/article89
	name = "08/15/64 - Almach Permits First Solar Inspection"
	data = "Almost four months since its establishment as a Skrellian territory, the Almach Protectorate Government has extended its first formal invitation to Solar Confederate Government inspectors to ensure the fledgling state is complying with restrictions imposed by the Treaty of Whythe.\
	<br><br>\
	The composition of the official Solar Inspection Group has been a matter of much deliberation over the past several months, and owing to the ground to be covered now includes over 3,500 experts from a wide variety of fields. The bulk of the Group is comprised of Transgressive Technologies Commission agents, including the EIO, but also includes military officials, independent observers, and corporate representatives. The inclusion of the latter group spurred heated debate in the Colonial Assembly, but ultimately 'thought-leaders' from Ward-Takahashi, NanoTrasen, and Hephaestus Industries were admitted, while other interests will have to be satisfied to be represented by Sol Economic Organization liaisons.\
	<br><br>\
	The APG, currently based out of what is to be a neutral embassy on Carter in Relan pending the completion of the new government centre of Vigilance Station in Whythe, is not legally required to fully comply with Five Points regulation, though the Whythe terms ensure that any transgressive research is undertaken under the strictest guidelines. The Skrell have amiably agreed to ensure that any innovation by the protectorate is safe, controlled, and does not enter Solar territory. These terms are similar to those applied to such technologies developed by and for the Skrell themselves, whose expertise is considered unrivalled in the field, but has been widely criticised by certain human bioconservative groups.\
	<br><br>\
	The inspection is expected to take several weeks, and will begin tomorrow."

/datum/lore/codex/page/article90
	name = "08/29/64 - Kaleidoscope Cosmetics Goes Trans-Stellar After Genix Merger"
	data = "Personal care giant Kaleidoscope Cosmetics has been officially recognised by the Solar Galactic Exchange as a true Trans-stellar Corporation today, following a controversial merger with Genix Therapeutic Systems and expanding its corporate assets to over 20 key systems.\
	<br><br>\
	Genix, which will now be operating under the Kaleidoscope name while retaining some corporate autonomy, has come under some scrutiny from the Transgressive Technologies Commission in recent months following its aggressive acquisition of liquidated Almachi assets in the aftermath of the Association's dissolution in April. The company was cleared of suspected Five Points violations without fanfare just two weeks ago, and allowed to resume work on the development a variety of previously approved commercial genetic modification products.\
	<br><br>\
	Many cosmetic gene-modification products have been available for some time - primarily in the Almach Rim - but have remained targeted at a relatively niche market. These treatments, ranging from cosmetic anti-aging to 'fantasy' body features are now set to be marketed and available in 'hundreds' of Kaleidoscope clinics galaxy-wide in the coming months. The TTC has reported that they are 'Confident that no transgressive modification is being provided and that these modifications are strictly superficial'. They have officially wished Kaleidoscope's directors well in their ascent to the galactic stage."

/datum/lore/codex/page/article91
	name = "09/21/64 - Almach Passes Inspection - Concerns Raised"
	data = "The Solar Inspection Group has granted the Almach Protectorate a passing grade in the first official inspection of the territory under Skrellian rule, though ethical concerns have been raised by a number of independent observers involved in the process.\
	<br><br>\
	During the course of the month-long inspection, Skrell facilitators were cooperative in ensuring the SIG were given 'unlimited' access to all research and development facilities requested by Sol, as well as informing the group of numerous previously unidentified locations that had been flagged by the Almach Protectorate Government since assuming control of the region in April. Critics of protectorate have suggested that the 'official list' may not be as comprehensive as stated, but the SIG has stated that they are 'confident that no deception has been undertaken by the APG. We have observed no evidence of research being concealed from our teams, and to the best of our knowledge the only locations left undisturbed are those few still occupied by Association holdouts, beyond the control of either inspecting government.'\
	<br><br>\
	Also as a result of the inspection, concerns have been raised regarding the treatment of ex-Association citizens, particularly the often genetically modified residents of Angessa's Pearl. While Angessa Martei's location is still unknown, her legacy - a society described by some as a cult of personality with emphasis on the cult - poses a significant threat to Skrellian control of the Exalt's Light system, and the clash of 'strong ideologies' has allegedly resulted in mistreatment of detainees that, according to the official report 'would not be permitted in Solar jurisdictions'.\
	<br><br>\
	The Protectorate's passing grade opens the door for interstellar trade to resume between the two nations for the first time in several years. Manufacturing giant Ward-Takahashi has already released a public statement on its intent to deal with the APG, and several other trans-stellars are expected to follow suit."

/datum/lore/codex/page/article92
	name = "09/24/64 - Kaleidoscope Announce Exclusive Almach Deal"
	data = "Mere days after the announcement of the reopening of Almachi-Solar trade, the Kaleidoscope Cosmetics corporation has confirmed that they have secured 'exclusive rights' to genetic products produced by several major manufacturers in the Angessa's Pearl system formerly owned by The Exalt - the insular mercurial theocracy of Exalt's Light - and recently handed over to the Almach Protectorate Government.\
	<br><br>\
	The details of the company's trade agreement have not been made public, but have reportedly already been approved by both the APG and SCG. The promptness of the agreement suggests to some that negotitations had been underway well before the announcement of the Protectorate's passing grade. Though cooperation between trans-stellar interests and government entities is far from unusual, such dealings with foreign governments - such as those widely made as 'open secrets' with Eutopia - are considered distasteful by many within the Icarus Front.\
	<br><br>\
	The Angessan products Kaleidoscope intends to offer have also not been made public, but are all to be thoroughly screened by the Transgressive Technologies Commission before being made available, though 'failing' proposals may be approved for use exclusively within Protectorate territory."

/datum/lore/codex/page/article93
	name = "10/04/64 - Yong Wins Relani Elections"
	data = "Despite concerns about domestic unrest and potential Skrellian interference, elections in Relan have gone ahead, selecting a new President and System Assembly. Francis Harp Yong, leader of the interim government and previous governor of the city-station Ithaca, known for his leading role in negotiating the end of Skrellian occupation and calming riots and rebellions earlier this year, has won the Presidency in a landslide, receiving nearly seventy percent of the vote. His party, the Spacer Union, has secured a narrow majority in the Assembly. The New Federalists, led by former member of the Harper government Odoacer Mieville, are the largest opposition party.\
	<br><br>\
	Yong has promised to reinforce Relani neutrality and rebuild the pre-war social system, forming a coalition of labor, technoprogressives, and anti-war activists. His victory likely means an end to the unrest that has plagued Relan since the end of the war with Almach."

/datum/lore/codex/page/article94
	name = "12/23/64 - Two Vessels Feared Lost In Isavau's Gamble"
	data = "Two Solar salvage vessels have been declared missing this week while undertaking operations in the remote Isavau's Gamble system. Locals also report that several smaller craft from the Eutopia system have 'vanished' under similar circumstances. Authorities are treating the disappearances as potential pirate attacks.\
	<br><br>\
	The XIV Sri Chamarajendra with crew of 32, and IIV Reimarus with 9 are both reported to have lost contact with the system's spaceport while undertaking far-orbit salvage operations on decommissioned and abandoned facilities, including the ILS Harvest Moon which detonated with all hands earlier this year. The disappearances have spurred the system government to request greater anti-piracy support from the SCG, which has been much reduced since the Almach War and increased tensions on the Hegemony border.\
	<br><br>\
	While Proximal to the independent and often 'lawless' Eutopia system, as well as the Rarkajar Rift, infamous prowl of the human-tajaran Jaguar Gang, the Isavau's System has rarely been a direct target for such large-scale apparent hijackings, and no group has yet claimed credit or demanded ransom."

/datum/lore/codex/page/article95
	name = "12/27/64 - NanoTrasen Accused In Satisfaction Poll Fixing"
	data = "The results of an annual system-wide corporate employee satisfaction poll in Vir have been called into question after a leak of internal employee contracts by an anonymous whistle blower. According to verified documents provided to the Vir News Network, NanoTrasen employees on annual employment contracts up for renewal are instructed to fill out an appended form expressing 'Extremely High' satisfaction with their employment at the company, or the contract will be deemed 'incomplete' and thus invalid.\
	<br><br>\
	NanoTrasen have been winners of the Vir Happy Employee Award for the 7 years running as of this year, and as such the legitimacy of the award, which has been run in major systems by the Sol Economic Organization since 2503, has been called seriously into question. The SEO has expressed regrets regarding the alleged fixing, but has stated that participating corporations are within their right to encourage employees to vote in a particular way.\
	<br><br>\
	According to NanoTrasen, the so-called 'Satisfaction Clause' in their contract renewal process is entirely permissible from a legal standpoint, and the company has no plans to make any changes at this time. When approached for comment, one anonymous employee stated that they 'had never even heard of' the award."

/datum/lore/codex/page/article96
	name = "01/03/65 - VirGov Seals Security Deal With Local Firm"
	data = "Governor Lusia Hainirsdottir has announced sweeping changes to government law enforcement in Vir, lynchpinned by the signing of a five-year contract with home-grown independent security and arms firm, Hedberg-Hammarstrom. The private enterprise will be assuming 'key duties' in local law enforcement and system security, in a move that Hainirsdottir says 'will save millions in taxpayer money, and encourages local, Virite businesses that we trust them every step of the way'.\
	<br><br>\
	While many colonies and facilities in Vir rely wholly on in-house security forces and will continue to do so, Hedberg-Hammarstrom is set to take over government patrol duties throughout the system, as well as administrating a large portion of previously government-run local law enforcement agencies including policing and wilderness garrisons.\
	<br><br>\
	CEO Gunnar Hammarstrom has reassured current SifGuard members at all levels that they need not fear for their jobs, and that for many the changes will be as simple as a slight change in uniform and a different name on their paychecks, but that H-H agents will be assuming managerial roles in most locations."

/datum/lore/codex/page/article97
	name = "01/05/65 - Top NanoTrasen Executive Injured In Sif Bombing"
	data = "Calvert Moravec, Chief Operations Officer for NanoTrasen Vir remains in a critical condition following a suspected assassination attempt on Saturday. The former gubernatorial candidate had been making a speech at a small NanoTrasen facility known for a prior terrorist attack by Boiling Point forces two years ago, when a small explosive device detonated close to the executive's leg, rendering him unconcious.\
	<br><br>\
	NanoTrasen security have elected to investigate the bombing internally, refusing to cooperate with SifGuard authorities on the grounds of disagreements with newly established Hedberg-Hammarstrom management. Mr. Moravec, nephew of NanoTrasen CEO Albary Moravec had reportedly been speaking out against H-H's involvement in national policing when the blast occurred.\
	<br><br>\
	Commander Spradling of NanoTrasen Internal Security has issued a company-wide active search order for one member of the audience who remains unaccounted for named 'Lae Vu', who is believed to be a journalist or posing as such, accompanied by images from communicator footage taken at the event.\
	<br><br>\
	This amateur footage also shows one member of the audience shouting an anti-corporate slogan and throwing a small electronic device at Moravec before being escorted from the room, just moments prior to the explosion. Spradling has stated that this individual, who is believed to be a disgruntled veteran of the Sif Defense Force, remains one of several persons of interest, but that the thrown item does not appear to be connected directly with the explosive device.\
	<br><br>\
	Reports from witnesses suggest that Mr. Moravec made a temporary recovery thanks to the fast action of medical staff aboard the NLS Southern Cross, but that a few hours later he appeared to suffer from a seizure, after which he was placed into a medically induced coma that he is yet to recover from. Unverified images from the Cross appear to show a disoriented individual resembling Moravec self-medicating with a cocktail of prescribed painkillers and alcoholic beverages, though the company strongly denies their veracity."

/datum/lore/codex/page/article98
	name = "02/02/65 - NanoTrasen Announces Employee-Led Advisement Scheme"
	data = "Trans-stellar giant NanoTrasen has today announced the launch of their brand-new 'NanoTrasen Employee Representation Committee' scheme, which will allow employee-selected representatives to have a say in company policy on a local basis. Initially launching as a pilot in 'a few key regions', the NERC is intended to provide an in-house method for those working for NanoTrasen to 'address grievances and provide valuable input without resorting to radical means'.\
	<br><br>\
	Vir is one of three size regions of varying scale but similar company presence selected for the pilot program, alongside the 'Deep Bowl' - including Stove, Viola and New Singapore, and 'South America', on Earth. Elections are expected to take place over the coming weeks, with each region electing representatives from core facilities in their locale. The Vir Branch will be expected to select five employees, one from each of; their New Reykjavik Head Office (Colloquially know as 'CentComm'), Karan colony the NCS Northern Star, Kalmar-based NMB Gullstrand medical research center, Sivian way-station NLS Southern Cross, and the company's sprawling Ekmanshalvo Fabrication Plant.\
	<br><br>\
	The Representation Committee is set to have quite significant powers over their region's day-to-day operations, ranging from Standard Operation Procedure, to security enforcement, to interior design."

/datum/lore/codex/page/article99
	name = "02/06/65 - Calvert Moravec Dead At 58, Announces Withdrawal From Public Life"
	data = "Just over a month since his injury in a brazen assassination attempt, NanoTrasen Vir's Chief Operations Officer Calvert Moravec has announced his 'temporary withdrawal' from public and corporate matters, in an inspiring speech given from his post-cloning recovery ward. The noted corporate executive passed away on Friday, following a long comatose period, but is expected to make a full recovery.\
	<br><br>\
	Mr. Moravec has stated that he believes a spell 'away from the public eye' will do wonders for his recovery, and 'expects to make a return some time in the coming years'. However, Moravec has reaffirmed that his stance on corporate policing, which is believed to have been the reason for the January bombing, remains unchanged; 'The refusal of Hedberg-Hammarstrom to allow our security teams to access government criminal records has been a significant hindrance to the investigation into my death. Allowing just one corporation exclusive access to this data is unequivocally wrong.'"

/datum/lore/codex/page/article100
	name = "02/08/65 - NERC Campaigning Begins in Vir"
	data = "NanoTrasen's latest employee initiative, the NanoTrasen Employee Representation Committee is set to hold their first in-house election this coming weekend, after 'respectable' signup rates for the positions across all participating Vir-based facilities.\
	<br><br>\
	According to those interviewed at a few sites, campaigning may be mixed. One potential committee member for the Gullstrand Medical Center described the competition as 'cut-throat' with staff looking to be split between the selection of already respected chief medical experts, and 'more represenative' service staff. Conversely, one worker at the Ekmanshalvo Fabrication Plant complex stated that he 'would probably just vote for whoever I've heard of.'\
	<br><br>\
	Final voting will take place on Saturday the 13th of February, with results announced by the following Monday."

/datum/lore/codex/page/article101
	name = "02/11/65 - Top Astronomers Announce 'Alarming' Tachyon Downtick"
	data = "The Galactic Survey Administration has today released a 'high priority' report on what is being described as a 'significant decline in core tachyon density' throughout the known galaxy. According to recent findings tachyon deterioration, which had previously been 'negligible' has undergone a 'rapid acceleration' which could begin to seriously affect interstellar transit in as soon as 30 to 50 years.\
	<br><br>\
	Tachyons are a naturally occurring particle present in varying density which form the primary mechanism for bluespace drive operation. In simple terms, the higher the density of tachyons, the more efficiently starship engines are capable of operating. Low-density regions such as the Rarkajar Rift have long posed a challenge to interstellar trade, and the expansion of such regions could prove devastating to galactic unity.\
	<br><br>\
	FTL industry leaders Focal Point Energistics have already announced 'immediate investigation' into the GSA's findings after taking a blow on the stock exchange, and have guaranteed a 'commitment to future-proofing' in all forthcoming products."

/datum/lore/codex/page/article102
	name = "02/15/65 - NanoTrasen Announces First NERC Members"
	data = "Following Saturday's internal election, NanoTrasen Vir has elected the first five members for its new Employee Representation Committee. These individuals are expected to hold the position for one month:\
	<br><br>\
	For the New Reykjavik Head Office Iraluq James, a remote personnel operative, won the position on a platform of employee morale, team-building and employee-employer conflict resolution.\
	<br><br>\
	On the NCS Northern Star, NanoTrasen's main colony station in Vir Victoria Bell, a cybernetic chef and hardshell operator won her place with promises of increased regulatory transparency and clarity, including the publication of an in-house magazine.\
	<br><br>\
	At the NMB Gullstrand medical science center in Kalmar, a close race between top doctors was upset by the election of a station security commander, Wish Elara-Voight who promises 'improvements to the safety and security of NanoTrasen facilities with a focus on enforcing current SoP and CorpReg policies and placing new procedure in the handbooks.'\
	<br><br>\
	The waypoint station NLS Southern Cross selected a cybernetic Unathi candidate, researcher Dr. Haven Rasikl to represent them on the basis of encouraging interdepartmental cooperation and communication.\
	<br><br>\
	Finally, the Ekmanshalvo Fabrication Plant has selected fabrication programmer Terazon Norddahl, who promises to push for overhauls and modernization of the company's internal transport and support systems, including shuttle scheduling."

/datum/lore/codex/page/article103
	name = "03/10/65 - GSA Confirms Presence Of 'New' Deep-Space Threat"
	data = "This morning the Galactic Survey Administration released confirmation that a previously unknown deep-space dwelling species was indeed responsible for the disappearance of five Extraplanar Discovery Division vessels early last year, three of which have returned adrift over the past several days. The species, colloquially dubbed the 'Bluespace Bugs' after initial reports from the recovered EDD ships, are believed to be capable of manipulating matter in a manner reminicent of experimental bluespace technology.\
	<br><br>\
	The three 'returning' vessels are said to have been 'significantly off-course', with their points of galactic re-entry differing vastly from their initial points of egress, and final programmed return routes. Each ship having departed on routes from Sol, the SCG-E Bungaree was reported adrift by Almach Protectorate officials close to the Vounna system, the SCG-E Ketumati severely damaged on a collision course with the Erebus star, in the Nyx system, and the SCG-E Mag Mell collided with the garden world of Sif, in Vir. The Gagarin and Xu Fu remain unaccounted for, but due to the proximity of final contact, their disappearance has also been ascribed to the 'bugs'.\
	<br><br>\
	Investigation of the recovered vessels each indicated signs of a brief struggle, always following reports of unexplained equipment disappearances and equipment failure. No crew, or crew remains have been found, with the exception of a single unidentified human thumb aboard the Bungaree.\
	<br><br>\
	Additionally, each ship has been identified as having undergone some degree of material alteration, with elements ranging from hull plating to crew belongings having taken on a crystaline form dubbed 'Magmellite' after the ship most thoroughly 'reconstructed'. It is unclear whether the mineral is somehow secreted by the alien species, or merely a product of the same environment.\
	<br><br>\
	GSA sources have stated that there is no current evidence that the insectoid creatures - identified only from scattered descriptions left from missing EDD personnel - are in any way sapient or malicious, and the lost vessels are thought to have merely disturbed a scattered array of endemic populations far from the galactic plane. Precisely why the species has only been encountered in the past year, and now all at once, is not yet known."

/datum/lore/codex/page/article104
	name = "05/24/65 - Oculum Apologizes for Interstellar Relay Outages"
	data = "Week-long difficulties with interstellar transmissions in several central star systems due to an 'unexpected behaviour' in bluespace relays 'should be resolved soon' according to telecoms giant Oculum Broadcast. The company has apologized to customers for connection speed drops as much as 80% which have rendered certain live systems near impossible for many customers, including disruption of telecast Colonial Assembly meetings on Luna which have been temporarily put on hold in order to allow representatives time to attend in person.\
	<br><br>\
	Customers may experience reduced speeds compared to prior service, but have been promised a two-year price freeze on exonet service packages for home and business users on most major providers in participating areas. In-system communications remain unaffected.\
	<br><br>\
	Initial reports that the finale broadcast of Game of Drones was 'rendered unwatchable' by connection issues proved to be unfounded as severe lag and audio distortion were confirmed as 'part of the creator's artistic vision for the story's end'."

/datum/lore/codex/page/article105
	name = "06/07/65 - 104 Feared Dead In Oasis Tourist Shuttle Incident"
	data = "The Vir Governmental Authority has confirmed the destruction of a small interstellar tourist vessel departing the Vir system. The ITV Relaxation IX operated by Thousand Palms Hotels, was bound for a popular resort in Oasis and reportedly 'split in two' shortly after confirming system bluespace departure with Vir space traffic control, exposing all passenger compartments to space and killing at least 94 of the 108 people onboard.\
	<br><br>\
	Four crew members recovered from forward sections are being treated for 'non-life-threatening' pressure injuries at a nearby medical facility, and ten individuals believed to have been situated at the rear of the ship remain unaccounted for. The exact cause of the break-up is yet to be determined, but initial accounts from surviving crew members describe the bluespace drive of the ship as having 'taken off by itself' at such speed that the rear of the fuselage was 'cut clean off' with no regard for structural elements. Foul play is not currently suspected.\
	<br><br>\
	The VGA believes that the chances of finding further survivors are 'extremely slim', though efforts to recover the rear section, which was 'sling-shot' into interstellar space, are underway. Gilthari Exports, Thousand Palms' parent company have temporarily suspended operation of all vessels fitted with similar bluespace drives, and Major Bill's Transportation is expected to follow suit. Wulf Aeronautics was unavailable for comment at this time."

/datum/lore/codex/page/article106
	name = "07/09/65 - 'Bluespace Bugs' Linked To Almach Tech"
	data = "Initial public reports on the extraplanar species commonly known as 'Bluespace Bugs' has proposed that the first recognizable signs of their activity within observable space, coincide precisely with the development - and particularly the test-firing - of the Whythe Superweapon, and that there may be a direct link between the two. The report, released by the Galactic Survey Administration this afternoon hypothesizes that the newly developed bluespace manipulation techniques used in Whythe may have acted as a signal to the deep-space dwelling creatures in a manner similar to moths attracted to artificial light. The GSA is currently collaborating with the Almach Protectorate Government to investigate the potential link further.\
	<br><br>\
	Additionally, findings from analysis of both inorganic and biological samples collected from the three recovered Extraplanar Discovery ships believed to belong to the 'Bugs' has excited much of the scientific community, with news that the insect-like aliens and their apparent dietary waste-product Magmellite may be composed in a manner completely unlike any life previously encountered in the known galaxy. The findings may rewrite our understanding of biology and material science, though a full specimen is desired to confirm these early findings.\
	<br><br>\
	The creatures have been given a tentative scientific name X Extraneus Tarlevi, after Captain Volmer Tarlev of the SCG-E Ketumati whose recorded descriptions were instrumental in establishing a basic understanding of the species' behavior. Researchers currently believe that the Bluespace Bugs are merely a form of bulk-feeding omnivore attracted to the EDD vessels in deep space by their bluespace drives, and that the loss of the ships was merely unfortunate happenstance rather than deliberate, malicious attack. Studies are already underway to determine methods that might prevent further incidents of this types before any further extraplanar missions are approved."

/datum/lore/codex/page/article107
	name = "08/15/65 - Enigmatic Arkship Sighted After 200 Year Voyage"
	data = "Recent reports from the New Singapore-based Exoplanar Traffic Observation Committee, have claimed historic extraplanar arkship, the VHS Rodnakya, has changed trajectory and may be approaching the galactic plane once more.\
	<br><br>\
	The ETOC, comprised of mostly exoplanar and shuttlecraft enthusiasts in the Bowl, have been tracking both government and private survey expeditions since the 2450's, reporting the approximate locations and assumed status of vessels for public record. The VHS Rodnakya has been a major point of interest among ETOC members since its formation, sometimes dominating discussions entirely, and the focus for numerous unverified theories.\
	<br><br>\
	The Arkship and its support fleet, known as 'Vystholm' was constructed in the early 2300's by Stanislava Dalibor, and left the galactic plane in response to the abolition of the SCG's First Contact Policy that demanded the capture and interrogation of unknown sapient aliens. It has not had any official contact with the galactic community since. Largely known for radical and since-outdated views on non-human intelligent life, their original crew was known to include a number of early Icarus Front extremists which may have fermented into a dangerous ideology after 200 years of isolation.\
	<br><br>\
	This alleged trajectory change has sparked excitement among the committee, including a flurry of completely unsupported reports of spies infiltrating Solar society, from the corporate workforce to major government bodies.\
	<br><br>\
	The Vir News Network does not endorse the unverified claims of the Exoplanar Traffic Observation Committee."

/datum/lore/codex/page/article108
	name = "09/12/65 - Gateway Transport Suspended Amidst Safety Concerns"
	data = "Nine of the galaxy's top trans-stellars have announced immediate suspension of bluespace gateway transit services following a report by Wulf Aeronautics indicating that some of the same tachyon instabilities affecting their faster-than-light engine technology may have even more severe reprecussions for rapid point-to-point teleportation that could result in 'significant decrease in matter' during rematerialization that could result in customer death, disfigurement, or loss of luggage.\
	<br><br>\
	Dismissing accusations that this was a move to bolster a weakened spacecraft travel industry, Focal Point Energistics, the original developers of modern gateway technology were first to announce their suspension of service on all first-party operated access points. Major contract operators, including NanoTrasen, Ward-Takahashi, and Gilthari Exports have followed suit citing a desire for caution when dealing with premium employee transport.\
	<br><br>\
	NanoTrasen are the Vir system's leading operator of gateway transport, offering 'luxury, near-instant interplanetary commutes' between most major company facilities, and the Vir Interstellar Spaceport. The company says it will be removing many smaller gate installations for 'full examination and required enhancements' and expects the service to return 'within a few weeks'.\
	<br><br>\
	Major Bill's Transportation have announced an increased frequency of service to affected NanoTrasen locations for the duration of the gateway suspension."

/datum/lore/codex/page/article109
	name = "10/23/65 - 12th Missing Ship Prompts Official Isavau Response"
	data = "After a shocking 12th interstellar vessel was declared missing in the Isavau's Gamble system earlier this week, the SCG has formally announced the launch of an official investigation, including the deployment of a significant Fleet security presence in the region. The lost ship, the HFV El Cid is recorded as having a crew complement of eight, pushing the total missing people in the system over the past year over one hundred and fifty. A contingent of around twenty SCG vessels - search and rescue, salvage, and armed warships - has been dispatched to the region to take over from near-absent local investigators, but is not expected to arrive for at least a month due to worsening FTL flight conditions.\
	<br><br>\
	The El Cid is believed to have been hauling highly secure cargo internationally, which may have been the final deciding factor in launching a confederation-level investigation into the abnormal number of appearances, and the SCG has come under quick criticism for their apparent prioritization of lost cargo over sapient lives. Fleet Admiral Silvain Barka, celebrated veteran of the Almach War, has stated 'Lives are our number one concern. The matter of the Hephaestus cargo has simply moved our timeline forward due to concerns that if high-grade arms were to fall into pirate hands, the situation in Isavau's Gamble could rapidly worsen. We want to avoid that, and bring back as many of the missing crew as possible.'\
	<br><br>\
	While piracy has long been a concern in the Bowl, with the 'Jaguar Gang' pirates making their home in the region, and a general uptick having occurred since the beginning of the Almach Crisis, it is unusual for such a high proportion of missing ships crews to remain lost without report of recovery or ransom demands. Accusations of brutality have been levied at the Vystholm flotilla, despite their improbable distance from the star system. To date the XIV Sri Chamarajendra remains the single largest loss of life, at 32 believed dead during a large salvage mission late last year."

/datum/lore/codex/page/article110
	name = "10/26/65 - 'Bluespace Bug' Confirmed Activity Near Tajaran Space"
	data = "The following address is from Khama Suketa enai-Lutiir, representative of the Tajaran Pearlshield Coalition:\
	<br><br>\
	'Good day, everyone. We would like to put the rumor mills to rest lest they get out of hand. Eleven Solar days ago, the Silk system's perimeter defenses picked up what appeared to be a derelict Vox raiding ship that had drifted into range. Security forces boarded the craft and found clear signs of fighting within the crew compartments, but no traces of the crew themselves. The craft's bluespace drives were notably ripped out of the hull, and it's believed the craft had been drifting for up to nearly two Solar weeks prior, as it has been identified as the 'Skiskatachtlakta', belonging to a well-known Vox raiding group our cousins in the Arrathiir system have been contending with for a few years now, and that was their last confirmed contact with it.\
	<br><br>\
	'Most importantly however, and the key reason for this address, is a significant portion of the ship's hull, particularly concentrated around the site of its bluespace drives, has been confirmed to've been converted to the material known as 'Magmellite', related to the so-called 'bluespace bugs' or X Extraneus Tarlevi that have been of note outside our borders. To acknowledge and assuage any natural alarm on our own part, there is no indication any part of the incident took place on our side of the Rift, and we are deploying additional reconnaissance and recovery ships, drones and general personnel throughout controlled space to keep a watchful eye, and we are negotiating with Solar forces in Silk to expand our presence as appropriate. We are currently analyzing the Magmellite samples recovered from the Skiskatachtlakta and will be sharing any findings with our fellows in the scientific sphere, as well as returning the ship's plundered riches if and when possible.\
	<br><br>\
	'There is currently no cause for concern beyond the understandable. If and when there is, we will rise to the occasion as always. Together, we will discover the truth of these strange times we find ourselves in. Until then, be safe, and be well. May our stars shine upon us all.'"

/datum/lore/codex/page/article111
	name = "01/14/66 - Unathi Border On Alert After Manoeuvre Scare"
	data = "The Solar garrison at Abel's Rest remains on high alert following a critical near-miss scenario resulting from an unannounced Unathi fleet arrival at the disputed system's perimeter alert zone, which has since been determined to be not a deliberate act of war. According to the Moghes Hegemony the fleet is 'part of a re-evaluation of <the Hegemony's> key troop deployments, that will be of mutual benefit to peace in the region'.\
	<br><br>\
	The arriving fleet, comprised of mostly troop transport vessels, remained in distant orbit of the star for seven hours before diplomatic contact could be established, during which time the SCG garrison remained at battle-ready stance. This marks the closest proximity to open conflict in Abel's Rest since the end of the Unathi War over 45 years ago. SolGov peacekeepers have confirmed decreased planetside garrison activity over the past several months, and key Hegemony warships have departed in recent weeks.\
	<br><br>\
	It remains impossible to determine the Unathi's true intentions as such a withdrawal could preface devastating planetary bombardment, or invasion elsewhere, and some members of the Icarus Front have called for immediate redeployment to the front in response. The SCG Fleet has assured the public that relations with the Hegemony have 'never been better' and that long-range sensors indicate a withdrawal from the entire border region on a far wider scale."

/datum/lore/codex/page/article112
	name = "02/13/66 - Isavau's Gamble Fleet Report 'All Silent'"
	data = "Early reports from the SCG contingent sent to investigate potential pirate activity in the Isavau's Gamble system include shocking descriptions of a system 'gone silent', with supposedly zero manmade signals originating from any ship or station in the entire area. Prior loss of contact several days prior had been ascribed to naturally occurring background noise 'overwhelming' the system Spaceport's bluespace relays, which had been operating at reduced efficiency due to the ongoing tachyon downtick.\
	<br><br>\
	While messages from the SCG-D Brazen Bull were similarly weakened by what has been described as a bluespace 'hum', no immediate cause for alarm was raised. The fleet indicated that they were proceeding to investigate the Isavau International Spaceport and hoped to make direct contact with the crew within a matter of hours.\
	<br><br>\
	While telecommunications outages were a forecasted consequence of the tachyon downtick, highly focused and widespread instances such as that occurring in Isavau's Gamble were not, which has cast doubt on the predictive models being used, and raised concerns of additional factors at play. A newly observed phenomena from the Brazen Bull's report, 'blue points of light suspended in space with no discernible origin' has led to some speculation of a re-concentration of tachyon particles which some hope may hold the key to preventing further deterioration of the energetic landscape."

/datum/lore/codex/page/outage
	name = "02/14/66 - 02/15/74 - RELAY DATA OUTAGE"
	data = "Article data lost for 2922 day period. Reason: Damage sustained to Oculum systems during Skathari Incursion. Please contact your administrator for details."

/datum/lore/codex/page/article113
	name = "08/17/74 - Vox Continue To Show Alarming Divergence In Behaviour; Experts Baffled"
	data = "Reports published by the Interspecies Joint Anti-Piracy Initiative this month continue to support an unsettling trend; the Vox, violent reptoavian aliens best known for engaging in rampant piracy, are simply not behaving as expected. Tactical and strategic models built painstakingly over the last three centuries are now showing accuracy ratings as low as 3%, with a rapidly growing number of raids either occurring outwith predicted regions or timeframes, or more alarmingly, not being predicted at all.\
	<br><br>\
	'Something has altered their priorities,' said Wataru Murata, the head of the Joint Operations Group in charge of tracking Vox activity. 'In some areas we're seeing vastly more unarmed transport, mining and salvaging vessels, than we were as recently as two months ago, and in others, we're seeing strength and frequency of raiding groups as much as tripling. It's a very complex situation.'\
	<br><br>\
	'They've never been so unpredictable before,' agreed senior naval officer Akira Doi. 'I understand that there is currently no official theory on why this is happening, but I believe it all goes back to the Skathari Incursion.'\
	<br><br>\
	Many leading scientists are skeptical that the Incursion, despite having thrown much of the galactic community into chaos over an eight-year period of conflict with the insectoid Skathari, could have seriously disrupted the Vox in the same way, given the relatively low indications of Skathari presence in known Vox operating territories, but Admiral Doi strongly disagrees.\
	<br><br>\
	'The Skathari are aggressive to an unprecedented degree,' he explained, 'and they had the ability and numbers to annihilate entire communities. I see no reason why that shouldn't have applied to the Vox.'\
	<br><br>\
	While some colonies and stations welcome this reprieve from raids and piracy, others are finding themselves under renewed pressure, with resources and labour withdrawn on the advice of apparently unreliable modelling. A representative of the Pearlshield Coalition territory of Arrathiir had this to say regarding the sluggish reallocation of resources after the latest wave of raids:\
	<br><br>\
	'On the frontier we are no strangers to fighting and rebuilding after raider attacks, but without reliable resupply of fuel and munitions from the home worlds, we cannot even field our ships. This is costing us dearly.'"

/datum/lore/codex/page/article114
	name = "09/25/74 - 'Emerald Skies' Conspiracy Protest Shuts Down New Reykjavik Mall"
	data = "This weekend saw the Vinterlykke Shopping Center shut down after a surge of protesters crowded the mall. Vinterlykke is known as the largest mall in New Reykjavik, renowned for its expansive selection of shops, restaurants, and entertainment options.\
	<br><br>\
	According to witnesses, protesters crowded the major walkways, preventing shoppers from passing and leaving some stranded in shops to avoid the crowd. Many shops barred and locked the storefronts in response, an unnamed employee of one store commenting, 'That many people <...> you never know if it's going to get out of control.'\
	<br><br>\
	The protesters chanted with signs regarding NanoTrasen's exclusive rights in studying the Sif Anomalous Region, demanding that studies into the anomalous properties be public knowledge. The march appears to be headed by the Skathari conspiracy group 'Emerald Skies', known in recent months for many other smaller protests regarding the government response to the Incursion, and beliefs that Skathari are more intelligent than the public has been informed.\
	<br><br>\
	The disruption was eventually cleared out by mall security forces before the crowd could grow out of control. It is reported that Vinterlykke will reopen on Monday with additional security measures in place."
