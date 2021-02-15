if not chatsounds then return end

function chatsounds:Mount( inc )
    for snd, tab in pairs( inc ) do

        if not chatsounds.Sounds[ snd ] then
            chatsounds.Sounds[ snd ] = tab
            continue
        end

        table.Add( chatsounds.Sounds[ snd ], tab )

    end
end

for _, file2 in pairs( file.Find("chatsounds/packages/*.lua","LUA") ) do

    local path = "chatsounds/packages/" .. file2
    include( path )

    if SERVER then
        AddCSLuaFile( path )
    end

    print( "[chatsounds] added " .. file2 .. " package" )

end
