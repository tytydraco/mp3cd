FROM archlinux:latest
WORKDIR /root

RUN pacman-key --init
RUN pacman -Syu --noconfirm --disable-sandbox-syscalls --disable-sandbox-filesystem \
    dart \
    ffmpeg \
    gpac \
    calibre \
    imagemagick

RUN curl -Lo '/usr/local/bin/ffmpeg-yp3-patch' 'https://github.com/tytydraco/static-ffmpeg-yp3-patch/releases/latest/download/ffmpeg-amd64'
RUN chmod +x '/usr/local/bin/ffmpeg-yp3-patch'

RUN dart pub global activate mp3cd
ENV PATH="$PATH:/root/.pub-cache/bin"

RUN mkdir '/root/working'

CMD ["/usr/bin/env", "bash", "-i"]