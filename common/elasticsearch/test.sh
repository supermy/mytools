#!/usr/bin/env bash
curl -XPUT http://133.224.220.65:9200/iktest
curl "http://133.224.220.65:9200/iktest/_analyze?pretty&analyzer=standard&text=%E4%B8%AD%E5%8D%8E%E4%BA%BA%E6%B0%91%E5%85%B1%E5%92%8C%E5%9B%BD"
curl "http://133.224.220.65:9200/iktest/_analyze?pretty&analyzer=ik_smart&text=中华人民共和国"
curl "http://133.224.220.65:9200/iktest/_analyze?pretty&analyzer=ik_max_word&text=中华人民共和国"

curl -XPOST http://133.224.220.65:9200/index/fulltext/_mapping -d'
{
    "fulltext": {
             "_all": {
            "analyzer": "ik_max_word",
            "search_analyzer": "ik_max_word",
            "term_vector": "no",
            "store": "false"
        },
        "properties": {
            "content": {
                "type": "string",
                "store": "no",
                "term_vector": "with_positions_offsets",
                "analyzer": "ik_max_word",
                "search_analyzer": "ik_max_word",
                "include_in_all": "true",
                "boost": 8
            }
        }
    }
}'

curl -XPOST http://133.224.220.65:9200/index/fulltext/1 -d'
{"content":"美国留给伊拉克的是个烂摊子吗"}
'

curl -XPOST http://133.224.220.65:9200/index/fulltext/2 -d'
{"content":"公安部：各地校车将享最高路权"}
'
curl -XPOST http://133.224.220.65:9200/index/fulltext/3 -d'
{"content":"中韩渔警冲突调查：韩警平均每天扣1艘中国渔船"}
'
curl -XPOST http://133.224.220.65:9200/index/fulltext/4 -d'
{"content":"中国驻洛杉矶领事馆遭亚裔男子枪击 嫌犯已自首"}
'

curl -XPOST http://133.224.220.65:9200/index/fulltext/_search  -d'
{
    "query" : { "term" : { "content" : "中国" }},
    "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "content" : {}
        }
    }
}