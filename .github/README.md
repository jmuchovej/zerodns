# Check out [ZeroNS][zerons] from ZeroTier!

This repository has been **archived** and **will not** receive updates because
ZeroTier now builds and supports [**ZeroNS**][zerons], which achieves the same
(or better) results to what ZeroDNS set out to achieve.


**Give it a look if you want hostname-like resolution for your ZeroTier peers!**


[zerons]: https://github.com/zerotier/zeronsd

## ZeroDNS ( :warning: This project has been archived and is unsupported.)

![Docker Builds](https://github.com/ionlights/zerodns/workflows/Docker%20Builds/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/jmuchovej/zerodns)
![GitHub](https://img.shields.io/github/license/jmuchovej/zerodns)


`ZeroDNS` is a CoreDNS-based Docker container that allows for name resolution
of your [ZeroTier][zt] peers.
You should point your local machine's DNS to `localhost` (127.0.0.1) to enable
this mapping.

### Configuration

1. Create a config directory for ZeroDNS.
2. For each network you want, create an empty `<network-id>.conf` file in the
   above directory.
3. Retrieve an `ACCESS_TOKEN` from [ZeroTier Central][myzt]. You'll need to pass
   this as an environment variable to the container.
4. Specify a command-separated list of `TLDS` (defaults to only `.zt`). Like
   `ACCESS_TOKEN`, this will be an environment variable passed to ZeroDNS.

### Usage

The [docs][docs] are fairly thorough in what parameters `docker` needs, but you
can also find those details in the [`docker-compose.yml`][compose] or
[`docker`][docker]. Additionally, if you find any of the Docker-related
configurations confusing, you should take a look at the
[LinuxServer.io Docs][lsio-docs], we draw heavy inspiration from their work.

### Current limitations

1. Doesn't play nicely with VPNs (tested on Mullvad, Proton, TunnelBear, PIA)
2. Needs `SYS_ADMIN` and `NET_ADMIN` capabilities.
3. Will always spawn a ZeroTier One client within ZeroDNS (CoreDNS is required).

[zt]: https://zerotier.com/
[myzt]: https://my.zerotier.com/
[docs]: https://john.muchovej.com/docs/zerodns/configuration/
[docker]: blob/main/docs/examples/docker.sh
[compose]: blob/main/docs/examples/docker-compose.yml
[lsio-docs]: https://docs.linuxserver.io/
