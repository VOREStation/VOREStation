
/* //VORESTATION REMOVAL
/datum/lore/codex/category/main_corp_regs // The top-level categories for SOP/Regs/Law/etc
	name = "Index"
	data = "This book is meant to act as a reference for both NanoTrasen regulations, Standard Operating Procedure, and important laws of both \
	the Sif Governmental Authority and the Solar Confederate Government. The legal interactions between Nanotrasen corporate policy and VGA/SolGov \
	law can make for some confusing legalese.  This book was written by the Vir division of NanoTrasen in order for employees, visitors, and residents \
	at NanoTrasen installations such as the Northen Star and the Southen Cross to know what isn't allowed, without needing to be a lawyer to read it.\
	<br><br>\
	In this book, there are two different types of rules.  Corporate Regulations, and Laws.  They each cover specific situations, and are both enforced \
	by the Security team.  Despite this, however, the punishments vary considerably for the two types.  It should also be noted that no one is above \
	these rules, not even the " + JOB_SITE_MANAGER + ".\
	<br><br>\
	Also contained inside are our Standard Operating Procedures, that all employees of NanoTrasen are expected to follow, and for the local facility's \
	Command team and Internal Affairs to enforce.\
	<br><br>\
	It should be noted that by being on-board our facility, you agree to follow the rules of Corporate Regulations. By being within VGA space, \
	you are also required to follow the laws of VirGov."
	children = list(
		/datum/lore/codex/category/standard_operating_procedures,
		/datum/lore/codex/category/corporate_regulations,
		/datum/lore/codex/category/sif_law,
		/datum/lore/codex/page/overview,
		/datum/lore/codex/page/about_corp_regs
		)

/datum/lore/codex/page/about_corp_regs
	name = "About"
	data = "This book was written and published by NanoTrasen, for use on NanoTrasen installations from within the Vir system."


// Special page which will hopefully enforce consistant formatting.
/datum/lore/codex/page/law
	var/definition = null // Short definition of the law violation.
	var/suggested_punishments = null
	var/suggested_brig_time = null
	var/suggested_fine = null
	var/notes = null
	var/mandated = FALSE // If true, changes 'suggested' to 'mandated' for punishments, used for virgov laws and some high corporate regs.

/datum/lore/codex/page/law/add_content()
	data = "<i>[definition]</i>\
	<br><br>\
	<h3>[mandated ? "Required":"Recommended"] punishment:</h3>\
	[suggested_punishments]\
	<br><br>\
	<h3>Comments:</h3>\
	[notes]"
*/
// Autogenerates a table which will resemble the traditional wiki table.
/datum/lore/codex/page/overview
	name = "Overview"
	data = "This has a table of all the corporate violations and legal crimes contained inside this book.  The 'mandated' area \
	determines the flexibility/strictness allowed in sentencing for violations/crimes."

/datum/lore/codex/page/overview/add_content()
	var/list/law_sources = list(
		/datum/lore/codex/category/corporate_minor_violations,
		/datum/lore/codex/category/corporate_major_violations,
		/datum/lore/codex/category/law_minor_violations,
		/datum/lore/codex/category/law_major_violations
		)
	var/list/table_color_headers = list("#66ffff", "#3399ff", "#ffee55", "#ff8855")
	var/list/table_color_body_even = list("#ccffff", "#66ccff", "#ffee99", "#ffaa99")
	var/list/table_color_body_odd = list("#e6ffff", "#b3e6ff", "#fff6cc", "#ffd5cc")
	spawn(2 SECONDS) // So the rest of the book can finish.
		var/HTML
		HTML += "<div align='center'>"
		var/i
		for(i = 1, i <= law_sources.len, i++)
			var/datum/lore/codex/category/C = holder.get_page_from_type(law_sources[i])
			if(C)
				HTML += "<table style='width:90% text-align:center'>"
				HTML += "<caption>[quick_link(C.name)]</caption>"
				HTML += "	<tr style='background-color:[table_color_headers[i]]'>"
				HTML += "		<th>Incident</th>"
				HTML += "		<th>Description</th>"
				HTML += "		<th>Suggested Punishment</th>"
				HTML += "		<th>Notes</th>"
				HTML += "		<th>Mandated?</th>"
				HTML += "	</tr>"

				var/j = 1 //Used to color rows differently if even or odd.
				for(var/datum/lore/codex/page/law/L in C.children)
					if(!L.name)
						continue // Probably something we don't want to see.
					HTML += "	<tr style='background-color:[j % 2 ? table_color_body_even[i] : table_color_body_odd[i]]'>"
					HTML += "		<td><b>[quick_link(L.name)]</b></td>"
					HTML += "		<td>[L.definition]</td>"
					HTML += "		<td>[L.suggested_punishments]</td>"
					HTML += "		<td>[L.notes]</td>"
					HTML += "		<td>[L.mandated ? span_red("Yes") : span_green("No")]</td>"
					HTML += "	</tr>"
					j++

			HTML += "</table>"
			HTML += "<br><br>"
		HTML += "</div>"

		data = data + HTML
		..()
