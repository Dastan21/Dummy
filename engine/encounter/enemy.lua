local self = {}

--- Creates an enemy
---@param data Dummy.Mod.Data.Enemy
---@return Dummy.Enemy
function self.new(data)
  ---@class Dummy.Enemy
  ---
  ---@field private hp number
  ---@field private max_hp number
  local enemy = {}

  enemy.name = data.name
  enemy.hp = Utils.getOrDefault(data.hp, 20)
  enemy.max_hp = enemy.hp
  enemy.atk = Utils.getOrDefault(data.at, 0)
  enemy.def = Utils.getOrDefault(data.df, 0)
  enemy.exp = Utils.getOrDefault(data.xp, 0)
  enemy.gold = Utils.getOrDefault(data.gold, 0)
  enemy.check = Utils.getOrDefault(data.check, "")

  --- Gets the enemy's name
  --- @return string
  function enemy.getName()
    return enemy.name
  end

  --- Gets the enemy's HP
  --- @return number
  function enemy.getHP()
    return enemy.hp
  end

  --- Sets the player's HP
  ---@param hp number health points
  function enemy.setHP(hp)
    if type(hp) ~= "number" then return end

    enemy.hp = math.clamp(hp, 0, enemy.max_hp)
    -- enemy.hp_value_text:setText(string.format("%02d", enemy.hp) .. " / " .. tostring(enemy.max_hp))
    -- enemy.hp_value_text:setPosition(289 + math.clamp(5 * Player.getLV() + 20, 25, 120), 409)
  end

  --- Gets the enemy's max HP
  --- @return number
  function enemy.getMaxHP()
    return enemy.max_hp
  end

  --- Sets the player's max HP
  ---@param max_hp number maximum health points
  function enemy.setMaxHP(max_hp)
    if type(max_hp) ~= "number" then return end

    enemy.max_hp = math.clamp(max_hp, 20, 99)
    -- enemy.hp_value_text:setText(tostring(enemy.hp) .. " / " .. tostring(enemy.max_hp))
    -- enemy.hp_value_text:setPosition(289 + math.clamp(5 * Player.getLV() + 20, 25, 120), 409)
  end

  --- Wether the enemy has a check dialogue
  --- @return boolean
  function enemy.hasCheck()
    return enemy.check ~= nil
  end

  --- Gets the enemy's check
  --- @return string
  function enemy.getCheck()
    return enemy.check
  end

  return enemy
end

return self
