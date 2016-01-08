local kube = import "libkube.jsonnet";
local util = import "util.jsonnet";

{
    RC(config):: {
        local default_config = {
            namespace: "default",
            labels: {
                name: "%s-%s" % [config.name, config.env],
                version: config.version,
            },
            container: {
                envvars: {
                    KUBE_ENV: config.env,
                },
                resources: {
                    memory_limit: "100m",
                    memory_requested: "100m",
                    cpu_limit: "1000",
                    cpu_requested: "1000",
                },
            }
        },
        local _config = util.merge(default_config, config),

        version: "v1",
        type: "ReplicationController",
        metadata: {
            name: _config.name,
            namespace: _config.namespace,
            labels: _config.labels,
        },

        spec: {
            replicas: 1,
            selector: _config.labels,
            template: {
                metadata: { 
                    labels: _config.labels,
                },
                spec: {
                    containers: [
                        {
                            name: config.name,
                            image: "%s/%s:%s" % [ config.container.image.repository,
                                                  config.container.image.name,
                                                  config.container.image.tag ],
                            env: util.pair_list(_config.container.envvars),
                            mounts: kube.v1.VolumeMounts(_config.container.mounts),
                            resources: {
                                limits: {
                                    memory: _config.container.resources.memory_limit,
                                    cpu: _config.container.resources.cpu_limit,
                                },
                                requests: {
                                    memory: _config.container.resources.memory_requested,
                                    cpu: _config.container.resources.cpu_requested,
                                }
                            },
                        },
                    ],
                    volumes: kube.v1.VolumeSources(_config.volumes),
                },
            },
        },
    },
}
