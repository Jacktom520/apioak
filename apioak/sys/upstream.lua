local pdk = require("apioak.pdk")
local cjson = pdk.json
local etcd = pdk.etcd.new()
local shared = ngx.shared
local _M = {}

function _M.update_upstreams()
    local servers = {
        {
            host = "127.0.0.1",
            port = "10111"
        },
        {
            host = "127.0.0.1",
            port = "10222"
        },
    }
    local server_list = cjson.encode(servers)
    local res, err = etcd.set('server_list', server_list)
    if err then
        return nil, err
    end
    local list = etcd.get('server_list')
    return  list
    --local upstreams = {}
    --for i, v in ipairs(servers) do
    --    upstreams[i + 1] = { ip = v.Address, port = v.ServicePort }
    --end
    --shared.upstream_list:set("sys_upstreams", cjson.encode(upstreams))
end

function _M.get_upstreams()
    local upstreams_str = ngx.shared.upstream_list:get("sys_upstreams")
    return upstreams_str
end

return _M
