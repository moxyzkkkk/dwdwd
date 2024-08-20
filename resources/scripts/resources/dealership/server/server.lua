lib.callback.register('vehicleshop:buy', function(source, props, type, price, job, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	local success = false

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		
		Zen.Functions.LogToDiscord(Zen.Webhooks['dealership'], 'Player Bought Vehicle', Zen.Functions.Admin.LogFormats({ admin = source }, true)..'\n**Price:** $'..Zen.Functions.FormatCommas(price)..'\n**Vehicle:** '..label)
		MySQL.insert.await('INSERT INTO `owned_vehicles` (identifier, vehicle, plate, label, type, job) VALUES (?, ?, ?, ?, ?, ?)', { xPlayer.identifier, json.encode(props), props.plate, label, type, (job and xPlayer.job.name or nil)})
		success = true
	else
		Zen.Functions.Notify(source, 'You Dont Have Enough Money!', 'dollar', '#FF0000')
	end

	return success
end)