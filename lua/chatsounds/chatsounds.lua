local tag = "zbox.Chatsounds"

chatsounds = {}
chatsounds.Sounds = {}

if SERVER then

    util.AddNetworkString( tag )
    
    local PLAYER = FindMetaTable( "Player" )
    function PLAYER:PlayChatsound( snd )
        if not chatsounds.Sounds[ snd ] then return false end

        net.Start( tag )
            net.WriteString( snd )
            net.WriteEntity( self )
        net.Broadcast()

        return true
    end

    concommand.Add( "zbox_playchatsound", function(ply,_,_,full) ply:PlayChatsound( full ) end )

else

    local CONVAR = CreateClientConVar( "zbox_chatsounds", "1", true, false, "Enable/disable chatsounds" )

    local PLAYER = FindMetaTable( "Player" )
    function PLAYER:PlayChatsound( snd )
        if not CONVAR:GetBool() then return end

        snd = chatsounds.Sounds[ snd ]
        if not snd then return false end

        self:EmitSound( table.Random( snd ), 75, 100, 0.7, CHAN_VOICE )
        return true
    end
    
    net.Receive( tag, function()
        local snd = net.ReadString()
        local ply = net.ReadEntity()

        ply:PlayChatsound( snd )
    end )

    hook.Add( "OnPlayerChat", tag, function( ply, text )
        if not IsValid( ply ) then return end
        ply:PlayChatsound( string.lower( text ) )
    end )

end
