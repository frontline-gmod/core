function GM:Initialize()
	print("[FL LOGS] Logging system activated")

  timer.Create( "LogsSystemSequence", logs.config.delay, 0, function() logs.persist() end )
end

hook.Add('PlayerInitialSpawn', 'logs_player_connect', function(ply)
  logs.insert("connect", ply);
end)
