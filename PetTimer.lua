

local object = CreateFrame("Frame", nil, UIParent) --"PlayerModel"
	
function object:createFrame()
	self:RegisterEvent("VARIABLES_LOADED")
	self:SetWidth(26)
	self:SetHeight(26)
	self:SetClampedToScreen(true) 
	self:SetPoint("CENTER", "PetPortrait", "CENTER", 0, 0)
	self:Show()

	
	local cd = CreateFrame("Cooldown",nil, self)
	cd:SetAllPoints(true)
	cd:SetWidth(55)
	cd:SetHeight(55)
	cd:SetFrameStrata("MEDIUM")
	cd:Hide()


	self.cd = cd

end	

function object:COMBAT_LOG_FILTER(...)

	local timestamp, eventtype, enemyCaster, srcName, srcFlags, _, dstName, dstFlags, spellId = ...
	local coolDown, startElementalCd, priestPetcd
	if eventtype == "SPELL_CAST_SUCCESS" and srcName == UnitName("player") then
		if spellId == 31687 then
			local _, _, _, _, available = GetTalentInfo(3, 26) -- Get talents those increase lifetime of elemental
			startElementalCd = 45
			coolDown = 45 + 5*available	
		
		elseif spellId == 34433 then
			priestPetcd = 15
			coolDown = priestPetcd + 0.3
		end	
		self:showCoolDown(coolDown)	
		
	end	
end--34433

function object:showCoolDown(coolDown)
	self.cd:Show()
	self.cd:SetCooldown(GetTime()-0.40, coolDown)
	self:SetScript("OnUpdate", self.addonUpdate)
end

function object:addonUpdate(elapsed)
	if elapsed >= 50 then 
			self.cd:Hide()
			self:SetScript("OnUpdate", nil)
	end		
end	

local function eventHandler(self,event,...)
	if event == "VARIABLES_LOADED" then object:createFrame() 
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then object:COMBAT_LOG_FILTER(...) 
	end
end

object:RegisterEvent("PLAYER_TARGET_CHANGED")
object:RegisterEvent("VARIABLES_LOADED")
object:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
object:SetScript("OnEvent", eventHandler)


