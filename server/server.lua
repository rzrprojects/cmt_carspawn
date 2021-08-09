ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterCommand("admincar", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if args[1] == "enable" or args[1] == "Enable" or args[1] == "true" or args[1] == "True" then
        if args[2] == nil then
            TriggerClientEvent('cmt_carspawn:modifyAdminCarState', xPlayer.source, true)
        else
            local plate = ""
            if args[3] == nil then
                plate = args[2]
            else
                plate = args[2] .. " " .. args[3]
            end
            TriggerEvent('cmt_carspawn:modifyAdminCarState', true, plate)
        end

    elseif args[1] == "disable" or args[1] == "Disable" or args[1] == "false" or args[1] == "False" then
        if args[2] == nil then
            TriggerClientEvent('cmt_carspawn:modifyAdminCarState', xPlayer.source, false)
        else
            local plate = ""
            if args[3] == nil then
                plate = args[2]
            else
                plate = args[2] .. " " .. args[3]
            end
            TriggerEvent('cmt_carspawn:modifyAdminCarState', false, plate)
        end
    elseif args[1] == "plate" or args[1] == "Plate" or args[1] == "setplate" or args[1] == "setPlate" then
        local plate = ""
        if args[3] == nil then
            plate = args[2]
        else
            plate = args[2] .. " " .. args[3]
        end
        TriggerClientEvent('cmt_carspawn:setPlate', xPlayer.source, plate)
    else
        TriggerClientEvent('esx:showNotification', source, "Invalid Command help at\nGitHub.com/\nComet1903/cmt_carspawn")
    end
end, true)

RegisterCommand("carspawn", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('carspawn:openmenu', xPlayer.source)
end, true)


ESX.RegisterServerCallback('carspawn:getVehicles', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local vehicules = {}

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner=@identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    }, function(data)
        for _, v in pairs(data) do
            local vehicle = json.decode(v.vehicle)
            table.insert(vehicules, {
                vehicle = vehicle,
                plate = v.plate,
                admin = v.admin
            })
        end

        cb(vehicules)
    end)
end)
RegisterServerEvent("carspawn:modifyAdminCarState")
AddEventHandler("carspawn:modifyAdminCarState", function(admin, plate)
    MySQL.Sync.execute('UPDATE owned_vehicles SET admin =@admin WHERE plate=@plate', {
        ['@admin'] = admin,
        ['@plate'] = plate
    })
end)