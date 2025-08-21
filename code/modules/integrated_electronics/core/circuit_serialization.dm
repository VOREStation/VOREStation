/**
 * Serialization/Deserialization for Integrated Circuits
 *
 * These functions handle converting assemblies to JSON format for export/import
 */
// Common prefixes that can be stripped to reduce JSON size
#define ASSEMBLY_PREFIX "/obj/item/electronic_assembly/"
#define CIRCUIT_PREFIX "/obj/item/integrated_circuit/"

/**
 * Strips the common assembly prefix to reduce JSON size
 * @param	type_path The full assembly type path
 * @return	The shortened path without the common prefix
 */
/proc/strip_assembly_prefix(type_path)
	if(!type_path)
		return ""
	var/type_string = "[type_path]"
	if(findtext(type_string, ASSEMBLY_PREFIX) == 1)
		return copytext(type_string, length(ASSEMBLY_PREFIX) + 1)
	return type_string  // Return as-is if prefix not found (for backward compatibility)

/**
 * Strips the common circuit prefix to reduce JSON size
 * @param	type_path The full circuit type path
 * @return	The shortened path without the common prefix
 */
/proc/strip_circuit_prefix(type_path)
	if(!type_path)
		return ""
	var/type_string = "[type_path]"
	if(findtext(type_string, CIRCUIT_PREFIX) == 1)
		return copytext(type_string, length(CIRCUIT_PREFIX) + 1)
	return type_string  // Return as-is if prefix not found (for backward compatibility)

/**
 * Restores the full assembly path from a shortened one
 * @param	shortened_path The shortened assembly path
 * @return	The full assembly type path
 */
/proc/restore_assembly_prefix(shortened_path)
	if(!shortened_path)
		return ""
	var/path_string = "[shortened_path]"
	// If it already contains the full path, return as-is (backward compatibility)
	if(findtext(path_string, "/obj/item/electronic_assembly/") == 1)
		return path_string
	// Otherwise, add the prefix
	return ASSEMBLY_PREFIX + path_string

/**
 * Restores the full circuit path from a shortened one
 * @param	shortened_path The shortened circuit path
 * @return	The full circuit type path
 */
/proc/restore_circuit_prefix(shortened_path)
	if(!shortened_path)
		return ""
	var/path_string = "[shortened_path]"
	// If it already contains the full path, return as-is (backward compatibility)
	if(findtext(path_string, "/obj/item/integrated_circuit/") == 1)
		return path_string
	// Otherwise, add the prefix
	return CIRCUIT_PREFIX + path_string

/**
 * Serializes an electronic assembly into a JSON string
 *
 * @param	assembly The electronic assembly to serialize
 * @return	JSON string representation of the assembly
 */
