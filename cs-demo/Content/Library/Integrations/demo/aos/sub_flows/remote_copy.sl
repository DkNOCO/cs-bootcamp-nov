namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.87
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/accountservice/target/accountservice.war'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      extract_filename:
        x: 177
        y: 131
      remote_secure_copy:
        x: 583
        y: 140
        navigate:
          11059992-16a8-ef1f-1e13-9c5063162043:
            targetId: 1b6590cc-0070-ec17-d857-8ded721456c2
            port: SUCCESS
      get_file:
        x: 376
        y: 140
    results:
      SUCCESS:
        1b6590cc-0070-ec17-d857-8ded721456c2:
          x: 803
          y: 161
      FAILURE:
        6846a464-126f-bec1-b9ae-43a762d8e6dd:
          x: 336
          y: 475
