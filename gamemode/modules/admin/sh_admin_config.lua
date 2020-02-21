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
*/

flrp.config.usergroup = {
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

flrp.config.usergroup.immunity = {
  ["user"] = 25,
  ["admin"] = 70,
}

flrp.config.admin_core_settings = {
  ["EnableCloakWithNoclip"] = true,
}
