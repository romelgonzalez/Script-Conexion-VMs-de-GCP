#!/bin/bash
#
#
if [ $1 ]; then
        project_name="--project $1"
fi

if [ $2 ]; then
        name="$2"
fi

if  [[ ! $project_name ]];  then
       # se capturan los proyectos excluyendo los proyectos que inician con sys-xxxx que son de sistema.
       project=($(gcloud projects list | grep -v '^sys-' | peco --initial-index 1))
       project_name="--project ${project[0]}"
fi;

if  [ ! $name ]; then
        instance=($(gcloud compute networks list ${project_name} | peco --initial-index 1))
        name=${instance[0]}
fi

network_name=$name
echo -e "Borrando la regla antigua...\n"
gcloud compute --project=$project firewall-rules delete roadwarrior-${USER}-$name --quiet

echo -e "Creando nueva regla de firewall...\n"
gcloud compute --project=$project firewall-rules create roadwarrior-${USER}-$name --direction=INGRESS --priority=1000 --network=$name --action=ALLOW --rules=tcp:3389,tcp:2222,tcp:443,tcp:81,tcp:80,tcp:22 --source-ranges=`curl ifconfig.me/ip`/32

instance=($(gcloud compute instances list ${project_name} | peco --initial-index 1))
name=${instance[0]}
zone=${instance[1]}

echo -e "\n"
echo -e "----------------------------------------------------------------------------------------------------"
echo "Conectado a la VM: $name en la zona "$zone" del proyecto "${project[0]}""
echo -e "----------------------------------------------------------------------------------------------------\n"
gcloud compute ssh --zone "$zone" ${project_name}  $name

echo -e "\n"
echo -e "----------------------------------------------------------------------------------------------------"
echo "Eliminando la regla del firewall"
echo -e "----------------------------------------------------------------------------------------------------\n"
gcloud compute --project=$project firewall-rules delete roadwarrior-beservices-${USER}-${network_name} -q


## END
