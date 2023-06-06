# ANCHORE - AZURE DEVOPS

## Requisitos.

 - Contar con un sistema operativo ( Ubuntu ).
 - Generar un Personal Access Tokens.

## Creación de Agent Pool.

 -  Dirigirse a `Organization Settings`.
 -  Buscar el apartado `Agent Pools`.
 -  Damos click en `Add pool`.
 -  Seleccionamos que el nuevo Agente pool sea de tipo `Self-hosted`.
    - Asignamos un nombre para el nuevo Agent Pool.
    - De igual manera le brindamos una descripción ( Opcional ).
    - Por último seleccionamos las dos casillas de `Grant access permission to all pipelines` y `Auto-provision this agent pool in all projects` y le damos en create.

## Instalación del agente de Anchore

 Tener en cuenta que debemos estar dentro del sistema operativo donde se va a instalar el agente, en este caso me encuentro dentro de una máquina virtual con `Ubuntu`.

 Crearemos un directorio nuevo y nos dirigimos a él.
 
    sudo mkdir /opt/myagent && cd /opt/myagent

 Luego ejecutamos el siguiente comando para descargar los archivos necesarios.
 
    sudo wget https://vstsagentpackage.azureedge.net/agent/3.218.0/vsts-agent-linux-x64-3.218.0.tar.gz

 Procedemos a descomprimir el archivo que acabamos de descargar.

    sudo tar zxvf vsts-agent-linux-x64-*.tar.gz

 Ejecutamos el siguiente script `config.sh`.
 
    sudo ./config.sh

 Una vez inicie nos pedirá los siguiente datos:

 1. La URL de tu servidor. `Ejemplo: https://dev.azure.com/anchoretest`, donde `anchoretest` se refiere al nombre de tu organización. 
 2. Tu `Personal Access Tokens`.
 3. El nombre de tu `Agent tool` donde se va a alojar tu agente.
 4. También te pedirá si tu agente opta por tomar el nombre de tu host o darle un nombre de tu preferencia ( Opcional ).

Como alternativa puedes utilizar el siguiente comando, pasando como argumentos lo anteriormente mencionado:

    sudo ./config.sh --unattended --url <Organization> --auth pat --token <Personal-Access-Tokens> --pool <Agent-Pool> --agent <Agent> --work /opt/myagent/

Como último paso ejecutamos el script `run.sh`.

    sudo ./run.sh

## Crear un servicio para ejecutar el agente ( Opcional ).

Al crear un servicio nos aseguramos que el agente se mantendra siempre activo baja cualquier incidente.

### Usando el script `svc.sh`.

 Para instalarlo utilizamos el siguiente comando:

    sudo ./svc.sh install $USER

Opciones:

 - Iniciar: `sudo  ./svc.sh start`.
 - Estado: `sudo ./svc.sh status`.
 - Detener: `sudo ./svc.sh stop`.
 - Eliminar: `sudo ./svc.sh uninstall`.

### De manera manual.

Primero creamos un archivo de servicio con el editor de tu preferencia ( `neovim` ).

    sudo nvim /etc/systemd/system/agent.service

Luego pegamos la siguiente configuración:

```
[Unit]
Description=Agent anchore
After=network.target

[Service]
User=jose
WorkingDirectory=/opt/myagent
ExecStart=/opt/myagent/run.sh start
ExecStop=/opt/myagent/run.sh stop
TimeoutSec=30
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Los siguientes comandos nos servirán para interactuar con el servicio:

 - Iniciar: `sudo systemctl start agent.service`.
 - Estado: `sudo systemctl status agent.service`.
 - Persistir: `sudo systemctl enable agent.service`.
 - Detener: `sudo systemctl stop agent.service`.

## Sistemas Operativos basados en paquetes .rpm => Centos, Fedora, etc. ( Opcional )

En este caso se deberá ejecutar el siguiente script alojado en la carpeta `bin/`:

    sudo ./bin/installdependencies.sh

## Corrección de errores:

 - Validar la `fecha y hora` de sistema operativo o máquina virtual donde se va a alojar el agente.
 - En caso de no de poder ejecutar el script `config.sh` utilizar:
 
        sudo chmod -R 777 /opt/myagent/

