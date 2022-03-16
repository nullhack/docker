mkdir -p ./certs

if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

echo "Creating certs for: *.${DOMAIN_NAME}.${DOMAIN_SUFFIX}"

mkcert -key-file ./certs/key.pem -cert-file ./certs/cert.pem "${DOMAIN_SUFFIX}" "${DOMAIN_NAME}.${DOMAIN_SUFFIX}" "*.${DOMAIN_NAME}.${DOMAIN_SUFFIX}"

#grep -qxF "address=/.${DOMAIN_SUFFIX}/127.0.0.1" '/etc/dnsmasq.conf' || sudo bash -c "echo 'address=/.${DOMAIN_SUFFIX}/127.0.0.1' >> /etc/dnsmasq.conf"
#[ -d "/etc/resolver/${DOMAIN_SUFFIX}" ] || sudo mkdir -p /etc/resolver && sudo bash -c "echo 'nameserver 127.0.0.1' > /etc/resolver/${DOMAIN_SUFFIX}"
#sudo systemctl restart dnsmasq

