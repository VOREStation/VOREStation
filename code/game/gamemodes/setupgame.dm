/////////////////////////
// (mostly) DNA2 SETUP
/////////////////////////

// Traitgenes Setup genetics using traits as a foundation for each gene. Basically making genetics automagic instead of something that needs to be maintained...
/proc/setupgenetics(var/list/trait_list)
	if(!trait_list)
		return
	var/list/blocks_remaining = list()
	var/I = 0
	while(++I < DNA_SE_LENGTH)
		blocks_remaining.Add(I)
		assigned_blocks[I] = "" // setup a clean list
	for(var/TI in trait_list)
		var/datum/trait/T = trait_list[TI]
		if(T.is_genetrait)
			if(blocks_remaining.len <= 0)
				CRASH("DNA2: Ran out of usable blocks! DNA_SE_LENGTH limit is [DNA_SE_LENGTH]. Raise it if you need more!")
			// Init
			var/datum/gene/trait/G = new /datum/gene/trait()
			G.block = pick(blocks_remaining)
			var/tex = uppertext(T.name)
			G.name = "[copytext(tex,1,min( 8, length(tex)+1 ))]:[G.block]"
			T.linked_gene = G
			G.linked_trait = T
			dna_activity_bounds[G.block]=T.activity_bounds
			// Handle global block data
			log_world("DNA2: Assigned [G.name] - Linked to trait [T.name].")
			assigned_blocks[G.block]=G.name
			GLOB.trait_to_dna_genes[T.type] = G
			GLOB.dna_genes.Add(G)
			blocks_remaining.Remove(G.block)
			// Add traitgenes to good/bad gene lists for randomized mutation procs!
			if(istype(T,/datum/trait/neutral))
				GLOB.dna_genes_neutral.Add(G)
			else if(istype(T,/datum/trait/negative))
				GLOB.dna_genes_bad.Add(G)
			else
				GLOB.dna_genes_good.Add(G)
	log_world("DNA2: Created traitgenes with [blocks_remaining.len] remaining blocks. Used [DNA_SE_LENGTH - blocks_remaining.len] out of [DNA_SE_LENGTH] ")
	if(blocks_remaining.len < 10)
		warning("DNA2: Blocks remaining is less than 10. The DNA_SE_LENGTH should be raised in dna.dm.")
	// Run conflict-o-tron on each traitgene all other traits... Lets setup an initial database of conflicts.
	// Any remaining conflicts will be handled by the conflict-o-tron midround using a quicker scan flag
	log_world("DNA2: Checking trait gene conflicts")
	var/list/compare_list = list()
	for(var/datum/gene/trait/gene in GLOB.dna_genes) // was orginally all_traits, but having 300 entry lists for 50 genes at launch was pointless. the caches will fill as characters spawn with traits instead... A small tradeoff
		if(gene.linked_trait)
			compare_list.Add(gene.linked_trait.type)
	for(var/datum/gene/trait/gene in GLOB.dna_genes)
		gene.has_conflict( compare_list, FALSE )
	log_world("DNA2: Initial Conflict summary")
	// Future coders: Don't worry, has_conflict() is run whenever a traitgene tries to enable itself as well, and adds to the trait conflict lists in each gene...
	// This is to setup the initial segments for the gene editing machines to sort gene segments with.
	for(var/datum/gene/trait/gene in GLOB.dna_genes)
		if(gene.conflict_traits.len)
			var/summery = ""
			for(var/path in gene.conflict_traits)
				if(gene.conflict_traits[path]) // check if it actually conflicts
					var/datum/trait/T = all_traits[path]
					if(summery != "")
						summery += ", "
					summery += "[T.name]"
			log_world("DNA2: [gene.get_name()] - ([summery])")
