#!/bin/bash
if [[ $# -ne 2 ]]; then
	echo "Usage: $0 register_name machine_ip"
else
	FILE_NAME=$1
	MACHINE_IP=$2
	NAMED_CONFIG=/etc/named.conf
	
	# ADD A ZONE LINE TO THE $NAMED_CONFIG
	echo "[+] Adding zone to $NAMED_CONFIG"
	echo "zone \"$FILE_NAME\" { type master; file \"/etc/bind/zones/db.$FILE_NAME\"; };" >> $NAMED_CONFIG
	
	# GENERATE THE ZONE FILE
	echo "[+] Add file "
	echo """
\$TTL    604800
@       IN      SOA     ns1.local.com. admin.local.com. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                        604800 )       ; Negative Cache TTL
;
; name servers - NS records
     IN      NS      ns1.local.com.

; name servers - A records
$FILE_NAME.               	 IN      A	$MACHINE_IP

""" > /etc/bind/zones/db.$FILE_NAME

	echo "[=] Restarting service..."
	systemctl restart named
	echo "[=] Done!"
fi
