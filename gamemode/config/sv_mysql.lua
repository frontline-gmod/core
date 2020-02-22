require( "mysqloo" )

DataBase = mysqloo.connect(
  "db4free.net", -- IP DATABASE
  "flrp_db", -- LOGIN DATABASE
  "seregatawer", -- PASSWORD DATABASE
  "flrp_db", -- NAME DATABASE
  3306 -- PORT DATABASE
)


function DataBase:onConnected()

    print( "[FL]Database has connected!" )

end

function DataBase:onConnectionFailed( err )

    print( "[FL]Connection to database failed!" )
    print( "[FL]Error:", err )

end

DataBase:connect()

UTF8Query = DataBase:query("SET NAMES utf8")
UTF8Query:start()
