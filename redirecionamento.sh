#!/bin/bash

cat << EOF
  ______________________________________________
 |                                              |
 |        REDIRECIONAMENTOS DE APPS             |
 |______________________________________________|
EOF

echo "(1) CRIAR REDIRECIONAMENTO"
echo "(2) SAIR"
read option

if [ $option == 1 ]; then
  echo -e " ########################################"
  echo -e "|                 AVISO                  |"
  echo -e "|  Antes de criar este redirecionamento  |"
  echo -e "|  é necessário criar o apontamento DNS  |"
  echo -e " ########################################\n"
  echo -e "\nQual o subdomain desejado? (FQDN = subdomain.eqi.life)"
  read subdomain

  echo -e "\nPara qual porta devo redirecionar as requests?"
  read port

  echo -e "\nO seguinte redirecionamento será criado:"
  echo " FQDN: $subdomain.eqi.life"
  echo " Porta: $port"
  echo -e "\nConfirma a criação do item? [S|n]"
  read confirm

  if [[ "$confirm" =~ [sS] ]]; then
    # Cria o arquivo do apontamento e faz restart no server
    filename="$subdomain.conf"

    cd /etc/nginx/conf.d
    touch $(echo "$filename")

    filecontent="server {
  listen 80;
  listen [::]:80;

  server_name  $subdomain.eqi.life;

  location / {
    proxy_pass http://localhost:$port/;
    proxy_buffering off;
  }
}"

    echo "$filecontent" >> $filename

    $(nginx -s reload)

    echo -e "\nRedirecionamento criado com sucesso!\n"
  else
    echo -e "\nCriação de redirecionamento cancelada\n"
    exit 1
  fi
fi
