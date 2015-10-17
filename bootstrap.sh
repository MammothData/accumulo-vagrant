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

echo "Setting up environment"

cat >> //etc/profile.d/dev.sh <<EOF
export JAVA_HOME=/usr/jdk64/jdk1.8.0_40
export HADOOP_HOME=/usr/lib/hadoop
export ZOOKEEPER_HOME=/usr/lib/zookeeper
export PATH=$PATH:/usr/lib/accumulo/bin:$JAVA_HOME/bin
EOF
export JAVA_HOME=/usr/jdk64/jdk1.8.0_40
export HADOOP_HOME=/usr/lib/hadoop
export ZOOKEEPER_HOME=/usr/lib/zookeeper
export PATH=$PATH:/usr/lib/accumulo/bin:$JAVA_HOME/bin


echo "Installing Accumulo"

curl -O -L -s http://mirrors.koehn.com/apache/accumulo/1.7.0/accumulo-1.7.0-bin.tar.gz
tar xvzf accumulo-1.7.0-bin.tar.gz
sudo mv accumulo-1.7.0 /usr/lib/accumulo
sudo chown -R root:root /usr/lib/accumulo

echo "Configuring Accumulo"
cp /usr/lib/accumulo/conf/examples/1GB/standalone/* /usr/lib/accumulo/conf/
cat > /usr/lib/accumulo/conf/masters <<EOF
ambari
EOF
cat > /usr/lib/accumulo/conf/slaves <<EOF
ambari
EOF
cat > /usr/lib/accumulo/conf/monitor <<EOF
ambari
EOF
cat > /usr/lib/accumulo/conf/tracers <<EOF
ambari
EOF
cat > /usr/lib/accumulo/conf/gc <<EOF
ambari
EOF


sed -i 's/<!-- HDP 2.0 requirements --><!--/<!-- HDP 2.0 requirements -->/' /usr/lib/accumulo/conf/accumulo-site.xml
sed -i 's/--><!-- End HDP 2.0 requirements -->/<!-- End HDP 2.0 requirements -->/' /usr/lib/accumulo/conf/accumulo-site.xml

