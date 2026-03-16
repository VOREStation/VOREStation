input_file = 'config/alienwhitelist.txt'
output_file = 'whitelist.sql'
table_name = 'whitelist'

with open(input_file, 'r', encoding='utf-8') as infile, \
    open(output_file, 'w', encoding='utf-8') as outfile:
    for line in infile:
        line = line.strip()
        if not line:
            continue
        if "#" in line:
            print(f"Skipping commented line: {line}")
            continue
        # Split on ' - ', expecting exactly two parts
        parts = line.split(' - ')
        if len(parts) != 2:
            print(f"Skipping invalid line: {line}")
            continue
        username, entry = (p.replace("'", "''") for p in parts)  # Escape single quotes
        kind = "species"
        sql = (
            f"INSERT INTO {table_name} (ckey, entry, kind) "
            f"VALUES ('{username}', '{entry}', '{kind}');\n"
        )
        outfile.write(sql)

input_file = 'config/jobwhitelist.txt'

with open(input_file, 'r', encoding='utf-8') as infile, \
    open(output_file, 'a', encoding='utf-8') as outfile:
    for line in infile:
        line = line.strip()
        if not line:
            continue
        if "#" in line:
            print(f"Skipping commented line: {line}")
            continue
        # Split on ' - ', expecting exactly two parts
        parts = line.split(' - ')
        if len(parts) != 2:
            print(f"Skipping invalid line: {line}")
            continue
        username, entry = (p.replace("'", "''") for p in parts)  # Escape single quotes
        kind = "job"
        sql = (
            f"INSERT INTO {table_name} (ckey, entry, kind) "
            f"VALUES ('{username}', '{entry}', '{kind}');\n"
        )
        outfile.write(sql)
