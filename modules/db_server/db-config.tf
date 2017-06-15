provider "baremetal" {
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
}
#Update resource to DB instance

#resource "baremetal_core_instance" "base" {
#  availability_domain = "${var.ad_name}"
#  compartment_id = "${var.compartment_name}"
#  display_name = "${var.server_display_name}"
#  image = "${var.image_name}"
#  shape = "${var.shape_name}"
#  subnet_id = "${var.subnet_name}"
#  metadata {
#    ssh_authorized_keys = "${var.public_key}"
#  }
#}

#data "baremetal_core_vnic_attachments" "vnics" {
#      compartment_id = "${var.compartment_name}"
#      availability_domain = "${var.ad_name}"
#      instance_id = "${baremetal_core_instance.base.id}"
#}
#data "baremetal_core_vnic" "vnic" {
#  vnic_id = "${lookup(data.baremetal_core_vnic_attachments.vnics.vnic_attachments[0],"vnic_id")}"
#}



resource "null_resource" "omc_db_config"{

  provisioner "remote-exec" {
        inline = [
         "sudo yum install gcc gcc-c++ wget git perl unzip bind-utils bc rng-tools libffi-devel python-devel openssl-devel policycoreutils-python -y",
         "sudo groupadd omcinstall",
         "sudo useradd -g omcinstall -G users omc",
         "sudo su root -c 'echo ulimit -S -n 10000 >> ~omc/.bash_profile'",
         "sudo su root -c 'echo umask 022 >> ~omc/.bash_profile'",
         "sudo su root -c 'echo umask 022 >> ~omc/.bash_profile'",
         "sudo su root -c 'echo omc soft nofile 65536 >> /etc/security/limits.conf'",
         "sudo su root -c 'echo omc hard nofile 65536 >> /etc/security/limits.conf'",
         "sudo su root -c \"echo 'omc ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers\"",
         "sudo su root -c 'mkdir ~omc/.ssh'",
         "sudo su root -c 'echo ${var.public_key} > ~omc/.ssh/authorized_keys'",
         "sudo su root -c 'echo ulimit -S -n 10000 >> ~omc/.bash_profile'",
         "sudo su root -c 'echo umask 022 >> ~omc/.bash_profile'",
         "sudo mkdir -p /omc" ,
         "sudo mkdir -p /omc/stage_one" ,
         "sudo mkdir -p /omc/stage_two" ,
         "sudo chown -R omc:omcinstall /omc",
         "sudo chown -R omc:omcinstall ~omc",
         "sudo rngd -r /dev/urandom -o /dev/random",
         "sudo su root -c 'echo AllowUsers omc >> /etc/ssh/sshd_config'",
         "sudo service sshd restart"
        ]
        connection {
          #host = "${data.baremetal_core_vnic.vnic.public_ip_address}"
          host = "10.0.5.4"
          type = "ssh"
          user = "opc"
          private_key = "${file(var.omc["private_key_path"])}"
          timeout = "7m"
        }
    }

  # Copies the agentInstall.zip file to the /u01/omc directory
  provisioner "file" {
      source = "${var.omc["omc_agent_path"]}"
      destination = "/omc/stage_one/agentInstall.zip"
      connection {
        #host = "${data.baremetal_core_vnic.vnic.public_ip_address}"
        host = "10.0.5.4"
        type = "ssh"
        user = "omc"
        private_key = "${file(var.omc["private_key_path"])}"
        timeout = "7m"
      }
    }

  provisioner "remote-exec" {
        inline = [
        "unzip /omc/stage_one/agentInstall.zip -d /omc/stage_one",
        "chmod +x /omc/stage_one/AgentInstall.sh",
        "/omc/stage_one/AgentInstall.sh AGENT_TYPE=cloud_agent STAGE_LOCATION=/omc/stage_two -download_only AGENT_REGISTRATION_KEY=${var.omc["omc_key"]}",
        "mkdir -p /omc/app",
        ]
        connection {
          #host = "${data.baremetal_core_vnic.vnic.public_ip_address}"
          host = "10.0.5.4"
          type = "ssh"
          user = "omc"
          private_key = "${file(var.omc["private_key_path"])}"
          timeout = "7m"
        }
    }

    provisioner "file" {
            content = "${var.omc["omc_entity_config_path"]}"
            destination = "/omc/stage_two/omc_entity.json"
            connection {
              #host = "${data.baremetal_core_vnic.vnic.public_ip_address}"
              host = "10.0.5.4"
              type = "ssh"
              user = "omc"
              private_key = "${file(var.omc["private_key_path"])}"
            }
    }

    provisioner "file" {
            content = "${var.omc["omc_db_creds_path"]}"
            destination = "/omc/stage_two/omc_entity_creds.json"
            connection {
              #host = "${data.baremetal_core_vnic.vnic.public_ip_address}"
              host = "10.0.5.4"
              type = "ssh"
              user = "omc"
              private_key = "${file(var.omc["private_key_path"])}"
            }
    }

    provisioner "remote-exec" {
      inline = [
      "/omc/stage_two/AgentInstall.sh AGENT_TYPE=cloud_agent AGENT_BASE_DIR='/omc/app/cloud_agent' -staged  AGENT_PROPERTIES=$PWD/agent.properties AGENT_REGISTRATION_KEY=${var.omc["omc_key"]}",
      "export core=$(/omc/app/cloud_agent/agent_inst/bin/omcli status agent | grep '^Binaries Location' | awk -F: '{print $2}')",
      "sudo $core/root.sh",
      "/omc/app/cloud_agent/agent_inst/bin/omcli update_entity agent /omc/stage_two/omc_entity.json"
      ]
      connection {
        #host = "${data.baremetal_core_vnic.vnic.public_ip_address}"
        host = "10.0.5.4"
        type = "ssh"
        user = "omc"
        private_key = "${file(var.omc["private_key_path"])}"
      }
  }
  }
