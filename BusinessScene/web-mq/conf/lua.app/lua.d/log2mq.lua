--if ngx.ctx.logcontent  then
--    ngx.log(ngx.ERR, ngx.ctx.logcontent)
--end

ngx.ctx.data = data
ngx.ctx.url = url
ngx.ctx.args = args

--http.lua:90: API disabled in the context of log_by_lua*
