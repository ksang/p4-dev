# p4-dev

A P4/p4lang development environment integrated with Mininet.

The environment is built based on [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).  
Install stable version according to your platform.

### Pre-installed Software

    os:
        ubuntu 14.04 LTS x64
    p4lang:
        behavioral-model 1.13.0
        p4c-bm 1.12.0
    mininet:
        2.2.2 (with nfv components)

### Pre-built Topology

- 4 nodes topology that contains 4 hosts and 4 p4 routers. Detailed information see [here](start_4nodes.sh).

### Step-by-step instructions
#### From host:
##### Start environment:

    vagrant up

##### Login to environment guest os:

    vagrant ssh

##### Reboot box:

    vagrant reload

The entire repo is mounted at `/p4-dev` in guest.  

#### From guest:  
##### To start up 4 nodes mininet environment with p4 simple_router:

    sudo /p4-dev/start_4nodes.sh /home/vagrant/p4lang/bin/simple_router/simple_router.json

Above command will bring you the mininet CLI.

##### To configure routers with static routes: (You may need another vagrant ssh session)

    /p4-dev/routing_4nodes.sh

Then within mininet CLI, you should be able to perform commands such as `pingall`.
