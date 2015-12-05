require( "mysqloo" )

ServerStatsDB = {}

ServerStatsDB.ServerIP = "200.6.36.127"
ServerStatsDB.ServerPort = 27016

ServerStatsDB.Host = "localhost"
ServerStatsDB.Username = "root"
ServerStatsDB.Password = ""
ServerStatsDB.Database_name = ""
ServerStatsDB.Database_port = 3306
ServerStatsDB.connected = true;

function connectToDatabase()

	db = mysqloo.connect(ServerStatsDB.Host, ServerStatsDB.Username, ServerStatsDB.Password, ServerStatsDB.Database_name, ServerStatsDB.Database_port)
	db.onConnected = function() 
		print("***********Database linked!***********") 
		ServerStatsDB.connected = true;
	end
	db.onConnectionFailed = function(self, err)
		ServerStatsDB.connected = false;
		print("[Awesome Stats]Failed to connect to the database: ", err, ". Retrying in 60 seconds.");
		timer.Simple(60, function()
			db:connect()
		end);
	end	
	db:connect()
end
hook.Add( "Initialize", "DBStuff - connect", connectToDatabase ); 

function checkQuery(query)
    local playerInfo = query:getData()
    if playerInfo[1] ~= nil then
		return true
    else
		return false
    end
end

function notifyerror(...)
    ErrorNoHalt("[", os.date(), "][Database stuff] ", ...);
    ErrorNoHalt("\n");
    print();
end

function notifymessage(...)
    local words = table.concat({"[",os.date(),"][Database stuff] ",...},"").."\n";
    ServerLog(words);
    Msg(words);
end