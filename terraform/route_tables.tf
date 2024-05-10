# Get the NAT instance's network interface ID
data "aws_instance" "nat_instance" {
  instance_id = module.ec2_nat_instance.id
}

data "aws_network_interface" "nat_interface" {
  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.nat_instance.id]
  }
}

# Update route tables for private subnet
resource "aws_route" "private_subnet_route" {
  count = length(module.vpc.private_route_table_ids)

  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"  # Internet-bound traffic
  network_interface_id   = data.aws_network_interface.nat_interface.id
}


