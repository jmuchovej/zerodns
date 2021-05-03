from typing import Union
import io
import re
import subprocess
import shlex
import functools
from pathlib import Path
from collections import defaultdict

import pandas as pd
from word2number import w2n


shell = functools.partial(subprocess.Popen, stdout=subprocess.PIPE)


def ztc_get_networks(network: str) -> str:
    cmd = shlex.split(f"ztc network:get {network} --columns=name --no-header")
    with shell(cmd) as proc:
        return proc.stdout.read().decode("utf-8").strip()


def ztc_to_host(network: str, tld: str) -> pd.DataFrame:
    cmd = shlex.split(f"ztc member:list {network} --csv --filter=Authorized=true")
    with shell(cmd) as proc:
        members = io.StringIO(proc.stdout.read().decode("utf-8"))

    df = pd.read_csv(members)
    df = df[df["Authorized"]]
    df = df[["IP-Assignments", "Node-ID", "Name"]]
    df["Network"] = network
    df["TLD"] = tld

    df = df.rename(columns={"IP-Assignments": "IP", "Node-ID": "Node"})

    hosts = defaultdict(list)
    for idx, row in df.iterrows():
        aliases = host_abbr(f"{row.Name}.{row.TLD}")
        aliases += [row.Name, row.Node, f"{row.Node}.{row.Network}"]
        hosts[row.IP] += aliases

    return hosts


def add_host(ip: str, aliases: list) -> str:
    assert type(aliases) == list
    return f"{ip.strip():15s}  {' '.join(aliases)}\n"


def member_to_host(row) -> list:
    aliases = host_abbr(f"{row.Name}.{row.TLD}")
    aliases += [row.Name, row.Node, f"{row.Node}.{row.Network}"]
    return add_host(row.IP, aliases)


def host_abbr(hostname: str):
    split = re.split(r" |-", hostname.split(".")[0])
    alias = ""

    for s in split:
        try:
            alias += str(w2n.word_to_num(s))
        except ValueError:
            alias += s[0]

    tld = ".".join(hostname.split(".")[1:])
    return [str(hostname), f"{alias}.{tld}"]

