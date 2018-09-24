local _, Mini = ...
local eframe = "MiniEventFrame"

function Mini:HideMicroTextures()
  -- AchievementMicroButtonNormalTexture:Hide()
  -- CharacterMicroButtonNormalTexture:Hide()
  -- CollectionsMicroButtonNormalTexture:Hide()
  -- EJMicroButtonNormalTexture:Hide()
  -- GuildMicroButtonNormalTexture:Hide()
  -- HelpMicroButtonNormalTexture:Hide()
  -- LFDMicroButtonNormalTexture:Hide()
  -- MainMenuMicroButtonNormalTexture:Hide()
  -- QuestLogMicroButtonNormalTexture:Hide()
  -- SpellbookMicroButtonNormalTexture:Hide()
  -- StoreMicroButtonNormalTexture:Hide()
  -- TalentMicroButtonNormalTexture:Hide()
end

local function exists(frameName)
  if _G[frameName] then
    return true
  end
  return false
end

local function hide(frameName)
  _G[frameName]:Hide()
end

function Mini:HideActionBarArt()
  MainMenuBarArtFrame.LeftEndCap:Hide()
  MainMenuBarArtFrame.RightEndCap:Hide()
  MainMenuBarArtFrameBackground:Hide()
  MicroButtonAndBagsBar:Hide()
  ActionBarUpButton:Hide()
  ActionBarDownButton:Hide()
  MainMenuBarArtFrame.PageNumber:Hide()
end

function Mini:HideReputationXpOverlay()
  hooksecurefunc(StatusTrackingBarManager, "UpdateBarsShown", function ()
    StatusTrackingBarManager.SingleBarLarge:Hide()
    StatusTrackingBarManager.SingleBarLargeUpper:Hide()
    StatusTrackingBarManager.SingleBarSmall:Hide()
    StatusTrackingBarManager.SingleBarSmallUpper:Hide()
    for i = 1, 4 do
      local bar = StatusTrackingBarManager.bars[i]
      if bar and bar.StatusBar and bar.StatusBar.Background then
        bar.StatusBar.Background:Hide()
      end
    end
  end)
end

function Mini:HideActionButtonsBorder()
  for i = 1, 12 do
    _G["ActionButton"..i.."NormalTexture"]:Hide()
    _G["MultiBarBottomLeftButton"..i.."NormalTexture"]:Hide()
    _G["MultiBarBottomRightButton"..i.."NormalTexture"]:Hide()
    _G["MultiBarRightButton"..i.."NormalTexture"]:Hide()
    _G["MultiBarLeftButton"..i.."NormalTexture"]:Hide()

    if exists("ActionButton"..i.."FloatingBG") then
      hide("ActionButton"..i.."FloatingBG")
    end
    if exists("MultiBarBottomLeftButton"..i.."FloatingBG") then
      hide("MultiBarBottomLeftButton"..i.."FloatingBG")
    end
    if exists("MultiBarBottomRightButton"..i.."FloatingBG") then
      hide("MultiBarBottomRightButton"..i.."FloatingBG")
    end
    if exists("MultiBarRightButton"..i.."FloatingBG") then
      hide("MultiBarRightButton"..i.."FloatingBG")
    end
    if exists("MultiBarLeftButton"..i.."FloatingBG") then
      hide("MultiBarLeftButton"..i.."FloatingBG")
    end
  end
  for i = 1, 10 do
    if _G["StanceButton"..i.."NormalTexture"] then
      _G["StanceButton"..i.."NormalTexture"]:Hide()
    end
  end
end

function Mini:HideStanceBar()
  RegisterStateDriver(StanceBarFrame, "visibility", "hide")
end

function Mini:HideMinimapClutter()
  MiniMapWorldMapButton:Hide()
  MinimapZoomIn:Hide() -- hides the zoom-in-button (+)
  MinimapZoomOut:Hide() -- hides the zoom-out-button (-)
end

