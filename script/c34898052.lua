--牙竜咆哮
function c34898052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(34898052,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c34898052.cost)
	e1:SetTarget(c34898052.target)
	e1:SetOperation(c34898052.activate)
	c:RegisterEffect(e1)
end
function c34898052.rfilter(c,att)
	return c:IsAttribute(att) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c34898052.filter(c,g,sg)
	if sg:GetCount()==0 then
		if not c:IsAttribute(ATTRIBUTE_EARTH) then return false end
	elseif sg:GetCount()==1 then
		if not c:IsAttribute(ATTRIBUTE_WATER) then return false end
	elseif sg:GetCount()==2 then
		if not c:IsAttribute(ATTRIBUTE_FIRE) then return false end
	elseif sg:GetCount()==3 then
		if not c:IsAttribute(ATTRIBUTE_WIND) then return false end
	end
	sg:AddCard(c)
	local res
	if sg:GetCount()<4 then
		res=g:IsExists(c34898052.filter,1,nil,g,sg)
	else
		res=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c34898052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c34898052.rfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
	if chk==0 then return g:IsExists(c34898052.filter,1,nil,g,Group.CreateGroup()) end
	local rg=Group.CreateGroup()
	while rg:GetCount()<4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,c34898052.filter,1,1,rg,g,rg)
		rg:Merge(sg)
	end
	rg:RemoveCard(e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c34898052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c34898052.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
