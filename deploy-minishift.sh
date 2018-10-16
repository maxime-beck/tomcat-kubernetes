#/bin/bash!

eval $(minishift docker-env)
docker login -u $(oc whoami) -p $(oc whoami -t) $(minishift openshift registry)
docker build -f Dockerfile.local --build-arg war=sample.war --build-arg registry_id=$(oc project -q) . -t $(minishift openshift registry)/$(oc project -q)/image
docker push $(minishift openshift registry)/$(oc project -q)/image
kubectl create -f deployment.yaml
kubectl scale deployment tomcat-in-the-cloud --replicas=3
kubectl create -f service.yaml
kubectl create -f route.yaml
