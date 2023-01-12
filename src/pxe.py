#!/usr/bin/env python3

from scapy.all import *
from scapy.base_classes import Net

conf.verbose = 0
conf.iface   = 'guest-bridge'


class PXE(AnsweringMachine):
  iface_ip = get_if_addr(conf.iface)
  ports = ' || '.join(
    str(port) for port in
    [67, 68, 69, 80, 135, 137, 138, 139, 389, 443, 4011, 5040]
  )

  filter = f'( arp or tcp or udp ) and port ( {ports} ) and !( src host {get_if_addr( conf.iface )} )'
  sniff_options = {"store": 0, "iface": conf.iface }
  #send_options = {"verbose": 0}  # type: Dict[str, Any]
  #send_options_list = ["iface", "inter", "loop", "verbose", "socket"]
  send_function = staticmethod(sendp)


  def is_request(self, pkt):
    return pkt.haslayer(IP)

  def make_reply(self, pkt):
    pkt.summary()
    return IP()

  def dhcp(self, pkt):
    pass

  def tftp(self, pkt):
    pass

  def http(self, pkt):
    pass


if __name__ == "__main__":
  PXE( )( )


"""
NOTES:
  - C:  https://github.com/Oline/bootpxe
  - Go: https://github.com/DSpeichert/netbootd
  - Go: https://github.com/DongJeremy/pxesrv
  - Go: https://github.com/p3lim/pixie
"""
