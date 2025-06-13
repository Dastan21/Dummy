--- @class Dummy.Enemy : Dummy.Class
---
--- @field protected name string
--- @field protected hp number
--- @field protected max_hp number
--- @field protected at number
--- @field protected df number
--- @field protected xp number
--- @field protected gold number
--- @field protected check Dummy.Text.Text|string[]|nil
--- @field protected x number
--- @field protected y number
--- @field protected width number
--- @field protected height number
local Enemy = Class()

--- Gets the class name
--- @return string
function Enemy:getClass()
  return "Dummy.Enemy"
end

--- Gets the enemy's name
--- @return string
function Enemy:getName()
  return self.name
end

--- Sets the enemy's name
--- @param name string
function Enemy:setName(name)
  self.name = name
end

--- Gets the enemy's HP
--- @return number
function Enemy:getHP()
  return self.hp
end

--- Sets the enemy's HP
--- @param hp number health points
function Enemy:setHP(hp)
  if type(hp) ~= "number" then return end

  self.hp = math.clamp(hp, 0, self.max_hp)
end

--- Gets the enemy's max HP
--- @return number
function Enemy:getMaxHP()
  return self.max_hp
end

--- Sets the enemy's max HP
--- @param max_hp number maximum health points
function Enemy:setMaxHP(max_hp)
  if type(max_hp) ~= "number" then return end

  self.max_hp = math.clamp(max_hp, 20, 99)
end

--- Gets the enemy's AT
--- @return number
function Enemy:getAT()
  return self.at
end

--- Sets the enemy's AT
--- @param at number attack point
function Enemy:setAT(at)
  self.at = at
end

--- Gets the enemy's DE
--- @return number
function Enemy:getDF()
  return self.df
end

--- Sets the enemy's DE
--- @param df number defense point
function Enemy:setDF(df)
  self.df = df
end

--- Wether the enemy has a check dialogue
--- @return boolean
function Enemy:hasCheck()
  return self.check ~= nil
end

--- Gets the enemy's check
--- @return string
function Enemy:getCheck()
  local check = self.check
  if type(check) == "table" then
    local t = {}
    for _, txt in ipairs(check) do
      table.insert(t, Lang.translate(txt))
    end
    return "* " .. table.concat(t, "\n* ")
  end

  return "* " .. check
end

--- Sets the enemy's check
--- @param check Dummy.Text.Text|Dummy.Text.Text[]
function Enemy:setCheck(check)
  self.check = check
end

--- Gets the computed enemy's check text
--- @return string
function Enemy:getCheckText()
  local check = "* " .. self:getName():upper() .. " - "
  check = check .. Lang.translate("ENCOUNTER_STAT_AT") .. " " .. self:getAT() .. " "
  check = check .. Lang.translate("ENCOUNTER_STAT_DF") .. " " .. self:getDF()
  check = check .. "\n" .. self:getCheck()
  return check
end

--- Gets the enemy's center position
---@return number, number
function Enemy:getPosition()
  return self.x, self.y
end

--- Sets the enemy's center position
---@param x number
---@param y number
function Enemy:setPosition(x, y)
  self.x = x
  self.y = y
end

--- Gets the enemy's size
---@return number, number
function Enemy:getSize()
  return self.width, self.height
end

--- Sets the enemy's size
---@param width number
---@param height number
function Enemy:setSize(width, height)
  self.width = width
  self.height = height
end

--- Creates an enemy
--- @param data Dummy.Mod.Enemy
--- @return Dummy.Enemy
function Enemy:new(data)
  local position = Utils.getOrDefault(data.position, {})
  local size = Utils.getOrDefault(data.size, {})

  return Class:new(Enemy, {
    name = Utils.getOrDefault(data.name, "Monster"),
    hp = Utils.getOrDefault(data.hp, 20),
    max_hp = Utils.getOrDefault(data.hp, 20),
    at = Utils.getOrDefault(data.at, 0),
    df = Utils.getOrDefault(data.df, 0),
    exp = Utils.getOrDefault(data.xp, 0),
    gold = Utils.getOrDefault(data.gold, 0),
    check = Utils.getOrDefault(data.check, ""),
    x = Utils.getOrDefault(position[1], 320),
    y = Utils.getOrDefault(position[2], 200),
    width = Utils.getOrDefault(size[1], 80),
    height = Utils.getOrDefault(size[2], 110),
  })
end

function Enemy:init() end

return Enemy
