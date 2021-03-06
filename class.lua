require "character"
require "bbox"


------------------------ BUFF -----------------------------

Buff = function(name, character, ...) --Recebe o nome, ponteiro para o pai e os parametros do buff especifico
    local tab = {}
    tab.arg = arg
    tab.character = character
    local foo
    local timer
    local args
    foo, timer, args = dofile('buff/' .. name .. '.lua') -- Retorna uma função "buff.run", recebebe self(com o ponteiro para o character e os argumentos) e dt (para buffs com timers)
    tab.run = foo
    tab.timer = timer
    tab.args = args
    return tab
end


------------------------ EFFECT ---------------------------

Effect = function(onHit, duration, style, ...)
    local tab = {arg = arg}
    tab.style = style
    tab.lifeTime = duration
    if (style == 'circle') then
        -- PARAMETERS FOR CIRCLE STYLE :
        local x = arg[1]
        local y = arg[2]
        local velx = arg[3]
        local vely = arg[4]
        local ratio = arg[5]
        tab.x = x
        tab.y = y
        tab.velx = velx
        tab.vely = vely
        tab.ratio = ratio
        function draw(self, stage)
            love.graphics.circle( 'fill', self.x + stage.x, self.y + stage.y , self.ratio )
        end
        tab.draw = draw
        if(onHit) then
            tab.onHitName = onHit
            tab.onHit = function(self, character)
                local t = {}  -- Apenas os argumentos a partir do 5 são para o "onHit", pois circle exige 5 argumentos
                for i = 6, #self.arg do
                    t[i - 5] = self.arg[i]
                end
                return Buff(self.onHitName, character, t)
            end
        end
        tab.update = function(self, dt)
            self.x = self.x + self.velx *dt
            self.y = self.y + self.vely *dt
            self.lifeTime = self.lifeTime - dt
        end
    else
        return 'Non supported style type'
    end
    return tab
end

------------------------ SPELL ----------------------------

Spell = function(name)
    --Returns a table with the function "run".
    local cooldown
    local foo
    local delay
    foo, cooldown, delay = dofile('spell/' .. name .. '.lua') --Returns a spell... function(self, character, stage, dt, mousex, mousey)
    local tab = {}
    tab.run = foo
    tab.cooldown = cooldown
    return tab
end

------------------------ OBJECT ----------------------------

Obj = function(...)
    local tabx = {}
    local taby = {}
    for i = 1 , #arg, 2 do
        tabx[((i+1)/2)] = arg[i]
        taby[((i+1)/2)] = arg[i+1]
    end
    local tab = {
        vx = tabx,
        vy = taby,
        draw = function(self, stage)
            local t = {}
            for i = 1, #self.vx do
                t[(i*2)-1] = self.vx[i] + stage.x
                t[i*2] = self.vy[i] + stage.y
            end
            love.graphics.polygon('line', t)
        end
    }
    tab.bb = Bbox(tab)
    return tab
end

------------------------ STAGE -----------------------------

Stage = function ()
    local tab = {
            x = 0,
            y = 0,
            w = 800,
            h = 600,
            g = 800,
            character = {},
            objs = {},
            effects = {},
            background = nil,
            loadStage = function (self, file)
                self.x, self.y, self.w, self.h, self.g, self.objs, self.background = dofile('stage/' .. file .. '.lua')
            end
    }
    return tab
end

------------------------ HUD -----------------------------

HUD = function ( file )
    local tab = {
            x = 0,
            y = 0,
            w = 800,
            h = 600,
            characterStat = {},
            img = nil
    }
    tab.x, tab.y, tab.w, tab.h, tab.characterStat, tab.img = dofile('hud/' .. file .. '.lua')
    return tab
end


