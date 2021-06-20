--[[ :: WORK IN PROGRESS :: ]]--

--[[tosId = nil

tostitle = "Terms of Service and End-User Licence Agreement"
tostext = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras mollis tellus quis nisl consectetur, eu vehicula risus scelerisque. Aliquam congue, nulla et mollis malesuada, justo risus sodales sapien, at viverra odio massa at dui. Nam orci massa, mollis ut leo nec, tristique congue sapien. Curabitur tempus accumsan magna, at elementum dui varius sit amet. Duis viverra ullamcorper sapien a vehicula. Vivamus gravida euismod ullamcorper. Morbi et mollis mauris, id facilisis quam. Proin at justo at lorem laoreet pellentesque. Vestibulum finibus urna quis orci tincidunt, in pretium arcu porttitor. In porttitor varius arcu at lobortis. Fusce in dictum arcu."
tostext2 = "Quisque neque sapien, imperdiet at turpis eget, commodo pellentesque nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus sagittis erat ac justo auctor, id convallis odio luctus. Maecenas at lorem posuere, sodales felis at, varius erat. Ut pellentesque mi sem. Etiam blandit ut ipsum eu gravida. Pellentesque sodales quam odio, sed ultricies dolor consectetur ut. Vestibulum egestas ac libero consequat iaculis."
tostext3 = "Nulla dignissim at nibh in egestas. Nunc congue lectus ac arcu tristique, placerat maximus orci cursus. Sed tempus pellentesque lectus, et rutrum mauris faucibus blandit. Vivamus nec vulputate tellus. Maecenas rutrum faucibus velit sed aliquam. Donec dui enim, venenatis non fringilla vel, ullamcorper eu elit. Maecenas dictum arcu non posuere hendrerit. Maecenas placerat faucibus turpis, vitae rhoncus erat fringilla vel. Sed id sapien quam. Pellentesque ornare pretium facilisis. Mauris volutpat odio malesuada lectus gravida efficitur."
tostext4 = "In vel placerat enim. Donec at ornare massa. Nulla maximus mauris lorem, egestas luctus eros vulputate quis. Aenean imperdiet ipsum dolor, id maximus arcu ornare in. Nam id dignissim est. Nunc venenatis aliquet libero quis elementum. Proin malesuada fermentum mauris eget ultrices. Phasellus elementum lorem nisl, et lacinia ex porttitor in. Ut fringilla tristique aliquam. Maecenas porttitor nibh ante, eget luctus leo ullamcorper sed."


function generateTos()
    local scaleform = RequestScaleformMovie("ONLINE_POLICIES")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "DISPLAY_TOS")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "INIT_BUTTONS")
    PushScaleformMovieMethodParameterString("test")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_POLICY_TITLE")
    PushScaleformMovieMethodParameterString(tostitle)
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_POLICY_INTRO")
    PushScaleformMovieMethodParameterString("Policy intro")
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_POLICY_TEXT")
    PushScaleformMovieMethodParameterString(tostext.."\n\n"..tostext2.."\n\n~y~"..tostext3.."~s~\n\n"..tostext4.."\n\n~y~"..tostext3)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_POLICY_ACCEPTED_TEXT")
    PushScaleformMovieMethodParameterString("Accepted")
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SCROLL_POLICY_TEXT")
    PushScaleformMovieMethodParameterInt(0)
    EndScaleformMovieMethod()


    

    return scaleform
end

RegisterCommand('tos', function()
    tosId = generateRP()
    renderTos = true
end)

Citizen.CreateThread(function() --main loop. Renders the scaleforms we need to. Otherwise we wait 1000ms
    while true do
        if renderTos == true then
            DrawScaleformMovieFullscreen(tosId, 255, 255, 255, 255)
            SetMouseCursorActiveThisFrame()
        end
        Citizen.Wait(1)
    end
end)]]