database = {}

database.config = {
  timeout = 5,
}

database.query = function(query, successCallback, data)
    local query = DataBase:prepare(query)

    function query:onSuccess(data)
       successCallback(data)
    end

    function query:onError(err)
      print("[FL ERROR] An error occured while executing the query: " .. err)
    end

    if #data > 0 then
      for k,v in pairs(data) do
        variableType = type(v);

        if variableType == "string" then
          query:setString(k,v);
        else if variableType == "number" then
          query:setNumber(k,v);
        else
          print("[FL ERROR] Provided type ("..variableType..") of variable is not supported.");
        end
      end
    end

    query:start();
  end
end
