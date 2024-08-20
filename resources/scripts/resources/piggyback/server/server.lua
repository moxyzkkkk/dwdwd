local piggybacking = {}
local beingPiggybacked = {}

RegisterNetEvent("piggyback:sync", function(targetSrc)
	local source = source
	TriggerClientEvent("piggyback:sync", targetSrc, source)
	piggybacking[source] = targetSrc
	beingPiggybacked[targetSrc] = source
end)

RegisterNetEvent("piggyback:stop", function(targetSrc)
	local source = source
	if piggybacking[source] then
		TriggerClientEvent("piggyback:stop", targetSrc)
		piggybacking[source] = nil
		beingPiggybacked[targetSrc] = nil
	elseif beingPiggybacked[source] then
		TriggerClientEvent("piggyback:stop", beingPiggybacked[source])
		beingPiggybacked[source] = nil
		piggybacking[source] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if piggybacking[source] then
		TriggerClientEvent("piggyback:stop", piggybacking[source])
		beingPiggybacked[piggybacking[source]] = nil piggybacking[source] = nil
	end

	if beingPiggybacked[source] then
		TriggerClientEvent("piggyback:stop", beingPiggybacked[source])
		piggybacking[beingPiggybacked[source]] = nil beingPiggybacked[source] = nil
	end
end)
