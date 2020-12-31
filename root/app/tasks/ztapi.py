#!/usr/bin/env python
"""Query ZeroTier is a script that accesses the ZeroTier API to determine network peers
of a given network, then updates /etc/hosts to allow for human-like name access.

(c) Copyright 2020 John Muchovej
"""

import os
import json

import requests
from jinja2 import Template
from word2number import w2n


def get(postfix: str, token: str):
    ZT = "https://my.zerotier.com/api"
    headers = {
        "Authorization": f"bearer {token}",
    }
    try:
        response = requests.get(f"{ZT}/{postfix}", headers=headers)
        response.raise_for_status()
    except requests.execptions.HTTPError as e:
        raise SystemExit(e)

    return json.loads(response.content.decode("utf-8"))


def get_network(lookup: str, token: str):
    networks = get("network", token)

    by_nm = next(filter(lambda x: x["config"]["name"] == lookup, networks), None)
    by_id = next(filter(lambda x: x["config"]["id"] == lookup, networks), None)
    try:
        assert by_nm != by_id
    except AssertionError:
        raise ValueError(f"`{lookup}` was either not present in networks OR `{lookup}` is both the network name and network ID.")
    return by_nm or by_id


def get_clients(network_name: str, token: str):
    network = get_network(network_name, token)
    zt_id = network["config"]["id"]

    members = get(f"network/{zt_id}/member", token)

    host = Template("{{ ip }}    {{ name }}")
    hosts = []
    for member in members:
        name = member["name"]
        for ip in member["config"]["ipAssignments"]:
            hosts.append({
                "ip": ip,
                "aliases": abbr(name),
            })

    return hosts


def abbr(hostname: str):
    split = hostname.split("-")
    alias = ""

    for s in split:
        try:
            alias += str(w2n.word_to_num(s))
        except ValueError:
            alias += s[0]

    return [hostname, alias]
