#!/bin/bash

## Instalar dependências
sudo apt-get install -y ca-certificates curl gnupg lsb-release

## Instalar Wireshark
sudo add-apt-repository ppa:wireshark-dev/stable -y
sudo apt update -y 
sudo apt install wireshark -y

## Definir diretório de trabalho
WORK_DIR=$HOME

## Configuração do forwarding
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT


## Baixar imagens do Docker Hub
IMAGENS=(
  "oaisoftwarealliance/oai-amf:v1.5.0"
  "oaisoftwarealliance/oai-nrf:v1.5.0"
  "oaisoftwarealliance/oai-smf:v1.5.0"
  "oaisoftwarealliance/oai-udr:v1.5.0"
  "oaisoftwarealliance/oai-udm:v1.5.0"
  "oaisoftwarealliance/oai-ausf:v1.5.0"
  "oaisoftwarealliance/oai-spgwu-tiny:v1.5.0"
  "oaisoftwarealliance/trf-gen-cn5g:latest"
)

for IMG in "${IMAGENS[@]}"; do
  sudo docker pull "$IMG"
  sudo docker image tag "$IMG" "$(echo $IMG | cut -d'/' -f2)"
done

## Remover diretório core5g antigo
if [ -d "$WORK_DIR/core5g" ]; then
  sudo rm -rf "$WORK_DIR/core5g"
fi

## Copiar repositório OpenAirInterface
if [ ! -d "core5g" ]; then
  echo "Erro: Diretório 'oai/core5g/' não encontrado!"
  exit 1
fi

cp -r core5g/ "$WORK_DIR"
cd "$WORK_DIR/core5g" || exit 1

## Verificar se syncComponents.sh existe
if [ ! -f "$WORK_DIR/core5g/scripts/syncComponents.sh" ]; then
  echo "Erro: syncComponents.sh não encontrado!"
  exit 1
fi

sudo bash "$WORK_DIR/core5g/scripts/syncComponents.sh"

## Verificar se core-network.py existe
if [ ! -f "$WORK_DIR/core5g/docker-compose/core-network.py" ]; then
  echo "Erro: core-network.py não encontrado!"
  exit 1
fi

## Iniciar Core 5G
cd "$WORK_DIR/core5g/docker-compose" || exit 1
sudo python3 core-network.py --type start-basic --scenario 1

## Permitir usuário rodar Docker sem sudo
sudo usermod -aG docker $USER

echo "Instalação do 5G Core concluída!"
