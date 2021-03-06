--魔界台本「ロマンティック・テラー」
--Abyss Script - Romantic Teller
--Scripted by Eerie Code
function c100409047.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100409047+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100409047.target)
	e1:SetOperation(c100409047.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c100409047.setcon)
	e2:SetTarget(c100409047.settg)
	e2:SetOperation(c100409047.setop)
	c:RegisterEffect(e2)
end
function c100409047.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x10ec) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c100409047.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c100409047.spfilter(c,e,tp,hc)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x10ec)
		and c:GetOriginalCode()~=hc:GetOriginalCode() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocationCountFromEx(tp,tp,c,hc)>0
end
function c100409047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100409047.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100409047.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local hc=Duel.SelectMatchingCard(tp,c100409047.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if hc and Duel.SendtoHand(hc,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100409047.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,hc)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
	end
end
function c100409047.filter2(c)
	return c:IsSetCard(0x10ec) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c100409047.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c100409047.filter2,tp,LOCATION_EXTRA,0,1,nil)
end
function c100409047.setfilter(c)
	return c:IsSetCard(0x20ec) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c100409047.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c100409047.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c100409047.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100409047.setfilter,tp,LOCATION_DECK,0,nil)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),#g)
	if ct<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:Select(tp,1,ct,nil)
	Duel.SSet(tp,sg)
	Duel.ConfirmCards(1-tp,sg)
end
