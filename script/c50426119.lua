--デグレネード・バスター
--Degrenade Buster
--Script by nekrozar
function c50426119.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c50426119.sprcon)
	e1:SetOperation(c50426119.sprop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50426119,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,50426119)
	e2:SetTarget(c50426119.rmtg)
	e2:SetOperation(c50426119.rmop)
	c:RegisterEffect(e2)
end
function c50426119.sprfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c50426119.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c50426119.sprfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and rg:GetCount()>1 and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0)
end
function c50426119.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c50426119.sprfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c50426119.rmfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk and c:IsAbleToRemove()
end
function c50426119.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local atk=e:GetHandler():GetAttack()
    	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c50426119.rmfilter(chkc,atk) end
    	if chk==0 then return Duel.IsExistingTarget(c50426119.rmfilter,tp,0,LOCATION_MZONE,1,nil,atk) end
   	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
   	local g=Duel.SelectTarget(tp,c50426119.rmfilter,tp,0,LOCATION_MZONE,1,1,nil,atk)
    	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c50426119.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(50426119,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c50426119.retcon)
		e1:SetOperation(c50426119.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c50426119.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(50426119)~=0
end
function c50426119.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
