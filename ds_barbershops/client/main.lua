-----------------------------------------------------------------------------------------------
--				█▀▀█ █▀▀ ▀▀█▀▀ █▀▀█ █▀▀█ █▀▀▄ ░▀░ █░█   █▀▀ █▀▀█ █▀▀█ █▀▀
--				█▄▄▀ █▀▀ ░░█░░ █▄▄▀ █░░█ █░░█ ▀█▀ ▄▀▄   █░░ █░░█ █▄▄▀ █▀▀
--				▀░▀▀ ▀▀▀ ░░▀░░ ▀░▀▀ ▀▀▀▀ ▀░░▀ ▀▀▀ ▀░▀   ▀▀▀ ▀▀▀▀ ▀░▀▀ ▀▀▀
-----------------------------------------------------------------------------------------------

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


ESX = nil
local isskinBarbershopOpened = false
local firstclothe = false
local cam = -1	
local heading = 332.219879	
local zoom = "vetements"
local isCameraActive, isCameraActiveOld, lastSkinOld
local zoomOffsetOld, camOffsetOld, headingOld = 0.0, 0.0, 90.0
local FirstSpawn     = true
local NewPlayer		 = true
local PlayerLoaded   = false
local PrevHat,PrevGlasses, PrevEars, PrevGender
local face

local GUI                     = {}
GUI.Time                      = 0
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasPayed                = false
local HasLoadCloth			  = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

------------------------------------------------------------------
--                          NUI
------------------------------------------------------------------

