--[[ :: WORK IN PROGRESS :: ]]--

function generateTos(menuID)
    local scaleform = RequestScaleformMovie("ONLINE_POLICIES")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "DISPLAY_TOS")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "INIT_BUTTONS")
    PushScaleformMovieMethodParameterString("")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_POLICY_TITLE")
    PushScaleformMovieMethodParameterString(menu[menuShown].title)
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_POLICY_INTRO")
    PushScaleformMovieMethodParameterString("")
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_POLICY_TEXT")
    PushScaleformMovieMethodParameterString(menu[menuShown].buttons[1].text)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_POLICY_ACCEPTED_TEXT")
    PushScaleformMovieMethodParameterString(menu[menuShown].buttons[1].helptext)
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SCROLL_POLICY_TEXT")
    PushScaleformMovieMethodParameterInt(0)
    EndScaleformMovieMethod()

    return scaleform
end
