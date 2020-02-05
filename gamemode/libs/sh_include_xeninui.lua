XeninUI = XeninUI or {}

function XeninUI:CreateFont(name, size, weight)
	surface.CreateFont(name, {
		font = "Montserrat Medium",
		-- Changing font... to match the old look we had to increase size by two
		size = size + 2,
		weight = weight or 500,
		extended = true
	})
end

function XeninUI:IncludeClient(path)
	if (CLIENT) then
		include("xeninui/" .. path .. ".lua")
	end

	if (SERVER) then
		AddCSLuaFile("xeninui/" .. path .. ".lua")
	end
end

function XeninUI:IncludeServer(path)
	if (SERVER) then
		include("xeninui/" .. path .. ".lua")
	end
end

function XeninUI:IncludeShared(path)
	XeninUI:IncludeServer(path)
	XeninUI:IncludeClient(path)
end

XeninUI:IncludeShared("settings/settings")

XeninUI:IncludeClient("libs/debug")
XeninUI:IncludeClient("libs/animations")
XeninUI:IncludeClient("libs/shadows")
XeninUI:IncludeClient("libs/essentials")
XeninUI:IncludeShared("libs/essentials_sh")
XeninUI:IncludeShared("libs/v0n_sh")
XeninUI:IncludeClient("libs/wyvern")
XeninUI:IncludeClient("libs/time")
XeninUI:IncludeShared("libs/promises")
XeninUI:IncludeShared("libs/languages")
XeninUI:IncludeClient("libs/icon_dl")

XeninUI:IncludeClient("elements/button")
XeninUI:IncludeClient("elements/frame")
XeninUI:IncludeClient("elements/navbar")
XeninUI:IncludeClient("elements/sidebar")
XeninUI:IncludeClient("elements/textentry")
XeninUI:IncludeClient("elements/popup")
XeninUI:IncludeClient("elements/notifications")
XeninUI:IncludeClient("elements/avatar")
XeninUI:IncludeClient("elements/dropdown_popup")
XeninUI:IncludeClient("elements/dropdown_player")
XeninUI:IncludeClient("elements/category")
XeninUI:IncludeClient("elements/scrollpanel")
XeninUI:IncludeClient("elements/checkbox")
XeninUI:IncludeClient("elements/checkbox_v2")
XeninUI:IncludeClient("elements/wyvern_scrollbar")
XeninUI:IncludeClient("elements/wyvern_scrollpanel")
XeninUI:IncludeClient("elements/query")
XeninUI:IncludeClient("elements/query_single_button")
XeninUI:IncludeClient("elements/slider")
XeninUI:IncludeClient("elements/purchase_confirmation")
XeninUI:IncludeClient("elements/panel")
XeninUI:IncludeClient("elements/animated_texture")
XeninUI:IncludeClient("elements/tooltip")
XeninUI:IncludeClient("elements/sidebar_animated")
XeninUI:IncludeClient("elements/sidebar_v2")
XeninUI:IncludeClient("elements/button_v2")
XeninUI:IncludeClient("elements/combobox")

XeninUI:IncludeServer("server/notification")
XeninUI:IncludeServer("server/database")

hook.Run("XeninUI.PreLoadAddons")
hook.Run("XeninUI.Loaded")
hook.Run("XeninUI.PostLoadAddons")
