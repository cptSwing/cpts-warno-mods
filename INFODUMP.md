# Spotting / Concealment

The concealment of a unit is `UnitConcealmentBonus * TerrainConcealmentBonus / NoiseConcealmentMalus`.

- `UnitConcealmentBonus` is defined in its `TVisibilityModuleDescriptor`.
- `TerrainConcealmentBonus` is the `ConcealmentBonus` of `TGameplayTerrain` where the unit is.
- `NoiseConcealmentMalus` is between 1.0 (if the unit didn't shoot recently) and highest `NoiseDissimulationMalus` of recently used ammunitions.

# Logistics / Supply

Supply Hub buildings:
`GameData/Generated/Gameplay/Gfx/BuildingDescriptors.ndf`

Supply Vehicles:
`GameData/Generated/Gameplay/Gfx/UniteDescriptors.ndf`
