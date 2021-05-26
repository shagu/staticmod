local _G = _G or getfenv(0)

-- hide daytime circle
GameTimeFrame:Hide()
GameTimeFrame:SetScript("OnShow", function() this:Hide() end)

-- squared minimap
if staticmod_config["minimapsquare"] then
  MinimapBorder:SetTexture(nil)
  Minimap:SetPoint("CENTER", MinimapCluster, "TOP", 9, -98)
  Minimap:SetMaskTexture("Interface\\BUTTONS\\WHITE8X8")
  Minimap.border = CreateFrame("Frame", nil, Minimap)
  Minimap.border:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -3, 3)
  Minimap.border:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 3, -3)
  Minimap.border:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }})

  Minimap.border:SetBackdropBorderColor(.9,.8,.5,1)
  Minimap.border:SetBackdropColor(.4,.4,.4,1)
else
  Minimap:SetMaskTexture("Textures\\MinimapMask")
end

-- hide minimap zone background
MinimapBorderTop:Hide()
MinimapToggleButton:Hide()
MinimapZoneTextButton:SetPoint("CENTER", 10, 85)

-- hide zoom buttons and enable mousewheel
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function()
  if(arg1 > 0) then Minimap_ZoomIn() else Minimap_ZoomOut() end
end)

if ST_CLIENT == "vanilla" then -- add a clock
  MinimapClock = CreateFrame("Frame", "Clock", Minimap)
  MinimapClock:SetFrameStrata("HIGH")
  MinimapClock:SetPoint("BOTTOM", MinimapCluster, "BOTTOM", 8, 15)
  MinimapClock:SetWidth(50)
  MinimapClock:SetHeight(25)
  MinimapClock:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }})
  MinimapClock:SetBackdropBorderColor(.9,.8,.5,1)
  MinimapClock:SetBackdropColor(.4,.4,.4,1)

  MinimapClock.text = MinimapClock:CreateFontString("Status", "LOW", "GameFontNormal")
  MinimapClock.text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
  MinimapClock.text:SetAllPoints(MinimapClock)
  MinimapClock.text:SetFontObject(GameFontWhite)
  MinimapClock:SetScript("OnUpdate", function()
    this.text:SetText(date("%H:%M"))
  end)
end
