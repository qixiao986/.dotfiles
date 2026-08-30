hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- Use the standardized config location, if present
custom_config = hs.fs.pathToAbsolute(os.getenv("HOME") .. '/.config/hammerspoon/private/config.lua')
if custom_config then
    print("Loading custom config")
    dofile( os.getenv("HOME") .. "/.config/hammerspoon/private/config.lua")
    privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
    if privatepath then
        hs.alert("You have config in both .config/hammerspoon and .hammerspoon/private.\nThe .config/hammerspoon one will be used.")
    end
else
    -- otherwise fallback to 'classic' location.
    if not privatepath then
        privatepath = hs.fs.pathToAbsolute(hs.configdir .. '/private')
        -- Create `~/.hammerspoon/private` directory if not exists.
        hs.fs.mkdir(hs.configdir .. '/private')
    end
    privateconf = hs.fs.pathToAbsolute(hs.configdir .. '/private/config.lua')
    if privateconf then
        -- Load awesomeconfig file if exists
        require('private/config')
    end
end

hsreload_keys = hsreload_keys or {{"cmd", "shift", "ctrl"}, "R"}
if string.len(hsreload_keys[2]) > 0 then
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "Reload Configuration", function() hs.reload() end)
end

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("ModalMgr")

-- Define default Spoons which will be loaded later
if not hspoon_list then
    hspoon_list = {
        "AClock",
        "BingDaily",
        "CircleClock",
        "ClipShow",
        -- "Cherry",
        "CountDown",
        "HCalendar",
        "HSaria2",
        "HSearch",
        "SpeedMenu",
        "WinWin",
        "FnMate",
    }
end

-- Load those Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- Then we create/register all kinds of modal keybindings environments.
----------------------------------------------------------------------------------------------------
-- Register windowHints (Register a keybinding which is NOT modal environment with modal supervisor)
hswhints_keys = hswhints_keys or {"alt", "tab"}
if string.len(hswhints_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hswhints_keys[1], hswhints_keys[2], 'Show Window Hints', function()
        spoon.ModalMgr:deactivateAll()
        hs.hints.windowHints()
    end)
end

