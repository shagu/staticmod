local _G = _G or getfenv(0)

table.insert(UISpecialFrames, "WorldMapFrame")

function _G.ToggleWorldMap()
  if WorldMapFrame:IsShown() then
    WorldMapFrame:Hide()
  else
    WorldMapFrame:Show()
  end
end

local delay = CreateFrame("Frame")
delay:RegisterEvent("PLAYER_ENTERING_WORLD")
delay:SetScript("OnEvent", function()
  -- do not load if other map addon is loaded
  if Cartographer then return end
  if METAMAP_TITLE then return end

  UIPanelWindows["WorldMapFrame"] = { area = "center" }

  WorldMapFrame:SetScript("OnShow", function()
    -- default events
    UpdateMicroButtons()
    PlaySound("igQuestLogOpen")
    CloseDropDownMenus()
    SetMapToCurrentZone()
    WorldMapFrame_PingPlayerPosition()

    -- customize
    this:EnableKeyboard(false)
    this:EnableMouseWheel(1)
  end)

  WorldMapFrame:SetScript("OnMouseWheel", function()
    if IsShiftKeyDown() then
      WorldMapFrame:SetAlpha(WorldMapFrame:GetAlpha() + arg1/10)
    elseif IsControlKeyDown() then
      WorldMapFrame:SetScale(WorldMapFrame:GetScale() + arg1/10)
    end
  end)

  WorldMapFrame:SetScript("OnMouseDown",function()
    WorldMapFrame:StartMoving()
  end)

  WorldMapFrame:SetScript("OnMouseUp",function()
    WorldMapFrame:StopMovingOrSizing()
  end)

  WorldMapFrame:SetMovable(true)
  WorldMapFrame:EnableMouse(true)

  WorldMapFrame:SetScale(.85)
  WorldMapFrame:ClearAllPoints()
  WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 30)
  WorldMapFrame:SetWidth(WorldMapButton:GetWidth() + 15)
  WorldMapFrame:SetHeight(WorldMapButton:GetHeight() + 55)
  BlackoutWorld:Hide()

  -- coordinates
  if not WorldMapButton.coords then
    WorldMapButton.coords = CreateFrame("Frame", "pfWorldMapButtonCoords", WorldMapButton)
    WorldMapButton.coords.text = WorldMapButton.coords:CreateFontString(nil, "OVERLAY")
    WorldMapButton.coords.text:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOMLEFT", 3, -21)
    WorldMapButton.coords.text:SetFontObject(GameFontWhite)
    WorldMapButton.coords.text:SetTextColor(1, 1, 1)
    WorldMapButton.coords.text:SetJustifyH("RIGHT")

    WorldMapButton.coords:SetScript("OnUpdate", function()
      local width  = WorldMapButton:GetWidth()
      local height = WorldMapButton:GetHeight()
      local mx, my = WorldMapButton:GetCenter()
      local scale  = WorldMapButton:GetEffectiveScale()
      local x, y   = GetCursorPosition()

      mx = (( x / scale ) - ( mx - width / 2)) / width * 100
      my = (( my + height / 2 ) - ( y / scale )) / height * 100

      if MouseIsOver(WorldMapButton) then
        WorldMapButton.coords.text:SetText(string.format('|cffffcc00Coordinates: |r%.1f / %.1f', mx, my))
      else
        WorldMapButton.coords.text:SetText("")
      end
    end)
  end
end)
