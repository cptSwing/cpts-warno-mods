# Spotting / Concealment

The concealment of a unit is `UnitConcealmentBonus * TerrainConcealmentBonus / NoiseConcealmentMalus`.

- `UnitConcealmentBonus` is defined in its `TVisibilityModuleDescriptor`.
- `TerrainConcealmentBonus` is the `ConcealmentBonus` of `TGameplayTerrain` where the unit is.
- `NoiseConcealmentMalus` is between 1.0 (if the unit didn't shoot recently) and highest `NoiseDissimulationMalus` of recently used ammunitions.

I confirm : those DamageModifierPerFamilyAndResistance are products for damages of a specific type on a specific family.
A 0.7 means it would multiply by 0.7 any matching damage for matching resistance on this terrain. In other words, a 30% reduction.

#### Text in Map hints being wrong

TerrainTypeToText / UIMousePolicyResources.ndf ??

# Logistics / Supply

Supply Hub buildings:
`GameData/Generated/Gameplay/Gfx/BuildingDescriptors.ndf`

Supply Vehicles:
`GameData/Generated/Gameplay/Gfx/UniteDescriptors.ndf`

# Traits / Abilities

- Snipers have ability to get more cover / stealth when being stationary for a bit --> Piggyback off this for entrenching engineers/saperi/pioniere?
- Recon Infantry has another buff to stealth - or was it optics ? - that is handled via trait, afaik
- How does GSR work?

[01:10] StinkApe: Anyone know how to add unit-card elements?  I know it came up awhile back but cant find the convo for the life of me.
[01:10] StinkApe: Like for a new trait
[01:10] StinkApe: ala Amphibious, Smoke Launchers, etc 
[09:42] Jasp137: For traits I believe UnitSpecialties.ndf, SpecialityIconTextures.ndf and SpecialtiesList in UniteDescriptor.ndf. Havent added a new Trait myselfe yet but want to do it in the future.
[10:00] dane: All the trait stuff is unitspecialties.ndf, effectspackslist.ndf, effectssurunite.ndf, capacitelist.ndf, specialtyicontextures.ndf and conditionsdescriptor.ndf :)

All 'capacities' a unit has are under     ~/EffectApplierModuleDescriptor in UniteDescriptor (it's right above the unit cost). You simply add the desired capacity to the Default Skill list. The exact effects of the Capacities are defined under Target effect which references EffetsSurUnite.NDF.
[02:28]Yung Venuz [EU5], : SpecialtiesList (right above NameToken in the same file) handles the display of said traits in the unit card Ui and is naturally purely cosmetic

There's not a specific "SF" thing, but they usually get both Capacite_Choc and Capacite_resolute  in the DefaultSkillList to get those benefits, and then get the '_sf' tag in the SpecialtiesList to show up as SF in the UI
