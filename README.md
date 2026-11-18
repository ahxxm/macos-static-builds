# macos-static-builds

Static `macos-arm64` builds of:

- mozjpeg `cjpeg`
- jpegli `cjpegli` and `djpegli`
- emacs-nox `emacs` (terminal build, same configure flags as Homebrew core `emacs`)

## Known limits

emacs-nox

- The zip is an install tree (`bin`, `libexec`, `share`), not a single file; `bin/emacs` finds its pdump and lisp relative to itself.
- `emacs` links the macOS system libraries (libxml2, ncurses, zlib) as dylibs under `/usr/lib`.

EXIF preserve

- mozjpeg `cjpeg` copies EXIF markers from JPEG and PNG inputs by default.
- jpegli `cjpegli` does not preserve EXIF. The [issue](https://github.com/google/jpegli/issues/10) states: "Metadata needs to be copied back with another tool."

## See also

[ffmpeg](https://ffmpeg.martin-riedl.de/)
