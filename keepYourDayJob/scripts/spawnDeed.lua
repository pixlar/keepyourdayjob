oldInit = init

function init(dt)
	oldInit(dt)
	message.setHandler("recruit.spawnDeed", simpleHandler(recruitable.spawnDeed))
end
  
function recruitable.spawnDeed()
	npcName = npc.humanoidIdentity().name
	
	retire = {
		crewmemberchemist = "scientist",
		crewmemberchemistblue = "scientist",
		crewmemberchemistgreen = "scientist",
		crewmemberchemistorange = "tar",
		crewmemberchemistyellow = "glow",
		crewmemberjanitor = "wizardmerchant",
		crewmemberengineer = "electrician",
		crewmembermechanic = "foundry",
		crewmembermedic = "giantflower",
		crewmemberoutlaw = "friendlycultist",
		crewmember = "friendlyguardtenant",
		crewmembertailor = "socialite"
		}
	
	newID = {
		species = npc.species(),
		spawn = "npc",
		seed = npc.seed(),
		type = retire[npc.npcType()],
		uniqueId = entity.uniqueId(),
		personality = personality(),
		overrides = {
			identity = npc.humanoidIdentity(),
			damageTeamType = "friendly",
			persistent = true,
			damageTeam = 0 
		}
	}
	 emptyhouse = { 
		 boundary = { { 987.5, 1023.5 }, { 988.5, 1024.5 }, { 988.5, 1028.5 }, { 987.5, 1029.5 }, { 987.5, 1033.5 }, { 986.5, 1034.5 }, { 979.5, 1034.5 }, { 978.5, 1033.5 }, { 978.5, 1024.5 }, { 979.5, 1023.5 }, { 984.5, 1023.5 } },
		 objects = { apexshiplight = 1,  florandoor = 1 },
		 floorPosition = { 984.5, 1023.5 },
		 seed = 3285878510,
		 contents = { 
			 light = 2,
			 door = 5 
		 }  
	 }
	deedParameters = {}
	deedParameters.shortdescription = npcName.."'s Deed"
	deedParameters.scriptStorage = {
		occupier = {
			name = "villager_random",
			colonyTagCriteria = { light = 1,  door = 1 },
			tenants = { newID }
		},
		house = emptyhouse
	}
	world.spawnItem("tenantdeed", mcontroller.position(), 1, deedParameters)
end