//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = JOB_CHAPLAIN
	flag = CHAPLAIN
	departments = list(DEPARTMENT_CIVILIAN)
	department_flag = CIVILIAN
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	pto_type = PTO_CIVILIAN
	supervisors = "the " + JOB_HEAD_OF_PERSONNEL
	selection_color = "#515151"
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	minimal_access = list(access_chapel_office, access_crematorium)

	outfit_type = /decl/hierarchy/outfit/job/chaplain
	job_description = "The " + JOB_CHAPLAIN + " ministers to the spiritual needs of the crew."
	alt_titles = list(JOB_ALT_MISSIONARY = /datum/alt_title/missionary, JOB_ALT_PREACHER = /datum/alt_title/preacher, JOB_ALT_PRIEST = /datum/alt_title/priest,
							JOB_ALT_NUN = /datum/alt_title/nun, JOB_ALT_MONK = /datum/alt_title/monk, JOB_ALT_COUNSELOR = /datum/alt_title/counselor,
						JOB_ALT_GURU = /datum/alt_title/guru)

// Chaplain Alt Titles
/datum/alt_title/counselor
	title = JOB_ALT_COUNSELOR
	title_blurb = "The " + JOB_ALT_COUNSELOR + " attends to the emotional needs of the crew, without a specific medicinal or spiritual focus."

/datum/alt_title/guru
	title = JOB_ALT_GURU
	title_blurb = "The " + JOB_ALT_GURU + " primarily tries to offer spiritual guidance to those who come seeking it."

/datum/alt_title/missionary
	title = JOB_ALT_MISSIONARY

/datum/alt_title/preacher
	title = JOB_ALT_PREACHER

/datum/alt_title/priest
	title = JOB_ALT_PRIEST

/datum/alt_title/nun
	title = JOB_ALT_NUN

/datum/alt_title/monk
	title = JOB_ALT_MONK

/datum/job/chaplain/equip(var/mob/living/carbon/human/H, var/alt_title, var/ask_questions = TRUE)
	. = ..()
	if(!.)
		return
	if(!ask_questions)
		return

	var/obj/item/storage/bible/B = locate(/obj/item/storage/bible) in H
	var/obj/item/card/id/I = locate(/obj/item/card/id) in H

	if(!B || !I)
		return

	INVOKE_ASYNC(src, PROC_REF(religion_prompts), H, B, I)

/datum/job/chaplain/proc/religion_prompts(mob/living/carbon/human/H, obj/item/storage/bible/B, obj/item/card/id/I)
	var/religion_name = "Unitarianism"
	var/new_religion = sanitize(tgui_input_text(H, "You are the crew services officer. Would you like to change your religion? Default is Unitarianism", "Name change", religion_name, MAX_NAME_LEN))
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

	var/deity_name = "Hashem"
	var/new_deity = sanitize(tgui_input_text(H, "Would you like to change your deity? Default is Hashem", "Name change", deity_name, MAX_NAME_LEN))

	if((length(new_deity) == 0) || (new_deity == "Hashem"))
		new_deity = deity_name

	var/new_title = sanitize(tgui_input_text(H, "Would you like to change your title?", "Title Change", I.assignment, MAX_NAME_LEN))

	var/list/all_jobs = get_job_datums()

	// Are they trying to fake an actual existent job
	var/faking_job = FALSE

	for (var/datum/job/J in all_jobs)
		if (J.title == new_title || (new_title in get_alternate_titles(J.title)))
			faking_job = TRUE

	if (length(new_title) != 0 && !faking_job)
		I.assignment = new_title

	H.mind.my_religion = new /datum/religion(new_religion, new_deity, B.name, "bible", "bible", new_title)

	B.deity_name = H.mind.my_religion.deity
	I.assignment = H.mind.my_religion.title
	I.name = text("[I.registered_name]'s ID Card ([I.assignment])")
	GLOB.data_core.manifest_modify(I.registered_name, I.assignment, I.rank)

/datum/religion
	var/religion = "Unitarianism"
	var/deity = "Hashem"
	var/bible_name = "Bible"
	var/bible_icon_state = "bible"
	var/bible_item_state = "bible"
	var/title = JOB_CHAPLAIN
	var/configured = FALSE

/datum/religion/New(var/r, var/d, var/bn, var/bis, var/bits, var/t)
	. = ..()
	religion = r
	deity = d
	bible_name = bn
	bible_icon_state = bis
	bible_item_state = bits
	title = t
