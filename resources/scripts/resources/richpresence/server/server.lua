lib.callback.register('richpresence:online', function(source)
    return GetNumPlayerIndices(), GetConvar('sv_maxClients', '32') 
end)