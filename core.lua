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




