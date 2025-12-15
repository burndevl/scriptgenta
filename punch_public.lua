
local LOCK_IDS = {
    [202]=true,
    [204]=true,
    [206]=true,
    [4994]=true
}

local OFFSETS = {
     {0,1},
     {-1,0},
     {1,0},
     {0,-1}
 }
local MOVE_DELAY  = 1000
--local world_list = "world_179_day.txt"
--local webhookURL = "https://discord.com/api/webhooks/1449963672989470741/Cuu6cf86Ef5d2EJJtBClzG4QgXrsmket9IWfv4TSrRhUvhh4n66QuVtY2Pgv3eXaKcxo"
local PUNCH_DELAY = 300
local punched         = {}
local lastPunchedLock = nil
local webhookMessage  = ""
local worlds = {}
local visited = {}

do
    local f = io.open(listhunting,"r")
    if f then
        for line in f:lines() do
            line = line:gsub("%s+","")
            if line ~= "" then
                table.insert(worlds,line)
            end
        end
        f:close()
    end
end

local function punch(x,y)
    sendPacketRaw(false,{
        type=3,value=18,
        punchx=x,punchy=y,
        x=getLocal().pos.x,
        y=getLocal().pos.y
    })
end

local function getSafePos(tx,ty)
    for _,o in ipairs(OFFSETS) do
        local px,py = tx+o[1], ty+o[2]
        local t = checkTile(px,py)
        if t and not t.isCollideable then
            return px,py
        end
    end
end

local function scanLocks()
    local r = {}
    for _,tile in pairs(getTile()) do
        if LOCK_IDS[tile.fg] then
            local k = tile.pos.x..","..tile.pos.y
            if not punched[k] then
                table.insert(r,{
                    id=tile.fg,
                    name=getItemByID(tile.fg).name or "Unknown Lock",
                    x=tile.pos.x,
                    y=tile.pos.y
                })
            end
        end
    end
    return r
end

local function getLockEmoji(n)
    n = (n or ""):lower()
    if n:find("builder") then return "<:bull:1405739883531599922>" end
    if n:find("huge")    then return "<:hl:1406580108181110836>" end
    if n:find("big")     then return "<:bl:1406580498762961108>" end
    if n:find("small")   then return "<:sl:1406580400364584960>" end
    return "<:gttrophy:1196409436063936583>"
end

local function parseBubble(t)
    local c = t:gsub("`%w",""):gsub("`","")
    local owner = c:match("^(.-)'s") or "-"
    local info = {}
    for x in c:gmatch("%((.-)%)") do table.insert(info,x) end
    return owner, info[1] or "-", info[#info] or "-"
end

local function appendLock(lock, text)
    local owner, access, info = parseBubble(text)
    webhookMessage = webhookMessage .. string.format(
        "<a:world:1211886322780864593> **World Name:** %s\n"..
        "<:burnism:1197836497760567326> **World Owner:** %s\n"..
        "%s **Lock Type:** %s\n"..
        "<a:warn:1198056757755387914> **Position Lock:** (%d,%d)\n"..
        "<a:veer:1198056364707156029> **Access Status:** %s\n"..
        "<a:nigp:1217664597981532231> **Information Lock:** %s\n\n",
        getWorld().name, owner, getLockEmoji(lock.name), lock.name,
        lock.x+1, lock.y+1, access, info
    )
end

AddHook("OnVarlist","BubbleCollector",function(v)
    if not lastPunchedLock then return end
    if v[0] ~= "OnTalkBubble" then return end
    if type(v[2]) ~= "string" then return end
    appendLock(lastPunchedLock,v[2])
    lastPunchedLock = nil
end)

runThread(function()
    for _,world in ipairs(worlds) do
        if not visited[world] then
            visited[world] = true
            webhookMessage = ""
            punched = {}

            sendPacket(3,"action|join_request\nname|"..world.."\ninvitedWorld|0")
            sleep(3000)

            local locks = scanLocks()
            for _,lock in ipairs(locks) do
                local px,py = getSafePos(lock.x,lock.y)
                if px then
                    findPath(px,py)
                    sleep(MOVE_DELAY)
                    lastPunchedLock = lock
                    punched[lock.x..","..lock.y] = true
                    punch(lock.x,lock.y)
                    sleep(PUNCH_DELAY)
                end
            end

            sleep(1200)

            if webhookMessage ~= "" then
                sendWebhook(webhookURL,{
                    username="sisterhong",
                    content=string.format(
                        "## <a:gtmegaphone:1217664707692068975> **Hunting 179 Day Logs**\n\n"..
                        "<:clock:1217664951435657226> **Time:** <t:%d:R>\n\n%s",
                        os.time(), webhookMessage
                    )
                })
            end
        end
    end
end,"freeday179")