RegisterNUICallback('updateSkin', function(data)
	local playerPed = PlayerPedId()
	v = data.value
	hair = tonumber(data.hair)
	haircolor = tonumber(data.haircolor)
	haircolor2 = tonumber(data.haircolor2)
	makeup = tonumber(data.makeup)
	makeupcolor = tonumber(data.makeupcolor)
	makeupcolor2 = tonumber(data.makeupcolor2)
	makeupopacity = tonumber(data.makeupopacity)
	eyebrow = tonumber(data.eyebrow)
	eyebrowopacity = tonumber(data.eyebrowopacity)
	beard = tonumber(data.beard)
	beardopacity = tonumber(data.beardopacity)
	beardcolor = tonumber(data.beardcolor)

	if(v == true) then
		local ped = GetPlayerPed(-1)
		local torso = GetPedDrawableVariation(ped, 3)
		local torsotext = GetPedTextureVariation(ped, 3)
		local leg = GetPedDrawableVariation(ped, 4)
		local legtext = GetPedTextureVariation(ped, 4)
		local shoes = GetPedDrawableVariation(ped, 6)
		local shoestext = GetPedTextureVariation(ped, 6)
		local accessory = GetPedDrawableVariation(ped, 7)
		local accessorytext = GetPedTextureVariation(ped, 7)
		local undershirt = GetPedDrawableVariation(ped, 8)
		local undershirttext = GetPedTextureVariation(ped, 8)
		local torso2 = GetPedDrawableVariation(ped, 11)
		local torso2text = GetPedTextureVariation(ped, 11)
		local prop_hat = GetPedPropIndex(ped, 0)
		local prop_hat_text = GetPedPropTextureIndex(ped, 0)
		local prop_glasses = GetPedPropIndex(ped, 1)
		local prop_glasses_text = GetPedPropTextureIndex(ped, 1)
		local prop_earrings = GetPedPropIndex(ped, 2)
		local prop_earrings_text = GetPedPropTextureIndex(ped, 2)
		local prop_watches = GetPedPropIndex(ped, 6)
		local prop_watches_text = GetPedPropTextureIndex(ped, 6)
		TriggerServerEvent('ds_barbershops:save', eyebrow, eyebrowopacity, beard, beardopacity, beardcolor, beardcolor, hair, haircolor, haircolor2, makeup, makeupopacity, makeupcolor, makeupcolor2)
		
		CloseskinBarbershop()
	else	
		-- Clothes variations
		if PrevHat ~= hats then
			PrevHat = hats
			hats_texture = 0
			local maxHat
			if hats == 0 then
				maxHat = 0
			else
				maxHat = GetNumberOfPedPropTextureVariations	(GetPlayerPed(-1), 0, hats) - 1
			end
			SendNUIMessage({
				type = "updateMaxVal",
				classname = "helmet_2",
				defaultVal = 0,
				maxVal = maxHat
			})
		end
		
		if hats == 0 then
			ClearPedProp(GetPlayerPed(-1), 0)
		else
			SetPedPropIndex(GetPlayerPed(-1), 0, hats, hats_texture, 2)
		end
		
		if PrevGlasses ~= glasses then
			PrevGlasses = glasses
			glasses_texture = 0
			local maxGlasses
			if glasses == 0 then maxGlasses = 0
			else maxGlasses = GetNumberOfPedPropTextureVariations	(GetPlayerPed(-1), 1, glasses - 1)
			end
			SendNUIMessage({
				type = "updateMaxVal",
				classname = "glasses_2",
				defaultVal = 0,
				maxVal = maxGlasses
			})
		end
		if glasses == 0 then		
			ClearPedProp(GetPlayerPed(-1), 1)
		else
			SetPedPropIndex(GetPlayerPed(-1), 1, glasses, glasses_texture, 2)--Glasses
		end
		
		if PrevEars ~= ears then
			PrevEars = ears
			ears_texture = 0
			local maxEars
			if ears == 0 then maxEars = 0
			else maxEars = GetNumberOfPedPropTextureVariations	(GetPlayerPed(-1), 1, ears - 1)
			end
			SendNUIMessage({
				type = "updateMaxVal",
				classname = "ears_2",
				defaultVal = 0,
				maxVal = maxEars
			})
		end
		if ears == 0 then		ClearPedProp(GetPlayerPed(-1), 2)
		else
			SetPedPropIndex(GetPlayerPed(-1), 2, ears, ears_texture, 2)
		end
	

	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if tops == 0 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 2) 	-- Torso
			elseif tops == 1 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 0, 7, 2) 	-- Torso
			elseif tops == 2 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 0, 7, 2) 	-- Torso
			elseif tops == 3 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 0, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 4, 0, 2) 	-- Torso
			elseif tops == 4 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 11, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 1, 2) 	-- Torso
			elseif tops == 5 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 6, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 5, 2) 	-- Torso
			elseif tops == 6 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 8, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 8, 5, 2) 	-- Torso
			elseif tops == 7 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 3, 1, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 10, 0, 2) 	-- Torso
			elseif tops == 8 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 0, 2) 	-- Torso
			elseif tops == 9 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 9, 3, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 20, 0, 2) 	-- Torso
			elseif tops == 10 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 6, 12, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 21, 0, 2) 	-- Torso
			elseif tops == 11 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 96, 6, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 23, 2, 2) 	-- Torso
			elseif tops == 12 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 74, 5, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 28, 0, 2) 	-- Torso
			elseif tops == 13 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 29, 12, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 38, 0, 2) 	-- Torso
			elseif tops == 14 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 101, 5, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 62, 0, 2) 	-- Torso
			elseif tops == 15 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 77, 2, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 69, 0, 2) 	-- Torso
			elseif tops == 16 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 25, 3, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 4, 0, 2) 	-- Torso
			elseif tops == 17 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 32, 2, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 6, 3, 2) 	-- Torso
			elseif tops == 18 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 17, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 59, 2, 2) 	-- Torso
			elseif tops == 19 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 61, 1, 2) 	-- Torso
			elseif tops == 20 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 28, 2, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 62, 0, 2) 	-- Torso
			elseif tops == 21 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 63, 0, 2) 	-- Torso
			elseif tops == 22 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 0, 2) 	-- Torso
			elseif tops == 23 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 3, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 72, 2, 2) 	-- Torso
			elseif tops == 24 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 74, 1, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 76, 3, 2) 	-- Torso
			elseif tops == 25 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 78, 1, 2) 	-- Torso
			elseif tops == 26 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 78, 9, 2) 	-- Torso
			elseif tops == 27 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 82, 15, 2) 	-- Torso
			elseif tops == 28 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 22, 2, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 120, 4, 2) 	-- Torso
			elseif tops == 29 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 28, 2, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 122, 5, 2) 	-- Torso
			elseif tops == 30 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 153, 2, 2) 	-- Torso
			elseif tops == 31 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 27, 2, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 157, 2, 2) 	-- Torso
			elseif tops == 32 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 135, 12, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 166, 1, 2) 	-- Torso
			elseif tops == 33 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 64, 4, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 167, 0, 2) 	-- Torso
			elseif tops == 34 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 111, 4, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 173, 0, 2) 	-- Torso
			elseif tops == 35 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 111, 4, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 191, 16, 2) 	-- Torso
			elseif tops == 36 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 193, 11, 2) 	-- Torso
			elseif tops == 37 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 197, 5, 2) 	-- Torso
			elseif tops == 38 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 200, 7, 2) 	-- Torso
			elseif tops == 39 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 245, 2, 2) 	-- Torso
			elseif tops == 40 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 256, 1, 2) 	-- Torso
			elseif tops == 41 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- t-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 265, 11, 2) 	-- Torso
			elseif tops == 42 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 8, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 38, 3, 2) 	-- Torso 2
			elseif tops == 43 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 39, 0, 2) 	-- Torso 2
			elseif tops == 44 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 39, 1, 2) 	-- Torso 2
			elseif tops == 45 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 41, 0, 2) 	-- Torso 2
			elseif tops == 46 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 42, 0, 2) 	-- Torso 2
			elseif tops == 47 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 50, 0, 2) 	-- Torso 2
			elseif tops == 48 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 50, 3, 2) 	-- Torso 2
			elseif tops == 49 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 50, 4, 2) 	-- Torso 2
			elseif tops == 50 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 57, 0, 2) 	-- Torso 2
			elseif tops == 51 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 0, 2) 	-- Torso 2
			elseif tops == 52 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 1, 2) 	-- Torso 2
			elseif tops == 53 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 50, 1, 2) 	-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 23, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 70, 7, 2) 	-- Torso 2
			elseif tops == 54 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 3, 1, 2) 		-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 72, 1, 2) 	-- Torso 2
			elseif tops == 55 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 87, 0, 2) 	-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 5, 0, 2) 		-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 74, 0, 2) 	-- Torso 2
			elseif tops == 56 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 12, 2, 2) 	-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 28, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 77, 0, 2) 	-- Torso 2
			elseif tops == 57 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 79, 0, 2) 	-- Torso 2
			elseif tops == 58 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 80, 0, 2) 	-- Torso 2
			elseif tops == 59 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 80, 1, 2) 	-- Torso 2
			elseif tops == 60 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 82, 5, 2) 	-- Torso 2
			elseif tops == 61 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 82, 8, 2) 	-- Torso 2
			elseif tops == 62 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 82, 9, 2) 	-- Torso 2
			elseif tops == 63 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 86, 0, 2) 	-- Torso 2
			elseif tops == 64 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 86, 2, 2) 	-- Torso 2
			elseif tops == 65 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 86, 4, 2) 	-- Torso 2
			elseif tops == 66 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 11, 2) 	-- Torso 2
			elseif tops == 67 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 0, 2) 	-- Torso 2
			elseif tops == 68 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 1, 2) 	-- Torso 2
			elseif tops == 69 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 2, 2) 	-- Torso 2
			elseif tops == 70 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 4, 2) 	-- Torso 2
			elseif tops == 71 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 87, 8, 2) 	-- Torso 2
			elseif tops == 72 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 89, 0, 2) 	-- Torso 2
			elseif tops == 73 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 95, 0, 2) 	-- Torso 2
			elseif tops == 74 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 31, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 99, 1, 2) 	-- Torso 2
			elseif tops == 75 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 31, 13, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 99, 3, 2) 	-- Torso 2
			elseif tops == 76 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 31, 13, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 101, 0, 2) 	-- Torso 2
			elseif tops == 77 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 105, 0, 2) 	-- Torso 2
			elseif tops == 78 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 106, 0, 2) 	-- Torso 2
			elseif tops == 79 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 73, 2, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 109, 0, 2) 	-- Torso 2
			elseif tops == 80 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 111, 0, 2) 	-- Torso 2
			elseif tops == 81 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 111, 3, 2) 	-- Torso 2
			elseif tops == 82 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 113, 0, 2) 	-- Torso 2
			elseif tops == 83 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 126, 5, 2) 	-- Torso 2
			elseif tops == 84 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 126, 9, 2) 	-- Torso 2
			elseif tops == 85 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 126, 10, 2) 	-- Torso 2
			elseif tops == 86 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 126, 14, 2) 	-- Torso 2
			elseif tops == 87 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 131, 0, 2) 	-- Torso 2
			elseif tops == 88 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 134, 0, 2) 	-- Torso 2
			elseif tops == 89 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 134, 1, 2) 	-- Torso 2
			elseif tops == 90 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 0, 2) 	-- Torso 2
			elseif tops == 91 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 2, 2) 	-- Torso 2
			elseif tops == 92 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 4, 2) 	-- Torso 2
			elseif tops == 93 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 5, 2) 	-- Torso 2
			elseif tops == 94 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 6, 2) 	-- Torso 2
			elseif tops == 95 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 8, 2) 	-- Torso 2
			elseif tops == 96 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 143, 9, 2) 	-- Torso 2
			elseif tops == 97 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 146, 0, 2) 	-- Torso 2
			elseif tops == 98 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 16, 2, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 166, 0, 2) 	-- Torso 2
			elseif tops == 99 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 167, 0, 2) 	-- Torso 2
			elseif tops == 100 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 1, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 167, 4, 2) 	-- Torso 2
			end
			if pants == 0 then 		SetPedComponentVariation(GetPlayerPed(-1), 4, 61, 1, 2)
			elseif pants == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 0, 2)
			elseif pants == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 0, 2)
			elseif pants == 2 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 2, 2)
			elseif pants == 3 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 1, 12, 2)
			elseif pants == 4 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 2, 11, 2)
			elseif pants == 5 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 0, 2)
			elseif pants == 6 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 4, 0, 2)
			elseif pants == 7 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 4, 1, 2)
			elseif pants == 8 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 4, 4, 2)
			elseif pants == 9 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 5, 0, 2)
			elseif pants == 10 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 5, 2, 2)
			elseif pants == 11 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 0, 2)
			elseif pants == 12 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 7, 1, 2)
			elseif pants == 13 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 0, 2)
			elseif pants == 14 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 9, 1, 2)
			elseif pants == 15 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 10, 0, 2)
			elseif pants == 16 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 10, 2, 2)
			elseif pants == 17 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 12, 0, 2)
			elseif pants == 18 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 12, 5, 2)
			elseif pants == 19 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 12, 7, 2)
			elseif pants == 20 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 0, 2)
			elseif pants == 21 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 1, 2)
			elseif pants == 22 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 3, 2)
			elseif pants == 23 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 15, 0, 2)
			elseif pants == 24 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 20, 0, 2)
			elseif pants == 25 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 0, 2)
			elseif pants == 26 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 1, 2)
			elseif pants == 27 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 5, 2)
			elseif pants == 28 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 0, 2)
			elseif pants == 29 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 4, 2)
			elseif pants == 30 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 5, 2)
			elseif pants == 31 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 6, 2)
			elseif pants == 32 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 28, 0, 2)
			elseif pants == 33 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 28, 3, 2)
			elseif pants == 34 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 28, 8, 2)
			elseif pants == 35 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 28, 14, 2)
			elseif pants == 36 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 42, 0, 2)
			elseif pants == 37 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 42, 1, 2)
			elseif pants == 38 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 48, 0, 2)
			elseif pants == 39 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 48, 1, 2)
			elseif pants == 40 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 49, 0, 2)
			elseif pants == 41 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 49, 1, 2)
			elseif pants == 42 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 54, 1, 2)
			elseif pants == 43 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 55, 0, 2)
			elseif pants == 44 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 60, 2, 2)
			elseif pants == 45 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 60, 9, 2)
			elseif pants == 46 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 71, 0, 2)
			elseif pants == 47 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 75, 2, 2)
			elseif pants == 48 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 76, 2, 2)
			elseif pants == 49 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 0, 2)
			elseif pants == 50 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 2, 2)
			elseif pants == 51 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 4, 2)
			elseif pants == 52 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 0, 2)
			elseif pants == 53 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 2, 2)
			elseif pants == 54 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 3, 2)
			elseif pants == 55 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 86, 9, 2)
			elseif pants == 56 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 88, 9, 2)
			elseif pants == 57 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 100, 9, 2)
			elseif pants == 58 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 58, 1, 2)
			elseif pants == 59 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 60 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 60, 1, 2)
			elseif pants == 61 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 62 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 62, 1, 2)
			elseif pants == 63 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 63, 1, 2)
			elseif pants == 64 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 64, 1, 2)
			elseif pants == 65 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 65, 1, 2)
			elseif pants == 66 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 67 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 68 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 69 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 69, 1, 2)			
			elseif pants == 70 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			end
			
            if shoes == 0 then		SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 2)
			elseif shoes == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 0, 10, 2)
			elseif shoes == 2 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 0, 2)
			elseif shoes == 3 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 1, 2)
			elseif shoes == 4 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 3, 2)
			elseif shoes == 5 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 0, 2)
			elseif shoes == 6 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 6, 2)
			elseif shoes == 7 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 14, 2)
			elseif shoes == 8 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 48, 0, 2)
			elseif shoes == 9 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 48, 1, 2)
			elseif shoes == 10 then SetPedComponentVariation(GetPlayerPed(-1), 6, 49, 0, 2)
			elseif shoes == 11 then SetPedComponentVariation(GetPlayerPed(-1), 6, 49, 1, 2)
			elseif shoes == 12 then SetPedComponentVariation(GetPlayerPed(-1), 6, 5, 0, 2)
			elseif shoes == 13 then SetPedComponentVariation(GetPlayerPed(-1), 6, 6, 0, 2)
			elseif shoes == 14 then SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 0, 2)
			elseif shoes == 15 then SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 9, 2)
			elseif shoes == 16 then SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 13, 2)
			elseif shoes == 17 then SetPedComponentVariation(GetPlayerPed(-1), 6, 9, 3, 2)
			elseif shoes == 18 then SetPedComponentVariation(GetPlayerPed(-1), 6, 9, 6, 2)
			elseif shoes == 19 then SetPedComponentVariation(GetPlayerPed(-1), 6, 9, 7, 2)
			elseif shoes == 20 then SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 0, 2)
			elseif shoes == 21 then SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 0, 2)
			elseif shoes == 22 then SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 2, 2)
			elseif shoes == 23 then SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 13, 2)
			elseif shoes == 24 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 0, 2)
			elseif shoes == 25 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 1, 2)
			elseif shoes == 26 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 0, 2)
			elseif shoes == 27 then SetPedComponentVariation(GetPlayerPed(-1), 6, 20, 0, 2)
			elseif shoes == 28 then SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2)
			elseif shoes == 29 then SetPedComponentVariation(GetPlayerPed(-1), 6, 27, 0, 2)
			elseif shoes == 30 then SetPedComponentVariation(GetPlayerPed(-1), 6, 28, 0, 2)
			elseif shoes == 31 then SetPedComponentVariation(GetPlayerPed(-1), 6, 28, 1, 2)
			elseif shoes == 32 then SetPedComponentVariation(GetPlayerPed(-1), 6, 28, 3, 2)
			elseif shoes == 33 then SetPedComponentVariation(GetPlayerPed(-1), 6, 28, 2, 2)
			elseif shoes == 34 then SetPedComponentVariation(GetPlayerPed(-1), 6, 31, 2, 2)
			elseif shoes == 35 then SetPedComponentVariation(GetPlayerPed(-1), 6, 31, 4, 2)
			elseif shoes == 36 then SetPedComponentVariation(GetPlayerPed(-1), 6, 36, 0, 2)
			elseif shoes == 37 then SetPedComponentVariation(GetPlayerPed(-1), 6, 36, 3, 2)
			elseif shoes == 38 then SetPedComponentVariation(GetPlayerPed(-1), 6, 42, 0, 2)
			elseif shoes == 39 then SetPedComponentVariation(GetPlayerPed(-1), 6, 42, 1, 2)
			elseif shoes == 40 then SetPedComponentVariation(GetPlayerPed(-1), 6, 42, 7, 2)
			elseif shoes == 41 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 0, 2)
			elseif shoes == 42 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 3, 2)
			elseif shoes == 43 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 8, 2)
			elseif shoes == 44 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 9, 2)
			elseif shoes == 45 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 10, 2)
			elseif shoes == 46 then SetPedComponentVariation(GetPlayerPed(-1), 6, 57, 11, 2)
			elseif shoes == 47 then SetPedComponentVariation(GetPlayerPed(-1), 6, 75, 4, 2)
			elseif shoes == 48 then SetPedComponentVariation(GetPlayerPed(-1), 6, 75, 7, 2)
			elseif shoes == 49 then SetPedComponentVariation(GetPlayerPed(-1), 6, 75, 8, 2)
			elseif shoes == 50 then SetPedComponentVariation(GetPlayerPed(-1), 6, 77, 0, 2)
			end
			
		else
			if tops == 0 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 2) 	-- Torso 2
			elseif tops == 1 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 0, 7, 2) 	-- Torso 2
			elseif tops == 2 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Torso
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 		-- Undershirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 0, 4, 2) 	-- Torso 2
			elseif tops == 3 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 125, 9, 2) 	-- Torso
			elseif tops == 4 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 3, 4, 2) 	-- Torso
			elseif tops == 5 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 78, 7, 2) 	-- Torso
			elseif tops == 6 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 24, 4, 2) 	-- Torso
			elseif tops == 7 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 24, 0, 2) 	-- Torso
			elseif tops == 8 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 38, 4, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 24, 5, 2) 	-- Torso
			elseif tops == 9 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 74, 0, 2) 	-- Torso
			elseif tops == 10 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 1, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 192, 19, 2) 	-- Torso
			elseif tops == 11 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 183, 0, 2) 	-- Torso
			elseif tops == 12 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 209, 13, 2) 	-- Torso
			elseif tops == 13 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 0, 2) 	-- Torso
			elseif tops == 14 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 27, 0, 2) 	-- Torso
			elseif tops == 15 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 30, 0, 2) 	-- Torso
			elseif tops == 16 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 65, 4, 2) 	-- Torso
			elseif tops == 17 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 75, 0, 2) 	-- Torso
			elseif tops == 18 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 65, 0, 2) 	-- Torso
			elseif tops == 19 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 79, 0, 2) 	-- Torso
			elseif tops == 20 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 121, 16, 2) 	-- Torso
			elseif tops == 21 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 83, 0, 2) 	-- Torso
			elseif tops == 22 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 104, 16, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 95, 0, 2) 	-- Torso
			elseif tops == 23 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 7, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 37, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 97, 0, 2) 	-- Torso
			elseif tops == 24 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 101, 1, 2) 	-- Torso
			elseif tops == 25 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 66, 4, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 104, 0, 2) 	-- Torso
			elseif tops == 26 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 117, 2, 2) 	-- Torso
			elseif tops == 27 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 118, 0, 2) 	-- Torso
			elseif tops == 28 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 20, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 120, 11, 2) 	-- Torso
			elseif tops == 29 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Arms --- Este falla
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 3, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 145, 3, 2) 	-- Torso
			elseif tops == 30 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 11, 15, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 154, 0, 2) 	-- Torso
			elseif tops == 31 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 37, 4, 2) 	-- Torso
			elseif tops == 32 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 26, 12, 2) 	-- Torso
			elseif tops == 33 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 7, 2) 	-- Torso
			elseif tops == 34 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 78, 4, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 163, 0, 2) 	-- Torso
			elseif tops == 35 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 14, 3, 2) 	-- Torso
			elseif tops == 36 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 87, 6, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 164, 13, 2) 	-- Torso
			elseif tops == 36 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 87, 5, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 164, 14, 2) 	-- Torso
			elseif tops == 37 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 22, 2, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 8, 2, 2) 	-- Torso
			elseif tops == 38 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 12, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 16, 5, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 167, 0, 2) 	-- Torso
			elseif tops == 39 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 22, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 8, 8, 2) 	-- Torso
			elseif tops == 40 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 8, 2) 	-- Torso
			elseif tops == 41 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 4, 2) 	-- Torso
			elseif tops == 42 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 2, 2) 	-- Torso
			elseif tops == 43 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 3, 2) 	-- Torso
			elseif tops == 44 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 168, 5, 2) 	-- Torso
			elseif tops == 45 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 81, 5, 2) 	-- Torso
			elseif tops == 46 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 116, 1, 2) 	-- Torso
			elseif tops == 47 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 115, 2, 2) 	-- Torso
			elseif tops == 48 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 125, 3, 2) 	-- Torso
			elseif tops == 49 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 125, 2, 2) 	-- Torso
			elseif tops == 50 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 75, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 134, 1, 2) 	-- Torso
			elseif tops == 51 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 136, 7, 2) 	-- Torso
			elseif tops == 52 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 170, 1, 2) 	-- Torso
			elseif tops == 53 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 170, 2, 2) 	-- Torso
			elseif tops == 54 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 170, 3, 2) 	-- Torso
			elseif tops == 55 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 3, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 136, 6, 2) 	-- Torso
			elseif tops == 56 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 170, 5, 2) 	-- Torso
			elseif tops == 57 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 171, 0, 2) 	-- Torso
			elseif tops == 58 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 171, 2, 2) 	-- Torso
			elseif tops == 59 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 171, 4, 2) 	-- Torso
			elseif tops == 60 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 158, 3, 2) 	-- Torso
			elseif tops == 61 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 184, 0, 2) 	-- Torso
			elseif tops == 62 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 184, 1, 2) 	-- Torso
			elseif tops == 63 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 9, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 26, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 187, 0, 2) 	-- Torso
			elseif tops == 64 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 195, 17, 2) 	-- Torso
			elseif tops == 65 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 195, 13, 2) 	-- Torso
			elseif tops == 66 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 195, 15, 2) 	-- Torso
			elseif tops == 67 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 195, 6, 2) 	-- Torso
			elseif tops == 68 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 195, 5, 2) 	-- Torso
			elseif tops == 69 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 202, 1, 2) 	-- Torso
			elseif tops == 70 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 202, 2, 2) 	-- Torso
			elseif tops == 71 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 202, 8, 2) 	-- Torso
			elseif tops == 72 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 208, 12, 2) 	-- Torso
			elseif tops == 73 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 11, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 209, 12, 2) 	-- Torso
			elseif tops == 74 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 234, 0, 2) 	-- Torso
			elseif tops == 75 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 6, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 234, 2, 2) 	-- Torso
			elseif tops == 76 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 236, 0, 2) 	-- Torso
			elseif tops == 77 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 16, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 240, 3, 2) 	-- Torso
			elseif tops == 78 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 244, 7, 2) 	-- Torso
			elseif tops == 79 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 247, 0, 2) 	-- Torso
			elseif tops == 80 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 247, 4, 2) 	-- Torso
			elseif tops == 81 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 247, 6, 2) 	-- Torso
			elseif tops == 82 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 247, 24, 2) 	-- Torso
			elseif tops == 83 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 244, 8, 2) 	-- Torso
			elseif tops == 84 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 88, 1, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 255, 24, 2) 	-- Torso
			elseif tops == 85 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 89, 1, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 255, 16, 2) 	-- Torso
			elseif tops == 86 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 256, 25, 2) 	-- Torso
			elseif tops == 87 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 244, 11, 2) 	-- Torso
			elseif tops == 88 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 244, 12, 2) 	-- Torso
			elseif tops == 89 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 273, 2, 2) 	-- Torso
			elseif tops == 90 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 279, 7, 2) 	-- Torso
			elseif tops == 91 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 279, 5, 2) 	-- Torso
			elseif tops == 92 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 279, 2, 2) 	-- Torso
			elseif tops == 93 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 283, 10, 2) 	-- Torso
			elseif tops == 94 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 286, 11, 2) 	-- Torso
			elseif tops == 95 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 286, 2, 2) 	-- Torso
			elseif tops == 96 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 265, 4, 2) 	-- Torso
			elseif tops == 97 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 265, 6, 2) 	-- Torso
			elseif tops == 98 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 30, 1, 2) 	-- Torso
			elseif tops == 99 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 37, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 52, 2, 2) 	-- Torso
			elseif tops == 100 then
				SetPedComponentVariation(GetPlayerPed(-1), 3, 2, 0, 2)		-- Arms
				SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2) 		-- Neck
				SetPedComponentVariation(GetPlayerPed(-1), 8, 14, 0, 2) 	-- T-shirt
				SetPedComponentVariation(GetPlayerPed(-1), 11, 54, 2, 2) 	-- Torso
			end
		
			if pants == 0 then 		SetPedComponentVariation(GetPlayerPed(-1), 4, 15, 1, 2)
			elseif pants == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 14, 4, 2)
			elseif pants == 2 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 25, 1, 2)
			elseif pants == 3 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 25, 11, 2)
			elseif pants == 4 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 26, 0, 2)
			elseif pants == 5 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 108, 9, 2)
			elseif pants == 6 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 8, 0, 2)
			elseif pants == 7 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 23, 12, 2)
			elseif pants == 8 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 23, 0, 2)
			elseif pants == 9 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 27, 0, 2)
			elseif pants == 10 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 43, 0, 2)
			elseif pants == 11 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 2, 2, 2)
			elseif pants == 12 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 2, 0, 2)
			elseif pants == 13 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 5, 8, 2)
			elseif pants == 14 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 5, 14, 2)
			elseif pants == 15 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 11, 15, 2)
			elseif pants == 16 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 11, 1, 2)
			elseif pants == 17 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 11, 10, 2)
			elseif pants == 18 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 66, 10, 2)
			elseif pants == 19 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 66, 7, 2)
			elseif pants == 20 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 80, 4, 2)
			elseif pants == 21 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 80, 2, 2)
			elseif pants == 22 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 80, 1, 2)
			elseif pants == 23 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 4, 2)
			elseif pants == 24 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 2, 2)
			elseif pants == 25 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 82, 1, 2)
			elseif pants == 26 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 109, 0, 2)
			elseif pants == 27 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 109, 2, 2)
			elseif pants == 28 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 109, 7, 2)
			elseif pants == 29 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 110, 0, 2)
			elseif pants == 30 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 110, 2, 2)
			elseif pants == 31 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 110, 7, 2)
			elseif pants == 32 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 102, 0, 2)
			elseif pants == 33 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 102, 4, 2)
			elseif pants == 34 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 102, 5, 2)
			elseif pants == 35 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 87, 0, 2)
			elseif pants == 36 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 87, 1, 2)
			elseif pants == 37 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 87, 3, 2)
			elseif pants == 38 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 0, 2)
			elseif pants == 39 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 78, 1, 2)
			elseif pants == 40 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 0, 2)
			elseif pants == 41 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 42 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 2, 2)
			elseif pants == 43 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 9, 2)
			elseif pants == 44 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 10, 2)
			elseif pants == 45 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 1, 2)
			elseif pants == 46 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 6, 2)
			elseif pants == 47 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 10, 2)
			elseif pants == 48 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 11, 2)
			elseif pants == 49 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 56, 1, 2)
			elseif pants == 50 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 56, 4, 2)
			elseif pants == 51 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 56, 5, 2)
			elseif pants == 52 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 56, 2, 2)
			elseif pants == 53 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 89, 23, 2)
			elseif pants == 54 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 89, 22, 2)
			elseif pants == 55 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 89, 20, 2)
			elseif pants == 56 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 89, 18, 2)
			elseif pants == 57 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 89, 19, 2)
			elseif pants == 58 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 58, 1, 2)
			elseif pants == 59 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 60 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 60, 1, 2)
			elseif pants == 61 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 62 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 62, 1, 2)
			elseif pants == 63 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 63, 1, 2)
			elseif pants == 64 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 64, 1, 2)
			elseif pants == 65 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 65, 1, 2)
			elseif pants == 66 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 66, 1, 2)
			elseif pants == 67 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 67, 1, 2)
			elseif pants == 68 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			elseif pants == 69 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)			
			elseif pants == 70 then	SetPedComponentVariation(GetPlayerPed(-1), 4, 0, 1, 2)
			end
            if shoes == 0 then		SetPedComponentVariation(GetPlayerPed(-1), 6, 35, 0, 2)
			elseif shoes == 1 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 0, 0, 2)
			elseif shoes == 2 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 0, 3, 2)
			elseif shoes == 3 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 0, 2, 2)
			elseif shoes == 4 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 0, 2)
			elseif shoes == 5 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 3, 2)
			elseif shoes == 6 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 7, 8, 2)
			elseif shoes == 7 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 77, 0, 2)
			elseif shoes == 8 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 77, 2, 2)
			elseif shoes == 9 then	SetPedComponentVariation(GetPlayerPed(-1), 6, 77, 3, 2)
			elseif shoes == 10 then SetPedComponentVariation(GetPlayerPed(-1), 6, 77, 4, 2)
			elseif shoes == 11 then SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 1, 2)
			elseif shoes == 12 then SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 3, 2)
			elseif shoes == 13 then SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 5, 2)
			elseif shoes == 14 then SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 10, 2)
			elseif shoes == 15 then SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 13, 2)
			elseif shoes == 16 then SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 0, 2)
			elseif shoes == 17 then SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 1, 2)
			elseif shoes == 18 then SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 2, 2)
			elseif shoes == 19 then SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 3, 2)
			elseif shoes == 20 then SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 4, 2)
			elseif shoes == 21 then SetPedComponentVariation(GetPlayerPed(-1), 6, 3, 5, 2)
			elseif shoes == 22 then SetPedComponentVariation(GetPlayerPed(-1), 6, 31, 0, 2)
			elseif shoes == 23 then SetPedComponentVariation(GetPlayerPed(-1), 6, 32, 0, 2)
			elseif shoes == 24 then SetPedComponentVariation(GetPlayerPed(-1), 6, 32, 1, 2)
			elseif shoes == 25 then SetPedComponentVariation(GetPlayerPed(-1), 6, 32, 2, 2)
			elseif shoes == 26 then SetPedComponentVariation(GetPlayerPed(-1), 6, 32, 4, 2)
			elseif shoes == 27 then SetPedComponentVariation(GetPlayerPed(-1), 6, 60, 0, 2)
			elseif shoes == 28 then SetPedComponentVariation(GetPlayerPed(-1), 6, 60, 1, 2)
			elseif shoes == 29 then SetPedComponentVariation(GetPlayerPed(-1), 6, 60, 2, 2)
			elseif shoes == 30 then SetPedComponentVariation(GetPlayerPed(-1), 6, 60, 9, 2)
			elseif shoes == 31 then SetPedComponentVariation(GetPlayerPed(-1), 6, 60, 10, 2)
			elseif shoes == 32 then SetPedComponentVariation(GetPlayerPed(-1), 6, 60, 11, 2)
			elseif shoes == 33 then SetPedComponentVariation(GetPlayerPed(-1), 6, 11, 0, 2)
			elseif shoes == 34 then SetPedComponentVariation(GetPlayerPed(-1), 6, 11, 1, 2)
			elseif shoes == 35 then SetPedComponentVariation(GetPlayerPed(-1), 6, 11, 2, 2)
			elseif shoes == 36 then SetPedComponentVariation(GetPlayerPed(-1), 6, 11, 3, 2)
			elseif shoes == 37 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 0, 2) 
			elseif shoes == 38 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 1, 2)
			elseif shoes == 39 then SetPedComponentVariation(GetPlayerPed(-1), 6, 15, 2, 2)
			elseif shoes == 40 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 10, 2)
			elseif shoes == 41 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 0, 2)
			elseif shoes == 42 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 1, 2)
			elseif shoes == 43 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 2, 2)
			elseif shoes == 44 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 4, 2)
			elseif shoes == 45 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 7, 2)
			elseif shoes == 46 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 8, 2)
			elseif shoes == 47 then SetPedComponentVariation(GetPlayerPed(-1), 6, 16, 9, 2)
			elseif shoes == 48 then SetPedComponentVariation(GetPlayerPed(-1), 6, 20, 0, 2)
			elseif shoes == 49 then SetPedComponentVariation(GetPlayerPed(-1), 6, 20, 4, 2)
			elseif shoes == 50 then SetPedComponentVariation(GetPlayerPed(-1), 6, 20, 8, 2)
		end
	end
	end)
	end
