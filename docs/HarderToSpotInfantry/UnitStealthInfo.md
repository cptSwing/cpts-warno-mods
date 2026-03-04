A unit is spotted if its **concealment** is lower than **optical** of the unit watching it.

The **concealment** of a unit is `UnitConcealmentBonus * TerrainConcealmentBonus / NoiseConcealmentMalus`.

- `UnitConcealmentBonus` is defined in its `TVisibilityModuleDescriptor`.
- `TerrainConcealmentBonus` is the `ConcealmentBonus` of `TGameplayTerrain` where the unit is.
- `NoiseConcealmentMalus` is between 1.0 (if the unit didn't shoot recently) and highest `NoiseDissimulationMalus` of recently used ammunitions.

The **optical** of a unit looking at a target is `OpticalStrength / distance / ConcealmentByDistance`.

- `OpticalStrength` is defined in its `TScannerConfigurationDescriptor`.
- `distance` is the distance with the target.
- `ConcealmentByDistance` is a constant defined in GDConstant.ndf : `MultiplicateurBonusDissimulationParDistanceGRU`.

---

`GameData\Generated\Gameplay\Unit\Strategic\Units.ndf`

and

`GameData\Generated\Gameplay\Gfx\UniteDescriptor.ndf`
--> has `TInfantrySquadModuleDescriptor()` ? Infantry.

---

Stealth is a stat for every unit in WARNO, describing how difficult a unit is to be detected. Stealth values are discrete and are **1, 1.5, 2, 2.5, and 3** . These values correspond to **Bad, Mediocre, Good, Very Good, Exceptional, and Exceptional+** . These stats can be checked via the in-game on any unit card.

---

`GameData\UserInterface\Use\InGame\UISpecificUnitInfoPanelView.ndf` likely important for Infopanel display?

---

GDConstants.ndf --> DissimulationEnumToValue ??

---

DissimulationValue ??

---

[EUG] Aracthor:

A unit is spotted if its **concealment** is lower than **optical** of the unit watching it.

The **concealment** of a unit is `UnitConcealmentBonus * TerrainConcealmentBonus / NoiseConcealmentMalus`.

- `UnitConcealmentBonus` is defined in its `TVisibilityModuleDescriptor`.
- `TerrainConcealmentBonus` is the `ConcealmentBonus` of `TGameplayTerrain` where the unit is.
- `NoiseConcealmentMalus` is between 1.0 (if the unit didn't shoot recently) and highest `NoiseDissimulationMalus` of recently used ammunitions.

The **optical** of a unit looking at a target is `OpticalStrength / distance / ConcealmentByDistance`.

- `OpticalStrength` is defined in its `TScannerConfigurationDescriptor`.
- `distance` is the distance with the target.
- `ConcealmentByDistance` is a constant defined in GDConstant.ndf : `MultiplicateurBonusDissimulationParDistanceGRU`.
