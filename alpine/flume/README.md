#flume-fastetl

##介绍

在数据采集端，利用采集设备的能力对大数据进行进行实时的 ETL 处理；采用 Redis 等作为全量数据计算引擎；特色是采用 groovy 作为规则语言，能够完成各种条件的处理。

业务场景1：RuleSearchAndReplaceInterceptor， 互联网算进行数据传输的安全，通过拦截器进行加密解密；官方原有的正则不能实现此功能。

业务场景2：RuleFilteringInterceptor， 数据条件过滤，可以通过groovy 脚本进行条件过滤，非常灵活；官方原有的正则不支持条件。

业务场景3：RuleSearchAndReplaceInterceptor，数据格式变更，可以通过groovy 脚本进行数据格式转换；官方可以通过正则完成，效率较低。

业务场景3：RuleSearchAndReplaceInterceptor，定制head 属性，可以通过groovy 脚本配置head 属性；官方配置较为复杂，不能支持灵活业务。

[new]业务场景4：支持内容过滤；支持将内容转换为 redis-lua 支持的脚本，支持 flume-redis 组件进行数据处理。

[new]业务场景5：将采集到数据通过 Redis Lua 进行 ETL,千亿级（RedisClusterZrangeByScoreSink 时间序列计算 60w/s）的数据进行统计与抽取进行毫秒级的实时处理。


## Install

安装:

    下载 flume7.0，解压；
    拷贝 conf 目录到 flume 目录；
    拷贝 plugins.d 到 flume 目录；

性能优化：

    修改 flume/bin/flume-ng
   
    JAVA_OPTS="-Xms2048m -Xmx2048m -Xss256k -Xmn2g -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:-UseGCOverheadLimit"
    export JAVA_OPTS=”-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=5445 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false”  
    -Dflume.monitoring.type=http -Dflume.monitoring.port=34545  


## Usage

    
    conf 目录中各种业务场景配置文件；
    conf 最后一行的运营指令；
    
        

### g-filter.groovy

过滤脚本，可以使用head and body 的数据作为条件 判定词条数据是否过滤

```  groovy

    //当它的值为true 不过滤
    println "netuser filter"
    //println head
    //println body
    body = "20170621162925,113.225.23.151,test_10056368,1"
    //body = "20170621162925,113.225.23.152,test_10056368,3"
    
    def split = body.split(",")
    
    println split.size()
    
    if(split.size()<4){
        //数据不合格过滤
        return false;
    }
    
    def type = split[3]
    
    println type.getClass()
    println type.substring(0,1) == '1'
    //println type.toInteger() == 1
    
    if (type.substring(0,1) == '1' || type.substring(0,1) == '2') {
        return true;  //不过滤
    } else {
        return false; //过滤
    }

```



### g-search-replace.groovy

替换脚本，可以更改head and body 的数据，适配不同的业务场景，脚本支持动态更新；

``` groovy 加密场景

        import  com.supermy.flume.interceptor.*
        import javax.crypto.Cipher;
        import javax.crypto.spec.SecretKeySpec;
        
        println head
        println body
        body=body.replace('a','aaa')
        head["newhead"]='abcd'
        
        
        
        String text = "Body 的数据 , I Love BONC"
        
        //
        def key = new SecretKeySpec("123456789987654321".bytes, "AES")
        def c = Cipher.getInstance("AES")
        
        //加密
        c.init(Cipher.ENCRYPT_MODE, key)
        e_text = new String(Hex.encodeHex(c.doFinal(text.getBytes("UTF-8"))))
        
        //解密
        c.init(Cipher.DECRYPT_MODE, key)
        text1 = new String(c.doFinal(Hex.decodeHex(e_text.toCharArray())))
        
        println text
        println e_text
        println text1
        
        
        def resultMap = [:]
        
        //加密数据，用于互联网数据传输
        
        
        resultMap["head"]=head
        resultMap["body"]=body
        
        return resultMap

```

``` groovy redis-lua 场景

    import com.google.gson.Gson
    
    //数据加工为 lua 脚本，插入到 redis
    println "netuser redis script 准备"
    //println head
    //println body
    
    //body = "20170621162925,113.225.23.151,test_10056368,1"
    body = "20170621162925,113.225.23.152,test_10056368,2"
    // eval "return redis.call('ZADD','KEYS[1]',ARGV[1],ARGV[2])" 1 keyset   123  u123
    
    
    
    def split = body.split(",")
    
    
    
    def type = split[3]
    if (type.substring(0,1) == '1') {
        split[2]=split[2]+"@Start";
    } else {
        split[2]=split[2]+"@End";
    }
    
    Gson gson = new Gson();
    
    Map full= new HashMap();
    full.put("script","return redis.call('ZADD',KEYS[2],KEYS[1],KEYS[3])");
    full.put("args",new ArrayList());
    full.put("keys",split);
    
    String json = gson.toJson(full);
    println json
    
    Map m=gson.fromJson(json, HashMap.class);
    println m
    
    
    //StringBuffer sb = new StringBuffer("return redis.call('ZADD','");
    //
    //sb.append(split[1]).append("',").append(split[0]).append(",'").append(split[2]);
    //if (type.substring(0,1) == '1') {
    //    sb.append("@Start'");
    //} else {
    //    sb.append("@End'");
    //}
    //sb.append(")");
    //println sb
    
    def resultMap = [:]
    
    resultMap["head"] = head
    resultMap["body"] = json
    
    return resultMap

```