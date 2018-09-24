# setup 


## Assumptions

* execute ansible scripts as root
* ansible directory is /etc/ansible (default in ubuntu)

## Preparations

### install ansible
 
 sudo apt-get install ansible


### create ssh keys for ssh login without password

 ssh-keygen  ##  < no passphrase>

 creates private and public key in ~/.ssh/ with default names (id_rsa and id_rsa.pub)
 
### copy public key to every host managed by ansible (activated root-user assumed)

 ssh-copy-id root@< hostname >

 in case of sudoer-user public key is copied to user (belonging to soduers)
 
 sudo password is given on commandline or in inventory (see docs)

### test ssh connection with rsa keys:

 ssh root@< hostname >

 you are logged in without password;

 return with 'exit' to your ansible host

##

### change  directory to /etc/ansible
 

### clone repo


### edit inventory 


### create symbolic link to your inventory


### edit vars in playbook


### execute ansible script









