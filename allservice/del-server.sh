#!/bin/bash
Path=/root/k8s/k8s-app/allservice
for i in $(cat $Path/all-service.txt)
do
    sed -i "27s#image:.*#image: 172.16.105.147:5000/saas/rc/service/com-dyrs-mtsp-$i:0.1#g"  deployment.yaml
    sed -i "5s#name:.*#name: $i#g" deployment.yaml
    sed -i "s/application:.*/application: $i/g" deployment.yaml
    sed -i "66s/claimName:.*/claimName: rc-$i/g" deployment.yaml
    sed -i "5s#name:.*#name: $i#g" $Path/service.yaml
    sed -i "s/application:.*/application: $i/g" $Path/service.yaml
    sed -i "s#name:.*#name: $i-ingress#g" $Path/ingress.yaml
    sed -i "8s/host:.*/host: $i\.rc.saas.dyrs.online/g" $Path/ingress.yaml
    sed -i "s/serviceName:.*/serviceName: $i/g" $Path/ingress.yaml
    sed -i "15s/host:.*/host: $i\.mysql.rc.saas.dyrs.online/g" $Path/ingress.yaml 
    
    kubectl delete -f deployment.yaml
    kubectl delete -f service.yaml
    kubectl delete -f ingress.yaml
done
