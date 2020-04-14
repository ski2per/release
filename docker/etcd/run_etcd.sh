etcd --name etcd --initial-advertise-peer-urls http://192.168.99.4:2380 \
  --enable-v2=true \
  --listen-peer-urls http://192.168.99.4:2380 \
  --listen-client-urls http://192.168.99.4:2379,http://127.0.0.1:2379 \
  --advertise-client-urls http://192.168.99.4:2379 \
  --initial-cluster-token whatthefuck \
  --initial-cluster zabbixproxy=http://192.168.99.2:2380,mail=http://192.168.99.3:2380,etcd=http://192.168.99.4:2380 \
  --initial-cluster-state new
