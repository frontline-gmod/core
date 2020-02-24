require( "mysqloo" )

DataBase = mysqloo.connect(
  "localhost", -- IP DATABASE
  "root", -- LOGIN DATABASE
  "", -- PASSWORD DATABASE
  "fl_gamemode", -- NAME DATABASE
  3306 -- PORT DATABASE
)


function DataBase:onConnected()

    database.orm.get("bans", function(result)
      table.Empty(flrp.banlist)
    	table.insert(flrp.banlist, result)
    end)

    print( "[FL]Database has connected!" )

end

function DataBase:onConnectionFailed( err )

    print( "[FL]Connection to database failed!" )
    print( "[FL]Error:", err )

end

DataBase:connect()

UTF8Query = DataBase:query("SET NAMES utf8")
UTF8Query:start()
