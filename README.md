# HTB Machines Search Script

## Descripción General
Este script en Bash está diseñado para buscar y filtrar máquinas resueltas de Hack The Box (HTB) desarrolladas por el hacker español Marcelo Vázquez. Permite realizar búsquedas basadas en diferentes criterios como nombre, dirección IP, dificultad y sistema operativo. Además, incluye una opción para obtener enlaces a las resoluciones disponibles en YouTube.

## Requisitos
Para ejecutar este script, necesitarás tener instalados los siguientes programas:

- `curl`
- `js-beatify`
- `sponge` (parte del paquete `moreutils`)
- `bat`

## Instalación de Herramientas Requeridas
Para instalar las herramientas necesarias, puedes usar el siguiente comando en tu terminal:

```bash
paru -S curl js-beatify moreutils bat
```

## Uso
1. Clona el repositorio:
   ```bash
   git clone https://github.com/Unfiw/htbmachines
   ```

2. Cambia al directorio del script:
   ```bash
   cd htbmachines/
   ```

3. Da permisos de ejecución al script:
   ```bash
   chmod +x htbmachines.sh
   ```

4. Ejecuta el script:
   ```bash
   ./htbmachines
   ```

## Demostración de Uso
Ejemplos de comandos que puedes usar:

1. Para actualizar o descargar archivos necesarios:
   ```bash
   ./htbmachines -u
   ```

2. Para iniciar el script sin argumentos y ver las opciones disponibles:
   ```bash
   ./htbmachines
   ```

   Salida esperada:
   ```
   [+] Uso:
     u) Descargar o actualizar archivos necesarios
     i) Buscar por dirección IP
     m) Buscar por nombre de la máquina 
     d) Buscar por dificultad de la máquina 
     o) Buscar por sistema operativo de la máquina 
     s) Buscar por habilidad 
     y) Obtener enlace de la resolución de la máquina en YouTube 
     h) Mostrar panel de ayuda
   ```

## Características
La herramienta proporciona una interfaz de consola colorida y cuenta con validaciones de entrada para asegurar que se ejecute correctamente.

## Contribuciones
Por el momento, no se contempla que otros contribuyan al proyecto; se planea seguir mejorándolo de manera independiente.

## Créditos
Gracias a la academia Hack4U por brindarme el conocimiento necesario para desarrollar esta herramienta.
