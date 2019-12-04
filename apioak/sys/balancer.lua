local _M = {}

function _M.init_worker()
    local balancer = require "ngx.balancer"
    local upstream = require "upstream"
    local upstream_name = 'mysvr3'
    local srvs = upstream.get_servers(upstream_name)
    local remote_ip = ngx.var.remote_addr
    local hash = ngx.crc32_long(remote_ip);
    hash = (hash % 2) + 1
    local backend = srvs[hash].addr
    local index = string.find(backend, ':')
    local host = string.sub(backend, 1, index - 1)
    local port = string.sub(backend, index + 1)
    ngx.log(ngx.DEBUG, "current peer ", host, ":", port)
    balancer.set_current_peer(host, tonumber(port))
    if not ok then
        ngx.log(ngx.ERR, "failed to set the current peer: ", err)
        return ngx.exit(500)
    end
end

return _M
