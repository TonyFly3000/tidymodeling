# -*- coding: utf-8 -*-
# @place: Pudong, Shanghai
# @file: make_empty_record.py
# @time: 2024/5/2 14:34
import json
from datetime import datetime
from uuid import uuid4

item_id = str(uuid4())
print("empty data: ", item_id)
data = {
        'item_id': item_id,
        'news_channel': '',
        'title': '',
        'report': '',
        'original_websites': '',
        'start_date': datetime.now().strftime('%Y-%m-%d'),
        'start_time': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'update_time': datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        'incident_type': '',
        'incident_reason': '',
        'person_death_num': 0,
        'person_injury_num': 0,
        'person_missing_num': 0,
        'location': [],
        'place': '',
        'province': '',
        'city': '',
        'county': '',
        'town': '',
        'village': '',
        'is_final': False
}

file_name = f'../elk/data/{item_id}.json'
with open(file_name, 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=4)
    f.write('\n')
