print('critMenu loaded.')

AddEventHandler('critMenu.CreateMenu', function(_menuID, _menuTitle, _menuDesc)
    menu[_menuID] = {
        title = _menuTitle,
        buttons = {
            [1] = {text = _menuDesc, helptext = "", strike = "", desc = "You don't have any buttons set up.", event = ""},
        }
    }
end)

AddEventHandler('critMenu.AddButton', function(_menuID, _buttonText, _buttonRightText, _buttonStrikeThroughText, _buttonDescription, _buttonEventHandler)
    if menu[_menuID] ~= nil then
        menu[_menuID].buttons[#menu[_menuID].buttons + 1] = {
            text = _buttonText, helptext = _buttonRightText, strike = _buttonStrikeThroughText, desc = _buttonDescription, event = _buttonEventHandler
        }
    else
        print('--==[[WARNING:: YOU TRIED TO ADD A BUTTON TO A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.ShowMenu', function(_menuID)
    if menu[_menuID] ~= nil then
        menuShown = _menuID
        buttonID = 2
        scaleformId = generateMenu(menuShown, buttonID)
        renderMenu = true
    else
        print('--==[[WARNING:: YOU TRIED TO SHOW A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.HideMenu', function()
    renderMenu = false
    menuShown = 0
    buttonID = 0
end)

AddEventHandler('critMenu.ModifyButton', function(_menuID, _buttonID, _buttonText, _buttonRightText, _buttonStrikeThroughText, _buttonDescription, _buttonEventHandler)
    if menu[_menuID] ~= nil then
        menu[_menuID].buttons[_buttonID] = {
            text = _buttonText, helptext = _buttonRightText, strike = _buttonStrikeThroughText, desc = _buttonDescription, event = _buttonEventHandler
        }
    else
        print('--==[[WARNING:: YOU TRIED TO MODIFY A BUTTON TO A NON-EXISTENT MENU-ID ]]==--')
    end
end)