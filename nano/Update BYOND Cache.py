#!/usr/bin/python3
# Setup
import os, json, shutil, glob, platform

if(platform.system() != "Windows"):
    print("Error: This script doesn't work on anything but Windows. How are you even planning to develop BYOND off windows?")
    exit()

cdir = (os.getcwd())
if(cdir[-4:] != "nano"):
    print("This script must be run from the nano directory.")
    exit()

def find_cache():
    target = os.path.join(os.path.expanduser("~"), "Documents", "BYOND", "cache")
    for root, dirs, files in os.walk(target):
        if "nano_templates_bundle.js" in files:
            return root

cache = find_cache()
if cache == None:
    print("Failed to find BYOND Cache.")
    exit()

# Send all of the random files to the cache
def send_to_cache(arrayOfFiles):
    for file in arrayOfFiles:
        target = os.path.join(cache, os.path.split(file)[1])
        shutil.copyfile(file, target)

send_to_cache([os.path.join(cdir, "css", f) for f in os.listdir(os.path.join(cdir, "css")) if os.path.isfile(os.path.join(cdir, "css", f))])
send_to_cache([os.path.join(cdir, "images", f) for f in os.listdir(os.path.join(cdir, "images")) if os.path.isfile(os.path.join(cdir, "images", f))])
send_to_cache([os.path.join(cdir, "js", f) for f in os.listdir(os.path.join(cdir, "js")) if os.path.isfile(os.path.join(cdir, "js", f))])

# Handle creating the tmpl bundle
arrOfFiles = glob.glob(os.path.join(cdir,  "templates", "*.tmpl"))

tmpl_bundle_header = "function nanouiTemplateBundle(){return "
tmpl_bundle_footer = ";}"

big_json_array = {}

for file in arrOfFiles:
    tmpl_name = os.path.split(file)[1]
    with open(file, 'r') as tmpl:
        big_json_array[tmpl_name] = tmpl.read()

tmpl_bundle = tmpl_bundle_header + json.dumps(big_json_array) + tmpl_bundle_footer

# Send the tmpl bundle to the cache
with open(os.path.join(cache, "nano_templates_bundle.js"), "w") as templateBundleFile:
    templateBundleFile.write(tmpl_bundle)
    templateBundleFile.close()