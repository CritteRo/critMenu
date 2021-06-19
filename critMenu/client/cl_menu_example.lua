
TriggerEvent('critMenu.CreateMenu', "test1", "Test Menu", "Test Description", "~y~Select", "Up", "Down", "Close Menu")
TriggerEvent('critMenu.AddButton', "test1", "btn1", "Button 1", "", "test", "~y~Descrp~b~tion~s~", "test.event")
TriggerEvent('critMenu.AddButton', "test1", "btn2", "Button 2", ">>", "     ", "Descrption ", "test.event")
TriggerEvent('critMenu.AddButton', "test1", "btn3", "Button 3", "", "", "Descrption ", "test.event")


RegisterCommand('showmen', function()
    TriggerEvent('critMenu.ShowMenu', "test1")
end)

AddEventHandler('test.event', function(_menu, _button)
    TriggerEvent('critMenu.HideMenu')
    print('button ['.._button..'] from menu ['.._menu..'] triggered this event')
end)
