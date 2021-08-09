ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(0)
    end
end)

RegisterNetEvent("cmt_carspawn:openmenu")
AddEventHandler("cmt_carspawn:openmenu", function()
    OpenMenuGarage('spawn')
end)

RegisterNetEvent("cmt_carspawn:modifyAdminCarState")
AddEventHandler("cmt_carspawn:modifyAdminCarState", function(state)
    local vehicle = ESX.Game.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    if state then
        TriggerServerEvent('cmt_carspawn:modifyAdminCarState', true, plate)
    else
        TriggerServerEvent('cmt_carspawn:modifyAdminCarState', false, plate)
    end
end)

function OpenMenuGarage(PointType)
    ESX.UI.Menu.CloseAll()
    local elements = {}
    ListVehiclesMenu()
end

function ListVehiclesMenu()
    local elements = {}
    
    ESX.TriggerServerCallback('cmt_carspawn:getVehicles', function(vehicles)
    
        for _,v in pairs(vehicles) do
    
            local hashVehicule = v.vehicle.model
            local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
            local labelvehicle = vehicleName 
            local plate = v.vehicle.plate
            local label =  plate .. " - " .. labelvehicle
            local admin = v.admin
            if admin then
                table.insert(elements, {label = label, value = v})
            end
            
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
            title = _U('carspawn'), -- Translation
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()
            SpawnVehicle(data.current.value.vehicle)
        end, function(data, menu)
            menu.close()
        end)
    end)
end
function SpawnVehicle(vehicle)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    ESX.Game.SpawnVehicle(vehicle.model, {
        x = x,
        y = y,
        z = z + 1
    }, pos, function(callback_vehicle)
        ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
        SetVehRadioStation(callback_vehicle, 'OFF')
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
        local plate = GetVehicleNumberPlateText(callback_vehicle)
        plate = SetVehicleNumberPlateText(callback_vehicle, "ADMIN")
        TriggerServerEvent('ls:mainCheck', plate, callback_vehicle, true)
    end)
end

RegisterNetEvent("cmt_carspawn:setPlate")
AddEventHandler("cmt_carspawn:setPlate", function(plate)
    local vehicle = ESX.Game.GetClosestVehicle()
    SetVehicleNumberPlateText(vehicle, plate)
end)