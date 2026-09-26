-- Zenith Tools V2.2
-- Portable utilities for the Zenith MPV build.

local mp = require 'mp'

local msg = require 'mp.msg'
local safe_mode = false
local hevc_safe = false
local baseline = {}

local function osd(text, duration)
    mp.osd_message(text, duration or 2.5)
end

local function capture_baseline()
    baseline.interpolation = mp.get_property_native('interpolation')
    baseline.deband = mp.get_property_native('deband')
    baseline.shaders = mp.get_property_native('glsl-shaders') or {}
    baseline.vf = mp.get_property_native('vf') or {}
end

local function reset_video_processing()
    mp.set_property_native('glsl-shaders', {})
    mp.set_property_native('vf', {})
    mp.set_property_native('deband', false)
    mp.set_property_native('interpolation', baseline.interpolation ~= false)
    osd('✓ Video processing reset')
end

local function toggle_safe_mode()
    safe_mode = not safe_mode
    if safe_mode then
        mp.set_property_native('glsl-shaders', {})
        mp.set_property_native('vf', {})
        mp.set_property_native('deband', false)
        mp.set_property_native('interpolation', false)
        osd('Safe Mode: ON\nShaders • Filters • Interpolation OFF', 3)
    else
        mp.set_property_native('glsl-shaders', baseline.shaders or {})
        mp.set_property_native('vf', baseline.vf or {})
        mp.set_property_native('deband', baseline.deband ~= false)
        mp.set_property_native('interpolation', baseline.interpolation ~= false)
        osd('Safe Mode: OFF\nBaseline processing restored', 3)
    end
end

local function prop(name, default)
    local v = mp.get_property(name)
    if v == nil or v == '' then return default or 'N/A' end
    return v
end

local function media_info()
    local lines = {
        'ZENITH MPV — MEDIA INFORMATION',
        '────────────────────────────────',
        'File: ' .. prop('media-title'),
        '',
        'VIDEO',
        'Codec:      ' .. prop('video-format'),
        'Resolution: ' .. prop('width') .. ' × ' .. prop('height'),
        'FPS:        ' .. prop('container-fps'),
        'Format:     ' .. prop('video-params/format'),
        'Bit depth:  ' .. prop('video-params/bit-depth'),
        'Primaries:  ' .. prop('video-params/primaries'),
        'Transfer:   ' .. prop('video-params/gamma'),
        'Matrix:     ' .. prop('video-params/colormatrix'),
        'HWDec:      ' .. prop('hwdec-current'),
        '',
        'AUDIO',
        'Codec:      ' .. prop('audio-codec'),
        'Channels:   ' .. prop('audio-params/channel-count'),
        'Rate:       ' .. prop('audio-params/samplerate'),
        '',
        'RENDERER',
        'VO:         ' .. prop('current-vo'),
        'Display FPS: '.. prop('display-fps'),
        'Dropped:    ' .. prop('frame-drop-count', '0'),
        'A/V Sync:   ' .. prop('avsync', '0'),
    }
    mp.osd_message(table.concat(lines, '\n'), 10)
end

local function reopen_software_decode()
    local path = mp.get_property('path')
    if not path or path == '' then
        osd('No local file is currently loaded')
        return
    end
    local pos = mp.get_property_number('time-pos', 0) or 0
    hevc_safe = not hevc_safe
    local hw = hevc_safe and 'no' or 'nvdec'
    -- Reopening is intentional: mpv documents hwdec as a decoder/renderer initialization option.
    mp.commandv('set', 'hwdec', hw)
    mp.commandv('set', 'vd-lavc-dr', hevc_safe and 'no' or 'auto')
    mp.commandv('loadfile', path, 'replace', 'start=' .. tostring(pos))
    if hevc_safe then
        osd('HEVC Safe Mode: ON\nSoftware decode • reopening file', 3)
    else
        osd('HEVC Safe Mode: OFF\nNVDEC • reopening file', 3)
    end
end

capture_baseline()

mp.add_key_binding(nil, 'zenith-reset-video', reset_video_processing)
mp.add_key_binding(nil, 'zenith-safe-mode', toggle_safe_mode)
mp.add_key_binding(nil, 'zenith-media-info', media_info)
mp.add_key_binding(nil, 'zenith-hevc-safe', reopen_software_decode)

mp.register_event('file-loaded', function()
    capture_baseline()
    safe_mode = false
end)
