ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetItemCount(source, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.getInventoryItem(item)

    if items == nil then
        return 0
    else
        return items.count
    end
end

ESX.RegisterServerCallback('master_radio:hasRadio', function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
    if GetItemCount(source, 'radio') > 0 then
		cb(true)
		return
	else
		cb(false)
		return
    end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	if item.name == 'radio' and item.count < 1 then
		TriggerClientEvent('master_radio:clear', source)
	end
end)

ESX.RegisterUsableItem('radio', function(source)
	TriggerClientEvent('master_radio:open', source)
end)