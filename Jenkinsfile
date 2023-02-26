pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="492365833365"
        AWS_DEFAULT_REGION="us-east-1" 
        CLUSTER_NAME="ecscluster"
        SERVICE_NAME="nodejs-container-svc"
        TASK_DEFINITION_NAME="custom"
        DESIRED_COUNT="1"
        IMAGE_REPO_NAME="demo-jenkins1"
        IMAGE_TAG="${env.BUILD_ID}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
	      registryCredential = "ecsagent"
    }
   
    stages {

    // Tests
    stage('Unit Tests') {
      steps{
        script {
          sh 'npm install'
	        sh 'npm test -- --watchAll=false'
        }
      }
    }
        
    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
        }
      }
    }
   
    Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
      steps{  
        script {
          // sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 492365833365.dkr.ecr.us-east-1.amazonaws.com'
			    docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:" + registryCredential) {
         	dockerImage.push()
          // sh 'docker tag demo-jenkins:latest 492365833365.dkr.ecr.us-east-1.amazonaws.com/demo-jenkins:latest'
          // sh 'docker push 492365833365.dkr.ecr.us-east-1.amazonaws.com/demo-jenkins:latest'
          }
        }
      }
    }

    // stages {
    //   stage('Push Docker Image to ECR') {
    //     steps {
    //       script {
    //         withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
    //           sh 'eval $(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 492365833365.dkr.ecr.us-east-1.amazonaws.com)'
    //           // sh "docker build -t $DOCKER_IMAGE_NAME ."
    //           // sh "docker tag $DOCKER_IMAGE_NAME $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:$DOCKER_IMAGE_NAME"
    //           sh "docker tag demo-jenkins:latest 492365833365.dkr.ecr.us-east-1.amazonaws.com/demo-jenkins:latest"
    //           sh "docker push 492365833365.dkr.ecr.us-east-1.amazonaws.com/demo-jenkins:latest"
    //         }
    //       }
    //     }
    //   }
    // }
      
    stage('Deploy to ECS') {
      steps{
        withAWS(credentials: registryCredential, region: "${AWS_DEFAULT_REGION}") {
          script {
			      sh './script.sh'
          }
        } 
      }
    }         
  }
}

