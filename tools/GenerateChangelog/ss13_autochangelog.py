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

validPrefixes = [
    'bugfix',
    'wip',
    'tweak',
    'soundadd',
    'sounddel',
    'rscdel',
    'rscadd',
    'imageadd',
    'imagedel',
    'maptweak',
    'spellcheck',
    'experiment'
]

incltag = False
new_logs = []
author = pr_author
new = 0

# Parse PR body for changelog entries
print('Reading changelogs...')
for line in pr_body.splitlines():
	if line[0:4] == ":cl:": # Find the start of the changelog
		if incltag == True: # If we're already reading logs, skip
			continue
		incltag = True
		
		# Fetch the author name
		author = line[5:]
		author.strip()
		
		if !(author.len):
			author = pr_author
		
		if !(new_logs[author].len):
			new_logs[author] = [] # Make array entry for the author
	
	# If we hit a /cl, we're no longer reading logs
	elif line[0:4] == "/:cl":
		incltag = False

	# If we aren't reading logs, we don't care about any other line contents
	if !incltag:
		continue
		
	# Split line into tag (icon) and body (comment)
	body = re.split(" ,:-", line, 1)
	tag = body[0]
	body = body[1]
	
	# If the tag is invalid, just default to rscadd
	if tag not in validPrefixes:
		tag = "rscadd"
		body = line
	
	# Strip special characters (mostly leading ones, for cases where the tag/body delimiter is multi-character)
	body.strip(" ,-:\t\n")
	
	new_logs[author] += '  - {tag}: "{body}"'
	new++

print("Writing {new} new changelog entries.")

for auth in new_logs:
	# Sanitize authors without changes
	if !new_logs[auth].len:
		new_logs.remove(auth)
	
	open(os.path.join(args.target_dir, auth, args.pr_numb, '.yml'), 'w') as f
	f.write('author: {auth}\n')
	f.write('delete-after: True\n')
	f.write('changes:\n')
	for log in new_logs[auth]:
		f.write('{log}\n')
	f.close()
