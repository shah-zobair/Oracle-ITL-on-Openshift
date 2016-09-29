FROM oc_base

MAINTAINER Shah Zobair <szobair@redhat.com>


#######################################
#
# folders located outside the container to get necessary dependencies
#
ENV REMOTE_PACKAGES_PATH installables
ENV REMOTE_SCRIPTS_PATH scripts
ENV REMOTE_SUPPORTS_PATH support

# folders for copying dependencies into initially
ENV BASE_CONTAINER_TMP_PATH /tmp/endeca

# folders for final installation of endeca programs
ENV BASE_INSTALL_PATH /apps/opt/weblogic
ENV BASE_ENDECA_PATH $BASE_INSTALL_PATH/endeca
ENV BASE_INSTALL_CUSTOM_SCRIPT_PATH $BASE_ENDECA_PATH/bin

# directory for final install of endeca
#RUN chmod 755 /opt/endeca/bin/*.sh

#######################################
# Set scripts to be executable
RUN chmod +x $BASE_CONTAINER_TMP_PATH/*.sh $BASE_CONTAINER_TMP_PATH/*.bin

#######################################
# Install mdex 6.5.1

RUN $BASE_CONTAINER_TMP_PATH/OCmdex6.5.1-Linux64_829811.sh --silent --target $BASE_INSTALL_PATH && \
    touch /home/endeca/.bashrc && \
    cat $BASE_INSTALL_PATH/endeca/MDEX/6.5.1/mdex_setup_sh.ini >> /home/endeca/.bashrc && \
    source /home/endeca/.bashrc

# Variables needed to install other applications.  List comes from previous mdex_setup_sh.ini script
ENV ENDECA_MDEX_ROOT=/opt/endeca/endeca/MDEX/6.5.1

#######################################
# Install platform services
#
#OCplatformservices11.1.0-Linux64.bin
RUN $BASE_CONTAINER_TMP_PATH/OCplatformservices11.1.0-Linux64.bin --silent --target $BASE_INSTALL_PATH < $BASE_CONTAINER_TMP_PATH/platformservices-silent.txt

RUN cat $BASE_INSTALL_PATH/endeca/PlatformServices/workspace/setup/installer_sh.ini >> /home/endeca/.bashrc

# Variables needed to install other applications.  List comes from previous mdex_setup_sh.ini script
ENV VERSION=11.1.0
ENV BUILD_VERSION=11.1.0.842407
ENV ARCH_OS=x86_64pc-linux
ENV PRODUCT=IAP
ENV ENDECA_INSTALL_BASE=$BASE_ENDECA_PATH

#  Environment variables required to run the Endeca Platform Services software.
ENV ENDECA_ROOT=$BASE_ENDECA_PATH/PlatformServices/11.1.0
ENV PERLLIB=$ENDECA_ROOT/lib/perl:$ENDECA_ROOT/lib/perl/Control:$ENDECA_ROOT/perl/lib:$ENDECA_ROOT/perl/lib/site_perl:$PERLLIB
ENV PERL5LIB=$ENDECA_ROOT/lib/perl:$ENDECA_ROOT/lib/perl/Control:$ENDECA_ROOT/perl/lib:$ENDECA_ROOT/perl/lib/site_perl:$PERL5LIB
ENV ENDECA_CONF=$BASE_ENDECA_PATH/PlatformServices/workspace

#  ENDECA_REFERENCE_DIR points to the directory the reference implementations
#  are installed in.  It is not required to run any Oracle Commerce software.
ENV ENDECA_REFERENCE_DIR=$BASE_ENDECA_PATH/PlatformServices/reference

#######################################
# install Tools and Frameworks
#
# set prerequisite environment variables.

#ENV ENDECA_TOOLS_ROOT $BASE_INSTALL_PATH/ToolsAndFrameworks/11.1.0
#ENV ENDECA_TOOLS_CONF $BASE_INSTALL_PATH/ToolsAndFrameworks/11.1.0/server/workspace
ENV ENDECA_TOOLS_ROOT $BASE_ENDECA_PATH/ToolsAndFrameworks/11.1.0
ENV ENDECA_TOOLS_CONF $BASE_ENDECA_PATH/ToolsAndFrameworks/11.1.0/server/workspace

#Tools And Frameworks install
RUN chmod -R 777 $BASE_INSTALL_PATH
USER endeca

RUN $BASE_CONTAINER_TMP_PATH/cd/Disk1/install/silent_install.sh $BASE_CONTAINER_TMP_PATH/cd/Disk1/install/silent_response.rsp ToolsAndFrameworks $BASE_ENDECA_PATH/ToolsAndFrameworks admin

#######################################
# install CAS

ENV CAS_PORT 8500
ENV CAS_SHUTDOWN_PORT 8506
ENV CAS_HOST localhost

#create silent install text file
RUN echo $CAS_PORT > $BASE_CONTAINER_TMP_PATH/cas-silent.txt && \
    echo $CAS_SHUTDOWN_PORT >> $BASE_CONTAINER_TMP_PATH/cas-silent.txt && \
    echo $CAS_HOST >> $BASE_CONTAINER_TMP_PATH/cas-silent.txt

USER root
RUN chmod -R 777 $BASE_INSTALL_PATH
#RUN mkdir -m 0777 -p /apps/opt/weblogic
RUN $BASE_CONTAINER_TMP_PATH/OCcas11.1.0-Linux64.sh --silent --target $BASE_INSTALL_PATH < $BASE_CONTAINER_TMP_PATH/cas-silent.txt
#RUN $BASE_CONTAINER_TMP_PATH/OCcas11.1.0-Linux64.sh --silent --target /apps/opt/weblogic < $BASE_CONTAINER_TMP_PATH/cas-silent.txt

#######################################
# create apps directory
RUN mkdir $BASE_INSTALL_PATH/endeca/apps

#######################################
# set user and permissions to endeca
#RUN chown -R endeca.endeca /appl/endeca/

#######################################
# install is done start cleanup to remove initial packages
USER root
RUN rm -rf $BASE_CONTAINER_TMP_PATH

ENV AUTHORIZED_KEYS **None**

EXPOSE 22 8888 8500 8506 8006
#RUN ls -R $ENDECA_TOOLS_ROOT/server
ADD $REMOTE_SCRIPTS_PATH/start.sh /start.sh
ADD $REMOTE_SCRIPTS_PATH/run.sh /run.sh
ADD $REMOTE_SCRIPTS_PATH/set_root_pw.sh /set_root_pw.sh
RUN chmod 777 /start.sh && \
    chmod 777 /run.sh && \
    chmod 777 /set_root_pw.sh
RUN /start.sh

CMD ["/run.sh"]
