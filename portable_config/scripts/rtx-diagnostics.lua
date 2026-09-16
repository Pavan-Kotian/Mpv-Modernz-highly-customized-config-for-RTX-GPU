-- RTX Diagnostics for MPV ModernZ RTX Ultimate
-- Displays renderer, decoder, video/display timing, HDR and cache information.

local mp = require 'mp'
local utils = require 'mp.utils'

local function val(name, fallback)
    local v = mp.get_property(name)
    if v == nil or v == '' then return fallback or 'n/a' end
    return v
end

local function fmt_num(v, digits)
    local n = tonumber(v)
    if not n then return 'n/a' end
    return string.format('%.' .. tostring(digits or 2) .. 'f', n)
end

local function show()
    local w = val('video-params/w', '?')
    local h = val('video-params/h', '?')
    local fps = val('estimated-vf-fps', val('video-params/fps', 'n/a'))
    local display = val('display-fps', 'n/a')
    local gpu = val('gpu-api', 'n/a')
    local hw = val('hwdec-current', val('hwdec', 'n/a'))
    local vo = val('vo-configured', val('vo', 'n/a'))
    local prim = val('video-params/primaries', 'n/a')
    local gamma = val('video-params/gamma', 'n/a')
    local sync = val('video-sync', 'n/a')
    local cache = val('cache-used', 'n/a')
    local cacheSize = val('demuxer-cache-duration', 'n/a')
    local dropped = val('frame-drop-count', '0')
    local missed = val('mistimed-frame-count', '0')
    local aid = val('audio-codec-name', 'n/a')
    local vid = val('video-codec-name', 'n/a')

    local text = string.format([[
RTX ULTIMATE DIAGNOSTICS

GPU API       %s
Renderer      %s
Decoder       %s

Video         %sx%s @ %s fps
Display       %s Hz
Video codec   %s
Audio codec   %s

HDR           %s / %s
Sync          %s
Cache used    %s
Cache time    %s s

Dropped      %s
Mistimed     %s]], gpu, vo, hw, w, h, fmt_num(fps, 3), display, vid, aid, prim, gamma, sync, cache, cacheSize, dropped, missed)

    mp.osd_message(text, 8)
end

mp.add_key_binding(nil, 'rtx-diagnostics', show)
mp.register_script_message('rtx-diagnostics', show)
