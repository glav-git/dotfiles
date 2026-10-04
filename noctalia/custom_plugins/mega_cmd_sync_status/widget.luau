-- Noctalia v5 scripted bar widget showing MEGAcmd sync status.

local issues, problems, busy = 0, 0, 0
local megaCmdServerRunning, megaLoggedIn = false, false;
local dNum, dTotal, dTotalSize = "0", "0.00", "B"
local uNum, uTotal, uTotalSize = "0", "0.00", "B"

local IDLE_REFRESH_RATE = 5000
local BUSY_REFRESH_RATE = 500
local IS_BUSY = true

barWidget.setGlyph("cloud")
noctalia.setUpdateInterval(BUSY_REFRESH_RATE)

function renderWidget(glyph: string, color: string, text: string?)
    barWidget.setGlyph(glyph)
    barWidget.setGlyphColor(color)
    if text ~= nil then
        barWidget.setText(text)
        barWidget.setColor(color)
    end
end

function update()
    -- cmd not running guard
    noctalia.runAsync('pgrep -u "$UID" -x mega-cmd-server >/dev/null', function(result)
        megaCmdServerRunning = result.exitCode == 0
        if megaCmdServerRunning then return end
        renderWidget("cloud-off", "outline", "")
        barWidget.setTooltip("mega-cmd-server is not running")
    end)

    if not megaCmdServerRunning then return end

    -- not logged in guard
    noctalia.runAsync('mega-whoami', function(result)
        megaLoggedIn = result.exitCode == 0
        if megaLoggedIn then return end
        renderWidget("alert-triangle", "error", "login")
        barWidget.setTooltip("not logged in: run mega-login to authenticate")
    end)

    if not megaLoggedIn then return end

    -- gathering syncs info
    noctalia.runAsync('mega-sync --output-cols=RUN_STATE,STATUS,ERROR --col-separator=";"', function(result)
        if result.exitCode ~= 0 then return end
        local _problems, _busy = 0, 0
        for line in string.gmatch(result.stdout,'[^\r\n]+') do
            local run, status, err = line:match("^([^;]*);([^;]*);([^;]*)$")
            if run == "RUN_STATE" then continue end
            if run:match("^(Suspended|Disabled)$") or (err ~= "" and err ~= "NO") then
                _problems = _problems + 1
            elseif run:match("^(Pending|Loading)$") or status:match("^(Syncing|Pending|Processing)$") then
                _busy = _busy + 1
            end
        end
        problems, busy = _problems, _busy
    end)

    -- gathering issues stats
    noctalia.runAsync('mega-sync-issues --limit=0 --output-cols=ISSUE_ID,PARENT_SYNC --col-separator=";"', function(result)
        if result.exitCode ~= 0 then return end
        local _issues = 0
        for line in string.gmatch(result.stdout,'[^\r\n]+') do
            if string.find(line, ";") then _issues = _issues + 1 end
        end
        issues = math.max(_issues - 1, 0)
    end)

    -- gathering transfers stuff (owns a tooltip)
    noctalia.runAsync("mega-transfers --summary", function(out)
        if out.exitCode ~= 0 then return end;
        local lines = string.split(out.stdout, "\n")
        local parts = {}
        for word in string.gmatch(lines[#lines], "%S+") do
            table.insert(parts, word)
        end

        -- command also have "%" and "downoloaded/uploaded" amount of data
        -- but it works glitchy, since it sometimes dros progress constantly
        -- with each subsequent call, so it's value is not of any use
        dNum, _, _, dTotal, dTotalSize = table.unpack(parts, 1, 5)
        uNum, _, _, uTotal, uTotalSize = table.unpack(parts, 7, 11)
        local tooltip = {
            {"NUM DOWNLOADS",    dNum},
            {"LEFT TO DOWNLOAD", dTotal .. " " .. dTotalSize},
            {"NUM UPLOADS",      uNum},
            {"LEFT TO UPLOAD",   uTotal .. " " .. uTotalSize},
            {"ISSUES",           issues},
            {"BAD SYNCS",        problems},
        }
        if dNum == "0" and uNum == "0" and IS_BUSY then
            IS_BUSY = false
            noctalia.setUpdateInterval(IDLE_REFRESH_RATE)
        elseif (dNum ~= "0" or uNum ~= "0") and not IS_BUSY then
            IS_BUSY = true
            noctalia.setUpdateInterval(BUSY_REFRESH_RATE)
        end
        barWidget.setTooltip(tooltip)
    end)

    -- rendering widget with gathered stats/info
    if (problems + issues) > 0 or uNum ~= "0" or dNum ~= "0" then
        local label, glyph, color = "", "", "primary"
        if (problems + issues) > 0 then
            color = "error"
            label = label .. "⚠" .. tostring(problems+issues)
        end
        if uNum ~= "0" then label = label .. "↑" .. uNum end
        if dNum ~= "0" then label = label .. "↓" .. dNum end
        if uNum ~= "0" then
            glyph = "cloud-upload"
        elseif dNum ~= "0" then
            glyph = "cloud-download"
        else
            glyph = "cloud"
        end
        renderWidget(glyph, color, label)
    elseif busy > 0 then
        renderWidget("cloud", "primary", "...")
    else
        renderWidget("cloud-check", "on_surface", "")
    end
end

local megaMonitorNotRunning = [[
if ! pgrep -u "$UID" -x mega-cmd-server >/dev/null; then
    echo "mega-cmd-server is not running (systemctl --user start mega-cmd-server)"
    read -rsn1 -p "Press any key to close..."
    exit 1
fi
]]

local megaLogin = [[
while true; do
    IFS= read -rp  'MEGA login: '    MEGA_LOGIN || true
    IFS= read -rsp 'MEGA password: ' MEGA_PASSWORD || true
    echo;
    mega-login "$MEGA_LOGIN" "$MEGA_PASSWORD" || continue;
    break
done
]]

local megaMonitor = [[
watch -t -n 0.5 '
    echo "== SYNCS ==";           mega-sync
    echo; echo "== ISSUES ==";    mega-sync-issues
    echo; echo "== TRANSFERS =="; mega-transfers --summary
    echo; mega-transfers --show-syncs --limit=30
'
]]

function onClick()
    if not megaCmdServerRunning then
        noctalia.runInTerminal(megaMonitorNotRunning)
    elseif not megaLoggedIn then
        noctalia.runInTerminal(megaLogin .. megaMonitor)
    else
        noctalia.runInTerminal(megaMonitor)
    end
end
