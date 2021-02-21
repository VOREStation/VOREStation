/proc/get_newspaper_header(newspaper, var/list/subjects, bgcolor)

	var/dat

	dat += "<br><table style=\"width: 100%;\">"
	dat += "<tbody><tr>"
	dat += "<td style=\"width: 100%; bgcolor='[bgcolor]';\>"
	dat += "<h1 class=\"fr-text-uppercase\" style=\"text-align: center;\">"
	dat += "<span style='font-family: \"Times New Roman\", Times, serif, -webkit-standard; font-size: 60px; text-align: center;'><strong>[newspaper]</strong></span></h1>"
	dat += "<hr>  "

	if(subjects)
		var/subject_list = jointext(subjects," - ")

		dat += "<p style=\"text-align: center;\"><strong><span style=\"font-size: 14px; font-family: Arial, Helvetica, sans-serif;\">[subject_list]</span></strong></p><hr>"
	dat += "</tr></tbody></table>"

	return dat


/proc/get_newspaper_content(header, content, author, bgcolor, picture_data)

	var/dat

	dat += "<table style=\"width: 100%; background-color: \"[bgcolor]\"; margin-right: calc(0%);\">"
	dat += "<td style=\"width: 100%;\">"
	dat += "<table style=\"width: 100%;\">"
	dat += "<td style=\"width: 100%; text-align: justify; vertical-align: middle;\">"
	dat += "<center><span style=\"font-family: Impact, Charcoal, sans-serif; font-size: 36px;\">[header]</span><span style=\"font-size: 36px;\"><br></span></center>"

	dat += "<p style=\"text-align: right;\">By <b>[author]</b></p><br>"

	if(picture_data)
		dat += "<center>[picture_data]</center>"

	dat += "</td></table>"
	dat += "<p style=\"margin-left: 40px; font-family: Arial, Helvetica, sans-serif; margin-right: 40px;\">[content]</p><br></td>"

	dat += "</table><h1 style=\"text-align: center;\"><br></h1>"

	return dat