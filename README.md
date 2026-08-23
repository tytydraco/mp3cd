# mp3cd

[Mp3c](https://github.com/tytydraco/mp3c) implementation written in Dart.

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