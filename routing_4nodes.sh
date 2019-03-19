#!/bin/bash
R1_commands=$(cat <<-END
table_set_default send_frame _drop
table_set_default forward _drop
table_set_default ipv4_lpm _drop
table_add send_frame rewrite_mac 1 => 00:aa:bb:00:00:01
table_add send_frame rewrite_mac 2 => 00:aa:bb:00:12:01
table_add send_frame rewrite_mac 3 => 00:aa:bb:00:13:01
table_add send_frame rewrite_mac 4 => 00:aa:bb:00:14:01
table_add forward set_dmac 10.0.1.10 => 00:04:00:00:00:01
table_add forward set_dmac 192.168.12.2 => 00:aa:bb:00:12:02
table_add forward set_dmac 192.168.13.3 => 00:aa:bb:00:13:03
table_add forward set_dmac 192.168.14.4 => 00:aa:bb:00:14:04
table_add ipv4_lpm set_nhop 10.0.1.10/32 => 10.0.1.10 1
table_add ipv4_lpm set_nhop 10.0.2.10/32 => 192.168.12.2 2
table_add ipv4_lpm set_nhop 10.0.3.10/32 => 192.168.13.3 3
table_add ipv4_lpm set_nhop 10.0.4.10/32 => 192.168.14.4 4
END
)

R2_commands=$(cat <<-END
table_set_default send_frame _drop
table_set_default forward _drop
table_set_default ipv4_lpm _drop
table_add send_frame rewrite_mac 1 => 00:aa:bb:00:00:02
table_add send_frame rewrite_mac 2 => 00:aa:bb:00:12:02
table_add send_frame rewrite_mac 3 => 00:aa:bb:00:24:02
table_add forward set_dmac 10.0.2.10 => 00:04:00:00:00:02
table_add forward set_dmac 192.168.12.1 => 00:aa:bb:00:12:01
table_add forward set_dmac 192.168.24.4 => 00:aa:bb:00:24:04
table_add ipv4_lpm set_nhop 10.0.2.10/32 => 10.0.2.10 1
table_add ipv4_lpm set_nhop 10.0.1.10/32 => 192.168.12.1 2
table_add ipv4_lpm set_nhop 10.0.3.10/32 => 192.168.12.1 2
table_add ipv4_lpm set_nhop 10.0.4.10/32 => 192.168.24.4 3
END
)

R3_commands=$(cat <<-END
table_set_default send_frame _drop
table_set_default forward _drop
table_set_default ipv4_lpm _drop
table_add send_frame rewrite_mac 1 => 00:aa:bb:00:00:03
table_add send_frame rewrite_mac 2 => 00:aa:bb:00:13:03
table_add send_frame rewrite_mac 3 => 00:aa:bb:00:34:03
table_add forward set_dmac 10.0.3.10 => 00:04:00:00:00:03
table_add forward set_dmac 192.168.13.1 => 00:aa:bb:00:13:01
table_add forward set_dmac 192.168.34.4 => 00:aa:bb:00:34:04
table_add ipv4_lpm set_nhop 10.0.3.10/32 => 10.0.3.10 1
table_add ipv4_lpm set_nhop 10.0.1.10/32 => 192.168.13.1 2
table_add ipv4_lpm set_nhop 10.0.2.10/32 => 192.168.13.1 2
table_add ipv4_lpm set_nhop 10.0.4.10/32 => 192.168.34.4 3
END
)

R4_commands=$(cat <<-END
table_set_default send_frame _drop
table_set_default forward _drop
table_set_default ipv4_lpm _drop
table_add send_frame rewrite_mac 1 => 00:aa:bb:00:00:04
table_add send_frame rewrite_mac 2 => 00:aa:bb:00:14:04
table_add send_frame rewrite_mac 3 => 00:aa:bb:00:24:04
table_add send_frame rewrite_mac 4 => 00:aa:bb:00:34:04
table_add forward set_dmac 10.0.4.10 => 00:04:00:00:00:04
table_add forward set_dmac 192.168.14.1 => 00:aa:bb:00:14:01
table_add forward set_dmac 192.168.24.2 => 00:aa:bb:00:24:02
table_add forward set_dmac 192.168.34.3 => 00:aa:bb:00:34:03
table_add ipv4_lpm set_nhop 10.0.4.10/32 => 10.0.4.10 1
table_add ipv4_lpm set_nhop 10.0.1.10/32 => 192.168.14.1 2
table_add ipv4_lpm set_nhop 10.0.2.10/32 => 192.168.24.2 3
table_add ipv4_lpm set_nhop 10.0.3.10/32 => 192.168.34.3 4
END
)
echo "R1 commands injection:"
/home/vagrant/p4lang/bin/simple_router/runtime_CLI --thrift-port 9091 <<< "${R1_commands}"

echo "R2 commands injection:"
/home/vagrant/p4lang/bin/simple_router/runtime_CLI --thrift-port 9092 <<< "${R2_commands}"

echo "R3 commands injection:"
/home/vagrant/p4lang/bin/simple_router/runtime_CLI --thrift-port 9093 <<< "${R3_commands}"

echo "R4 commands injection:"
/home/vagrant/p4lang/bin/simple_router/runtime_CLI --thrift-port 9094 <<< "${R4_commands}"
