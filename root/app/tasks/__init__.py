from invoke import Collection

from . import ztdns

ns = Collection("ztdns")
ns.add_collection(ztdns)