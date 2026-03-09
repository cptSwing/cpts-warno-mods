## YIMBY - Yes, in my backyard

Buffs Cover and Damage Reduction of Buildings / Rubble

# Spotting / Concealment

The concealment of a unit is `UnitConcealmentBonus * TerrainConcealmentBonus / NoiseConcealmentMalus`.

- `UnitConcealmentBonus` is defined in its `TVisibilityModuleDescriptor`.
- `TerrainConcealmentBonus` is the `ConcealmentBonus` of `TGameplayTerrain` where the unit is.
- `NoiseConcealmentMalus` is between 1.0 (if the unit didn't shoot recently) and highest `NoiseDissimulationMalus` of recently used ammunitions.
