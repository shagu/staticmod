GameTooltipStatusBar:SetPoint('TOPLEFT',   7, -5)
GameTooltipStatusBar:SetPoint('TOPRIGHT', -7, -5)
GameTooltipStatusBar:SetHeight(4)

local position = CreateFrame("Frame", nil, GameTooltip)
position:SetScript("OnShow", function()
  if GameTooltip:GetAnchorType() == "ANCHOR_NONE" then
    GameTooltip:ClearAllPoints()
    GameTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -40, 110)
  end
end)
