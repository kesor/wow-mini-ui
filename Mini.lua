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
    ComboPointPlayerFrame.Background:Hide()
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("LEFT", "SpellActivationOverlayFrame", "RIGHT", 100, 0)
    TargetFrameTextureFrameTexture:Hide()
    TargetFrameNameBackground:SetTexture(0.0, 0.0, 0.0, 0.5)
    FocusFrame:ClearAllPoints()
    FocusFrame:SetPoint("BOTTOMLEFT", "SpellActivationOverlayFrame", "TOPRIGHT", 100, 0)
    FocusFrameTextureFrameTexture:Hide()
    FocusFrameNameBackground:SetTexture(0.0, 0.0, 0.0, 0.5)
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
  self.eventframe:RegisterEvent("MERCHANT_SHOW")
  self.eventframe:SetScript("OnEvent", function(x, event, ...)
    Mini:SellJunk()
    Mini:Repair()
  end)
end

Mini:init()
Mini.init = nil

_G["Mini"] = Mini