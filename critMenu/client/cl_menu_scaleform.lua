scaleformId = 0
instrucitonId  = 0
credits = "Thank you for choosing ~y~critMenu~s~!\ncritMenu is an event-based scaleform menu framework, created on top of the ORBITAL_CANNON_CAM scaleform.\n\nShoutout to:\n >CritteR / CritteRo :: framework creation\n >Vespura :: Scaleforms research"
menu = {
    ["critmenu:internalmenu:cleanmenu:donotuse"] = {
        title = "changeme",
        isSubmenu = false,
        isTOS = false,
        menuParent = '',
        buttons = {
            [1] = {text = "changeme", helptext = "", strike = "", desc = "This should never show", event = "critMenu.HideMenu", id = "test", isMenu = false},
        },
        selectText = "Select",
        upText = "Up",
        downText = "Down",
        quitText = "Close Menu",
    },
    ["critmenu:internalmenu:credits"] = {
        title = "critMenu - A scaleform menu framework",
        isSubmenu = false,
        isTOS = false,
        menuParent = '',
        buttons = {
            [1] = {text = "About", helptext = "", strike = "", desc = credits, event = "critMenu.HideMenu", id = "credits", isMenu = false},
        },
        selectText = "Select",
        upText = "Up",
        downText = "Down",
        quitText = "Close",
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

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    if #menu[_menuID].buttons > 1 or menu[_menuID].isTOS then
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(4)
        ScaleformMovieMethodAddParamPlayerNameString("~INPUT_EDD5F444~")
        ButtonMessage(menu[_menuID].selectText)
        PopScaleformMovieFunctionVoid()
    
        if #menu[_menuID].buttons > 2 then
            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(3)
            ScaleformMovieMethodAddParamPlayerNameString("~INPUT_95AAEE79~")
            ButtonMessage(menu[_menuID].upText)
            PopScaleformMovieFunctionVoid()
        
            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(2)
            ScaleformMovieMethodAddParamPlayerNameString("~INPUT_E7DCE59F~")
            ButtonMessage(menu[_menuID].downText)
            PopScaleformMovieFunctionVoid()
        end
    end

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_FCF788AA~")
    ButtonMessage(menu[_menuID].quitText)
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

function generateOrbital(_menuID, activeButton)
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

function generateMenu(_menuID, _buttonID)
    local id = nil
    if menu[_menuID].isTOS == false then
        id = generateOrbital(_menuID, _buttonID)
    elseif menu[_menuID].isTOS == true then
        id = generateTos(_menuID)
    end

    return id
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
    if renderMenu then
        if menu[menuShown].isTOS ~= nil and menu[menuShown].isTOS == false then
            if buttonID >= #menu[menuShown].buttons then
                buttonID = 2
                menuMin = 2
                menuMax = 12
            else
                buttonID = buttonID + 1
            end
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
            scaleformId = generateMenu(menuShown, buttonID)
        end
    end
end)

RegisterCommand('critmenumovemenuitemup', function()
    if renderMenu then
        if menu[menuShown].isTOS ~= nil and menu[menuShown].isTOS == false then
            if buttonID <= 2 then
                buttonID = #menu[menuShown].buttons
                menuMax = #menu[menuShown].buttons
                menuMin = menuMax - 10
            else
                buttonID = buttonID - 1
            end
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET")
            scaleformId = generateMenu(menuShown, buttonID)
        end
    end
end)

RegisterCommand('critmenuclosemenu', function()
    if renderMenu then
        if menu[menuShown].isTOS == true then
            TriggerEvent('critMenu.Check.TosDenied', menuShown)
        end
        TriggerEvent('critMenu.HideMenu')
        PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    end
end)

RegisterCommand('critmenutriggeritem', function()
    if renderMenu then
        if menu[menuShown].isTOS == true then
            TriggerEvent('critMenu.Check.TosAccepted', menuShown)
        else
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
            TriggerEvent('critMenu.Check.ButtonWasUsed', menuShown, buttonID)
            if menu[menuShown].buttons[buttonID].isMenu == true then
                local newMenu = menu[menuShown].buttons[buttonID].event
                TriggerEvent('critMenu.HideMenu')
                TriggerEvent('critMenu.ShowMenu', newMenu)
            else
                TriggerEvent(menu[menuShown].buttons[buttonID].event, menuShown, menu[menuShown].buttons[buttonID].id)
            end
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)
    TriggerEvent('chat:removeSuggestion', '/critmenumovemenuitemdown')
    TriggerEvent('chat:removeSuggestion', '/critmenumovemenuitemup')
    TriggerEvent('chat:removeSuggestion', '/critmenuclosemenu')
    TriggerEvent('chat:removeSuggestion', '/critmenutriggeritem')
end)

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