disconnect:
    runner.minion_connect.change_status_minion:
        - offline: {{ data.id }}