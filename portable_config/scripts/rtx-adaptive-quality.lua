-- Adaptive RTX Quality for MPV ModernZ
-- Selects an existing shader chain based on source resolution and actual MPV window size.
-- Designed for the NVIDIA RTX 4050 profile in this repository.

local mp = require "mp"

local active = "none"

local chains = {
    sd = {
        "~~/shaders/F16.glsl",
        "~~/shaders/ssimds.glsl",
    },
    hd = {
        "~~/shaders/ravu_z_ar_r3.glsl",
        "~~/shaders/ssimds.glsl",
    },
    fullhd = {
        "~~/shaders/F8.glsl",
        "~~/shaders/ssimds.glsl",
    },
}

local function set_shaders(list)
    -- Replace, rather than append, so repeated activation never stacks
    -- multiple expensive shader chains.
    mp.commandv("change-list", "glsl-shaders", "clr", "")
    for _, shader in ipairs(list) do
        mp.commandv("change-list", "glsl-shaders", "append", shader)
    end
end

local function clear_shaders()
    mp.commandv("change-list", "glsl-shaders", "clr", "")
end

local function choose()
    local vp = mp.get_property_native("video-params")
    if not vp then
        mp.osd_message("RTX Adaptive: video parameters unavailable", 3)
        return
    end

    local sw = tonumber(vp.w)
    local sh = tonumber(vp.h)
    local dims = mp.get_property_native("osd-dimensions") or {}
    local ow = tonumber(dims.w) or 0
    local oh = tonumber(dims.h) or 0

    if not sw or not sh then
        mp.osd_message("RTX Adaptive: source resolution unavailable", 3)
        return
    end

    -- Use the largest axis so letterboxing does not accidentally disable
    -- useful upscaling.
    local scale = 1.0
    if ow > 0 and oh > 0 then
        scale = math.max(ow / sw, oh / sh)
    end

    local chain
    local label

    if scale <= 1.05 then
        clear_shaders()
        label = "Native / no upscale shader"
    elseif sh <= 576 then
        chain = chains.sd
        label = "SD → F16 + SSIM"
    elseif sh <= 900 then
        chain = chains.hd
        label = "HD → RAVU + SSIM"
    elseif sh <= 1600 then
        chain = chains.fullhd
        label = "FHD/QHD → FSRCNNX F8 + SSIM"
    else
        clear_shaders()
        label = "4K-class → no neural upscale"
    end

    if chain then
        set_shaders(chain)
    end

    active = label
    mp.osd_message(
        string.format("RTX Adaptive Quality\nSource: %dx%d\nWindow: %dx%d\nScale: %.2fx\n%s",
            sw, sh, ow, oh, scale, label),
        4
    )
end

local function status()
    mp.osd_message("RTX Adaptive Quality: " .. active, 3)
end

mp.add_key_binding(nil, "rtx-adaptive-quality", choose)
mp.add_key_binding(nil, "rtx-adaptive-status", status)
mp.register_script_message("rtx-adaptive-quality", choose)
mp.register_script_message("rtx-adaptive-status", status)
