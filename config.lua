---------------------------------------------
-- Nosso Discord
-- https://discord.gg/UajwX4a
---------------------------------------------

local config = {}

-- Coordenada Para Inicar o Serviçp
config.startLoc = vector3( 3211.51, 5339.55, 5.21 )

-- Tempo da Animação
config.animTime = 3

-- Locais onde estão as tartarugas
config.locs = {
	{ 3223.13,5342.82,4.10 }, 
	{ 3218.07,5342.92,4.69 },
	{ 3215.46,5346.26,5.65 }, 
	{ 3208.99,5348.94,7.30 }, 
	{ 3205.28,5348.01,7.87 }, 
	{ 3202.35,5343.38,7.46 }, 
	{ 3207.75,5341.56,6.23 }, 
	{ 3217.16,5338.93,4.19 }, 
	{ 3216.73,5333.57,3.16 }, 
	{ 3212.97,5328.58,2.94 }, 
	{ 3210.44,5321.48,2.54 }, 
	{ 3205.94,5328.54,4.40 }, 
	{ 3208.14,5332.78,4.48 }, 
	{ 3202.81,5336.00,5.94 }, 
	{ 3213.20,5312.99,1.50 }
}

-- Coordenada Para Vender as Tartarugas
config.sellLoc = vector3( 3807.85, 4478.56, 6.37 )

-- Valor a Receber por Plantar a Flores
config.reward = 150

-- Quantidade de Tartarugas Ganhas por Blip
config.minTurtleAmount = 2
config.maxTurtleAmount = 5

-- Index do ítem Tartaruga
config.item = "tartaruga"

-- Pagamento por Dinheiro Sujo ?
config.dirtyMoney = true
config.dirtyItem = "dinheirosujo"

return config