----------------------------------------------------------------------------------------------------
-- appM modal environment
spoon.ModalMgr:new("appM")
local cmodal = spoon.ModalMgr.modal_list["appM"]
cmodal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
cmodal:bind('', 'Q', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
if not hsapp_list then
    hsapp_list = {
        {key = 'f', name = 'Finder'},
        {key = 's', name = 'Safari'},
        {key = 't', name = 'Terminal'},
        {key = 'v', id = 'com.apple.ActivityMonitor'},
        {key = 'y', id = 'com.apple.systempreferences'},
    }
end
for _, v in ipairs(hsapp_list) do
    if v.id then
        local located_name = hs.application.nameForBundleID(v.id)
        if located_name then
            cmodal:bind('', v.key, located_name, function()
                hs.application.launchOrFocusByBundleID(v.id)
                spoon.ModalMgr:deactivate({"appM"})
            end)
        end
    elseif v.name then
        cmodal:bind('', v.key, v.name, function()
            hs.application.launchOrFocus(v.name)
            spoon.ModalMgr:deactivate({"appM"})
        end)
    end
end

-- Then we register some keybindings with modal supervisor
hsappM_keys = hsappM_keys or {"alt", "A"}
if string.len(hsappM_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsappM_keys[1], hsappM_keys[2], "Enter AppM Environment", function()
        spoon.ModalMgr:deactivateAll()
        -- Show the keybindings cheatsheet once appM is activated
        spoon.ModalMgr:activate({"appM"}, "#FFBD2E", true)
    end)
end

----------------------------------------------------------------------------------------------------
-- clipshowM modal environment
if spoon.ClipShow then
    spoon.ModalMgr:new("clipshowM")
    local cmodal = spoon.ModalMgr.modal_list["clipshowM"]
    cmodal:bind('', 'escape', 'Deactivate clipshowM', function()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'Q', 'Deactivate clipshowM', function()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'N', 'Save this Session', function()
        spoon.ClipShow:saveToSession()
    end)
    cmodal:bind('', 'R', 'Restore last Session', function()
        spoon.ClipShow:restoreLastSession()
    end)
    cmodal:bind('', 'B', 'Open in Browser', function()
        spoon.ClipShow:openInBrowserWithRef()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'S', 'Search with Bing', function()
        spoon.ClipShow:openInBrowserWithRef("https://www.bing.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'M', 'Open in MacVim', function()
        spoon.ClipShow:openWithCommand("/usr/local/bin/mvim")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'F', 'Save to Desktop', function()
        spoon.ClipShow:saveToFile()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'H', 'Search in Github', function()
        spoon.ClipShow:openInBrowserWithRef("https://github.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'G', 'Search with Google', function()
        spoon.ClipShow:openInBrowserWithRef("https://www.google.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'L', 'Open in Sublime Text', function()
        spoon.ClipShow:openWithCommand("/usr/local/bin/subl")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)

    -- Register clipshowM with modal supervisor
    hsclipsM_keys = hsclipsM_keys or {"alt", "C"}
    if string.len(hsclipsM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsclipsM_keys[1], hsclipsM_keys[2], "Enter clipshowM Environment", function()
            -- We need to take action upon hsclipsM_keys is pressed, since pressing another key to showing ClipShow panel is redundant.
            spoon.ClipShow:toggleShow()
            -- Need a little trick here. Since the content type of system clipboard may be "URL", in which case we don't need to activate clipshowM.
            if spoon.ClipShow.canvas:isShowing() then
                spoon.ModalMgr:deactivateAll()
                spoon.ModalMgr:activate({"clipshowM"})
            end
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- Register HSaria2
if spoon.HSaria2 then
    -- First we need to connect to aria2 rpc host
    hsaria2_host = hsaria2_host or "http://localhost:6800/jsonrpc"
    hsaria2_secret = hsaria2_secret or "token"
    spoon.HSaria2:connectToHost(hsaria2_host, hsaria2_secret)

    hsaria2_keys = hsaria2_keys or {"alt", "D"}
    if string.len(hsaria2_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsaria2_keys[1], hsaria2_keys[2], 'Toggle aria2 Panel', function() spoon.HSaria2:togglePanel() end)
    end
end

----------------------------------------------------------------------------------------------------
-- Register Hammerspoon Search
if spoon.HSearch then
    hsearch_keys = hsearch_keys or {"alt", "G"}
    if string.len(hsearch_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsearch_keys[1], hsearch_keys[2], 'Launch Hammerspoon Search', function() spoon.HSearch:toggleShow() end)
    end
end

----------------------------------------------------------------------------------------------------
-- Register Hammerspoon API manual: Open Hammerspoon manual in default browser
-- hsman_keys = hsman_keys or {"alt", "H"}
-- if string.len(hsman_keys[2]) > 0 then
--     spoon.ModalMgr.supervisor:bind(hsman_keys[1], hsman_keys[2], "Read Hammerspoon Manual", function()
--         hs.doc.hsdocs.forceExternalBrowser(true)
--         hs.doc.hsdocs.moduleEntitiesInSidebar(true)
--         hs.doc.hsdocs.help()
--     end)
-- end

----------------------------------------------------------------------------------------------------
-- countdownM modal environment
if spoon.CountDown then
    spoon.ModalMgr:new("countdownM")
    local cmodal = spoon.ModalMgr.modal_list["countdownM"]
    cmodal:bind('', 'escape', 'Deactivate countdownM', function() spoon.ModalMgr:deactivate({"countdownM"}) end)
    cmodal:bind('', 'Q', 'Deactivate countdownM', function() spoon.ModalMgr:deactivate({"countdownM"}) end)
    cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
    cmodal:bind('', '0', '5 Minutes Countdown', function()
        spoon.CountDown:startFor(5)
        spoon.ModalMgr:deactivate({"countdownM"})
    end)
    for i = 1, 9 do
        cmodal:bind('', tostring(i), string.format("%s Minutes Countdown", 10 * i), function()
            spoon.CountDown:startFor(10 * i)
            spoon.ModalMgr:deactivate({"countdownM"})
        end)
    end
    cmodal:bind('', 'return', '25 Minutes Countdown', function()
        spoon.CountDown:startFor(25)
        spoon.ModalMgr:deactivate({"countdownM"})
    end)
    cmodal:bind('', 'space', 'Pause/Resume CountDown', function()
        spoon.CountDown:pauseOrResume()
        spoon.ModalMgr:deactivate({"countdownM"})
    end)

    -- Register countdownM with modal supervisor
    hscountdM_keys = hscountdM_keys or {"alt", "I"}
    if string.len(hscountdM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hscountdM_keys[1], hscountdM_keys[2], "Enter countdownM Environment", function()
            spoon.ModalMgr:deactivateAll()
            -- Show the keybindings cheatsheet once countdownM is activated
            spoon.ModalMgr:activate({"countdownM"}, "#FF6347", true)
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- Register lock screen
hslock_keys = hslock_keys or {"alt", "L"}
if string.len(hslock_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], "Lock Screen", function()
        hs.caffeinate.lockScreen()
    end)
end

----------------------------------------------------------------------------------------------------
-- resizeM modal environment
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'escape', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'Q', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
    cmodal:bind('', 'A', 'Move Leftward', function() spoon.WinWin:stepMove("left") end, nil, function() spoon.WinWin:stepMove("left") end)
    cmodal:bind('', 'D', 'Move Rightward', function() spoon.WinWin:stepMove("right") end, nil, function() spoon.WinWin:stepMove("right") end)
    cmodal:bind('', 'W', 'Move Upward', function() spoon.WinWin:stepMove("up") end, nil, function() spoon.WinWin:stepMove("up") end)
    cmodal:bind('', 'S', 'Move Downward', function() spoon.WinWin:stepMove("down") end, nil, function() spoon.WinWin:stepMove("down") end)
    cmodal:bind('', 'H', 'Lefthalf of Screen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfleft") end)
    cmodal:bind('', 'L', 'Righthalf of Screen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfright") end)
    cmodal:bind('', 'K', 'Uphalf of Screen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfup") end)
    cmodal:bind('', 'J', 'Downhalf of Screen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfdown") end)
    cmodal:bind('', 'Y', 'NorthWest Corner', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerNW") end)
    cmodal:bind('', 'O', 'NorthEast Corner', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerNE") end)
    cmodal:bind('', 'U', 'SouthWest Corner', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerSW") end)
    cmodal:bind('', 'I', 'SouthEast Corner', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerSE") end)
    cmodal:bind('', 'F', 'Fullscreen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("fullscreen") end)
    cmodal:bind('', 'C', 'Center Window', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("center") end)
    cmodal:bind('', '=', 'Stretch Outward', function() spoon.WinWin:moveAndResize("expand") end, nil, function() spoon.WinWin:moveAndResize("expand") end)
    cmodal:bind('', '-', 'Shrink Inward', function() spoon.WinWin:moveAndResize("shrink") end, nil, function() spoon.WinWin:moveAndResize("shrink") end)
    cmodal:bind('shift', 'H', 'Move Leftward', function() spoon.WinWin:stepResize("left") end, nil, function() spoon.WinWin:stepResize("left") end)
    cmodal:bind('shift', 'L', 'Move Rightward', function() spoon.WinWin:stepResize("right") end, nil, function() spoon.WinWin:stepResize("right") end)
    cmodal:bind('shift', 'K', 'Move Upward', function() spoon.WinWin:stepResize("up") end, nil, function() spoon.WinWin:stepResize("up") end)
    cmodal:bind('shift', 'J', 'Move Downward', function() spoon.WinWin:stepResize("down") end, nil, function() spoon.WinWin:stepResize("down") end)
    cmodal:bind('', 'left', 'Move to Left Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("left") end)
    cmodal:bind('', 'right', 'Move to Right Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("right") end)
    cmodal:bind('', 'up', 'Move to Above Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("up") end)
    cmodal:bind('', 'down', 'Move to Below Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("down") end)
    cmodal:bind('', 'space', 'Move to Next Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("next") end)
    cmodal:bind('', '[', 'Undo Window Manipulation', function() spoon.WinWin:undo() end)
    cmodal:bind('', ']', 'Redo Window Manipulation', function() spoon.WinWin:redo() end)
    cmodal:bind('', '`', 'Center Cursor', function() spoon.WinWin:centerCursor() end)

    -- Register resizeM with modal supervisor
    hsresizeM_keys = hsresizeM_keys or {"alt", "R"}
    if string.len(hsresizeM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "Enter resizeM Environment", function()
            -- Deactivate some modal environments or not before activating a new one
            spoon.ModalMgr:deactivateAll()
            -- Show an status indicator so we know we're in some modal environment now
            spoon.ModalMgr:activate({"resizeM"}, "#B22222")
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- cheatsheetM modal environment (Because KSheet Spoon is NOT loaded, cheatsheetM will NOT be activated)
if spoon.KSheet then
    spoon.ModalMgr:new("cheatsheetM")
    local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
    cmodal:bind('', 'escape', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)
    cmodal:bind('', 'Q', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)

    -- Register cheatsheetM with modal supervisor
    hscheats_keys = hscheats_keys or {"alt", "S"}
    if string.len(hscheats_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hscheats_keys[1], hscheats_keys[2], "Enter cheatsheetM Environment", function()
            spoon.KSheet:show()
            spoon.ModalMgr:deactivateAll()
            spoon.ModalMgr:activate({"cheatsheetM"})
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- Register AClock
if spoon.AClock then
    hsaclock_keys = hsaclock_keys or {"alt", "T"}
    if string.len(hsaclock_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsaclock_keys[1], hsaclock_keys[2], "Toggle Floating Clock", function() spoon.AClock:toggleShow() end)
    end
end

----------------------------------------------------------------------------------------------------
-- Register browser tab typist: Type URL of current tab of running browser in markdown format. i.e. [title](link)
hstype_keys = hstype_keys or {"alt", "V"}
if string.len(hstype_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hstype_keys[1], hstype_keys[2], "Type Browser Link", function()
        local safari_running = hs.application.applicationsForBundleID("com.apple.Safari")
        local chrome_running = hs.application.applicationsForBundleID("com.google.Chrome")
        if #safari_running > 0 then
            local stat, data = hs.applescript('tell application "Safari" to get {URL, name} of current tab of window 1')
            if stat then hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")") end
        elseif #chrome_running > 0 then
            local stat, data = hs.applescript('tell application "Google Chrome" to get {URL, title} of active tab of window 1')
            if stat then hs.eventtap.keyStrokes("[" .. data[2] .. "](" .. data[1] .. ")") end
        end
    end)
end

----------------------------------------------------------------------------------------------------
-- Register Hammerspoon console
hsconsole_keys = hsconsole_keys or {"alt", "Z"}
if string.len(hsconsole_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], "Toggle Hammerspoon Console", function() hs.toggleConsole() end)
end

----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()

local spaces = require("hs.spaces") -- https://github.com/asmagill/hs._asm.spaces

-- -- Switch kitty
-- hs.hotkey.bind({'command'}, 'space', function ()  -- hotkey config
--   local BUNDLE_ID = 'net.kovidgoyal.kitty' -- more accurate to avoid mismatching on browser titles
--
--   function getMainWindow(app)
--     -- get main window from app
--     local win = nil
--     while win == nil do
--       win = app:mainWindow()
--     end
--     return win
--   end
--
--   function moveWindow(kitty, space, mainScreen)
--     -- move to main space
--     local win = getMainWindow(kitty)
--     if win:isFullScreen() then
--       hs.eventtap.keyStroke('fn', 'f', 0, kitty)
--     end
--     winFrame = win:frame()
--     scrFrame = mainScreen:fullFrame()
--     winFrame.w = scrFrame.w/6*5
--     winFrame.y = scrFrame.y
--     winFrame.x = scrFrame.x + scrFrame.w/6
--     win:setFrame(winFrame, 0)
--     spaces.moveWindowToSpace(win, space)
--     if win:isFullScreen() then
--       hs.eventtap.keyStroke('fn', 'f', 0, kitty)
--     end
--     win:focus()
--   end
--
--   local kitty = hs.application.get(BUNDLE_ID)
--   if kitty ~= nil and kitty:isFrontmost() then
--     kitty:hide()
--   else
--     local space = spaces.activeSpaceOnScreen()
--     local mainScreen = hs.screen.mainScreen()
--     if kitty == nil and hs.application.launchOrFocusByBundleID(BUNDLE_ID) then
--       local appWatcher = nil
--       appWatcher = hs.application.watcher.new(function(name, event, app)
--         if event == hs.application.watcher.launched and app:bundleID() == BUNDLE_ID then
--           getMainWindow(app):move(hs.geometry({x=0,y=0,w=1,h=1}))
--           app:hide()
--           moveWindow(app, space, mainScreen)
--           appWatcher:stop()
--         end
--       end)
--       appWatcher:start()
--     end
--     if kitty ~= nil then
--       moveWindow(kitty, space, mainScreen)
--     end
--   end
--
--   -- 展开交易铁律sticky
--   local stickies = hs.application.get("com.apple.Stickies")
--     
--   -- 1. 如果便笺还没启动，先启动它
--   if not stickies then
--       hs.application.launchOrFocusByBundleID("com.apple.Stickies")
--       return
--   end
--
--   -- 2. 将其拉到前台 (确保菜单命令作用于正确的窗口)
--   if not stickies:isFrontmost() then
--       stickies:activate()
--   end
--
--   -- 3. 直接调用原生菜单命令，抛弃模拟按键
--   -- 定义不同语言和状态下的菜单路径 (中/英)
--   local menu_paths = {
--       {"窗口", "折叠"},
--       {"窗口", "展开"},
--       {"Window", "Collapse"},
--       {"Window", "Expand"}
--   }
--   
--   -- 遍历菜单，找到当前可用的那个并直接触发
--   for _, path in ipairs(menu_paths) do
--       if stickies:findMenuItem(path) then
--           stickies:selectMenuItem(path)
--           break
--       end
--   end
-- end)

-- ==========================================
-- 配置区 (Configuration)
-- ==========================================
local ENABLE_STICKIES = false -- 【总开关】: 改为 false 即可彻底关闭便笺联动功能，只保留 Kitty

local KITTY_BUNDLE_ID = 'net.kovidgoyal.kitty' 
local STICKIES_BUNDLE_ID = "com.apple.Stickies"

-- ==========================================
-- 通用工具模块 (Utilities)
-- ==========================================
local function getMainWindow(app)
  local win = app:mainWindow()
  if not win then
    local windows = app:allWindows()
    if #windows > 0 then win = windows[1] end
  end
  return win
end

local function yieldFocus()
  local windows = hs.window.orderedWindows()
  for _, win in ipairs(windows) do
    local app = win:application()
    if app then
      local bid = app:bundleID()
      -- 如果关闭了便笺功能，就不需要判断便笺的 Bundle ID
      local isStickies = ENABLE_STICKIES and (bid == STICKIES_BUNDLE_ID) or false
      if bid ~= KITTY_BUNDLE_ID and not isStickies and win:isStandard() then
        app:activate()
        return
      end
    end
  end
  local finder = hs.application.get("com.apple.finder")
  if finder then finder:activate() end
end

-- ==========================================
-- Kitty 控制模块 (Kitty Controller)
-- ==========================================
local function moveAndFocusKitty(kittyApp)
  local space = spaces and spaces.activeSpaceOnScreen() or nil
  local mainScreen = hs.screen.mainScreen()
  
  local win = getMainWindow(kittyApp)
  if not win then return end

  if win:isFullScreen() then
    hs.eventtap.keyStroke('fn', 'f', 0, kittyApp)
  end
  
  local winFrame = win:frame()
  local scrFrame = mainScreen:fullFrame()
  winFrame.w = scrFrame.w / 6 * 5
  winFrame.y = scrFrame.y
  winFrame.x = scrFrame.x + scrFrame.w / 6
  win:setFrame(winFrame, 0)
  
  if spaces and spaces.moveWindowToSpace then
      spaces.moveWindowToSpace(win, space)
  end
  
  if win:isFullScreen() then
    hs.eventtap.keyStroke('fn', 'f', 0, kittyApp)
  end
  win:focus()
end

local function launchOrShowKitty()
  local kittyApp = hs.application.get(KITTY_BUNDLE_ID)
  if kittyApp == nil then
    if hs.application.launchOrFocusByBundleID(KITTY_BUNDLE_ID) then
      local appWatcher = nil
      appWatcher = hs.application.watcher.new(function(name, event, app)
        if event == hs.application.watcher.launched and app:bundleID() == KITTY_BUNDLE_ID then
          local win = getMainWindow(app)
          if win then win:move(hs.geometry({x=0, y=0, w=1, h=1})) end
          app:hide()
          moveAndFocusKitty(app)
          appWatcher:stop()
        end
      end)
      appWatcher:start()
    end
  else
    moveAndFocusKitty(kittyApp)
  end
end

-- ==========================================
-- 便笺 控制模块 (Stickies Controller)
-- ==========================================
local function isStickiesCollapsed(app)
  if not app then return false end
  local win = getMainWindow(app)
  if win then return win:frame().h < 50 end
  return false
end

-- ==========================================
-- 主逻辑：快捷键绑定 (Main Hotkey Bind)
-- ==========================================
hs.hotkey.bind({'command'}, 'space', function () 
  local kitty = hs.application.get(KITTY_BUNDLE_ID)
  local stickies = ENABLE_STICKIES and hs.application.get(STICKIES_BUNDLE_ID) or nil

  local isKittyFront = (kitty ~= nil and kitty:isFrontmost())
  local isStickiesFront = (stickies ~= nil and stickies:isFrontmost())
  
  -- 统一动作判定
  local action = (isKittyFront or isStickiesFront) and "HIDE" or "SHOW"

  if action == "HIDE" then
    -- 1. 隐藏 Kitty
    if kitty then kitty:hide() end
    
    -- 2. 处理便笺与焦点交接
    if ENABLE_STICKIES and stickies and not isStickiesCollapsed(stickies) then
        stickies:activate()
        hs.timer.doAfter(0.1, function()
            if not stickies:selectMenuItem({"窗口", "折叠"}) and not stickies:selectMenuItem({"Window", "Collapse"}) then
                hs.eventtap.keyStroke({"cmd"}, "m")
            end
            hs.timer.doAfter(0.1, yieldFocus)
        end)
    else
        yieldFocus()
    end

  else -- action == "SHOW"
    if ENABLE_STICKIES then
        -- 开启便笺联动模式：先处理便笺，再唤醒 Kitty
        if not stickies then
            hs.application.launchOrFocusByBundleID(STICKIES_BUNDLE_ID)
            hs.timer.doAfter(0.3, launchOrShowKitty)
        elseif isStickiesCollapsed(stickies) then
            stickies:activate()
            hs.timer.doAfter(0.1, function()
                if not stickies:selectMenuItem({"窗口", "展开"}) and not stickies:selectMenuItem({"Window", "Expand"}) then
                    hs.eventtap.keyStroke({"cmd"}, "m")
                end
                hs.timer.doAfter(0.1, launchOrShowKitty)
            end)
        else
            launchOrShowKitty()
        end
    else
        -- 纯 Kitty 模式：直接唤醒
        launchOrShowKitty()
    end
  end
end)






local VimMode = hs.loadSpoon('VimMode')
local vim = VimMode:new()

vim
  :disableForApp('Code')
  :disableForApp('nvim')
  :disableForApp('MacVim')
  :disableForApp('zoom.us')
  :disableForApp('kitty')
  :enterWithSequence(';;')


