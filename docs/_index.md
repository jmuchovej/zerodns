---
# Documentation: https://wowchemy.com/docs/managing-content/

title: "ZeroDNS Documentation"
linktitle: "ZeroDNS"
summary: >-
  A ZeroTier-DNS to allow for human-readable names of ZeroTier peers.

date: 2020-12-31T20:52:10Z
lastmod: 2020-12-31T20:52:10Z

draft: false  # Is this a draft? true/false
toc: true  # Show table of contents? true/false
type: book  # Do not modify.

project: [zerodns, ]

tags: [ ZeroTier, CoreDNS, Self Hosted, Docker, ]
categories: [Homelab, ]

# Add menu entry to sidebar.
# - Substitute `example` with the name of your course/documentation folder.
# - name: Declare this menu item as a parent with ID `name`.
# - parent: Reference a parent ID if this page is a child.
# - weight: Position of link in menu.
menu:
  docs:
    parent: Global Project Documentation
  zerodns:

---

Check out the project page below for motivations of creating ZeroDNS.

{{< cite page="/project/zerodns" view=3 >}}

## Roadmap

1. Allow for persistent use while Host has a VPN connection.[^vpn]
2. Slim down the container from ~1GB. (This appears largely due to `ztc`.)
3. Refine the added capabilities down from `NET_ADMIN` and `SYS_ADMIN`.

## Contents

{{< list_children >}}

[ztdns]: https://github.com/uxbh/ztdns
[ztapi.py]: https://github.com/ionlights/zerodns/blog/main/root/app/tasks/ztapi.py

[^zthosts]: Which I actually did for a time, even with a `cron` job, but `/etc/hosts` only works for the tools that respect it, `nslookup` just so happens to be one that doesn't.
[^vpn]: As a non-networking whiz, this might take a while, or be a futile effort. For the moment, I'm not super concerned with this use-case, but definitely open an issue if this is a high priority and I'll see what I can do! :smiley: