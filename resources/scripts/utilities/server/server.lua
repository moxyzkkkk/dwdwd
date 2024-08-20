local scopes = {}

AddEventHandler("playerEnteredScope", function(data)
    local playerEntering, player = data["player"], data["for"]

    if not scopes[player] then
        scopes[player] = {}
    end

    scopes[player][playerEntering] = true
end)

AddEventHandler("playerLeftScope", function(data)
    local playerLeaving, player = data["player"], data["for"]

    if not scopes[player] then return end
    scopes[player][playerLeaving] = nil
end)

AddEventHandler("playerDropped", function()
    local intSource = source
        
    if not intSource then return end

    scopes[intSource] = nil

    for owner, tbl in pairs(scopes) do
        if tbl[intSource] then
            tbl[intSource] = nil
        end
    end
end)

function GetPlayerScope(intSource)
    return scopes[tostring(intSource)]
end