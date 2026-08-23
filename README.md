# mp3cd

[Mp3c](https://github.com/tytydraco/mp3c) implementation written in Dart.

# Details

Convert audio, images, text, and videos for specific portable media players. Profiles were meticulously
reverse-engineered for optimal
conversion. [List of profiles are available through this spreadsheet](https://github.com/tytydraco/mp3c/blob/main/Generic%20MP3%20Player%20Video%20Specification%20Sheet.xlsx).

# Binary paths

Binaries are assumed to be in your `PATH`, but can be overridden on a library-level. These are the defaults:

```
/// Binary path for FFmpeg.
String binPathFfmpeg = 'ffmpeg';

/// Binary path for FFprobe.
String binPathFfprobe = 'ffprobe';

/// Binary path for FFmpeg with YP3 x264 patch.
String binPathFfmpegYp3Patch = 'ffmpeg-yp3-patch';

/// Binary path for Image Magick convert.
String binPathImageMagick = 'convert';

/// Binary path for ebook-convert.
String binPathEbookConvert = 'ebook-convert';

/// Binary path for MP4Box.
String binPathMp4box = 'MP4Box';
```

# YP3

Certain MP3 players using the SmartLink 6806 (SL6806) chipset
require [special x264 patches](https://github.com/tytydraco/x264-yp3-patch) and thus a
special [patched ffmpeg binary](https://github.com/tytydraco/ffmpeg-yp3-patch) for x264 video conversion. Ensure the
ffmpeg binary can be located in your `PATH` named `ffmpeg-yp3-patch`.

# Dependencies

Ensure these dependencies are available through your environment:

- `ffmpeg`
- `ffmpeg-yp3-patch`
- `ffprobe`
- `ebook-convert` (Calibre)
- `convert` (Image Magick)
- `MP4Box` (gpac)

# Usage

```
-h, --[no-]help            Show usage.
-i, --input (mandatory)    Input file.
-o, --output               Output file. Automatic if null.
-c, --converters           Converters to apply.
                           [uid0001, uid0002, uid0003, uid0004, uid0005, uid0007, uid0008, uid0009, uid0010, uid0011, uid0013, uid0014, uid0016, uid0017, uid0018, uid0019]
-m, --mode (mandatory)     Mode of operation.
                           [audio, image, text, video]
```

# Examples

- `mp3cd -i myvideo.mp4 -c uid0001,uid0004 -m video`
- `mp3cd -i myimage.png -c uid0018 -m image -o output.jpg`