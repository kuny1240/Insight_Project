#!/bin/bash


# Move all config files to the right place
cd ~
sudo mv configures/config.yml /etc/rds_exporter/
sudo mv configures/cloudwatch_exporter.yml /etc/cloudwatch_exporter/
sudo mv configures/alertmanager.yml /etc/alertmanager/
sudo mv configures/alert_rules.yml /etc/prometheus/


# Move all services to the right place
cd ~
sudo mv configures/cloudwatch_exporter.service /etc/systemd/system/
sudo mv configures/rds_exporter.service /etc/systemd/system/
sudo mv configures/alertmanager.service /etc/systemd/system/


