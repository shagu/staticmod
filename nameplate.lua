-- tbc does not allow to rescale nameplates (secure_frames)
if ST_CLIENT == "tbc" then return end

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
        local owidth = plate:GetWidth()
        local oheight = plate:GetHeight()

        -- create new plate
        local new = CreateFrame("Frame", nil, plate)
        new:SetScale(UIParent:GetScale())
        new:SetAllPoints(plate)
        new.plate = plate

        local healthbar = plate:GetChildren()
        healthbar:SetParent(new)

        plate:SetWidth(owidth*UIParent:GetScale())
        plate:SetHeight(oheight*UIParent:GetScale())

        for i, object in pairs({plate:GetRegions()}) do
          object:SetParent(new)
        end

        new:SetScript("OnShow", function()
          -- adjust sizes
          this:SetScale(UIParent:GetScale())
          this.plate:SetWidth(owidth*UIParent:GetScale())
          this.plate:SetHeight(oheight*UIParent:GetScale())
        end)

        registry[plate] = plate
      end
    end

    initialized = parentcount
  end
end)
