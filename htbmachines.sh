#!/bin/bash 

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c() {
  echo -e "\n\n${redColour}[!] Saliendo...\n${endColour}"
  tput cnorm; exit 1
}

#Ctrl + c
trap ctrl_c INT

main_url="https://htbmachines.github.io/bundle.js"

function helpPanel () {
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso: ${endColour}"
  echo -e "\t${purpleColour}u)${endColour}${grayColour} Descargar o actualizar archivos necesarios${endColour}" 
  echo -e "\t${purpleColour}i)${endColour}${grayColour} Buscar por direccion IP${endColour}"
  echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por nombre de la maquina ${endColour}"
  echo -e "\t${purpleColour}d)${endColour}${grayColour} Buscar por dificultad de la maquina ${endColour}"
  echo -e "\t${purpleColour}o)${endColour}${grayColour} Buscar por sistema operativo de la maquina ${endColour}"
  echo -e "\t${purpleColour}s)${endColour}${grayColour} Buscar por skill ${endColour}"
  echo -e "\t${purpleColour}y)${endColour}${grayColour} Obtener link de la resolucion de la maquina en Youtube ${endColour}"
  echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar panel de ayuda ${endColour}\n"
}

function searchMachine () {
  machineName="$1"
  machieName_checker="$(cat  bundle.js | awk "BEGIN{IGNORECASE=1} /name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d "," | sed "s/^ *//" | bat -l ruby)"

  if [ "$machieName_checker" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando propiedades de la maquina${endColour}${blueColour} $machineName${endColour}${grayColour}:${endColour}\n"
    cat  bundle.js | awk "BEGIN{IGNORECASE=1} /name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d "," | sed "s/^ *//" | bat -l ruby
  else
    echo -e "\n${redColour}[!] La maquina no existe${endColour}"
    helpPanel
  fi
}

function searchIP () {
  ipAddress="$1"
  machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

  if [ $machineName ];then

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} La maquina correspondiente a la IP${endColour} ${blueColour}$ipAddress${endColour} ${grayColour}es:${endColour}${purpleColour} $machineName ${endColour}\n"
  else 
    echo -e "\n${redColour}[!] La IP $ipAddress no corresponde con ninguna maquina ${endColour}\n"
  fi

}

function getYoutubeLink () {
  machineName="$1"
  youtubeLink="$(cat bundle.js | awk "BEGIN{IGNORECASE=1} /name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d "," | sed "s/^ *//" | grep "youtube" | awk 'NF{print $NF}')"
  
  if [ $youtubeLink ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Link de la maquina${endColour}${purpleColour} $machineName${endColour}${grayColour} resuelta en Youtube:${endColour} ${redColour}$youtubeLink${endColour} \n"
  else
    echo -e "\n${redColour}[!] La maquina no existe${endColour}\n"
  fi
}

function getMachineDifficulty () {
  difficulty="$1"
  results_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '",' | column)"

  if [ "$results_check" ]; then

    if [ "$difficulty" == "Fácil" ]; then 
      color="${blueColour}" 
    elif [ "$difficulty" == "Media" ]; then 
      color="${greenColour}" 
    elif [ "$difficulty" == "Difícil" ]; then 
      color="${purpleColour}" 
    elif [ "$difficulty" == "Insane" ]; then 
      color="${redColour}" 
    else color="${endColour}" 
    fi

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Representando las maquina que poseen el nivel de${endColour}${blueColour} $difficulty${endColour}${grayColour} de dificultad:${endColour}\n"
    echo -e "\n${color}$results_check${endColour}\n"
  else 
    echo -e "\n${redColour}[!] La dificultad proporcionada no existe${endColour}\n"
  fi
}

function getOSMachines () {
  os="$1"
  results_check="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '",' | column)"
  
  if [ "$results_check" ]; then

    if [ "$os" == "Windows" ]; then 
      color="${blueColour}" 
    elif [ "$os" == "Linux" ]; then 
      color="${greenColour}"  
    else 
      color="${endColour}" 
    fi
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Representando las maquinas con el sistema operativo${endColour} ${blueColour}$os${endColour}\n"
    echo -e "\n${color}$results_check${endColour}\n"
  else 
    echo -e "\n${redColour}[!] El sistema operativo proporcionado no existe${endColour}\n"
  fi
}

function getOSDifficultyMachines () {
  os="$1"
  difficulty="$2"

  results_check="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -C 5 | grep "so: \"$os\"" -B 4 | grep "name: " | awk 'NF{print $NF}' | tr -d ',"')"

  if [ "$results_check" ]; then
      if [ "$difficulty" == "Fácil" ]; then 
        color="${greenColour}" 
      elif [ "$difficulty" == "Media" ]; then 
        color="${turquoiseColour}" 
      elif [ "$difficulty" == "Difícil" ]; then 
        color="${purpleColour}" 
      elif [ "$difficulty" == "Insane" ]; then 
        color="${redColour}" 
      else color="${endColour}" 
      fi
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Representando las maquinas de dificultadad ${endColour}${blueColour}$difficulty${endColour}${grayColour} que tengan sistema operativo ${endColour}${purpleColour}$os${endColour}"
    echo -e "\n${color}$results_check${endColour}\n"
  else 
    echo -e "\n${redColour}[!] No se ha identificado dificultad o sistema operativo correcto${endColour}\n"
  fi
}

function getSkill () {
  skill="$1"

  skill_check="$(cat bundle.js | grep "skills" -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d ',"' | column)"

  if [ "$skill_check" ]; then
        color="${purpleColour}"
        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Representando maquinas por skill ${endColour}${blueColour}$skill${endColour}${grayColour}${yellowColour}:${endColour}"
        echo -e "\n${color}$skill_check${endColour}\n"
  else 
    echo -e "\n${redColour}[!] No se ha identificado ninga maquina con la Skill insertada${endColour}\n"
  fi
}

function updateFiles () {
  
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios\n${endColour}"
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados\n${endColour}"
    tput cnorm
 else
    tput civis
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaciones pendientes...\n${endColour}"
    curl -s $main_url > bundle_temp.js 
    js-beautify bundle_temp.js | sponge bundle_temp.js
    md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum bundle.js | awk '{print $1}')
    
    if [ "$md5_temp_value" == "$md5_original_value" ];  then
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} No se han encontrado actualizaciones\n${endColour} "
      rm bundle_temp.js
    else 
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han encontrado actualizaciones disponibles\n${endColour} "
      sleep 1
      rm bundle.js && mv bundle_temp.js bundle.js 
      echo -e "${yellowColour}[+]${endColour}${grayColour} Los archivos han sido actualizados${endColour}"
    fi
    tput cnorm
 fi
 
}

#Indicators
declare -i parameter_counter=0 

#Combinators
declare -i comb_os=0 
declare -i comb_difficulty=0

while getopts "m:ui:y:d:o:s:h" args; do 
  case $args in
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipAddress=$OPTARG; let parameter_counter+=3;;
    y) machineName=$OPTARG; let parameter_counter+=4;;
    d) difficulty=$OPTARG; comb_difficulty=1; let parameter_counter+=5;;
    o) os=$OPTARG; comb_os=1; let parameter_counter+=6;;
    s) skill=$OPTARG; let parameter_counter+=7;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  getMachineDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
  getOSMachines $os
elif [ $parameter_counter -eq 7 ]; then
  getSkill "$skill"
elif [ $comb_os -eq 1 ] && [ $comb_difficulty -eq 1 ]; then
  getOSDifficultyMachines $os $difficulty
 else
  helpPanel
fi
