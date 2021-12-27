print('critMenu loaded.')

AddEventHandler('critMenu.CreateMenu', function(_menuID, _menuTitle, _menuDesc, _selectText, _upText, _downText, _quitText)
    menu[_menuID] = {
        title = _menuTitle,
        isSubmenu = false,
        isTOS = false,
        menuParent = '',
        buttons = {
            [1] = {text = _menuDesc, helptext = "", strike = "", desc = "You don't have any buttons set up.", event = "", isMenu = false},
        },
        selectText = _selectText,
        upText = _upText,
        downText = _downText,
        quitText = _quitText,
    }
end)

AddEventHandler('critMenu.UpdateOpenMenu', function()
    if renderMenu then
        generateMenu(menuShown, buttonID)
    end
end)

AddEventHandler('critMenu.CreateSubMenu', function(_menuID, _parentID, _menuTitle, _menuDesc, _selectText, _upText, _downText, _quitText)
    menu[_menuID] = {
        title = _menuTitle,
        isSubmenu = true,
        isTOS = false,
        menuParent = _parentID,
        buttons = {
            [1] = {text = _menuDesc, helptext = "", strike = "", desc = "You don't have any buttons set up.", event = "", isMenu = false},
        },
        selectText = _selectText,
        upText = _upText,
        downText = _downText,
        quitText = _quitText,
    }
end)

AddEventHandler('critMenu.CreateTosMenu', function(_menuID, _menuTitle, _menuDesc, _selectText, _quitText)
    menu[_menuID] = {
        title = _menuTitle,
        isSubmenu = false,
        isTOS = true,
        menuParent = '',
        buttons = {
            [1] = {text = _menuDesc, helptext = "", strike = "", desc = "You don't have any buttons set up.", event = "", isMenu = false, id = "critmenu:internalid:tos"},
        },
        selectText = _selectText,
        upText = "",
        downText = "",
        quitText = _quitText,
    }
end)

AddEventHandler('critMenu.ModifyMenu', function(_menuID, _menuTitle, _menuSubtitle, _selectText, _upText, _downText, _quitText)
    if menu[_menuID] ~= nil then
        menu[_menuID].title = _menuTitle
        menu[_menuID].buttons[1].text = _menuSubtitle
        menu[_menuID].selectText = _selectText
        menu[_menuID].upText = _upText
        menu[_menuID].downText = _downText
        menu[_menuID].quitText = _quitText
    else
        print('--==[[WARNING:: YOU TRIED TO MODIFY A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.AddButton', function(_menuID, _buttonID, _buttonText, _buttonRightText, _buttonStrikeThroughText, _buttonDescription, _buttonEventHandler)
    if menu[_menuID] ~= nil then
        menu[_menuID].buttons[#menu[_menuID].buttons + 1] = {
            text = _buttonText, helptext = _buttonRightText, strike = _buttonStrikeThroughText, desc = _buttonDescription, event = _buttonEventHandler, id = _buttonID, isMenu = false
        }
    else
        print('--==[[WARNING:: YOU TRIED TO ADD A BUTTON TO A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.AddMenuButton', function(_menuID, _buttonID, _buttonText, _buttonRightText, _buttonStrikeThroughText, _buttonDescription, _buttonMenuTrigger)
    if menu[_menuID] ~= nil then
        menu[_menuID].buttons[#menu[_menuID].buttons + 1] = {
            text = _buttonText, helptext = _buttonRightText, strike = _buttonStrikeThroughText, desc = _buttonDescription, event = _buttonMenuTrigger, id = _buttonID, isMenu = true
        }
    else
        print('--==[[WARNING:: YOU TRIED TO ADD A MENU BUTTON TO A NON-EXISTENT MENU-ID ]]==--')
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
        TriggerEvent('critMenu.Check.MenuWasOpened', _menuID)
    else
        print('--==[[WARNING:: YOU TRIED TO SHOW A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.HideMenu', function()
    if menu[menuShown].isSubmenu == false then
        TriggerEvent('critMenu.Check.MenuWasClosed', menuShown)
        renderMenu = false
        menuShown = 0
        instrucitonId = SetScaleformMovieAsNoLongerNeeded()
        buttonID = 0
        generateMenu("critmenu:internalmenu:cleanmenu:donotuse", 1)
        scaleformId = SetScaleformMovieAsNoLongerNeeded()
    else
        local parent = menu[menuShown].menuParent
        if menu[parent] ~= nil then
            TriggerEvent('critMenu.Check.MenuWasClosed', menuShown)
            generateMenu("critmenu:internalmenu:cleanmenu:donotuse", 1) --needed to reset the scene
            menuShown = parent
            instrucitonId = generateInstruction(menuShown)
            buttonID = 2
            scaleformId = generateMenu(menuShown, buttonID)
        else
            print('--==[[WARNING:: YOU TRIED TO SHOW A NON-EXISTENT PARENT MENU-ID ]]==--')
        end
    end
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
                text = _buttonText, helptext = _buttonRightText, strike = _buttonStrikeThroughText, desc = _buttonDescription, event = _buttonEventHandler, id = _buttonID, isMenu = false
            }
            generateMenu(menuShown, buttonID)
        else
            print('--==[[WARNING:: THE BUTTON-ID YOU TRIED TO MODIFY DOES NOT EXIST ]]==--')
        end
    else
        print('--==[[WARNING:: YOU TRIED TO MODIFY A BUTTON TO A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.ModifyEmptyMenuDescription', function(_menuID, _newDescription)
    if menu[_menuID] ~= nil then
        if #menu[_menuID].buttons > 1 then
            print('--==[[WARNING:: MENU-ID IS NOT EMPTY. DESCRIPTION WILL NOT SHOW UNLESS YOU REMOVE THE BUTTONS FROM SCRIPT OR USING THE EVENT ]]==--')
        end
        if menu[_menuID].buttons[1] ~= nil then
            menu[_menuID].buttons[1].desc = _newDescription
            if menu[menuShown] ~= nil then
                generateMenu(menuShown, buttonID)
            end
        else
            print('^1--==[[WARNING:: THE MENU SUBTITLE BUTTON IS NIL. THIS IS BAD ]]==--')
        end
    else
        print('--==[[WARNING:: YOU TRIED TO MODIFY A DESCRIPTION TO A NON-EXISTENT MENU-ID ]]==--')
    end
end)

AddEventHandler('critMenu.RemoveButton', function(_menuID, _buttonID)
    local foundit = nil
    local newbuttons = {}
    if menu[_menuID] ~= nil then
        for k, v in ipairs(menu[_menuID].buttons) do
            if menu[_menuID].buttons[k].id == _buttonID then
                foundit = 1
                --do nothing
            else
                newbuttons[#newbuttons + 1] = menu[_menuID].buttons[k]
                print(newbuttons[#newbuttons].text)
            end
        end
        menu[_menuID].buttons = newbuttons
        local btnid = buttonID
        generateMenu("critmenu:internalmenu:cleanmenu:donotuse", 1)
        buttonID = 2
        generateMenu(menuShown, buttonID)
        if foundit ~= nil then
            --do nothing..for now
        else
            print('--==[[WARNING:: THE BUTTON-ID YOU TRIED TO REMOVE DOES NOT EXIST ]]==--')
        end
    else
        print('--==[[WARNING:: YOU TRIED TO MODIFY A BUTTON TO A NON-EXISTENT MENU-ID ]]==--')
    end
end)