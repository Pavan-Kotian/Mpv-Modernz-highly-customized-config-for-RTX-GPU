# MPV ModernZ — Highly Customized Config for RTX GPU

A portable, highly customized Windows **mpv** configuration built around **ModernZ** and tuned for NVIDIA RTX GPUs.

## Highlights

- ModernZ UI with customized sizing and controls
- NVIDIA hardware decoding via NVDEC
- Vulkan + `gpu-next` rendering
- 4K/HDR playback tuning
- Custom GLSL shader collection for scaling and image enhancement
- White subtitles with a clean black outline
- Spacebar play/pause binding
- Custom audio processing and surround/downmix profiles
- Thumbfast integration
- Portable `portable_config` layout

## Installation

1. Download the latest package from the repository.
2. Extract the MPV portable build and place the `portable_config` folder beside `mpv.exe`.
3. Launch `mpv.exe`.
4. For NVIDIA RTX hardware, the configuration is designed to use Vulkan/gpu-next with NVDEC hardware decoding.

## Notes

This configuration is primarily tuned for Windows and NVIDIA RTX GPUs. Some options, shaders, audio processing, and scripts are intentionally customized for this setup.

ModernZ is maintained separately by Samillion: https://github.com/Samillion/ModernZ

## License / Third-party components

This repository contains third-party scripts, shaders, fonts, and assets. Their original licenses and attribution should be retained where applicable. Refer to the individual component repositories/files for their licensing terms.
