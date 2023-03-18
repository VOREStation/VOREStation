import os
import json

def scan_whitelist():
    whitelist_dict = {}
    path = "../data/player_saves"
   for subdir in os.listdir(path):
        path = f"../data/player_saves/{subdir}"
        if not os.path.isdir(path):
            continue
        for player_dir in os.listdir(path):
            whitelist_file = f"{path}/{player_dir}/whitelist.json"
            print(f"Opening {whitelist_file}")
            if not os.path.exists(whitelist_file):
                continue
            with open(whitelist_file) as contents:
                if os.path.getsize(whitelist_file) == 1:
                    continue
                whitelist_dict[player_dir] = []
                for key in json.load(contents):
                    whitelist_dict[player_dir].append(translate_key(key))
    return whitelist_dict

def translate_key(key):
    if key == "/datum/language/tajsign":
        return "Alai"
    if key == "/datum/language/skrell":
        return "Common Skrellian"
    if key == "/datum/language/skrellfar":
        return "High Skrellian"
    if key == "/datum/species/diona":
        return "Diona"
    if key == "/datum/species/shapeshifter/promethean":
        return "Promethean"
    if key == "/datum/language/teshari":
        return "Schechi"
    if key == "/datum/language/tajaran":
        return "Siik"
    if key == "/datum/language/unathi":
        return "Sinta'Unathi"
    if key == "/datum/species/skrell":
        return "Skrell"
    if key == "/datum/language/human":
        return "Sol Common"
    if key == "/datum/species/tajaran":
        return "Tajara"
    if key == "/datum/species/teshari":
        return "Teshari"
    if key == "/datum/species/unathi":
        return "Unathi"
    if key == "/datum/species/zaddat":
        return "Zaddat"
    if key == "/whitelist/genemod":
        return "Genemods"
    if key == "/datum/species/vox":
        return "Vox"
    if key == "/datum/language/zaddat":
        return "Vedahq"

new_dict = scan_whitelist()
print(new_dict)
with open("../config/whitelists.json", "w") as whitelist:
    whitelist.write(json.dumps(new_dict, indent=4))
