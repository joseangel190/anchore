#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install git wget unrar -y

# INSTALL AGENT
sudo mkdir /opt/myagent && cd /opt/myagent
sudo wget https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz
sudo tar zxvf vsts-agent-linux-x64-*.tar.gz

sudo chmod -R 777 /opt/myagent/
sudo ./config.sh --unattended --url <Organization> --auth pat --token <Personal-Access-Tokens> --pool <Agent-Pool> --agent <Agent> --work /opt/myagent/
sudo ./svc.sh install $USER
sudo  ./svc.sh start
