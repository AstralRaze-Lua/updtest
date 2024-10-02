autoupdate("тут ссылка на ваш json", '[' .. string.upper(thisScript().name) .. ']: ',
    "тут ссылка на ваш сайт/url вашего скрипта на форуме (если нет, оставьте как в json)")

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
                                (prefix .. 'Обнаружено обновление. Пытаюсь обновиться c ' .. thisScript().version .. ' на ' .. updateversion),
                                    color)
                                wait(250)
                                downloadUrlToFile(updatelink, thisScript().path,
                                    function(id3, status1, p13, p23)
                                        if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                                            print(string.format('Загружено %d из %d.', p13, p23))
                                        elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                            print('Загрузка обновления завершена.')
                                            sampAddChatMessage((prefix .. 'Обновление завершено!'), color)
                                            goupdatestatus = true
                                            lua_thread.create(function()
                                                wait(500)
                                                thisScript():reload()
                                            end)
                                        end
                                        if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                                            if goupdatestatus == nil then
                                                sampAddChatMessage(
                                                (prefix .. 'Обновление прошло неудачно. Запускаю устаревшую версию..'),
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
                            print('v' .. thisScript().version .. ': Обновление не требуется.')
                        end
                    end
                else
                    print('v' ..
                    thisScript().version ..
                    ': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на ' .. url)
                    update = false
                end
            end
        end
    )
    while update ~= false do wait(100) end
end
