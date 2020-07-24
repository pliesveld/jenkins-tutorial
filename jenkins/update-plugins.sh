# token for the jenkins-tutorial container
API_TOKEN='11d6367ffa48ce7adaf4cdaf8f2fd7d6b2'
# token for the jenkins-project container
# API_TOKEN_2='113b553b5dd3785b029ed31feee8821301'
# script variable (UPDATE_LIST) has a script that returns the plugins that are available for updates from the Jenkins update center.
UPDATE_LIST=$( java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth admin:${API_TOKEN} list-plugins | grep -e ')$' | awk '{ print $1 }' );
# grabs the plugins ready for an update from jenkins update center and redirects the list to the plugins-to-update.txt file
java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth admin:${API_TOKEN} list-plugins | grep -e ')$' | awk '{ print $0 }' > plugins-to-update.txt
# grabs the name of the plugin and redirects it to the update-names.txt file
cat plugins-to-update.txt | awk '{print $1}' > update-names.txt
# grabs the version of the plugin and redirects it to the update-versions.txt file
cat plugins-to-update.txt | awk '{print $0}' | egrep --only-matching '[0-9.-.()]+$' > update-versions.txt
paste -d ':' update-names.txt update-versions.txt > the-plugins-to-update.txt 
UPDATED_PLUGINS=$(cat the-plugins-to-update.txt)
if [ ! -z "${UPDATE_LIST}" ]
then # IF there are updates available
    echo Updating Jenkins Plugins: ${UPDATE_LIST}; 
    java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth admin:${API_TOKEN} install-plugin ${UPDATE_LIST};
    java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth admin:${API_TOKEN} safe-restart; # 
    echo Restarting ...
    until java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth admin:${API_TOKEN} list-plugins 2> /dev/null ; do echo . & sleep 1 ; done
    echo Successfully updated plugins. Restart completed.
    echo Plugins that were updated: ${UPDATED_PLUGINS}
else # IF there are not any updates available
    echo Plugins already up to date;
fi
# updates the plugins.txt file
java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -webSocket -auth admin:${API_TOKEN} list-plugins | awk '{ print $0 }' > plugins0.txt
cat plugins0.txt | awk '{print $1}' > plugin-names.txt
cat plugins0.txt | awk '{print $0}' | egrep --only-matching '[0-9.-]+$' > plugin-versions.txt
paste -d ':' plugin-names.txt plugin-versions.txt > plugins.txt

# removes not-needed files
rm update-names.txt
rm update-versions.txt 
rm plugins-to-update.txt
rm plugin-names.txt
rm plugin-versions.txt
