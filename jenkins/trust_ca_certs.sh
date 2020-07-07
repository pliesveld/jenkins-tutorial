#!/bin/bash

# Updates system and JVM certificates

mkdir -p /usr/local/share/ca-certificates/
cd /usr/local/share/ca-certificates/
wget --no-check-certificate -r -l1 --no-parent -A.cer http://aia.pki.va.gov/PKI/AIA/VA/ -P .

find aia.pki.va.gov -name '*.cer' | while read FILE; do export NAME=${FILE//.cer}; openssl x509 -inform DER -in ${NAME}.cer -out ${NAME}.crt; done


find aia.pki.va.gov -name '*.cer' | while read FILE; do export NAME=${FILE//.cer}; keytool -import -trustcacerts -alias ${NAME} -file ${NAME}.cer -noprompt -storepass changeit -keystore $JAVA_HOME/jre/lib/security/cacerts   ;  done

mv ./aia.pki.va.gov/PKI/AIA/VA ./VA
rm -rf aia.pki.va.gov
find VA  -name '*.cer' -delete
chmod -R 644 VA
dpkg-reconfigure -p critical ca-certificates
update-ca-certificates

