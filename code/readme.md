1. Install Ansible:

RHEL 8.6

```
subscription-manager repos --enable ansible-2.9-for-rhel-8-x86_64-rpms
yum -y install ansible
```


2. Run playbook:

```
ansible-playbook main.yml
```

Errors:

ansible-playbook main.yml --extra-vars "@./params.yml" | tee output.log
[WARNING]: provided hosts list is empty, only localhost is available. Note that
the implicit localhost does not match 'all'
ERROR! couldn't resolve module/action 'community.general.helm_repository'. This often indicates a misspelling, missing collection, or incorrect module path.

Useful Ansible commands:

ansible-galaxy collection list 

Install pip on RHEL8.6:

wget https://bootstrap.pypa.io/pip/3.6/get-pip.py
python3 ./get-pip.py

```
pip --version
pip 21.3.1 from /usr/local/lib/python3.6/site-packages/pip (python 3.6)

python --version
Python 3.6.8

pip install openshift
Requirement already satisfied: openshift in /usr/local/lib/python3.6/site-packages (0.13.2)
Requirement already satisfied: six in /usr/lib/python3.6/site-packages (from openshift) (1.11.0)
Requirement already satisfied: kubernetes>=12.0 in /usr/local/lib/python3.6/site-packages (from openshift) (28.1.0)
Requirement already satisfied: python-string-utils in /usr/local/lib/python3.6/site-packages (from openshift) (1.0.0)
Requirement already satisfied: requests-oauthlib in /usr/local/lib/python3.6/site-packages (from kubernetes>=12.0->openshift) (1.3.1)
Requirement already satisfied: oauthlib>=3.2.2 in /usr/local/lib/python3.6/site-packages (from kubernetes>=12.0->openshift) (3.2.2)
Requirement already satisfied: pyyaml>=5.4.1 in /usr/local/lib64/python3.6/site-packages (from kubernetes>=12.0->openshift) (6.0.1)
Requirement already satisfied: websocket-client!=0.40.0,!=0.41.*,!=0.42.*,>=0.32.0 in /usr/local/lib/python3.6/site-packages (from kubernetes>=12.0->openshift) (1.3.1)
Requirement already satisfied: python-dateutil>=2.5.3 in /usr/lib/python3.6/site-packages (from kubernetes>=12.0->openshift) (2.6.1)
Requirement already satisfied: requests in /usr/lib/python3.6/site-packages (from kubernetes>=12.0->openshift) (2.20.0)
Requirement already satisfied: urllib3<2.0,>=1.24.2 in /usr/lib/python3.6/site-packages (from kubernetes>=12.0->openshift) (1.24.2)
Requirement already satisfied: google-auth>=1.0.1 in /usr/local/lib/python3.6/site-packages (from kubernetes>=12.0->openshift) (2.22.0)
Requirement already satisfied: certifi>=14.05.14 in /usr/local/lib/python3.6/site-packages (from kubernetes>=12.0->openshift) (2023.11.17)
Requirement already satisfied: rsa<5,>=3.1.4 in /usr/local/lib/python3.6/site-packages (from google-auth>=1.0.1->kubernetes>=12.0->openshift) (4.9)
Requirement already satisfied: pyasn1-modules>=0.2.1 in /usr/local/lib/python3.6/site-packages (from google-auth>=1.0.1->kubernetes>=12.0->openshift) (0.3.0)
Requirement already satisfied: cachetools<6.0,>=2.0.0 in /usr/local/lib/python3.6/site-packages (from google-auth>=1.0.1->kubernetes>=12.0->openshift) (4.2.4)
Requirement already satisfied: chardet<3.1.0,>=3.0.2 in /usr/lib/python3.6/site-packages (from requests->kubernetes>=12.0->openshift) (3.0.4)
Requirement already satisfied: idna<2.8,>=2.5 in /usr/lib/python3.6/site-packages (from requests->kubernetes>=12.0->openshift) (2.5)
Requirement already satisfied: pyasn1<0.6.0,>=0.4.6 in /usr/local/lib/python3.6/site-packages (from pyasn1-modules>=0.2.1->google-auth>=1.0.1->kubernetes>=12.0->openshift) (0.5.1)
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
```



ansible-playbook main.yml --extra-vars "@./params.yml" -e ansible_python_interpreter=/usr/bin/python3  | tee output.log