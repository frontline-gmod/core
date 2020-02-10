/*
  noclip - права на ноуклип и невидимку
  godmode - права на год мод
  playerpickup - права на поднятие игроков
  setnotarget - права на отключение видимости игрока нпси
  teleport - права на телепорт игроков
  nologs - права на полную анонимность админки
  viewlog - права видеть админ. действия администраторов в чате
  setrank - права на выдачу групп
*/

flrp.config.usergroup = {
  ["user"] = {
    "noclip",
    "godmode",
    "viewlog",
    "setrank",
    "setnotarget",
    "playerpickup",
    "teleport",
  },

  ["admin"] = {
    "noclip",
    "godmode",
    "viewlog",
    "setrank",
    "playerpickup",
  },
}

flrp.config.usergroup.immunity = {
  ["user"] = 25,
  ["admin"] = 70,
}

flrp.config.admin_core_settings = {
  ["EnableCloakWithNoclip"] = true,
}
