local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1.05,
	["$pp_colour_colour"] = 1.05,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0.75
}

hook.Add("RenderScreenspaceEffects", "PostProcessingExample", function()
	DrawColorModify(tab)
end )