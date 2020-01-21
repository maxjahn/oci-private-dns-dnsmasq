#cloud-config
write_files:
  # create dnsmasq config
  - path: /etc/dnsmasq.conf
    content: |
      server=/${private_domain}/${zone_dns_1}
      server=/${private_domain}/${zone_dns_2}
      cache-size=0
runcmd:
  # Run firewall commands to open DNS (udp/53)
  - firewall-offline-cmd --zone=public --add-port=53/udp
  # install dnsmasq package
  - yum install dnsmasq -y
  # enable dnsmasq process
  - systemctl enable dnsmasq
  # restart dnsmasq process
  - systemctl restart dnsmasq
  # restart firewalld
  - systemctl restart firewalld
