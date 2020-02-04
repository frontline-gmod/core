require( "mysqloo" )

DataBase = mysqloo.connect(
  "remotemysql.com", -- IP DATABASE
  "tGx32wrUUE", -- LOGIN DATABASE
  "8ITB4AdBsL", -- PASSWORD DATABASE
  "tGx32wrUUE", -- NAME DATABASE
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