end)

-- Character rotation
RegisterNUICallback('rotateleftheading', function(data)
	local currentHeading = GetEntityHeading(GetPlayerPed(-1))
	heading = heading+tonumber(data.value)
end)

RegisterNUICallback('rotaterightheading', function(data)
	local currentHeading = GetEntityHeading(GetPlayerPed(-1))
	heading = heading-tonumber(data.value)
end)

RegisterNUICallback('zoom', function(data)
	zoom = data.zoom
end)


function CloseskinBarbershop()
	local ped = PlayerPedId()
	isskinBarbershopOpened = false
	ShowskinBarbershop(false)
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
	
	if firstclothe == true then
		Citizen.Wait(550)
		TriggerEvent('ds_core:showmenu')
		firstclothe = false
	elseif firstclothe == false then
		SetPlayerInvincible(ped, false)
	end
end

function ShowskinBarbershop(enable)
local elements    = {}
	TriggerEvent('skinchanger:getData', function(components, maxVals)
		local _components = {}

		for i=1, #components, 1 do
			_components[i] = components[i]
		end

		-- Insert elements
		for i=1, #_components, 1 do
			local value       = _components[i].value
			local componentId = _components[i].componentId

			if componentId == 0 then
				value = GetPedPropIndex(playerPed,  _components[i].componentId)
			end

			local data = {
				label     = _components[i].label,
				name      = _components[i].name,
				value     = value,
				min       = _components[i].min,
			}

			for k,v in pairs(maxVals) do
				if k == _components[i].name then
					data.max = v
					break
				end
			end

			table.insert(elements, data)
		end
	end)
	isCameraActive = true
	SetNuiFocus(enable, enable)
	SendNUIMessage({
		openskinBarbershop = enable,
	})
	
	for index, data in ipairs(elements) do
		local name, Valmax

		for key, value in pairs(data) do
			if key == 'name' then
				name = value
			end
			if key == 'max' then
				Valmax = value
			end
		end
		
		SendNUIMessage({
			type = "updateMaxVal",
			classname = name,
			defaultVal = 0,
			maxVal = Valmax
		})
	end
