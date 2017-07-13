println "redis groovy ......"
println head
println body




import redis.clients.jedis.*
import redis.clients.jedis.exceptions.JedisConnectionException


@Singleton
public class SingleRedis {




    //synchronized
    private JedisPool jedisPool;
    public   Jedis getJedisConnection(String host,Integer port) {		// koushik: removed static
        try {
            if (jedisPool == null) {
                JedisPoolConfig config = new JedisPoolConfig();
                //config.setMaxTotal(100);
                config.setMaxIdle(50);
                config.setMinIdle(20);
                //config.setMaxWaitMillis(30000);

                jedisPool = new JedisPool(config, host, port);

            }
            return jedisPool.getResource();
        } catch (JedisConnectionException e) {

            e.printStackTrace();
            throw e;
        }
    }


    //普通的方法
    public void singleMethor() {
        System.out.println ("singleMethor");
    }

}

try {

//    Jedis jedis = new Jedis("172.20.149.158");
    Jedis jedis = SingleRedis.instance.getJedisConnection("172.20.149.158",6379);


    jedis.set("foo", "bar1")
    assert jedis.get("foo") == "bar1"

    System.out.println("88888888");
} catch(Exception e1) {
    e1.printStackTrace();

}





return true