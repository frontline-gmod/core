local PANEL = {}
AccessorFunc(PANEL, "m_body", "Body")

XeninUI:CreateFont("XeninUI.SidebarV2.Name", 20)
XeninUI:CreateFont("XeninUI.SidebarV2.Desc", 16)
XeninUI:CreateFont("XeninUI.SidebarV2.DescSmall", 14)

function PANEL:Init()
  self.Scroll = self:Add("XeninUI.ScrollPanel")
  self.Scroll:Dock(FILL)
  self.Scroll.VBar:SetWide(0)

  self.Sidebar = {}
  self.Panels = {}
end

function PANEL:CreateDivider(startCol, endCol)
  startCol = startCol or Color(164, 43, 115)
  endCol = endCol or Color(198, 66, 110)

  local divider = self.Scroll:Add("DPanel")
  divider:Dock(TOP)
  divider:SetTall(10)
  divider.Paint = function(pnl, w, h)
    local aX, aY = pnl:LocalToScreen()

    draw.SimpleLinearGradient(aX + 4, aY + 4, w - 8, h - 8, startCol, endCol, true)
  end
end

function PANEL:CreatePanel(name, desc, panelClass, icon, tbl)
  tbl = tbl or {}
  tbl.colors = tbl.colors or {}
  local startCol = tbl.colors[1] or Color(158, 53, 210)
  local endCol = tbl.colors[2] or Color(109, 77, 213)

  local btn = self.Scroll:Add("DButton")
  btn:Dock(TOP)
  btn.Name = name
  btn.Desc = desc or ""
  btn.Icon = icon
  btn.Tbl = tbl
  btn:SetTall(tbl.Height or 64)
  btn:SetText("")
  btn.GradientAlpha = 0
  btn.SmallFont = btn.Desc:len() > 20
  btn.DescFont = !btn.SmallFont and "XeninUI.SidebarV2.Desc" or "XeninUI.SidebarV2.DescSmall"
  XeninUI:DownloadIcon(btn, icon)
  btn.Paint = function(pnl, w, h)
    local aX, aY = pnl:LocalToScreen()
    draw.SimpleLinearGradient(aX, aY, w, h, ColorAlpha(startCol, pnl.GradientAlpha), ColorAlpha(endCol, pnl.GradientAlpha), true)

    local x = icon and h or 12
    XeninUI:DrawIcon(16, 16, h - 32, h - 32, pnl)

    XeninUI:DrawShadowText(name, "XeninUI.SidebarV2.Name", x, h / 2 + (pnl.SmallFont and 1 or 0), color_white, TEXT_ALIGN_LEFT, desc and TEXT_ALIGN_BOTTOM or TEXT_ALIGN_CENTER, 1, 125)
    if (desc) then
      XeninUI:DrawShadowText(desc, pnl.DescFont, x, h / 2 + (pnl.SmallFont and 1 or 0), Color(171, 171, 171), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, 125)
    end
  end
  btn.OnCursorEntered = function(pnl)
    if (self.Active == btn.Id) then return end

    pnl:Lerp("GradientAlpha", 127.5)
  end
  btn.OnCursorExited = function(pnl)
    if (self.Active == btn.Id) then return end

    pnl:Lerp("GradientAlpha", 0)
  end
  btn.DoClick = function(pnl)
    self:SetActive(pnl.Id)
  end

  local body = self:GetBody():Add(panelClass or "DPanel")
  if (!IsValid(body)) then
    Error("Failed to create panel for " .. tostring(panelClass))
  end
  body:Dock(FILL)
  body.Data = tbl
  body:SetVisible(false)

  table.insert(self.Panels, body)

  local id = table.insert(self.Sidebar, btn)
  self.Sidebar[id].Id = id
end

function PANEL:SetActive(id)
  local active = self.Active
  self.Active = id

  if (IsValid(self.Sidebar[active])) then
    self.Sidebar[active]:OnCursorExited()

    if (IsValid(self.Panels[active])) then
      self.Panels[active]:SetVisible(false)
    end
  end
  
  if (IsValid(self.Sidebar[id])) then
    self.Sidebar[id]:Lerp("GradientAlpha", 255)

    if (IsValid(self.Panels[id])) then
      self.Panels[id]:SetVisible(true)

      if (self.Panels[id].OnSwitchedTo) then
        self.Panels[id]:OnSwitchedTo(self.Panels[id].Data)
      end
    end
  end
end

function PANEL:SetActiveByName(name)
  for i, v in ipairs(self.Sidebar) do
    if (v.Name == name) then
      self:SetActive(i)

      break
    end
  end
end

function PANEL:Paint(w, h)
  XeninUI:DrawRoundedBoxEx(6, 0, 0, w, h, XeninUI.Theme.Primary, false, false, true, false)
end

vgui.Register("XeninUI.SidebarV2", PANEL)