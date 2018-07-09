--アスポート
--Column Switch
--Scripted by Eerie Code
function c37480144.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c37480144.target)
	e1:SetOperation(c37480144.activate)
	c:RegisterEffect(e1)
end
function c37480144.filter(c)
	return c:GetSequence()<5
end
function c37480144.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsInMainMZone(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsInMainMZone,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(37480144,0))
	Duel.SelectTarget(tp,Card.IsInMainMZone,tp,LOCATION_MZONE,0,1,1,nil)
end
function c37480144.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0),2))
end
