--set function from https://www.lua.org/pil/11.5.html
--leave this alone!
function Set (list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end


----edit this block-------

--line 11 declares the int's of classes of cars you want banned
--a list of the car class numbers is here: https://runtime.fivem.net/doc/natives/#_0x29439776AAA00A62
--for instance, military is 19. to ban military vehicles set the line below to {19}.
bannedcarlist = Set{0,0}

----stop editing---------


RegisterNetEvent("VehicleSpawner")
AddEventHandler('VehicleSpawner', function(args,isadmin)
	carname = args[1]
	ped=PlayerPedId()
	if ped then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(ped, 0.0, 8.0, 0.5))
		if carname == nil then
			TriggerEvent('chatMessage', "^6Spawner", {255, 0, 0}, "^6Usage: ^7/spawn carname")
		else
			local hash = GetHashKey(carname)
			local class = GetVehicleClassFromName(hash)
			if bannedcarlist[class] and not isadmin then
				TriggerEvent('chatMessage', "^6Spawner", {255, 0, 0}, "^7The vehicle you are attempting to spawn is not allowed on this server.")
			else
				RequestModel(hash)
				local wait = 0
				TriggerEvent('chatMessage', "^6Spawner", {255, 0, 0}, "^7We are now attempting to load '".. carname .. "'. Please wait.")
				while not HasModelLoaded(hash) do
					if wait > 10000 then
						TriggerEvent('chatMessage', "^6Spawner", {255, 0, 0}, "^7Could not load the car model or the car does not exist.")
						break
					else
						Citizen.Wait(100)
						wait = wait+100
					end
				end
				if DoesEntityExist(lastcar) then
					DeleteEntity(lastcar)
				end
				if HasModelLoaded(hash) then
					TriggerEvent('chatMessage', "^6Spawner", {255, 0, 0}, "^7Your vehicle has spawned!")
					lastcar = CreateVehicle(hash, x, y, z, GetEntityHeading(ped)+90, 1, 0)
					SetVehicleEngineOn(lastcar,true,true,true)
					SetPedIntoVehicle(ped,lastcar,-1)
				end
			end
		end
	end
end)

