local function dump(o, indent)
    if indent == nil then
        indent = 0
    end
   if type(o) == 'table' then
      local s = string.rep('\t', indent)..'{\n'
      indent = indent + 1
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. string.rep('\t', indent) .. k..' = ' .. dump(v, indent + 1) .. ',\n'
      end
      return s .. string.rep('\t', indent - 1) .. '} '
   else
      return tostring(o)
   end
end

local function getActiveChromeTabData(log)
    ok, ret, raw = hs.osascript.applescript([[
tell application "Google Chrome"
    if 0 < (count of windows) then
        tell front window
            {title, URL} of active tab
        end tell
    else
        "No windows open in Chrome"
    end if
end tell
]])
    log("getTitleAndURLWithAS", {ok = ok, ret = ret, raw = raw})
    if ok then
        return ret[1], ret[2]
    else
        error(raw)
    end
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function cleanTitle(log, title, url)
    local ghStart, ghEnd = string.find(title, " by .* Pull Request")
    if ghStart ~= nil then
        newTitle = string.sub(title,0, ghStart - 1)
        log("cleanTitle", {type="github", title = title, newTitle = newTitle})
        return newTitle
    end

    local newTitle, n = title:gsub(" %- Google Docs", "")
    if n > 0 then
        log("cleanTitle", {type="gdocs", title = title, newTitle = newTitle})
        return newTitle
    end

    newTitle, n = title:gsub(" %- Google Drive", "")
    if n > 0 then
        log("cleanTitle", {type="gdrive", title = title, newTitle = newTitle})
        return newTitle
    end

    newTitle, n = title:gsub(" %- Jira", "")
    if n > 0 then
        log("cleanTitle", {type="jira", title = title, newTitle = newTitle})
        return newTitle
    end

    if starts_with(url, "https://git.corp.stripe.com") and url:find("/blob/") then
        -- Turn a title like "gopiori/aws_access.go0a49f269a9a8834a8620d5fb5f78ec483872d1e · apiori/gopiori" into "gopiori/aws_access.go · apiori/gopiori"
        newTitle, n = title:gsub(" at %g+", "")
        log("cleanTitle", {type="github_file", title = title, newTitle = newTitle})
        return newTitle
    end

    newTitle, n = title:gsub(" %- Confluence", "")
    if n > 0 then
        log("cleanTitle", {type="confluence", title = title, newTitle = newTitle})
        return newTitle
    end

    return title
end

local HTML_ENTITIES = {
    -- ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;",
    -- ["%["] = "&lbrack;",
    -- ["%]"] = "&rbrack;"
}

local doneSound = hs.sound.getByName("Frog")

local function escape(str)
    str = str:gsub("&", "&amp;")
    for k, v in pairs(HTML_ENTITIES) do
        str = str:gsub(k, v)
    end
    return str
end

local function htmlLinkForTitleAndURL(title, url)
    return string.format('<meta charset=\'utf-8\'><meta charset="utf-8"><a href="%s">%s</a>', url, title)
end

local function copyTitleAsLink(log)
    local title, url = getActiveChromeTabData(log)
    title = cleanTitle(log, title, url)
    title = escape(title)
    local html = htmlLinkForTitleAndURL(title, url)
    local data = {
        ["Apple HTML pasteboard type"] = html,
        ["public.html"] = html,
        ["public.utf8-plain-text"] = title,
    }
    local retVal = hs.pasteboard.writeAllData(nil, data)
    if retval == false then
        hs.alert.show("Failed to set clipboard")
    end

    doneSound:play()
end

local function insertTitleAsLink(log)
    local oldData = hs.pasteboard.readAllData()
    copyTitleAsLink(log)
    hs.eventtap.keyStroke({"cmd"}, "v")

    hs.timer.doAfter(0.2, function()
        hs.pasteboard.writeAllData(nil, oldData)
        doneSound:play()
    end)
end

local function jbind()
    local fns = {
        copy_title_as_link = {
            fn = copyTitleAsLink,
            text = "Copy Title as Link"
        },
        insert_title_as_link = {
            fn = insertTitleAsLink,
            text = "Insert Title as Link"
        },
        reload_hammerspoon = {
            text = "Reload hammerspoon",
            fn = function(log)
                hs.reload()
            end
        },
        debug_clipboard = {
            text = "Debug clipboard",
            fn = function(log)
                log("readAllData", hs.pasteboard.readAllData())
                hs.openConsole()
            end
        },
        chrome_count = {
            text = "Chrome: Count Tabs",
            fn = function(log)
                local script = [[
                    tell application "Google Chrome"
                        set windowCount to count windows
                        set tabCount to 0
                        repeat with w in windows
                            set tabCount to tabCount + (count tabs of w)
                        end repeat
                        return {windowCount, tabCount}
                    end tell
                ]]
                local ok, result = hs.osascript.applescript(script)
                if ok then
                    local windowCount = result[1]
                    local tabCount = result[2]
                    hs.alert.show(string.format("Chrome has %d window(s) and %d tab(s) open", windowCount, tabCount))
                else
                    hs.alert.show("Error counting Chrome tabs: " .. result)
                end
            end
        }
    }

    local onChoose = function(choice)
        if not choice then
            return
        end

        local logger = hs.logger.new(choice.name, "info")
        local log = function(msg, data)
            logger.i(msg.." "..dump(data))
        end
        fns[choice.name].fn(log)
    end

    local chooser = hs.chooser.new(onChoose)
    chooser:width(40)
    chooser:placeholderText("Command:")

    choices = {}
    for k, v in pairs(fns) do
        table.insert(choices, {text = v.text, name = k})
    end
    chooser:choices(choices)

    chooser:show()
end

hs.hotkey.bind({"cmd", "ctrl", "alt"}, "N", function() jbind() end)