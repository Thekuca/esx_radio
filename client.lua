local radioMenu, onRadio, radioProp, radioChannel, radioVolume = false, false, 0, 0, 50

local function connectToRadio(channel)
    radioChannel = channel
    if not onRadio then
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
        exports["pma-voice"]:setVoiceProperty("micClicks", true)
	    onRadio = true
    end
    TriggerServerEvent('esx_radio:stateUpdate', onRadio)
    exports["pma-voice"]:setRadioChannel(channel)
    ESX.ShowNotification(TODO['joined to radio'] ..channel.. '.00 MHz')
end

local function radioOff()
    radioChannel = 0
    onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    exports["pma-voice"]:setVoiceProperty("micClicks", false)
    TriggerServerEvent('esx_radio:stateUpdate', onRadio)
    ESX.ShowNotification(TODO['you leave'])
end

local function toggleRadioAnimation()
	ESX.Streaming.RequestAnimDict("cellphone@", function()
        if radioMenu then
            TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
            radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
            AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
        else
            StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
            ClearPedTasks(PlayerPedId())
            if radioProp ~= 0 then
                DeleteObject(radioProp)
                radioProp = 0
            end
        end
    end)
end

local function toggleRadio(toggle)
    radioMenu = toggle
    SetNuiFocus(radioMenu, radioMenu)
    toggleRadioAnimation()
    SendNUIMessage({type = not radioMenu and 'close' or 'open'})
end

local function IsRadioOn()
    return onRadio
end

exports("isRadioOn", IsRadioOn)

RegisterNUICallback('joinRadio', function(data, _)
    local newRadioChannel = tonumber(data.channel)

    if newRadioChannel == nil then return ESX.ShowNotification('Invalid radio freq') end

    if newRadioChannel > Config.MaxFrequency or newRadioChannel == 0 then return ESX.ShowNotification('Invalid radio freq') end

    if radioChannel == newRadioChannel then return ESX.ShowNotification('You are already on this radio channel') end

    if not Config.RestrictedChannels[newRadioChannel] then return connectToRadio(newRadioChannel) end

    if not Config.RestrictedChannels[newRadioChannel][ESX.PlayerData.job.name] then return ESX.ShowNotification('Restricted channel') end

    connectToRadio(newRadioChannel)
end)

RegisterNUICallback('leaveRadio', function(_, _)
    if radioChannel == 0 then
        return ESX.ShowNotification('Nisi na radio signalu')
    end
    radioOff()
end)

RegisterNUICallback("volumeUp", function()
	if radioVolume <= 95 then
		radioVolume = radioVolume + 5
		ESX.ShowNotification(TODO["volume radio"] .. radioVolume, "success")
		exports["pma-voice"]:setRadioVolume(radioVolume)
	else
		 ESX.ShowNotification(TODO["decrease radio volume"], "error")
	end
end)

RegisterNUICallback("volumeDown", function()
	if radioVolume >= 10 then
		radioVolume = radioVolume - 5
		ESX.ShowNotification(TODO["volume radio"] .. radioVolume)
		exports["pma-voice"]:setRadioVolume(radioVolume)
	else
		 ESX.ShowNotification(TODO["increase radio volume"], "error")
	end
end)

RegisterNUICallback("increaseradiochannel", function(_, _)
    radioChannel = radioChannel + 1
    exports["pma-voice"]:setRadioChannel(radioChannel)
    ESX.ShowNotification(TODO["increase decrease radio channel"] .. radioChannel)
end)

RegisterNUICallback("decreaseradiochannel", function(_, _)
    if not onRadio then return end
    radioChannel = radioChannel - 1
    if radioChannel >= 1 then
        exports["pma-voice"]:setRadioChannel(radioChannel)
        ESX.ShowNotification(TODO["increase decrease radio channel"] .. radioChannel)
    end
end)

RegisterNUICallback('poweredOff', function(_, _)
    radioOff()
end)

RegisterNUICallback('escape', function(_, _)
    toggleRadio(false)
end)

CreateThread(function()
    exports["pma-voice"]:SetMumbleProperty("radioClickMaxChannel", Config.MaxFrequency)
    while onRadio do
        Wait(2000)
        if not ESX.SearchInventory(Config.Item) then radioOff() end
    end
end)

local function handleOpen()
    if not ESX.SearchInventory(Config.Item) then return ESX.ShowNotification('You don\'t have a radio') end
    toggleRadio(not radioMenu)
end

local function handleStop(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    toggleRadio(false)
    radioOff()
end

RegisterNetEvent('esx-radio:use', handleOpen)
AddEventHandler('onResourceStop', handleStop)
ESX.RegisterInput("radio", 'Toggle Radio', 'KEYBOARD', Config.OpenKey, handleOpen)