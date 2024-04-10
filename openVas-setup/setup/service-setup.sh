sudo cat << EOF > /etc/systemd/system/ospd-openvas.service
[Unit]
Description=OSPd Wrapper for the OpenVAS Scanner (ospd-openvas)
Documentation=man:ospd-openvas(8) man:openvas(8)
After=network.target networking.service redis-server@openvas.service mosquitto.service
Wants=redis-server@openvas.service mosquitto.service notus-scanner.service
ConditionKernelCommandLine=!recovery
[Service]
Type=exec
User=gvm
Group=gvm
RuntimeDirectory=ospd
RuntimeDirectoryMode=2775
PIDFile=/run/ospd/ospd-openvas.pid
ExecStart=/usr/local/bin/ospd-openvas --foreground --unix-socket /run/ospd/ospd-openvas.sock --pid-file /run/ospd/ospd-openvas.pid --log-file /var/log/gvm/ospd-openvas.log --lock-file-dir /var/lib/openvas --socket-mode 0o770 --mqtt-broker-address localhost --mqtt-broker-port 1883 --notus-feed-dir /var/lib/notus/advisories
SuccessExitStatus=SIGKILL
Restart=always
RestartSec=60
[Install]
WantedBy=multi-user.target
EOF


sudo cat << EOF > /etc/systemd/system/notus-scanner.service
[Unit]
Description=Notus Scanner
Documentation=https://github.com/greenbone/notus-scanner
After=mosquitto.service
Wants=mosquitto.service
ConditionKernelCommandLine=!recovery
[Service]
Type=exec
User=gvm
RuntimeDirectory=notus-scanner
RuntimeDirectoryMode=2775
PIDFile=/run/notus-scanner/notus-scanner.pid
ExecStart=/usr/local/bin/notus-scanner --foreground --products-directory /var/lib/notus/products --log-file /var/log/gvm/notus-scanner.log
SuccessExitStatus=SIGKILL
Restart=always
RestartSec=60
[Install]
WantedBy=multi-user.target
EOF

sudo cat << EOF > /etc/systemd/system/gvmd.service
[Unit]
Description=Greenbone Vulnerability Manager daemon (gvmd)
After=network.target networking.service postgresql.service ospd-openvas.service
Wants=postgresql.service ospd-openvas.service
Documentation=man:gvmd(8)
ConditionKernelCommandLine=!recovery
[Service]
Type=exec
User=gvm
Group=gvm
PIDFile=/run/gvmd/gvmd.pid
RuntimeDirectory=gvmd
RuntimeDirectoryMode=2775
ExecStart=/usr/local/sbin/gvmd --foreground --osp-vt-update=/run/ospd/ospd-openvas.sock --listen-group=gvm
Restart=always
TimeoutStopSec=10
[Install]
WantedBy=multi-user.target
EOF

sudo cat << EOF > /etc/systemd/system/gsad.service
[Unit]
Description=Greenbone Security Assistant daemon (gsad)
Documentation=man:gsad(8) https://www.greenbone.net
After=network.target gvmd.service
Wants=gvmd.service

[Service]
Type=exec
User=gvm
Group=gvm
RuntimeDirectory=gsad
RuntimeDirectoryMode=2775
PIDFile=/run/gsad/gsad.pid
ExecStart=/usr/local/sbin/gsad --foreground --listen=0.0.0.0 --port=9392 --http-only
Restart=always
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target
Alias=greenbone-security-assistant.service
EOF

sudo systemctl daemon-reload
sudo /usr/local/bin/greenbone-feed-sync
sudo systemctl start notus-scanner
sudo systemctl start ospd-openvas
sudo systemctl start gvmd
sudo systemctl start gsad
sudo systemctl enable notus-scanner
sudo systemctl enable ospd-openvas
sudo systemctl enable gvmd
sudo systemctl enable gsad
sudo systemctl status notus-scanner
sudo systemctl status ospd-openvas
sudo systemctl status gvmd

if sudo systemctl status gsad | grep -q "failed"; then
    sudo apt install git -y
    cd
    git clone https://github.com/greenbone/gsad.git
    cd gsad
    mkdir build && cd build
    cmake ..
    sudo make install
fi
sudo systemctl start gsad
sudo systemctl status gsad


#Now The custom scripts for ssh and web access

echo "Please enter the path where the scripts should be saved\n Entered Path should NOT END WITH / \n recommended: /home/scripts"
read script

#Create path
mkdir -p $script/ssh && echo "scripts are saved in $script"

toreplacecon="\$sshconection\$"
toreplacepath="\$keypath\$"

echo "\n Please enter a valid ssh connection: "
read sshcon
echo "\n Please enter a valid ssh-key path: "
read keypath
ccontent=$(curl https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/ssh_services/tunScript.sh)
wcontent="${ccontent/$toreplacecon/$sshcon}"
wwcontent="${wcontent/$toreplacepath/$keypath}"
echo wwcontent > $script/ssh/usedby_openVasgui_tunnel.sh

ccontent=$(curlhttps://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/ssh_services/2tunScript.sh)
wcontent="${ccontent/$toreplacecon/$sshcon}"
wwcontent="${wcontent/$toreplacepath/$keypath}"
echo wwcontent > $script/ssh/usedby_ssh_tunnel.sh

ccontent=$(https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/ssh_services/tunScript.service) -t /usr/lib/systemd/system/tun.service
sudo wget https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/ssh_services/2tunScript.service -t /usr/lib/systemd/system/2tun.service
sudo wget https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/ssh_services/sshd_config -t /etc/ssh/sshd_config

sudo systemctl daemon-reload
sudo systemctl enable 2tunScript
sudo systemctl enable tunScript
sudo systemctl start tunScript 2tunScript
sudo systemctl restart ssh


#Now only the master is missing
mkdir -p /home/scripts/reports
sudo wget https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/openvas/master -t /home/scripts/reports/master.sh
sudo wget https://raw.githubusercontent.com/GremlinStyle/tools/main/openVas-setup/openvas/master.service -t usr/lib/systemd/system/master.service
sudo systemctl daemon-reload
sudo systemctl enable master
sudo systemctl start master