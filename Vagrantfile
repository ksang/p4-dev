Vagrant.configure("2") do |config|
    config.vm.box = "ksang/p4-dev"
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder "..", "/p4-dev"
    config.vm.provider "virtualbox" do |v|
        v.name = "p4-dev"
        v.gui = false
        v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
        v.customize ["modifyvm", :id, "--cpus", "2"]
        v.customize ["modifyvm", :id, "--memory", "2048"]
    end
end
