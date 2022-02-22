#!/bin/sh

HOST=${HOST:-localhost}
N_DAYS=${N_DAYS:-365}
KEY_SIZE=${KEY_SIZE:-2048}
OWNER=${OWNER:-"root"}
GEN_NAME=${GEN_NAME:-"generic"}
GEN_NAME_CRT=${GEN_NAME_CRT:-$GEN_NAME}
EXT_CRT=${EXT_CRT:-"crt"}
GEN_NAME_KEY=${GEN_NAME_KEY:-$GEN_NAME}
EXT_KEY=${EXT_KEY:-"key"}

generate_cert() {
    local name=$1
    local cn="$2"
    local opts="$3"

    local keyfile=/certs/${name}/${GEN_NAME_KEY}.$EXT_KEY
    local certfile=/certs/${name}/${GEN_NAME_CRT}.$EXT_CRT

    [ -f $keyfile ] || openssl genrsa -out $keyfile $KEY_SIZE
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

mkdir -p /certs/ca
mkdir -p /certs/server
mkdir -p /certs/client
mkdir -p /certs/generic

[ -f /certs/ca/ca.$EXT_KEY ] || openssl genrsa -out /certs/ca/ca.$EXT_KEY $KEY_SIZE
openssl req \
    -x509 -new -nodes -sha256 \
    -key /certs/ca/ca.$EXT_KEY \
    -days $N_DAYS \
    -subj '/O=LocalAuthority/CN=Certificate Authority' \
    -out /certs/ca/ca.$EXT_CRT

cat > /certs/ca/openssl.cnf <<_END_
[ server_cert ]
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
nsCertType = server
subjectAltName = @alt_names


[ client_cert ]
keyUsage = digitalSignature, keyEncipherment
nsCertType = client
subjectAltName = @alt_names


[alt_names]
DNS.1 = $HOST
_END_

generate_cert server "Server-cert" "-extfile /certs/ca/openssl.cnf -extensions server_cert"
generate_cert client "Client-cert" "-extfile /certs/ca/openssl.cnf -extensions client_cert"
generate_cert generic "Generic-cert"

chown -R $OWNER:$OWNER /certs
