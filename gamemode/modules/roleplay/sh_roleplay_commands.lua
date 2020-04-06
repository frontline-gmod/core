flrp.cmd = flrp.cmd || {}
flrp.cmd.data = flrp.cmd.data || {}

function flrp.cmd.callback( ply, cmd, args, str )
	if (!(args[1]) or args == {}) then
		print("Бывает.")
	end
	if table.HasValue(table.GetKeys(flrp.cmd.data), args[1]) then
		local com = args[1]
		-- table.remove(args, 1)
		flrp.cmd.data[com](ply, cmd, args)
	elseif (args[1] or args == {}) then
		print("Ошибка в аргументах!")
	end
end

function flrp.cmd.autoComplete(commandName, args)
	local return_table = {}
	for _, name in pairs(table.GetKeys(flrp.cmd.data)) do
		table.insert(return_table, string.format("flrp %s", name))
	end
	return return_table
end

function flrp.cmd.add(arg, callback)
	flrp.cmd.data[arg] = callback
end

function OOCMassage( ply, cmd, args )
	table.remove(args, 1)
	local strMsg = string.Implode( " ", args )
	netstream.Start(player.GetAll(), "ChatMassage", {
		ply = ply,
		pre = "[OOC] ",
		color = Color(238, 50, 57),
		text = strMsg
	} )
end
flrp.cmd.add("ooc", OOCMassage)
flrp.cmd.add("/", OOCMassage)

local function ChangeName( ply, cmd, args )
	if !SERVER then
		return
	end

	table.remove(args, 1)
	local nickname = string.Implode(" ", args)
	local ostime = os.time()

	local can_change_name = false

	if can_change_name == false then
		can_change_name = true
	end

  database.orm.get("users", function(result)
		for k,v in pairs(result) do
	    if result[k].name == nickname && isstring(result[k].name) then
	      ply:SendLua( "chat.AddText( Color( 0, 183, 91 ), '[FL ROLEPLAY] ', Color( 235, 235, 235 ), 'Данный ник уже занят!' )" )
				can_change_name = false
	    end
		end

    if can_change_name then
			database.orm.update("users", {
				name = nickname
			}, {
				name = ply:Name()
			})

      netstream.Start(player.GetAll(), "RPCommands", Color(240, 240, 240), ply, Color(240, 240, 240), " сменил свой ник на ", team.GetColor(ply:Team()), nickname, Color(240, 240, 240), "." )
			ply:SetNWString( "fl_name", nickname )
    end
  end)
end

flrp.cmd.add("name", ChangeName)
flrp.cmd.add("rpname", ChangeName)

function AdvertMassage( ply, cmd, args )
	table.remove(args, 1)
	netstream.Start(player.GetAll(), "RPCommands", Color(8, 219, 114), "[Рация] ", team.GetColor(ply:Team()), ply:Nick(), Color(255, 255, 255, 255), ": ", Color(225, 225, 0, 255),  string.Implode( " ", args )  )
end

flrp.cmd.add("advert", AdvertMassage)
flrp.cmd.add("ad", AdvertMassage)
flrp.cmd.add("radio", AdvertMassage)

function DropWeapon( ply, cmd, args )
	if (ply:GetActiveWeapon():GetClass() == "weapon_handcuffed") then return end
	if (ply:GetActiveWeapon():GetClass() == "weapon_hands") then return end
	if (ply:GetActiveWeapon():GetClass():find("cw")) then ply:ConCommand("cw_dropweapon") else ply:DropWeapon(ply:GetActiveWeapon()) end
end

flrp.cmd.add("drop", DropWeapon)
flrp.cmd.add("dropweapon", DropWeapon)
flrp.cmd.add("dropgun", DropWeapon)

function MeMassage( ply, cmd, args )
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "ChatMassage", {
		ply = ply,
		pre = "",
		color = team.GetColor(ply:Team()),
		text = string.Implode( " ", args ),
		postcolor = false,
	} )
