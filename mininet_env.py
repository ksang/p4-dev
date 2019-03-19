#!/usr/bin/env python2
from mininet.net import Mininet
from mininet.topo import Topo
from mininet.log import setLogLevel, info
from mininet.cli import CLI

from p4_mininet import P4Switch, P4Host

import argparse
from time import sleep

parser = argparse.ArgumentParser(description='Mininet environment for p4-dev')
parser.add_argument('--behavioral-exe', help='Path to behavioral executable',
                    type=str, action="store", required=True)
parser.add_argument('--thrift-port', help='Thrift server port for table updates',
                    type=int, action="store", default=9090)
parser.add_argument('--num-hosts', help='Number of hosts to connect to switch',
                    type=int, action="store", default=2)
parser.add_argument('--mode', choices=['l2', 'l3'], type=str, default='l3')
parser.add_argument('--topo', choices=['4nodes'], type=str, default='4nodes')
parser.add_argument('--json', help='Path to JSON config file',
                    type=str, action="store", required=True)
parser.add_argument('--pcap-dump', help='Dump packets on interfaces to pcap files',
                    type=str, action="store", required=False, default=False)

args = parser.parse_args()


class SingleSwitchTopo(Topo):
    "Single switch connected to n (< 256) hosts."
    def __init__(self, sw_path, json_path, thrift_port, pcap_dump, n, **opts):
        # Initialize topology and default options
        Topo.__init__(self, **opts)

        switch = self.addSwitch('s1',
                                sw_path = sw_path,
                                json_path = json_path,
                                thrift_port = thrift_port,
                                pcap_dump = pcap_dump)

        for h in xrange(n):
            host = self.addHost('h%d' % (h + 1),
                                ip = "10.0.%d.10/24" % h,
                                mac = '00:04:00:00:00:%02x' %h)
            self.addLink(host, switch)

class FourNodesTopo(Topo):
    "4 nodes topo with 4 hosts connected to each."
    def __init__(self, sw_path, json_path, thrift_port, pcap_dump, **opts):
        # Initialize topology and default options
        Topo.__init__(self, **opts)
        for i in xrange(1, 5):
            sw = self.addSwitch('R'+str(i),
                                    sw_path = sw_path,
                                    json_path = json_path,
                                    thrift_port = thrift_port+i,
                                    pcap_dump = pcap_dump)
            h = self.addHost('h'+str(i),
                                ip = "10.0.%d.10/24" % i,
                                mac = '00:04:00:00:00:%02x' %i)
            self.addLink(sw, h)
        # Add links between switches
        self.addLink("R1", "R2")
        self.addLink("R1", "R3")
        self.addLink("R1", "R4")
        self.addLink("R2", "R4")
        self.addLink("R3", "R4")

    def host_net_config(self, net):
        for n in xrange(1, 5):
            h = net.get('h%d' % n)
            h.setARP("10.0.%d.1" % n, "00:aa:bb:00:00:%02x" % n )
            h.setDefaultRoute("dev eth0 via %s" % ("10.0.%d.1" % n))

    def describe(self, net):
        for n in xrange(1, 5):
            h = net.get('h%d' % n)
            h.describe()
        for n in xrange(1, 5):
            r = net.get('R%d' % n)
            r.describe()

def main():
    num_hosts = args.num_hosts
    mode = args.mode

    if args.topo == '4nodes':
        topo = FourNodesTopo(args.behavioral_exe,
                                args.json,
                                args.thrift_port,
                                args.pcap_dump)
    net = Mininet(topo = topo,
                  host = P4Host,
                  switch = P4Switch,
                  controller = None)
    net.start()
    topo.host_net_config(net)
    topo.describe(net)
    sleep(1)

    print "Ready !"

    CLI( net )
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )
    main()
