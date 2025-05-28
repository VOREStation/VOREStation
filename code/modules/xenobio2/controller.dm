//Used to create the gene mask. Shamelessly stolen from the plant controller and cut down.

/client/proc/show_xenobio_genes()
	set category = "Debug"
	set name = "Show Xenobio Genes"
	set desc = "Prints the round's plant xenobio masks."

	if(!holder)	return

	if(!xenobio_controller || !xenobio_controller.gene_tag_masks)
		to_chat(usr, "Gene masks not set.")
		return

	for(var/mask in xenobio_controller.gene_tag_masks)
		to_chat(usr, "[mask]: [xenobio_controller.gene_tag_masks[mask]]")

var/global/datum/controller/xenobio/xenobio_controller // Set in New().

/datum/controller/xenobio

	var/list/gene_tag_masks = list()        // Gene obfuscation for delicious trial and error goodness.

/datum/controller/xenobio/New()
	if(xenobio_controller && xenobio_controller != src)
		log_debug("Rebuilding xenobio controller.")
		qdel(xenobio_controller)
	xenobio_controller = src
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
