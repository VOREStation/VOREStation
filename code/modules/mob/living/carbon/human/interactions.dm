/**********************************
*******Interactions code by HONKERTRON feat TestUnit********
**Contains a lot ammount of ERP and MEHANOYEBLYA**
***********************************/

/mob/living/carbon/human/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(M == src || src == usr || M != usr)		return
	if(usr.restrained())		return

	var/mob/living/carbon/human/H = usr
	H.partner = src
	make_interaction(machine)

/mob/proc/make_interaction()
	return

//Distant interactions
/mob/living/carbon/human/verb/interact(mob/M as mob)
	set name = "Interact"
	set category = "IC"

	if (istype(M, /mob/living/carbon/human) && usr != M)
		partner = M
		make_interaction(machine)

/datum/species/human
	genitals = 1
	anus = 1

/datum/species/plasmaman
	anus = 0

/datum/species/kidan
	anus = 0

/datum/species/wryn
	anus = 0

/datum/species/unathi
	genitals = 1
	anus = 1

/datum/species/Tajara
	genitals = 1
	anus = 1

/datum/species/vulpkanin
	genitals = 1
	anus = 1

/datum/species/human/skrell
	genitals = 0
	anus = 1

/datum/species/monkey
	genitals = 1
	anus = 1

/datum/species/monkey/skrell
	genitals = 0
	anus = 1

/datum/species/human/machine
	genitals = 0
	anus = 0 //kiss my metal ass

/datum/species/human/diona
	genitals = 0
	anus = 0

/datum/species/human/vatgrown
	genitals = 1
	anus = 1

/datum/species/human/spacer
	genitals = 1
	anus = 1

/datum/species/human/gravworlder
	genitals = 1
	anus = 1

/datum/species/teshari
	genitals = 1
	anus = 1

/datum/species/akula
	genitals = 1
	anus = 1

/datum/species/sergal
	genitals = 1
	anus = 1

/datum/species/nevrean
	genitals = 0
	anus = 1

/datum/species/hi_zoxxen
	genitals = 1
	anus = 1

/datum/species/fl_zorren
	genitals = 1
	anus = 1

/datum/species/xenohybrid
	genitals = 1
	anus = 1

/datum/species/shapeshifter/promethean
	genitals = 1
	anus = 1

/datum/species/spider
	genitals = 1
	anus = 1

/datum/species/custom
	genitals = 1
	anus = 1

/datum/species/harpy
	genitals = 1
	anus = 1

/mob/living/carbon/human/proc/is_nude()
	return (!wear_suit && !w_uniform) ? 1 : 0 //TODO: Nudity check for underwear

/mob/living/carbon/human/make_interaction()
	set_machine(src)

	var/mob/living/carbon/human/H = usr
	var/mob/living/carbon/human/P = H.partner
	var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
	var/hashands = (temp && temp.is_usable())
	if (!hashands)
		temp = H.organs_by_name["l_hand"]
		hashands = (temp && temp.is_usable())
	temp = P.organs_by_name["r_hand"]
	var/hashands_p = (temp && temp.is_usable())
	if (!hashands_p)
		temp = P.organs_by_name["l_hand"]
		hashands = (temp && temp.is_usable())
	var/mouthfree = !((H.head && (H.head.flags & HIDEFACE)) || (H.wear_mask && (H.wear_mask.flags & HIDEFACE)))
	var/mouthfree_p = !( (P.head && (P.head.flags & HIDEFACE)) || (P.wear_mask && (P.wear_mask.flags & HIDEFACE)))
	var/haspenis = ((H.gender == MALE && H.potenzia > -1 && H.species.genitals))
	var/haspenis_p = ((P.gender == MALE && P.potenzia > -1  && P.species.genitals))
	var/hasvagina = (H.gender == FEMALE && H.species.genitals && H.species.name != "Stok" && H.species.name != "Teshari")
	var/hasvagina_p = (P.gender == FEMALE && P.species.genitals && P.species.name != "Stok" && P.species.name != "Teshari")
	var/hasanus_p = P.species.anus
	var/isnude = H.is_nude()
	var/isnude_p = P.is_nude()

	H.lastfucked = null
	H.lfhole = ""

	var/dat = "<B><HR><FONT size=3>INTERACTIONS - [H.partner]</FONT></B><BR><HR>"
	var/ya = "&#1103;"

	dat +=  {"� <A href='?src=\ref[src];interaction=bow'>�������� ������.</A><BR>"}
	//if (Adjacent(P))
	//	dat +=  {"� <A href='?src=\ref[src];interaction=handshake'>����������������.</A><BR>"}
	//else
	//	dat +=  {"� <A href='?src=\ref[src];interaction=wave'>����������������.</A><BR>"}
	if (hashands)
		dat +=  {"<font size=3><B>����:</B></font><BR>"}
		if (Adjacent(P))
			dat +=  {"� <A href='?src=\ref[src];interaction=handshake'>������ ����.</A><BR>"}
			dat +=  {"� <A href='?src=\ref[src];interaction=hug'>���������!</A><BR>"}
			dat +=  {"� <A href='?src=\ref[src];interaction=cheer'>��������� �� �����</A><BR>"}
			dat +=  {"� <A href='?src=\ref[src];interaction=five'>���� �[ya]��.</A><BR>"}
			if (hashands_p)
				dat +=  {"� <A href='?src=\ref[src];interaction=give'>�������� �������.</A><BR>"}
			dat +=  {"� <A href='?src=\ref[src];interaction=slap'><font color=red>���� ��������!</font></A><BR>"}
			if (isnude_p)
				if (hasanus_p)
					dat += {"� <A href='?src=\ref[src];interaction=assslap'>�������� �� �������</A><BR>"}
				if (hasvagina_p)
					dat += {"� <A href='?src=\ref[src];interaction=fingering'>��������� �������...</A><BR>"}
				if (haspenis_p)
					dat += {"� <A href='?src=\ref[src];interaction=jerk'>���������</A><BR>"}
			if ((P.species.name == "Tajara") || (P.species.name == "Vulpkanin") || (P.species.name == "Flatland Zorren") || (P.species.name == "Highlander Zorren") || (P.species.name == "Sergal") || (P.species.name == "Vox") || (P.species.name == "Nevrean") || (P.species.name == "Rapala") || (P.species.name == "Teshari") || (P.species.name == "Unathi"))
				dat +=  {"� <A href='?src=\ref[src];interaction=pull'><font color=red>ĸ����� �� �����!</font></A><BR>"}
				if(P.can_inject(H, 1))
					dat +=  {"� <A href='?src=\ref[src];interaction=pet'>���������.</A><BR>"}
			dat +=  {"� <A href='?src=\ref[src];interaction=knock'><font color=red>���� ������������.</font></A><BR>"}
		dat +=  {"� <A href='?src=\ref[src];interaction=fuckyou'><font color=red>�������� ������� �����.</font></A><BR>"}
		dat +=  {"� <A href='?src=\ref[src];interaction=threaten'><font color=red>��������� �������.</font></A><BR>"}

	if (mouthfree && H.species.name != "Diona")
		dat += {"<font size=3><B>����:</B></font><BR>"}
		dat += {"� <A href='?src=\ref[src];interaction=kiss'>����������.</A><BR>"}
		if (Adjacent(P))
			if (mouthfree_p)
				dat += {"� <A href='?src=\ref[src];interaction=lick'>������� � ����.</A><BR>"}
			if (isnude_p)
				if (haspenis_p)
					dat += {"� <A href='?src=\ref[src];interaction=blowjob'><font color=purple>������� �����.</font></A><BR>"}
				if (hasvagina_p)
					dat += {"� <A href='?src=\ref[src];interaction=vaglick'><font color=purple>��������.</font></A><BR>"}
				if (hasanus_p && P.species.name != "Diona")
					dat += {"� <A href='?src=\ref[src];interaction=asslick'><font color=purple>������������ ������ ���?!</font></A><BR>"}
			dat +=  {"� <A href='?src=\ref[src];interaction=spit'><font color=red>�������.</font></A><BR>"}
		dat +=  {"� <A href='?src=\ref[src];interaction=tongue'><font color=red>�������� [ya]���.</font></A><BR>"}

	if (Adjacent(P) && isnude && P.species.name != "Diona")
		if (haspenis && hashands)
			dat += {"<font size=3><B>����:</B></font><BR>"}
			if (hasvagina_p && isnude_p && P.species.name != "Teshari")
				dat += {"� <A href='?src=\ref[src];interaction=vaginal'><font color=purple>�������� ����������.</font></A><BR>"}
			if (hasanus_p && isnude_p)
				dat += {"� <A href='?src=\ref[src];interaction=anal'><font color=purple>�������� �������.</font></A><BR>"}
			if (mouthfree_p)
				dat += {"� <A href='?src=\ref[src];interaction=oral'><font color=purple>�������� �������.</font></A><BR>"}
	if (isnude && hashands)
		if (hasvagina)
			dat += {"<font size=3><B>����:</B></font><BR>"}
			if (isnude_p && haspenis_p && usr.loc == H.partner.loc)
				dat += {"� <A href='?src=\ref[src];interaction=mount'><font color=purple>��������</font></A><BR>"}
				dat += {"� <A href='?src=\ref[src];interaction=rub'><font color=purple>���������[ya]</font></A><BR>"}
			if (mouthfree_p && usr.loc == H.partner.loc)
				dat += {"� <A href='?src=\ref[src];interaction=facesitting'><font color=purple>����� �� ����</font></A><BR>"}
			if (mouthfree_p && (Adjacent(P) || (usr.loc == H.partner.loc)))
				dat += {"� <A href='?src=\ref[src];interaction=forcelick'><font color=purple>��������� ����������</font></A><BR>"}

	var/datum/browser/popup = new(usr, "interactions", "Interactions", 340, 480)
	popup.set_content(dat)
	popup.open()

