--this is probably disgusting but I know no other ways of doing it yet, so bear with me
--atleastitworks.ogg

--get config elements
self.selfDamageType = config.getParameter("selfDamageType", "maxHealthPercentage")
self.damagePerHit = config.getParameter("damagePerHit", 0.01)

self.dmgreq = {
      damageType = "IgnoresDef",
      damage = 1,
      sourceEntityId = activeItem.ownerEntityId()
    }

--determine which ability slot we're in
self.primaryAbilityScripts = config.getParameter("primaryAbility.scripts")
self.altAbilityScripts = config.getParameter("altAbility.scripts")

if self.altAbilityScripts then
  for i = 1, #self.altAbilityScripts do
    if string.find(self.altAbilityScripts[i], "selfdamagingstrike.lua") then
      self.fireModeB = "secondary"
    end
  end
end

if self.primaryAbilityScripts then
  for i = 1, #self.primaryAbilityScripts do
    if string.find(self.primaryAbilityScripts[i], "selfdamagingstrike.lua") then
      self.fireModeA = "primary"
    end
  end
end

oldInit = init
function init()
  oldInit()
  sb.logInfo("hi")
end

--[[oldFire = fire()
function fire()
  oldFire()
  sb.logInfo("ho")
end]]

oldupdate = update
function update(dt, fireMode, shiftHeld)
  oldupdate(dt, fireMode, shiftHeld)

  sb.setLogMap("update ","%s %s %s", fireMode, 0.01 * status.resourceMax("health"), self.selfDamageType)

  if fireMode == self.fireModeA or fireMode == self.fireModeB then

    if self.selfDamageType == "maxHealthPercentage" then
       self.dmgreq.damage = self.damagePerHit * status.resourceMax("health")
    elseif self.selfDamageType == "fixedAmount" then
      self.dmgreq.damage = self.damagePerHit
    end

    status.applySelfDamageRequest(self.dmgreq)
  end
end