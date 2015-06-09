local count = 0
local delayInSeconds = 6
local heartbeatCheck = nil
heartbeatCheck = function(args)
  count = count + 1
  ngx.log(ngx.ERR, "do check ", count)
  local ok, err = ngx.timer.at(delayInSeconds, heartbeatCheck)
  if not ok then
    ngx.log(ngx.ERR, "failed to startup heartbeart worker...", err)
  end
end
heartbeatCheck()