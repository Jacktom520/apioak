local pdk = require("apioak.pdk")
local cjson = pdk.json
local etcd = pdk.etcd
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
    local upstream_responses = etcd.get('server_list')
    local upstream_body = upstream_responses.body
    local upstream_servers = {}
    if not upstream_body.node or not upstream_body.node.value then
        pdk.log.error("[sys.upstream] servers not set")
    else
        upstream_servers = cjson.decode(upstream_body.node.value)
    end
    etcd.set("server_name", upstream_servers, 0)
end

function _M.get_upstreams()
    local upstreams_str = etcd.get("server_name")
    return upstreams_str
end

return _M
