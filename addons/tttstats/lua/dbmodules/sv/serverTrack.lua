util.AddNetworkString( "TESTY" )

function getPlyCount()

	local i = 0;
	for k,v in pairs(player.GetAll()) do
		i = i + 1;
	end
	return i;

end

function loadServerStats( )


	if not ServerStatsDB.connected then
		timer.Simple( 10, loadServerStats )
		return
	end
	
	lHost = db:escape(GetConVar("hostname"):GetString());
	ipPort = string.format("%s:%s", ServerStatsDB.ServerIP, ServerStatsDB.ServerPort);
	curServ = tostring(ipPort);
	currentMap = game.GetMap();
	
    loadQuery = db:query("SELECT * FROM server_track WHERE hostip = '" .. ipPort .. "'")
	    
	loadQuery.onError = function(q,e)
		notifymessage("[Awesome Tracker]Something went wrong")
		notifyerror(e)
	end
	
	loadQuery.onSuccess = function(q)
        if not checkQuery(q) then

			local Statquery2 = db:query("INSERT INTO server_track(hostip, hostname, maxplayers, map, players, lastupdate) VALUES ('" .. ipPort .. "', '" .. lHost .. "', '" .. tonumber(GetConVarString("sv_visiblemaxplayers")) .. "', '" .. currentMap .. "', '" .. getPlyCount() .. "', '" .. os.time() .. "')")

			Statquery2.onSuccess = function(q)  
			
				notifymessage("[Awesome Tracker]Added this server to the table!") 
				
				playerCount = getPlyCount();
				
			end
			Statquery2.onError = function(q,e) 
				notifymessage("[Awesome Tracker]Something went wrong")
				notifyerror(e)
			end
			Statquery2:start()
		end	
		updateReady = true
	end 
	loadQuery:start()
	
end


function updateServers ()
	
	if not updateReady then return; end
	if not ServerStatsDB.connected then return; end

	updateString = "UPDATE server_track SET hostname='%s', maxplayers='%d', map='%s', players='%d', lastupdate='%d' WHERE hostip ='%s'"	
	
	local formQ = string.format(updateString,
					db:escape(GetConVarString("hostname")),
					tonumber(GetConVarString("sv_visiblemaxplayers")),
					game.GetMap(),
					getPlyCount(),
					os.time(),
					ipPort
				)
	
	local updateQuery = db:query(formQ)
	updateQuery.onSuccess = function(q) end; 
	updateQuery.onError = function(q,e)
		notifymessage("[Awesome Tracker]Something went wrong")
		notifyerror(e)
	end
	updateQuery:start()	

end
timer.Create("Tracker - Updater", 15, 0, updateServers);


function getServers(ply)

	if not ServerStatsDB.connected then
		ply:PrintMessage( HUD_PRINTTALK, "The server browser is currently unavailable - please try again soon");
		return
	end	
	local updateCheck = os.time() - 60;
	local getAllQ = db:query( "SELECT * FROM server_track WHERE lastupdate > '" .. updateCheck .. "'")
    getAllQ.onSuccess = function(q, sdata)
		net.Start( "TESTY")
			net.WriteTable(sdata)
		net.Send(ply)
	end
	getAllQ.onError = function(q,e)
		notifymessage("[Awesome Tracker]Something went wrong")
		notifyerror(e)
	end
	getAllQ:start()
end

local function chatCom( ply, text, toall )

    local tab = string.Explode( " ", text );
    if tab[1] == "!servers" or tab[1] == "/servers" then
     
        getServers(ply)
     
    elseif tab[1] == "!join" then
				
		ply:SendLua("LocalPlayer():ConCommand('connect "..curServ.."')")
	
	elseif tab[1] == "!favourites" or tab[1] == "!fav" or tab[1] == "!favor" or tab[1] == "!favorite" then
		
		ply:ChatPrint("To add this server to your favourites, then:")
		ply:ChatPrint("Go to the main menu (without leaving the server) by pushing Esc.")
		ply:ChatPrint("Click Legacy Browser - then select the Favourites tab.")
		ply:ChatPrint("Click the button, \"Add Current Server\" - Then your done :)")		

		
	end
	
 
end
hook.Add( "PlayerSay", "JonZChatCommandsTracker", chatCom)

loadServerStats()