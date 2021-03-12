local _G = _G or getfenv(0)
local classcolors = staticmod_config["classcolor"]


-- enable class color backgrounds
local original = TargetFrame_CheckFaction
function TargetFrame_CheckFaction(self)
  original(self)

	if UnitPlayerControlled("target") and classcolors then
	  local _, class = UnitClass("player")
	  local class = RAID_CLASS_COLORS[class] or { r = .5, g = .5, b = .5, a = 1 }
	  TargetFrameNameBackground:SetVertexColor(class.r, class.g, class.b, 1)
	end
end

local _, class = UnitClass("player")
local class = RAID_CLASS_COLORS[class] or { r = .5, g = .5, b = .5, a = 1 }

-- add name background to player frame
PlayerFrameNameBackground = PlayerFrame:CreateTexture(nil, "LOW")
PlayerFrameNameBackground:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")
PlayerFrameNameBackground:SetWidth(119)
PlayerFrameNameBackground:SetHeight(19)
PlayerFrameNameBackground:SetPoint("TOPLEFT", 106, -22)
PlayerFrameNameBackground:SetVertexColor(class.r, class.g, class.b, 1)