function Mini:MoveUnitFrames()
  hooksecurefunc("PlayerFrame_ToPlayerArt",function()
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("RIGHT", "SpellActivationOverlayFrame", "LEFT", -100, 0)
    PlayerFrameTexture:Hide()
    PlayerFrameAlternateManaBarLeftBorder:Hide()
    PlayerFrameAlternateManaBarBorder:Hide()
    PlayerFrameAlternateManaBarRightBorder:Hide()
    PetFrameTexture:Hide()
    ComboPointPlayerFrame.Background:Hide()
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("LEFT", "SpellActivationOverlayFrame", "RIGHT", 100, 0)
    TargetFrameTextureFrameTexture:Hide()
    TargetFrameNameBackground:SetTexture(0.0, 0.0, 0.0, 0.5)
    FocusFrame:ClearAllPoints()
    FocusFrame:SetPoint("BOTTOMLEFT", "SpellActivationOverlayFrame", "TOPRIGHT", 100, 0)
    FocusFrameTextureFrameTexture:Hide()
    FocusFrameNameBackground:SetTexture(0.0, 0.0, 0.0, 0.5)
    FocusFrame:SetFrameStrata(BACKGROUND)
    FocusFrameTextureFramePVPIcon:SetAlpha(0)
  end)
end

function Mini:CompactRaidFrames()
  CompactRaidFrameContainer:ClearAllPoints()
  CompactRaidFrameContainer:SetPoint("TOP", "SpellActivationOverlayFrame", "BOTTOM", 0, -180)
end

function Mini:SellJunk()
  local priceTotal = 0
  for bag = 0, 4 do -- backpack + 5 bags
    for slot = 1, GetContainerNumSlots(bag) do
      local item = GetContainerItemLink(bag, slot)
      if item then
        local grey = string.find(item, "|cff9d9d9d")
        if grey then
          local priceUnit = select(11, GetItemInfo(item)) or 0
          local countUnit = select(2, GetContainerItemInfo(bag, slot))
          if priceUnit > 0 then
            PickupContainerItem(bag, slot)
            PickupMerchantItem()
            DEFAULT_CHAT_FRAME:AddMessage("Sold "..countUnit.." x "..item.." for "..GetMoneyString(priceUnit * countUnit), 0, 255, 255)
            priceTotal = priceTotal + (priceUnit * countUnit)
          end
        end
      end
    end
  end
  if priceTotal > 0 then
    DEFAULT_CHAT_FRAME:AddMessage("Sold grey items for a total profit of "..GetMoneyString(priceTotal), 0, 255, 255)
  end
end

function Mini:Repair()
  if CanMerchantRepair() then
    local priceRepair, canRepair = GetRepairAllCost()
    if canRepair then
      if priceRepair < GetMoney() then
        local guildRepair = false
        RepairAllItems(guildRepair)
        DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaired for "..GetMoneyString(priceRepair), 0, 255, 255)
      else
        DEFAULT_CHAT_FRAME:AddMessage("You do not have enough gold to repair everything", 255, 0, 0)
      end
    else
      -- Repairs are not needed
    end
  end
end

function Mini:ExtraRaidBuffs()
  local maxBuffs = 9
  local maxDebuffs = 9
  hooksecurefunc("CompactUnitFrame_UpdateAuras", function(frame)
    if not frame or frame:IsForbidden() or not frame:GetName():match("^Compact") then
      return
    end
    bf = frame.buffFrames
    for i = 4, maxBuffs do -- position accordingly
      if not bf[i] then
        bf[i] = CreateFrame("Button", frame:GetName().."Buff"..i, frame, "CompactBuffTemplate")
      end
      CompactUnitFrame_SetMaxBuffs(frame, maxBuffs)
      bf[i]:SetSize(bf[1]:GetSize())
      bf[i]:ClearAllPoints()
      bf[i]:SetPoint("BOTTOMRIGHT", bf[i-3], "TOPRIGHT", 0, 0)
    end
    df = frame.debuffFrames
    for i = 4, maxDebuffs do -- position accordingly
      if not df[i] then
        df[i] = CreateFrame("Button", frame:GetName().."Debuff"..i, frame, "CompactDebuffTemplate")
      end
      CompactUnitFrame_SetMaxDebuffs(frame, maxDebuffs)
      df[i]:SetSize(df[1]:GetSize())
      df[i]:ClearAllPoints()
      df[i]:SetPoint("BOTTOMLEFT", df[i-3], "TOPLEFT", 0, 0)
    end
  end)
