/datum/event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0

/datum/event/money_lotto/start()
	winner_sum = pick(5000, 10000, 50000, 100000, 500000, 1000000, 1500000)
	if(all_money_accounts.len)
		var/datum/money_account/D = pick(all_money_accounts)
		winner_name = D.owner_name
		if(!D.suspended)
			D.money += winner_sum

			var/datum/transaction/T = new()
			T.target_name = "The [using_map.starsys_name] Times Grand Slam -Stellar- Lottery"
			T.purpose = "Winner!"
			T.amount = winner_sum
			T.date = current_date_string
			T.time = stationtime2text()
			T.source_terminal = "Sif TCD Terminal #[rand(111,333)]"
			D.transaction_log.Add(T)

			deposit_success = 1

/datum/event/money_lotto/announce()
	var/author = "[using_map.company_name] Editor"
	var/channel = "The [using_map.starsys_name] Times"

	var/body = "The [using_map.starsys_name] Times wishes to congratulate <b>[winner_name]</b> for receiving the [using_map.starsys_name] Stellar Slam Lottery, and receiving the out of this world sum of [winner_sum] credits!"
	if(!deposit_success)
		body += "<br>Unfortunately, we were unable to verify the account details provided, so we were unable to transfer the money. Send a cheque containing the sum of 5000 Thalers to ND 'Stellar Slam' office on the The [using_map.starsys_name] Times gateway containing updated details, and your winnings'll be re-sent within the month."

	news_network.SubmitArticle(body, author, channel, null, 1)