//INTERACTIONS
/mob/living/carbon/human
	var/mob/living/carbon/human/partner
	var/mob/living/carbon/human/lastfucked
	var/lfhole
	var/potenzia = 10
	var/resistenza = 200
	var/lust = 0
	var/erpcooldown = 0
	var/multiorgasms = 0
	var/lastmoan

mob/living/carbon/human/proc/cum(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, var/hole = "floor")
	var/message = "������� �� ���!"
	var/ya = "&#255;"
	var/turf/T

	if (H.gender == MALE)
		var/datum/reagent/blood/source = H.dna.b_type
		if (P)
			T = get_turf(P)
		else
			T = get_turf(H)
		if (H.multiorgasms < H.potenzia)
			var/obj/effect/decal/cleanable/cum/C = new(T)
			// Update cum information.
			C.blood_DNA = list()
			if(source.data["blood_type"])
				C.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
			else
				C.blood_DNA[source.data["blood_DNA"]] = "O+"

		if (H.species.genitals)
			if (hole == "mouth" || H.zone_sel.selecting == "mouth")
				message = pick("������� [P] � ���.", "������[ya] � ���� [P], �����[ya]�� ����� ����� �������, �� ������������[ya].", "������������� ���[ya] �� ���� [P].", "������� �� ���.")

			else if (hole == "vagina")
				message = pick("������� � [P]", "����� ���[ya]������ ���� �� [P], � ����� �������� �� ���.", "��������� � [P] ��������� ���, ����� ����������[ya]. ������ �������� �������� �� ���� [P].")

			else if (hole == "anus")
				message = pick("������� [P] � ���.", "����������� ���� �� [P], � ����� ������� ������� �� [P.identifying_gender == MALE ? "���" : "�"] �����.", "���[ya]������ ���� �� ������� [P] � ����� �� �������� �� ���.")

			else if (hole == "floor")
				message = "������� �� ���!"

		else
			message = pick("���������[ya] � �������� �������", "���������� ����� � ����� ������", "����������[ya], � ����� ����� ��������[ya]���[ya]", "��������, ������� �����")

		playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 70, 1, frequency = get_age_pitch())

		H.visible_message("<B>[H] [message]</B>")
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message("<B>[H] [message]</B>")
		H.lust = 5
		H.resistenza += 50

	else
		message = pick("���������[ya] � �������� �������", "���������� ����� � ����� ������", "����������[ya], � ����� ����� ��������[ya]���[ya]", "��������, ������� �����")
		H.visible_message("<B>[H] [message].</B>")
		if (istype(P.loc, /obj/structure/closet))
			P.visible_message("<B>[H] [message].</B>")
		playsound(loc, "honk/sound/interactions/final_f[rand(1, 3)].ogg", 90, 1, frequency = get_age_pitch())
		var/delta = pick(20, 30, 40, 50)
		src.lust -= delta

	H.druggy = 60
	H.multiorgasms += 1
	H.erpcooldown = 0
	H.lust = 0

