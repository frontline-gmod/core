/*
  noclip - права на ноуклип
  godmode - права на год мод
  cloak - права на неведимку
  playerpickup - права на поднятие игроков
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
    "cloak",
    "playerpickup",
    "teleport",
  },

  ["admin"] = {
    "noclip",
    "godmode",
    "setrank",
  },
}

flrp.config.usergroup.immunity = {
  ["user"] = 25,
  ["admin"] = 70,
}

flrp.config.admin_core_settings = {
  ["EnableCloakWithNoclip"] = true,
}
