namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.87
    - username: root
    - password: admin@123
    - filename: accountservice.war
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 349
        y: 118
        navigate:
          10de6da9-53c1-2acd-1dab-f6231e3c90ba:
            targetId: d502ed08-3a3c-a568-5c1e-ed6eba11fa2f
            port: SUCCESS
          fe6d2138-af69-9d7f-6b33-2c4031ae5906:
            targetId: 8a290b49-a294-ad42-d446-98551138171a
            port: FAILURE
    results:
      SUCCESS:
        d502ed08-3a3c-a568-5c1e-ed6eba11fa2f:
          x: 744
          y: 161
      FAILURE:
        8a290b49-a294-ad42-d446-98551138171a:
          x: 458
          y: 361
