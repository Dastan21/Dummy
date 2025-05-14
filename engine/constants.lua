local self = {}

self.CREDITS = {
  NAME = "DUMMY",
  AUTHOR = "Dastan",
  YEAR = "2025",
  VERSION = "0.01"
}

self.LAYERS = {
  BOTTOM        = -1000,
  BELOW_UI      = 0,
  UI            = 1,
  ABOVE_UI      = 2,
  BELOW_ARENA   = 3,
  ARENA         = 4,
  ABOVE_ARENA   = 5,
  BELOW_SOUL    = 6,
  SOUL          = 7,
  ABOVE_SOUL    = 8,
  BELOW_BULLETS = 9,
  BULLETS       = 10,
  ABOVE_BULLETS = 11,
  TOP           = 1000
}

self.ENCOUNTER_STATES = {
  --- Used for example for custom introductions
  NONE = "NONE",
  --- Action selection menu
  ACTION_SELECT = "ACTION_SELECT",
  --- Enemy selection menu for FIGHT
  FIGHT_ENEMY_MENU = "FIGHT_ENEMY_MENU",
  --- Enemy selection menu for ACT
  ACT_ENEMY_MENU = "ACT_ENEMY_MENU",
  --- ACT selection menu
  ACT_MENU = "ACT_MENU",
  --- ITEM selection menu
  ITEM_MENU = "ITEM_MENU",
  --- MERCY selection menu
  MERCY_MENU = "MERCY_MENU",
  --- Player attack screen
  ATTACKING = "ATTACKING",
  --- Enemy dialogue before DEFENDING
  ENEMY_DIALOGUE = "ENEMY_DIALOGUE",
  --- Enemy attack phase
  DEFENDING = "DEFENDING",
  --- Returns to the main menu
  DONE = "DONE",
}

return self
