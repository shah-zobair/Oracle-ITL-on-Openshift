#!/bin/bash


################
# Start Platform Service
#
echo "Starting Platform Services"
/apps/opt/weblogic/endeca/PlatformServices/11.1.0/tools/server/bin/startup.sh &
echo "Started PS"

################
# Start Tools and Framework
#
echo "Starting Tools and Framework"
/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/bin/startup.sh &
echo "Started T&F"

################
# Start CAS
#
echo "Starting CAS"
/apps/opt/weblogic/endeca/CAS/11.1.0/bin/cas-service.sh &
echo "Started CAS"

###############
# Deploy Search Application
#
# Create Response file for the wizard
echo '' > /tmp/search.rsp
echo 'Y' >> /tmp/search.rsp
echo 'Search' >> /tmp/search.rsp
echo '/apps/opt/weblogic/endeca/apps' >> /tmp/search.rsp
echo '8888' >> /tmp/search.rsp
echo '8006' >> /tmp/search.rsp
echo '17000' >> /tmp/search.rsp
echo '17002' >> /tmp/search.rsp
echo '17010' >> /tmp/search.rsp
echo '' >> /tmp/search.rsp
#echo '/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/deployment_template/lib/../../server/workspace/credential_store/jps-config.xml' >> /tmp/search.rsp
echo '/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/deployment_template/lib/../../server/workspace/state/repository' >> /tmp/search.rsp
echo '' >> /tmp/search.rsp

# Run the Wizard
echo "Running the Search App Wizard now"

/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/deployment_template/bin/deploy.sh --app /apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/reference/discover-data/deploy.xml < /tmp/search.rsp

sleep 60

/apps/opt/weblogic/endeca/PlatformServices/11.1.0/tools/server/bin/shutdown.sh
/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/bin/shutdown.sh
/apps/opt/weblogic/endeca/CAS/11.1.0/bin/cas-service-shutdown.sh

# Configure the App
echo "Configuring the app"
rm -f /apps/opt/weblogic/endeca/apps/Search/config/script/environment.properties
cp /tmp/environment.properties /apps/opt/weblogic/endeca/apps/Search/config/script/environment.properties

sed -i 's/eacHost=\".*\" eacPort=\"8888\"/eacHost=\"localhost\" eacPort=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Search/config/script/AppConfig.xml
sed -i 's/hostName=\".*\" port=\"8888\"/hostName=\"localhost\" port=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Search/config/script/AuthoringDgraphCluster.xml
sed -i 's/hostName=\".*\" port=\"8006\"/hostName=\"localhost\" port=\"8006\"/g' /apps/opt/weblogic/endeca/apps/Search/config/script/LiveAppServerCluster.xml
sed -i 's/hostName=\".*\" port=\"8888\"/hostName=\"localhost\" port=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Search/config/script/DataIngest.xml
sed -i 's/id=\"LiveMDEXHostA\" hostName=\".*\" port=\"8888\"/id=\"LiveMDEXHostA\" hostName=\"localhost\" port=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Search/config/script/LiveDgraphCluster.xml
sed -i 's/hostName=\".*\" port=\"8888\"/hostName=\"localhost\" port=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Search/config/script/ReportGeneration.xml
sed -i 's/name="workbenchHost" value=\".*\" \/>/name="workbenchHost" value="localhost" \/>/g' /apps/opt/weblogic/endeca/apps/Search/config/script/WorkbenchConfig.xml
sed -i 's/name="repositoryUrl" value=\".*\" \/>/name="repositoryUrl" value="http:\/\/localhost:8006\/ifcr" \/>/g' /apps/opt/weblogic/endeca/apps/Search/config/script/WorkbenchConfig.xml

sed -i 's/http:\/\/.*:/http:\/\/localhost:/g' /apps/opt/weblogic/endeca/apps/Search/config/ifcr/configuration/tools/preview.json
sed -i 's/http:\/\/.*:/http:\/\/localhost:/g' /apps/opt/weblogic/endeca/apps/Search/config/ifcr/configuration/tools/xmgr/editors.xml
sed -i 's/<mdexHost>.*<\/mdexHost>/<mdexHost>localhost<\/mdexHost>/g' /apps/opt/weblogic/endeca/apps/Search/config/ifcr/configuration/tools/xmgr/editors.xml
sed -i 's/\"host\": \".*\",/\"host\": \"localhost\",/g' /apps/opt/weblogic/endeca/apps/Search/config/ifcr/configuration/tools/xmgr/services/dataservice.json

sed -i 's/host=.*/host=localhost/g' /apps/opt/weblogic/endeca/PlatformServices/workspace/conf/eaccmd.properties
sed -i 's/com.endeca.itl.cas.server.host=.*/com.endeca.itl.cas.server.host=localhost/g' /apps/opt/weblogic/endeca/CAS/workspace/conf/commandline.properties
sed -i 's/com.endeca.mdexRoot=.*/com.endeca.mdexRoot=\/apps\/opt\/weblogic\/endeca\/MDEX\/6.5.1\//g' /apps/opt/weblogic/endeca/PlatformServices/workspace/conf/eac.properties

rm -fr /apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/workspace/state
mkdir /apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/workspace/state

echo "Configuration Done"


/apps/opt/weblogic/endeca/PlatformServices/11.1.0/tools/server/bin/startup.sh &
/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/bin/startup.sh &
/apps/opt/weblogic/endeca/CAS/11.1.0/bin/cas-service.sh &
echo "Startup Complete, Sleeping for 60 Sec..."
sleep 60

## Restart all Services
#echo "Restarting all Services"
#/apps/opt/weblogic/endeca/PlatformServices/11.1.0/tools/server/bin/shutdown.sh
#/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/bin/shutdown.sh
#/apps/opt/weblogic/endeca/CAS/11.1.0/bin/cas-service-shutdown.sh
#echo "Shutdown Complete, Sleeping for 20 Sec..."
#sleep 20

# Initialize the App
echo "Initializing the Service"
#rm -fr /apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/workspace/state
#mkdir /apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/workspace/state

#/apps/opt/weblogic/endeca/PlatformServices/11.1.0/tools/server/bin/startup.sh &
#/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/bin/startup.sh &
#/apps/opt/weblogic/endeca/CAS/11.1.0/bin/cas-service.sh &
#echo "Startup Complete, Sleeping for 20 Sec..."
#sleep 60

sleep 30
/apps/opt/weblogic/endeca/apps/Search/control/initialize_services.sh --force

## Shutting Down Services for fresh start
echo "Shutting Down all Services for fresh start"
/apps/opt/weblogic/endeca/PlatformServices/11.1.0/tools/server/bin/shutdown.sh
/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/server/bin/shutdown.sh
/apps/opt/weblogic/endeca/CAS/11.1.0/bin/cas-service-shutdown.sh
sleep 10