mob/living/carbon/human/proc/fuck(mob/living/carbon/human/H as mob, mob/living/carbon/human/P as mob, var/hole)
	var/ya = "&#255;"
	var/message = ""

	switch(hole)

		if("vaglick")

			message = pick("���������� [P].", "���������� [P].")
			if (prob(35))
				switch(P.species.name)
					if("Human", "Vatborn", "Custom Species", "Rapala", "Vasilissan", "Akula", "Promethean", "Unathi")
						message = pick("���������� [P].", "�������� ����������� [P] [ya]�����.", "���������� [P].", "������� [P] [ya]������.", "��������� ���� [ya]��� � [P]", "�������[ya] � [P] [ya]������", "�������� �������� [ya]����� ����� ����������� [P]")
					if("Tajara", "Vulpkanin", "Flatland Zorren", "Highlander Zorren", "Sergal")
						message = pick("���������� [P].", "�������� ����������� [P] [ya]�����.", "���������� [P].", "������� [P] [ya]������.", "��������� ���� [ya]��� � [P]", "�������[ya] � [P] [ya]������", "�������� �������� [ya]����� ����� ����������� [P]")

			if (H.lastfucked != P || H.lfhole != hole)
				H.lastfucked = P
				H.lfhole = hole

			if (H.lust < 6)
				H.lust += 6
			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message]</B></font>")
				P.lust += 10
			else
				H.visible_message("<font color=purple>[H] [message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message]</font>")
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H)
					message = pick("�� ����������, ��� ����������� ����� [P] �������� ����� ����������[ya].", "�� ����������, ��� � ��� ��� �������� ��������� ���������� �[ya]���[ya]�� [P] � �������� �������.", "�� ����������, ��� ������[ya] ����� [P] ����� ������� ��� [ya]����� ������ ���[ya].", "�� ����������, ��� �� ������ [P] ��������[ya], � � ������ �������� ������������.", "�� ����������, ��� [P] ������� ��� � ��� �������� �[ya]���[ya]��, ���������[ya].")
					to_chat(H, message)
				else
					P.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bj[rand(1, 11)].ogg", 50, 1, -1)

		if("facesitting")

			message = pick("������ ������� �� ���� [P].", "������� ���� [P].")
			if (prob(35))
				message = pick("������� ������ [P], ������[ya] �� ���� ������.", "�������� [ya]��� [P] ����� ������������, ����������� �� [P.identifying_gender==FEMALE ? "�" : "���"] ����.", "���������� ��� [P] ������ ������� ��� � ������ �� ��.", "������ ����[ya] � ���� [P] ������������, ������[ya] �����.", "�������� ���� [P] �������� �������[ya]�� ����.", "�������[ya] � ������� [P], ����[ya] �� ���� ����������.", "�������� �������� ������������ �� ���� [P].", "����������� ���� ���� �� ���������� [P] �������[ya]�� ����.")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("�[ya]��� ������[ya] [P] �� ����.", "����� �����������[ya] �� ���� [P].", "������[ya] �� ���� [P], �����[ya]�� ���������� ������� [P.identifying_gender==FEMALE ? "��" : "���"] ��� ���.", "������� ���� [P] ����� ������� ������������.")
				H.lastfucked = P
				H.lfhole = hole

			if (P.lust < 6)
				P.lust += 6
			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message]</B></font>")
				H.lust += 10
			else
				H.visible_message("<font color=purple>[H] [message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message]</font>")
			if (H.stat != DEAD && H.stat != UNCONSCIOUS)
				H.lust += 10
				if (H.lust >= H.resistenza)
					H.cum(H, P)
					timeofact = world.time
					message = pick("�� ����������, ��� ����������� ����� [H] �������� ����� ����������[ya].", "�� ����������, ��� � ��� ��� �������� ��������� ���������� �[ya]���[ya]�� [H] � �������� �������.", "�� ����������, ��� ������[ya] ����� [H] ����� ��������[ya] �� ����� ����.", "�� ����������, ��� �� ������ [H] ��������[ya], � � ������ �������� ������������.", "�� ����������, ��� [H] ������� ��� �� ���� �������� �[ya]���[ya]��, ���������[ya].")
					to_chat(P, message)
				else
					H.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/champ_fingering.ogg", 50, 1, -1)

		if("forcelick")

			message = pick("�������[ya]�� [P] ����������.", "���������� [P] ���������� ����.")
			if (prob(35))
				message = pick("������ ��������� ������ [P] � ����.", "������� ��� � ��� [P], ������[ya] �����.", "�������� ���������� [P], ���������� � [P.identifying_gender==FEMALE ? "�" : "���"] ������.", "����������� ������ [P] � ������ ���������, ��������[ya]�� ������� [ya]����.", "����� ������� ������ �� ������ [P], ����� [P.identifying_gender==FEMALE ? "�" : "���"] [ya]��� ����������[ya] ������.")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("�[ya]��� ������[ya]�� [P] � ����� �������.", "����� ������� ������ [P] � �������[ya]�� � ����� �����������.", "������[ya]�� ���� [P], �������[ya] [P.identifying_gender==FEMALE ? "�" : "���"] ��� � ���� ���������� �����.", "�������[ya]�� ��� [P] � ����� ������� �����������.")
				H.lastfucked = P
				H.lfhole = hole

			if (P.lust < 6)
				P.lust += 6
			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message]</B></font>")
				H.lust += 10
			else
				H.visible_message("<font color=purple>[H] [message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message]</font>")
			if (H.stat != DEAD && H.stat != UNCONSCIOUS)
				H.lust += 10
				if (H.lust >= H.resistenza)
					H.cum(H, P)
					timeofact = world.time
					message = pick("�� ����������, ��� ����������� ����� [P] �������� ����� ����������[ya].", "�� ����������, ��� � ��� ��� �������� ��������� ���������� �[ya]���[ya]�� [P] � �������� �������.", "�� ����������, ��� ������[ya] ����� [P] ����� ������� ��� [ya]����� ������ ���[ya].", "�� ����������, ��� �� ������ [P] ��������[ya], � � ������ �������� ������������.", "�� ����������, ��� [P] ������� ��� � ��� �������� �[ya]���[ya]��, ���������[ya].")
					to_chat(P, message)
			else
				H.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bj[rand(1, 11)].ogg", 50, 1, -1)

		if("fingering")

			message = pick("������ ��� ������ � ������ [P].", "������� [P] ��������.")
			if (prob(35))
				switch(P.species.name)
					if("Human", "Vatborn", "Custom Species", "Rapala", "Vasilissan", "Akula", "Promethean")
						message = pick("������ ��� ������ � ������ [P].", "������� �������� [P].", "����� �������� [P].", "������� [P] ����������.", "����� ����������� ����������� [P].", "��������� ������ ������� � [P], �����[ya] � �������.", "������� ������� [P].")
					if("Tajara", "Vulpkanin", "Flatland Zorren", "Highlander Zorren", "Sergal")
						message = pick("������ ��� ������ � �������� ������ [P].", "������� �������� [P].", "����� �������� [P].", "������� [P] ����������.", "����� ����������� ����������� [P].", "��������� ������ ������� � [P], �����[ya] � �������.", "������� ������� [P].")

			if (H.lastfucked != P || H.lfhole != hole)
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message]</B></font>")
				P.lust += 8
			else
				H.visible_message("<font color=purple>[H] [message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message]</font>")
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 8
				if (P.lust >= P.resistenza)
					P.cum(P, H)
					message = pick("�� ����������, ��� ����������� ����� [P] �������� ����� ����������[ya] ������ ����� �������.", "�� ����������, ��� ��������� ������ [P] ������ ������� ���� ��������� ������.", "�� ����������, ��� ������[ya] ����� [P] ����� ������� ���� ������ ������ ���[ya].", "�� ����������, ��� ����� ������� ���������[ya] ����� ������ ���[ya]��� ������� [P].", "�� ����������, ��� �� ���������� ������� ����� ������ ������� ����[ya] ������� �[ya]���[ya]�� [P].")
					to_chat(H, message)
				else
					P.moan()
			playsound(loc, "honk/sound/interactions/champ_fingering.ogg", 50, 1, -1)
			H.do_fucking_animation(P)

		if("jerk")

			message = pick("����� �� ���������� [P] � ����������� ��� ���������-��������������� �������[ya]��.", "������ ����� [P] � ������� �����.", "�������� ������� ���� [P] ����������.", "����������� [P] ��������.", "������ ���� [P], �������� ��� � ������� �� ���� �������.", "�������� ����������� ����� [P].", "������ [P], �������� ��� ���� �����.", "����������� ���� [P].", "����������� ������� ����� [P] ������� �������.", "������ ������� ����� [P].", "������������ [P].", "������ [P].")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("�[ya]��� ����������� ���� [P] �����.", "���� ���� [P] � ����.", "�������� ����������� [P].")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message]</B></font>")
				P.lust += 5
			else
				H.visible_message("<font color=purple>[H] [message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message]</font>")
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 5
				if (P.lust >= P.resistenza)
					P.cum(P, H)
					timeofact = world.time
					message = pick("������� [H] � ����.", "������� � ������ ������� [H].", "������������� ���[ya], �����[ya] ������� � ������ [H].", "������� �� ���.", "�����[ya]�� ����� ����� �������, ���[ya]����[ya] [H].")
					P.visible_message("<B>[P]</B> [message]")
					playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 70, 1, frequency = get_age_pitch())
					P.lust = 0
					P.druggy = 60
				else
					P.moan()
			playsound(loc, "honk/sound/interactions/champ_fingering.ogg", 50, 1, -1)
			H.do_fucking_animation(P)

		if("blowjob")

			switch(H.species.name)
				if("Human", "Skrell", "Vatborn", "Custom Species", "Rapala", "Vasilissan")
					message = pick("���������� [P].", "����� ���� [P].", "����������� ���� [P] [ya]�����.")
					if (prob(35))
						message = pick("������ ����� [P], ������� ����� �� �����������[ya].", "�����������, ������� �����, �� ������[ya] ���� [P] ��� ���.", "������� ���� [P] [ya]������, ����������[ya] ��� �����.", "���������� ���� [P] �� ���� �����.", "��������� ���� [P] ��� ������ ���� � ���.", "�������� [ya]���� ���������� ������� ����� [P].", "����� �� ������ ����� [P] � ����� ���� ��� � ���.", "���� ������� [P].", "������� ������� ����-�����, ���������[ya] ���� [P].", "��������� ���������� ���� [P].", "������������, ��������� ����������� ������ [P].", "������� ���� [P], ������[ya] ���� ������.")
					if (H.lastfucked != P || H.lfhole != hole)
						message = pick("�[ya]��� ����������� ���� [P] ������.", "���������� ������ ���� [P].")
						H.lastfucked = P
						H.lfhole = hole

				if("Unathi", "Akula", "Sergal", "Teshari")
					message = pick("���������� ���� [P].", "����������� ����� [P] [ya]�����.", "��� ���� [P] � ���� [ya]���.", "������������ ���� [P] ���� � �����, �����[ya]�� �� �������� ��� ������.", "����������� ���� [P] [ya]�����.")
					if (prob(35))
						message = pick("���������� ����� [P], ������� ����� �� �����������[ya].", "�����������, ������� �����, �� ������[ya] ���� [P] �� �����.", "������� ���� [P] [ya]������, ����������[ya] ��� �����.", "���������� ���� [P] �� ���� �����.", "��������� ���� [P] ��� ������ ���� � �����.", "�������� [ya]���� ���������� ������� ����� [P].", "����� �� ������ ����� [P] � ������������ ��� ���� � ������.", "���������� ������� [P].", "������� ������� ����-�����, ���������[ya] ���� [P].", "��������� ���������� ���� [P].", "������������, ��������� ����������� ������ [P].", "������� ���� [P], ������[ya] ���� ������.")
					if (H.lastfucked != P || H.lfhole != hole)
						message = pick("�������� [ya]���� �������[ya] ����� [P].", "���������� ���������� ���� [P].")
						H.lastfucked = P
						H.lfhole = hole

				if("Tajara", "Vulpkanin", "Flatland Zorren", "Highlander Zorren")
					message = pick("���������� ���� [P].", "������� ����� �������� [ya]������ ������ ����� [P].", "������������ ���� [P] ���� � �����, �����[ya]�� �� �������� ��� ������.", "����������� ���� [P] [ya]�����.")
					if (prob(35))
						message = pick("���������� ����� [P], ������� ����� �� �����������[ya].", "�����������, ������� �����, �� ������[ya] ���� [P] �� �����.", "������� ���� [P] [ya]������, ����������[ya] ��� �����.", "���������� ���� [P] �� ���� �����.", "��������� ���� [P] ��� ������ ���� � �����.", "�������� [ya]���� ���������� ������� ����� [P].", "����� �� ������ ����� [P] � ������������ ��� ���� � ������.", "���������� ������� [P].", "������� ������� ����-�����, ���������[ya] ���� [P].", "��������� ���������� ���� [P].", "������������, ��������� ����������� ������ [P].", "������� ���� [P], ������[ya] ���� ������.")
					if (H.lastfucked != P || H.lfhole != hole)
						message = pick("�������� [ya]���� �������[ya] ����� [P].", "���������� ���������� ���� [P].")
						H.lastfucked = P
						H.lfhole = hole

				if("Vox", "Nevrean")
					message = pick("���������� ���� [P].", "����������� ����� [P] [ya]�����.", "��� ���� [P] � ���� [ya]���.", "������������ ���� [P] ���� � ������, �����[ya]�� �� �������� ��� ������.", "����������� ���� [P] [ya]�����.")
					if (prob(35))
						message = pick("���������� ����� [P], ������� ����� �� �����������[ya].", "�����������, ������� �����, �� ������[ya] ���� [P] �� �����.", "������� ���� [P] [ya]������, ����������[ya] ��� ������.", "���������� ���� [P] �� ���� �����.", "��������� ���� [P] ��� ������ ���� � ����.", "�������� [ya]���� ���������� ������� ����� [P].", "����� �� ������ ����� [P] � ������������ ��� ���� � ������.", " ���������� ������� [P].", "������� ������� ����-�����, ���������[ya] ���� [P].", "��������� ���������� ���� [P].", "������������, ��������� ����������� ������ [P].", "������� ���� [P] [ya]�����.")
					if (H.lastfucked != P || H.lfhole != hole)
						message = pick("�������� [ya]���� �������[ya] ����� [P].", "���������� ���������� ���� [P].")
						H.lastfucked = P
						H.lfhole = hole

				if("Promethean")
					message = pick("���������� [P].", "����� ���� [P].", "����������� ���� [P] [ya]�����.")
					if (prob(35))
						message = pick("������ ������ ����� [P], ������� ����� �� �����������[ya].", "�����������, ������� �����, �� ������[ya] ���� [P] ��� ���.", "������� ���� [P] [ya]������, �������[ya] ��� �[ya]���� ������.", "���������� ���� [P] �� ���� �����, ������[ya][ya] ���� �� �����.", "��������� ���� [P] ��� ������ ���� � ���.", "�������� [ya]���� ���������� ������� ����� [P].", "��������� ������ ����� [P] ������ ������ � ����� ���� ��� � ���.", "����� ������� [P].", "������� ������� ����-�����, ���������[ya] ���� [P].", "��������� ���������� ���� [P].", "������������, ��������� ����������� ������ [P].", "������� ���� [P], ������[ya] ���� ������.")
					if (H.lastfucked != P || H.lfhole != hole)
						message = pick("�[ya]��� ����������� ���� [P] ������, ����������[ya] ��� ������.", "���������� ������ ���� [P].")
						H.lastfucked = P
						H.lfhole = hole

				if("Diona")
					return

				if("Machine")
					return

			if (H.lust < 6)
				H.lust += 6
			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message]</B></font>")
				P.lust += 10
			else
				H.visible_message("<font color=purple>[H] [message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message]</font>")
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H, "mouth")
					timeofact = world.time
					message = pick("������� [H] � ���.", "������[ya] � ���� [H], �����[ya]�� ����� ����� �������, �� ������������[ya].", "������������� ���[ya] �� ���� [H].", "������� �� ���.", "�������� �� [ya]����� [H].")
					P.visible_message("<B>[P]</B> [message]")
					playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 70, 1, frequency = get_age_pitch())
					P.lust = 0
					P.druggy = 60
			playsound(loc, "honk/sound/interactions/bj[rand(1, 11)].ogg", 50, 1, -1)
			H.do_fucking_animation(P)
			if (prob(P.potenzia))
				H.oxyloss += 3
				H.visible_message("<B>[H]</B> [pick("������[ya] ������������ <B>[P]</B>", "���������[ya]", "�������[ya] � ������� ������")].")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[H]</B> [pick("������[ya] ������������ <B>[P]</B>", "���������[ya]", "�������[ya] � ������� ������")].")

		if("vaginal")

			message = pick("������� [P].", "������� [P].", "������ [P].")
			if (prob(35))
				switch(P.species.name)
					if("Human", "Skrell", "Vatborn", "Custom Species", "Rapala", "Vasilissan", "Unathi")
						message = pick("����� ������� [P].", "�������[ya] ��������� ����� � [P].", "������ ��������� ����������[ya] ������ [P].", "�������[ya] ������ [P].", "������� �����, ��������[ya] ���� � [P].", "������, ��������[ya]�� �� [P].", "������ ����������[ya] ����� � [P].", "���������� [P] �� ���� ����.", "���������� ����� [P].")
					if("Tajara", "Vulpkanin", "Flatland Zorren", "Highlander Zorren")
						message = pick("����� ������� [P].", "�������[ya] ��������� ����� � [P].", "������ ��������� ����������[ya] ������ [P].", "�������[ya] ������ [P].", "������� �����, ��������[ya] ���� � [P].", "������, ��������[ya]�� �� [P].", "������ ����������[ya] ����� � [P].", "���������� [P] �� ���� ����.", "���������� ����� [P].")
					if("Promethean")
						message = pick("����� ������� [P].", "�������[ya] ��������� ����� � [P].", "������ ��������� ����������[ya] ������ [P].", "�������[ya] ������ [P].", "������� �����, ��������[ya] ���� � [P].", "������, ��������[ya]�� �� [P].", "������ ����������[ya] ����� � [P].", "���������� [P] �� ���� ����.", "���������� ����� [P].")
						playsound(loc, "honk/sound/interactions/champ[rand(1, 2)].ogg", 50, 1, -1)

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("��������� ���� ���� �� ����� [ya]��� � [P].", "������ ���� ����� ����� � ���� [P].", "��������� ���� ������ ������ ������ [P].", "��������� � [P].")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message]</B></font>")
				P.lust += H.potenzia * 2
			else
				H.visible_message("<font color=purple>[H] [message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message]</font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 10
			if (H.lust >= H.resistenza)
				H.cum(H, P, "vagina")
				timeofact = world.time
				message = pick("������� � [P]", "����� ���[ya]������ ���� �� [P], � ����� �������� �� ���.", "��������� � [P] ��������� ���, ����� ����������[ya]. ������ �������� �������� �� ���� [P].")
				H.visible_message("<B>[H]</B> [message]")
				playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 70, 1, frequency = get_age_pitch())
				H.lust = 0
				H.druggy = 30
				P.lust += 5

			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += H.potenzia * 0.5
				if (P.lust >= P.resistenza)
					P.cum(P, H)
					message = pick("�� ����������, ��� ����������� ����� [P] �������� ����� ����������[ya] ������ ������ �����������.", "�� ����������, ��� ��������� ������ [P] ������ ������� ��� ����[ya]����� ����.", "�� ����������, ��� ������[ya] ����� [P] ����� ������� ��� ���� ������ ���[ya].", "�� ����������, ��� ������ ������� ���������[ya] ����� ������ ���[ya]��� ������� [P].", "�� ����������, ��� ����� ������ ������[ya]������ ������ [P] ������ ��������[ya] ��������� ���, ��������[ya] ��� � �������.")
					to_chat(H, message)
				else
					P.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bang[rand(1, 3)].ogg", 70, 1, -1)

		if("anal")

			message = pick("������ [P] � ����.", "������� ������� [P].", "������� [P] � ����.")
			if (prob(35))
				switch(P.species.name)
					if("Human", "Vatborn", "Custom Species", "Rapala", "Vasilissan", "Akula")
						message = pick("������� [P] � �������.", "��������� ���� [P] � �������� ������ �� ����� [ya]���.", "����� ����� � ����� [P].", "��������� [P] ���� �������� ������[ya]��.", "��������� ������ ������� � �������� ����� [P].")
					if("Unathi")
						message = pick("������� [P] � ������.", "��������� ���� [P] � �������� ������ �� ����� [ya]���.", "����� ����� � ����� [P].", "��������� [P] ���� �������� ������[ya]��.", "��������� ������ ������� � �������� ����� [P].")
					if("Tajara", "Vulpkanin", "Flatland Zorren", "Highlander Zorren", "Sergal")
						message = pick("������� [P] ��� �����.", "��������� ���� [P] � �������� ������ �� ����� [ya]���.", "������ [P] ��� �������� �������.", "����� ����� � ����� [P].", "��������� [P] ���� �������� ������[ya]��.", "��������� ������ ������� � �������� ����� [P].")
					if("Skrell", "Teshari", "Vox", "Nevrean")
						message = pick("������� [P] � ������.", "��������� ���� [P] � �������� ������ �� ����� [ya]���.", "����� ����� � ����� [P].", "��������� [P] ���� �������� ������[ya]��.", "��������� ������ ������� � �������� ����� [P].")
					if("Promethean")
						message = pick("������� [P] � �������.", "��������� ���� [P] � �������� ������ �� ����� [ya]���, �[ya]��[ya]�� � �[ya]���� �����.", "��c�[ya]������ [P] ���� �������� ������[ya]��.")
						playsound(loc, "honk/sound/interactions/champ[rand(1, 2)].ogg", 50, 1, -1)

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" ����������� ��������� �������� ��������� [P].", "��������� ���� [P] � ����.")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message]</B></font>")
				P.lust += H.potenzia * 2
			else
				H.visible_message("<font color=purple>[H] [message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message]</font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 12
			if (H.lust >= H.resistenza)
				H.cum(H, P, "anus")
				timeofact = world.time
				message = pick("������� [P] � ���.", "����������� ���� �� [P], � ����� ������� ������� �� [P.identifying_gender == MALE ? "���" : "�"] �����.", "���[ya]������ ���� �� ������� [P] � ����� �� �������� �� ���.")
				H.visible_message("<B>[H]</B> [message]")
				playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 70, 1, frequency = get_age_pitch())
				H.lust = 0
				H.druggy = 30
				P.lust += 5

			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				if (H.potenzia > 13)
					P.lust += H.potenzia * 0.25
				else
					P.lust += H.potenzia * 0.75
				if (P.lust >= P.resistenza)
					P.cum(P, H)
				else
					P.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bang[rand(1, 3)].ogg", 70, 1, -1)

		if("oral")

			message = pick(" ������� [P], ��������[ya] ���� ���� [P.identifying_gender == FEMALE ? "��" : "���"] � ������.", " ������� ������� [P].")
			if (prob(35))
				switch(P.species.name)
					if("Human", "Skrell", "Vatborn", "Custom Species", "Rapala", "Vasilissan")
						message = pick(" ��������[ya] �� ����� [P], ����������[ya] [P.identifying_gender==FEMALE ? "�" : "���"] � ��������[ya] ���� �� ������� � ������� [P.identifying_gender==FEMALE ? "��" : "���"] � ������.", " ������� [P] � ���.", " ���������� ������ [P] �� ���� ����.", " ������ [P] �� ������ ����[ya] ������ � ��������� �������[ya] �����.", " ��� �������� [P], ��������[ya] ����� ������ � ���.", " ��������� ���������[ya] ������� [P].", ", ���� ������ ����, ���[ya]������ ������ [P] �� ������ ������.")
					if("Unathi", "Akula", "Sergal", "Teshari")
						message = pick(" ��������[ya] �� ����� [P], ����������[ya] [P.identifying_gender==FEMALE ? "�" : "���"] � ��������[ya] ���� �� ������� � ������� [P.identifying_gender==FEMALE ? "��" : "���"] � ������.", " ������� [P] � �������� �����.", " ���������� ������ [P] �� ���� ����.", " ������ [P] �� ������ ����[ya] ������ � ��������� �������[ya] �����.", " ��� �������� [P], ��������[ya] ����� [P.identifying_gender == FEMALE ? "������ [ya]�����" : "������� [ya]����"] � �����.", " ��������� ���������[ya] ������� [P].", ", ���� ������ ����, ���[ya]������ ������ [P] �� ������ ������.")
					if("Tajara", "Vulpkanin", "Flatland Zorren", "Highlander Zorren")
						message = pick(" ��������[ya] �� ����� [P], ����������[ya] [P.identifying_gender==FEMALE ? "�" : "���"] � ��������[ya] ���� �� ������� � ������� [P.identifying_gender==FEMALE ? "��" : "���"] � ������.", " ������� [P] � �������� �����.", " ���������� ������ [P] �� ���� ����.", " ������ [P] �� ������ ����[ya] ������ � ��������� �������[ya] �����.", " ��� �������� [P], ��������[ya] ����� [P.identifying_gender == FEMALE ? "������ �������" : "������� ������"] � �����.", " ��������� ���������[ya] ������� [P].", ", ���� ������ ����, ���[ya]������ ������ [P] �� ������ ������.")
					if("Vox", "Nevrean")
						message = pick(" ��������[ya] �� ����� [P], ����������[ya] [P.identifying_gender==FEMALE ? "�" : "���"] � ��������[ya] ���� �� ������� � ������� [P.identifying_gender==FEMALE ? "��" : "���"] � ������.", " ������� [P] ��[ya]�� � ����.", " ���������� ������ [P] �� ���� ����, �����[ya]�� �� ���������[ya] � ������� �� �����.", " ������ [P] �� ������ ����[ya] ������ � ��������� �������[ya] �����.", " ������� ����[ya] �� ������ [P], ��������[ya] ����� ������ ������ � ���.", " ��������� ���������[ya] ������� [P].", ", ���� ������ ����, ���[ya]������ ������ [P] �� ������ ������.")
					if("Promethean")
						message = pick(" ��������[ya] �� ������������ ����� [P], ����������[ya] [P.identifying_gender==FEMALE ? "�" : "���"] � ��������[ya] ���� �� ������� � ������� [P.identifying_gender==FEMALE ? "��" : "���"] � ������.", " ������� [P] � ���, ���[ya]����[ya] ���� ���� � ������ �����.", " ���������� ������ [P] �� ���� ����.", " ������ [P] �� ������ ����[ya] ������ � ��������� �������[ya] �����.", " ���������� ����� [P.identifying_gender == FEMALE ? "������ �����������" : "������� �����[ya]"] � ���.", " ��������� ���������[ya] ������� [P].", ", ���������� ���������, ������ ������ ���� ��� [P] � ������ �� ��������� ��������.", " ������� �������� ������ [P].")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick(" ������������ ������������ ���� ���� [P] � ������.")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && H.stat != DEAD)
				H.visible_message("<font color=purple><B>[H][message]</B></font>")
				H.lust += 15
			else
				H.visible_message("<font color=purple>[H][message]</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H][message]</font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 15
			if (H.lust >= H.resistenza)
				H.cum(H, P, "mouth")
				timeofact = world.time
				message = pick("������� [P] � ���.", "������[ya] � ���� [P], �����[ya]�� ����� ����� �������, �� ������������[ya].", "������������� ���[ya] �� ���� [P].", "������� �� ���.", "�������� �� [ya]����� [P].")
				H.visible_message("<B>[H]</B> [message]")
				playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 70, 1, frequency = get_age_pitch())
				H.lust = 0
				H.druggy = 30

			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/oral[rand(1, 2)].ogg", 70, 1, -1)
			if (P.species.name == "Promethean")
				playsound(loc, "honk/sound/interactions/champ[rand(1, 2)].ogg", 50, 1, -1)
			if (prob(H.potenzia))
				P.oxyloss += 3
				H.visible_message("<B>[P]</B> [pick("������[ya] ������������ <B>[H]</B>", "���������[ya]", "�������[ya] � ������� ������")].")
				if (istype(P.loc, /obj/structure/closet))
					P.visible_message("<B>[P]</B> [pick("������[ya] ������������ <B>[H]</B>", "���������[ya]", "�������[ya] � ������� ������")].")


		if("mount")

			message = pick("������ �� ����� [P]", "������� �� ����������� [P]", "�����������[ya] �� [P]")
			if (prob(35))
				message = pick("������� ���� [P], ������ ���������", "������ �� ������ [P]", "������� �� [P], ����[ya][ya]�� � ��� ����", "�������� ������������, �������[ya][ya] ������������ ���� � [P]", "�������� ����� � [P] � ������, ����� ��� ���� ������", "������� ����� ��-�����, ���[ya] �� ����������� [P]", "���������� �����������[ya] �� [P], ��[ya]� ������ ��� ����", "����������� ��� ���� �� ������ [P], ���[ya] �� ���� ����� �����", "�������� ������ ���[ya] ������� [P]")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("��������� �����������[ya] �� ������� ����� [P]", "�������[ya]�� ���� [P] � ���� ������� �����, ������[ya] ���� �����", "�������� ������ � ���[ya] ����� [P]")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message].</B></font>")
				P.lust += H.potenzia * 2
			else
				H.visible_message("<font color=purple>[H] [message].</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message].</font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += P.potenzia
			if (H.lust >= H.resistenza)
				H.cum(H, P)
				H.lust = 0
				message = pick("�� ����������, ��� ����������� ����� [H] �������� ����� ����������[ya] ������ ������ �����������.", "�� ����������, ��� ��������� ������ [H] ������ ������� ��� ����[ya]����� ����.", "�� ����������, ��� ������[ya] ����� [H] ����� ������� ��� ���� ������ ���[ya].", "�� ����������, ��� ������ ������� ���������[ya] ����� ������ ���[ya]��� ������� [H].", "�� ����������, ��� ����� ������ ������[ya]������ ������ [H] ������ ��������[ya] ��������� ���, ��������[ya] ��� � �������.")
				to_chat(P, message)
				P.lust += 15
			else
				H.moan()
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += H.potenzia
				if (P.lust >= P.resistenza)
					P.cum(P, H, "vagina")
					timeofact = world.time
					message = pick("������� � [H]", "����� ���[ya]������ ���� �� [H], � ����� �������� �� ���.", "��������� � [H] ��������� ���, ����� ����������[ya]. ������ �������� �������� �� ���� [H].")
					P.visible_message("<B>[P]</B> [message]")
					playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 70, 1, frequency = get_age_pitch())
					P.lust = 0
					P.druggy = 30
				else
					P.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/bang[rand(1, 3)].ogg", 70, 1, -1)
			if (H.species.name == "Promethean")
				playsound(loc, "honk/sound/interactions/champ[rand(1, 2)].ogg", 50, 1, -1)

		if("rub")

			message = pick("����[ya] � ���� [P]", "����[ya] �� ���������� [P]", "����������� ���� [P] ����� ������")
			if (prob(35))
				message = pick("������ �������� ������ �� ����� [P] � ���� ���������", "�������� ������ [P], ������ ���������� �����", "� ���������� ����� ��������� �������, ������[ya] ������ � ���� [P]", "������� ������� �����, �������� � ������ [P.identifying_gender==FEMALE ? "��������" : "�������"], �������[ya][ya] ������������ ���� � [P]", "�������� ����� � [P] � ������", "������� ����� ��-�����, ������� ���������[ya] ���������� [P]", "����� �������� ����� [P] ����� ������� ���, ������[ya] ���� �����", "��� ������ [P] �� �����, ���[ya] �� ���� ����� �����", "����������� ������ � ������� [P]")

			if (H.lastfucked != P || H.lfhole != hole)
				message = pick("��������� ������[ya] ������������ �� ������� �����, �������[ya] ��� � ������ [P]", "������������ ���� [P] ����� � ��������� � ������ [P.identifying_gender==FEMALE ? "��������" : "�������"], ����� ���� ������[ya] ������� �������� �� �����", "�������� ������[ya] �� [P] � �������� ��� ���� ����� ����� ������� ���")
				H.lastfucked = P
				H.lfhole = hole

			if (prob(5) && P.stat != DEAD)
				H.visible_message("<font color=purple><B>[H] [message].</B></font>")
				P.lust += H.potenzia * 2
			else
				H.visible_message("<font color=purple>[H] [message].</font>")
			if (istype(P.loc, /obj/structure/closet))
				P.visible_message("<font color=purple>[H] [message].</font>")
				playsound(P.loc.loc, 'sound/effects/clang.ogg', 50, 0, 0)
			H.lust += 9
			if (H.lust >= H.resistenza)
				H.cum(H, P)
				H.lust = 0
			else
				H.moan()
			if (P.stat != DEAD && P.stat != UNCONSCIOUS)
				P.lust += 10
				if (P.lust >= P.resistenza)
					P.cum(P, H, "vagina")
					timeofact = world.time
					message = pick("������� ���� �� �����.", "������[ya] �� ����� [H], �����[ya]�� ����� ����� �������, �� ������������[ya].", "������������� ���[ya] �� ������ [H].", "������[ya]�� ������� ����� ������ [H] ���[ya]��� �������.")
					P.visible_message("<B>[P]</B> [message]")
					playsound(loc, "honk/sound/interactions/final_m[rand(1, 5)].ogg", 70, 1, frequency = get_age_pitch())
					P.lust = 0
					P.druggy = 30
				else
					P.moan()
			H.do_fucking_animation(P)
			playsound(loc, "honk/sound/interactions/champ_fingering.ogg", 50, 1, -1)

