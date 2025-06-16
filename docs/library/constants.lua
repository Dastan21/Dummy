--[[
  Generated from ..\engine\constants.lua

  Source: https://github.com/Dastan21/Dummy/blob/main/engine/constants.lua
]]

---@meta

Constants = {
  CREDITS = {
    NAME    = "DUMMY",
    AUTHOR  = "Dastan",
    YEAR    = "2025",
    VERSION = "0.01"
  },

  WIDTH = 640,
  HEIGHT = 480,

  LAYERS = {
    BOTTOM       = -1000,
    BELOW_ARENA  = 0,
    ARENA        = 1,
    ABOVE_ARENA  = 2,
    BELOW_UI     = 3,
    UI           = 4,
    ABOVE_UI     = 5,
    BELOW_BULLET = 6,
    BULLET       = 7,
    ABOVE_BULLET = 8,
    BELOW_SOUL   = 9,
    SOUL         = 10,
    ABOVE_SOUL   = 11,
    TOP          = 1000,
    DEBUG        = 1001
  },

  ENCOUNTER_STATES = {
    --- Used for example for custom introductions
    NONE             = "NONE",
    --- Action selection menu
    ACTION_SELECT    = "ACTION_SELECT",
    --- Enemy selection menu for FIGHT
    FIGHT_ENEMY_MENU = "FIGHT_ENEMY_MENU",
    --- Enemy selection menu for ACT
    ACT_ENEMY_MENU   = "ACT_ENEMY_MENU",
    --- ACT selection menu
    ACT_MENU         = "ACT_MENU",
    --- ITEM selection menu
    ITEM_MENU        = "ITEM_MENU",
    --- MERCY selection menu
    MERCY_MENU       = "MERCY_MENU",
    --- Player attack screen
    ATTACKING        = "ATTACKING",
    --- Text dialogue before ENEMY_DIALOGUE or DEFENDING
    TEXT_DIALOGUE    = "TEXT_DIALOGUE",
    --- Enemy dialogue before DEFENDING
    ENEMY_DIALOGUE   = "ENEMY_DIALOGUE",
    --- Enemy attack phase
    DEFENDING        = "DEFENDING",
    --- Returns to the main menu
    DONE             = "DONE",
  },

  ARENA = {
    RESIZE_SPEED   = 30,
    DEFAULT_WIDTH  = 565,
    DEFAULT_HEIGHT = 130,
    BORDER_WIDTH   = 5,
    DEFAULT_X      = 320,
    DEFAULT_Y      = 385,
  }
}
