/obj/item/organ/internal/eyes/emp_act(severity)
	if(!(robotic >= ORGAN_ASSISTED))
		return
	owner.eye_blurry += (4/severity)

/obj/item/organ/internal/cell/emp_act(severity)
	owner.nutrition = max(0, owner.nutrition - rand(10/severity, 50/severity))

/obj/item/organ/internal/mmi_holder/emp_act(severity)
	owner.adjustToxLoss(rand(6/severity, 12/severity))

