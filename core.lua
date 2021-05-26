local _G = _G or getfenv(0)

SLASH_RELOAD1 = '/rl'
function SlashCmdList.RELOAD(msg, editbox) ReloadUI() end

local msgcache = {}
message = function(msg)
  if msgcache[msg] then return end
  DEFAULT_CHAT_FRAME:AddMessage("|cffcccc33INFO: |cffffff55" .. ( msg or "nil" ))
  msgcache[( msg or "nil" )] = true
end
print = message

-- expansion detection
local _, _, _, client = GetBuildInfo()
client = client or 11200

-- detect client expansion
if client >= 20000 and client <= 20400 then
  ST_CLIENT = "tbc"
elseif client >= 30000 and client <= 30300 then
  ST_CLIENT = "wotlk"
else
  ST_CLIENT = "vanilla"
end

-- static expansion variables
if ST_CLIENT == "vanilla" then
  ST_NAMEPLATE_OBJECTORDER = { "border", "glow", "name", "level", "levelicon", "raidicon" }
  ST_NAMEPLATE_FRAMETYPE = "Button"
elseif ST_CLIENT == "tbc" then
  ST_NAMEPLATE_OBJECTORDER = { "border", "castborder", "casticon", "glow", "name", "level", "levelicon", "raidicon" }
  ST_NAMEPLATE_FRAMETYPE = "Frame"
end
