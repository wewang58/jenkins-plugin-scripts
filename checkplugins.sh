#!/bin/bash
#download plugins version expected file
wget -O base-plugins.txt https://raw.githubusercontent.com/openshift/jenkins/master/1/contrib/openshift/base-plugins.txt
#Check installed plugins in rhel jenkins
wget -O jenkins-cli.jar --no-check-certificate ${JENKINS_URL}/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s ${JENKINS_URL}  list-plugins >installed.txt
PLUGINS=(durable-task credentials workflow-aggregator workflow-durable-task-step workflow-step-api workflow-multibranch cloudbees-folder pipeline-stage-view jquery-detached handlebars momentjs workflow-remote-loader scm-api branch-api matrix-project multiple-scms pipeline-utility-steps script-security git-client git-server plain-credentials)
for  (( i=0; i<${#PLUGINS[@]} ; i++)) ; do
      pluginname=${PLUGINS[i]}
      grep -q "^$pluginname" installed.txt
      result=$?
      if [ $result != 0 ]; then
         echo "no $pluginname is installed!!!"
         continue
      fi 
      actualversion=`grep "^$pluginname" installed.txt|cut -d '(' -f1| awk -F ' ' '{printf"%s\n",$1 ":" $NF}'|awk -F ':' '{printf $2}'`
      expectedversion=`grep "^$pluginname" base-plugins.txt|cut -d: -f2`
      if [[ $expectedversion = $actualversion ]];then
         echo "$pluginname is updated to $expectedversion"
      else 
         echo "$pluginname is installed by $actualversion,not updated to $expectedversion"
      fi 
done

