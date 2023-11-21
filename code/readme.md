1. Install Ansible:

RHEL 8.6

```
subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms
yum -y install ansible
```

2. Install Python

- Ensure you have python 3.6 or later and [pip](https://pip.pypa.io/en/stable/installation/) 21.1.3 or later installed

  `python --version`

  `pip --version`

 To install pip on RHEL8.6:

```
wget https://bootstrap.pypa.io/pip/3.6/get-pip.py
python3 ./get-pip.py
```


  >NB: if your python interpreter is using `python3` or `python37` or other Python 3 executables, you can create a symlink for `python` using this command

  ```
  ln -s -f /usr/bin/python3 /usr/bin/python
 
  # OR depends on the Python 3 installation location
 
  ln -s -f /usr/local/bin/python3 /usr/local/bin/python
  ```

  >NB: if `pip` is not available or is an older version, run the command below to upgrade it, and then check its version again. If `pip` command
  can't be found after the below command, add `/usr/local/bin` into your PATH ENV variable.


  - Install ansible k8s modules

  `pip install openshift`

  Verify:

  `pip freeze  | grep kubernetes`


    >NB: the `openshift` package installation requires PyYAML >= 5.4.1, and if the existing PyYAML is an older version, then PyYAML's 
   installation will fail. To overcome this issue, manually delete the exsiting PyYAML package as below (adjust the paths in the commands 
   according to the your host environment):
   
   ```
   rm -rf /usr/lib64/python3.6/site-packages/yaml
   rm -f  /usr/lib64/python3.6/site-packages/PyYAML-*
   ```

Update params.yml file storage_class, docker_registry_username ,docker_registry_password

```
helm_version: "v3.9.4"

helm_chart_version: "0.0.24"
k8sgpt_model: "ggml-gpt4all-j"


storage_class: <your_storage_class>
image_pull_secret_name: docker-registry-secret
docker_registry_server: docker.io
docker_registry_username: <your_username>
docker_registry_password: <your_password>
```

Run playbook:

```
ansible-playbook main.yml --extra-vars "@./params.yml" -e ansible_python_interpreter=/usr/bin/python3  | tee output.log
```


Useful Ansible commands:

`ansible-galaxy collection list `


uninstall:
