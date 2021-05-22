local _G = _G or getfenv(0)
local classcolors = staticmod_config["classcolor"]
local hidefriendly = staticmod_config["hidefriendly"]

-- enable class color backgrounds
local original = TargetFrame_CheckFaction
function TargetFrame_CheckFaction(self)
  original(self)

  local reaction = UnitReaction("target", "player")

	if UnitPlayerControlled("target") and classcolors then
	  local _, class = UnitClass("target")
	  local class = RAID_CLASS_COLORS[class] or { r = .5, g = .5, b = .5, a = 1 }
	  TargetFrameNameBackground:SetVertexColor(class.r- .2, class.g - .2, class.b - .2, 1)
	  TargetFrameNameBackground:Show()
	elseif hidefriendly and reaction and reaction > 4 then
	  TargetFrameNameBackground:Hide()
  else
	  TargetFrameNameBackground:Show()
  end

  PlayerFrameBackground:SetDrawLayer("BORDER")
  TargetFrameBackground:SetDrawLayer("BORDER")
end

local _, class = UnitClass("player")
local class = RAID_CLASS_COLORS[class] or { r = .5, g = .5, b = .5, a = 1 }

-- add name background to player frame
if classcolors and not hidefriendly then
  PlayerFrameNameBackground = PlayerFrame:CreateTexture(nil, "BACKGROUND")
  PlayerFrameNameBackground:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")
  PlayerFrameNameBackground:SetWidth(119)
  PlayerFrameNameBackground:SetHeight(19)
  PlayerFrameNameBackground:SetPoint("TOPLEFT", 106, -22)
  PlayerFrameNameBackground:SetVertexColor(class.r, class.g, class.b, 1)
end
