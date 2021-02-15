if SERVER then
    AddCSLuaFile( "chatsounds/chatsounds.lua" )
    AddCSLuaFile( "chatsounds/packages.lua" )
    AddCSLuaFile( "chatsounds/hud.lua" )
end

include( "chatsounds/chatsounds.lua" )
include( "chatsounds/packages.lua" )

include( "chatsounds/hud.lua" )
