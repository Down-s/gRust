AddCSLuaFile()

ENT.Base = "rust_workbench"

ENT.PickupType = PickupType.Hammer
ENT.Model = "models/deployable/workbench_tier1.mdl"
ENT.MaxHP = 500
ENT.Decay = 8 * 60*60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "wood",
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
        <Item id="pickaxe" cost="75">
            <Item id="salvaged_sword" cost="20">
                <Item id="salvaged_cleaver" cost="75">
                    <Item id="waterpipe_shotgun" cost="75">
                        <Item id="double_barrel_shotgun" cost="125">
                            <Item id="silencer" cost="75">
                                
                            </Item>
                        </Item>
                        
                        <Item id="combat_knife" cost="75">
                            <Item id="weapon_flashlight" cost="75">
                                
                            </Item>
                        </Item>
                        
                        <Item id="revolver" cost="75">
                            <Item id="pistol_bullet" cost="75">
                                <Item id="beancan_grenade" cost="75">
                                    <Item id="satchel_charge" cost="125">
                                        
                                    </Item>
                                </Item>
                            </Item>
                        </Item>
                    </Item>
                </Item>
            </Item>
        </Item>

        <Item id="hatchet" cost="75" offset="0.5">
            <Item id="wooden_barricade_cover" cost="20">
                <Item id="stone_barricade" cost="20">
                    
                </Item>
            </Item>
            
            <Item id="wooden_window_bars" cost="75">
            
            </Item>
        </Item>
    </TechTree>
]])