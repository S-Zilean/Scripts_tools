#! /bin/bash


user=$(whoami | awk'{print $1}')


remote_temp="~/.script_tmp"
dist_dir="/home/${user}/.tempdir"
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
read -p "Adresse IP 2 : " ip2

read -p "Chemin complet du fichier sur ip1 à utiliser : " file1
read -p "Chemin complet du fichier sur ip2 à utiliser : " file2

# Récupération file1
getfile1(){

	ssh -At $ip1 mkdir $dist_dir
       	ssh -At $ip1 sudo cp ${file1} $dist_dir/file1
	scp $ip1:${remote_temp}/file1 $repo_tmp/.
	ssh -At $ip1 rm -fr $dist_dir

}	

# Récupération file2
getfile2(){

	ssh -At ${ip2} mkdir 
	ssh -At ${ip2} sudo cp ${file1} /home/$user/.tempdir/file2
	scp ${ip2}:${remote_temp}/file2 $repo_tmp/.
	ssh -At ${ip2} rm -fr ${remote_temp}

}	


comparefiles(){

	sdiff $repo_tmp/file1 $repo_tmp/file2

}

script_exec=0
while [ ${script_exec} == 0 ]
do
	getfile1
	getfile2
	comparefiles
	script_exec=1
done
