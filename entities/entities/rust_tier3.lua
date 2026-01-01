AddCSLuaFile()

ENT.Base = "rust_workbench"

ENT.PickupType = PickupType.Hammer
ENT.Model = "models/deployable/workbench_tier3.mdl"
ENT.MaxHP = 750
ENT.Decay = 8 * 60*60 -- 8 hours
ENT.Upkeep = {
    {
        Item = "hq_metal",
        Amount = 20
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
        <Item id="reinforced_glass_window" cost="125" float="left">
            <Item id="armored_door" cost="500">
                <Item id="armored_double_door" cost="500">

                </Item>
            </Item>
        
            <Item id="weapon_lasersight" cost="125" offset="0.5">
                <Item id="hv_556_rifle_ammo" cost="125">
                    <Item id="incendiary_556_rifle_ammo" cost="125">
                        <Item id="mp5a4" cost="500">
                            <Item id="explosive_556_rifle_ammo" cost="125">
                                <Item id="explosives" cost="500">
                                    <Item id="timed_explosive_charge" cost="500">
                                        <Item id="rocket" cost="125">

                                        </Item>
                                    </Item>
                                </Item>
                                
                                <Item id="assault_rifle" cost="500">
                                    <Item id="bolt_action_rifle" cost="500">
                                        <Item id="8x_zoom_scope" cost="125">

                                        </Item>
                                    </Item>
                                </Item>
                            </Item>
                        </Item>
                    </Item>

                    <Item id="metal_chest_plate" cost="500">

                    </Item>
                </Item>
            </Item>
        </Item>
    </TechTree>
]])