mob/living/carbon/human/proc/moan()
	var/ya = "&#255;"
	var/mob/living/carbon/human/H = src
	switch(species.name)
		if("Human", "Skrell", "Vatborn", "Custom Species", "Rapala", "Vasilissan", "Akula", "Promethean", "Tajara", "Vulpkanin", "Sergal", "Flatland Zorren", "Highlander Zorren")
			if (prob(H.lust / H.resistenza * 65))
				var/message = pick("�����������", "������ �� �����������[ya]", "���������� �����", "���������� ����", "�������� �����������[ya]")
				H.visible_message("<B>[H]</B> [message].")
				var/g = H.gender == FEMALE ? "f" : "m"
				var/moan = rand(1, 7)
				if (moan == lastmoan)
					moan--
				if(!istype(loc, /obj/structure/closet))
					playsound(loc, "honk/sound/interactions/moan_[g][moan].ogg", 70, 1, frequency = get_age_pitch())
				else if (g == "f")
					playsound(loc, "honk/sound/interactions/under_moan_f[rand(1, 4)].ogg", 70, 1, frequency = get_age_pitch())
				lastmoan = moan

				if (istype(H.head, /obj/item/clothing/head/kitty)  || istype(H.head, /obj/item/clothing/head/collectable/kitty))
					playsound(loc, "honk/sound/interactions/purr_f[rand(1, 3)].ogg", 70, 1, 0)
