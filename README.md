# epoch

Convert between Unix timestamps and human-readable dates, without opening a browser tab. The unit (seconds, ms, µs, ns) is auto-detected from the number's size.

![macOS 13+](https://img.shields.io/badge/macOS-13%2B-blue)
![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange)
![License](https://img.shields.io/badge/license-MIT-green)

```console
$ epoch 1719630000
Interpreted as: seconds (s)
Unix (s):   1719630000
Unix (ms):  1719630000000
ISO 8601:   2024-06-29T03:00:00Z
Local:      2024-06-29 12:00:00 GMT+9
Relative:   2 years ago

$ epoch 2024-06-29T03:00:00Z
Unix (s):   1719630000
...
```

## Why

You paste a timestamp from a log into a converter website ten times a day. `epoch 1719630000` is faster, works offline, and goes both directions.

## Install

### Homebrew

```sh
brew install shint-mcguff/tap/epoch
```

### From source

```sh
git clone https://github.com/shint-mcguff/epoch
cd epoch
swift build -c release
cp .build/release/epoch /usr/local/bin/
```

## Usage

```sh
epoch                       # the current time, every which way
epoch 1719630000            # a timestamp → date (unit auto-detected)
epoch 1719630000000         # 13 digits → detected as milliseconds
epoch 2024-06-29T03:00:00Z  # a date → timestamp
epoch 2024-06-29            # a bare date (interpreted in your local time zone)
epoch --ms 1719630000       # force the input unit
epoch -r 1719630000         # raw: print only the converted value (for scripts)
```

- **Auto-detection:** a 10-digit number is read as seconds, 13 as milliseconds, 16 as microseconds, 19 as nanoseconds. Override with `--s` / `--ms` / `--us` / `--ns`.
- **`--raw`:** prints just the ISO date (for epoch input) or just the Unix seconds (for date input), so you can pipe it: `mtime=$(epoch -r "$logline")`.
- Date strings accept ISO 8601 (with or without fractional seconds / zone) and plain `yyyy-MM-dd[ HH:mm[:ss]]` forms.

## License

MIT — see [LICENSE](LICENSE).
