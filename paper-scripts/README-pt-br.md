# Informações sobre o ambiente utilizado

* Versão do Kernel
  * Antes de realizar a instalação dos demais pacotes, instale o kernel indicado. Após a instalação realize um reboot.
  * Comando de Instalação: `sudo apt install linux-image-5.15.0-89-lowlatency -y`
  * Após o reboot certifique-se que o kernel instalado foi carregado com o comando `uname -a`

* Host utilizado: Lenovo SR630 - arquitetura x84 de 64bit
  * **Processador:** Intel Xeon Gold 5218R
  * **RAM:** 128GB DDR4 (4x 32GB) - Dual Channel
  * **HDD:** 10TB
  * **Sistema Operacional:** Ubuntu Desktop 20.04 LTS (Fresh install)
  * **Ettus driver:** versão v4.4.0.0

* USRP Ettus N310
  * Ettus driver: versão v4.4.0.0

# Instalação do Ambiente
## Passo 1: Clonar este Repositório
Após instalar o `Kernel` indicado em uma instalação limpa do Ubuntu Desktop 20.04 LTS, realize os seguintes procedimentos:

Clonar este repositório no seu sistema Linux alvo:
```
git clone https://github.com/lance-ufrn/oai_bench_tuto.git
```

## Passo 2: Instalação do Docker e driver Ettus
Execute o script `./oai_5g_core_install.sh`. Ele será responsável por instalar o Docker e os recursos necessários do Open Air Interface. Não utilize o `sudo` para executar o script, porém o usuário necessita possuir permissão para utilizar o comando `sudo` (que está presente na execução dos comandos internos do script).

```bash
./oai_5g_core_install.sh
```


# Utilização do Ambiente
## Passo 1: Inicializar o 5GC
Para inicializar os serviços do core você deve utilizar o script `core-start.sh`.

```bash
./core-start.sh
```

## Passo 2: Executar o container Docker da gNodeB
Certifique-se de que a USRP (Ettus N310 ou Ettus B210) esteja conectada **diretamente** à máquina host.
* Ettus N310: Certifique-se de que o endereço IP da interface de comunicação da USRP está corretamente indicado nos arquivos de configuração (do diretório `conf`, o parâmetro `addr` da propriedade `sdr_addrs`);
* Ettus B210: Certifique-se de que esteja conectada ao host por meio de uma porta USB3 ou superior.

Para inicializar o container, execute o seguinte comando:
```bash
./services.sh [parâmetro]
```

Parâmetros disponíveis:
- `n106` para utilizar o PRB = 106 na USRP N310
- `n162` para utilizar o PRB = 162 na USRP N310
- `b106` para utilizar o PRB = 106 na USRP B210
- `b106fr` para utilizar o PRB = 106 na USRP B210 com FlexRic
- `2n162` para utilizar duas USRP N310, uma com 3700 MHz e outra com 3740 MHz e PRB = 162
- `stop` para finalizar os containers

Exemplo: `./services.sh n106`

Isso executará um shell script que iniciará um contêiner com as configurações mencionadas acima.


## Interromper os serviços do 5GC
Para interromper os serviços do core você deve utilizar o script `core-stop.sh`.

```bash
./core-stop.sh
```
