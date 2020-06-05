#!/bin/bash


######################
# apt update##########
######################

sudo apt-get update
sudo apt-get -y upgrade

cd ~
mkdir tmp

sleep 1

######################
#Install Latest Go####
######################

if [[ -z ${GOPATH} ]];
then
    echo Installing go:
    cd ~/tmp
    wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.13.*linux-amd64.tar.gz
else
    echo Uninstalling previous go!:
    sudo apt-get uninstall golang
    cd ~/tmp
    wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.13.*linux-amd64.tar.gz
fi

sleep 1

##########################
##Configuring Enviroment##
#####################h#####

echo configuring environements!
sudo chmod +w /etc/environment
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
echo configuration successed! For further information please refer to https://github.com/kuny1240/Insight_Project


######################
#Install Prometheus###
######################
echo Installing prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo chown prometheus:prometheus /etc/prometheus
sudo chown prometheus:prometheus /var/lib/prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.15.2/prometheus-2.15.2.linux-amd64.tar.gz
tar xzf prometheus-2.15.2.linux-amd64.tar.gz
sudo cp prometheus-2.15.2.linux-amd64/{prometheus,promtool} /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
sudo cp -r prometheus-2.15.2.linux-amd64/{consoles,console_libraries} /etc/prometheus/
sudo cp prometheus-2.15.2.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml
sleep 10


#######################
##Install AlertManager#
#######################

cd ~/tmp
wget https://github.com/prometheus/alertmanager/releases/download/v0.20.0/alertmanager-0.20.0.linux-amd64.tar.gz
tar -xvzf alertmanager-*.linux-amd64.tar.gz
sudo mv alertmanager-*.linux-amd64/alertmanager /usr/local/bin/
sudo mkdir /etc/alertmanager/

#######################
####Install Grafana####
#######################

echo installing grafana!
sudo apt-get install -y gnupg2 curl
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt-get -y update
sudo apt-get -y install grafana
echo installation ended!

sleep 1

###########################
###Install rds_exporter####
###########################

echo installing rds_exporter for prometheus:
cd ~
mkdir go
cd go
go get github.com/percona/rds_exporter
cd ~/go/src/github.com/percona/rds_exporter
sudo apt-get -y install make
sleep 10
make build
sudo mv rds_exporter /usr/local/bin/
sudo mkdir /etc/rds_exporter/
echo installation success!
sleep 1


###################################
####Install cloudwatch_exporter####
###################################


cd ~/tmp
git clone https://github.com/prometheus/cloudwatch_exporter.git
cd cloudwatch_exporter
sudo apt-get -y install default-jdk
sudo apt-get -y install maven
mvn package
sudo mkdir /etc/cloudwatch_exporter
sudo mv ./target /usr/local/bin/