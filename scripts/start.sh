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
echo '/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/deployment_template/lib/../../server/workspace/credential_store/jps-config.xml' >> /tmp/search.rsp
echo '/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/deployment_template/lib/../../server/workspace/state/repository' >> /tmp/search.rsp
echo '' >> /tmp/search.rsp

# Run the Wizard
echo "Running the Search App Wizard now"

/apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/deployment_template/bin/deploy.sh --app /apps/opt/weblogic/endeca/ToolsAndFrameworks/11.1.0/reference/discover-data/deploy.xml < /tmp/search.rsp

# Initialize the App
#echo "Initializing the App"
#/apps/opt/weblogic/endeca/apps/Search/control/initialize_services.sh