end

RegisterNetEvent('hud:loadMenuClothe')
AddEventHandler('hud:loadMenuClothe', function()
	ShowskinBarbershop(true)
end)

RegisterNetEvent('hud:loadMenuClotheFIRST')
AddEventHandler('hud:loadMenuClotheFIRST', function()
	firstclothe = true
	ShowskinBarbershop(true)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isCameraActive == true then
			DisableControlAction(2, 14, true)
			DisableControlAction(2, 15, true)
			DisableControlAction(2, 16, true)
			DisableControlAction(2, 17, true)
			DisableControlAction(2, 30, true)
			DisableControlAction(2, 31, true)
			DisableControlAction(2, 32, true)
			DisableControlAction(2, 33, true)
			DisableControlAction(2, 34, true)
			DisableControlAction(2, 35, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 24, true)

			local ped = PlayerPedId()
			
			-- Player
			SetPlayerInvincible(ped, true)

			-- Camera
			RenderScriptCams(false, false, 0, 1, 0)
			DestroyCam(cam, false)
			if(not DoesCamExist(cam)) then
				cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
				SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
				SetCamRot(cam, 0.0, 0.0, 0.0)
				SetCamActive(cam,  true)
				RenderScriptCams(true,  false,  0,  true,  true)
				SetCamCoord(cam, GetEntityCoords(GetPlayerPed(-1)))
			end
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
			if zoom == "visage" or zoom == "pilosite" then
				SetCamCoord(cam, x+0.2, y+0.5, z+0.7)
				SetCamRot(cam, 0.0, 0.0, 150.0)
			elseif zoom == "vetements" then
				SetCamCoord(cam, x+0.3, y+2.0, z+0.0)
				SetCamRot(cam, 0.0, 0.0, 170.0)
			end
			SetEntityHeading(GetPlayerPed(-1), heading)
		else
			Citizen.Wait(500)
		end
	end

end)


