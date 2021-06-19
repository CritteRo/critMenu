
TriggerEvent('critMenu.CreateMenu', "test1", "Test Menu", "Test Description")
TriggerEvent('critMenu.AddButton', "test1", "Button 1", "", "test", "Descrption ", "test.event.1")
TriggerEvent('critMenu.AddButton', "test1", "Button 2", ">>", "     ", "Descrption ", "test.event.2")
TriggerEvent('critMenu.AddButton', "test1", "Button 3", "", "", "Descrption ", "test.event.3")

RegisterCommand('showmen', function()
    TriggerEvent('critMenu.ShowMenu', "test1")
end)

AddEventHandler('test.event.1', function()
    TriggerEvent('critMenu.HideMenu')
end)

AddEventHandler('test.event.2', function()
    TriggerEvent('critMenu.HideMenu')
end)

AddEventHandler('test.event.3', function()
    TriggerEvent('critMenu.HideMenu')
end)