/proc/serialize_electronic_assembly(obj/item/electronic_assembly/assembly)
	if(!istype(assembly))
		return "Invalid assembly"

	var/list/assembly_data = list(
		"n" = assembly.name,                    // Shortened: name
		"d" = assembly.desc,                    // Shortened: desc
		"t" = strip_assembly_prefix("[assembly.type]"),  // Shortened: type (strip common prefix)
		"c" = assembly.detail_color,           // Shortened: color
		"components" = list(),                  // Keep full name for clarity
		"connections" = list()                  // Keep full name for clarity
	)

	// Create a lookup table for component indices
	var/list/component_indices = list()
	var/component_index = 1

	// First pass: serialize components and build index lookup
	for(var/obj/item/integrated_circuit/IC in assembly.contents)
		component_indices[REF(IC)] = component_index

		var/list/component_data = list(
			"i" = component_index,  // Shortened key: index
			"t" = strip_circuit_prefix("[IC.type]")  // Shortened key: type (strip common prefix)
		)

		// Only include custom name if it differs from the default
		if(IC.displayed_name != IC.name)
			component_data["n"] = IC.displayed_name  // Shortened key: name

		// Include position data if available
		for(var/list/pos_data in assembly.component_positions)
			if(pos_data["ref"] == REF(IC))
				component_data["x"] = pos_data["x"]  // x position
				component_data["y"] = pos_data["y"]  // y position
				break

		// Serialize pin data that has non-null values (both inputs and outputs)
		var/list/pin_data_list = list()

		// Serialize input pins
		for(var/i = 1, i <= length(IC.inputs), i++)
			var/datum/integrated_io/input_pin = IC.inputs[i]
			if(input_pin.data != null)
				var/pin_data = null
				// Handle different data types appropriately
				if(isnum(input_pin.data) || istext(input_pin.data))
					pin_data = input_pin.data
				else if(islist(input_pin.data))
					var/list/original_list = input_pin.data
					pin_data = list()
					for(var/item in original_list)
						pin_data += item
				else
					pin_data = "[input_pin.data]" // Convert other types to text

				// Store pin type, index and data
				pin_data_list += list(list("t" = "i", "i" = i, "d" = pin_data))

		// Serialize output pins
		for(var/i = 1, i <= length(IC.outputs), i++)
			var/datum/integrated_io/output_pin = IC.outputs[i]
			if(output_pin.data != null)
				var/pin_data = null
				// Handle different data types appropriately
				if(isnum(output_pin.data) || istext(output_pin.data))
					pin_data = output_pin.data
				else if(islist(output_pin.data))
					var/list/original_list = output_pin.data
					pin_data = list()
					for(var/item in original_list)
						pin_data += item
				else
					pin_data = "[output_pin.data]" // Convert other types to text

				// Store pin type, index and data
				pin_data_list += list(list("t" = "o", "i" = i, "d" = pin_data))

		// Only include pins if there's actual data
		if(length(pin_data_list) > 0)
			component_data["p"] = pin_data_list  // Shortened key: pins (inputs and outputs)

		assembly_data["components"] += list(component_data)
		component_index++

	// Second pass: serialize connections using the component indices (avoid duplicates by only processing outputs)
	var/list/recorded_connections = list()  // Track connections to avoid duplicates

	for(var/obj/item/integrated_circuit/IC in assembly.contents)
		var/source_component_index = component_indices[REF(IC)]

		// Check output connections (only process outputs to avoid duplicates)
		for(var/i = 1, i <= IC.outputs.len, i++)
			var/datum/integrated_io/output_pin = IC.outputs[i]
			for(var/datum/integrated_io/linked_pin in output_pin.linked)
				var/target_component_index = component_indices[REF(linked_pin.holder)]
				if(target_component_index)
					var/target_pin_type = "u"  // u = unknown
					var/target_pin_index = 0

					if(linked_pin in linked_pin.holder.inputs)
						target_pin_type = "i"  // i = input
						target_pin_index = linked_pin.holder.inputs.Find(linked_pin)
					else if(linked_pin in linked_pin.holder.outputs)
						target_pin_type = "o"  // o = output
						target_pin_index = linked_pin.holder.outputs.Find(linked_pin)
					else if(linked_pin in linked_pin.holder.activators)
						target_pin_type = "a"  // a = activator
						target_pin_index = linked_pin.holder.activators.Find(linked_pin)

					if(target_pin_index > 0)
						// Create unique connection identifier to prevent duplicates
						var/connection_id = "[source_component_index].o[i]->[target_component_index].[target_pin_type][target_pin_index]"

						if(!(connection_id in recorded_connections))
							recorded_connections += connection_id

							// Ultra-compact connection format: [sc, spt, spi, tc, tpt, tpi]
							var/list/connection = list(
								"sc" = source_component_index,     // source_component -> sc
								"spt" = "o",                       // source_pin_type -> spt (always "o" for output)
								"spi" = i,                         // source_pin_index -> spi
								"tc" = target_component_index,     // target_component -> tc
								"tpt" = target_pin_type,           // target_pin_type -> tpt
								"tpi" = target_pin_index           // target_pin_index -> tpi
							)
							assembly_data["connections"] += list(connection)

		// Check activator connections
		for(var/i = 1, i <= IC.activators.len, i++)
			var/datum/integrated_io/activate/activator_pin = IC.activators[i]
			for(var/datum/integrated_io/linked_pin in activator_pin.linked)
				var/target_component_index = component_indices[REF(linked_pin.holder)]
				if(target_component_index)
					var/target_pin_type = "u"  // u = unknown
					var/target_pin_index = 0

					if(linked_pin in linked_pin.holder.inputs)
						target_pin_type = "i"  // i = input
						target_pin_index = linked_pin.holder.inputs.Find(linked_pin)
					else if(linked_pin in linked_pin.holder.outputs)
						target_pin_type = "o"  // o = output
						target_pin_index = linked_pin.holder.outputs.Find(linked_pin)
					else if(linked_pin in linked_pin.holder.activators)
						target_pin_type = "a"  // a = activator
						target_pin_index = linked_pin.holder.activators.Find(linked_pin)

					if(target_pin_index > 0)
						// Create unique connection identifier to prevent duplicates
						var/connection_id = "[source_component_index].a[i]->[target_component_index].[target_pin_type][target_pin_index]"

						if(!(connection_id in recorded_connections))
							recorded_connections += connection_id

							// Ultra-compact connection format: [sc, spt, spi, tc, tpt, tpi]
							var/list/connection = list(
								"sc" = source_component_index,     // source_component -> sc
								"spt" = "a",                       // source_pin_type -> spt (always "a" for activator)
								"spi" = i,                         // source_pin_index -> spi
								"tc" = target_component_index,     // target_component -> tc
								"tpt" = target_pin_type,           // target_pin_type -> tpt
								"tpi" = target_pin_index           // target_pin_index -> tpi
							)
							assembly_data["connections"] += list(connection)

	return json_encode(assembly_data)

