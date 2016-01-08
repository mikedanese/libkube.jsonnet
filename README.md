# Kubernetes and Jsonnet

https://github.com/google/jsonnet

Run:

```console
$ jsonnet example.jsonnet
```

Get

```json
{
   "metadata": {
      "labels": {
         "name": "redis-dev",
         "tier": "backend",
         "version": "v4"
      },
      "name": "redis",
      "namespace": "default"
   },
   "spec": {
      "replicas": 1,
      "selector": {
         "name": "redis-dev",
         "tier": "backend",
         "version": "v4"
      },
      "template": {
         "metadata": {
            "labels": {
               "name": "redis-dev",
               "tier": "backend",
               "version": "v4"
            }
         },
         "spec": {
            "containers": [
               {
                  "env": [
                     {
                        "name": "KUBE_ENV",
                        "value": "dev"
                     },
                     {
                        "name": "PASSWORD",
                        "value": "foo"
                     }
                  ],
                  "image": "gcr.io/blah/pipeline_image:latest",
                  "mounts": [
                     {
                        "mountPath": "/data",
                        "name": "data",
                        "readonly": false
                     },
                     {
                        "mountPath": "/ebs",
                        "name": "ebs1",
                        "readonly": false
                     },
                     {
                        "mountPath": "/var/logs",
                        "name": "logs",
                        "readonly": false
                     }
                  ],
                  "name": "redis",
                  "resources": {
                     "limits": {
                        "cpu": "1000",
                        "memory": "100m"
                     },
                     "requests": {
                        "cpu": "1000",
                        "memory": "100m"
                     }
                  }
               }
            ],
            "volumes": [
               {
                  "awsElasticBlockStore": {
                     "volumeID": "i-8467"
                  },
                  "name": "ebs1"
               },
               {
                  "hostPath": {
                     "path": "/var/lib/data"
                  },
                  "name": "data"
               },
               {
                  "hostPath": {
                     "path": "/var/log"
                  },
                  "name": "logs"
               }
            ]
         }
      }
   },
   "type": "ReplicationController",
   "version": "v1"
}
```

Put it all together:
```console
$ jsonnet example.jsonnet | kubectl create -f -
```
