-- Dont remove this line, it is required for the script to run properly.
-- Helper Hunting Script for Growtopia (mod menu gentahax v 5.23+)

--===================[ GLOBAL VARIABLES ]===================--
local vaultTiles = {}
local pathMakerTileInfo = {}
local itemInfo = {}
local itemDropped = { 242, 1796, 7188 }
-- update maling mannequin, display block, display shelf kalo lagi niat 
-- mending scroll fesnuk😋😝
-- local itemMaling = {}
local running = false
local typ = "nn"
local len = 1
local name = ""
local position = "front"
local delay = 5000
local autoMode = false
local paused = false
local lastOverlayTime = 0

--===================[ UTILITY ]===================--
function ovlay(msg)
    local var = {}
    var[0] = "OnTextOverlay"
    var[1] = "`9[HELPER] `7" .. msg
    sendVariant(var)
end

--===================[ WORLD FINDER ]===================--
function makeWorldName()
    local chars = (typ == "wn") and "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" or "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local world = ""

    if len < 1 or #name > 24 or len + #name > 24 then return nil end

    if position == "mid" then
        if #name >= len then return nil end
        local space = len - #name
        local half = math.floor(space / 2)
        local prefix, suffix = "", ""
        for i = 1, half do
            local r = math.random(1, #chars)
            prefix = prefix .. chars:sub(r, r)
        end
        for i = 1, (space - half) do
            local r = math.random(1, #chars)
            suffix = suffix .. chars:sub(r, r)
        end
        world = prefix .. name .. suffix

    elseif position == "front" then
        local gen = ""
        for i = 1, len do
            local r = math.random(1, #chars)
            gen = gen .. chars:sub(r, r)
        end
        world = name .. gen

    else -- end
        local gen = ""
        for i = 1, len do
            local r = math.random(1, #chars)
            gen = gen .. chars:sub(r, r)
        end
        world = gen .. name
    end

    if #world > 24 then
        world = world:sub(1, 24)
    end

    return world
end

function autoLoop()
    while true do
        if running and autoMode and not paused then
            -- Cek item add diworld
            for _, obj in pairs(getWorldObject()) do
                for _, id in ipairs(itemDropped) do
                    if obj.id == id then
                        paused = true
                        lastOverlayTime = 0 -- reset overlay
                        ovlay("`4Auto paused! Found drop item ID: " .. id)
                        break
                    end
                end
                if paused then break end
            end

            if not paused then
                local world = makeWorldName()
                if world then
                    ovlay("Join To `9" .. world .. "`")
                    sendPacket(3, "action|join_request\nname|" .. world .. "\ninvitedWorld|0")
                else
                    ovlay("Invalid config.")
                    running = false
                    autoMode = false
                end
            end
            sleep(delay)
        end

        if running and autoMode and paused then
            local now = os.time()
            if now - lastOverlayTime >= 2 then
                lastOverlayTime = now
                for _, obj in pairs(getWorldObject()) do
                    for _, id in ipairs(itemDropped) do
                        if obj.id == id then
                            ovlay("`4Paused! Still detecting item ID: " .. id)
                            break
                        end
                    end
                end
            end
        end
        sleep(500)
    end
end

function manualFind()
    local world = makeWorldName()
    if not world then
        ovlay("Invalid config. Check /set.")
        return
    end
    ovlay("Join To `9" .. world .. "`")
    paused = false
    sendPacket(3, "action|join_request\nname|" .. world .. "\ninvitedWorld|0")
end

--===================[ VAULT BYPASS ]===================--
function getVaultTiles()
    vaultTiles = {}
    for _, tile in pairs(getTile()) do
        if tile and tile.fg and tile.pos and tile.pos.x and tile.pos.y then
            if tile.fg == 8878 then
                table.insert(vaultTiles, {x = tile.pos.x, y = tile.pos.y, fg = tile.fg})
            end
        end
    end
end

--===================[ PATH MAKER ]===================--
function getPathMakerTile()
    pathMakerTileInfo = {}
    for _, tile in pairs(getTile()) do
        if tile and tile.fg and tile.pos and tile.pos.x and tile.pos.y then
            if tile.fg == 1684 or tile.fg == 4482 then
                table.insert(pathMakerTileInfo, {x = tile.pos.x, y = tile.pos.y, fg = tile.fg})
            end
        end
    end
end

--===================[ MAGNET ]===================--
function getItemObject()
    itemInfo = {}
    for _, item in pairs(getWorldObject()) do
        table.insert(itemInfo, "\nadd_label_with_icon_button|small|`wItem : `9" .. getItemByID(item.id).name .. " `wAmount : [`b" .. item.amount .. "``]|left|" .. item.id .. "|" .. item.oid .. "|\n")
    end
end

--===================[ DIALOG HELP ]===================--
local helper = [[

add_label_with_icon|big|`9HELPER HUNTING [BETA]|left|12900|
add_spacer|small|
add_label_with_icon|small|`w/set -> `7Configure world finder|left|32|
add_label_with_icon|small|`w/manual -> `7Manually search for a world|left|6276|
add_label_with_icon|small|`w/stop -> `7Stop the auto finder|left|2584|
add_label_with_icon|small|`w/next -> `7Resume if paused|left|482|
add_label_with_icon|small|`w/menu -> `7Show menu|left|550|
add_label_with_icon|small|`w/bypass -> `7Bypass Vault|left|8878|
add_label_with_icon|small|`w/pscan -> `7Scan Path Maker|left|4482|
add_label_with_icon|small|`w/magnet -> `7Take dropped items|left|6140|
add_label_with_icon|small|`w/w (world) -> `7Warp to a world|left|3802|
add_label_with_icon|small|`w/id (id) -> `7Warp to ID|left|858|
add_spacer|small|
add_label_with_icon|small|`9Dont Forget To Join My Discord Community!|left|2480|
add_image_button|gazette_YouTube|interface/large/gazette/gazette_5columns_btn04.rttex|7imageslayout20|https://www.youtube.com/KriboGTPS|Jangan lupa subrek ya ler|
add_image_button|gazette_DiscordServer|interface/large/gazette/gazette_5columns_social_btn01.rttex|7imageslayout20|https://discord.gg/DCNmmkxc4s|Free script? Join ler|
add_spacer|huge|
add_spacer|big|
add_quick_exit||
end_dialog|bye|||
]]

--===================[ HOOK ]===================--
function mainHook(type, pkt)
    if pkt:find("action|input\n|text|") then
        local txt = pkt:match("text|([^\n]*)") or ""
        txt = txt:lower()

        if txt:find("/set") then
            local auto = autoMode and "1" or "0"
            local var = {}
            var[0] = "OnDialogRequest"
            var[1] = [[set_default_color|`o
add_label_with_icon|big|Finder Setup|left|11218|
add_text_input|world_l|World Length|]] .. len .. [[|3|
add_text_input|world_t|World Type (nn/wn/n)|]] .. typ .. [[|3|
add_text_input|world_n|Set World|]] .. name .. [[|12|
add_text_input|world_p|Position (front/mid/end)|]] .. position .. [[|5|
add_text_input|world_d|Delay in ms|]] .. delay .. [[|5|
add_checkbox|world_a|Enable Auto Search|]] .. auto .. [[|
end_dialog|set_find_world|Cancel|OK|]]
            sendVariant(var, -1, 700)
            return true
        elseif txt:find("/stop ") then
            running = false
            autoMode = false
            paused = false
            ovlay("Auto finder stopped.")
            return true
        elseif txt:find("/manual ") then
            manualFind()
            return true
        elseif txt:find("/next ") then
    if running and paused then
        paused = false
        ovlay("`2Resuming auto finder...")
    else
        ovlay("`9Auto finder is not paused.")
    end
    return true
        elseif txt:find("/menu ") then
            local var = {}
            var[0] = "OnDialogRequest"
            var[1] = helper
            sendVariant(var)
           -- jgn alay ovlay("Opened helper menu.")
            return true
        elseif txt:find("/bypass ") then
            getVaultTiles()
            local dialog = {
                "add_label_with_icon|big|SAFE VAULT BYPASS|left|10024|",
                "add_spacer|small|",
                "add_smalltext|Click vault to cancel wrench.|",
                "add_spacer|small|"
            }
            if #vaultTiles > 0 then
                for i, tile in ipairs(vaultTiles) do
                    table.insert(dialog, "add_label_with_icon_button|small|`0Vault: `9X:"..tile.x.." `9Y:"..tile.y.."|left|"..tile.fg.."|vault_"..i.."|")
                end
            else
                table.insert(dialog, "add_label||No vaults found.|big|")
            end
            table.insert(dialog, "add_quick_exit||")
            table.insert(dialog, "end_dialog|vault_hack|Close|OK|")
            local var = {}
            var[0] = "OnDialogRequest"
            var[1] = table.concat(dialog, "\n")
            sendVariant(var)
            return true
        elseif txt:find("/pscan ") then
            getPathMakerTile()
            local dialog = {
                "add_label_with_icon|big|PATH MAKER EXPLOIT|left|10024|",
                "add_spacer|small|",
                "add_smalltext|Click pathmaker tile after wrenching.|",
                "add_spacer|small|"
            }
            if #pathMakerTileInfo > 0 then
                for i, tile in ipairs(pathMakerTileInfo) do
                    table.insert(dialog, "add_label_with_icon_button|small|`0Tile:  `9X:"..tile.x.." `9Y:"..tile.y.."|left|"..tile.fg.."|tile_"..i.."|")
                end
            else
                table.insert(dialog, "add_label||No path tiles found.|big|")
            end
            table.insert(dialog, "add_quick_exit||")
            table.insert(dialog, "end_dialog|pathhack|Close|OK|")
            local var = {}
            var[0] = "OnDialogRequest"
            var[1] = table.concat(dialog, "\n")
            sendVariant(var)
            return true
        elseif txt:find("/magnet ") then
            getItemObject()
            local var = {}
            var[0] = "OnDialogRequest"
            var[1] = string.format("add_label_with_icon|big|MAGNET EXPLOIT|left|10024|\nadd_spacer|small|\nadd_smalltext|Ensure you have at least one 'Extract O' Snap' and that the item is located in a public (unlocked) area before proceeding.|"..table.concat(itemInfo).."\nadd_quick_exit|||\nend_dialog|scann|Exit||")
            sendVariant(var, -1, 100)
            return true
        elseif txt:find("^/w%s") then
            local worldn = txt:match("^/w%s+(.+)")
            if worldn then
                sendPacket(3, "action|join_request\nname|" .. worldn .. "\ninvitedWorld|0")
                ovlay("Warping to " .. worldn)
                return true
            end
        elseif txt:find("^/id%s") then
            local idw = txt:match("^/id%s+(%w+)")
            local wor = getWorld().name
            if idw then
                sendPacket(3, "action|join_request\nname|" .. wor .. "|" .. idw .. "\ninvitedWorld|0")
                ovlay("Join ID " .. idw)
                return true
            end
        end
    elseif pkt:find("dialog_name|vault_hack") then
        local idx = tonumber(pkt:match("buttonClicked|vault_(%d+)"))
        if idx and vaultTiles[idx] then
            local x, y = vaultTiles[idx].x, vaultTiles[idx].y
            sendPacket(2, "action|dialog_return\ndialog_name|storageboxxtreme\ntilex|"..x.."|\ntiley|"..y.."|\nitemid|1|\nbuttonClicked|cancel\nitemcount|1\n")
        end
        return true
    elseif pkt:find("dialog_name|pathhack") then
        local idx = tonumber(pkt:match("buttonClicked|tile_(%d+)"))
        if idx and pathMakerTileInfo[idx] then
            local x, y = pathMakerTileInfo[idx].x, pathMakerTileInfo[idx].y
            local here = getWorld().name
            local id = "x0xburn"
            sendPacket(2, "action|dialog_return\ndialog_name|sign_edit\ntilex|"..x.."|\ntiley|"..y.."|\nsign_text|"..id)
            sendPacket(3, "action|join_request\nname|"..here.."|"..id.."|invitedWorld|0")
        end
        return true
    elseif pkt:find("dialog_name|scann") then
        local po = pkt:match("buttonClicked|(%d+)")
        if po then
            sendPacket(2, "action|dialog_return\ndialog_name|extractor\ntilex|0|\ntiley|0|\nstartIndex|0|\nextractorID|6140|\nbuttonClicked|extractOnceObj_" .. po)
        end
        return true
    elseif pkt:find("dialog_name|set_find_world") then
        typ = pkt:match("world_t|(%w+)") or "nn"
        len = tonumber(pkt:match("world_l|(%d+)") or "1")
        name = pkt:match("world_n|([^\n]+)") or ""
        position = pkt:match("world_p|(%w+)") or "front"
        delay = tonumber(pkt:match("world_d|(%d+)") or "5000")
        autoMode = pkt:match("world_a|(%d)") == "1"
        running = autoMode
        paused = false
        if autoMode then ovlay("Auto finder started.") end
        return true
    end
end

--===================[ HOOK REGISTER + LOOP ]===================--
AddHook("OnTextPacket", "main_hook", mainHook)
autoLoop()

