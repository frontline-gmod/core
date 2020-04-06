timer.Create("InsertLogsInDB", flrp.config.logs_cooldown, 0, function()
  if flrp.temp then
    for k,v in pairs(flrp.temp) do
      database.orm.insert("logs", {
        date = flrp.temp[k].date,
        category = flrp.temp[k].category,
        logstring = flrp.temp[k].logstring,
      })
      if table.Count(flrp.temp) == k then
        table.Empty(flrp.temp)
        break
      end
    end
  end
end)

function AddLogString(date, category, logstring)
  local tableLogString = {
    date = date,
    category = category,
    logstring = logstring,
  }

  table.insert(flrp.temp, tableLogString)
  table.insert(flrp.logs[1], tableLogString)
end

hook.Add("PlayerConnect", "FLRPPlayerConnectLog", function(ply)
  AddLogString(tostring(os.time()), "Коннект", string.format( "Игрок %s зашел на сервер", ply ))
end)

hook.Add("PlayerDisconnected", "FLRPPlayerDisconnectLog", function(ply)
  AddLogString(tostring(os.time()), "Дисконнект", string.format( "Игрок %s вышел с сервера", ply:Name() ))
end)

hook.Add("PlayerCanPickupWeapon", "FLRPCanPickupLog", function(ply, weapon)
  AddLogString(tostring(os.time()), "Снаряжение", string.format( "Игрок %s(%s) взял оружие %s", ply:Name(), ply:SteamID64(), weapon:GetClass() ))
end)

hook.Add("PlayerSpawnedEffect", "FLRPSpawnedEffectLog", function(ply, model, ent)
  AddLogString(tostring(os.time()), "Спавн", string.format( "Игрок %s(%s) заспавнил эффект: %s", ply:Name(), ply:SteamID64(), model ))
end)

hook.Add("PlayerSpawnedNPC", "FLRPSpawnedNPCLog", function(ply, ent)
  AddLogString(tostring(os.time()), "Спавн", string.format( "Игрок %s(%s) заспавнил НПСи: %s", ply:Name(), ply:SteamID64(), ent:GetClass() ))
end)

hook.Add("PlayerSpawnedProp", "FLRPSpawnedPropLog", function(ply, model, ent)
  AddLogString(tostring(os.time()), "Спавн", string.format( "Игрок %s(%s) заспавнил проп: %s", ply:Name(), ply:SteamID64(), model ))
end)

hook.Add("PlayerSpawnedRagdoll", "FLRPSpawnedRagdollLog", function(ply, model, ent)
  AddLogString(tostring(os.time()), "Спавн", string.format( "Игрок %s(%s) заспавнил рэгдолл: %s", ply:Name(), ply:SteamID64(), model ))
end)

hook.Add("PlayerSpawnedSENT", "FLRPSpawnedSENTLog", function(ply, ent)
  AddLogString(tostring(os.time()), "Спавн", string.format( "Игрок %s(%s) заспавнил энтити: %s", ply:Name(), ply:SteamID64(), ent:GetClass() ))
end)

hook.Add("PlayerSpawnedSWEP", "FLRPSpawnedSWEPLog", function(ply, ent)
  AddLogString(tostring(os.time()), "Спавн", string.format( "Игрок %s(%s) заспавнил оружие: %s", ply:Name(), ply:SteamID64(), ent:GetClass() ))
end)

hook.Add("PlayerSpawnedSWEP", "FLRPSpawnedSWEPLog", function(ply, ent)
  AddLogString(tostring(os.time()), "Спавн", string.format( "Игрок %s(%s) заспавнил технику: %s", ply:Name(), ply:SteamID64(), ent:GetClass() ))
end)

hook.Add("CanTool", "FLRPCanToolLog", function( ply, tr, tool )
  AddLogString(tostring(os.time()), "Тулган", string.format( "Игрок %s(%s) использовал тулган: %s", ply:Name(), ply:SteamID64(), tool ))
end)

hook.Add("PostEntityTakeDamage", "FLRPEntityTakeDamage", function(victim, damage, took)
  if victim:IsPlayer() then
    if damage:GetAttacker():IsPlayer() then
      AddLogString(tostring(os.time()), "Урон", string.format( "Игрок %s(%s) получил %s урон(-а) от %s(%s) при помощи %s", victim:Name(), victim:SteamID64(), math.floor(damage:GetDamage()), damage:GetAttacker():Name(), damage:GetAttacker():SteamID64(), damage:GetAttacker():GetActiveWeapon():GetClass() ))
    end

    if damage:IsFallDamage() then
      AddLogString(tostring(os.time()), "Урон", string.format( "Игрок %s(%s) получил %s урон(-а) при падении", victim:Name(), victim:SteamID64(), math.floor(damage:GetDamage()) ))
    end

    if damage:IsExplosionDamage() then
      AddLogString(tostring(os.time()), "Урон", string.format( "Игрок %s(%s) получил %s урон(-а) от взрыва", victim:Name(), victim:SteamID64(), math.floor(damage:GetDamage()) ))
    end
  end
end)

hook.Add("PlayerDeath", "FLRPPlayerDeathLog", function(victim, weapon, suspect)
  if weapon == Entity(0) then weapon = "Мир" end
  if suspect == Entity(0) then suspect = "Мир"
    AddLogString(tostring(os.time()), "Смерть", string.format( "Игрок %s(%s) был убит %s при помощи %s", victim:Name(), victim:SteamID64(), suspect, weapon ))
  else
    AddLogString(tostring(os.time()), "Смерть", string.format( "Игрок %s(%s) был убит %s(%s) при помощи %s", victim:Name(), victim:SteamID64(), suspect:Name(), suspect:SteamID64(), weapon:GetClass() ))
  end
end)

hook.Add("PlayerSpawn", "FLRPPlayerSpawnLog", function(ply)
  AddLogString(tostring(os.time()), "Возрождение", string.format( "Игрок %s(%s) заспавнился", ply:Name(), ply:SteamID64() ))
end)
