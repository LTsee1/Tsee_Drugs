ESX = nil
local PlayersHarvestingCoke = {}
local PlayersTransformingCoke  = {}
local PlayersHarvestingWeed = {}
local PlayersTransformingWeed  = {}
local PlayersTransformingWeed2  = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)
local function HarvestCoke(source)

		
	
	SetTimeout(5000, function()

		if PlayersHarvestingCoke[source] == true then
		
		
		



			local xPlayer  = ESX.GetPlayerFromId(source)

			local coke = xPlayer.getInventoryItem('coke')

			if coke.limit ~= -1 and coke.count >= coke.limit then
				TriggerClientEvent('esx:showNotification', source, '~r~ Pełny Ekwipunek !')
			     TriggerEvent('Drugs_Tsee:stopHarvestCoke')
				 
			else
				xPlayer.addInventoryItem('coke', 1)
				HarvestCoke(source)
			end

		end
	end)
end
local function HarvestWeed(source)

		
	
	SetTimeout(5000, function()

		if PlayersHarvestingWeed[source] == true then
		
		
		



			local xPlayer  = ESX.GetPlayerFromId(source)

			local weed = xPlayer.getInventoryItem('weed')

			if weed.limit ~= -1 and weed.count >= weed.limit then
				TriggerClientEvent('esx:showNotification', source, '~r~ Pełny Ekwipunek !')
			     TriggerEvent('Drugs_Tsee:stopHarvestWeed')
				 
			else
				local Losowosc = math.random(1,4)
				xPlayer.addInventoryItem('weed', Losowosc)
				HarvestWeed(source)
			end

		end
	end)
end




RegisterServerEvent('Drugs_Tsee:HarvestCoke')
AddEventHandler('Drugs_Tsee:HarvestCoke', function()
	local _source = source
	PlayersHarvestingCoke[source] = true
	TriggerClientEvent('esx:showNotification', _source, '~g~Zaczynasz zbierać ~r~liście kokainy')
	TriggerClientEvent('Drugs_Tsee:Animation', _source)
	
	HarvestCoke(_source)
end)
RegisterServerEvent('Drugs_Tsee:HarvestWeed')
AddEventHandler('Drugs_Tsee:HarvestWeed', function()
	local _source = source
	PlayersHarvestingWeed[source] = true
	TriggerClientEvent('esx:showNotification', _source, '~g~Zaczynasz zbierać ~g~marihuanę')
	TriggerClientEvent('Drugs_Tsee:Animation', _source)
	
	HarvestWeed(_source)
end)

RegisterServerEvent('Drugs_Tsee:stopHarvestCoke')
AddEventHandler('Drugs_Tsee:stopHarvestCoke', function()

	local _source = source

	PlayersHarvestingCoke[_source] = false
	TriggerClientEvent('Drugs_Tsee:AnimationEnd', _source)
end)
RegisterServerEvent('Drugs_Tsee:stopHarvestWeed')
AddEventHandler('Drugs_Tsee:stopHarvestWeed', function()

	local _source = source

	PlayersHarvestingWeed[_source] = false
	TriggerClientEvent('Drugs_Tsee:AnimationEnd', _source)
end)




