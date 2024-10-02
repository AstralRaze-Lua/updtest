local dlstatus = require('moonloader').download_status
local inicfg = require('inicfg')

update_state = false -- Если переменная == true, значит начнётся обновление.
update_found = true  -- Если будет true, будет доступна команда /update.

local script_vers = 1.0
local script_vers_text = "v1.0"                                                                          -- Название нашей версии. В будущем будем её выводить ползователю.

local update_url =
'https://raw.githubusercontent.com/AstralRaze-Lua/updtest/refs/heads/main/update.ini'                    -- Путь к ini файлу. Позже нам понадобиться.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = 'https://github.com/AstralRaze-Lua/updtest/blob/main/updcheck.lua' -- Путь скрипту.
local script_path = thisScript().path


function check_update() -- Создаём функцию которая будет проверять наличие обновлений при запуске скрипта.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- Сверяем версию в скрипте и в ini файле на github
                sampAddChatMessage(
                "{FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}" ..
                updateIni.info.vers_text .. ". {FFFFFF}/update что-бы обновить", 0xFF0000) -- Сообщаем о новой версии.
                update_found = true -- если обновление найдено, ставим переменной значение true
            end
            os.remove(update_path)
        end
    end)
end

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

    check_update()

    sampRegisterChatCommand('ky', function()
        sampAddChatMessage('ky', -1)
    end)

    --  if update_found then -- Если найдено обновление, регистрируем команду /update.
    sampRegisterChatCommand('upd', function() -- Если пользователь напишет команду, начнётся обновление.
        update_state = true                 -- Если человек пропишет /update, скрипт обновится.
    end)
    -- else
    --sampAddChatMessage('{FFFFFF}Нету доступных обновлений!')
    -- end

    while true do
        wait(0)

        if update_state then -- Если человек напишет /update и обновлени есть, начнётся скаачивание скрипта.
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}Скрипт {32CD32}успешно {FFFFFF}обновлён.", 0xFF0000)
                end
            end)
            break
        end
    end
end
