local dlstatus = require('moonloader').download_status
local inicfg = require('inicfg')
local imgui = require('mimgui')

update_state = false -- Åñëè ïåðåìåííàÿ == true, çíà÷èò íà÷í¸òñÿ îáíîâëåíèå.
update_found = false -- Åñëè áóäåò true, áóäåò äîñòóïíà êîìàíäà /update.

local script_vers = 1.0
local script_vers_text = "v1.0" -- Íàçâàíèå íàøåé âåðñèè. Â áóäóùåì áóäåì å¸ âûâîäèòü ïîëçîâàòåëþ.

local update_url = 'https://raw.githubusercontent.com/AstralRaze-Lua/updtest/refs/heads/main/update.ini' -- Ïóòü ê ini ôàéëó. Ïîçæå íàì ïîíàäîáèòüñÿ.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = 'https://raw.githubusercontent.com/AstralRaze-Lua/updtest/refs/heads/main/upd.lua' -- Ïóòü ñêðèïòó.
local script_path = thisScript().path

local window = imgui.new.bool(true)

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

        sampRegisterChatCommand('hi', function ()
        sampAddChatMessage('hi', -1)
        end)

    check_update()

    while true do
        wait(0)
  
        if update_state then -- Åñëè ÷åëîâåê íàïèøåò /update è îáíîâëåíè åñòü, íà÷í¸òñÿ ñêàà÷èâàíèå ñêðèïòà.
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}Ñêðèïò {32CD32}óñïåøíî {FFFFFF}îáíîâë¸í.", 0xFF0000)
                end
            end)
            break
        end
  
    end 
end

imgui.OnFrame(function() return window[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(245, 270), imgui.Cond.Always)
    imgui.Begin('##window', window, imgui.WindowFlags.NoResize)
    if update_found then
        if imgui.Button('Download') then
            update_state = true
        end
    end
    imgui.End()
end)
function check_update() -- Ñîçäà¸ì ôóíêöèþ êîòîðàÿ áóäåò ïðîâåðÿòü íàëè÷èå îáíîâëåíèé ïðè çàïóñêå ñêðèïòà.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- Ñâåðÿåì âåðñèþ â ñêðèïòå è â ini ôàéëå íà github
                sampAddChatMessage("{FFFFFF}Èìååòñÿ {32CD32}íîâàÿ {FFFFFF}âåðñèÿ ñêðèïòà. Âåðñèÿ: {32CD32}"..updateIni.info.vers_text..". {FFFFFF}/update ÷òî-áû îáíîâèòü", 0xFF0000) -- Ñîîáùàåì î íîâîé âåðñèè.
                update_found = true -- åñëè îáíîâëåíèå íàéäåíî, ñòàâèì ïåðåìåííîé çíà÷åíèå true
            end
            os.remove(update_path)
        end
    end)
end
