# -*- coding: utf-8 -*-
# @place: Pudong, Shanghai
# @file: create_index.py
# @time: 2024/5/2 19:39
from elasticsearch import Elasticsearch

# 连接Elasticsearch
es_client = Elasticsearch("http://localhost:9200")

# 创建新的ES index
mapping = {
    'properties': {
        'item_id': {
            'type': 'keyword'
        },
        'news_channel': {
            'type': 'keyword'
        },
        'title': {
            'type': 'text',
            'fields': {
                "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                }
            },
            'analyzer': 'ik_max_word',
            'search_analyzer': 'ik_smart'
        },
        'report': {
            'type': 'text',
            'fields': {
                "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                }
            },
            'analyzer': 'ik_max_word',
            'search_analyzer': 'ik_smart'
        },
        "original_websites": {
            "type": "text",
            "fields": {
                "keyword": {
                    "type": "keyword",
                    "ignore_above": 256
                }
            }
        },
        'start_time': {
            'type': 'date',
            'format': 'yyyy-MM-dd HH:mm:ss'
        },
        'start_date': {
            'type': 'date',
            'format': 'yyyy-MM-dd'
        },
        'update_time': {
            'type': 'date',
            'format': 'yyyy-MM-dd HH:mm:ss'
        },
        'person_death_num': {
            'type': 'integer'
        },
        'person_injury_num': {
            'type': 'integer'
        },
        'person_missing_num': {
            'type': 'integer'
        },
        'incident_type': {
            'type': 'keyword'
        },
        'incident_reason': {
            'type': 'text',
            'analyzer': 'ik_max_word',
            'search_analyzer': 'ik_smart'
        },
        'place': {
            'type': 'keyword'
        },
        'province': {
            'type': 'keyword'
        },
        'city': {
            'type': 'keyword'
        },
        'county': {
            'type': 'keyword'
        },
        'town': {
            'type': 'keyword'
        },
        'village': {
            'type': 'keyword'
        },
        'location': {
            'type': 'geo_point'
        },
        'is_final': {
            'type': 'boolean'
        }
    }
}

es_client.indices.create(index='china_incidents', ignore=400)
result = es_client.indices.put_mapping(index='china_incidents', body=mapping)
print(result)
