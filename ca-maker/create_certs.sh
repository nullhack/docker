#!/bin/sh

N_DAYS=${N_DAYS:-365}
EXT_CRT=${EXT_CRT:-"crt"}
EXT_KEY=${EXT_KEY:-"key"}
GEN_NAME=${GEN_NAME:-"generic"}
KEY_SIZE=${KEY_SIZE:-KEY_SIZE}

generate_cert() {
    local name=$1
    local cn="$2"
    local opts="$3"

    local keyfile=/certs/${name}/${name}.$EXT_KEY
    local certfile=/certs/${name}/${name}.$EXT_CRT

    [ -f $keyfile ] || openssl genrsa -out $keyfile KEY_SIZE
    openssl req \
        -new -sha256 \
        -subj "/O=$name/CN=$cn" \
        -key $keyfile | \
        openssl x509 \
            -req -sha256 \
            -CA /certs/ca/ca.$EXT_CRT \
            -CAkey /certs/ca/ca.$EXT_KEY \
            -CAserial /certs/ca/ca.txt \
            -CAcreateserial \
            -days $N_DAYS \
            $opts \
            -out $certfile
}

mkdir -p /certs
mkdir -p /certs/ca
mkdir -p /certs/server
mkdir -p /certs/client
mkdir -p /certs/$GEN_NAME

[ -f /certs/ca/ca.$EXT_KEY ] || openssl genrsa -out /certs/ca/ca.$EXT_KEY KEY_SIZE
openssl req \
    -x509 -new -nodes -sha256 \
    -key /certs/ca/ca.$EXT_KEY \
    -days $N_DAYS \
    -subj '/O=LocalAuthority/CN=Certificate Authority' \
    -out /certs/ca/ca.$EXT_CRT

cat > /certs/ca/openssl.cnf <<_END_
[ server_cert ]
keyUsage = digitalSignature, keyEncipherment
nsCertType = server
[ client_cert ]
keyUsage = digitalSignature, keyEncipherment
nsCertType = client
_END_

generate_cert server "Server-only" "-extfile /certs/ca/openssl.cnf -extensions server_cert"
generate_cert client "Client-only" "-extfile /certs/ca/openssl.cnf -extensions client_cert"
generate_cert $GEN_NAME "Generic-cert"
