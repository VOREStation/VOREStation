// All maps that are available for the rotation
/var/list/map_rotation = list()

// Variables for rotation logic
var/map_round_count = 0
var/rotation_due = FALSE
var/rotation_overridden = FALSE

// Loads the rotation maps and the rotation logic data
/hook/startup/proc/loadMapRotation()
    load_rotation_maps()
    load_map_rotation_data()
    return 1

// Loads all maps available for the rotation
/proc/load_rotation_maps()
    var/text = file2text("config/map_rotation.txt")
    if (!text)
        log_misc("Failed to load config/map_rotation.txt")
    else
        var/lines = splittext(text, "\n")
        for(var/line in lines)
            var/list/our_rotation = map_rotation[line]
            if(!our_rotation)
                our_rotation = list()
                map_rotation[line] = our_rotation
            our_rotation += line

// Loads all variables for rotation logic
/proc/load_map_rotation_data()
    var/text = file2text("data/rotation.txt")
    if (!text)
        log_misc("Failed to load data/rotation.txt")
        update_rotation_data()
    else
        var/lines = splittext(text, "\n")
        for(var/line in lines)
            map_round_count += text2num(lines[1])
            rotation_overridden += text2num(lines[2])
            rotation_due += text2num(lines[3])

// Update the persistent rotation data (How many rounds passed, if the current rotation cycle was overridden)
/proc/update_rotation_data()
    fdel("data/rotation.txt")
    text2file(num2text(map_round_count), "data/rotation.txt")
    text2file(num2text(rotation_overridden), "data/rotation.txt")
    text2file(num2text(rotation_due), "data/rotation.txt")

// Check if we met the requirements, choose to automatically rotate or vote, depending on configuration
/proc/check_due()
    if (config.rotation_schedule_mode == 0 && (map_round_count > config.rotate_after_round))
        log_misc("Map rotation due! [map_round_count]/[config.rotate_after_round] rounds since past rotation.")

        if (!rotation_overridden)
            if (config.map_rotation_mode == 1) // Mode: Voting
                log_misc("Launching map vote.")
                SSvote.autorotation()

            else if (config.map_rotation_mode == 2) // Mode: Automatic
                log_misc("Choosing next map in rotation automatically.")
                var/current_map = get_map()

                for(var/i=1, i<=map_rotation.len, i++)
                    if (current_map == map_rotation[i])
                        if ((i + 1) > map_rotation.len)
                            set_map(map_rotation[1])
                        else
                            set_map(map_rotation[i+1])
        return TRUE
    
    else if (config.rotation_schedule_mode == 1 && config.rotate_after_day == time2text(world.timeofday,"Day",0))
        if (map_round_count < 6) // Prevent it to rotate it multiple times, just because its the specified day.
            return FALSE

        log_misc("Map rotation due! It is [config.rotate_after_day].")
        
        if (!rotation_overridden)
            if (config.map_rotation_mode == 1) // Mode: Voting
                log_misc("Launching map vote.")
                SSvote.autorotation()
            else if (config.map_rotation_mode == 2) // Mode: Automatic
                log_misc("Choosing next map in rotation automatically.")
                var/current_map = get_map()

                for(var/i=1, i<=map_rotation.len, i++)
                    if (current_map == map_rotation[i])
                        if ((i + 1) > map_rotation.len)
                            set_map(map_rotation[1])
                        else
                            set_map(map_rotation[i+1])

        return TRUE

    return FALSE

// Set the map for the current rotation
/proc/set_map(map, force)
    if(!map)
        return

    if (!rotation_overridden || force)
        fdel("data/map.txt")
        text2file(map, "data/map.txt")

// Get map name that is currently in rotation
/proc/get_map()
    var/text = file2text("data/map.txt")
    if (!text)
        log_misc("Failed to load data/map.txt! Defaulting to first config/map_rotation.txt entry...")
        return map_rotation[1]
    else
        var/lines = splittext(text, "\n")
        for(var/line in lines)
            return lines[1]

// This launches the rotation script
/proc/rotate_map()
    map_round_count = 0
    rotation_overridden = FALSE
    update_rotation_data()
    //shell("python ./scripts/rotate_map.py")