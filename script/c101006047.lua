--空牙団の大義 フォルゴ
--Folgo, Justice Fur Hire
--Scripted by Eerie Code
function c101006047.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,3,c101006047.lcheck)
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006047,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,101006047)
	e2:SetCondition(c101006047.spcon)
	e2:SetTarget(c101006047.sptg)
	e2:SetOperation(c101006047.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c101006047.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101006047,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101006047+100)
	e4:SetCondition(c101006047.drcon)
	e4:SetTarget(c101006047.drtg)
	e4:SetOperation(c101006047.drop)
	c:RegisterEffect(e4)
end
function c101006047.lcheck(g,lc,tp)
	return g:GetClassCount(Card.GetRace,lc,SUMMON_TYPE_LINK,tp)==#g
end
function c101006047.valcheck(e,c)
	local g=c:GetMaterial()
	local val=0
	for tc in aux.Next(g) do
		val=val|tc:GetRace()
	end
	e:GetLabelObject():SetLabel(val)
end
function c101006047.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and #(e:GetHandler():GetMaterial())==3
end
function c101006047.spfilter(c,e,tp,rc)
	return c:IsSetCard(0x114) and not c:IsRace(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101006047.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101006047.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101006047.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101006047.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c101006047.drcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()~=tp and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c101006047.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101006047.drcfilter,1,nil,tp)
end
function c101006047.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x114)
end
function c101006047.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101006047.drfilter,tp,LOCATION_MZONE,0,nil)
	local ct=1
	if g:GetClassCount(Card.GetCode)>=3 then ct=3 end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c101006047.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101006047.drfilter,tp,LOCATION_MZONE,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,1,REASON_EFFECT)>0 and g:GetClassCount(Card.GetCode)>=3 then
		Duel.BreakEffect()
		Duel.Draw(p,2,REASON_EFFECT)
	end
end
