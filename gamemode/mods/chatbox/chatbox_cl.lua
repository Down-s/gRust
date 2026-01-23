function gRust.SendChat(msg, teamchat)
    --if hook.Run("PlayerSay", LocalPlayer(), msg, teamchat, false) then return end
    net.Start("gRust.SendChat2")
    net.WriteString(msg)
    net.WriteBool(teamchat)
    net.SendToServer()
end

local function ChatInit()
    if rustChatBox and rustChatBox.frame then rustChatBox.frame:Remove() end
    rustChatBox = {}
    rustChatBox.cachedAvatars = rustChatBox.cachedAvatars or {}
    local sH, sW = ScrH(), ScrW()
    surface.CreateFont("RustChatboxFont", {
        font = "Roboto Condensed",
        size = sH / 40,
        extended = true,
        weight = 750,
    })

    -- Caching and fetching player avatar from steam cdn
    local function AvatarURL(id)
        if not id then -- grust icon (like rust but blue) if not player
            return "https://i.imgur.com/SJ4nCvj.png"
        end

        if rustChatBox.cachedAvatars[id] then -- if already cached
            return rustChatBox.cachedAvatars[id]
        end

        http.Fetch("http://steamcommunity.com/profiles/" .. id .. "/?xml=1", function(body)
            --fetching player profile xml to find avatar
            if not body then -- something went wrong (grust icon
                return "https://i.imgur.com/SJ4nCvj.png"
            end

            local link = string.match(body, "<avatarIcon>.-(https?://%S+%f[%.]%.).-</avatarIcon>")
            if not link then -- something went wrong (grust icon)
                return "https://i.imgur.com/SJ4nCvj.png"
            end

            link = link .. "jpg"
            rustChatBox.cachedAvatars[id] = link
        end)
        return "https://i.imgur.com/tJVFggF.png" -- fetching icon
    end

    local chatW, chatH, chatX, chatY, chatbarH = sW / 3.36842, sH * 0.83333 - 100, sW / 80, 100, sH / 24
    local teambuttonY, teambuttonW = chatH - chatbarH, chatW / 5.85
    local greenColor, teamColor, teamTagColor, globalchatColor, oldTeamTagColor, cmenuBGColor, cmenuTextColor, whiteColor = Color(100, 127, 62), Color(170, 253, 81), Color(165, 238, 56), Color(85, 170, 255), Color(30, 160, 40), Color(49, 49, 49, 250), Color(227, 248, 187), Color(255, 255, 255)
    local teamchat = false
    local HTMLstring = [[    <html>

    <head>

        <style>

            @import url('https://fonts.googleapis.com/css2?family=Roboto+Condensed:wght@700&display=swap');



            * {

                font-family: 'Roboto Condensed', sans-serif;

                font-size: ]] .. sH / 45 .. [[;

                text-shadow: 0 0 1.2px black, 0 0 1.2px black, 0 0 1.2px black, 0 0 1.2px black; 

                overflow: auto;

            }



            body {

                margin-left: ]] .. sW / 400 .. [[px;

            }



            div.messages img {

                height: ]] .. sH / 30 .. [[px;

                margin-right: ]] .. sW / 128 .. [[px;

                position: absolute

            }



            div.messages p span {

                margin-top: 100%;

            }



            p {

                margin: 0px;

                overflow: hidden;

                padding-left: ]] .. sH / 30 + 4 .. [[px;

                padding-top: ]] .. sH / 360 .. [[px;

            }



            ::-webkit-scrollbar {

                display: none;

            }



            div.messages > div.textbox {

                margin-top: ]] .. sH / 102.85 .. [[px;

                margin-bottom: ]] .. sH / 102.85 .. [[px;

                opacity: 0;

                transition: 0.13s;

            }



            body.show div.messages > div.textbox {

                opacity: 1;

                transition: 0.13s;

            }

            

            .player {

                cursor: pointer;

            }

            

            .link {

                cursor: pointer;

            }

        </style>

    </head>

    <body>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        

        <div class="chatbox">

            <div class="messages">

                <div style="height: 100%;"></div>

            </div>

        </div>



        <script>

            function showChat() {

                document.body.classList.add("show");

                document.querySelector("div.messages").lastElementChild.scrollIntoView(false);

            }

            

            function hideChat() {

                document.body.classList.remove("show");

                window.getSelection().removeAllRanges();

                document.querySelector("div.messages").lastElementChild.scrollIntoView(false);

            }

            

            function clearChat() {

                var messagesDiv = document.querySelector('div.messages');

                messagesDiv.innerHTML = '';

                var div = document.createElement('div');

                div.style.height = '100%';

                messagesDiv.appendChild(div);

                window.getSelection().removeAllRanges();

            }

            

            function addText(json) {

                var args = JSON.parse(json);

            

                var prefixPrint = "";

                var stringPrint = document.createElement("p");

            

                var wholeMessage = document.createElement("div");

                wholeMessage.classList.add("textbox");

            

                var color = null;

            

                for (var i = 0; i < args.length; i++) {

                    var obj = args[i];

            

                    if (typeof obj == "string") {

                        if (color == null) {

                            // Parse HTML string and append

                            var tempDiv = document.createElement("div");

                            tempDiv.innerHTML = obj;

                            stringPrint.appendChild(tempDiv);

                        } else {

                            // Parse HTML string and append to color span

                            var tempDiv = document.createElement("div");

                            tempDiv.innerHTML = obj;

                            color.appendChild(tempDiv.firstChild);

                        }

                    } else {

                        if (color != null) {

                            stringPrint.appendChild(color);

                        }

            

                        if (obj.player) {

                            prefixPrint = "<img class='player' id='" + obj.steamid + "' src='" + obj.avatar + "'/>";

                            color = document.createElement("span");

                            color.style.color = "rgba(" + obj.color.r + "," + obj.color.g + "," + obj.color.b + ",255)";

                            var playerName = document.createElement("span");

                            playerName.classList.add("player");

                            playerName.id = obj.steamid;

                            playerName.innerHTML = obj.name;

                            color.appendChild(playerName);

                            stringPrint.appendChild(color);

                            color = null;

                        } else {

                            if (prefixPrint == "") {

                                prefixPrint = "<img src=https://i.imgur.com/SJ4nCvj.png/>";

                            }

                            color = document.createElement("span");

                            color.style.color = "rgba(" + obj.r + "," + obj.g + "," + obj.b + ", 255)";

                        }

                    }

                }

                if (color != null) {

                    stringPrint.appendChild(color);

                }

            

                wholeMessage.style.opacity = "1";

            

                wholeMessage.innerHTML += prefixPrint;

                wholeMessage.appendChild(stringPrint);

            

                document.querySelector("div.messages").appendChild(wholeMessage);

                document.querySelector("div.messages").lastElementChild.scrollIntoView(false);

            

                if (navigator.userAgent.search("Awesomium") != -1) {

                    setTimeout(function() {

                        if (!document.body.classList.contains("show")) {

                            wholeMessage.style.opacity = "";

                        }

                    }, 4800);

                }

            

                setTimeout(function() {

                    wholeMessage.style.opacity = "";

                }, 5000);

            }

            

            

            document.addEventListener("click", function(e) {

                if (e.target.classList.contains("player")) {

                    gmod.contextMenu(e.target.id);

                } else if ($(e.target).hasClass("link")) {

                    gmod.openURL($(e.target).attr('link'));

                }

            }, false);



        </script>

    </body>

</html>

]]
    rustChatBox.frame = vgui.Create("DFrame")
    rustChatBox.frame:SetPos(0, chatY)
    rustChatBox.frame:SetSize(chatW, chatH)
    rustChatBox.frame:SetTitle("")
    rustChatBox.frame:SetVisible(true)
    rustChatBox.frame:SetDraggable(false)
    rustChatBox.frame:ShowCloseButton(false)
    rustChatBox.frame:ParentToHUD()
    rustChatBox.frame.Paint = function() end
    rustChatBox.html = rustChatBox.frame:Add("DHTML")
    rustChatBox.html:SetPos(chatX, chatY)
    rustChatBox.html:SetSize(chatW - chatX, chatH - chatbarH)
    rustChatBox.html:SetHTML(HTMLstring)
    rustChatBox.html:AddFunction("gmod", "contextMenu", function(sid)
        local Menu = DermaMenu()
        Menu.Paint = function(self, w, h)
            surface.SetDrawColor(cmenuBGColor)
            surface.DrawRect(0, 0, w, h)
        end

        Menu:AddOption("Steam Profile", function() gui.OpenURL("http://steamcommunity.com/profiles/" .. sid) end)
        Menu:AddOption("Copy SteamID64", function() SetClipboardText(sid) end)
        Menu:AddOption("Clear Chat", function() rustChatBox.html:RunJavascript("clearChat()") end)
        for i = 1, 3 do
            local option = Menu:GetChild(i)
            option:SetTextInset(8, 0)
            option:SetFont("RustChatboxFont")
            option:SetTextColor(cmenuTextColor)
            option.PerformLayout = function(w, h)
                option:SetSize(sW / 10, sH / 30)
                DButton.PerformLayout(option, w, h)
            end
        end

        Menu:Open()
    end)

    rustChatBox.html:AddFunction("gmod", "openURL", function(link) gui.OpenURL(link) end)
    function rustChatBox.html:OnDocumentReady()
        self:SetAllowLua(true)
    end

    local chatbar = rustChatBox.frame:Add("DFrame") -- invisible panel to parent textentry and button to make animation
    chatbar:SetPos(-300, teambuttonY + 100)
    chatbar:SetSize(chatW - chatX, chatbarH)
    chatbar:SetDraggable(false)
    chatbar:SetTitle("")
    chatbar:ShowCloseButton(false)
    chatbar:SetAlpha(0)
    chatbar.Paint = function(self, w, h)
        surface.SetDrawColor(greenColor)
        surface.DrawRect(0, 0, w, h)
    end

    local teambutton = chatbar:Add("DButton")
    teambutton:SetText("")
    teambutton:SetPos(0, 0)
    teambutton:SetSize(teambuttonW, chatbarH)
    teambutton.Paint = function(self, w, h) draw.SimpleText(teamchat and "[Team]" or "[Global]", "RustChatboxFont", w / 2, h / 2, teamchat and teamColor or whiteColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
    local textentry = chatbar:Add("DTextEntry")
    textentry:SetPos(teambuttonW, 0)
    textentry:SetSize(chatW - chatX - teambuttonW, chatbarH)
    textentry:SetDrawBackground(false)
    textentry:SetDrawBorder(false)
    textentry:SetTextColor(whiteColor)
    textentry:SetCursorColor(whiteColor)
    textentry:SetFont("RustChatboxFont")
    textentry:SetCursor("hand")
    textentry:SetTabbingDisabled(true)
    textentry:SetDrawLanguageID(false)
    textentry.AllowInput = function(self, stringValue)
        if #self:GetValue() > 125 then return true end
        return
    end

    teambutton.DoClick = function()
        if LocalPlayer().TeamID then teamchat = not teamchat end
        textentry:RequestFocus()
    end

    local function ShowChatbox()
        chatbar:MoveTo(chatX, teambuttonY + 100, 0.05)
        chatbar:AlphaTo(255, 0.05)
        rustChatBox.html:MakePopup()
        chatbar:MakePopup()
        rustChatBox.html:SetMouseInputEnabled(true)
        rustChatBox.html:SetKeyBoardInputEnabled(true)
        textentry:SetMouseInputEnabled(true)
        rustChatBox.html:RequestFocus()
        textentry:RequestFocus()
    end

    local function HideChatbox()
        chatbar:MoveTo(-300, teambuttonY + 100, 0.05)
        chatbar:AlphaTo(0, 0.05)
        rustChatBox.html:RunJavascript("hideChat()")
        textentry:SetText("")
        textentry:SetMouseInputEnabled(false)
        chatbar:SetMouseInputEnabled(false)
        chatbar:SetKeyBoardInputEnabled(false)
        rustChatBox.html:SetMouseInputEnabled(false)
        rustChatBox.html:SetKeyBoardInputEnabled(false)
    end

    hook.Add("PlayerBindPress", "RustChatboxBind", function(ply, bind, pressed)
        if bind == "messagemode" then
            teamchat = false
        elseif bind == "messagemode2" then
            if LocalPlayer().TeamID then teamchat = true end
        else
            return
        end

        ShowChatbox()
        function textentry:OnKeyCodeTyped(key)
            if key == KEY_TAB and LocalPlayer().TeamID then
                teamchat = not teamchat
            elseif key == KEY_BACKQUOTE then
                gui.HideGameUI()
            elseif key == KEY_ENTER then
                if not string.IsNullOrEmpty(textentry:GetValue()) then gRust.SendChat(textentry:GetValue(), teamchat) end
                HideChatbox()
            end
        end

        rustChatBox.html:RunJavascript("showChat()")
        return true
    end)

    hook.Add("OnPauseMenuShow", "RustChatboxHide", function()
        if textentry:IsEditing() then
            HideChatbox()
            return false
        end
    end)

    hook.Add("HUDShouldDraw", "RustChatboxHide", function(name) if name == "CHudChat" then return false end end)
    if not oldAddText then oldAddText = chat.AddText end
    function chat.AddText(...)
        local args = {...}
        local message = {}
        table.insert(args, 1, whiteColor) -- black text fix
        for _, obj in ipairs(args) do
            if type(obj) == "table" or type(obj) == "string" then
                if obj == oldTeamTagColor then
                    table.insert(message, teamTagColor)
                else
                    table.insert(message, type(obj) == "string" and string.Replace(obj, "(TEAM) ", "[Team] ") or obj)
                end
            elseif type(obj) == "Player" then
                table.insert(message, {
                    ["player"] = true,
                    ["color"] = teamchat and teamColor or globalchatColor,
                    ["name"] = obj:Name(),
                    ["avatar"] = AvatarURL(obj:SteamID64()),
                    ["steamid"] = obj:SteamID64(),
                })
            else
                table.insert(message, tostring(obj))
            end
        end

        if rustChatBox then
            rustChatBox.html:RunJavascript([[addText("]] .. util.TableToJSON(message):JavascriptSafe() .. [[")]])
            -- print([[addText("]]..util.TableToJSON(message):JavascriptSafe()..[[")]])
        end

        oldAddText(...)
    end

    function chat.AddTextOverride(...)
        local args = {...}
        local message = {}
        table.insert(args, 1, whiteColor) -- black text fix
        for _, obj in ipairs(args) do
            if type(obj) == "table" or type(obj) == "string" then
                if obj == oldTeamTagColor then
                    table.insert(message, teamTagColor)
                else
                    table.insert(message, type(obj) == "string" and string.Replace(obj, "(TEAM) ", "[Team] ") or obj)
                end
            elseif type(obj) == "Player" then
                table.insert(message, {
                    ["player"] = true,
                    ["color"] = teamchat and teamColor or globalchatColor,
                    ["name"] = obj:Name(),
                    ["avatar"] = AvatarURL(obj:SteamID64()),
                    ["steamid"] = obj:SteamID64(),
                })
            else
                table.insert(message, tostring(obj))
            end
        end

        if rustChatBox then
            rustChatBox.html:RunJavascript([[addText("]] .. util.TableToJSON(message):JavascriptSafe() .. [[")]])
            -- print([[addText("]]..util.TableToJSON(message):JavascriptSafe()..[[")]])
        end

        oldAddText(...)
    end

    ShowChatbox() --makepopup() parent glitch fix
    HideChatbox()
    for _, v in player.Iterator() do
        AvatarURL(v:SteamID64())
    end
end

hook.Add("InitPostEntity", "RustChatboxInit", ChatInit)
hook.Add("OnScreenSizeChanged", "RustChatboxResChange", ChatInit)
if rustChatBox then ChatInit() end
local TEAM_CHAT_COLOR = Color(30, 160, 40)
net.Receive("gRust.SendChat", function(len)
    local pl = net.ReadPlayer and net.ReadPlayer() or "[CONSOLE]"
    local message = net.ReadString()
    local teamchat = net.ReadBool()
    print(message)
    local rank, color
    if net.ReadBool() then
        rank = net.ReadString()
        color = net.ReadColor()
    end

    if teamchat then
        chat.AddText(TEAM_CHAT_COLOR, "[TEAM] ", pl, color_white, ": ", message)
    else
        if rank then
            chat.AddText(color, "[" .. rank .. "] ", pl, color_white, ": ", message)
        else
            print(pl)
            chat.AddText(pl ~= nil and pl or "[Console]", color_white, ": ", message)
        end
    end
end)

net.Receive("gRust.SendChatConsole", function(len)
    local message = net.ReadString()
    chat.AddText("[Console]", color_white, ": ", message)
end)

concommand.Add("grust_removechat", function()
    if rustChatBox then
        rustChatBox.frame:Remove()
        rustChatBox = nil
    end
end)