--- @alias Dummy.Object.SolidTriangle.Side "top-left" | "top-right" | "bottom-left" | "bottom-right"

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
  self.hitbox_triangle = self:newHitboxTriangle(side, 1, 1, -1, -1)
  self.hitbox_triangle_debug = self:newHitboxTriangle(side, 0.5, 0.5, -0.5, -0.5)

  return self
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
function SolidTriangleObject:newHitboxTriangle(side, ox1, oy1, ox2, oy2)
  ox1 = Utils.getOrDefault(ox1, 0)
  oy1 = Utils.getOrDefault(oy1, 0)
  ox2 = Utils.getOrDefault(ox2, 0)
  oy2 = Utils.getOrDefault(oy2, 0)

  local _, _, width, height = self:getHitbox()
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

return SolidTriangleObject
