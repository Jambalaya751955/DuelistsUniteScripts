--The Greatest Duo of the Seven Emperors
function c511001180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511001180.atkcon)
	e1:SetTarget(c511001180.tgtg)
	e1:SetOperation(c511001180.tgop)
	c:RegisterEffect(e1)
end
function c511001180.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return ep==tp and ((a:IsSetCard(0x1048) and a:IsControler(1-tp)) or (d and d:IsSetCard(0x1048) and d:IsControler(1-tp)))
end
function c511001180.spfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511001180.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chk==0 then return (not ect or ect>=2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCountFromEx(tp)>1
		and Duel.IsExistingMatchingCard(c511001180.spfilter,tp,LOCATION_EXTRA,0,1,nil,20785975,e,tp)
		and Duel.IsExistingMatchingCard(c511001180.spfilter,tp,LOCATION_EXTRA,0,1,nil,67173574,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c511001180.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or (ect and ect<2) or Duel.GetLocationCountFromEx(tp)<=1 then return end
	local g1=Duel.GetMatchingGroup(c511001180.spfilter,tp,LOCATION_EXTRA,0,nil,20785975,e,tp)
	local g2=Duel.GetMatchingGroup(c511001180.spfilter,tp,LOCATION_EXTRA,0,nil,67173574,e,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		local tc=sg1:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			tc=sg1:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
