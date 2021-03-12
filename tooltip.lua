GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("BOTTOMLEFT", 7, 4)
GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", -7, 4)
GameTooltipStatusBar:SetHeight(3)

local position = CreateFrame("Frame", nil, GameTooltip)
position:SetScript("OnShow", function()
  if GameTooltip:GetAnchorType() == "ANCHOR_NONE" then
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -40, 110)
  end
end)
