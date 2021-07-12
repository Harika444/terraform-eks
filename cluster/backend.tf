terraform {
  backend "remote" {
    organization = "Harika"

    workspaces {
      name = "my-CLUSTER"
    }
  }
}