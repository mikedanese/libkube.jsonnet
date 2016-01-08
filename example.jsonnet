local templates = import "kubetemplates.jsonnet";

local config = {
    name: "redis",
    env: "dev",
    version: "v4",
    labels: {
        "tier": "backend",
    },
    container: {
        image: {
            repository: "mddanese",
            name: config.name,
            tag: config.version,
        },
        port: 6379,
        envvars: {
            PASSWORD: "foo",
        },
        mounts: {
            "data": "/data",
            "logs": "/var/logs",
            "ebs1":  "/ebs",
        },
    },
    volumes: {
        host: {
            "data": "/var/lib/data",
            "logs": "/var/log",
        },
        ebs: {
            "ebs1": "i-8467",
        },
    },
};

templates.RC(config)
