{% if data['fun'] == 'minion.all_info' %}

save_minion_info:
   runner.minion_info.save:
     - info: {{ data['return'] }}
     - minion_id: '{{ data["id"] }}'

{% endif %}