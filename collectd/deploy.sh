#!/bin/bash

# Install and configure the collectd to push some
# system metrics into the RIEMANN

set -eu
set -o pipefail

sys_config () {
    cat <<"EOF"
LoadPlugin cpu
LoadPlugin df
LoadPlugin load
LoadPlugin memory
LoadPlugin processes
LoadPlugin swap

LoadPlugin aggregation

<Plugin "aggregation">
    <Aggregation>
        Plugin "cpu"
        Type "cpu"

        SetPlugin "cpu"
        SetPluginInstance "%{aggregation}"

        GroupBy "Host"
        GroupBy "TypeInstance"

        CalculateNum false
        CalculateSum false
        CalculateAverage true
        CalculateMinimum false
        CalculateMaximum false
        CalculateStddev false
    </Aggregation>
</Plugin>
EOF
}


interface_config () {
    cat <<EOF
<Plugin "interface">
  Interface "lo"
  Interface "sit0"
  IgnoreSelected true
</Plugin>
EOF
}


riemann_write_config () {
    local riemann_server="$1"

    cat <<EOF
LoadPlugin write_riemann

<Plugin "write_riemann">
    <Node "local">
        Host "${riemann_server}"
        Port "5555"
        Protocol TCP
        StoreRates true
        AlwaysAppendDS false
    </Node>
    Tag "collectd"
</Plugin>

<Target "write">
    Plugin "write_riemann/local"
</Target>
EOF
}


yum install collectd collectd-write_riemann

setsebool -P collectd_tcp_network_connect 1

sys_config >/etc/collectd.d/sys.conf
interface_config >/etc/collectd.d/interface.conf
riemann_write_config "${1:-localhost}" >/etc/collectd.d/riemann.conf

systemctl enable collectd
systemctl restart collectd
