//Used to create the gene mask. Shamelessly stolen from the plant controller and cut down.

/client/proc/show_xenobio_genes()
	set category = "Debug"
	set name = "Show Xenobio Genes"
	set desc = "Prints the round's plant xenobio masks."

	if(!holder)	return

	if(!GLOB.xenobio_controller || !GLOB.xenobio_controller.gene_tag_masks)
		to_chat(usr, "Gene masks not set.")
		return

	for(var/mask in GLOB.xenobio_controller.gene_tag_masks)
		to_chat(usr, "[mask]: [GLOB.xenobio_controller.gene_tag_masks[mask]]")

GLOBAL_DATUM(xenobio_controller, /datum/controller/xenobio)

/datum/controller/xenobio

	var/list/gene_tag_masks = list()        // Gene obfuscation for delicious trial and error goodness.

/datum/controller/xenobio/New()
	if(GLOB.xenobio_controller && GLOB.xenobio_controller != src)
		log_runtime("Rebuilding xenobio controller.")
		qdel(GLOB.xenobio_controller)
	GLOB.xenobio_controller = src
	setup()


/datum/controller/xenobio/proc/setup()

	var/list/used_masks = list()
	var/list/xenobio_traits = ALL_XENO_GENES
	while(xenobio_traits && xenobio_traits.len)
		var/gene_tag = pick(xenobio_traits)
		var/gene_mask = "[uppertext(num2hex(rand(0,255), 2))]"

		while(gene_mask in used_masks)
			gene_mask = "[uppertext(num2hex(rand(0,255), 2))]"

		used_masks += gene_mask
		xenobio_traits -= gene_tag
		gene_tag_masks[gene_tag] = gene_mask
