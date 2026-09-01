## 1.0.17

- Use duration-based GOP for SL6806

## 1.0.16

- Reduce excessive bitrate for MPEG4

## 1.0.15

- MPEG4 GOP of 1s for bitrate stability

## 1.0.14

- Remove VBV for MPEG4 for now

## 1.0.13

- Benchmark and properly solidify MPEG4 VBV

## 1.0.12

- Fix MPEG4 dense I-frames by forcing strict GOP

## 1.0.11

- Export library files
- Introduce toolchain configuration
- Allow CLI to specify toolchain configuration

## 1.0.10

- Revert reduced bitrate for MPEG4 320x240

## 1.0.9

- Reduce quality for SL6806 128x160

## 1.0.8

- Add helper method for FFmpeg 2-pass
- Use non-prefixed temp directories for 2-pass
- Adjust bitrate for perceptual consistency for MPEG4 profiles
- Switch from CQP to 2-pass VBR for MJPEG

## 1.0.7

- Ensure minimum FPS is 1, not 0
- Prefix 2-pass VBR log directory with output file name
- Make some sync methods async

## 1.0.6

- Place pass log files in temp directory

## 1.0.5

- Switch to mpeg4 encoder to support VBV
- Use 2-pass encode
- Validate input file exists

## 1.0.4

- Improve MJPEG quality

## 1.0.3

- Swap uid0017 & uid0018 from CQP to ABR due to needing a VBV

## 1.0.2

- Add global library binary path overrides.

## 1.0.1

- Additional documentation

## 1.0.0

- Initial version.
