chage_state:
  runner.minion_connect.change_status_minion:
    - online: {{ data['new'] | list }}
    - offline: {{ data['lost'] | list }}