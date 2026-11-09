# macos-static-builds

Static `macos-arm64` builds of:

- mozjpeg `cjpeg`
- jpegli `cjpegli` and `djpegli`

## Known limits

EXIF preserve

- mozjpeg `cjpeg` copies EXIF markers from JPEG and PNG inputs by default.
- jpegli `cjpegli` does not preserve EXIF. The [issue](https://github.com/google/jpegli/issues/10) states: "Metadata needs to be copied back with another tool."
