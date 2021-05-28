local _G = _G or getfenv(0)
local darken = staticmod_config["darken"]

local function HookAddonOrVariable(addon, func)
  local lurker = CreateFrame("Frame", nil)
  lurker.func = func
  lurker:RegisterEvent("ADDON_LOADED")
  lurker:RegisterEvent("VARIABLES_LOADED")
  lurker:RegisterEvent("PLAYER_ENTERING_WORLD")
  lurker:SetScript("OnEvent",function()
    -- only run when config is available
    if event == "ADDON_LOADED" and not this.foundConfig then
      return
    elseif event == "VARIABLES_LOADED" then
      this.foundConfig = true
    end

    if IsAddOnLoaded(addon) or _G[addon] then
      this:func()
      this:UnregisterAllEvents()
    end
  end)
end

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
  ["PetHappiness"] = true,
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
  ["ShapeshiftButton"] = 3,
  ["BuffButton"] = 3,
  ["TempEnchant"] = 3,
  ["SpellButton"] = 3,
  ["SpellBookSkillLineTab"] = 3,
  ["ActionButton"] = 3,
  ["MultiBar(.+)Button"] = 3,
  ["Character(.+)Slot$"] = 3,
  ["ContainerFrame(.+)Item"] = 3,
  ["MainMenuBarBackpackButton$"] = 3,
  ["CharacterBag(.+)Slot$"] = 3,
  ["ChatFrame(.+)Button"] = -2,
  ["PetFrameHappiness"] = 1,
  ["MicroButton"] = { -20, 1, 1, 1 },
}

-- sizing is a bit different on tbc
if ST_CLIENT == "tbc" then
  borders["BuffButton"] = 2
  borders["TempEnchant"] = 2
  borders["MicroButton"] = { -22, -1, -1, -1 }
end

local function AddSpecialBorder(frame, inset)
  local top, right, bottom, left

  if type(inset) == "table" then
    top, right, bottom, left = unpack((inset))
    left, bottom = -left, -bottom
  end

  if not frame.staticmod_border then
    frame.staticmod_border = CreateFrame("Frame", nil, frame)
    frame.staticmod_border:SetPoint("TOPLEFT", frame, "TOPLEFT", (left or -inset), (top or inset))
    frame.staticmod_border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", (right or inset), (bottom or -inset))
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

local name, original, r, g, b
local hookBuffButton_Update = BuffButton_Update
function BuffButton_Update(buttonName, index, filter)
  hookBuffButton_Update(buttonName, index, filter)

  -- tbc passes buttonName and index arguments, vanilla uses "this" context
  name = buttonName and index and buttonName .. index or this:GetName()
  original = _G[name.."Border"]

  if original and this.staticmod_border then
    r, g, b = original:GetVertexColor()
    this.staticmod_border:SetBackdropBorderColor(r, g, b, 1)
    original:SetAlpha(0)
  elseif not original and _G[name] then
    -- tbc buff buttons don't have borders, so we
    -- need to manually add a dark one.
    AddSpecialBorder(_G[name], 2)
  end
end

local hookBuffFrame_Enchant_OnUpdate = BuffFrame_Enchant_OnUpdate
function BuffFrame_Enchant_OnUpdate(elapsed)
  hookBuffFrame_Enchant_OnUpdate(elapsed)

  -- return early without any weapon enchants
  local mh, _, _, oh = GetWeaponEnchantInfo()
	if not mh and not oh then return end

  -- update weapon enchant 1
  AddSpecialBorder(TempEnchant1, 3)
  local r, g, b = GetItemQualityColor(GetInventoryItemQuality("player", TempEnchant1:GetID()) or 1)
  TempEnchant1.staticmod_border:SetBackdropBorderColor(r,g,b,1)
  TempEnchant1Border:SetAlpha(0)

  -- update weapon enchant 2
  AddSpecialBorder(TempEnchant2, 3)
  local r, g, b = GetItemQualityColor(GetInventoryItemQuality("player", TempEnchant2:GetID()) or 1)
  TempEnchant2.staticmod_border:SetBackdropBorderColor(r,g,b,1)
  TempEnchant2Border:SetAlpha(0)
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
  if frame and frame.GetRegions then
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

  if MinimapClock then -- vanilla
    MinimapClock:SetBackdropBorderColor(.2,.2,.2,1)
    MinimapClock:SetBackdropColor(.2,.2,.2,1)
  else -- tbc
    HookAddonOrVariable("Blizzard_TimeManager", function()
      DarkenFrame(TimeManagerClockButton)
    end)
  end

  local function IsNamePlate(frame)
    if frame:GetObjectType() ~= ST_NAMEPLATE_FRAMETYPE then return nil end
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
