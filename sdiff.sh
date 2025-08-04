#! /bin/bash


username=$(whoami)


remote_temp="~/.script_tmp"
repo_dir=$(timeout '0.1' find /* -name 'Scripts_tools' -type d 2>/dev/null)
repo_tmp="${repo_dir}/tempdir"

## Demande d'adresse IP 1 pour connection SSH
## Demande adresse IP 2 pour seconde connection SSH

echo
echo '------------------------------------------------------------------------------------------'
echo Deux connections SSH seront initialisées pour comparer des fichiers de différents serveurs
echo '------------------------------------------------------------------------------------------'
echo

read -p "Adresse IP 1 : " ip1
read -p "Adresse IP 1 : " ip2

read -p "Chemin complet du fichier sur ip1 à utiliser : " file1
read -p "Chemin complet du fichier sur ip2 à utiliser : " file2

# Récupération file1
getfile1(){
	ssh -At ${user}@${ip1} "sudo mkdir ${remote_temp} && sudo cp ${file1} ${remote_temp}/file1 "
	scp ${user}@${ip1}:${remote_temp}/file1 $repo_tmp/.
	ssh -At ${user}@${ip1} "sudo rm -fr ${remote_temp}"
}	

# Récupération file2
getfile1(){
	ssh -At ${user}@${ip1} "sudo mkdir ${remote_temp} && sudo cp ${file1} ${remote_temp}/file1 "
	scp ${user}@${ip1}:${remote_temp}/file1 $repo_tmp/.
	ssh -At ${user}@${ip1} "sudo rm -fr ${remote_temp}"
}	


comparefiles(){
	sdiff $repo_tmp/file1 $repo_tmp/file2
}

script_exec=0
while [ ${script_exec} == 0 ];
do
	getfile1
	getfile2
	comparefiles
	$script_exec=1
done
