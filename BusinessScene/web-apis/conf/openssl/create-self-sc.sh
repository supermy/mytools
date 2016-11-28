#!/usr/bin/env bash
#!/bin/sh
# create self-signed server certificate:
read -p "请输入证书的域 例如[www.example.com or 10.126.128.195/196]: " DOMAIN

SUBJECT="/C=CN/ST=BJ/L=BJ/O=bky/CN=$DOMAIN"

echo "创建服务器证书..."

openssl genrsa -des3 -out server.key 2048
echo ""
openssl rsa -in server.key -out server.key

openssl req -new -subj $SUBJECT -key server.key -out server.csr

echo "创建客户端证书..."
openssl genrsa -des3 -out client.key 2048
openssl req -new -subj $SUBJECT -key client.key -out client.csr

echo "创建根证书..."
openssl req -new -x509 -keyout ca.key -out ca.crt

#rm -rf /etc/pki/CA/index.txt
#rm -rf /etc/pki/CA/serial
#touch /etc/pki/CA/{index.txt,serial}
#echo 01 > /etc/pki/CA/serial

#echo "用根证书对服务器证书和客户端证书签名"
#openssl ca -in server.csr -out server.crt -cert ca.crt -keyfile ca.key
#openssl ca -in client.csr -out client.crt -cert ca.crt -keyfile ca.key

#echo "导出服务器证书和客户端证书"
#openssl pkcs12 -export -clcerts -in client.crt -inkey client.key -out client.p12
#openssl pkcs12 -export -in client.crt -inkey client.key -out  client.pfx
#openssl x509 -in client.crt -out client.cer
#openssl x509 -in server.crt -out server.cer


echo "把以上生成的文件copy到nginx conf文件的ssl目录下面，如果ssl目录不存在请创建"
echo "接下请配置nginx.conf操作:"
echo " server {																						"
echo " 			...                                           "
echo "     ssl on;                                        "
echo "     ssl_certificate ssl/server.crt;                "
echo "     ssl_certificate_key ssl/server.key;            "
echo "     ssl_client_certificate ssl/ca.crt;             "
echo "     ssl_verify_client on;                          "
echo "			...                                           "
echo "     }                                               "
echo "使用如下命令重新加载nginx配置"
echo "nginx -s reload"