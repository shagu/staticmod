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
  ["BarFill"] = true,
  ["Portrait"] = true,
  ["Button"] = true,
  ["Icon"] = true,
  ["AddOns"] = true,
  ["StationeryTest"] = true,
  ["TargetDead"] = true, -- LootFrame Icon
  ["KeyRing"] = true, -- bag frame
  ["GossipIcon"] = true,
  ["WorldMap\\(.+)\\"] = true,
}

local function IsBlacklisted(texture)
  local name = texture:GetName()
  local texture = texture:GetTexture()
  if not texture then return true end

  if name then
    for entry in pairs(blacklist) do
      if string.find(name, entry, 1) then return true end
    end
  end

  for entry in pairs(blacklist) do
    if string.find(texture, entry, 1) then return true end
  end

  return nil
end

local borders = {
  ["BuffButton"] = 3,
  ["SpellButton"] = 3,
  ["SpellBookSkillLineTab"] = 3,
  ["ActionButton"] = 3,
  ["Character(.+)Slot"] = 3,
  ["ContainerFrame(.+)Item"] = 3,
  ["MainMenuBarBackpackButton"] = 3,
  ["CharacterBag(.+)Slot"] = 3,
  ["ChatFrame(.+)Button"] = -2,
}

local function AddSpecialBorder(frame, inset)
  if not frame.staticmod_border then
    frame.staticmod_border = CreateFrame("Frame", nil, frame)
    frame.staticmod_border:SetPoint("TOPLEFT", frame, "TOPLEFT", -inset, inset)
    frame.staticmod_border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", inset, -inset)
    frame.staticmod_border:SetBackdrop(border)
    frame.staticmod_border:SetBackdropBorderColor(.2, .2, .2, 1)
  end
end

local backgrounds = {
  ["^SpellBookFrame$"] = { 325, 355, 17, -74 },
  ["^QuestLogDetailScrollFrame$"] = {300, 261, 0, 0 },
  ["^QuestFrame(.+)Panel$"] = { 300, 330, 24, -82 },
  ["^GossipFrameGreetingPanel$"] = { 300, 330, 24, -82 },
}

local function AddSpecialBackground(frame, w, h, x, y)
  if frame.staticmod_bg then return end

  frame.Material = frame:CreateTexture(nil, "OVERLAY")
  frame.Material:SetTexture("Interface\\Stationery\\StationeryTest1")
  frame.Material:SetWidth(w)
  frame.Material:SetHeight(h)
  frame.Material:SetPoint("TOPLEFT", frame, x, y)
  frame.Material:SetVertexColor(.8, .8, .8)
end

local function DarkenFrame(frame, r, g, b, a)
  -- set defaults
  if not r and not g and not b then
    r, g, b, a = .2, .2, .2, 1
  end

  -- iterate through all subframes
  if frame and frame.GetChildren then
    for _, frame in pairs({frame:GetChildren()}) do
      DarkenFrame(frame, r, g, b, a)
    end
  end

  -- set vertex on all regions
  if frame.GetRegions then
    -- read name
    local name = frame.GetName and frame:GetName()

    -- set a dark backdrop border color everywhere
    frame:SetBackdropBorderColor(.2, .2, .2, 1)

    -- add special backgrounds to quests and such
    for pattern, inset in pairs(backgrounds) do
      if name and string.find(name, pattern) then AddSpecialBackground(frame, inset[1], inset[2], inset[3], inset[4]) end
    end

    -- add black borders around specified buttons
    for pattern, inset in pairs(borders) do
      if name and string.find(name, pattern) then AddSpecialBorder(frame, inset) end
    end

    -- scan through all regions (textures)
    for _, region in pairs({frame:GetRegions()}) do
      if region.SetVertexColor and region:GetObjectType() == "Texture" then
        if region:GetTexture() and string.find(region:GetTexture(), "UI%-Panel%-Button%-Up") then
          -- region:SetDesaturated(true) -- monochrome buttons
        end

        if not IsBlacklisted(region) then
          region:SetVertexColor(r,g,b,a)
        end
      end
    end
  end
end

if darken then
  TOOLTIP_DEFAULT_COLOR.r = .2
  TOOLTIP_DEFAULT_COLOR.g = .2
  TOOLTIP_DEFAULT_COLOR.b = .2
  TOOLTIP_DEFAULT_BACKGROUND_COLOR.r = .2
  TOOLTIP_DEFAULT_BACKGROUND_COLOR.g = .2
  TOOLTIP_DEFAULT_BACKGROUND_COLOR.b = .2

  DarkenFrame(UIParent)

  DarkenFrame(DropDownList1)
  DarkenFrame(DropDownList2)
  DarkenFrame(DropDownList3)

  DarkenFrame(WorldMapFrame)

  MinimapClock:SetBackdropBorderColor(.2,.2,.2,1)
  MinimapClock:SetBackdropColor(.2,.2,.2,1)

  local function IsNamePlate(frame)
    if frame:GetObjectType() ~= "Button" then return nil end
    regions = frame:GetRegions()

    if not regions then return nil end
    if not regions.GetObjectType then return nil end
    if not regions.GetTexture then return nil end

    if regions:GetObjectType() ~= "Texture" then return nil end
    return regions:GetTexture() == "Interface\\Tooltips\\Nameplate-Border" or nil
  end

  local registry = {}
  local initialized = 0
  local parentcount, childs, plate
  local nameplates = CreateFrame("Frame", nil, UIParent)
  nameplates:SetScript("OnUpdate", function()
    parentcount = WorldFrame:GetNumChildren()
    if initialized < parentcount then
      childs = { WorldFrame:GetChildren() }
      for i = initialized + 1, parentcount do
        plate = childs[i]
        if IsNamePlate(plate) and not registry[plate] then
          DarkenFrame(plate)
          local healthbar = plate:GetChildren()
          registry[plate] = plate
        end
      end

      initialized = parentcount
    end
  end)
end
