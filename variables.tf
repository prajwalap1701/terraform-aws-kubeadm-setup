# Mandatory variable
variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
}

variable "private_key_file" {
  type        = string
  description = "SSH Private key on local machine to connect to the nodes of the cluster"
  default     = "./keys/aws-key"
}

variable "public_key_file" {
  type        = string
  description = "SSH Public key on local machine to connect to the nodes of the cluster"
  default     = "./keys/aws-key.pub"
}

variable "master_instance_type" {
  type        = string
  description = "Instance type for Kubernetes master node"
  default     = "t2.medium"
}

variable "worker_instance_type" {
  type        = string
  description = "Instance type for Kubernetes worker nodes"
  default     = "t2.small"
}

# Define a variable for the number of Kubernetes worker nodes
variable "workers-count" {
  type        = number
  default     = 1
  description = "Number of Kubernetes worker nodes"
}

variable "volume_size" {
  type    = number
  default = 30
}

variable "tags" {
  type        = map(string)
  description = "A set of tags to assign to the created AWS resources"
  default     = {}
}

variable "vpc_cidr" {
  type        = string
  description = "AWS VPC CIDR"
  default     = "10.0.0.0/16"
}
variable "vpc_azs" {
  type        = list(string)
  description = "AWS VPC availability zones"
  default     = ["10.0.0.0/16"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
  default     = ["10.0.101.0/24"]
}

variable "allowed_ssh_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make SSH connections to the EC2 instances"
  default     = ["0.0.0.0/0"]
}

variable "allowed_k8s_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks from which it is allowed to make Kubernetes API request"
  default     = ["0.0.0.0/0"]
}

variable "pod_network_cidr_block" {
  type        = string
  description = "CIDR block for the Pod network of the cluster"
  default     = null
}