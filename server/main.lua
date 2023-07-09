QBCore = exports['qb-core']:GetCoreObject()

local function reward(reward)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if reward.Item.item then
        local count = 0
        while count < reward.Item.amount do
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[reward.Item.name], "add")
            count = count + 1
        end
        Player.Functions.AddItem(reward.Item.name, reward.Item.amount)
    end

    if reward.Money.bank then
        Player.Functions.AddMoney("bank", reward.Money.amount)
    end

    if reward.Money.cash then
        Player.Functions.AddMoney("cash", reward.Money.amount)
    end
end

RegisterNetEvent('quickcash:server:fill', function(index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local count = 0

    while count < Config.Locations[index].Amount do
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Locations[index].Item], "add")
        count = count + 1
    end
    Player.Functions.AddItem(Config.Locations[index].Item, Config.Locations[index].Amount)
end)

RegisterNetEvent('quickcash:server:remove', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local count = 0
    if QBCore.Functions.HasItem(src, data.item, data.amount) then
        while count < data.amount do
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "remove")
            count = count + 1
        end
        Player.Functions.RemoveItem(data.item, data.amount)
        if data.finished then
            reward(data.reward)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You do not have the required items", 'error')
    end
end)

RegisterNetEvent('quickcash:server:secureRemove', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local count = 0

    while count < amount do
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
        count = count + 1
    end
    Player.Functions.RemoveItem(item, amount)
end)
