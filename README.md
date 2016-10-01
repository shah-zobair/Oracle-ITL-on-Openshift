# Oracle ITL and MDEX on OpenShift


Oracle ITL 11.1.0

Oracle MDEX 6.5.1

Oracle Tools and Framework

Oracle Platform Service

Oracle CAS (Content Acquisition System) 11.1.0


1) Build the base image on docker with Dockerfile.base which requires some supporting files(scripts,tools,support,installables). 
2) Tag the base image (Use OpenShift internal registry IP and Port)
```
docker tag oc_base 172.30.144.230:5000/openshift/oc_base
```

3) Login to Openshift with image:push authorizaton (not as system:admin)
```
oc login -u <USER>
```

4) Generate token for login to OpenShift internal registry
```
oc whoami -t
```
Copy the Generated Token

5) Login to OpenShift internal registry
```
docker login -u <USER> -e a@b.com -p <Generated_Token> <Registry_IP>:5000
```

6) Push the image to internal registry
```
docker push 172.30.144.230:5000/openshift/oc_base
```

7) Build and deploy the application using "itl" template. Create the project with the following privilege:
```
oc new project endeca
oc project endeca
oadm policy add-scc-to-user anyuid -z default
```
