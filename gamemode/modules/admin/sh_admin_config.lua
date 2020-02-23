/*
  noclip - права на ноуклип и невидимку
  godmode - права на год мод
  playerpickup - права на поднятие игроков
  setnotarget - права на отключение видимости игрока нпси
  teleport - права на телепорт игроков
  nologs - права на полную анонимность админки
  viewlog - права видеть админ. действия администраторов в чате
  kick - права для кика с сервера
  ban - права на бан игроков
  setrank - права на выдачу групп
  property - права на использование проперти (поджечь, удалить и т.п)
  spawnmenu - права на использование C меню и Q menu
*/

flrp.config.usergroup = { -- все доступные юзер группы сервера
  ["user"] = {},
  ["admin"] = {
    "noclip",
    "godmode",
    "viewlog",
    "setrank",
    "setnotarget",
    "playerpickup",
    "teleport",
    "kick",
    "ban",
  },
}

flrp.config.usergroup.immunity = { -- иммунитет у юзер групп
  ["user"] = 25,
  ["admin"] = 70,
}

flrp.config.usergroup.lenght = { -- максимальный срок блокировки у юзер групп
  ["admin"] = 1440,
}

flrp.config.admin_core_settings = { -- доп настройки
  ["EnableCloakWithNoclip"] = true,
}
