--- @alias Dummy.Object.SolidTriangle.Side "top-left" | "top-right" | "bottom-left" | "bottom-right"

--- @class Dummy.Object.SolidTriangle.Data : Dummy.Object.Data
---
--- @field side Dummy.Object.SolidTriangle.Side
--- @field size number

--- @class Dummy.Object.SolidTriangle : Dummy.Object.Solid
---
--- @field protected side Dummy.Object.SolidTriangle.Side
--- @field protected hitbox_triangle [number, number, number, number, number, number]
local SolidTriangleObject = Class(SolidObject, "Dummy.Object.SolidTriangle")

--- Creates a solid triangle
--- @param side Dummy.Object.SolidTriangle.Side
--- @param x number
--- @param y number
--- @param size? number
function SolidTriangleObject:new(side, x, y, size)
  self = Class:new(SolidTriangleObject, { x, y, size, size })

  self.side = side

  local _, _, width, height = self:getHitbox()
  self.hitbox_triangle = SolidTriangleObject.newHitboxTriangle(self.side, width, height, 1, 1, -1, -1)
  self.hitbox_triangle_debug = SolidTriangleObject.newHitboxTriangle(self.side, width, height, 0.5, 0.5, -0.5, -0.5)

  return self
end

--- Initializes the solid triangle object's arguments before creating it
--- @param data Dummy.Object.SolidTriangle.Data
function SolidTriangleObject.initArgs(data)
  return data.side, data.x, data.y, data.size
end

--- Gets the solid triangle object's metadata
--- @return Dummy.Editor.Metadata[]
function SolidTriangleObject.getMetadata()
  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "side",
      label = "WORLD_OBJECT_SOLID_TRIANGLE_METADATA_SIDE",
      type = "string",
      default = "top-left",
      options = {
        { value = "top-left",     label = "top-left" },
        { value = "top-right",    label = "top-right" },
        { value = "bottom-left",  label = "bottom-left" },
        { value = "bottom-right", label = "bottom-right" }
      }
    },
    {
      id = "size",
      label = "WORLD_OBJECT_SOLID_TRIANGLE_METADATA_SIZE",
      type = "integer",
      default = 20,
      validate = function(value)
        return value > 0
      end
    },
  }
end

--- Called when the solid triangle form is confirmed in the editor
---
--- Note: Useful for modifying the object's data before it is added to the room
--- @param data Dummy.Object.SolidTriangle.Data
function SolidTriangleObject.onFormConfirm(data)
  data.width = data.size
  data.height = data.size
end

--- Gets the solid triangle side
--- @return Dummy.Object.SolidTriangle.Side
function SolidTriangleObject:getSide()
  return self.side
end

--- Gets the solid triangle hitbox
--- @return number, number, number, number, number, number
function SolidTriangleObject:getHitboxTriangle()
  return self.hitbox_triangle[1], self.hitbox_triangle[2], self.hitbox_triangle[3], self.hitbox_triangle[4],
      self.hitbox_triangle[5], self.hitbox_triangle[6]
end

--- Creates the solid triangle hitbox
--- @param side Dummy.Object.SolidTriangle.Side
--- @param ox1? number
--- @param oy1? number
--- @param ox2? number
--- @param oy2? number
--- @return [number, number, number, number, number, number]
function SolidTriangleObject.newHitboxTriangle(side, width, height, ox1, oy1, ox2, oy2)
  ox1 = Utils.getOrDefault(ox1, 0)
  oy1 = Utils.getOrDefault(oy1, 0)
  ox2 = Utils.getOrDefault(ox2, 0)
  oy2 = Utils.getOrDefault(oy2, 0)

  local ax, ay = 0, 0
  local bx, by = 0, 0
  local cx, cy = 0, 0
  if side == "top-left" then
    ax = ox1
    ay = oy1
    bx = width + ox2
    by = oy1
    cx = ox1
    cy = height + oy2
  elseif side == "top-right" then
    ax = width + ox2
    ay = oy1
    bx = width + ox2
    by = height + oy2
    cx = ox1
    cy = oy1
  elseif side == "bottom-left" then
    ax = ox1
    ay = height + oy2
    bx = ox1
    by = oy1
    cx = width + ox2
    cy = height + oy2
  elseif side == "bottom-right" then
    ax = width + ox2
    ay = height + oy2
    bx = ox1
    by = height + oy2
    cx = width + ox2
    cy = oy1
  end

  return { ax, ay, bx, by, cx, cy }
end

--- Draws the solid triangle object's hitbox for debugging
function SolidTriangleObject:drawDebug() end

--- @type table<integer, { side: Dummy.Object.SolidTriangle.Side, size: number, hitbox: [number, number, number, number, number, number] }>
local hitboxes_cache = {}

--- Draws the solid triangle object for the editor
--- @param data Dummy.Object.SolidTriangle.Data
function SolidTriangleObject.drawEditor(data)
  local hitbox_data = hitboxes_cache[data.id]
  if hitbox_data == nil or data.side ~= hitbox_data.side or data.size ~= hitbox_data.size then
    hitbox_data = {
      side = data.side,
      size = data.size,
      hitbox = SolidTriangleObject.newHitboxTriangle(data.side, data.size, data.size, 0.5, 0.5, -0.5, -0.5)
    }
    hitboxes_cache[data.id] = hitbox_data
  end
  love.graphics.setColor(0, 1, 0)
  local ax, ay, bx, by, cx, cy = table.unpack(hitbox_data.hitbox)
  love.graphics.polygon("line", data.x + ax, data.y + ay, data.x + bx, data.y + by, data.x + cx, data.y + cy)
end

return SolidTriangleObject
