AddCSLuaFile()

ENT.Base = "rust_workbench"

ENT.PickupType = PickupType.Hammer
ENT.Model = "models/deployable/workbench_tier2.mdl"
ENT.MaxHP = 500
ENT.Decay = 8 * 60*60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "metal_fragments",
        Amount = 50
    }
}

ENT.ShouldSave = true

ENT.Deploy = gRust.CreateDeployable()
    :SetModel(ENT.Model)
    :SetRotate(90)
    :SetInitialRotation(180)
    //:SetSound("deploy/metal_bars_deploy.wav")

ENT.TechTree = util.XmlToTable([[
    <TechTree>
        <Item id="hazmat_suit" cost="125">
            <Item id="medical_syringe" cost="75">
                <Item id="large_medkit" cost="75">
                    
                </Item>
            </Item>

            <Item id="coffee_can_helmet" cost="75">
            
            </Item>
        </Item>

        <Item id="metal_horizontal_embrasure" cost="20" offset="1.5">
            <Item id="metal_vertical_embrasure" cost="20">
                <Item id="strengthened_glass_window" cost="75">
                    <Item id="small_oil_refinery" cost="75">
                        <Item id="garage_door" cost="90">

                        </Item>
                    </Item>
                </Item>
            </Item>
            
            <Item id="pump_shotgun" cost="125">
                <Item id="semi_automatic_pistol" cost="125">
                    <Item id="f1_grenade" cost="75">
                        <Item id="python_revolver" cost="125">
                            <Item id="muzzle_boost" cost="125">
                                <Item id="muzzle_brake" cost="125">
                                    <Item id="custom_smg" cost="125">
                                        <Item id="thompson" cost="125">
                                            <Item id="556_rifle_ammo" cost="125">
                                                <Item id="semi_automatic_rifle" cost="125">
                                                    <Item id="holosight" cost="125">
                                                        <Item id="rocket_launcher" cost="500">
                                                            <Item id="high_velocity_rocket" cost="125">
                                                                
                                                            </Item>
                                                        </Item>
                                                    </Item>
                                                </Item>
                                            </Item>
                                        </Item>
                                    </Item>
                                </Item>
                            </Item>
                            
                            <Item id="hv_pistol_ammo" cost="125">
                            
                            </Item>

                            <Item id="incendiary_pistol_bullet" cost="125">
                                <Item id="homemade_landmine" cost="150">
                                    <Item id="auto_turret" cost="500">

                                    </Item>
                                </Item>
                            </Item>
                        </Item>
                    </Item>
                </Item>
            </Item>
        </Item>
    </TechTree>
]])