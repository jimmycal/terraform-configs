resource "baremetal_load_balancer" "weblogic-lb" {
  shape          = "100Mbps"
  compartment_id = "${lookup(module.bmc_resources.compartments, var.compartment_name)}"
  subnet_ids     = ["${baremetal_core_subnet.lb-subnet-1.id}","${baremetal_core_subnet.lb-subnet-2.id}"]
  display_name   = "${var.identifier}-weblogic-LB"
}

resource "baremetal_load_balancer_backendset" "weblogic-backend-set" {
  load_balancer_id = "${baremetal_load_balancer.weblogic-lb.id}"
  name             = "appbackendset"
  policy           = "ROUND_ROBIN"
  health_checker {
    interval_ms         = 30001
    port                = 7001
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/console"
  }
}

