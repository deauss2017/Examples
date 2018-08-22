#!/bin/bash
Path=/root/k8s/k8s-app/allservice
count1=$(cat $Path/all-service.txt|wc -l)
n=0
for i in $(cat $Path/all-service.txt)
do
    sed -i "28s#image:.*#image: 172.16.105.147:5000/saas/production/service/com-dyrs-mtsp-$i:0.1#g"  deployment.yaml
    sed -i "5s#name:.*#name: $i#g" deployment.yaml
    sed -i "s/application:.*/application: com-dyrs-mtsp-$i/g" deployment.yaml
    sed -i "s/claimName:.*/claimName: rc-$i/g" deployment.yaml


    sed -i "5s#name:.*#name: $i#g" service.yaml
    sed -i "s/application:.*/application: icom-dyrs-mtsp-$i/g" service.yaml

    sed -i "s#name:.*#name: $i-ingress#g" ingress.yaml
    sed -i "13s/host:.*/host: $i\.rc.saas.dyrs.online/g" ingress.yaml
    sed -i "s/serviceName:.*/serviceName: $i/g" ingress.yaml
    sed -i "20s/host:.*/host: $i\.mysql.rc.saas.dyrs.online/g" ingress.yaml

    sed -i "s/application:.*/application: com-dyrs-mtsp-rc-$i/g" $Path/pv.yaml
    sed -i "s#name:.*#name: rc-$i#g" $Path/pv.yaml
    sed -i "s#path:.*#path: /rc-$i#g" $Path/pv.yaml
    sed -i "s/storageClassName:.*/storageClassName: rc-$i/g" $Path/pv.yaml
    
    sed -i "s#name:.*#name: rc-$i#g" $Path/pvc.yaml
    sed -i "s/application:.*/application: com-dyrs-mtsp-rc-$i/g" $Path/pvc.yaml
    sed -i "s/storageClassName:.*/storageClassName: rc-$i/g" $Path/pvc.yaml


    kubectl apply -f $Path/pv.yaml
    kubectl apply -f $Path/pvc.yaml
    sleep 2
    kubectl apply -f $Path/all-server.yaml
    kubectl apply -f $Path/service.yaml
    kubectl apply -f $Path/ingress.yaml
    echo "$i 服务已经部署完了，20秒后将创建下一个服务"
    sleep 20
    let "n++" 
done
numl=$(( $count1 - $n ))
if [ $numl -eq 0 ]
then 
   echo "您的服务全部部署完成"
else
   echo “您还差 $numl 个服务没有启动”
fi

