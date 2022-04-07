// All maps that are available for the rotation
/var/list/map_rotation = list()

// Variables for rotation logic
var/map_round_count = 0

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
            map_round_count += text2num(line)

/proc/update_rotation_data()
    fdel("data/rotation.txt")
    text2file(num2text(map_round_count), "data/rotation.txt")

// Check if we met the requirements, choose to automatically rotate or vote, depending on configuration
/proc/check_due()
    if (map_round_count > config.rotate_after_round)
        log_misc("Map rotation due! [map_round_count]/[config.rotate_after_round] rounds since past rotation.")

        if (config.map_rotation_mode == 1) // Mode: Voting
            SSvote.autorotation()
        else if (config.map_rotation_mode == 2) // Mode: Automatic
            // TODO: Actually choose new map, not the one that was currently played
            rotate_map()

// This launches the rotation script
/proc/rotate_map()
    map_round_count = 0
    update_rotation_data()
    shell("python ./scripts/rotate_map.py")