end

function Mini:CompactUnitFrameBuffCountdown()
  hooksecurefunc("CompactUnitFrame_UtilSetBuff", function(buffFrame, unit, index, filter)
    if not buffFrame or buffFrame:IsForbidden() or not buffFrame:GetName():match("^Compact") then
      return
    end
    local cooldownFrame = _G[buffFrame:GetName().."Cooldown"]
    if not cooldownFrame.text then
      cooldownFrame.text = cooldownFrame:CreateFontString("$parentText", "OVERLAY")
      cooldownFrame.text:SetFont("Fonts\\UbuntuMono-Regular.ttf", 12, "OUTLINE")
      cooldownFrame.text:SetPoint("CENTER")
      cooldownFrame.text:SetJustifyH("RIGHT")
      cooldownFrame.text:SetJustifyV("CENTER")
    end
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter)
    cooldownFrame:SetScript("OnUpdate", function(frame, elapsed)
      timeLeft = expirationTime - GetTime()
      if timeLeft <= 0 then
        return
      elseif timeLeft < 3 then
        cooldownFrame.text:SetText(string.format("%.1f",timeLeft))
        cooldownFrame.text:SetTextColor(1,0,0,1)
      elseif timeLeft < 6 then
        cooldownFrame.text:SetText(string.format("%.1f",timeLeft))
        cooldownFrame.text:SetTextColor(1,1,0,1)
      elseif timeLeft < 10 then
        cooldownFrame.text:SetText(string.format("%.0f",timeLeft))
        cooldownFrame.text:SetTextColor(1,1,1,1)
      elseif timeLeft < 100 then
        cooldownFrame.text:SetText(string.format("%.0f",timeLeft))
        cooldownFrame.text:SetTextColor(0.5,0.5,0.5,1)
      end
    end)
  end)
end

table.indexOf = function(t, object)
  for i = 1, #t do
    if object == t[i] then
      return i
    end
  end
  return nil
end

function Mini:CompactUnitFrameBuffSort()
  local druidPriority = { "Lifebloom", "Rejuvenation", "Regrowth", "Wild Growth", "Cenarion Ward", "Ironbark", "Innervate" }
  hooksecurefunc("CompactUnitFrame_UpdateBuffs", function(frame)
    if not frame or frame:IsForbidden() or not frame.buffFrames or not frame:GetName():match("^Compact") then
      return -- do not mess with protected name plates, especially during combat
    end
    for i=1, frame.maxBuffs do -- first, hide all buffs
      frame.buffFrames[i]:Hide()
    end
    local index = 1 -- iterate over available player buffs
    local frameNum = 1 -- unsorted buff index
    local filter = nil
    repeat
      local buffName = UnitBuff(frame.displayedUnit, index, filter) -- get buff name
      if buffName and CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) then -- only if it needs to be displayed
        local frameIndex = nil -- eventual buff index
        local priority = table.indexOf(druidPriority, buffName)
        if priority then -- from the end
          frameIndex = frame.maxBuffs + 1 - priority
        else -- from the start
          frameIndex = frameNum
          frameNum = frameNum + 1
        end
        CompactUnitFrame_UtilSetBuff(frame.buffFrames[frameIndex], frame.displayedUnit, index, filter)
      end
      index = index + 1
    until not buffName or index > frame.maxBuffs
  end)
end

function Mini:init()
  self.eventframe = CreateFrame("Frame", eframe, UIParent)
  self.eventframe:UnregisterAllEvents()
  Mini:HideActionBarArt()
  Mini:HideActionButtonsBorder()
  Mini:HideReputationXpOverlay()
  Mini:HideMinimapClutter()
  Mini:HideStanceBar()
  Mini:MoveUnitFrames()
  Mini:CompactRaidFrames()
  Mini:ExtraRaidBuffs()
  Mini:CompactUnitFrameBuffCountdown()
  Mini:CompactUnitFrameBuffSort()
  self.eventframe:RegisterEvent("MERCHANT_SHOW")
  self.eventframe:SetScript("OnEvent", function(x, event, ...)
    Mini:SellJunk()
    Mini:Repair()
  end)
end

Mini:init()
Mini.init = nil

_G["Mini"] = Mini