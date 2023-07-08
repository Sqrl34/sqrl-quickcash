QBCore = exports['qb-core']:GetCoreObject()
local inprogress = false
local currentBlip
local currentObject
local pickup = false
local indx
local finnishedCooldown = true
local itemsGiven = false
local drugZone



-- functions
local function createBlips()
    local starterBlip = AddBlipForCoord(Config.Blip.location.x, Config.Blip.location.y, Config.Blip.location.z)
    SetBlipColour(starterBlip, Config.Blip.color)
    SetBlipScale(starterBlip, Config.Blip.scale)
    SetBlipSprite(starterBlip, Config.Blip.sprite)
    SetBlipDisplay(starterBlip, 4)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Blip.name)
    EndTextCommandSetBlipName(starterBlip)
end

local function createTargetPed()
    local model = Config.StarterPedInfo.model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    local ped = CreatePed(0, model, Config.StarterPedInfo.coords.x, Config.StarterPedInfo.coords.y,
        Config.StarterPedInfo.coords.z, Config.StarterPedInfo.coords.w, true, false)
    FreezeEntityPosition(ped, true)
    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "client",
                event = "quickcash:client:startProcess",
                icon = 'fas fa-clipboard',
                label = "Talk to Oswald about a special project",
            }
        },
        distance = 2.5,
    })
end

local function createUsefulBlip(sprite, color, name, location)
    print(currentBlip)
    currentBlip = nil
    print(currentBlip)
    currentBlip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipColour(currentBlip, color)
    SetBlipScale(currentBlip, .6)
    SetBlipSprite(currentBlip, sprite)
    SetBlipDisplay(currentBlip, 4)
    SetBlipRoute(currentBlip, true)
    SetBlipRouteColour(currentBlip, 16)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(currentBlip)
end

local function sendMail(send, subjects, messages)
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = send,
        subject = subjects,
        message = messages,
        button = {}
    })
end

local function fillInventory(item, amount)
    TriggerServerEvent('quickcash:server:fill', item, amount)
    itemsGiven = true
end

local function doModel(newmodel, location, message, item, amount)
    local model = newmodel
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    currentObject = CreateObject(model, location.x, location.y, location.z, true, true, false)

    exports['qb-target']:AddTargetEntity(currentObject, {
        options = {
            {
                icon = 'fas fa-clipboard',
                label = 'Pick up the model',
                action = function()
                    sendMail('Oswald', 'Drop Location', message)
                    DeleteObject(currentObject)
                    fillInventory(item, amount)
                    RemoveBlip(currentBlip)
                    pickup = true
                end
            }
        },
        distance = 2.5,
    })
end




local function chooseIllegal()
    local place = math.random(1, #Config.Locations)
    indx = place
    createUsefulBlip(Config.Locations[place].Blip.sprite, Config.Locations[place].Blip.color,
        Config.Locations[place].Blip.name, Config.Locations[place].Blip.coords)
    sendMail("Osawald", "Shipment", Config.Locations[place].Messages.Pickup)
    doModel(Config.Locations[place].Prop.model, Config.Locations[place].Prop.coords,
        Config.Locations[place].Messages.Drop, Config.Locations[place].Item, Config.Locations[place].Amount)
end

local function menuDeliver()
    local deliverMenu = {
        {
            header = "Deliver Options",
            isMenuHeader = true
        }
    }

    deliverMenu[#deliverMenu + 1] = {
        header = "Place object on delivery location",
        params = {
            event = 'quickcash:client:serverTrigger',
            args = {
                item = Config.Locations[indx].Item,
                amount = Config.Locations[indx].Amount,
                reward = Config.Locations[indx].Reward,
                finished = true
            }
        }
    }

    deliverMenu[#deliverMenu + 1] = {
        header = "Close Menu",
        params = {
            event = "qb-menu:client:closeMenu"
        }
    }

    inprogress = false

    exports['qb-menu']:openMenu(deliverMenu)
end

local function closeMenu()
    exports['qb-menu']:closeMenu()
end

local function finnishIllegal()
    local location = math.random(1, #Config.DropOff.Locations)
    createUsefulBlip(Config.DropOff.Blip.sprite, Config.DropOff.Blip.color, Config.DropOff.Blip.name,
        Config.DropOff.Locations[location].coords)

    drugZone = BoxZone:Create(
    vector3(Config.DropOff.Locations[location].coords.x, Config.DropOff.Locations[location].coords.y,
        Config.DropOff.Locations[location].coords.z), 3.0, 5.0, {
        name = "deliver_zone",
        minz = Config.DropOff.Locations[location].coords.z - 2.0,
        maxz = Config.DropOff.Locations[location].coords.z + 2.0,
        debugPoly = false,
    })

    drugZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            menuDeliver()
        else
            closeMenu()
        end
    end)
end

local function cooldown()
    local time = Config.Cooldown * 60 * 1000
    finnishedCooldown = false
    Wait(time)
    finnishedCooldown = true

end

-- Events
RegisterNetEvent('quickcash:client:startProcess', function()
    if finnishedCooldown then
        if not inprogress then
            inprogress = not inprogress
            chooseIllegal()
            while not pickup do
                Wait(1000)
            end
            finnishIllegal()
            pickup = false
        else
            QBCore.Functions.Notify('You already have a job in progress.', 'error', 5000)
        end
    else
        QBCore.Functions.Notify('You have a cooldown running, take a brake', 'error', 5000)
    end
end)

RegisterNetEvent('quickcash:client:openMenu', function()
    menuDeliver()
end)

RegisterNetEvent('quickcash:client:serverTrigger', function(data)
    TriggerServerEvent('quickcash:server:remove', data)
    print("event")
    itemsGiven = false
    print("given false")
    RemoveBlip(currentBlip)
    currentBlip = nil
    print("remove blip")
    drugZone:destroy()
    print("zone destroy")
    cooldown()
    print("cooldown")
end)
-- Startup
local x = false
CreateThread(function()
    if not x then
        createBlips()
        createTargetPed()
    end
end)

-- Security

local function secure()
    if itemsGiven then
        TriggerServerEvent('quickcash:server:secureRemove', Config.Locations[indx].Item, Config.Locations[indx].Amount)
    end
    inprogress = false
    if currentBlip ~= nil then
        RemoveBlip(currentBlip)
        currentBlip = nil
    end
    if currentObject ~= nil then
        DeleteObject(currentObject)
    end
    finnishedCooldown =  true
    drugZone:destroy()
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    secure()
end)

AddEventHandler('playerDropped', function()
end)