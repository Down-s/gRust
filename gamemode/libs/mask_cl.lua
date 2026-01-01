local TEXTUREFLAGS_NOMIP = 256

local RT_TEXTURE_FLAGS = TEXTUREFLAGS_NOMIP
local SOURCE_RT = GetRenderTargetEx("gRust_SourceRT", ScrW(), ScrH(), RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_SEPARATE, RT_TEXTURE_FLAGS, 0, IMAGE_FORMAT_BGRA8888)
local DEST_RT = GetRenderTargetEx("gRust_DestRT", ScrW(), ScrH(), RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_SEPARATE, RT_TEXTURE_FLAGS, 0, IMAGE_FORMAT_BGRA8888)

local SOURCE_MAT = CreateMaterial("gRust_SourceMask", "UnlitGeneric", {
    ["$basetexture"] = SOURCE_RT:GetName(),
    ["$translucent"] = 1,
    ["$vertexcolor"] = 1,
    ["$vertexalpha"] = 1,
})

local DEST_MAT = CreateMaterial("gRust_DestMask", "UnlitGeneric", {
    ["$basetexture"] = DEST_RT:GetName(),
    ["$translucent"] = 1,
    ["$vertexcolor"] = 1,
    ["$vertexalpha"] = 1,
})

function gRust.StartMask()
    render.PushRenderTarget(DEST_RT)
    render.Clear(0, 0, 0, 0, true, true)
    
    cam.Start2D()
end

function gRust.EndMask(x, y, w, h, mask)
    cam.End2D()

    render.PopRenderTarget()

    render.PushRenderTarget(SOURCE_RT)
    render.Clear(0, 0, 0, 0, true, true)

    cam.Start2D()
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(mask)
        surface.DrawTexturedRect(x, y, w, h)
    cam.End2D()

    render.PopRenderTarget()

    render.PushRenderTarget(DEST_RT)

    local scrw, scrh = ScrW(), ScrH()

    cam.Start2D()
        -- Can be inverted with BLEND_ONE_MINUS_SRC_ALPHA
        render.OverrideBlend(true, BLEND_ZERO, BLEND_SRC_ALPHA, BLENDFUNC_ADD)

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(SOURCE_MAT)
        surface.DrawTexturedRect(0, 0, scrw, scrh)

        render.OverrideBlend(false)
    cam.End2D()

    render.PopRenderTarget()

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(DEST_MAT)
    surface.DrawTexturedRectUV(x, y, w, h, x / scrw, y / scrh, (x + w) / scrw, (y + h) / scrh)
end