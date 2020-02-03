--[[
	Created by Patrick Ratzow (sleeppyy).

	Credits goes to Metamist for his previously closed source library Wyvern,
		CupCakeR for various improvements, the animated texture VGUI panel, and misc.
]]

-- due to calling this very early we can't use XeninUI namespace
local yellow = Color(201, 176, 15)
local red = Color(230, 58, 64)
local green = Color(46, 204, 113)

function XeninUI:InvokeSQL(conn, str, name, successFunc, errFunc)
	local p = XeninUI.Promises.new()
	local debug = self.Debug
	local sqlStr = conn.isMySQL() and "[MySQL] " or "[SQLite] "
	local successDetour = function(result)
		if (debug) then
			MsgC(yellow, sqlStr, color_white, name, green, " Success!\n")
		end
	end
	local _successFunc = function(result)
		successDetour(result)
		p:resolve(result)
	end
	local errDetour = function(err)
		if (debug) then
			MsgC(yellow, sqlStr, color_white, name, red, " Failure! ", color_white, err .. "\n")
		end
	end
	local _errFunc = function(err)
		errDetour(err)
		p:reject(err)
	end

	conn.query(str, _successFunc, _errFunc)

	return p
end
