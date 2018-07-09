--創星神 sophia
function c4335427.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c4335427.spcon)
	e1:SetOperation(c4335427.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4335427,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c4335427.rmtg)
	e4:SetOperation(c4335427.rmop)
	c:RegisterEffect(e4)
end
function c4335427.spfilter(c,tpe)
	return c:IsFaceup() and c:IsType(tpe) and c:IsAbleToRemoveAsCost()
end
function c4335427.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c4335427.chk,1,nil,sg,Group.CreateGroup(),TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ)
end
function c4335427.chk(c,sg,g,tpe,...)
	if not c:IsType(tpe) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c4335427.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function c4335427.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c4335427.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_RITUAL)
	local g2=Duel.GetMatchingGroup(c4335427.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_FUSION)
	local g3=Duel.GetMatchingGroup(c4335427.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_SYNCHRO)
	local g4=Duel.GetMatchingGroup(c4335427.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_XYZ)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	g:Merge(g4)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4 and g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 and g4:GetCount()>0 
		and aux.SelectUnselectGroup(g,e,tp,4,4,c4335427.rescon,0)
end
function c4335427.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c4335427.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	local sg=aux.SelectUnselectGroup(g,e,tp,4,4,c4335427.rescon,1,tp,HINTMSG_REMOVE)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c4335427.rmfilter(c)
	return c:IsAbleToRemove() and (c:IsLocation(0x0a) or aux.SpElimFilter(c,false,true))
end
function c4335427.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c4335427.rmfilter,tp,0x1e,0x1e,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c4335427.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c4335427.rmfilter,tp,0x1e,0x1e,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
