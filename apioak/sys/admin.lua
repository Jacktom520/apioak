local r3route = require("resty.r3")
local pdk = require("apioak.pdk")
local _M = {}

local resources = {
    routes = require("apioak.admin.routes"),
    upstreams = require("apioak.admin.upstreams"),
}

local router_handle = function(params)
    local res_id = params.res_id
    local res_name = params.res_name
    local method = string.lower(ngx.req.get_method())
    local resource = resources[res_name]
    if not resource or not resource[method] then
        ngx.exit(404)
    end
    ngx.req.read_body()
    local req_body = ngx.req.get_body_data()
    if req_body then
        local res, err = pdk.json.decode(req_body)
        if err then
            pdk.log.error(err)
            ngx.exit(404)
        end
        req_body = res
    end
    local code, body = resource[method](res_id, req_body)
    ngx.say(pdk.json.encode(body))
    ngx.exit(code)
end

local router

function _M.init_worker()
    router = r3route.new()
    router:insert_route("/apioak/admin/{res_name}/{res_id}", router_handle, { "GET", "PUT", "POST", "DELETE", "PATCH" })
    router:compile()
end

function _M.routers()
    return router
end

return _M
