#!/bin/bash

# Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Instalar o LXD
sudo apt install -y lxd

# Adicionar o usuário atual ao grupo lxd
sudo usermod -aG lxd $USER

# Inicializar o LXD com as configurações desejadas
cat <<EOF | sudo lxd init --preseed
config:
  core.https_address: "[::]:8443"
networks:
- config:
    ipv4.address: 10.10.10.1/24
    ipv4.nat: "true"
    ipv6.address: none
  description: ""
  name: lxdbr0
  type: bridge
storage_pools:
- config:
    size: 20GB
  description: ""
  name: default
  driver: dir
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
  name: default
cluster: null
EOF

# Reiniciar o LXD para aplicar as configurações
sudo systemctl restart lxd

echo "LXD instalado e configurado com sucesso!"
echo "Acesse a interface web do LXD em https://<seu_ip>:8443"