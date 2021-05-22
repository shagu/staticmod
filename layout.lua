local _G = _G or getfenv(0)

local onload = CreateFrame("Frame")
onload:RegisterEvent("PLAYER_ENTERING_WORLD")
onload:SetScript("OnEvent", function()
  -- unitframes
  PlayerFrame:ClearAllPoints()
  PlayerFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", -200, 200)

  TargetFrame:ClearAllPoints()
  TargetFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 200, 200)

  -- chat
  ChatFrame1:ClearAllPoints()
  ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 40, 110)

  ChatFrame3:ClearAllPoints()
  ChatFrame3:SetPoint("BOTTOMRIGHT", UIParent ,"BOTTOMRIGHT", -40, 110)

  -- right actionbar
  MultiBarRight:ClearAllPoints()
  MultiBarRight:SetPoint("RIGHT", -7, 0)
  MultiBarRight:SetScale(.9)
  MultiBarLeft:SetScale(.9)
end)
