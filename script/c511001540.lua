--Ancient Gear Double Bite Hound Dog
function c511001540.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,true,true,42878636,2)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c511001540.atkop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511001540,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c511001540.cttg)
	e2:SetOperation(c511001540.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(52846880,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c511001540.descon)
	e4:SetTarget(c511001540.destg)
	e4:SetOperation(c511001540.desop)
	c:RegisterEffect(e4)
end
c511001540.material_setcode=0x7
function c511001540.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c511001540.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c511001540.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c511001540.ctfilter(c,tp)
	return c:IsControler(1-tp) and c:GetCounter(0x1102)==0
end
function c511001540.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511001540.ctfilter,1,nil,tp) end
end
function c511001540.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c511001540.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1102,1)
		tc=g:GetNext()
	end
end
function c511001540.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	local g=Group.CreateGroup()
	if tc:GetCounter(0x1102)>0 then
		g:AddCard(tc)
	end
	if bc:GetCounter(0x1102)>0 then
		g:AddCard(bc)
	end
	g:KeepAlive()
	e:SetLabelObject(g)
	return g:GetCount()>0
end
function c511001540.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g and g:IsExists(Card.IsDestructable,1,nil) end
	g:KeepAlive()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c511001540.desfilter(c)
	return c:IsRelateToBattle() and c:GetCounter(0x1102)>0
end
function c511001540.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c511001540.desfilter,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
