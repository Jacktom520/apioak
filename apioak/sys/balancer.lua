local ngx_balancer = require "ngx.balancer"
local set_current_peer = ngx_balancer.set_current_peer
local pdk = require("apioak.pdk")
--local ngx_crc32_long = ngx.crc32_long
--local ngx_exit = ngx.exit
--local ngx_var = ngx.var
local roundrobin  = require("resty.roundrobin")
local resty_chash = require("resty.chash")
--local remote_ip = ngx_var.remote_addr

local _M = {}

function _M.init_worker()

end

--local function chash(service)
--    local hash = ngx_crc32_long(remote_ip);
--    local server_count = #service
--    hash = (hash % server_count) + 1
--    local host = service[hash].host or ''
--    local port = service[hash].port or 80
--    return host, port
--end

function _M.go(oak_ctx)
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
    local upstream = oak_ctx.upstream or {}
    if upstream.type == 'chash' then
        resty_chash.
        pdk.log.error("upstream param is err ")
    end
    --local host = '127.0.0.1'
    --local port = 80
    --if type == 'roundrobin' then
    --    host, port = roundrobin(upstream)
    --else
    --    host, port = chash(upstream)
    --end
    --pdk.log.error("current peer ", host, ":", port)
    --local ok, err = set_current_peer(host, port)
    --if not ok then
    --    pdk.log.error("failed to set the current peer: ", err)
    --    ngx_exit(500)
    --end
end

return _M
