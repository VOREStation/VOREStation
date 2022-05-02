//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Chaplain"
	flag = CHAPLAIN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Head of Personnel"
	selection_color = "#515151"
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	minimal_access = list(access_chapel_office, access_crematorium)

	outfit_type = /decl/hierarchy/outfit/job/chaplain
	job_description = "The Chaplain ministers to the spiritual needs of the crew."
	alt_titles = list("Counselor" = /datum/alt_title/counselor)

// Chaplain Alt Titles
/datum/alt_title/counselor
	title = "Counselor"
	title_blurb = "The Counselor attends to the emotional needs of the crew, without a specific medicinal or spiritual focus."

/datum/job/chaplain/equip(var/mob/living/human/H, var/alt_title, var/ask_questions = TRUE)
	. = ..()
	if(!.)
		return
	if(!ask_questions)
		return

	var/obj/item/weapon/storage/bible/B = locate(/obj/item/weapon/storage/bible) in H
	if(!B)
		return

	if(GLOB.religion)
		B.deity_name = GLOB.deity
		B.name = GLOB.bible_name
		B.icon_state = GLOB.bible_icon_state
		B.item_state = GLOB.bible_item_state
		to_chat(H, "<span class='boldnotice'>There is already an established religion onboard the station. You are an acolyte of [GLOB.deity]. Defer to the [title].</span>")
		return
	
	INVOKE_ASYNC(src, .proc/religion_prompts, H, B)

/datum/job/chaplain/proc/religion_prompts(mob/living/carbon/human/H, obj/item/weapon/storage/bible/B)
	var/religion_name = "Unitarianism"
	var/new_religion = sanitize(input(H, "You are the crew services officer. Would you like to change your religion? Default is Unitarianism", "Name change", religion_name), MAX_NAME_LEN)
	if(!new_religion)
		new_religion = religion_name

	switch(lowertext(new_religion))
		if("unitarianism")
			B.name = "The Great Canon"
		if("christianity")
			B.name = "The Holy Bible"
		if("judaism")
			B.name = "The Torah"
		if("islam")
			B.name = "Quran"
		if("buddhism")
			B.name = "Tripitakas"
		if("hinduism")
			B.name = pick("The Srimad Bhagvatam", "The Four Vedas", "The Shiv Mahapuran", "Devi Mahatmya")
		if("neopaganism")
			B.name = "Neopagan Hymnbook"
		if("phact shintoism")
			B.name = "The Kojiki"
		if("kishari national faith")
			B.name = "The Scriptures of Kishar"
		if("pleromanism")
			B.name = "The Revised Great Canon"
		if("spectralism")
			B.name = "The Book of the Spark"
		if("hauler")
			B.name = "Histories of Captaincy"
		if("nock")
			B.name = "The Book of the First"
		if("singulitarian worship")
			B.name = "The Book of the Precursors"
		if("starlit path of angessa martei")
			B.name = "Quotations of Exalted Martei"
		if("sikhism")
			B.name = "Guru Granth Sahib"
		else
			B.name = "The Holy Book of [new_religion]"
	feedback_set_details("religion_name","[new_religion]")

	var/deity_name = "Hashem"
	var/new_deity = sanitize(input(H, "Would you like to change your deity? Default is Hashem", "Name change", deity_name), MAX_NAME_LEN)

	if((length(new_deity) == 0) || (new_deity == "Hashem"))
		new_deity = deity_name
	B.deity_name = new_deity

	GLOB.religion = new_religion
	GLOB.bible_name = B.name
	GLOB.deity = B.deity_name
	feedback_set_details("religion_deity","[new_deity]")
	

<<<<<<< HEAD
=======
/* If you uncomment this, every time the mob preview updates it makes a new PDA. It seems to work just fine and display without it, so why this exists, haven't a clue. -Hawk
/datum/job/chaplain/equip_preview(var/mob/living/human/H, var/alt_title)
	return equip(H, alt_title, FALSE)
*/
>>>>>>> 666428014d2... Merge pull request #8546 from Atermonera/surgery_refactor
