local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
taR = {}
Tunnel.bindInterface("puzzle_turtles",taR)
config = module("puzzle_turtles","config")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local reward = 100

function taR.checkSpaceAndPayment(espaco,pagamento)
	local user_id = vRP.getUserId(source)
	local amount = math.random(config.minTurtleAmount, config.maxTurtleAmount)
	if user_id then

		if espaco == true then
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(config.item)*amount <= vRP.getInventoryMaxWeight(user_id) then
				return true
			end

		elseif pagamento == true then
			vRP.giveInventoryItem(user_id,config.item,amount)
			TriggerClientEvent("Notify",source,"sucesso","Você pegou <b>"..amount.."x</b> Tartarugas.") 
		end

	end
end

function taR.sellTurtles()
	local user_id = vRP.getUserId(source)
	if user_id then
		local amount = vRP.getInventoryItemAmount(user_id,config.item)
		if amount <= 0 then TriggerClientEvent("Notify",source,"negado","Você não tem Tartarugas para vender.") return end
		vRP.tryGetInventoryItem(user_id,config.item,amount)

		if config.dirtyMoney == true then
			vRP.giveInventoryItem(user_id,config.dirtyItem, reward * amount)
		else
			vRP.giveMoney(user_id,reward * amount)
		end

		TriggerClientEvent("Notify",source,"sucesso","Você vendeu <b>"..amount.."x</b> Tartarugas.") 
	end
end
