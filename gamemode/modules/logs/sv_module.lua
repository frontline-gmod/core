----------------------------------------------------------------------------
-- Модуль логгирования
-- Для работы модуля логгирования требуется модуль Database и модуль Admin
--
-- Gor Mkhitaryan aka Chigiman (c)
----------------------------------------------------------------------------

logs = {
  config = {
    --Задержка перед загрузкой логов в базу данных (в секундах)
    delay = 2,
    debug = true
  },
  -- Массив из собранных данных за время logs.config.delay
  bag = {}
}

logs.persist = function()
  if(next(logs.bag) == nil) then
    if(logs.config.debug) then
      print("[FL LOGS] Nothing to save")
    end

    return false;
  end

  local bag = logs.bag;

  logs.bag = {}

  /*
    Структура элемента bag:

    subject - Никнейм инциатора
    subject_id - SteamID инициатора
    subject_usergroup - Usergroup инициатора
    target - Никнейм цели (опционально)
    target_id - SteamID цели (опционально)
    target_usergroup - Usergroup цели (опционально)
    action - действие (kill, damage, spawn, ....)
    time - время (Год-Месяц-День Час:Минута:Секунда)
    ip - IP address
  */
  local query = "INSERT INTO `logs` %s VALUES ";

  local valuesStamp = {};

  for k,v in pairs(bag[1]) do
      table.insert(valuesStamp, string.format('`%s`', k));
  end

  valuesStamp = string.format('(%s)', table.concat(valuesStamp, ', '));

  query = string.format(query, valuesStamp);

  local valuesArray = {};
  local bindedValues = {};

    for i = 1, #bag do
      for k,v in pairs(bag[i]) do
        table.insert(bindedValues, v);
      end

      table.insert(valuesArray, "(?,?,?,?,?,?,?,?,?)");
    end

  query = query .. table.concat(valuesArray, ', ');

  if(logs.config.debug) then
    database.query(query, function()
      print("[FL LOGS] Logs package has been saved in database")
    end, bindedValues)
  end
end

logs.insert = function(action, subjectPly, targetPly)
  local targetPly = targetPly or false;

  local tmp = {
      subject = subjectPly:Name(),
      subject_id = subjectPly:SteamID64() or 0,
      subject_usergroup = subjectPly:GetUserGroup(),
      action = action,
      time = os.date("%Y-%m-%d %H:%M:%S", os.time()),
      ip = subjectPly:IPAddress()
  }

  if(targetPly) then
      tmp.target = targetPly:Name();
      tmp.target_id = targetPly:SteamID64() or 0;
      tmp.target_usergroup = targetPly:GetUserGroup();
  else
      tmp.target = "";
      tmp.target_id = "";
      tmp.target_usergroup = "";
  end

  table.insert(logs.bag, tmp);
end
