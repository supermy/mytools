2016-12-18
##haproxy 高性能的代理
/etc/haproxy/haproxy.cfg为haproxy的主配置文件，里面包括全局配置段（global settings）和代理配置段（proxies）。
global settings：主要用于定义haproxy进程管理安全及性能相关的参数
proxies：代理相关的配置可以有如下几个配置端组成。
 - defaults <name>：为其它配置段提供默认参数，默认配置参数可由下一个“defaults”重新设定。
 - frontend <name>：定义一系列监听的套接字，这些套接字可接受客户端请求并与之建立连接。
 - backend  <name>：定义“后端”服务器，前端代理服务器将会把客户端的请求调度至这些服务器。
 - listen   <name>：定义监听的套接字和后端的服务器。类似于将frontend和backend段放在一起 

HAproxy的工作模式：
HAProxy的工作模式一般有两种：tcp模式和http模式。
tcp模式：实例运行于TCP模式，在客户端和服务器端之间将建立一个全双工的连接，且不会对7层报文做任何类型的检查，只能以简单模式工作。此为默认模式，通常用于SSL、SSH、SMTP等应用。
http模式：实例运行于HTTP模式，客户端请求在转发至后端服务器之前将被深度分析，所有不与RFC格式兼容的请求都会被拒绝。
当实现内容交换时，前端和后端必须工作于同一种模式(一般都是HTTP模式)，否则将无法启动实例。工作模式可通过mode参数在default，frontend，listen，backend中实现定义。
1
mode {tcp|http}

   
    