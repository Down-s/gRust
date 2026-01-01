-- TODO: Make configurable?
gRust.TreeModels = {
	["models/props_foliage/ah_super_large_pine002.mdl"] = 220,
	["models/props_foliage/ah_large_pine.mdl"] = 180,
	["models/props/cs_militia/tree_large_militia.mdl"] = 140,
	["models/props_foliage/ah_medium_pine.mdl"] = 220,
	["models/brg_foliage/tree_scotspine1.mdl"] = 160,
	["models/props_foliage/ah_super_pine001.mdl"] = 180,
	["models/props_foliage/ah_ash_tree001.mdl"] = 190,
	["models/props_foliage/ah_large_pine.mdl"] = 190,
	["models/props_foliage/ah_ash_tree_cluster1.mdl"] = 140,
	["models/props_foliage/ah_ash_tree_med.mdl"] = 170,
	["models/props_foliage/ah_hawthorn_sm_static.mdl"] = 150,
	["models/props_foliage/coldstream_cedar_trunk.mdl"] = 170,
	["models/props_foliage/ah_ash_tree_lg.mdl"] = 190,
}

local ENTITY = FindMetaTable("Entity")
function ENTITY:IsTree()
    return gRust.TreeModels[self:GetModel()] ~= nil
end