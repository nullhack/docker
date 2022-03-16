# source: https://medium.com/soulweb-academy/docker-local-dev-stack-with-traefik-https-dnsmasq-locally-trusted-certificate-for-ubuntu-20-04-5f036c9af83d

sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
ls -lh /etc/resolv.conf
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolv.conf'
sudo bash -c 'echo "nameserver 1.1.1.1" >> /etc/resolv.conf'
sudo apt install dnsmasq
