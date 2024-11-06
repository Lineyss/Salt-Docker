connect:
    runner.minion_connect.change_status_minion:
        - online: {{ [data.id] | list }}
        - offline: {{ [] | list }}