provider "aws" {
  region     = var.web_region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "thej-webserver-1" {
  source = ".//module-1"
}

module "thej-webserver-2" {
  source = ".//module-2"
}





