terraform {
  backend "remote" {
    organization = "Harika"

    workspaces {
      name = "VPC"
    }
  }
}
