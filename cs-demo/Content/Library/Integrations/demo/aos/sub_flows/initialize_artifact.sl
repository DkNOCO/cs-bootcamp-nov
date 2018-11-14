namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.87
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_tomcat.sh'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: on_failure
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - SUCCESS: execute_script
          - FAILURE: on_failure
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_script
          - FAILURE: delete_script
    - delete_script:
        do:
          Integrations.demo.aos.tools.delete_file:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - filename: '${script_name}'
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': FAILURE
          - 'FALSE': SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 375
        y: 23
      copy_artifact:
        x: 143
        y: 108
      copy_script:
        x: 498
        y: 111
      execute_script:
        x: 100
        y: 280
      delete_script:
        x: 355
        y: 310
      has_failed:
        x: 577
        y: 302
        navigate:
          35ad8850-638b-0861-a9ef-df01129b15ef:
            targetId: 264c7d18-74ba-7a67-0fbf-184c93e504ad
            port: 'TRUE'
          87fe0867-85d0-74fc-c034-77b8c6a67729:
            targetId: 1df37f41-a452-385f-8496-02662dde9727
            port: 'FALSE'
    results:
      SUCCESS:
        c04f0d72-b0fd-6310-2aef-506d132cc5b5:
          x: 997
          y: 234
        1df37f41-a452-385f-8496-02662dde9727:
          x: 747
          y: 227
      FAILURE:
        64112d57-fc93-5aa2-af73-12ddcf900609:
          x: 1004
          y: 369
        264c7d18-74ba-7a67-0fbf-184c93e504ad:
          x: 692
          y: 385
