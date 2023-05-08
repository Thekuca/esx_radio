CreateThread(function()
    for channel, jobs in pairs(Config.RestrictedChannels) do
        exports['pma-voice']:addChannelCheck(channel, function(source)
            return jobs[Player(source).state.job.name]
        end)
    end
end)

ESX.RegisterUsableItem(Config.Item, function(source)
    TriggerClientEvent('esx-radio:use', source)
end)

RegisterNetEvent('esx_radio:stateUpdate', function(state)
    local xTarget = ESX.GetPlayerFromId(source)
    xTarget.set('onRadio', state)
end)