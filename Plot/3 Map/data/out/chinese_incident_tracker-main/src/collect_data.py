# -*- coding: utf-8 -*-
# @place: Pudong, Shanghai
# @file: collect_data.py
# @time: 2024/5/2 21:13
import json
import os
from uuid import uuid4

content = []
for file in os.listdir('../elk/data'):
    if file.endswith('.json'):
        with open(f'../elk/data/{file}', 'r', encoding='utf-8') as f:
            content.append(json.loads(f.read()))

# if the directory exists, remove it
if not os.path.exists('../elk/logstash/data/my_data'):
    os.makedirs('../elk/logstash/data/my_data')
# if other json exists in the directory, remove them
for file in os.listdir('../elk/logstash/data/my_data'):
    if file.endswith('.json'):
        os.remove(f'../elk/logstash/data/my_data/{file}')

new_json_file_name = f"{str(uuid4())}.json"
print("collect data: ", new_json_file_name)
with open(f'../elk/logstash/data/my_data/{new_json_file_name}', 'w', encoding='utf-8') as f:
    for line in content:
        f.write(json.dumps(line, ensure_ascii=False))
        f.write('\n')
