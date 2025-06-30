const http = require("node:http");
const { Client, GatewayIntentBits } = require("discord.js");
const { port, token, guildId, roleId } = require("./config.json");

async function main() {
	const client = new Client({ intents: [] });
	await client.login(token);

	const guild = await client.guilds.fetch(guildId);
	if (!guild) {
		console.error("ERROR in config, unable to resolve guild " + guildId);
		return;
	}

	const role = await guild.roles.fetch(roleId);
	if (!role) {
		console.error("ERROR in config, invalid role ID ", roleId);
		return;
	}

	const server = http.createServer({}, (req, res) => {
		const url = req.url;
		if (!url) {
			res.writeHead(400, { 'Content-Type': 'application/json' });
			res.end(JSON.stringify({ data: "error parsing URL" }))
			return;
		}

		let urlObj;
		try {
			urlObj = new URL(`http://localhost${url}`);
		} catch (err) {
			res.writeHead(400, { 'Content-Type': 'application/json' });
			res.end(JSON.stringify({ data: "error parsing URL: " + err }))
			return;
		}
		if (!urlObj.search) {
			res.writeHead(400, { 'Content-Type': 'application/json' });
			res.end(JSON.stringify({ data: "error parsing URL" }))
			return;
		}

		const params = urlObj.searchParams;
		const member_id = params.get("member");

		if (!member_id) {
			res.writeHead(400, { 'Content-Type': 'application/json' });
			res.end(JSON.stringify({ data: "error parsing URL" }))
			return;
		}

		let memberIdRaw;
		try {
			memberIdRaw = JSON.parse(member_id);
		} catch(err) {
			res.writeHead(400, { 'Content-Type': 'application/json' });
			res.end(JSON.stringify({ data: "error parsing URL: " + err }))
			return;
		}

		guild.members.addRole({ user: memberIdRaw, role, reason: "SS13 Registration" })
		console.log("Successfully registered ", memberIdRaw);

		res.writeHead(200, { 'Content-Type': 'application/json' });
		res.end(JSON.stringify({ data: "success" }))
	});

	server.listen(port);
	console.log("Server running on port", port);
}

main();
