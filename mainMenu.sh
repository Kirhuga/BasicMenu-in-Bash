#!/bin/bash

function finalizar() {
	read -p "Introduce el usuario" usuario1
	echo "Se paran todos los procesos de $usuario1"
	pkill -u $usuario1
}

function procesos() {
	echo "Se comprueban nº de procesos"
	procesos=$(ps -fea | wc -l)
	echo $procesos
	if [ $procesos -gt 200 ]; then
		echo "El número de procesos es mayor que 200"
	elif [ $procesos -le 200 ]; then
		echo "El número de procesos es normal"
	fi
}


function hardware(){
	echo "Para ver la información de la bios hay que ser sudo"
	echo 
	fabricante=$(sudo dmidecode -t 0 | head -7 | tail -1 | cut -d":" -f2)
	version=$(sudo dmidecode -t 0 | head -8 | tail -1 | cut -d":" -f2)
	placaf=$(sudo dmidecode -t 2 | head -7 | tail -1 | cut -d":" -f2)
	versionf=$(sudo dmidecode -t 2 | head -9 | tail -1 | cut -d":" -f2)
	echo "BIOS"
	echo "Fabricante es: "$fabricante" y versión es: "$version""
	echo
	echo "Placa base"
	echo "Fabricante es: "$placaf" y version es: "$versionf""
}

function cambiar(){
	read -p "Dime usuario " usuario2
	echo "Me has dicho " $usuario2
	existe=$(getent passwd $usuario2 | wc -l)
	if [ $existe -eq 1 ]; then
		echo "$usuario2 existe, cambio su contraseña "
		passwd $usuario2
	else
		echo "$usuario2 no existe, no tengo nada que cambiar"
	fi
}

function consulta(){
	read -p "Dime usuario " usuario4
	uid=$(getent passwd $usuario4 | cut -d":" -f3)
	echo "El UID de $usuario4 es: $uid"
}

function planificar(){
	read -p "Se programará el cron del usuario que me digas " usuario3
	cat /var/spool/cron/crontabs/$usuario3 | grep "/tmp/backup.sh"
    if [ $? -eq 0 ]; then
        echo "Ya estaba programado"
    else
        sudo echo "30 8 * 4 6 $usuario3 /tmp/backup.sh" >> /var/spool/cron/crontabs/$usuario3
        echo "Programado"
    fi
}

function volver(){
	./mainMenu.sh
}

echo MAIN MENÚ
echo ========================
echo "[F]inalizar"
echo "[P]rocesos"
echo "[H]ardware"
echo "[U]suarios"
echo "[S]alir"
echo ===============
echo "Introduce una opción: "
read menu

case $menu in
F) finalizar;;
P) procesos;;
H) hardware;;
U) 	echo USERS SUBMENU
	echo ****************************
	echo 1. Cambiar
	echo 2. Consulta
	echo 3. Planificar
	echo 4. Volver al menú principal

	echo "Introduce una opción: "
	read sub
	case $sub in
		1)cambiar;;
		2)consulta;;
		3)planificar;;
		4)volver;;
	esac;;
S) echo "Fin del programa"; break;;
esac