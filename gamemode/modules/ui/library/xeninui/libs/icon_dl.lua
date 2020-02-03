XeninUI.CachedIcons = XeninUI.CachedIcons or {}

if (!file.IsDir("xenin/icons", "DATA")) then
  file.CreateDir("xenin/icons")
end


--[[
	Example of how it works

	local test = {
		-- It checks the first image, if that fails to load then the second, then third, etc..
		-- First one is cusotm, using a cusotm URL n not using png.
		{ id = "dLyjNp", url = "https://i.hizliresim.com", type = "jpg" },
		-- If there's no url specificed it'll use imgur, and if there's no type, it'll use png
		{ id = "4aa0Ka4" }
	}

	-- Example frame
	if (IsValid(XeninUI.frame)) then XeninUI.frame:Remove() end
	XeninUI.frame = vgui.Create("XeninUI.Frame")
	XeninUI.frame:SetSize(800, 600)
	XeninUI.frame:Center()
	XeninUI.frame:MakePopup()

	XeninUI.panel = XeninUI.frame:Add("DPanel")
	XeninUI.panel:Dock(FILL)
	XeninUI:DownloadIcon(XeninUI.panel, test)
	XeninUI.panel.Paint = function(pnl, w, h)
		XeninUI:DrawIcon(8, 8, w - 16, h - 16, pnl)
	end
--]]


local function DownloadImage(tbl)
	local p = XeninUI.Promises.new()

	if (!isstring(tbl.id)) then
		return p:reject("ID invalid")
	end

	local id = tbl.id
	local idLower = id:lower()
	local url = tbl.url or "https://i.imgur.com"
	local type = tbl.type or "png"

	if (XeninUI.CachedIcons[id] and XeninUI.CachedIcons[id] != "Loading") then
		return p:resolve(XeninUI.CachedIcons[id])
	end

	local read = file.Read("xenin/icons/" .. idLower .. "." .. type)
	if (read) then
		XeninUI.CachedIcons[id] = Material("../data/xenin/icons/" .. idLower .. ".png", "smooth")

		return p:resolve(XeninUI.CachedIcons[id])
	end

	http.Fetch(url .. "/" .. id .. "." .. type, function(body)
		local str = "xenin/icons/" .. idLower .. "." .. type
		file.Write(str, body)

		XeninUI.CachedIcons[id] = Material("../data/" .. str, "smooth")

		p:resolve(XeninUI.CachedIcons[id])
	end, function(err)
		p:reject(err)
	end)

	return p
end

function XeninUI:DownloadIcon(pnl, tbl, pnlVar)
	if (!tbl) then return end
	
	local p = XeninUI.Promises.new()

	if (isstring(tbl)) then
		tbl = { { id = tbl } }
	end

	local i = 1
	local function AsyncDownload()
		if (!tbl[i]) then p:reject() end
	
		DownloadImage(tbl[i]):next(function(result)
			p:resolve(result):next(function()
				pnl[pnlVar or "Icon"] = result
			end, function(err)
				ErrorNoHalt(err)
			end)
		end, function(err)
			i = i + 1

			ErrorNoHalt(err)

			AsyncDownload()
		end)
	end

	AsyncDownload()

	return p
end

function XeninUI:DrawIcon(x, y, w, h, pnl, col, loadCol)
	col = col or color_white
	loadCol = loadCol or XeninUI.Theme.Accent

	if (pnl.Icon and type(pnl.Icon) == "IMaterial") then
		surface.SetMaterial(pnl.Icon)
		surface.SetDrawColor(col)
		surface.DrawTexturedRect(x, y, w, h)
	else
		XeninUI:DrawLoadingCircle(h, h, h, loadCol)
  end
end

-- Can be used, but I recommend using :DownloadIcon one as it's more customisable
-- This is preserved for old use
function XeninUI:GetIcon(id)
	local _type = type(id)
	if (_type == "IMaterial") then
		return id
	end
	
	if (self.CachedIcons[id]) then
		return self.CachedIcons[id]
	end

	local read = file.Read("xenin/icons/" .. id:lower() .. ".png")
	if (read) then
		self.CachedIcons[id] = Material("../data/xenin/icons/" .. id:lower() .. ".png", "smooth")
	else
		self.CachedIcons[id] = "Loading"
	end

	http.Fetch("https://i.imgur.com/" .. id .. ".png", function(body, len)
		local str = "xenin/icons/" .. id:lower() .. ".png"
		file.Write(str, body)

		self.CachedIcons[id] = Material("../data/" .. str, "smooth")
	end)
end