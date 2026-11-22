terraform {
    backend "s3" {
        bucket = "gitops-eks-platform-953326304662"
        key    = "terraform.tfstate"
        region = "us-east-2"
        encrypt = true
        use_lockfile = true
    }
}