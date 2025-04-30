# Nginx性能分析

> 上游（Upstream）：
>
> - 代表后端服务（如应用服务器、数据库等）
> - 当Nginx作为反向代理时，上游是Nginx转发的目标服务器。
> - `$upstream_response_time` 表示**Nginx与上游服务器通信的总耗时**，包括建立连接、等待响应、接收响应头的时间
>
> 下游（Downstream）：
>
> - 代表客户端（如浏览器、移动App等）
> - 下游是向Nginx发起请求的终端用户或设备
> - `$request_time` 表示**客户端从发送请求到完整接收响应的总耗时**，涵盖网络传输、Nginx处理、等待上游响应等所有环节

## 日志配置

```nginx
# 定义慢上游响应标记，向后端服务请求的耗时
map "$upstream_response_time" $log_slow_upstream {
    default 0;
    "~^[1-9]\d*\.?\d*$" 1;  # 当上游响应时间 ≥1 秒时标记为 1
}

# 客户端接收请求到返回响应的总耗时
map "$request_time" $log_slow_request {
    default 0;
    "~^[1-9]\d*\.?\d*$" 1;  # 当请求总耗时 ≥1 秒时标记为 1
}

# 生成最终慢响应标记
map "$log_slow_upstream$log_slow_request" $log_slow_response {
    default 0;
    "~1.*" 1;  # 上游慢（如 "10"、"11"）
    ".*1" 1;   # 请求慢（如 "01"）
}

access_log /usr/local/nginx/logs/slow_response.log main  if=$log_slow_response;
```

> - 上游慢（`$log_slow_upstream=1`）：数据库查询慢、应用服务器性能瓶颈、上游网络延迟
> - 下游慢（`$log_slow_request=1`但`$log_slow_upstream=0`）：客户端网络差、响应体过大、Nginx到客户端的传输延迟