resource "digitalocean_droplet" "haproxy-web" {
	image = "ubuntu-18-04-x64"
	name = "haproxy-web"
	region = "nyc1"
	size = "s-1vcpu-1gb"
	private_networking = "true"
	ssh_keys = [
		"${var.ssh_fingerprint}"
	]
	connection {
		user = "root"
		type = "ssh"
		host = self.ipv4_address
		private_key = "${file(var.pvt_key)}"
		timeout = "2m"
	}
	provisioner "remote-exec" {
 		inline = [
 			"sleep 25",
 			#install haproxy
 			"sudo apt-get update",
 			"sudo apt-get -y install haproxy"
 		]
 	}
 	provisioner "file" {
 	    content = "${data.template_file.haproxyconf.rendered}"
 	    destination = "/etc/haproxy/haproxy.cfg"
 	}
 	provisioner "remote-exec" {
 		inline = [
 			"sudo service haproxy restart"
 		]
 	}
}
