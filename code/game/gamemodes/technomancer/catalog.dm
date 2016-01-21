var/list/all_technomancer_spells = typesof(/datum/power/technomancer) - /datum/power/technomancer
var/list/all_technomancer_equipment = typesof(/datum/technomancer_equipment/equipment) - /datum/technomancer_equipment/equipment
var/list/all_technomancer_consumables = typesof(/datum/technomancer_equipment/consumable) - /datum/technomancer_equipment/consumable
var/list/all_technomancer_assistance = typesof(/datum/technomancer_equipment/assistance) - /datum/technomancer_equipment/assistance
var/list/all_technomancer_presets = typesof(/datum/technomancer_equipment/presets) - /datum/technomancer_equipment/presets

/datum/power/technomancer/
	name = "technomancer function"
	desc = "If you can see this, something broke."
	var/cost = 100
	var/hidden = 0

/obj/item/weapon/technomancer_catalog
	name = "catalog"
	desc = "A \"book\" featuring a holographic display, metal cover, and miniaturized teleportation device, allowing the user to \
	requisition various things from.. where ever they came from."
	icon = 'icons/obj/storage.dmi'
	icon_state ="scientology" //placeholder
	w_class = 2
	var/budget = 1000
	var/max_budget = 1000
	var/mob/living/carbon/human/owner = null
	var/list/spell_instances = list()
	var/list/equipment_instances = list()
	var/list/consumable_instances = list()
	var/list/assistance_instances = list()
	var/list/preset_instances = list()
	var/tab = 0

/obj/item/weapon/technomancer_catalog/apprentice
	name = "apprentice's catelog"
	budget = 700
	max_budget = 700

/obj/item/weapon/technomancer_catalog/master //for badmins, I suppose
	name = "master's catelog"
	budget = 2000
	max_budget = 2000

/obj/item/weapon/technomancer_catalog/proc/bind_to_owner(var/mob/living/carbon/human/new_owner)
	if(!owner && technomancers.is_antagonist(new_owner.mind))
		owner = new_owner

/obj/item/weapon/technomancer_catalog/New()
	..()
	set_up()

/obj/item/weapon/technomancer_catalog/proc/set_up()
	if(!spell_instances.len)
		for(var/S in all_technomancer_spells)
			spell_instances += new S()
	if(!equipment_instances.len)
		for(var/E in all_technomancer_equipment)
			equipment_instances += new E()
	if(!consumable_instances.len)
		for(var/C in all_technomancer_consumables)
			consumable_instances += new C()
	if(!assistance_instances.len)
		for(var/A in all_technomancer_assistance)
			assistance_instances += new A()
	if(!preset_instances.len)
		for(var/P in all_technomancer_presets)
			preset_instances += new P()

/obj/item/weapon/technomancer_catalog/attack_self(mob/user)
	if(!user)
		return 0
	if(owner && user != owner)
		user << "<span class='danger'>\The [src] knows that you're not the original owner, and has locked you out of it!</span>"
		return 0
	else if(!owner)
		bind_to_owner(user)

	switch(tab)
		if(0) //Functions
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><b>Functions</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=4'>Presets</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/power/technomancer/spell in spell_instances)
				if(spell.hidden)
					continue
				dat += "<b>[spell.name]</b><br>"
				dat += "<i>[spell.desc]</i><br>"
				if(spell.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];spell_choice=[spell.name]'>Purchase</a> ([spell.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			dat += "<a href='byond://?src=\ref[src];refund_functions=1'>Refund Functions</a>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")
		if(1) //Equipment
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<b>Equipment</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=4'>Presets</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer_equipment/equipment/E in equipment_instances)
				dat += "<b>[E.name]</b><br>"
				dat += "<i>[E.desc]</i><br>"
				if(E.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];spell_choice=[E.name]'>Purchase</a> ([E.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")
		if(2) //Consumables
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<b>Consumables</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=4'>Presets</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer_equipment/consumable/C in consumable_instances)
				dat += "<b>[C.name]</b><br>"
				dat += "<i>[C.desc]</i><br>"
				if(C.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];spell_choice=[C.name]'>Purchase</a> ([C.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")
		if(3) //Assistance
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<b>Assistance</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=4'>Presets</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer_equipment/assistance/A in assistance_instances)
				dat += "<b>[A.name]</b><br>"
				dat += "<i>[A.desc]</i><br>"
				if(A.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];spell_choice=[A.name]'>Purchase</a> ([A.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")
		if(4) //Presets
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a> | "
			dat += "<b>Presets</b></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer_equipment/presets/P in preset_instances)
				dat += "<b>[P.name]</b><br>"
				dat += "<i>[P.desc]</i><br>"
				if(P.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];spell_choice=[P.name]'>Purchase</a> ([P.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			user << browse(dat, "window=radio")
			onclose(user, "radio")

/obj/item/weapon/technomancer_catalog/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/H = usr

	if(H.stat || H.restrained())
		return
	if(!istype(H, /mob/living/carbon/human))
		return 1 //why does this return 1?

	if(H != owner)
		H << "\The [src] won't allow you to do that, as you don't own \the [src]!"
		return

	if(loc == H || (in_range(src, H) && istype(loc, /turf)))
		H.set_machine(src)
		if(href_list["tab_choice"])
			tab = text2num(href_list["tab_choice"])
		if(href_list["spell_choice"])
			var/datum/power/technomancer/new_spell = null
			//Locate the spell.
			for(var/datum/power/technomancer/spell in spell_instances)
				if(spell.name == href_list["spell_choice"])
					new_spell = spell
					break
			if(new_spell)
				if(new_spell.cost <= budget)
					budget -= new_spell.cost
					H << "<span class='notice'>You have just bought [new_spell.name].</span>"
				else
					H << "<span class='danger'>You can't afford that!</span>"
					return
		attack_self(H)