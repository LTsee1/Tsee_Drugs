local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}









local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local isInZone                  = false
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local inmarker = false
local CancelInfo = nil
local coords = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)
		coords = GetEntityCoords(GetPlayerPed(-1))
	end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Markers) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerEvent('Drugs_Tsee:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('Drugs_Tsee:hasExitedMarker', lastZone)
		end

		if isInMarker and isInZone then
			TriggerEvent('Drugs_Tsee:hasEnteredMarker', 'exitMarker')
		end
end
end)

AddEventHandler('Drugs_Tsee:hasEnteredMarker', function(zone)
	if myJob == 'police' or myJob == 'ambulance' then
		return
	end


	
	if zone == 'exitMarker' then
		CurrentAction     = zone
		CurrentActionMsg  = ('Naciśnij ~g~E ~s~by przerwać zbierać'..CancelInfo)
		CurrentActionData = {}
	end
	
	if zone == 'CokeLeaves' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~g~E ~s~by zacząć zbierać ~r~liście kokainy'
		CurrentActionData = {}
	end
	if zone == 'CokeProcessing' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~g~E ~s~by zacząć obrabiać ~r~liście kokainy'
		CurrentActionData = {}
	end
	if zone == 'WeedFarm1' or zone == 'WeedFarm2' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~g~E ~s~by zacząć zbierać ~g~kwiaty marihuany'
		CurrentActionData = {}
	end
	if zone == 'WeedSzusz1' or zone == 'WeedSzusz2' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~g~E ~s~by zacząć szuszyć ~g~kwiaty marihuany'
		CurrentActionData = {}
	end
	if zone == 'WeedPacking1' or zone == 'WeedPacking2' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~g~E ~s~by zacząć pakować ~g~wyszuszone kwiaty marihuany'
		CurrentActionData = {}
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			if IsControlJustReleased(0, Keys['E']) then
				isInZone = true -- unless we set this boolean to false, we will always freeze the user
				if CurrentAction == 'exitMarker' then
					isInZone = false -- do not freeze user
					TriggerEvent('Drugs_Tsee:freezePlayer', false)
					TriggerEvent('Drugs_Tsee:hasExitedMarker', lastZone)
					Citizen.Wait(15000)
				elseif CurrentAction == 'CokeLeaves' then
					TriggerServerEvent('Drugs_Tsee:HarvestCoke')
CancelInfo = " ~r~liście kokainy"
				elseif CurrentAction == 'CokeProcessing' then
					TriggerServerEvent('Drugs_Tsee:startTransformCoke')
					CancelInfo = " ~r~przerabianie liści kokainy"
				elseif CurrentAction == 'WeedFarm1' or CurrentAction == 'WeedFarm2' then
					TriggerServerEvent('Drugs_Tsee:HarvestWeed')
					CancelInfo = " ~g~kwiaty marihuany"
				elseif  CurrentAction == 'WeedSzusz1' or CurrentAction == 'WeedSzusz2' then
					CancelInfo = " ~g~szuszyć kwiaty marihuany"
					TriggerServerEvent('Drugs_Tsee:startTransformWeed')
				elseif  CurrentAction == 'WeedPacking1' or CurrentAction == 'WeedPacking2' then
					CancelInfo = " ~g~pakować szuszone kwiaty marihuany"
					TriggerServerEvent('Drugs_Tsee:startTransformWeed2')
				else
					isInZone = false -- not a esx_drugs zone
				end
				
				if isInZone then
					TriggerEvent('Drugs_Tsee:freezePlayer', true)
				end
				
				CurrentAction = nil


		end
		end
	end
end)








AddEventHandler('Drugs_Tsee:hasExitedMarker', function(zone)
	CurrentAction = nil

TriggerServerEvent('Drugs_Tsee:stopHarvestCoke')
TriggerServerEvent('Drugs_Tsee:stopTransformCoke')
TriggerServerEvent('Drugs_Tsee:stopHarvestWeed')
TriggerServerEvent('Drugs_Tsee:stopTransformWeed')
TriggerServerEvent('Drugs_Tsee:stopTransformWeed2')

end)

RegisterNetEvent('Drugs_Tsee:freezePlayer')
AddEventHandler('Drugs_Tsee:freezePlayer', function(freeze)
	FreezeEntityPosition(GetPlayerPed(-1), freeze)
end)
RegisterNetEvent('Drugs_Tsee:Animation')
AddEventHandler('Drugs_Tsee:Animation', function(animationF)
	TaskStartScenarioInPlace(GetPlayerPed(-1), 'PROP_HUMAN_BUM_BIN', 0, false)
end)
RegisterNetEvent('Drugs_Tsee:AnimationEnd')
AddEventHandler('Drugs_Tsee:AnimationEnd', function(animationE)
	ClearPedTasks(GetPlayerPed(-1))			
end)


function OpenShopSodaMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Craft2', {
        title = 'Sklep z przedmiotami do stworzenia narkotyków',
        align = 'center',
        elements = {
         {label = 'x5 Soda ~ 1000$', value = 'soda'},
       
        }}, function(data, menu)
            local action = data.current.value
            
               if  action == 'soda'    then
            TriggerServerEvent('Drugs_Tsee:BuySoda')
            menu.close()
            else 
                TriggerEvent('esx:showNotification', source, 'Test')
            end
        end, function(data, menu)
            menu.close()
        end)
    end    














Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)

local letsleep = false

	for k,v in pairs(Config.Markers) do
		zz = v.z + 1.25
	if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
	DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.25, 3.25, 1.25, 0, 120, 0, 100, false, true, 2, false, false, false, false)
	end
	if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x) then
		DrawText3Ds(v.x, v.y, zz, CurrentActionMsg)
	end
end
	for k,v in pairs(Config.Shops) do
		zz = v.z + 1.25
	if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then

	DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.25, 3.25, 3.25, 204, 204, 0, 100, false, true, 2, false, false, false, false)
	end
	if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x) then
		DrawText3Ds(v.x, v.y, zz, 'Naciśnij ~g~E ~s~by otworzyć sklep')
		if IsControlJustReleased(0, Keys['E']) then
			OpenShopSodaMenu()
		
		end
	end

end
end
	end)








	function DrawText3Ds(x,y,z, text)
		local onScreen,_x,_y=World3dToScreen2d(x,y,z)
		local px,py,pz=table.unpack(GetGameplayCamCoords())
		
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
	end


	