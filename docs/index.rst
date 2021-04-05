=======
ZeroDNS
=======

.. https://github.com/zyclonite/zerotier-docker

.. https://github.com/jmuchovej/zerodns/workflows/Compile%20Release%20into%20Container/badge.svg

.. .. image:: https://github.com/jmuchovej/zerodns/workflows/Compile%20Release%20into%20Container/badge.svg
   :target: https://github.com/jmuchovej/zerodns
   :alt: Automated Release Patching


``ZeroDNS`` is a CoreDNS-based Docker container that allows for name resolution
of your ZeroTier_ peers.
You should point your local machine's DNS to ``localhost`` (127.0.0.1) to
enable this mapping.

Configuration
=============

#. Create a config directory for ZeroDNS.
#. For each network you want, create an empty ``<network-id>.conf`` file in the
   above directory.

Usage
=====

As a Docker container, you can easily start the container with
``docker-compose`` (recommended) or with ``docker``.

``docker-compose.yml``
----------------------

.. literalinclude:: ../docs/docker-compose.yml
   :language: yaml
   :linenos:

``docker``
----------------------

.. literalinclude:: ../docs/docker.sh
   :language: bash
   :linenos:


Appendix
========

Generating an ``ACCESS_TOKEN``
------------------------------

#. Head over to `My Account <my-account_>`_ on ZeroTier
#. Find the "API Access Tokens" section
#. Create a "New Token"

**NOTE:** `Don't store this in a publicly accessible folder/repository`.
It gives wide-ranging privileges to your ZeroTier account.

**NOTE.1:** If ZeroTier implements a read-only token in the future, you can
prevent ZeroDNS from writing anything by using a read-only token. `This should
not cause any erroneous behavior from ZeroDNS.`


Why does ``ZeroDNS`` need an ``ACCESS_TOKEN``?
----------------------------------------------

We use your `access_token` to query your ZeroTier networks by ID or Name. The entire "API" is read-only, and you can validate that by looking at [tasks/ztapi.py](root/app/tasks/ztapi.py).


Current Limitations
===================

1. Doesn't play nicely with VPNs (tested on Mullvad, Proton, TunnelBear, PIA)

.. https://ragingtiger.github.io/2020/01/03/docker-local-dns
.. https://github.com/coredns/deployment/blob/aba0245/docker/dns.yml

.. _ZeroTier: https://zerotier.com
.. _my-account: https://my.zerotier.com/account