function OpenMenu(submitCb, cancelCb, restrict)
	local playerPed = PlayerPedId()

	TriggerEvent('skinchanger:getSkin', function(skin)
		lastSkinOld = skin
	end)

	TriggerEvent('skinchanger:getData', function(components, maxVals)
		local elements    = {}
		local _components = {}

		-- Restrict menu
		if restrict == nil then
			for i=1, #components, 1 do
				_components[i] = components[i]
			end
		else
			for i=1, #components, 1 do
				local found = false

				for j=1, #restrict, 1 do
					if components[i].name == restrict[j] then
						found = true
					end
				end

				if found then
					table.insert(_components, components[i])
				end
			end
		end


		for i=1, #_components, 1 do
			local value       = _components[i].value
			local componentId = _components[i].componentId

			if componentId == 0 then
				value = GetPedPropIndex(playerPed, _components[i].componentId)
			end

			local data = {
				label     = _components[i].label,
				name      = _components[i].name,
				value     = value,
				min       = _components[i].min,
				textureof = _components[i].textureof,
				zoomOffset= _components[i].zoomOffset,
				camOffset = _components[i].camOffset,
				type      = 'slider'
			}

			for k,v in pairs(maxVals) do
				if k == _components[i].name then
					data.max = v
					break
				end
			end

			table.insert(elements, data)
		end

		CreateSkinCam()
		zoomOffsetOld = _components[1].zoomOffset
		camOffsetOld = _components[1].camOffset

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin', {
			title    = _U('skin_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			TriggerEvent('skinchanger:getSkin', function(skin)
				lastSkinOld = skin
			end)

			submitCb(data, menu)
			DeleteSkinCam()
		end, function(data, menu)
			menu.close()
			DeleteSkinCam()
			TriggerEvent('skinchanger:loadSkin', lastSkinOld)

			if cancelCb ~= nil then
				cancelCb(data, menu)
			end
		end, function(data, menu)
			local skin, components, maxVals

			TriggerEvent('skinchanger:getSkin', function(getSkin)
				skin = getSkin
			end)

			zoomOffsetOld = data.current.zoomOffset
			camOffsetOld = data.current.camOffset

			if skin[data.current.name] ~= data.current.value then

				TriggerEvent('skinchanger:change', data.current.name, data.current.value)


				TriggerEvent('skinchanger:getData', function(comp, max)
					components, maxVals = comp, max
				end)

				local newData = {}

				for i=1, #elements, 1 do
					newData = {}
					newData.max = maxVals[elements[i].name]

					if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
						newData.value = 0
					end

					menu.update({name = elements[i].name}, newData)
				end

				menu.refresh()
			end
		end, function(data, menu)
			DeleteSkinCam()
		end)
	end)
