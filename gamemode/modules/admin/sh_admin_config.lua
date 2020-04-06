/*
  admin - права администратора
  superadmin - права супер администратора
  noclip - права на ноуклип и невидимку
  godmode - права на год мод
  playerpickup - права на поднятие игроков
  notarget - права на отключение видимости игрока нпси
  teleport - права на телепорт игроков
  logs - права доступа к логам
  model - права на смену модели
  kick - права для кика с сервера
  ban - права на бан игроков
  perm - права на бан игроков пермачом
  setrank - права на выдачу групп
  property - права на использование проперти (поджечь, удалить и т.п)
  spawnmenu - права на использование C меню и Q menu
  whitelist - права на использование вайтлиста
  respawn - права на респавн игроков
  incognito - права на режим скрытия прав
*/

flrp.config.admin_core_settings = { -- доп настройки
  ["EnableCloakWithNoclip"] = true,
}

flrp.config.defaultusergroup = "user" -- юзер группа по умолчанию

flrp.config.usergroup = { -- все доступные юзер группы сервера
  [flrp.config.defaultusergroup] = {},

  ["admin"] = {
    "admin",
    "noclip",
    "godmode",
    "setrank",
    "notarget",
    "playerpickup",
    "teleport",
    "kick",
    "ban",
    "unban",
    "perm",
    "spawnmenu",
    "whitelist",
    "respawn",
  },

  ["superadmin"] = {
    "admin",
    "noclip",
    "godmode",
    "setrank",
    "notarget",
    "playerpickup",
    "teleport",
    "model",
    "kick",
    "ban",
    "unban",
    "perm",
    "spawnmenu",
    "whitelist",
    "respawn",
    "incognito",
    "logs",
    "scale",
  },
}

flrp.config.usergroup.immunity = { -- иммунитет у юзер групп
  ["user"] = 25,
  ["admin"] = 50,
  ["superadmin"] = 100,
}

flrp.config.usergroup.lenght = { -- максимальный срок блокировки у юзер групп
  ["user"] = 0,
  ["admin"] = 1440,
  ["superadmin"] = 36000,
}

flrp.config.usergroup.limits = { -- лимиты пропов у юзер групп
  ["admin"] = {
  	["vehicles"] = 8,
  	["effects"] = 12,
  	["props"] = 512,
  	["ragdolls"] = 6,
  	["npcs"] = 4,
  	["tools"] = {},
  	["sents"] = 12,
  	["balloons"] = 12,
  	["buttons"] = 30,
  	["dynamite"] = 12,
  	["effects"] = 50,
  	["emitters"] = 12,
  	["hoverballs"] = 20,
  	["lamps"] = 12,
  	["lights"] = 12,
  	["thrusters"] = 50,
  	["wheels"] = 50,
  },

  ["superadmin"] = {
  	["vehicles"] = 8,
  	["effects"] = 12,
  	["props"] = 2,
  	["ragdolls"] = 6,
  	["npcs"] = 4,
  	["tools"] = {},
  	["sents"] = 12,
  	["balloons"] = 12,
  	["buttons"] = 30,
  	["dynamite"] = 12,
  	["effects"] = 2,
  	["emitters"] = 12,
  	["hoverballs"] = 20,
  	["lamps"] = 12,
  	["lights"] = 12,
  	["thrusters"] = 50,
  	["wheels"] = 50,
  },
}
