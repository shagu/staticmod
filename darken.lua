local _G = _G or getfenv(0)
local darken = staticmod_config["darken"]

local border = {
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 8, edgeSize = 16,
  insets = { left = 0, right = 0, top = 0, bottom = 0 }
}

local blacklist = {
  ["Solid Texture"] = true,
  ["WHITE8X8"] = true,
  ["StatusBar"] = true,
  ["Portrait"] = true,
  ["Button"] = true,
  ["Icon"] = true,
  ["AddOns"] = true,
  ["Material"] = true,
}

local function IsBlacklisted(texture)
  local name = texture:GetName()
  local texture = texture:GetTexture()

  if not texture then return true end

  if name then -- also apply blacklist to names
  end

  for entry in pairs(blacklist) do
    if string.find(texture, entry, 1) then return true end
  end

  return nil
end

local function DarkenBorder(texture, frame)
  frame:SetBackdropBorderColor(.2, .2, .2, 1)
  if not frame or frame:GetWidth() ~= 32 or frame:GetHeight() ~= 32 then return end
  if texture and frame and not frame.staticmod_backdrop and string.find(texture, "Button", 1) then
    frame.staticmod_backdrop = CreateFrame("Frame", nil, frame)
    frame.staticmod_backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    frame.staticmod_backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    frame.staticmod_backdrop:SetBackdrop(border)
    frame.staticmod_backdrop:SetBackdropBorderColor(.2, .2, .2, 1)
  end
end

local function SetVertex(frame, r, g, b, a)
  -- set defaults
  if not r and not g and not b then
    r, g, b, a = .2, .2, .2, 1
  end

  -- iterate through all subframes
  if frame and frame.GetChildren then
    for _, frame in pairs({frame:GetChildren()}) do
      SetVertex(frame, r, g, b, a)
    end
  end

  -- set vertex on all regions
  if frame.GetRegions then
    for _, region in pairs({frame:GetRegions()}) do
      if region.SetVertexColor and region:GetObjectType() == "Texture" then
        DarkenBorder(region:GetTexture(), frame)

        if not IsBlacklisted(region) then
          region:SetVertexColor(r,g,b,a)
        end
      end
    end
  end
end

if darken then
  SetVertex(UIParent)
  MinimapClock:SetBackdropBorderColor(.2,.2,.2,1)
  MinimapClock:SetBackdropColor(.2,.2,.2,1)
end
