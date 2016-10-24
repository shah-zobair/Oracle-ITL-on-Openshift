cp /tmp/environment.properties /apps/opt/weblogic/endeca/apps/Discover/config/script/environment.properties

sed -i 's/eacHost=\".*\" eacPort=\"8888\"/eacHost=\"localhost\" eacPort=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Discover/config/script/AppConfig.xml
sed -i 's/hostName=\".*\" port=\"8888\"/hostName=\"localhost\" port=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Discover/config/script/AuthoringDgraphCluster.xml
sed -i 's/hostName=\".*\" port=\"8006\"/hostName=\"localhost\" port=\"8006\"/g' /apps/opt/weblogic/endeca/apps/Discover/config/script/LiveAppServerCluster.xml
sed -i 's/hostName=\".*\" port=\"8888\"/hostName=\"localhost\" port=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Discover/config/script/DataIngest.xml
sed -i 's/id=\"LiveMDEXHostA\" hostName=\".*\" port=\"8888\"/id=\"LiveMDEXHostA\" hostName=\"localhost\" port=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Discover/config/script/LiveDgraphCluster.xml
sed -i 's/hostName=\".*\" port=\"8888\"/hostName=\"localhost\" port=\"8888\"/g' /apps/opt/weblogic/endeca/apps/Discover/config/script/ReportGeneration.xml
sed -i 's/name="workbenchHost" value=\".*\" \/>/name="workbenchHost" value="localhost" \/>/g' /apps/opt/weblogic/endeca/apps/Discover/config/script/WorkbenchConfig.xml
sed -i 's/name="repositoryUrl" value=\".*\" \/>/name="repositoryUrl" value="http:\/\/localhost:8006\/ifcr" \/>/g' /apps/opt/weblogic/endeca/apps/Discover/config/script/WorkbenchConfig.xml

sed -i 's/http:\/\/.*:/http:\/\/localhost:/g' /apps/opt/weblogic/endeca/apps/Discover/config/ifcr/configuration/tools/preview.json
sed -i 's/http:\/\/.*:/http:\/\/localhost:/g' /apps/opt/weblogic/endeca/apps/Discover/config/ifcr/configuration/tools/xmgr/editors.xml
sed -i 's/<mdexHost>.*<\/mdexHost>/<mdexHost>localhost<\/mdexHost>/g' /apps/opt/weblogic/endeca/apps/Discover/config/ifcr/configuration/tools/xmgr/editors.xml
sed -i 's/\"host\": \".*\",/\"host\": \"localhost\",/g' /apps/opt/weblogic/endeca/apps/Discover/config/ifcr/configuration/tools/xmgr/services/dataservice.json

sed -i 's/host=.*/host=localhost/g' /apps/opt/weblogic/endeca/PlatformServices/workspace/conf/eaccmd.properties
sed -i 's/com.endeca.itl.cas.server.host=.*/com.endeca.itl.cas.server.host=localhost/g' /apps/opt/weblogic/endeca/CAS/workspace/conf/commandline.properties
