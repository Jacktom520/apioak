local ngx_balancer     = require "ngx.balancer"
local get_last_failure = ngx_balancer.get_last_failure
local set_current_peer = ngx_balancer.set_current_peer
local set_timeouts     = ngx_balancer.set_timeouts
local set_more_tries   = ngx_balancer.set_more_tries
local pdk = require("apioak.pdk")
local tonumber = tonumber
local ngx_crc32_long = ngx.crc32_long
local ngx_exit = ngx.exit
local ngx_var = ngx.var
local upstream = require("apioak.sys.upstream")

local _M = {}

function _M.init_worker()

end

function _M.go()
    local upstream_name = 'service_name'
    local srvs = upstream.get_upstreams()
    local remote_ip = ngx_var.remote_addr
    local hash = ngx_crc32_long(remote_ip);
    local server_count = #srvs
    hash = (hash % server_count) + 1
    local host = srvs[hash].host
    local port = srvs[hash].port
    pdk.log.error("current peer ", host, ":", port)
    local ok, err = set_current_peer(host, port)
    if not ok then
        pdk.log.error( "failed to set the current peer: ", err)
        ngx_exit(500)
    end
end

return _M
