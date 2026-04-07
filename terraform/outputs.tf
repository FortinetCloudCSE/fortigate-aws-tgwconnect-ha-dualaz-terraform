output "fgt_login_info" {
  value = <<-FGTLOGIN
-=-=-=-=-=-=-=-=-=-=-
fgt username: admin
fgt initial password: ${module.fgcp-tgw.fgt1_id}
cluster login url: https://${module.fgcp-tgw.cluster_eip_public_ip}
fgt1 login url: https://${module.fgcp-tgw.fgt1_hamgmt_ip}
fgt2 login url: https://${module.fgcp-tgw.fgt2_hamgmt_ip}
-=-=-=-=-=-=-=-=-=-=-
FGTLOGIN
}

output "tgw_info" {
  value = var.create_tgw ? (
    <<-tgwNEW
-=-=-=-=-=-=-=-=-=-=-
tgw id: ${module.transit-gw[0].tgw_id}
tgw spoke route table id: ${module.transit-gw[0].tgw_spoke_route_table_id}
tgw security route table id: ${module.transit-gw[0].tgw_security_route_table_id}
-=-=-=-=-=-=-=-=-=-=-
tgwNEW
    ) : (
    <<-tgwEXISTING
-=-=-=-=-=-=-=-=-=-=-
tgw_id = ${var.existing_tgw_id}
tgw_spoke_route_table_id = ${var.existing_tgw_spoke_route_table_id}
tgw_security_route_table_id = ${var.existing_tgw_security_route_table_id}
-=-=-=-=-=-=-=-=-=-=-
tgwEXISTING
  )
}