/*
		if("Tajara")
			if (prob(H.lust / src.resistenza * 70))
				var/message = pick("��������", "�������� �� �����������[ya]", "���������� �����", "�������� �����������[ya]")
				H.visible_message("<B>[H]</B> [message].")
				playsound(loc, "honk/sound/interactions/purr[rand(1, 3)].ogg", 70, 1, frequency = get_age_pitch())

		if("Vulpkanin", "Sergal", "Flatland Zorren", "Highlander Zorren")
			if (prob(H.lust / src.resistenza * 70))
				var/message = pick("�����������", "����������� �� �����������[ya]", "���������� �����", "�������� �����������[ya]")
				H.visible_message("<B>[H]</B> [message].")
*/
		if("Unathi")
			if (prob(H.lust / H.resistenza * 70))
				var/message = pick("�������� �����", "���������[ya] �� �����������[ya]")
				H.visible_message("<B>[H]</B> [message].")

		if("Teshari", "Vox", "Nevrean")
			if (prob(H.lust / H.resistenza * 70))
				var/message = pick("�������� ���������", "���������[ya] �� �����������[ya]")
				H.visible_message("<B>[H]</B> [message].")


mob/living/carbon/human/proc/handle_lust()
	lust -= 4
	if (lust <= 0)
		lust = 0
		lastfucked = null
		lfhole = ""
		multiorgasms = 0
	if (lust == 0)
		erpcooldown -= 1
	if (erpcooldown < 0)
		erpcooldown = 0

