# Accumulo (+ Ambari) on Vagrant

This project helps to set up a 1 node Accumulo cluster on Vagrant.

## Requirements

You need [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/)

Once installed, you can pre-fetch the referenced Centos 6.5 image:
```
vagrant box add centos65-x86_64-20140116 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box
```


## Initialize the single node cluster

```
git clone git@github.com:MammothData/accumulo-vagrant.git
cd accumulo-vagrant
vagrant up
```

## Kicking the tires

```
#Log into Ambari (username:password admin:admin) and start up the Hadoop cluster
192.168.64.101:8080

#Once its running, log in as root and start Accumulo
vagrant ssh
sudo su
start-all.sh #this accumulo start script is in your path

accumulo shell -u root
```

## When things go wrong

### Things you might see:

"message" : "Attempted to add unknown hosts to a cluster.  These hosts have not been registered with the server: ambari"

```
AMBARI_URL=192.168.64.101:8080

#Check which hosts are registered:
curl -Hs "X-Requested-By: ambari" -u admin:admin -i http://$AMBARI_URL/api/v1/hosts

#Delete the blueprint config:
curl -H "X-Requested-By: ambari" -X DELETE -u admin:admin http://$AMBARI_URL/api/v1/blueprints/single-node-hdfs-yarn

#Delete the Ambari cluster:
curl -H "X-Requested-By: ambari" -X DELETE -u admin:admin http://$AMBARI_URL/api/v1/clusters/MySingleNodeCluster
```

## References

This project was derived from the SequenceIQ [ambari-vagrant](https://github.com/sequenceiq/ambari-vagrant) project, which in-turn was derived from the Apache Ambari [Quick Start Guide](https://cwiki.apache.org/confluence/display/AMBARI/Quick+Start+Guide) and modified.

