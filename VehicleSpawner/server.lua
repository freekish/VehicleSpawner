adminonly = false
RegisterCommand('spawn', function(source, args, user)
	if(IsPlayerAceAllowed(source,"command")) then
		isadmin = true
	else
		isadmin = false
	end
	if adminonly then
		if(IsPlayerAceAllowed(source,"command")) then
			TriggerClientEvent('VehicleSpawner', source,args,isadmin)
		end
	else
		TriggerClientEvent('VehicleSpawner', source,args,isadmin)
	end
end)
