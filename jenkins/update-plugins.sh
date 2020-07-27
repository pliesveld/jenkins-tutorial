# token for the jenkins-tutorial container

USERNAME=admin
API_TOKEN='1124db709836c296a5c1e4adcfa43650e7'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


if [ ! -f ${DIR}/jenkins-cli.jar ] ; then
    curl -o ${DIR}/jenkins-cli.jar http://localhost:8080/jenkins/jnlpJars/jenkins-cli.jar
fi


# script variable (UPDATE_LIST) has a script that returns the plugins that are available for updates from the Jenkins update center.
UPDATE_LIST=$( java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth ${USERNAME}:${API_TOKEN} list-plugins | grep -e ')$' | awk '{ print $1 }' );
# grabs the plugins ready for an update from jenkins update center and redirects the list to the plugins-to-update.txt file
java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth ${USERNAME}:${API_TOKEN} list-plugins | grep -e ')$' | awk '{ print $0 }' > plugins-to-update.txt
# grabs the name of the plugin and redirects it to the update-names.txt file
cat plugins-to-update.txt | awk '{print $1}' > update-names.txt
# grabs the version of the plugin and redirects it to the update-versions.txt file
cat plugins-to-update.txt | awk '{print $0}' | egrep --only-matching '[0-9.-.()]+$' > update-versions.txt
paste -d ':' update-names.txt update-versions.txt > the-plugins-to-update.txt 
UPDATED_PLUGINS=$(cat the-plugins-to-update.txt)
if [ ! -z "${UPDATE_LIST}" ]
then # IF there are updates available
    echo Updating Jenkins Plugins: ${UPDATE_LIST}; 
    java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth ${USERNAME}:${API_TOKEN} install-plugin ${UPDATE_LIST};
    java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth ${USERNAME}:${API_TOKEN} safe-restart; # 
    echo Restarting ...
    until java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth ${USERNAME}:${API_TOKEN} list-plugins 2> /dev/null ; do echo . & sleep 1 ; done
    echo Successfully updated plugins. Restart completed.
    echo Plugins that were updated: ${UPDATED_PLUGINS}

    # updates the plugins.txt file
    java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth ${USERNAME}:${API_TOKEN} list-plugins | awk '{ print $0 }' > plugins0.txt
    cat plugins0.txt | awk '{print $1}' > plugin-names.txt
    cat plugins0.txt | awk '{print $0}' | egrep --only-matching '[0-9.-]+$' > plugin-versions.txt
    paste -d ':' plugin-names.txt plugin-versions.txt > "${DIR}/plugins.txt"

else # IF there are not any updates available
    echo Plugins already up to date;
fi
# removes not-needed files
rm -f plugins0.txt update-names.txt update-versions.txt plugins-to-update.txt plugin-names.txt plugin-versions.txt
