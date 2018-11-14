namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploty_wars
  inputs:
    - tomcat_host
    - account_service_host
    - db_host
    - username
    - password
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/'
  results: []
