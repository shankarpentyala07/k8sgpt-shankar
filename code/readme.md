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
