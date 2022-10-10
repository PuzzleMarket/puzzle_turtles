local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
taR = Tunnel.getInterface("puzzle_turtles")
config = module("puzzle_turtles","config")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local service = false
local segundos = 0
local list = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIAR TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
local inicio = config.startLoc
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		sleep = true
		if not service then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local distancia = #(coords - inicio)
			if distancia <= 15 then
				sleep = false
				DrawMarker(21,inicio[1],inicio[2],inicio[3]-0.5,0,0,0,0,180.0,130.0,0.5,0.5,0.4,250,100,50,150,1,0,0,1)
				if distancia <= 2 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA ~y~INICAR CAPTURA DAS TARTARUGAS",4,0.5,0.90,0.50,255,255,255,200)
					if IsControlJustPressed(0,38) then
						service = true
						TriggerEvent('reloadNinhos')
						PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
						TriggerEvent("Notify","sucesso","Capture as tartaruas, mas cuidado com a polícia.")
					end
				end
			end
		end
	if sleep then Citizen.Wait(1000) end 
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETAR AS TARTARUGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		sleep = true
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if service then
			for k,v in pairs(config.locs) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 25 and not list[k] then
					sleep = false
					DrawMarker(21,v[1],v[2],v[3]-0.6,0,0,0,0,180.0,130.0,0.4,0.4,0.3,250,100,50,150,1,0,0,1)
					if distance <= 1.2  then
						drawTxt("PRESSIONE  ~r~E~w~  PARA ~y~PEGAR TARTARUGAS~w~",4,0.5,0.90,0.50,255,255,255,200)
						if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
							if taR.checkSpaceAndPayment(true, false) then
								list[k] = true
								segundos = config.animTime
								TriggerEvent("progress",2800,"Pegando Tartarugas")
								TriggerEvent('cancelando',true)
								vRP._playAnim(false,{{"amb@medic@standing@tendtodead@idle_a","idle_a"}},false)
								TriggerEvent('subtractSeconds', segundos)
								SetTimeout(segundos*1000, function()
									PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
									TriggerEvent('cancelando',false)
									taR.checkSpaceAndPayment(false, true)
								end)
							else
								TriggerEvent("Notify","negado","Mochila Cheia.")
								PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_CLOTHESSHOP_SOUNDSET', false)
							end
						end
					end
				end
			end
		end
		if sleep then Citizen.Wait(1000) end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDER AS TARTARUGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		sleep = true
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local distancia = #(coords - config.sellLoc)
		if distancia <= 5 then
			sleep = false
			DrawMarker(21,config.sellLoc[1],config.sellLoc[2],config.sellLoc[3]-0.5,0,0,0,0,180.0,130.0,0.5,0.5,0.4,250,100,50,150,1,0,0,1)
			if distancia <= 2 then
				drawTxt("PRESSIONE  ~r~E~w~  PARA ~y~VENDER AS TARTARUGAS",4,0.5,0.90,0.50,255,255,255,200)
				if IsControlJustPressed(0,38) then
					taR.sellTurtles()
					PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
				end
			end
		end
	if sleep then Citizen.Wait(1000) end 
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('reloadNinhos')
AddEventHandler('reloadNinhos',function()
	local seconds = 60
	repeat
		Citizen.Wait(1000)
		seconds = seconds - 1
		if seconds == 0 then
			list = {}
			seconds = 60
		end
	until service == false
end)

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

RegisterKeyMapping("StopTurtleService","Sair Serviço Tartarugas","keyboard","f7")
RegisterCommand("StopTurtleService",function(source,args)
	if service then
		service = false
		PlaySoundFrontend(-1, "ERROR", "HUD_AMMO_SHOP_SOUNDSET", 1)
		TriggerEvent("Notify","aviso","Você saiu de serviço.")
	end
end)