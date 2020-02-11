----------------------------------------------------------------------------
-- Модуль работы с базой данных
-- Включает в себя:
-- * Entity Manager (конструктор запросов для работы с сущностями базы данных)
-- * Обертку под mysqloo для удобной и безопасной работы с базой данных
--
-- Gor Mkhitaryan aka Chigiman aka Ebus' v ochko (c)
----------------------------------------------------------------------------

database = {
  config = {
    debug = true
  },
  utils = {}
}

-- Утилиты для модуля Database
database.utils.getSize = function(table)
  local i = 0;

  for item in pairs(table) do
    i = i + 1;
  end

  return i;
end

database.utils.tableMerge = function(firstTable, secondTable)
  if type(firstTable) == 'table' and type(secondTable) == 'table' then
    for k,v in pairs(secondTable) do
      if type(v) == 'table' and type(firstTable[k] or false) == 'table' then
        database.utils.tableMerge(firstTable[k], v)
      else
        firstTable[k]=v
      end
    end
  end

  return firstTable
end

database.utils.queryError = function(err)
  local string = string or "No string provided to queryError";

  print("[FL ERROR] An error occured while executing the query: " .. err)
end

database.utils.printDebug = function(string)
  local string = string or "No string provided to printDebug";

  print("[FL DATABASE DEBUG] " .. string);
end

-- Генерирует блок условий для запроса
database.utils.buildCriteria = function(criteria, offset)
  local offset = offset or 0;

  local criteriaTable = {}
  local bindedValues = {}
  local i = 1 + offset;

  for k,v in pairs(criteria) do
    bindedValues[i] = v;

    table.insert(criteriaTable, k.." = ?")

    i = i + 1;
  end

  return {
    criteriaPart = table.concat(criteriaTable, " AND "),
    bindedValues = bindedValues
  }
end

/*
 * Функция выполнения запроса
 */
database.query = function(query, successCallback, data)
  local data = data or {};

  if database.utils.getSize(data) > 0 then
    queryInstance = DataBase:prepare(query)

    function queryInstance:onSuccess(data)
       successCallback(data)
    end

    function queryInstance:onError(err)
      database.utils.queryError(err)
    end

    /*
     * Вставка значений в запрос (защита от SQL инъекций)
     */
    for k,v in pairs(data) do
        variableType = type(v);

        if variableType == "string" then
          queryInstance:setString(k,v);
        else if variableType == "number" then
          queryInstance:setNumber(k,v);
        else
          print("[FL ERROR] Provided type ("..variableType..") of variable is not supported.");
        end
      end
    end
  else
    /*
     * Если вставка данных не требуется, то не используем подготовленный запрос
     */
    queryInstance = DataBase:query(query)

    function queryInstance:onSuccess(data)
       successCallback(data)
    end

    function queryInstance:onError(err)
      database.utils.queryError(err)
    end
  end

  queryInstance:start();

  if(database.config.debug) then
    database.utils.printDebug("Executed query: " .. query .. table.ToString(data, " [Query data]"))
  end
end
