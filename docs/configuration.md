---
# Documentation: https://wowchemy.com/docs/managing-content/

title: "Configuration & Usage"
linktitle: "Configuration & Usage"
summary: >-
  Learn how to configure `ZeroDNS` and launch it with Docker.

date: 2020-12-31T20:52:10Z

draft: false  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: book  # Do not modify.

tags: [ ZeroTier, CoreDNS, Self Hosted, Docker, ]
categories: [Homelab, ]

weight: 1

links:
- name: Container
  url: https://hub.docker.com/r/jmuchovej/zerodns
  icon_pack: fab
  icon: docker

---

Here, you'll learn how to configure ZeroDNS and launch it with Docker. I
recommend copying the `docker-compose.yml` file below before moving about
with getting things from ZeroTier.

## Getting the Docker container

Note that this container follows the general architecture of LinuxServer
containers. You can read more about those [here][lsio-docs].

{{% code
    lang="yaml"
    name="docker-compose.yml **(recommended)**"
    file="/content/docs/zerodns/examples/docker-compose.yml"
    %}}

{{% code
    lang="bash"
    name="docker.sh"
    file="/content/docs/zerodns/examples/docker.sh"
    %}}

Check the comments in the `docker-compose.yml` file above for details on what
items need to be changed (and how). **This container requires the
`SYS_ADMIN`[^sysadmin] and `NET_ADMIN`[^netadmin] privileges** – to learn more
about what these do, take a look at the linked footnotes.

## Collect the files &amp; tokens for ZeroDNS to work

**In your browser:** Head to [ZeroTier Central][myzt]. We'll need two things:

1. an [Access Token](https://my.zerotier.com/account), and
2. the [Network ID](https://my.zerotier.com/network) (repeat this step for
   each newtork).

**Using your favorite text editor:**

1. Replace `SomeSuperDuperSecretToken` with the Access Token you retrieved from
   [here](https://my.zerotier.com/account).
2. Create a folder for ZeroDNS' configurations to live (e.g. `zerodns`).
3. Create an empty `<network-id>.conf` file within `zerodns` using Network IDs
   you retrieved from [here](https://my.zerotier.com/network).
4. Edit the `docker-compose.yml` (or `docker` command) accordingly, replacing
   environment variable values and DNS choices as you see fit.

## Running ZeroDNS &amp; configuring your local DNS

1. Ensure you have no services using port 53 (the standard DNS port) as we'll
   need this for ZeroDNS to work. You can check using `lsof | grep ":53"`. Any
   services you find using port 53 will need to be stopped/disabled. Check your
   OS's manual/wiki on how to do that.
2. Launch the ZeroDNS container using your typical `docker compose up`
   command(s). If you're unfamiliar with `docker compose`, take a look at
   LinuxServer's docker primer[^docker-primer].
3. In your DNS settings, list `127.0.0.1` as your first entry (so that ZeroDNS)
   receives all outbound traffic and can resolve whatever network/TLD
   combinations your network uses.
4. **Optional:** Reboot your device to clear any network caches that may have
   been made.

{{% callout success %}}
You should now be able to run `ping`, `dig`, `nslookup`, and the like from your
devices (that also run ZeroDNS).
{{% /callout %}}

[^docker-primer]: For a solid primer on Docker, head over to [LinuxServer's Docs][lsio-docs]. Many parameters passed into the containers are all well-described there.
[^netadmin]: The `NET_ADMIN` capability allows ZeroDNS to _create `/dev/net/tun`_ and _bind to privileged ports_ (ports < 1024). This lets ZeroDNS work as your DNS server since port 53 is the expected listener for DNS queries.
[^sysadmin]: The `SYS_ADMIN` essentially allows eroDNS to _create `/dev/net/tun`_ and _bind to privileged ports_ (ports < 1024). This lets ZeroDNS work as your DNS server since port 53 is the expected listener for DNS queries.

[lsio-docs]: https://docs.linuxserver.io/general/
[myzt]: https://my.zerotier.com/account/
