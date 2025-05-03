local self = {}

local function initText()
  local text = {}

  local mt = {}
  function mt.__index(_, key) return mt[key] end

  function mt.__newindex(_, key, value)
    mt[key] = value
    if key == "text" or key == "color" or key == "alpha" then
      if text.sprite ~= nil then
        text.sprite:set({ { text.color[1], text.color[2], text.color[3], text.alpha }, Lang.translate(text.text) })
      end
    elseif key == "font" then
      if text.sprite ~= nil and value ~= nil then
        text.sprite:setFont(value)
      end
    elseif key == "scale" and type(value) == "number" then
      mt[key] = { value, value }
    end
  end

  setmetatable(text, mt)

  return text
end

---Create a text
---@param text_value string | table | function
---@return table
function self.createText(text_value)
  local text_data = initText()
  text_data.text = text_value
  text_data.font = love.graphics.getFont()
  text_data.color = { 1, 1, 1 }
  text_data.alpha = 1
  text_data.x = 0
  text_data.y = 0
  text_data.rotation = 0
  text_data.scale = { 1, 1 }
  text_data.origin = { 0.5, 0.5 }
  text_data.active = true
  text_data.sprite = love.graphics.newText(text_data.font, { text_data.color, Lang.translate(text_data.text) })

  Scene.drawables[text_data.sprite] = text_data

  return text_data
end

return self
