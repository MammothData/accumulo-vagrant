#!/usr/bin/env bash

echo "--- RUNNING BOOTSTRAP ----"

cp /vagrant/hosts /etc/hosts
cp /vagrant/resolv.conf /etc/resolv.conf
yum install ntp -y
service ntpd start
service iptables stop

yum install jq -y

echo "Installing Ambari"

[ -f /etc/yum.repos.d/ambari.repo ] || curl -Lso /etc/yum.repos.d/ambari.repo http://public-repo-1.hortonworks.com/ambari/centos6/1.x/updates/1.6.1/ambari.repo 
yum install ambari-server -y
ambari-server setup -s
ambari-server start

yum install ambari-agent -y
sed -i.bak "/^hostname/ s/.*/hostname=c6401.ambari.apache.org/" /etc/ambari-agent/conf/ambari-agent.ini
ambari-agent start

echo "Setting up environment"

cat >> //etc/profile.d/dev.sh <<EOF
export JAVA_HOME=/usr/jdk64/jdk1.7.0_45
export HADOOP_HOME=/usr/lib/hadoop
export ZOOKEEPER_HOME=/usr/lib/zookeeper
export PATH=$PATH:/usr/lib/accumulo/bin
EOF
export JAVA_HOME=/usr/jdk64/jdk1.7.0_45
export HADOOP_HOME=/usr/lib/hadoop
export ZOOKEEPER_HOME=/usr/lib/zookeeper
export PATH=$PATH:/usr/lib/accumulo/bin


echo "Installing Accumulo"

curl -O -L -s http://www.carfab.com/apachesoftware/accumulo/1.6.1/accumulo-1.6.1-bin.tar.gz
tar xvzf accumulo-1.6.1-bin.tar.gz
sudo mv accumulo-1.6.1 /usr/lib/accumulo
sudo chown -R root:root /usr/lib/accumulo

echo "Configuring Accumulo"
cp /usr/lib/accumulo/conf/examples/1GB/standalone/* /usr/lib/accumulo/conf/
cat > /usr/lib/accumulo/conf/masters <<EOF
c6401.ambari.apache.org
EOF
cat > /usr/lib/accumulo/conf/slaves <<EOF
c6401.ambari.apache.org
EOF
sed -i 's/>secret</>dev</' /usr/lib/accumulo/conf/accumulo-site.xml

