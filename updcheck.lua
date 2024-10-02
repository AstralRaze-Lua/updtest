local dlstatus = require('moonloader').download_status
local inicfg = require('inicfg')

update_state = false -- ���� ���������� == true, ������ ������� ����������.
update_found = true  -- ���� ����� true, ����� �������� ������� /update.

local script_vers = 1.0
local script_vers_text = "v1.0"                                                                          -- �������� ����� ������. � ������� ����� � �������� �����������.

local update_url =
'https://raw.githubusercontent.com/AstralRaze-Lua/updtest/refs/heads/main/update.ini'                    -- ���� � ini �����. ����� ��� ������������.
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = 'https://github.com/AstralRaze-Lua/updtest/blob/main/updcheck.lua' -- ���� �������.
local script_path = thisScript().path


function check_update() -- ������ ������� ������� ����� ��������� ������� ���������� ��� ������� �������.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- ������� ������ � ������� � � ini ����� �� github
                sampAddChatMessage(
                "{FFFFFF}������� {32CD32}����� {FFFFFF}������ �������. ������: {32CD32}" ..
                updateIni.info.vers_text .. ". {FFFFFF}/update ���-�� ��������", 0xFF0000) -- �������� � ����� ������.
                update_found = true -- ���� ���������� �������, ������ ���������� �������� true
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

    --  if update_found then -- ���� ������� ����������, ������������ ������� /update.
    sampRegisterChatCommand('upd', function() -- ���� ������������ ������� �������, ������� ����������.
        update_state = true                 -- ���� ������� �������� /update, ������ ���������.
    end)
    -- else
    --sampAddChatMessage('{FFFFFF}���� ��������� ����������!')
    -- end

    while true do
        wait(0)

        if update_state then -- ���� ������� ������� /update � ��������� ����, ������� ����������� �������.
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("{FFFFFF}������ {32CD32}������� {FFFFFF}�������.", 0xFF0000)
                end
            end)
            break
        end
    end
end
