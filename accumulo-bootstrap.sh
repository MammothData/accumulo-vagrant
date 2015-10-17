echo "Setting up environment"

cat >> //etc/profile.d/dev.sh <<EOF
export JAVA_HOME=/usr/jdk64/jdk1.8.0_40
export HADOOP_HOME=/usr/hdp/current/hadoop-client
export ZOOKEEPER_HOME=/usr/hdp/current/zookeeper-client
export PATH=$PATH:/usr/lib/accumulo/bin:$JAVA_HOME/bin
EOF
export JAVA_HOME=/usr/jdk64/jdk1.8.0_40
export HADOOP_HOME=/usr/hdp/current/hadoop-client
export ZOOKEEPER_HOME=/usr/hdp/current/zookeeper-client
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

sed -i 's/<!-- HDP 2.2 requirements --><!--/<!-- HDP 2.2 requirements -->/' /usr/lib/accumulo/conf/accumulo-site.xml
sed -i 's/--><!-- End HDP 2.2 requirements -->/<!-- End HDP 2.2 requirements -->/' /usr/lib/accumulo/conf/accumulo-site.xml

sed -i 's/>secret</>dev</' /usr/lib/accumulo/conf/accumulo-site.xml