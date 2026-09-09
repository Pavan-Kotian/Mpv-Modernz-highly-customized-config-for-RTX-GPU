# MPV ModernZ — Highly Customized Config for RTX GPU

A portable, highly customized Windows **mpv** configuration built around **ModernZ** and tuned for NVIDIA RTX GPUs.

## Based on Zabooby's mpv config

This project is **based on and inspired by [Zabooby's mpv-config](https://github.com/Zabooby/mpv-config)**, which focuses on high-quality playback, tuned profiles, shaders, scripts, and a practical viewing experience.

This version keeps that quality-focused foundation while significantly customizing the setup for a modern NVIDIA RTX system, including a completely refreshed **ModernZ** interface and a large streaming cache.

## AI-assisted optimization

This configuration has also been **optimized and refined with the help of AI**, with extensive tuning of mpv settings, GPU rendering, hardware decoding, streaming/cache behavior, shaders, subtitle rendering, audio processing, key bindings, and ModernZ customization.

The goal is to balance **image quality, playback stability, performance, and usability** on NVIDIA RTX hardware.

## Highlights

- 🎨 **ModernZ** modern, sleek OSC/UI with customized controls
- 🚀 NVIDIA RTX GPU optimization with **Vulkan + `gpu-next`**
- ⚡ **NVDEC hardware video decoding**
- 💾 **10 GB disk cache for streaming** to provide a larger buffer for supported streaming playback
- 🎬 4K/HDR playback tuning
- 🖼️ Custom GLSL shader collection for scaling, restoration, sharpening, and image enhancement
- 📝 White subtitles with a clean black outline
- ⌨️ Customized keyboard and mouse controls
- 🔊 Custom audio processing and surround/downmix profiles
- 🖼️ Thumbfast integration for video thumbnail previews
- 📦 Portable `portable_config` layout

## ⚠️ Important: Set Your GPU Name

This configuration currently contains a specific NVIDIA GPU name in `mpv.conf`:

```ini
vulkan-device=NVIDIA GeForce RTX 4050 Laptop GPU
```

**You must change this value to match the GPU in your own PC or laptop.** If the GPU name does not match, mpv may fail to select the intended Vulkan device.

To find the correct Vulkan GPU name, run:

```text
mpv.exe --vulkan-device=help
```

This will display the available Vulkan devices and their names/UUIDs. Copy the appropriate GPU name and replace the `vulkan-device=` value in `portable_config/mpv.conf`.

Example:

```ini
vulkan-device=YOUR GPU NAME HERE
```

If you do not want to manually select a GPU, you can also remove/comment out the `vulkan-device=` line and allow mpv to select the first enumerated hardware Vulkan device automatically.

See the [mpv reference manual](https://mpv.io/manual/master/) for the current Vulkan device options.

## Installation

1. Download the latest package from the repository.
2. Extract the MPV portable build and place the `portable_config` folder beside `mpv.exe`.
3. **Change `vulkan-device=` in `mpv.conf` to match your GPU.**
4. Launch `mpv.exe`.
5. For NVIDIA RTX hardware, the configuration is designed to use Vulkan/`gpu-next` with NVDEC hardware decoding.

## Streaming Cache

The configuration uses a **10 GB disk-based demuxer cache** for streaming:

```ini
demuxer-cache-dir=C:\mpv-cache
demuxer-max-bytes=10G
demuxer-max-back-bytes=512M
cache-pause=yes
```

This is a **disk cache**, not a 10 GB RAM allocation. The larger cache is intended to provide more buffering headroom during streaming and improve seeking/playback stability when the source and network conditions allow it.

## Credits

- **Base configuration:** [Zabooby/mpv-config](https://github.com/Zabooby/mpv-config)
- **ModernZ:** [Samillion/ModernZ](https://github.com/Samillion/ModernZ)
- **mpv:** [mpv-player/mpv](https://github.com/mpv-player/mpv)

This project is a customized configuration and is not affiliated with Zabooby, Samillion, or the mpv project.

## Notes

This configuration is primarily tuned for Windows and NVIDIA RTX GPUs. Some options, shaders, audio processing, scripts, and UI settings are intentionally customized for this setup.

## License / Third-party components

This repository contains third-party scripts, shaders, fonts, and assets. Their original licenses and attribution should be retained where applicable. Refer to the individual component repositories/files for their respective licensing terms.
