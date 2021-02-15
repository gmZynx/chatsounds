local tag = "zbox.ChatsoundSearch"
local cv  = CreateClientConVar( "zbox_chatsounds_autocomplete", "1", true, false, "Enable/disable autocomplete for chatsounds." )

local function tridig( num )
    num = tonumber(num)
    if not num then return "000" end
    return string.rep( "0", 3 - tostring(num):len(), "" ) .. num
end

if SERVER then return end

local cache = {}

hook.Add( "HUDPaint", tag, function()
    if table.IsEmpty( cache ) then return end

    local id = 0
    for k,v in pairs( cache ) do

        id = id + 1
        local alpha = id ~= 1 and math.floor( 255 / id ) or 255
        if 15 > alpha then continue end

        draw.SimpleTextOutlined( tridig(id) .. " - " .. k, id == 1 and "DermaDefaultBold" or "DermaDefault", 48, 32 - 14 + id * 14, Color(255,255,255,alpha), 0, 3, 1, Color(0,0,0,alph) )

    end
end )

hook.Add( "ChatTextChanged", tag, function( text )
    table.Empty( cache )

    text = text:lower():Trim()
    if 0 >= text:len() then return end

    for snd,_ in pairs( chatsounds.Sounds ) do
        if not snd:find( text, 1, true ) then continue end
        cache[ snd ] = true
    end
end )

hook.Add( "FinishChat", tag, function() table.Empty( cache ) end )

local function OnChatTab( text )
    if table.IsEmpty( cache ) then return end

    for snd,_ in pairs( cache ) do
        if snd == text then cache[ snd ] = nil continue end
        return snd
    end
end

if cv:GetBool() then
    hook.Add( "OnChatTab", tag, OnChatTab )
end

cvars.AddChangeCallback( "zbox_chatsounds_autocomplete", function(_,_,new)
    local hook_Toggle = tonumber(new) ~= 0 and hook.Add or hook.Remove
    hook_Toggle( "OnChatTab", tag, OnChatTab )
end )
