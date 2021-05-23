local _G = _G or getfenv(0)

local onload = CreateFrame("Frame", nil, UIParent)
onload:RegisterEvent("PLAYER_ENTERING_WORLD")
onload:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
onload:Hide()

local function JoinWorld()
  -- join /world chat automatically
  JoinChannelByName("World")
  ChatFrame_AddChannel(ChatFrame3, "World")
  this.init = true
end

local function SetupChat()
  -- close all chat windows
  for i=1, NUM_CHAT_WINDOWS do
    local frame = _G["ChatFrame"..i]
    FCF_Close(frame)

    local editbox = _G["ChatFrame"..i.."EditBox"]
  end

  -- disable <Alt> requirement to move cursor
  if ChatFrameEditBox then
    ChatFrameEditBox:SetAltArrowKeyMode(false)
  elseif ChatFrame1EditBox then
    ChatFrame1EditBox:SetAltArrowKeyMode(false)
  end

  -- create chat windows (update titles)
  FCF_SetWindowName(ChatFrame1, GENERAL)
  FCF_SetWindowName(ChatFrame2, COMBAT_LOG)
  FCF_SetWindowName(ChatFrame3, "Loot & Spam")

  FCF_UnDockFrame(ChatFrame3)
  FCF_SetTabPosition(ChatFrame3, 0)

  ChatFrame3:Show()

  -- add channels to chat windows
  ChatFrame_RemoveAllMessageGroups(ChatFrame1)
  ChatFrame_RemoveAllMessageGroups(ChatFrame2)
  ChatFrame_RemoveAllMessageGroups(ChatFrame3)

  ChatFrame_RemoveAllChannels(ChatFrame1)
  ChatFrame_RemoveAllChannels(ChatFrame2)
  ChatFrame_RemoveAllChannels(ChatFrame3)

  local left = { "SYSTEM", "SAY", "YELL", "WHISPER", "PARTY", "GUILD",
    "GUILD_OFFICER", "CREATURE", "CHANNEL", "EMOTE", "RAID", "RAID_LEADER",
    "RAID_WARNING", "BATTLEGROUND", "BATTLEGROUND_LEADER" }

  local right = { "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN",
    "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "MONSTER_SAY",
    "MONSTER_EMOTE", "MONSTER_YELL", "MONSTER_WHISPER", "MONSTER_BOSS_EMOTE",
    "MONSTER_BOSS_WHISPER" }

  for _,group in pairs(left) do
    ChatFrame_AddMessageGroup(ChatFrame1, group)
  end

  for _,group in pairs(right) do
    ChatFrame_AddMessageGroup(ChatFrame3, group)
  end

  ChatFrame_ActivateCombatMessages(ChatFrame2)

  for _, chan in pairs({EnumerateServerChannels()}) do
    ChatFrame_AddChannel(ChatFrame3, chan)
    ChatFrame_RemoveChannel(ChatFrame1, chan)
  end

  for i=1, NUM_CHAT_WINDOWS do
    local frame = _G["ChatFrame"..i]
    FCF_SetWindowColor(frame, 0, 0, 0)
    FCF_SetWindowAlpha(frame, 0)
    FCF_SetLocked(frame, 1)

    frame:SetUserPlaced(1)
    frame:SetWidth(400)
    frame:SetHeight(160)

    -- enable mouse wheel scrolling
    frame:EnableMouseWheel(true)
    frame:SetScript("OnMouseWheel", function()
      if (arg1 > 0) then
        if IsShiftKeyDown() then
          this:ScrollToTop()
        else
          this:ScrollUp()
        end
      elseif (arg1 < 0) then
        if IsShiftKeyDown() then
          this:ScrollToBottom()
        else
          this:ScrollDown()
        end
      end
    end)
  end

  FCF_DockUpdate()
end

onload:SetScript("OnEvent", function()
  this:UnregisterAllEvents()
  this.time = GetTime()
  this:Show()
end)

onload:SetScript("OnUpdate", function()
  -- wait .2 seconds to make sure all other channels
  -- are populated, to avoid having /world on /1
  if this.time + .2 < GetTime() then
    this:Hide()
    SetupChat()
    JoinWorld()
  end
end)
