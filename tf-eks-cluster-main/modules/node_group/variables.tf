variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "subnet_ids" {
  description = "subnet IDs for the Node Group"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 0
}

variable "instance_types" {
  description = "Instance types for worker nodes"
  type        = list(string)
  default     = ["t3.micro"]
}

variable "ami_type" {
  description = "AMI type for worker nodes"
  type = string
  default = ""
}

variable "tags" {
  description = "Tags for the Node Group"
  type        = map(string)
  default     = {
    Environment = "development"
    Project     = "eks-demo"
  }
}
