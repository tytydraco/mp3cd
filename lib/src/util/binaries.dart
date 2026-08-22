import 'dart:io';

/// Run a process.
Future<ProcessResult> run(String executable, List<String> args) =>
    Process.run(executable, args);

/// FFmpeg.
Future<ProcessResult> ffmpeg(List<String> args) => run('ffmpeg', args);

/// FFprobe.
Future<ProcessResult> ffprobe(List<String> args) => run('ffprobe', args);

/// FFmpeg with YP3 x264 patch.
Future<ProcessResult> ffmpegYp3Patch(List<String> args) =>
    run('ffmpeg-yp3-patch', args);

/// Image Magick convert.
Future<ProcessResult> imageMagick(List<String> args) => run('convert', args);

/// Calibre ebook-convert.
Future<ProcessResult> ebookConvert(List<String> args) =>
    run('ebook-convert', args);

/// MP4Box.
Future<ProcessResult> mp4Box(List<String> args) => run('MP4Box', args);
