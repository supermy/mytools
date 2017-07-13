import com.google.gson.Gson
import com.yam.redis.JedisClusterPipeline
import redis.clients.jedis.JedisCluster

println "jcp redis script 准备"
//println batchEvents
//println clusterNodes

JedisCluster cluster = new JedisCluster(clusterNodes);
JedisClusterPipeline jcp = JedisClusterPipeline.pipelined(cluster);
jcp.refreshCluster();

//JedisClusterPipeline jcp=null;
gson = new Gson();



for (byte[] redisEvent : batchEvents) {

    String json = new String(redisEvent);

    Map m=gson.fromJson(json, HashMap.class);


    List<String> keys= (List<String>) m.get("keys");
    List<String> args= (List<String>) m.get("args");


    jcp.zadd(keys.get(1),keys.get(0),keys.get(2))
    //String scriptlua = m.get("script").toString();

    //jcp.eval(scriptlua,keys,args);

    // eval "return redis.call('ZADD','KEYS[1]',ARGV[1],ARGV[2])" 1 keyset   123  u123
//    Map full= new HashMap();
//    full.put("script","return redis.call('ZADD',KEYS[2],KEYS[1],KEYS[3])");
//    full.put("args",new ArrayList());
//    full.put("keys",split);

}


def resultMap = [:]

//resultMap["head"] = head
//resultMap["body"] = json

return resultMap