end

function CreateSkinCam()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)

	isCameraActiveOld = true
	SetCamRot(cam, 0.0, 0.0, 270.0, true)
	SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
	isCameraActiveOld = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isCameraActiveOld then
			DisableControlAction(2, 30, true)
			DisableControlAction(2, 31, true)
			DisableControlAction(2, 32, true)
			DisableControlAction(2, 33, true)
			DisableControlAction(2, 34, true)
			DisableControlAction(2, 35, true)
			DisableControlAction(0, 25, true) -- Input Aim
			DisableControlAction(0, 24, true) -- Input Attack

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			local angle = headingOld * math.pi / 180.0
			local theta = {
				x = math.cos(angle),
				y = math.sin(angle)
			}

			local pos = {
				x = coords.x + (zoomOffsetOld * theta.x),
				y = coords.y + (zoomOffsetOld * theta.y)
			}

			local angleToLook = headingOld - 140.0
			if angleToLook > 360 then
				angleToLook = angleToLook - 360
			elseif angleToLook < 0 then
				angleToLook = angleToLook + 360
			end

			angleToLook = angleToLook * math.pi / 180.0
			local thetaToLook = {
				x = math.cos(angleToLook),
				y = math.sin(angleToLook)
			}

			local posToLook = {
				x = coords.x + (zoomOffsetOld * thetaToLook.x),
				y = coords.y + (zoomOffsetOld * thetaToLook.y)
			}

			SetCamCoord(cam, pos.x, pos.y, coords.z + camOffsetOld)
			PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffsetOld)

			ESX.ShowHelpNotification(_U('use_rotate_view'))
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	local angle = 90

	while true do
		Citizen.Wait(0)

		if isCameraActiveOld then
			if IsControlPressed(0, 108) then
				angle = angle - 1
			elseif IsControlPressed(0, 109) then
				angle = angle + 1
			end

			if angle > 360 then
				angle = angle - 360
			elseif angle < 0 then
				angle = angle + 360
			end

			headingOld = angle + 0.0
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenSaveableMenu(submitCb, cancelCb, restrict)
	TriggerEvent('skinchanger:getSkin', function(skin)
		lastSkinOld = skin
	end)

	OpenMenu(function(data, menu)
		menu.close()
		DeleteSkinCam()

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('ds_clotheshops:save', skin)

			if submitCb ~= nil then
				submitCb(data, menu)
			end
		end)

	end, cancelCb, restrict)
