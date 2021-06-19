scaleformId = 0

menu = {
    ["test"] = {
        title = "CritteRo's Standard Menu",
        buttons = {
            [1] = {text = "Menu Subtitle XAXAXAXAXAXAXAXAXAXAXAXAXAX XAXAXXA", helptext = "", strike = "", desc = "This should never show", event = "toggle.me"},
            [2] = {text = "menu2", helptext = ">>", strike = "", desc = "Item Description\n\n\nnumber 2", event = "menu.Item2"},
            [3] = {text = "menu3", helptext = ">>", strike = "", desc = "Item Description number 3", event = "menu.Item3"},
            [4] = {text = "menu4", helptext = ">>", strike = "", desc = "Item Description number 4", event = "menu.Item4"},
            [5] = {text = "menu5", helptext = ">>", strike = "", desc = "Item Description number 5", event = "menu.Item5"},
        },
    },
}

menuShown = 0
renderMenu = false
buttonID = 0
menuMin = 2
menuMax = 12

function generateMenu(_menuID, activeButton)
    local scaleform = RequestScaleformMovie("ORBITAL_CANNON_CAM")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SET_STATE")
    PushScaleformMovieMethodParameterInt(1)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_MENU_TITLE")
    PushScaleformMovieMethodParameterString(menu[_menuID].title)
    EndScaleformMovieMethod()

    getMenuItemRange(activeButton)

    BeginScaleformMovieMethod(scaleform, "ADD_MENU_ITEM")
    PushScaleformMovieMethodParameterInt(1)
    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[1].text)
    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[1].helptext)
    PushScaleformMovieMethodParameterBool(false)
    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[1].strike)
    EndScaleformMovieMethod()


    for k, v in ipairs(menu[_menuID].buttons) do
        if k ~= 1 then
            BeginScaleformMovieMethod(scaleform, "REMOVE_MENU_ITEM")
            PushScaleformMovieMethodParameterInt(k)
            EndScaleformMovieMethod()
            if k >= menuMin and k <= menuMax then
                BeginScaleformMovieMethod(scaleform, "ADD_MENU_ITEM")
                PushScaleformMovieMethodParameterInt(k)
                PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].text)
                PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].helptext)
                PushScaleformMovieMethodParameterBool(false)
                PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].strike)
                EndScaleformMovieMethod()
            end
        end
    end

    if #menu[_menuID].buttons < activeButton then
        BeginScaleformMovieMethod(scaleform, "SET_MENU_ITEM_STATE")
        PushScaleformMovieMethodParameterInt(1)
        PushScaleformMovieMethodParameterBool(true)
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(scaleform, "SET_MENU_HELP_TEXT")
        PushScaleformMovieMethodParameterString(menu[_menuID].buttons[1].desc)
        EndScaleformMovieMethod()
    else
        BeginScaleformMovieMethod(scaleform, "SET_MENU_ITEM_STATE")
        PushScaleformMovieMethodParameterInt(activeButton)
        PushScaleformMovieMethodParameterBool(true)
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(scaleform, "SET_MENU_HELP_TEXT")
        PushScaleformMovieMethodParameterString(menu[_menuID].buttons[activeButton].desc)
        EndScaleformMovieMethod()
    end

    buttonID = activeButton

    return scaleform
end

function getMenuItemRange(_itemID)
    if _itemID > menuMax then
        menuMin = menuMax
        menuMax = menuMin + 10
    elseif _itemID < menuMin then
        menuMax = menuMin
        menuMin = menuMax - 10
    end
end


RegisterCommand('menu', function()
    if renderMenu == false then
        TriggerEvent('critMenu.ShowMenu', "test")
    else
        TriggerEvent('critMenu.HideMenu')
    end
end)

RegisterCommand('movemenuitemdown', function()
    if buttonID >= #menu[menuShown].buttons then
        buttonID = 2
        menuMin = 2
        menuMax = 12
    else
        buttonID = buttonID + 1
    end
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    scaleformId = generateMenu(menuShown, buttonID)
end)
TriggerEvent('chat:removeSuggestion', '/movemenuitemdown')


RegisterCommand('movemenuitemup', function()
    if buttonID <= 2 then
        buttonID = #menu[menuShown].buttons
        menuMax = #menu[menuShown].buttons
        menuMin = menuMax - 10
    else
        buttonID = buttonID - 1
    end
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    scaleformId = generateMenu(menuShown, buttonID)
end)
TriggerEvent('chat:removeSuggestion', '/movemenuitemup')


RegisterCommand('menuclosemenu', function()
    if renderMenu then
        TriggerEvent('critMenu.HideMenu')
        PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    end
end)
TriggerEvent('chat:removeSuggestion', '/menuclosemenu')

RegisterCommand('menutriggeritem', function()
    if renderMenu then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
        TriggerEvent(menu[menuShown].buttons[buttonID].event)
    end
end)
TriggerEvent('chat:removeSuggestion', '/menutriggeritem')


RegisterKeyMapping('movemenuitemup', 'Menu Up', 'keyboard', 'arrow_up')
RegisterKeyMapping('movemenuitemdown', 'Menu Down', 'keyboard', 'arrow_up')
RegisterKeyMapping('menuclosemenu', 'Close Menu', 'keyboard', 'backspace')
RegisterKeyMapping('menutriggeritem', 'Menu Use Item', 'keyboard', 'enter')

Citizen.CreateThread(function()
    while true do
        if renderMenu == true then
            DrawScaleformMovieFullscreen(scaleformId, 255, 255, 255, 255)
        end
        Citizen.Wait(1)
    end
end)