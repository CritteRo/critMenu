scaleformId = 0
instrucitonId  = 0

menu = {
    ["critmenu:internalmenu:cleanmenu:donotuse"] = {
        title = "changeme",
        buttons = {
            [1] = {text = "changeme", helptext = "", strike = "", desc = "This should never show", event = "critMenu.HideMenu", id = "test"},
        },
        selectText = "Select",
        upText = "Up",
        downText = "Down",
        quitText = "Close Menu",
    },
    ["critmenu:test"] = {
        title = "changeme",
        buttons = {
            [1] = {text = "changeme", helptext = "", strike = "", desc = "This should never show", event = "critMenu.HideMenu", id = "test"},
            [2] = {text = "changeme1", helptext = "", strike = "", desc = "This should never show", event = "critMenu.HideMenu", id = "test1"},
            [3] = {text = "changem2e", helptext = "", strike = "", desc = "This should never show", event = "critMenu.HideMenu", id = "test2"},
            [4] = {text = "changeme3", helptext = "", strike = "", desc = "This should never show", event = "critMenu.HideMenu", id = "test3"},
        },
        selectText = "Select",
        upText = "Up",
        downText = "Down",
        quitText = "Close Menu",
    },
}

menuShown = 0
renderMenu = false
buttonID = 0
menuMin = 2
menuMax = 12

function ButtonMessage(text) --from Vespura's no-clip script. 
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function generateInstruction(_menuID) --from Vespura's no-clip script. 

    local scaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(1)
    end

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_EDD5F444~")
    ButtonMessage(menu[_menuID].selectText)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_FCF788AA~")
    ButtonMessage(menu[_menuID].quitText)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_95AAEE79~")
    ButtonMessage(menu[_menuID].upText)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_E7DCE59F~")
    ButtonMessage(menu[_menuID].downText)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function generateMenu(_menuID, activeButton)
    local scaleform = RequestScaleformMovie("ORBITAL_CANNON_CAM")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SET_STATE") --1 is the menu. Other states are used for other screens for the orbital cannon.
    PushScaleformMovieMethodParameterInt(1)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_MENU_TITLE")
    PushScaleformMovieMethodParameterString(menu[_menuID].title)
    EndScaleformMovieMethod()

    getMenuItemRange(activeButton)

    BeginScaleformMovieMethod(scaleform, "ADD_MENU_ITEM") --first item. I use it as "menu subtitle", because I can't find how to move the scaleform selection.
    PushScaleformMovieMethodParameterInt(1)
    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[1].text)
    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[1].helptext)
    PushScaleformMovieMethodParameterBool(false)
    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[1].strike)
    EndScaleformMovieMethod()

    if _menuID == "critmenu:internalmenu:cleanmenu:donotuse" then
        for k=1, 99, 1 do --this will remove 99 items from the menu...to clear it...I need to find a better way to handle this...
            BeginScaleformMovieMethod(scaleform, "REMOVE_MENU_ITEM")
            PushScaleformMovieMethodParameterInt(k)
            EndScaleformMovieMethod()
        end
    else
        for k, v in ipairs(menu[_menuID].buttons) do--looks at all "buttons"...read items
            if k ~= 1 then --make sure to not get the first one
                BeginScaleformMovieMethod(scaleform, "REMOVE_MENU_ITEM") --remove item
                PushScaleformMovieMethodParameterInt(k)
                EndScaleformMovieMethod()
                if k >= menuMin and k <= menuMax then
                    BeginScaleformMovieMethod(scaleform, "ADD_MENU_ITEM") --add it back :D
                    PushScaleformMovieMethodParameterInt(k)
                    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].text)
                    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].helptext)
                    PushScaleformMovieMethodParameterBool(false)
                    PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].strike)
                    EndScaleformMovieMethod()
                end
            end
        end
    end

    if #menu[_menuID].buttons < activeButton then --in case the menu does not have any buttons, get desc from item 1, so from the menu subtitle
        BeginScaleformMovieMethod(scaleform, "SET_MENU_ITEM_STATE")
        PushScaleformMovieMethodParameterInt(1)
        PushScaleformMovieMethodParameterBool(true)
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(scaleform, "SET_MENU_HELP_TEXT")
        PushScaleformMovieMethodParameterString(menu[_menuID].buttons[1].desc)
        EndScaleformMovieMethod()
    else --show current selected item, and render tooltip
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

function getMenuItemRange(_itemID) --this is some weird way I get the range of items that the menu should load at any time.
    menuMin = 2
    menuMax = menuMin + 10
    while _itemID > menuMax or _itemID < menuMin do
        if _itemID > menuMax then
            menuMin = menuMax
            menuMax = menuMin + 10
        elseif _itemID < menuMin then
            menuMax = menuMin
            menuMin = menuMax - 10
        end
    end
end

--[[ I use command to move navigate the menu, because I want to take advantage of RegisterKeyMapping()]]--
-- If any user wants to individually type every command to navigate the menu...good luck...
RegisterCommand('critmenumovemenuitemdown', function()
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


RegisterCommand('critmenumovemenuitemup', function()
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


RegisterCommand('critmenuclosemenu', function()
    if renderMenu then
        TriggerEvent('critMenu.HideMenu')
        PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    end
end)
TriggerEvent('chat:removeSuggestion', '/menuclosemenu')

RegisterCommand('critmenutriggeritem', function()
    if renderMenu then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
        TriggerEvent(menu[menuShown].buttons[buttonID].event, menuShown, menu[menuShown].buttons[buttonID].id)
    end
end)
TriggerEvent('chat:removeSuggestion', '/menutriggeritem')


RegisterKeyMapping('critmenumovemenuitemdown', 'Menu Down', 'keyboard', 'DOWN')
RegisterKeyMapping('critmenumovemenuitemup', 'Menu Up', 'keyboard', 'UP')
RegisterKeyMapping('critmenuclosemenu', 'Close Menu', 'keyboard', 'BACK')
RegisterKeyMapping('critmenutriggeritem', 'Menu Use Item', 'keyboard', 'RETURN')

--[[----------------------------------------------------------------------------------]]--

Citizen.CreateThread(function() --main loop. Renders the scaleforms we need to. Otherwise we wait 1000ms
    while true do
        if renderMenu == true then
            DrawScaleformMovieFullscreen(scaleformId, 255, 255, 255, 255)
            DrawScaleformMovieFullscreen(instrucitonId, 255, 255, 255, 255)
        end
        Citizen.Wait(1)
    end
end)