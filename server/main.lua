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

RegisterNetEvent('quickcash:server:fill', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local count = 0

    while count < amount do
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add")
        count = count + 1
    end
    Player.Functions.AddItem(item, amount)
end)

RegisterNetEvent('quickcash:server:remove', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local count = 0
    print(QBCore.Functions.HasItem(src, data.item, data.amount))
    print(data.item)
    print(data.amount)
    if QBCore.Functions.HasItem(src, data.item, data.amount) then
        while count < data.amount do
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data.item], "remove")
            count = count + 1
        end
        Player.Functions.RemoveItem(data.item, data.amount)
        print(data.reward.Item.item)
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