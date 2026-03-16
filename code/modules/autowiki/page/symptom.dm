/datum/autowiki/symptom
	page = "Template:Autowiki/Content/Symptoms"

/datum/autowiki/symptom/generate()
	var/output = ""

	var/list/template_list = list()

	for(var/the_symptom in subtypesof(/datum/symptom))
		var/datum/symptom/symptom = new the_symptom

		if(symptom.level < 0) // Skip base/admin symptoms
			continue

		template_list["name"] = escape_value(symptom.name)
		template_list["stealth"] = symptom.stealth
		template_list["resistance"] = symptom.resistance
		template_list["speed"] = symptom.stage_speed
		template_list["transmission"] = symptom.transmission
		template_list["level"] = symptom.level
		template_list["effect"] = escape_value(symptom.desc)
		template_list["thresholds"] = length(symptom.threshold_descs) ? generate_thresholds(symptom.threshold_descs) : "None"

		output += include_template("Autowiki/SymptomTemplate", template_list)

	return include_template("Autowiki/SymptomTableTemplate", list("content" = output))

/datum/autowiki/symptom/proc/generate_thresholds(var/list/thresholds)
	var/compiled_thresholds = ""

	for(var/threshold in thresholds)
		var/description = thresholds[threshold]
		if(length(threshold))
			compiled_thresholds += "<li><b>[threshold]:</b> [description]</li>"

	return compiled_thresholds
