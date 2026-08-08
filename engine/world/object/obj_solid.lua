--- @class Dummy.Object.Solid.Data : Dummy.Object.Data

--- @class Dummy.Object.Solid : Dummy.Object
local SolidObject = Class(Object, "Dummy.Object.Solid")

SolidObject.ALLOW_EDITOR = true

--- Creates a solid
--- @param x number
--- @param y number
--- @param width? number
--- @param height? number
function SolidObject:new(x, y, width, height)
  self = Class:new(SolidObject)

  self.depth = 99999999
  self:setStatic(true)
  self:setCollisionEnabled(true)
  self:setCollisionSolid(true)
  self:setOrigin(0, 0)
  self:setHitbox(x, y, Utils.getOrDefault(width, 20), Utils.getOrDefault(height, 20))
  self:setLayer(Constants.LAYERS.WORLD_SOLID)

  return self
end

--- Gets the solid object's metadata
--- @return Dummy.Editor.Metadata[]
function SolidObject.getMetadata()
  --- @type Dummy.Editor.Metadata[]
  return {
    {
      id = "width",
      label = "WORLD_OBJECT_SOLID_METADATA_WIDTH",
      type = "integer",
      default = 20,
      validate = function(value)
        return value > 0
      end
    },
    {
      id = "height",
      label = "WORLD_OBJECT_SOLID_METADATA_HEIGHT",
      type = "integer",
      default = 20,
      validate = function(value)
        return value > 0
      end
    }
  }
end

--- Draws the solid object's hitbox for debugging
function SolidObject:drawDebug() end

--- Draws the solid object for the editor
--- @param data Dummy.Object.Solid.Data
function SolidObject.drawEditor(data)
  love.graphics.setColor(0, 1, 0)
  love.graphics.rectangle("line", data.x + 0.5, data.y + 0.5, data.width - 1, data.height - 1)
end

return SolidObject
