function tenant.degraduate()
  if storage.respawner then
    local respawnerEntityId = world.loadUniqueEntity(storage.respawner)
    if world.entityExists(respawnerEntityId) then
      if world.callScriptedEntity(respawnerEntityId, "countMonsterTenants") > 0 then
        return
      end
    end
  end

local graduation = config.getParameter("questGenerator.graduation.oldNpcType") or "villager"
  --local gear = config.getParameter("questGenerator.graduation.oldItems")
--  npc.setItemSlot(chest, nil)
--  npc.setItemSlot(legs, nil)
  storage.itemSlots.chest = nil
  storage.itemSlots.legs = nil
  
  if graduation then
    local nextNpcType = graduation
    tenant.setNpcType(nextNpcType)
  end
end

function recruitable.declineRecruitment(playerUniqueId)
  local playerEntityId = world.loadUniqueEntity(playerUniqueId)
  if not world.entityExists(playerEntityId) then
    playerEntityId = nil
  end
  sb.logInfo("going back to my old job...")
  
  tenant.degraduate()
  

  notify({ type = "recruitDeclined", sourceId = playerEntityId })
end

    
function tenant.setNpcType(npcType)
  if npc.npcType() == npcType then return end

  npc.resetLounging()

  -- Changing the tenant's npc type consists of:
  -- 1. Spawning a new npc at our current position
  -- 2. Updating the colonydeed with the new npc's npcType and uniqueId
  -- 3. Killing ourself
  -- This is done to turn villagers into crewmembers.
  
  -- Store old items for degraduation
  theItems = storage.itemSlots

  -- Preserve head item slots, even if they haven't changed from the default:
  storage.itemSlots = storage.itemSlots or {}
  if not storage.itemSlots.headCosmetic and not storage.itemSlots.headCosmetic then
    storage.itemSlots.headCosmetic = npc.getItemSlot("headCosmetic")
  end
  if not storage.itemSlots.head then
    storage.itemSlots.head = npc.getItemSlot("head")
  end
  storage.itemSlots.primary = nil
  storage.itemSlots.alt = nil

  local newUniqueId = sb.makeUuid()
  local newEntityId = world.spawnNpc(entity.position(), npc.species(), npcType, npc.level(), npc.seed(), {
      identity = npc.humanoidIdentity(),
      scriptConfig = {
          personality = personality(),
          initialStorage = preservedStorage(),
          uniqueId = newUniqueId,
          questGenerator = {
          	graduation = {
          		oldNpcType = npc.npcType(),
				oldItems = theItems
          	}
          }
        }
    })

  if storage.respawner then
    assert(newUniqueId and newEntityId)
    world.callScriptedEntity(newEntityId, "tenant.setHome", storage.homePosition, storage.homeBoundary, storage.respawner, true)

    local spawnerId = world.loadUniqueEntity(storage.respawner)
    assert(spawnerId and world.entityExists(spawnerId))
    world.callScriptedEntity(spawnerId, "replaceTenant", entity.uniqueId(), {
        uniqueId = newUniqueId,
        type = npcType
      })
  end

  tenant.despawn(false)
end