end
flrp.cmd.add("me", MeMassage)

function RollMassage( ply, cmd, args )
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "RPCommands", ply, Color(240, 240, 240, 255), " кинул кости и выпало ", Color(0, 165, 240, 255), math.random(1, 100), Color(240, 240, 240, 255), "." )
end
flrp.cmd.add("roll", RollMassage)

function TryMassage( ply, cmd, args )
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
		table.insert(tblPlayers, v)
	end
	local try = math.random(0, 6)%2 == 1 and "неудачно" or "удачно"
	netstream.Start(tblPlayers, "RPCommands", team.GetColor(ply:Team()), ply, Color(240, 240, 240, 255), " ", string.Implode( " ", args ), " - ", Color(0, 165, 240, 255), try, Color(240, 240, 240, 255), "."  )
end
flrp.cmd.add("try", TryMassage)

function DoMassage( ply, cmd, args )
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "RPCommands", Color(238, 50, 57), "[Третье Лицо]", team.GetColor(ply:Team()), ply:Nick(), Color(240, 240, 240, 255), ": ", string.Implode( " ", args )  )
end
flrp.cmd.add("do", DoMassage)

function LOOCMessage( ply, cmd, args )
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "RPCommands", Color(238, 50, 57), "[LOOC] ", team.GetColor(ply:Team()), ply:Nick(), Color(240, 240, 240, 255), ": ", string.Implode( " ", args )  )
end
flrp.cmd.add("looc", LOOCMessage)
flrp.cmd.add("l", LOOCMessage)

function YellMessage( ply, cmd, args )
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 500)) do
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "RPCommands", Color(255, 120, 57), "(Крик) ", team.GetColor(ply:Team()), ply:Nick(), Color(240, 240, 240, 255), ": ", string.Implode( " ", args )  )
end
flrp.cmd.add("yell", YellMessage)
flrp.cmd.add("y", YellMessage)

function WhisperMessage( ply, cmd, args )
	table.remove(args, 1)
	local tblPlayers = {}
	for _, v in pairs(ents.FindInSphere(ply:GetPos(), 150)) do
		table.insert(tblPlayers, v)
	end
	netstream.Start(tblPlayers, "RPCommands", Color(120, 255, 57), "(Шепот) ", team.GetColor(ply:Team()), ply:Nick(), Color(240, 240, 240, 255), ": ", string.Implode( " ", args )  )
end
flrp.cmd.add("whisper", WhisperMessage)
flrp.cmd.add("w", WhisperMessage)

flrp.cmd.add("whitelist", function( ply )
	if ply:GetUserGroup() == "founder" or serverguard.player:GetImmunity(ply) > 20 or ply:GetUserGroup() == "inst" or ply:GetUserGroup() == "cmd" then
		netstream.Start(ply, "WhiteList_OpenMenu", nil)
	end
end)

if SERVER then
	concommand.Add( "flrp", flrp.cmd.callback, flrp.cmd.autoComplete, "." )
	netstream.Hook("flrp.command.SendCommandsToServer", function(ply, data)
		flrp.cmd.callback(ply, data.cmd, data.args)
	end)
else
	concommand.Add( "flrp", function(ply, cmd, args)
		netstream.Start("flrp.command.SendCommandsToServer", {
			args = args,
			cmd = cmd
		})
	end, flrp.cmd.autoComplete, "." )

	netstream.Hook("ChatMassage", function(data)
		pCaller = data.ply
		if pCaller and pCaller:IsPlayer() then
			color, pre = data.color, data.pre
			postcolor = data.postcolor == false and "" or Color(255, 255, 255)
			postname = data.postcolor == false and " " or ": "
			chat.AddText(color, pre, team.GetColor(pCaller:Team()), pCaller:Name(), postcolor, postname, data.text)
		end
	end)

	netstream.Hook("RPCommands", function(...)
		chat.AddText(...)
	end)
end