/mob/living/carbon/human/proc/do_fucking_animation(mob/living/carbon/human/P)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = get_dir(src, P)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)

/obj/item/weapon/enlarger
	name = "penis enlarger"
	desc = "Very special DNA mixture which helps YOU to enlarge your little captain."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"
	item_state = "dnainjector"
	hitsound = null
	throwforce = 0
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("stabbed")

/obj/item/weapon/enlarger/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(istype(M, /mob/living/carbon/human) && (M.gender == MALE))
		M.potenzia = 30
		to_chat(user, "<span class='warning'>Your penis extends!</span>")

	else if (istype(M, /mob/living/carbon/human) && M.gender == FEMALE)
		to_chat(user, "<span class='warning'>It didn't affect you since you're female!</span>")

	..()

	qdel(src)

/obj/item/weapon/enlarger/attack_self(mob/user as mob)
	to_chat(user, "<span class='warning'>You break the syringe. Gooey mass is dripping on the floor.</span>")
	qdel(src)

/obj/item/weapon/dildo
	name = "dildo"
	desc = "Hm-m-m, deal thow"
	icon = 'honk/icons/obj/items/dildo.dmi'
	icon_state = "dildo"
	item_state = "c_tube"
	throwforce = 0
	force = 10
	w_class = 1
	throw_speed = 3
	throw_range = 15
	attack_verb = list("slammed", "bashed", "whipped")
	var/hole = "vagina" //or "anus"
	var/rus_name = "�����"
	var/ya = "&#255;"
	var/pleasure = 10

