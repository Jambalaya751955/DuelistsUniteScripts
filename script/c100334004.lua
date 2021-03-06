--マイクロ・コーダー
--Micro Coder
--extra material only by edo9300
function c100334004.initial_effect(c)
	--Extra Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetOperation(c100334004.extracon)
	e1:SetValue(c100334004.extraval)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100334004,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,100334004)
	e2:SetCondition(c100334004.thcon)
	e2:SetTarget(c100334004.thtg)
	e2:SetOperation(c100334004.thop)
	c:RegisterEffect(e2)
end
function c100334004.extracon(c,e,tp,sg,mg,lc,og,chk)
	return (sg+mg):Filter(Card.IsLocation,nil,LOCATION_MZONE):IsExists(Card.IsRace,og,1,RACE_CYBERSE) and
	#(sg&sg:Filter(c100334004.flagcheck,nil))<2
end
function c100334004.flagcheck(c)
	return c:GetFlagEffect(100334004)>0
end
function c100334004.extraval(chk,summon_type,e,...)
	local c=e:GetHandler()
	if chk==0 then
		local tp,sc=...
		if not summon_type==SUMMON_TYPE_LINK or not sc:IsSetCard(0x101) or Duel.GetFlagEffect(tp,100334004)>0 then
			return Group.CreateGroup()
		else
			local feff=c:RegisterFlagEffect(100334004,0,0,1)
			local eff=Effect.CreateEffect(c)
			eff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			eff:SetCode(EVENT_ADJUST)
			eff:SetOperation(function(e)feff:Reset() e:Reset() end)
			Duel.RegisterEffect(eff,0)
			return Group.FromCards(c)
		end
	else
		local sg,sc,tp=...
		if summon_type&SUMMON_TYPE_LINK == SUMMON_TYPE_LINK and #sg>0 then
			Duel.Hint(HINT_CARD,tp,100334004)
			Duel.RegisterFlagEffect(tp,100334004,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c100334004.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x101)
end
function c100334004.thfilter(c,chk)
	return ((c:IsSetCard(0x218) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or (chk==1 and c:IsRace(RACE_CYBERSE) and c:IsLevel(4))) and c:IsAbleToHand()
end
function c100334004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100334004.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100334004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100334004.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
