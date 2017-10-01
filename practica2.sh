#!/bin/bash
declare -a herenciainodos; #struct que guarda los inodos de los directorios que has visitado
declare -a ciclosArray; #struct que guarda los ciclos

cont=0 #para el array de inodos
ciclos=0 #numero de ciclos que hay

for i in `find` #va elemento elemento  guardando su inodo y su tipo
do
	inodo=$(stat --printf=%i $i) #inodo de los elementos del directrios
	tipo=$(stat --printf=%F $i) #Tipo de los elementos del directorio
	echo "$i $inodo $tipo" #muestra el elemeto, el nodo y su tipo

	if  [ "$tipo" = "directorio" ] #si el tipo es un directorio entra en el if y guarda el inodo en el array de herenciainodo. e incremente cont para la proxima vez.
	then
	    herenciainodos[$cont]=$inodo # 
	    ((cont++)) #
	fi
	if  [ "$tipo" = "enlace simbólico" ] #si el tipo es un enlace simbolico, 
	then
	  #ver a donde apunta y calculo inodo
	  ruta=$(ls -l $i | tr -s ' ' '%' | cut -d'%' -f10) #calcula la ruta.
	  TargetInode=$(stat --printf=%i $ruta)	#inodo al que apunta el link.
	  #Busca si el inodo del enlace simbolico, ya esta dentro de el array de herenciainodos.
	  for ((j=0;j<cont;j++))
	  do
	    if [ "$TargetInode" = "${herenciainodos[$j]}" ] # 
	    then
		echo "Softlink $i con inodo $inodo formando ciclo --> $ruta" 
		((ciclos++)) #Incrementa el numero de ciclos
		ciclosArray[$ciclos]=$i # mete en la posicion ciclos, el ciclo i.
	     fi
	    done
	  fi
done
echo "Numero ciclos $ciclos"
#Borrar
if [ "$1" = "-rmdel" ]; then
  if [ "$2" -le $ciclos ]; then
  echo "Borrado link con inodo ${ciclosArray[$2]}"
  rm ${ciclosArray[$2]}
  fi
fi
	
	
	
