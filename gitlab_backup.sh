#!/bin/bash

# Répertoire de sauvegarde
backup_dir="/home/farhat/Desktop/GITLAB"
mkdir -p "$backup_dir"

# URL du serveur GitLab
gitlab_url="https://gitlab.dpc.com.tn/"
token="glpat-zidzwkE6JgsgAHB6X1X8"

# Liste tous les projets du GitLab
projects=$(curl --header "PRIVATE-TOKEN: $token" "$gitlab_url/api/v4/projects?per_page=100")

# Parcours de la liste des projets
for row in $(echo "${projects}" | jq -r '.[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
    }

    # Récupère l'ID et le nom du projet
    project_id=$(_jq '.id')
    project_name=$(_jq '.name')

    # Clone le dépôt dans le répertoire de sauvegarde
    git clone --mirror "$gitlab_url/$project_id/$project_name.git" "$backup_dir/$project_name.git"
done