local function TransformCoke(source)

	
	SetTimeout(5000, function()

		if PlayersTransformingCoke[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local cokeQuantity = xPlayer.getInventoryItem('coke').count
			local poochQuantity = xPlayer.getInventoryItem('coke_pooch').count
			local sodaQuantity = xPlayer.getInventoryItem('soda').count
			local gram = math.random(1,3)

			if poochQuantity > 39 then
				TriggerClientEvent('esx:showNotification', source, '~r~ Nie umieścisz wiecej już ~s~gotowej kokainy')
			elseif cokeQuantity < 4 then
				TriggerClientEvent('esx:showNotification', source, '~r~Nie posiadasz ~s~liści kokainy')
			elseif sodaQuantity < 1 then
				TriggerClientEvent('esx:showNotification', source, '~r~Nie posiadasz ~s~Sody kuchennej')
			else

				xPlayer.removeInventoryItem('coke', 5)
				xPlayer.removeInventoryItem('soda', 1)
				xPlayer.addInventoryItem('coke_pooch', gram)
			
				TransformCoke(source)

		end
		end
	end)
end
local function TransformWeed(source)

	
	SetTimeout(5000, function()

		if PlayersTransformingWeed[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)

			local weedQuantity = xPlayer.getInventoryItem('weed').count
			local weed1Quantity = xPlayer.getInventoryItem('weed1').count
			local weed = xPlayer.getInventoryItem('weed')

			if weed1Quantity > weed.limit then
				TriggerClientEvent('esx:showNotification', source, '~r~ Nie umieścisz wiecej już ~g~szuszonej marihuany')
			elseif weedQuantity < 1 then
				TriggerClientEvent('esx:showNotification', source, '~r~Nie posiadasz ~g~kwiatów marihuany')
			
			else

				xPlayer.removeInventoryItem('weed', 1)

				xPlayer.addInventoryItem('weed1', 1)
			
				TransformWeed(source)

		end
		end
	end)
end
local function TransformWeed2(source)

	
	SetTimeout(5000, function()

		if PlayersTransformingWeed2[source] == true then

			local _source = source
			local xPlayer = ESX.GetPlayerFromId(_source)


			local weed1Quantity = xPlayer.getInventoryItem('weed1').count
			local weed4 = xPlayer.getInventoryItem('weed_pooch')

			if weed4.limit ~= -1 and weed4.count >= weed4.limit then
				TriggerClientEvent('esx:showNotification', source, '~r~ Nie umieścisz wiecej już ~g~pakowanej szuszonej marihuany')
			elseif weed1Quantity < 4 then
				TriggerClientEvent('esx:showNotification', source, '~r~Nie posiadasz ~g~kwiatów marihuany')
			
			else

				xPlayer.removeInventoryItem('weed1', 5)

				xPlayer.addInventoryItem('weed_pooch', 1)
			
				TransformWeed2(source)

		end
		end
	end)
end

RegisterServerEvent('Drugs_Tsee:startTransformCoke')
AddEventHandler('Drugs_Tsee:startTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[source] = true

	TriggerClientEvent('esx:showNotification', _source, '~g~ Zaczynasz przerabiac liśćie kokainy')
	TriggerClientEvent('Drugs_Tsee:Animation', _source)
	TransformCoke(_source)

end)

RegisterServerEvent('Drugs_Tsee:stopTransformCoke')
AddEventHandler('Drugs_Tsee:stopTransformCoke', function()

	local _source = source

	PlayersTransformingCoke[_source] = false
	TriggerClientEvent('Drugs_Tsee:AnimationEnd', _source)
end)
RegisterServerEvent('Drugs_Tsee:startTransformWeed')
AddEventHandler('Drugs_Tsee:startTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[source] = true

	TriggerClientEvent('esx:showNotification', _source, '~g~ Zaczynasz szuszyć kwiaty marihuany')
	TriggerClientEvent('Drugs_Tsee:Animation', _source)
	TransformWeed(_source)

end)

RegisterServerEvent('Drugs_Tsee:stopTransformWeed')
AddEventHandler('Drugs_Tsee:stopTransformWeed', function()

	local _source = source

	PlayersTransformingWeed[_source] = false
	TriggerClientEvent('Drugs_Tsee:AnimationEnd', _source)
end)
RegisterServerEvent('Drugs_Tsee:startTransformWeed2')
AddEventHandler('Drugs_Tsee:startTransformWeed2', function()

	local _source = source

	PlayersTransformingWeed2[source] = true

	TriggerClientEvent('esx:showNotification', _source, '~g~ Zaczynasz pakować szuszone kwiaty marihuany')
	TriggerClientEvent('Drugs_Tsee:Animation', _source)
	TransformWeed2(_source)

end)

RegisterServerEvent('Drugs_Tsee:stopTransformWeed2')
AddEventHandler('Drugs_Tsee:stopTransformWeed2', function()

	local _source = source

	PlayersTransformingWeed2[_source] = false
	TriggerClientEvent('Drugs_Tsee:AnimationEnd', _source)
end)









RegisterServerEvent('Drugs_Tsee:BuySoda')
AddEventHandler('Drugs_Tsee:BuySoda', function()
local _source = source
local xPlayer  = ESX.GetPlayerFromId(source)
local sodaQuantity = xPlayer.getInventoryItem('soda').count
local xPlayer = ESX.GetPlayerFromId(_source)
if sodaQuantity < 41 and xPlayer.getMoney() > 999 then
	xPlayer.addInventoryItem('soda', 5)
	xPlayer.removeMoney(1000)
elseif xPlayer.getMoney() < 1000 then
	TriggerClientEvent('esx:showNotification', _source, '~g~Nie posiadasz pieniędzy na kupno ~s~Sody')
elseif sodaQuantity > 35 then
	TriggerClientEvent('esx:showNotification', _source, '~g~Nie posiadasz miejsca na kupno ~s~Sody')
end
end)



