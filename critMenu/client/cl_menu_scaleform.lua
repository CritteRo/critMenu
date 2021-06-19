scaleformId = 0

menu = {
    [1] = {
        title = "CritteRo's Standard Menu",
        buttons = {
            [1] = {text = "menu1", helptext = ">>", strike = "", event = "toggle.me"},
            [2] = {text = "menu2", helptext = ">>", strike = "", event = "toggle.me"},
            [3] = {text = "menu3", helptext = ">>", strike = "", event = "toggle.me"},
            [4] = {text = "menu4", helptext = ">>", strike = "", event = "toggle.me"},
            [5] = {text = "menu5", helptext = ">>", strike = "", event = "toggle.me"},
        },
    },
}

menuShown = 0
renderMenu = false
buttonID = 0

function generateMenu(_menuID)
    local scaleform = RequestScaleformMovie("ORBITAL_CANNON_CAM")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SET_STATE")
    PushScaleformMovieMethodParameterInt(1)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_MENU_TITLE")
    PushScaleformMovieMethodParameterString(_title)
    EndScaleformMovieMethod()

    for k, v in ipairs(menu[_menuID].buttons) do
        BeginScaleformMovieMethod(scaleform, "ADD_MENU_ITEM")
        PushScaleformMovieMethodParameterInt(k)
        PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].text)
        PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].helptext)
        PushScaleformMovieMethodParameterBool(false)
        PushScaleformMovieMethodParameterString(menu[_menuID].buttons[k].strike)
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(scaleform, "SET_MENU_ITEM_STATE")
    PushScaleformMovieMethodParameterInt(1)
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    buttonID = 1

    return scaleform
end

function updateMenuSelectedItem(itemID)
    BeginScaleformMovieMethod(scaleform, "SET_MENU_ITEM_STATE")
    PushScaleformMovieMethodParameterInt(buttonID)
    PushScaleformMovieMethodParameterBool(false)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_MENU_ITEM_STATE")
    PushScaleformMovieMethodParameterInt(itemID)
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    buttonID = itemID
end


RegisterCommand('menu', function()
    menuShown = 1
    buttonID = 1
    scaleformId = generateMenu(menuShown)
    renderMenu = true
end)

Citizen.CreateThread(function()
    while true do
        if renderMenu == true then
            DrawScaleformMovieFullscreen(scaleformId, 255, 255, 255, 255)
            if IsControlJustReleased(0,  172--[[arrowup]]) then
                if buttonID == 1 then
                    local newButtonID = #menu[menuShown].buttons
                    updateMenuSelectedItem(newButtonID)
                end
            end
            if IsControlJustReleased(0,  173--[[arrowdown]]) then
                if buttonID == #menu[menuShown].buttons then
                    local newButtonID = 1
                    updateMenuSelectedItem(newButtonID)
                end
            end
        end
        Citizen.Wait(1)
    end
end)