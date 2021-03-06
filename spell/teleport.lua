local cooldown = 1
local delay = 0
local foo = function(self, character, stage, dt, mousex, mousey)
    if(self.cooldown < 0) then
        self.cooldown = 0
    end
    if(self.cooldown == 0) then
        if(stage.effects['teleport']) then
            character:move( stage, stage.effects['teleport'].x - character.x, stage.effects['teleport'].y - character.y)
            stage.effects['teleport'] = nil
            self.cooldown = 2
        else
            local unix, uniy = mousex - character.x, mousey - character.y
            stage.effects['teleport'] = Effect(nil, 1, 'circle', character.x+5, character.y, unix * 5, uniy * 5, 5)
        end
        self.cooldown = 0.3
    end
end

return foo, cooldown, delay