end

AddEventHandler('playerSpawned', function()
	Citizen.CreateThread(function()
		while not playerLoaded do
			Citizen.Wait(100)
		end
		if FirstSpawn then
			ESX.TriggerServerCallback('ds_clotheshops:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
					TriggerEvent('skinchanger:loadSkin', {sex = 0})
				else
					TriggerEvent('skinchanger:loadSkin', skin)
				end
			end)

			FirstSpawn = false
		end
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	playerLoaded = true
end)

AddEventHandler('ds_clotheshops:getLastSkin', function(cb)
	cb(lastSkinOld)
end)

AddEventHandler('ds_clotheshops:setLastSkin', function(skin)
	lastSkinOld = skin
end)

RegisterNetEvent('ds_clotheshops:openMenu')
AddEventHandler('ds_clotheshops:openMenu', function(submitCb, cancelCb)
	OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('ds_clotheshops:openRestrictedMenu')
AddEventHandler('ds_clotheshops:openRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('ds_clotheshops:openSaveableMenu')
AddEventHandler('ds_clotheshops:openSaveableMenu', function(submitCb, cancelCb)
	ShowskinBarbershop(true)
end)

RegisterNetEvent('ds_clotheshops:openSaveableRestrictedMenu')
AddEventHandler('ds_clotheshops:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('ds_clotheshops:requestSaveSkin')
AddEventHandler('ds_clotheshops:requestSaveSkin', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('ds_clotheshops:responseSaveSkin', skin)
	end)
end)


function OpenShopMenu()
  
  local price = 250
  
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'shop_clothes',
    {
      title = _U('shop_clothes'),
	  align    = 'bottom-right',
      elements = {
        { label = _U('yes') .. ' (<span style="color:#ffffff;">$' .. price .. '<span style="color:#FFFFFF;">)', value = 'yes' },
        { label = _U('no'), value = 'no' },
      }
    },
    function (data, menu)
      if data.current.value == 'yes' then
        TriggerServerEvent('ds_clotheshops:buyclothes', price)
      end
      menu.close()
    end,
    function (data, menu)
      menu.close()
    end
  )

end

AddEventHandler('ds_clotheshops:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {}
end)

AddEventHandler('ds_clotheshops:hasExitedMarker', function(zone)
	
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil

end)

-- Create Blips
Citizen.CreateThread(function()

	for i=1, #Config.Shops, 1 do

		local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

		SetBlipSprite (blip, 71)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 51)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Barber')
		EndTextCommandSetBlipName(blip)
	end

end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('ds_clotheshops:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('ds_clotheshops:hasExitedMarker', LastZone)
		end

	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then

				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()

			end

		end

	end
end)
