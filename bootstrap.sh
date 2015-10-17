#!/usr/bin/env bash

echo "--- RUNNING BOOTSTRAP ----"

cp /vagrant/hosts /etc/hosts
cp /vagrant/resolv.conf /etc/resolv.conf
yum install ntp -y
service ntpd start
service iptables stop

yum install jq -y

echo "Installing Ambari"

[ -f /etc/yum.repos.d/ambari.repo ] || curl -Lso /etc/yum.repos.d/ambari.repo http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.1.2/ambari.repo
yum install ambari-server -y
ambari-server setup -s
ambari-server start

yum install ambari-agent -y
sed -i.bak "/^hostname/ s/.*/hostname=ambari/" /etc/ambari-agent/conf/ambari-agent.ini
ambari-agent start

AMBARI_URL=192.168.64.101:8080
a=$(curl -s -H "X-Requested-By: ambari" -u admin:admin  http://$AMBARI_URL/api/v1/hosts | jq '.items[0].Hosts.host_name' | grep ambari | wc -l)
while [ $a -lt 1 ]
do
echo $a "Waiting for ambari-agent to register..."
a=$(curl -s -H "X-Requested-By: ambari" -u admin:admin  http://$AMBARI_URL/api/v1/hosts | jq '.items[0].Hosts.host_name' | grep ambari | wc -l)
sleep 2
done
