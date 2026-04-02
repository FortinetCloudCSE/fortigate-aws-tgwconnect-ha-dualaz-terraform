provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

locals {
  create_tgw = var.create_tgw ? 1 : 0
  create_inspect_vpc = var.create_inspect_vpc ? 1 : 0
  create_spokes = var.create_spokes ? 1 : 0
}

module "transit-gw" {
  source = ".//modules/tgw"
  count = local.create_tgw
  region = var.region
  tgw_bgp_asn = var.tgw_bgp_asn
  tgw_connect_cidr = var.tgw_connect_cidr
  tag_name_prefix = var.tag_name_prefix
}

module "inspection-vpc" {
  source = "./modules/vpc-inspection"
  count = local.create_inspect_vpc
  region = var.region

  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  vpc_cidr = var.inspection_vpc_cidr
  public_subnet_cidr1 = var.inspection_vpc_public_subnet_cidr1
  public_subnet_cidr2 = var.inspection_vpc_public_subnet_cidr2
  private_subnet_cidr1 = var.inspection_vpc_private_subnet_cidr1
  private_subnet_cidr2 = var.inspection_vpc_private_subnet_cidr2
  hamgmt_subnet_cidr1 = var.inspection_vpc_hamgmt_subnet_cidr1
  hamgmt_subnet_cidr2 = var.inspection_vpc_hamgmt_subnet_cidr2
  attachment_subnet_cidr1 = var.inspection_vpc_attachment_subnet_cidr1
  attachment_subnet_cidr2 = var.inspection_vpc_attachment_subnet_cidr2
  tgw_creation = local.create_tgw
  tgw_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_id : var.existing_tgw_id
  tgw_spoke_route_table_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_spoke_route_table_id : var.existing_tgw_spoke_route_table_id
  tgw_security_route_table_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_security_route_table_id : var.existing_tgw_security_route_table_id
  tgw_connect_cidr = var.tgw_connect_cidr
  fgt_loopback_ip = var.fgt_loopback_ip
  fgt1_eni1_id = module.fgcp-tgw.fgt1_eni1_id
  
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "inspection"
}

module "fgcp-tgw" {
  source = "./modules/fgcp-tgw"
  region = var.region

  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  vpc_id = local.create_inspect_vpc == 1 ? module.inspection-vpc[0].vpc_id : var.existing_vpc_id
  vpc_cidr = var.inspection_vpc_cidr
  public_subnet1_id = local.create_inspect_vpc == 1 ? module.inspection-vpc[0].public_subnet1_id : var.existing_public_subnet1_id
  private_subnet1_id = local.create_inspect_vpc == 1 ? module.inspection-vpc[0].private_subnet1_id : var.existing_private_subnet1_id
  hamgmt_subnet1_id = local.create_inspect_vpc == 1 ? module.inspection-vpc[0].hamgmt_subnet1_id : var.existing_hamgmt_subnet1_id
  public_subnet2_id = local.create_inspect_vpc == 1 ? module.inspection-vpc[0].public_subnet2_id : var.existing_public_subnet2_id
  private_subnet2_id = local.create_inspect_vpc == 1 ? module.inspection-vpc[0].private_subnet2_id : var.existing_private_subnet2_id
  hamgmt_subnet2_id = local.create_inspect_vpc == 1 ? module.inspection-vpc[0].hamgmt_subnet2_id : var.existing_hamgmt_subnet2_id

