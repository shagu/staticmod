-- set tooltip backdrop
GameTooltip:SetBackdrop({
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 8, edgeSize = 16,
  insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
GameTooltip:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
GameTooltip:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)

-- resize and move statusbar to bottom
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("BOTTOMLEFT", 7, 4)
GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", -7, 4)
GameTooltipStatusBar:SetHeight(3)

-- change position to match the right chat
local position = CreateFrame("Frame", nil, GameTooltip)
position:SetScript("OnShow", function()
  if GameTooltip:GetAnchorType() == "ANCHOR_NONE" then
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -40, 110)
  end
end)