/**
 * Deserializes a JSON string into a list of components to add to an assembly
 *
 * @param	json_data The JSON string to deserialize
 * @return	List of information needed to recreate the assembly
 */
/proc/deserialize_electronic_assembly(json_data)
	if(!json_data)
		return null

	// Add safety check for maximum size
	if(length(json_data) > 50000)
		return null

	// Safety check for minimum viable JSON
	if(length(json_data) < 10)
		return null

	if(copytext(json_data, 1, 2) != "{" || copytext(json_data, length(json_data)) != "}")
		return null

	var/list/assembly_data
	try
		// Use built-in html_decode to handle all HTML entities
		var/cleaned_json = html_decode(json_data)

		assembly_data = json_decode(cleaned_json)
	catch
		return null

	if(!assembly_data || !islist(assembly_data))
		return null

	// Validate required fields exist
	if(!assembly_data["components"] || !islist(assembly_data["components"]))
		return null

	return assembly_data

/**
 * Creates an electronic assembly from deserialized data
 *
 * @param	assembly_data The deserialized assembly data
 * @param	override_type Whether to override the assembly type
 * @param	custom_type Custom assembly type path if overriding
 * @return	The created assembly or null if failed
 */
/proc/create_assembly_from_data(list/assembly_data, override_type = FALSE, custom_type = null)
	if(!assembly_data || !islist(assembly_data))
		return null

	var/obj/item/electronic_assembly/assembly

	// Determine assembly type
	if(override_type && custom_type)
		var/custom_path = text2path(custom_type)
		if(custom_path && ispath(custom_path, /obj/item/electronic_assembly))
			assembly = new custom_path()

	// Use original assembly type if not overriding (use shortened key "t" for type)
	if(!assembly && assembly_data["t"])
		var/restored_path = restore_assembly_prefix(assembly_data["t"])
		var/original_path = text2path(restored_path)
		if(original_path && ispath(original_path, /obj/item/electronic_assembly))
			assembly = new original_path()

	// Default to medium assembly
	if(!assembly)
		assembly = new /obj/item/electronic_assembly/medium()

	// Set basic properties (use shortened keys)
	if(assembly_data["n"])  // "n" for name
		assembly.name = assembly_data["n"]
	if(assembly_data["d"])  // "d" for desc
		assembly.desc = assembly_data["d"]
	if(assembly_data["c"])  // "c" for color
		assembly.detail_color = assembly_data["c"]

	// Open assembly for component insertion
	assembly.opened = TRUE

	return assembly

/**
 * Adds components to an assembly from deserialized data
 *
 * @param	assembly The assembly to add components to
 * @param	assembly_data The deserialized assembly data
 * @param	available_components List of component types available for creation
 * @return	List of created components indexed by their original index
 */
