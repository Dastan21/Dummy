local self = {}

--- Creates an enemy
--- @param data Dummy.Mod.Enemy
--- @return Dummy.Enemy
function self.new(data)
  --- @class Dummy.Enemy
  ---
  --- @field private hp number
  --- @field private max_hp number
  local enemy = {}

  enemy.name = data.name
  enemy.hp = Utils.getOrDefault(data.hp, 20)
  enemy.max_hp = enemy.hp
  enemy.at = Utils.getOrDefault(data.at, 0)
  enemy.df = Utils.getOrDefault(data.df, 0)
  enemy.exp = Utils.getOrDefault(data.xp, 0)
  enemy.gold = Utils.getOrDefault(data.gold, 0)
  enemy.check = Utils.getOrDefault(data.check, "")

  --- Gets the enemy's name
  --- @return string
  function enemy:getName()
    return enemy.name
  end

  --- Gets the enemy's HP
  --- @return number
  function enemy:getHP()
    return enemy.hp
  end

  --- Sets the enemy's HP
  --- @param hp number health points
  function enemy:setHP(hp)
    if type(hp) ~= "number" then return end

    enemy.hp = math.clamp(hp, 0, enemy.max_hp)
  end

  --- Gets the enemy's max HP
  --- @return number
  function enemy:getMaxHP()
    return enemy.max_hp
  end

  --- Sets the enemy's max HP
  --- @param max_hp number maximum health points
  function enemy:setMaxHP(max_hp)
    if type(max_hp) ~= "number" then return end

    enemy.max_hp = math.clamp(max_hp, 20, 99)
  end

  --- Gets the enemy's AT
  --- @return number
  function enemy:getAT()
    return self.at
  end

  --- Sets the enemy's AT
  --- @param at number attack point
  function enemy:setAT(at)
    self.at = at
  end

  --- Gets the enemy's DE
  --- @return number
  function enemy:getDF()
    return self.df
  end

  --- Sets the enemy's DE
  --- @param df number defense point
  function enemy:setDF(df)
    self.df = df
  end

  --- Wether the enemy has a check dialogue
  --- @return boolean
  function enemy:hasCheck()
    return enemy.check ~= nil
  end

  --- Gets the enemy's check
  --- @return string
  function enemy:getCheck()
    return enemy.check
  end

  --- Gets the computed enemy's check text
  --- @return string
  function enemy:getCheckText()
    local check = "* " .. enemy:getName():upper() .. " - "
    check = check .. Lang.translate("ENCOUNTER_STAT_AT") .. " " .. enemy:getAT() .. " "
    check = check .. Lang.translate("ENCOUNTER_STAT_DF") .. " " .. enemy:getDF()
    check = check .. "\n" .. enemy:getCheck()
    return check
  end

  return enemy
end

return self
