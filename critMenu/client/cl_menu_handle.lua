print('critMenu loaded.')

AddEventHandler('critMenu.CreateMenu', function(_menuID, _menuTitle, _menuDesc, _selectText, _upText, _downText, _quitText)
    menu[_menuID] = {
        title = _menuTitle,
        buttons = {
            [1] = {text = _menuDesc, helptext = "", strike = "", desc = "You don't have any buttons set up.", event = ""},
        },
        selectText = _selectText,
        upText = _upText,
        downText = _downText,
        quitText = _quitText,
    }
end)

AddEventHandler('critMenu.AddButton', function(_menuID, _buttonID, _buttonText, _buttonRightText, _buttonStrikeThroughText, _buttonDescription, _buttonEventHandler)
    if menu[_menuID] ~= nil then
        menu[_menuID].buttons[#menu[_menuID].buttons + 1] = {
            text = _buttonText, helptext = _buttonRightText, strike = _buttonStrikeThroughText, desc = _buttonDescription, event = _buttonEventHandler, id = _buttonID
        }
    else
        print('--==[[WARNING:: YOU TRIED TO ADD A BUTTON TO A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.ShowMenu', function(_menuID)
    if menu[_menuID] ~= nil then
        scaleformId = SetScaleformMovieAsNoLongerNeeded()
        menuShown = _menuID
        buttonID = 2
        scaleformId = generateMenu(menuShown, buttonID)
        instrucitonId = generateInstruction(menuShown)
        renderMenu = true
    else
        print('--==[[WARNING:: YOU TRIED TO SHOW A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.HideMenu', function()
    renderMenu = false
    menuShown = 0
    instrucitonId = SetScaleformMovieAsNoLongerNeeded()
    buttonID = 0
    generateMenu("critmenu:internalmenu:cleanmenu:donotuse", 1)
    scaleformId = SetScaleformMovieAsNoLongerNeeded()
end)

AddEventHandler('critMenu.ModifyButton', function(_menuID, _buttonID, _buttonText, _buttonRightText, _buttonStrikeThroughText, _buttonDescription, _buttonEventHandler)
    local btnid = nil
    
    if menu[_menuID] ~= nil then
        for k, v in ipairs(menu[_menuID].buttons) do
            if menu[_menuID].buttons[k].id == _buttonID then
                btnid = k
                break
            end
        end
        if btnid ~= nil then
            menu[_menuID].buttons[btnid] = {
                text = _buttonText, helptext = _buttonRightText, strike = _buttonStrikeThroughText, desc = _buttonDescription, event = _buttonEventHandler, id = _buttonID
            }
        else
            print('--==[[WARNING:: THE BUTTON-ID YOU TRIED TO MODIFY DOES NOT EXIST ]]==--')
        end
    else
        print('--==[[WARNING:: YOU TRIED TO MODIFY A BUTTON TO A NON-EXISTENT MENU-ID ]]==--')
    end
end)