  cidr_for_access = var.cidr_for_access
  keypair = var.keypair
  encrypt_volumes = var.encrypt_volumes
  instance_type = var.instance_type
  only_private_ec2_api = var.only_private_ec2_api
  fortios_version = var.fortios_version
  license_type = var.license_type
  fgt1_byol_license = var.fgt1_byol_license
  fgt2_byol_license = var.fgt2_byol_license
  fgt1_fortiflex_token = var.fgt1_fortiflex_token
  fgt2_fortiflex_token = var.fgt2_fortiflex_token
  public_subnet1_intrinsic_router_ip = local.create_inspect_vpc == 1 ? var.inspection_vpc_public_subnet1_intrinsic_router_ip : var.existing_public_subnet1_intrinsic_router_ip
  private_subnet1_intrinsic_router_ip = local.create_inspect_vpc == 1 ? var.inspection_vpc_private_subnet1_intrinsic_router_ip : var.existing_private_subnet1_intrinsic_router_ip
  hamgmt_subnet1_intrinsic_router_ip = local.create_inspect_vpc == 1 ? var.inspection_vpc_hamgmt_subnet1_intrinsic_router_ip : var.existing_hamgmt_subnet1_intrinsic_router_ip
  public_subnet2_intrinsic_router_ip = local.create_inspect_vpc == 1 ? var.inspection_vpc_public_subnet2_intrinsic_router_ip : var.existing_public_subnet2_intrinsic_router_ip
  private_subnet2_intrinsic_router_ip = local.create_inspect_vpc == 1 ? var.inspection_vpc_private_subnet2_intrinsic_router_ip : var.existing_private_subnet2_intrinsic_router_ip
  hamgmt_subnet2_intrinsic_router_ip = local.create_inspect_vpc == 1 ? var.inspection_vpc_hamgmt_subnet2_intrinsic_router_ip : var.existing_hamgmt_subnet2_intrinsic_router_ip
  fgt1_public_ip = var.fgt1_public_ip
  fgt1_private_ip = var.fgt1_private_ip
  fgt1_hamgmt_ip = var.fgt1_hamgmt_ip
  fgt2_public_ip = var.fgt2_public_ip
  fgt2_private_ip = var.fgt2_private_ip
  fgt2_hamgmt_ip = var.fgt2_hamgmt_ip
  fgt_loopback_ip = var.fgt_loopback_ip
  fgt_bgp_asn = var.fgt_bgp_asn
  tgw_bgp_asn = var.tgw_bgp_asn
  tgw_connect_cidr = var.tgw_connect_cidr
  tgw_connect_attachment_id = local.create_inspect_vpc == 1 ? module.inspection-vpc[0].tgw_connect_attachment_id : var.existing_tgw_connect_attachment_id
  tgw_connect_peer1_inside_cidr = var.tgw_connect_peer1_inside_cidr
  tgw_connect_peer2_inside_cidr = var.tgw_connect_peer2_inside_cidr
  
  tag_name_prefix = var.tag_name_prefix
}

module "spoke-vpc1" {
  source = "./modules/vpc-spoke"
  count = local.create_spokes
  region = var.region
  
  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  vpc_cidr = var.spoke_vpc1_cidr
  private_subnet_cidr1 = var.spoke_vpc1_private_subnet_cidr1
  private_subnet_cidr2 = var.spoke_vpc1_private_subnet_cidr2
  tgw_creation = local.create_tgw
  transit_gateway_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_id : var.existing_tgw_id
  tgw_spoke_route_table_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_spoke_route_table_id : var.existing_tgw_spoke_route_table_id
  tgw_security_route_table_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_security_route_table_id : var.existing_tgw_security_route_table_id
  
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke1"
}

module "spoke-vpc2" {
  source = "./modules/vpc-spoke"
  count = local.create_spokes
  region = var.region
  
  availability_zone1 = var.availability_zone1
  availability_zone2 = var.availability_zone2
  vpc_cidr = var.spoke_vpc2_cidr
  private_subnet_cidr1 = var.spoke_vpc2_private_subnet_cidr1
  private_subnet_cidr2 = var.spoke_vpc2_private_subnet_cidr2
  tgw_creation = local.create_tgw
  transit_gateway_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_id : var.existing_tgw_id
  tgw_spoke_route_table_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_spoke_route_table_id : var.existing_tgw_spoke_route_table_id
  tgw_security_route_table_id = local.create_tgw == 1 ? module.transit-gw[0].tgw_security_route_table_id : var.existing_tgw_security_route_table_id
  
  tag_name_prefix = var.tag_name_prefix
  tag_name_unique = "spoke2"
}