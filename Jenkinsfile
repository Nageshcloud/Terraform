pipeline{
    agent { label any }
    stages{
        stage (" SCM ") {
            steps {
                git branch: 'master',
            url: 'https://github.com/Nageshcloud/Terraform.git'
            }
        }
        stage( "creating infrastructure" ){
            steps {
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}