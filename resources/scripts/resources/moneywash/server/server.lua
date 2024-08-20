RegisterNetEvent('moneywash:process', function(exchange, amount)
	local _source = source
	local player = ESX.GetPlayerFromId(_source)

	if not amount or amount <= 0 then
		Zen.Functions.Notify(_source, 'Invalid Number!', 'hashtag', '#FF0000')
	else
		local blackMoney = player.getAccount('black_money').money
		if blackMoney < amount then 
			Zen.Functions.Notify(_source, 'You Dont Have That Much Dirty!', 'dollar', '#FF0000')
		else
			local cleanMoney = amount * exchange
			player.addMoney(cleanMoney)
			player.removeAccountMoney('black_money', amount)
			Zen.Functions.LogToDiscord(Zen.Webhooks['moneywash'], 'Player Washed Money', Zen.Functions.Admin.LogFormats({ admin = source }, true)..'\n**Washed:** $'..Zen.Functions.FormatCommas(amount)..'\n**Recieved:** $'..Zen.Functions.FormatCommas(cleanMoney))
			Zen.Functions.Notify(_source, "You washed $"..Zen.Functions.FormatCommas(amount).." dirty and recieved $"..Zen.Functions.FormatCommas(cleanMoney).." clean", 'dollar', '#00FF00')
		end
	end
end)