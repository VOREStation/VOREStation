import os
import psutil
import subprocess
import sys

maps = []

# Terminate old server process
print("INFO: Terminating old server instance...")
try:
    if(sys.platform == "win32"):
        process = "dreamdaemon.exe"
    elif(sys.platform == "linux"):
        process = "DreamDaemon"

    for proc in psutil.process_iter():
        if proc.name() == process:
            proc.kill()
except Exception as err:
    print("WARN: Unable to terminate server process! Server might not be running:\n" + err.with_traceback)

# Get all maps that can be chosen in the rotation
with open("config/map_rotation.txt", "r") as f:
    lines = f.readlines()
    for line in lines:
        if os.path.isdir('maps/' + line.rstrip()):
            maps.append(line.rstrip())
        else:
            print("WARN: Invalid Map: " + line.rstrip() + ". Ignoring.")
    f.close()

# Get map chosen by vote/automatic rotation/admin verb
try:
    with open("data/map.txt", "r") as f:
        new_map = f.readline().rstrip()
        f.close()
except FileNotFoundError as err:
    print("WARN: data/map.txt does not exist yet. Defaulting to first config/map_rotation.txt entry...")
    new_map = lines[0].rstrip()

# Load environment file into memory and current map with new one
# Warning, the map from rotation which is *currently* played on, might break this script
try:
    for map in maps:
        with open("vorestation.dme", "rt") as fin:
            with open("vorestation.dme.temp", "wt") as fout:
                for line in fin:
                    fout.write(line.replace('\"maps\\' + map + '\\' + map + '.dm\"', '\"maps\\' + new_map + '\\' + new_map + '.dm\"'))

        os.remove("vorestation.dme")
        os.rename("vorestation.dme.temp", "vorestation.dme")

    if(sys.platform == "win32"):
        subprocess.call(["C:\\Program Files (x86)\\BYOND\\bin\\dm.exe", "vorestation.dme"])
    elif(sys.platform == "linux"):
        subprocess.call(["DreamMaker", "vorestation.dme"])
except FileNotFoundError as err:
    print("ERR:" + err.filename + "could not be found!")
    exit()

# Boot up the Server again
try:
    print("INFO: Starting new server instance...")
    if(sys.platform == "win32"):
        DETACHED_PROCESS = 8
        subprocess.Popen("C:\\Program Files (x86)\\BYOND\\bin\\dreamdaemon.exe .\\vorestation.dmb -trusted", creationflags=DETACHED_PROCESS, close_fds=True)
    elif(sys.platform == "linux"):
        subprocess.Popen("DreamDaemon vorestation.dmb -trusted", close_fds=True)
except Exception as err:
    print("ERR: Unable to start server process:\n" + err)