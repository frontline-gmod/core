----------------------------------------------------------------------------
-- Entity Manager (конструктор запросов для работы с сущностями базы данных)
--
-- Обеспечивает удобный доступ к данным из БД, во всех случаях где не требуется
-- сложная выборка из базы, рекомендуется использовать именно Entity Manager
-- для минимизации возможных ошибок при построении запроса
--
-- Gor Mkhitaryan aka Chigiman (c)
----------------------------------------------------------------------------

database.orm = {}

-- Простой запрос SELECT для получения всех данных из таблицы
database.orm.get = function(entity, successCallback)
  local successCallback = successCallback or function() end
  local query = "SELECT * FROM `"..entity.."`";

  database.query(query, successCallback, {})
end

-- Запрос SELECT с условием (задается в виде таблицы)
database.orm.getBy = function(entity, criteria, successCallback)
  local successCallback = successCallback or function() end
  local query = "SELECT * FROM `"..entity.."`";

  if(database.utils.getSize(criteria) > 0) then
    buildedCriteria = database.utils.buildCriteria(criteria);

    query = query .. " WHERE " .. buildedCriteria.criteriaPart;

    database.query(query, successCallback, buildedCriteria.bindedValues)
  else
    database.orm.get(entity, successCallback)
  end
end

-- Запрос UPDATE,
database.orm.update = function(entity, data, criteria, successCallback)
  local successCallback = successCallback or function() end
  local criteria = criteria or {};

  local query = "UPDATE `"..entity.."` SET ";
  local setValuesTable = {};
  local bindedValues = {};

  for k,v in pairs(data) do
    table.insert(setValuesTable, "`"..k.."` = ?");
    table.insert(bindedValues, v);
  end

  query = query..table.concat(setValuesTable, ',');

  if(database.utils.getSize(criteria) > 0) then
    local buildedCriteria = database.utils.buildCriteria(criteria, database.utils.getSize(bindedValues));

    query = query .." WHERE ".. buildedCriteria.criteriaPart;

    database.utils.tableMerge(bindedValues, buildedCriteria.bindedValues);
  end

  database.query(query, successCallback, bindedValues);
end

-- Запрос INSERT
database.orm.insert = function(entity, data, successCallback)
  local successCallback = successCallback or function() end

  local dataKeys = {};
  local bindedValues = {};
  local values = {};

  for k,v in pairs(data) do
    table.insert(dataKeys, "`"..k.."`");
    table.insert(bindedValues, v);
    table.insert(values, '?');
  end

  local query = "INSERT INTO `"..entity.."` ("..table.concat(dataKeys, ',')..") VALUES ("..table.concat(values,',')..")";

  database.query(query, successCallback, bindedValues);
end

-- Запрос DELETE
database.orm.delete = function(entity, criteria, successCallback)
  local successCallback = successCallback or function() end
  local criteria = criteria or {};

  local query = "DELETE FROM `"..entity.."` ";

  if(database.utils.getSize(criteria) > 0) then
    buildedCriteria = database.utils.buildCriteria(criteria);

    query = query .." WHERE ".. buildedCriteria.criteriaPart;

    database.query(query, successCallback, buildedCriteria.bindedValues)
  else
    database.query(query, successCallback)
  end
end
