'''
Usage:
    $ python ss13_autochangelog.py [--dry-run] html/changelogs [PR_number] [PR_author] [PR_Body]

ss13_autochangelog.py - Generate changelog YAML files from pull request.
'''

from __future__ import print_function
import os, sys, re, time, argparse
from datetime import datetime, date
from time import time

today = date.today()

dateformat = "%d %B %Y"

opt = argparse.ArgumentParser()
opt.add_argument('target_dir', help='The location to write changelog files to.')
opt.add_argument('pr_numb', help='The number of the pull request.')
opt.add_argument('pr_author', help='The author of the pull request. If specific authors aren\'t specified, the PR author will be used')
opt.add_argument('pr_body', help='The body of the pull request to parse for changelogs.')

args = opt.parse_args()

all_changelog_entries = {}

validPrefixes = {
    "fix": 'bugfix',
	"fixes": 'bugfix',
	"bugfix": 'bugfix',
    "wip": 'wip',
    "tweak": 'tweak',
	"tweaks": 'tweak',
	"rsctweak": 'tweak',
    "soundadd": 'soundadd',
    "sounddel": 'sounddel',
    "add": 'rscadd',
    "adds": 'rscadd',
	"rscadd": 'rscadd',
    "del": 'rscdel',
	"dels": 'rscdel',
	"delete": 'rscdel',
	"deletes": 'rscdel',
	"rscdeldel": 'rscdel',
	"imageadd": 'imageadd',
    "imagedel": 'imagedel',
    "maptweak": 'maptweak',
	"remap": 'maptweak',
	"remaps": 'maptweak',
    "typo": 'spellcheck',
	"spellcheck": 'spellcheck',
    "experimental": 'experiment',
	"experiments": 'experiment',
	"experiment": 'experiment'
}

incltag = False
new_logs = {}
author = args.pr_author
new = 0

# Parse PR body for changelog entries
print('Reading changelogs...')
for line in args.pr_body.splitlines():
	print(f"Checking line '{line}'")
	if line[:1] == "🆑": # Find the start of the changelog
		print("Found opening :cl: tag")
		if incltag == True: # If we're already reading logs, skip
			continue
		incltag = True

		# Fetch the author name
		author = line[1:]
		author.strip()

		if not len(author):
			author = args.pr_author

		if author not in new_logs:
			new_logs[author] = [] # Make array entry for the author
		continue

	# If we hit a /cl, we're no longer reading logs
	elif line == "/🆑":
		print("Found closing /:cl: tag")
		incltag = False

	# If we aren't reading logs, we don't care about any other line contents
	if not incltag:
		continue

	# Split line into tag (icon) and body (comment)
	body = re.split("[ ,:-]", line, 1)
	if len(body) != 2:
		continue # If there's just one word, then it can't really be a changelog, now can it

	if body[0] in validPrefixes:
		tag = validPrefixes[body[0]]
		body = body[1].strip(" ,-:\t\n")
	else: # If the tag is invalid, just default to rscadd
		tag = "rscadd"
		body = line.strip(" ,-:\t\n")

	new_logs[author].append(f"  - {tag}: \"{body}\"")
	new += 1

print(f"Writing {new} new changelog entries.") # f supposedly formats new into the var

for auth in new_logs:
	# Sanitize authors without changes
	if not len(new_logs[auth]):
		continue

	f = open(os.path.join(args.target_dir, f"{auth}{args.pr_numb}.yml"), 'w')
	print(f"Writing changes to {f}")
	f.write(f'author: {auth}\n')
	f.write('delete-after: True\n')
	f.write('changes:\n')
	for log in new_logs[auth]:
		f.write(f'{log}\n')
	f.close()
