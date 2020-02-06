/*
  noclip - права на ноуклип
  godmode - права на год мод
  nologs - права на полную анонимность админки
  viewlog - видеть админ. действия администраторов в чате
  setrank - права на выдачу прав
*/

flrp.config.usergroup = {
  ["user"] = {
    "noclip",
    "godmode",
    "viewlog",
    "setrank",
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
