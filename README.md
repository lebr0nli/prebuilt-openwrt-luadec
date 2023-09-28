## Prebuilt OpenWRT luadec

Dockerized luadec for OpenWRT & prebuilt image.

Currently only support Lua 5.1.5.

Please note that there may be issues with decompiling complicated bytecode, and it is unclear whether this is a bug in luadec or not.

## Usage

### Pull the image

```bash
docker pull lebr0nli/openwrt-luadec
```

### Run

```bash
# Use luadec
alias luadec='docker run -v $(pwd):/work --rm -it openwrt-luadec'
luadec ./path/to/xxx.lua

# You can also use lua/luac if you want
## Use luac
alias luac='docker run -v $(pwd):/work --rm -it --entrypoint=/usr/local/bin/luac openwrt-luadec'
luac -l ./path/to/xxx.lua
## Use lua
alias lua='docker run -v $(pwd):/work --rm -it --entrypoint=/usr/local/bin/lua openwrt-luadec'
lua ./path/to/xxx.lua
```

## Build locally

```bash
docker build -t openwrt-luadec .
```

## Credits

- [viruscamp/luadec](https://github.com/viruscamp/luadec)
- https://vovohelo.medium.com/unscrambling-lua-7bccb3d5660
- https://blog.ihipop.com/2018/05/5110.html

## TODO

- [ ] Support more Lua versions
