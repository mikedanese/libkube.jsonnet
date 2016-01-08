{
    v1:: {

        local ApiVersion = { apiVersion: "v1" },

        local Metadata(name) = {
            metadata: {
            name: name,
                labels: {
                    name: name,
                },
            },
        },

        ReplicationController(name): ApiVersion + Metadata(name) {
            kind: "ReplicationController",
        },

        Service(name): ApiVersion + Metadata(name) {
            kind: "Service",
        },

        List: ApiVersion + {
            kind: "List",
        },

        VolumeMounts(tab)::
            [{name: k, mountPath: tab[k], readonly: false} for k in std.objectFields(tab)],

        HostVolumes(tab)::
            [{name: k, hostPath: {path: tab[k]}} for k in std.objectFields(tab)],

        EBSVolumes(tab)::
            [{name: k, awsElasticBlockStore: {volumeID: tab[k]}} for k in std.objectFields(tab)],

        VolumeSources(obj)::
            self.EBSVolumes(obj.ebs) + self.HostVolumes(obj.host),
    },

    extensions:: {
        v1beta1:: {
            local ApiVersion = { apiVersion: "v1beta1" }
        },
    },
}