/proc/add_components_to_assembly(obj/item/electronic_assembly/assembly, list/assembly_data, list/available_components)
	if(!assembly || !assembly_data || !assembly_data["components"])
		return null

	var/list/created_components = list()
	var/list/components_list = assembly_data["components"]

	// Create each component
	var/component_index = 0
	for(var/component_data in components_list)
		component_index++

		if(!islist(component_data))
			continue

		// Use shortened keys: "t" for type, "i" for index
		if(!component_data["t"] || !component_data["i"])
			continue

		var/restored_type_path = restore_circuit_prefix(component_data["t"])
		var/component_type_path = text2path(restored_type_path)
		if(!component_type_path || !ispath(component_type_path, /obj/item/integrated_circuit))
			continue

		if(available_components && !(component_type_path in available_components))
			continue

		var/obj/item/integrated_circuit/IC = new component_type_path()

		if(component_data["n"])
			IC.displayed_name = component_data["n"]

		// Set pin data - use shortened key "p" for pins (both inputs and outputs)
		if(component_data["p"] && islist(component_data["p"]))
			for(var/list/pin_data in component_data["p"])
				// Only support ultra-compact format with pin type indicators
				var/pin_type = pin_data["t"]  // Pin type: "i" = input, "o" = output
				var/pin_index = pin_data["i"]  // Pin index
				var/pin_value = pin_data["d"]  // Pin data

				if(!pin_type || !pin_index || pin_value == null)
					continue

				var/datum/integrated_io/target_pin = null

				if(pin_type == "i")
					if(pin_index <= length(IC.inputs))
						target_pin = IC.inputs[pin_index]
				else if(pin_type == "o")
					if(pin_index <= length(IC.outputs))
						target_pin = IC.outputs[pin_index]
				else
					continue

				if(target_pin)
					target_pin.write_data_to_pin(pin_value)

		// Add component to assembly
		IC.forceMove(assembly)
		assembly.force_add_circuit(IC)

		// Store position data if available
		if(component_data["x"] != null && component_data["y"] != null)
			// Store position in assembly for later UI restoration
			assembly.component_positions += list(list(
				"ref" = REF(IC),
				"x" = component_data["x"],
				"y" = component_data["y"]
			))
		else
			// Set default positions in a grid layout if no position data
			var/default_x = ((component_index - 1) % 4) * 200 + 50  // 4 components per row, 200px apart
			var/default_y = ((component_index - 1) / 4) * 150 + 50  // 150px between rows
			assembly.component_positions += list(list(
				"ref" = REF(IC),
				"x" = default_x,
				"y" = default_y
			))

		// Store component by its original index for wiring
		created_components["[component_data["i"]]"] = IC

	return created_components

/**
 * Restores wiring connections between components (ultra-compact format only)
 *
 * @param	assembly_data The deserialized assembly data
 * @param	created_components List of created components indexed by original index
 */
/proc/restore_component_wiring(list/assembly_data, list/created_components)
	if(!assembly_data["connections"] || !islist(assembly_data["connections"]))
		return

	for(var/connection in assembly_data["connections"])
		if(!connection || !islist(connection))
			continue

		// Support both old and new connection formats
		var/source_comp_index, source_pin_type, source_pin_index
		var/target_comp_index, target_pin_type, target_pin_index

		// Try ultra-compact format first (new format)
		if(connection["sc"])
			source_comp_index = connection["sc"]        // source_component
			source_pin_type = connection["spt"]         // source_pin_type
			source_pin_index = connection["spi"]        // source_pin_index
			target_comp_index = connection["tc"]        // target_component
			target_pin_type = connection["tpt"]         // target_pin_type
			target_pin_index = connection["tpi"]        // target_pin_index

		if(!source_comp_index || !target_comp_index || !source_pin_index || !target_pin_index)
			continue

		var/source_key = "[source_comp_index]"
		var/target_key = "[target_comp_index]"

		var/obj/item/integrated_circuit/source_IC = created_components[source_key]
		var/obj/item/integrated_circuit/target_IC = created_components[target_key]

		if(!source_IC || !target_IC)
			continue

		var/datum/integrated_io/source_pin
		var/datum/integrated_io/target_pin

		// Get the appropriate pin based on single-letter type
		switch(source_pin_type)
			if("i")
				if(source_pin_index <= source_IC.inputs.len)
					source_pin = source_IC.inputs[source_pin_index]
			if("o")
				if(source_pin_index <= source_IC.outputs.len)
					source_pin = source_IC.outputs[source_pin_index]
			if("a")
				if(source_pin_index <= source_IC.activators.len)
					source_pin = source_IC.activators[source_pin_index]

		switch(target_pin_type)
			if("i")
				if(target_pin_index <= target_IC.inputs.len)
					target_pin = target_IC.inputs[target_pin_index]
			if("o")
				if(target_pin_index <= target_IC.outputs.len)
					target_pin = target_IC.outputs[target_pin_index]
			if("a")
				if(target_pin_index <= target_IC.activators.len)
					target_pin = target_IC.activators[target_pin_index]

		if(source_pin && target_pin)
			// Allow multiple outputs to connect to the same input
			// Only prevent truly identical connections (same source pin to same target pin)
			var/connection_exists = FALSE

			// Check if this exact pin-to-pin connection already exists
			if(target_pin in source_pin.linked)
				connection_exists = TRUE

			if(!connection_exists)
				source_pin.linked |= target_pin
				target_pin.linked |= source_pin
