
TriggerEvent('critMenu.CreateMenu', "test1", "_menuTitle", "_menuDesc", "_selectText", "_upText", "_downText", "_quitText")

TriggerEvent('critMenu.AddButton', "test1", "test1button", "_buttonText1", "_buttonRightText", "_strike", "_buttonDescription", "test.event")
TriggerEvent('critMenu.AddButton', "test1", "test2button", "~b~_butt~y~onText2", "~y~_buttonRightText", "_strike", "~y~_buttonDescription~s~", "test.event")
TriggerEvent('critMenu.AddButton', "test1", "test3button", "_buttonText3", "~b~_buttonRightText", "_strike", "~b~_buttonDescription", "test.event")
TriggerEvent('critMenu.AddButton', "test1", "test4button", "_buttonText4", "~g~_buttonRightText", "_strike", "~g~_buttonDescription", "test.event")

RegisterCommand('showmen', function()
    TriggerEvent('critMenu.ShowMenu', "test1")
end)

AddEventHandler('test.event', function(_menu, _button)
    TriggerEvent('critMenu.HideMenu')
    print('button ['.._button..'] from menu ['.._menu..'] triggered this event')
end)

RegisterCommand('modif', function(source, args)
    local btn = tostring(args[1])
    if btn ~= nil then
        TriggerEvent('critMenu.ModifyButton', "test1", btn, "_modified", "_modified", "", "_modified _modified _modified _modified _modified _modified _modified", "test.event")
    end
end)

RegisterCommand('remove', function(source, args)
    local btn = tostring(args[1])
    if btn ~= nil then
        TriggerEvent('critMenu.RemoveButton', "test1", btn)
    end
end)

