{
    local util = self,

    pair_list_ex(tab, kfield, vfield)::
        [{[kfield]: k, [vfield]: tab[k]} for k in std.objectFields(tab)],

    pair_list(tab)::
        self.pair_list_ex(tab, "name", "value"),

    env_var_or(variable, default)::
        if std.extVar(variable) then std.env(variable) else default,

    merge(target, patch)::
        if std.type(patch) == "object" then
            local _1 =
                if std.type(target) != "object" then
                    {}
                else
                    target;
            local _2 =
                { [k]: null
                    for k in std.objectFields(patch)
                        if patch[k] == null &&
                            std.objectHas(_1, k)};
            local _3 =
                { [k]: patch[k]
                    for k in std.objectFields(patch)
                        if patch[k] != null &&
                            !std.objectHas(_1, k)};
            local _4 =
                { [k]: util.merge(_1[k], patch[k])
                    for k in std.objectFields(patch)
                        if patch[k] != null &&
                            std.objectHas(_1, k)};
            _1 + _2 + _3 + _4
        else
            patch
}
