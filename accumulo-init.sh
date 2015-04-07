echo "--- RUNNING ACCUMULO INIT----"

sudo su hdfs <<'EOF'
hadoop fs -mkdir /accumulo
hadoop fs -chown root:root /accumulo
hadoop fs -mkdir /user/root
hadoop fs -chown root:root /user/root
EOF


/usr/lib/accumulo/bin/accumulo init --clear-instance-name <<'EOF'
dev
dev
dev
EOF