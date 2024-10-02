autoupdate("https://raw.githubusercontent.com/AstralRaze-Lua/updtest/refs/heads/main/upd.json", '[' .. string.upper(thisScript().name) .. ']: ',
    "https://raw.githubusercontent.com/AstralRaze-Lua/updtest/refs/heads/main/upd.json")

--
--     _   _   _ _____ ___  _   _ ____  ____    _  _____ _____   ______   __   ___  ____  _     _  __
--    / \ | | | |_   _/ _ \| | | |  _ \|  _ \  / \|_   _| ____| | __ ) \ / /  / _ \|  _ \| |   | |/ /
--   / _ \| | | | | || | | | | | | |_) | | | |/ _ \ | | |  _|   |  _ \\ V /  | | | | |_) | |   | ' /
--  / ___ \ |_| | | || |_| | |_| |  __/| |_| / ___ \| | | |___  | |_) || |   | |_| |  _ <| |___| . \
-- /_/   \_\___/  |_| \___/ \___/|_|   |____/_/   \_\_| |_____| |____/ |_|    \__\_\_| \_\_____|_|\_\
--
-- Author: http://qrlk.me/samp
--
function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\' .. thisScript().name .. '-version.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json,
        function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                if doesFileExist(json) then
                    local f = io.open(json, 'r')
                    if f then
                        local info = decodeJson(f:read('*a'))
                        updatelink = info.updateurl
                        updateversion = info.latest
                        f:close()
                        os.remove(json)
                        if updateversion ~= thisScript().version then
                            lua_thread.create(function(prefix)
                                local dlstatus = require('moonloader').download_status
                                local color = -1
                                sampAddChatMessage(
                                (prefix .. 'Îáíàðóæåíî îáíîâëåíèå. Ïûòàþñü îáíîâèòüñÿ c ' .. thisScript().version .. ' íà ' .. updateversion),
                                    color)
                                wait(250)
                                downloadUrlToFile(updatelink, thisScript().path,
                                    function(id3, status1, p13, p23)
                                        if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                                            print(string.format('Çàãðóæåíî %d èç %d.', p13, p23))
                                        elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                            print('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')
                                            sampAddChatMessage((prefix .. 'Îáíîâëåíèå çàâåðøåíî!'), color)
                                            goupdatestatus = true
                                            lua_thread.create(function()
                                                wait(500)
                                                thisScript():reload()
                                            end)
                                        end
                                        if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                                            if goupdatestatus == nil then
                                                sampAddChatMessage(
                                                (prefix .. 'Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóñêàþ óñòàðåâøóþ âåðñèþ..'),
                                                    color)
                                                update = false
                                            end
                                        end
                                    end
                                )
                            end, prefix
                            )
                        else
                            update = false
                            print('v' .. thisScript().version .. ': Îáíîâëåíèå íå òðåáóåòñÿ.')
                        end
                    end
                else
                    print('v' ..
                    thisScript().version ..
                    ': Íå ìîãó ïðîâåðèòü îáíîâëåíèå. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà ' .. url)
                    update = false
                end
            end
        end
    )
    while update ~= false do wait(100) end
end

function main()
    sampRegisterChatCommand('ch', function()
            sampAddChatMessage('cg', -1)
        end)
    while true do
    end
end
