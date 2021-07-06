ESX = nil
local ISopen, RChannel, RPower = false, 0, false
local Radio = {
	Prop = `prop_cs_hand_radio`,
	Handle = nil,
	Offset = vector3(0.0, 0.0, 0.0),
	Rotation = vector3(0.0, 0.0, 0.0),
	Dictionary = {
		"cellphone@",
		"cellphone@in_car@ds",
		"cellphone@str",    
		"random@arrests",  
	},
	Animation = {
		"cellphone_text_in",
		"cellphone_text_out",
		"cellphone_call_listen_a",
		"generic_radio_chatter",
	}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		SetNuiFocus(false, false)
	end
end)

function toggleShow(Open)
	local playerPed = PlayerPedId()
	local count = 0
	
	local isFalling = IsPedFalling(playerPed)
	local isDead = IsEntityDead(playerPed)
	
	if isFalling or isDead then
		ISopen = false
		return
	end
	
	ISopen = Open
	
	if ISopen then
		TriggerEvent("masterking32:closeAllUI")
		Citizen.Wait(100)
		SendNUIMessage({type = 'show'})
		SetNuiFocus(true, true)
	else
		SendNUIMessage({type = 'hide'})
		SetNuiFocus(false, false)
	end
end

RegisterNetEvent('masterking32:closeAllUI')
AddEventHandler('masterking32:closeAllUI', function()
	SendNUIMessage({type = 'hide'})
	SetNuiFocus(false, false)
end)

RegisterNetEvent("master_radio:clear")
AddEventHandler("master_radio:clear", function()
	if ISopen then
		toggleShow(false)
	end
	
	RPower = false
	RChannel = 0
	exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
	exports["pma-voice"]:setRadioChannel(0)
	--exports["mumble-voip"]:SetRadioChannel(0)
	--exports["mumble-voip"]:SetMumbleProperty("radioEnabled", false)
end)

RegisterNetEvent("master_radio:open")
AddEventHandler("master_radio:open", function()
	toggleShow(true)
end)

RegisterNUICallback('setdata', function(data)
	ISopen = false
	if data ~= nil and data.power ~= nil and data.power == true and data.channel ~= nil and tonumber(data.channel) > 0 and tonumber(data.channel) <= 999 then
		RChannel = tonumber(data.channel)
		RPower = true
	else
		RPower = false
		RChannel = 0
	end
	
	exports["pma-voice"]:setVoiceProperty("radioEnabled", RPower)
	exports["pma-voice"]:setRadioChannel(RChannel)
	
	--exports["mumble-voip"]:SetRadioChannel(RChannel)
	--exports["mumble-voip"]:SetMumbleProperty("radioEnabled", RPower)
	
	toggleShow(false)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	if ISopen then
		ISopen = false
		SendNUIMessage({type = 'hide'})
		SetNuiFocus(false, false)
	end
end)

AddEventHandler("onClientResourceStart", function(resName)
	if GetCurrentResourceName() ~= resName and "mumble-voip" ~= resName then
		return
	end
	exports["mumble-voip"]:SetRadioChannel(0)
	exports["mumble-voip"]:SetMumbleProperty("radioEnabled", false)
	--exports["mumble-voip"]:SetMumbleProperty("radioClickMaxChannel", 999) -- Set radio clicks enabled for all radio frequencies
	--exports["mumble-voip"]:SetMumbleProperty("radioEnabled", false) -- Disable radio control
end)
