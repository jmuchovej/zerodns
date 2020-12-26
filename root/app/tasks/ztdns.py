import itertools
from typing import Union

from invoke import task
from jinja2 import Template, Environment
from jinja2.loaders import FileSystemLoader

from . import ztapi as zt


@task
def get_config(ctx):
    ctx.j2env = Environment(loader=FileSystemLoader("/app/tasks/templates"))

    if type(ctx.zt.networks) == str:
        ctx.zt.networks = [ctx.zt.networks]

    if type(ctx.zt.tlds) == str:
        ctx.zt.tlds = [ctx.zt.tlds] * len(ctx.zt.networks)

    ctx.zt.domains = list(map(".".join, zip(ctx.zt.networks, ctx.zt.tlds)))
    if "dnses" not in ctx:
        ctx.dnses = ["1.1.1.1", "1.0.0.1", ]


@task(pre=[get_config, ])
def update_coredns(ctx):
    corefile = ctx.j2env.get_template("Corefile.j2")
    with open("/config/Corefile", "w+") as core:
        core.write(corefile.render(
            domains=" ".join(ctx.zt.domains),
            dnses=" ".join(ctx.dnses)
        ))


@task(pre=[get_config, ])
def update_hosts(ctx):
    zt_clients = {
        k: zt.get_clients(netname, ctx.zt.access_token)
        for k, netname in zip(ctx.zt.domains, ctx.zt.networks)
    }

    def line(ip: str, aliases: Union[str, list]) -> str:
        host_line = Template("{{ ip }}  {{ aliases }}")
        aliases = [aliases] if type(aliases) != list else aliases
        ip = f"{ip:15s}"
        return host_line.render(ip=ip, aliases=" ".join(aliases)) + "\n"

    with open("/config/zt.hosts", "w+") as hosts:
        hosts.write(line(ip="127.0.0.1", aliases="localhost"))
        for domain, clients in zt_clients.items():
            for client in clients:
                # TODO support non-domain endings
                client["aliases"] = [[f"{a}.{domain}"] for a in client["aliases"]]
                client["aliases"] = list(itertools.chain(*client["aliases"]))
                hosts.write(line(**client))
