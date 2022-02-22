# source: https://medium.com/soulweb-academy/docker-local-dev-stack-with-traefik-https-dnsmasq-locally-trusted-certificate-for-ubuntu-20-04-5f036c9af83d

sudo apt install libnss3-tools wget -y
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64
sudo mv mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert && chmod +x /usr/local/bin/mkcert
mkcert -install