/obj/item/weapon/dildo/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	var/hasvagina = (M.gender == FEMALE && M.species.genitals && M.species.name != "Unathi" && M.species.name != "Stok")
	var/hasanus = M.species.anus
	var/message = ""

	if(istype(M, /mob/living/carbon/human) && user.zone_sel.selecting == "groin" && M.is_nude())
		if (hole == "vagina" && hasvagina)
			if (user == M)
				message = pick("����������[ya]�� ���[ya] � ������� [rus_name]", "����������� � ���[ya] [rus_name]", "��������� [rus_name] � ���� ����")
			else
				message = pick("����������[ya]�� [M] � ������� [rus_name]", "����������� � [M] [rus_name]", "��������� [rus_name] � ���� [M]")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<font color=purple><B>[user] [message].</B></font>")
				M.lust += pleasure * 2

			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<font color=purple>[user] [message].</font>")
				M.lust += pleasure

			if (M.lust >= M.resistenza)
				M.cum(M, user, "floor")
			else
				M.moan()

			user.do_fucking_animation(M)
			playsound(loc, "honk/sound/interactions/bang[rand(4, 6)].ogg", 70, 1, -1)

		else if (hole == "anus" && hasanus)
			if (user == M)
				message = pick("����������[ya]�� ���[ya] ������� � ������� [rus_name]", "����������� [rus_name] ���� � ����", "������ ���� �������, ��������[ya] [rus_name]")
			else
				message = pick("����������[ya]�� [M] ������� � ������� [rus_name]", "����������� [rus_name] [M] � ����", "������ ������� [M], ��������[ya] [rus_name]")

			if (prob(5) && M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<font color=purple><B>[user] [message].</B></font>")
				M.lust += pleasure * 2

			else if (M.stat != DEAD && M.stat != UNCONSCIOUS)
				user.visible_message("<font color=purple>[user] [message].</font>")
				M.lust += pleasure

			if (M.lust >= M.resistenza)
				M.cum(M, user, "floor")
			else
				M.moan()

			user.do_fucking_animation(M)
			playsound(loc, "honk/sound/interactions/bang[rand(4, 6)].ogg", 70, 1, -1)

		else
			..()
	else
		..()

/obj/item/weapon/dildo/attack_self(mob/user as mob)
	if(hole == "vagina")
		hole = "anus"
	else
		hole = "vagina"
	to_chat(user, "<span class='warning'>Hm-m-m. Maybe we should put it in [hole]?!</span>")
