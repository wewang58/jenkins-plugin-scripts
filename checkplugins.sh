#!/bin/bash
#download plugins version expected file
wget -O base-plugins.txt https://raw.githubusercontent.com/openshift/jenkins/master/1/contrib/openshift/base-plugins.txt
#Check installed plugins in rhel jenkins
java -jar /root/Downloads/jenkins-cli.jar -s http://localhost:8080/ list-plugins >installed.txt
PLUGINS=(openshift-pipeline credentials workflow-aggregator workflow-durable-task-step workflow-step-api workflow-multibranch cloudbees-folder pipeline-stage-view jquery-detached)
for  (( i=0; i<${#PLUGINS[@]} ; i++)) ; do
      pluginname=${PLUGINS[i]}
      expectedversion=`grep "^$pluginname" base-plugins.txt|cut -d: -f2`
      actualversion=`grep "^$pluginname" installed.txt|cut -d '(' -f1| awk -F ' ' '{printf"%s\n",$1 ":" $NF}'|awk -F ':' '{printf $2}'`
      if [[ $expectedversion = $actualversion ]];then
         echo "$pluginname is updated to $expectedversion"
      else 
         echo "$pluginname is installed by version $actualversion,not updated to $expectedversion"
      fi 
done

