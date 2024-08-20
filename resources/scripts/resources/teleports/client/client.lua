local Config = Zen.Config.Teleports

for i = 1, #Config do
    local point = lib.points.new(Config[i][2], 3, { text = Config[i][1], from = Config[i][2], to = Config[i][3] })

    function point:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            SetEntityCoords(cache.ped, self.to.x, self.to.y, self.to.z, false, false, false, false)
        end

        Zen.Functions.FloatText(self.from, '[E] - '..self.text)
    end
end