data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "k8s_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.master_instance_type
  key_name      = aws_key_pair.aws-key.key_name
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.ingress_internal.id,
    aws_security_group.ingress_k8s.id,
    aws_security_group.ingress_ssh.id
  ]

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }
  tags = {
    Name = "k8s-master"
  }


  user_data = templatefile(
    "./scripts/kubeadm-setup.tftpl",
    {
      node              = "master",
      token             = local.token,
      cidr              = null
      master_public_ip  = aws_eip.master.public_ip,
      master_private_ip = null,
      worker_index      = null
    }
  )

}

resource "aws_instance" "k8s_worker" {
  count                       = var.workers-count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.worker_instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main.id
  key_name                    = aws_key_pair.aws-key.key_name
  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.ingress_internal.id,
    aws_security_group.ingress_k8s.id,
    aws_security_group.ingress_ssh.id
  ]

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  tags = {
    Name = "k8s-worker-${count.index}"
  }
  user_data = templatefile(
    "./scripts/kubeadm-setup.tftpl",
    {
      node              = "worker",
      token             = local.token,
      cidr              = null,
      master_public_ip  = null,
      master_private_ip = aws_instance.k8s_master.private_ip,
      worker_index      = count.index
    }
  )
}


