local imgui = require('mimgui')
local dlstatus = require('moonloader').download_status
local inicfg = require('inicfg')

update_state = false 
update_found = false

local new = imgui.new
local upd = new.bool(false)
local file = 'Upd'

local script_vers = 1.0
local script_vers_text = "v1.0"

local update_url = 'https://raw.githubusercontent.com/AstralRaze-Lua/updtest/refs/heads/main/update.ini'

local script_url = 'https://raw.githubusercontent.com/AstralRaze-Lua/updtest/refs/heads/main/upd.lua'
local script_path = thisScript().path

local ini = inicfg.load({

}, file)

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    check_update()
    sampRegisterChatCommand('emm', function()
                sampAddChatMessage('ti bot', -1)
        end)

    sampRegisterChatCommand('checkupd', function ()
        upd[0] = not upd[0]
    end)
    while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}asdasdasd.", 0xFF0000)
                end
            end)
            break
        end
    end
end

imgui.OnFrame(function() return upd[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(245, 270), imgui.Cond.Always)
    imgui.Begin('##window', upd, imgui.WindowFlags.NoResize)
    if update_found then
        if imgui.Button('Download') then
            update_state = true
        end
    end
    imgui.End()
end)

function check_update()
    downloadUrlToFile(update_url, file, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, file)
            if tonumber(updateIni.info.vers) > script_vers then 
                sampAddChatMessage("{FFFFFF}asdasdas: {32CD32}"..updateIni.info.vers_text..". {FFFFFF}/update asda", 0xFF0000) -- ???????? ? ????? ??????.
                update_found = true
            end
            os.remove(file)
        end
    end)
end

function save()
    inicfg.save(ini, file)
end
