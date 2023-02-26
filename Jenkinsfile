pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID="492365833365"
        AWS_DEFAULT_REGION="us-east-1" 
        CLUSTER_NAME="ecscluster"
        SERVICE_NAME="nodejs-container-svc"
        TASK_DEFINITION_NAME="custom"
        DESIRED_COUNT="1"
        IMAGE_REPO_NAME="demo-jenkins"
        IMAGE_TAG="${env.BUILD_ID}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
	      // registryCredential = "ecsagent"
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
   
    // Uploading Docker images into AWS ECR
    // stage('Pushing to ECR') {  steps{    script {      docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:") {        withCredentials([[          $class: 'AmazonWebServicesCredentialsBinding',          credentialsId: 'ecsagent',          region: 'us-east-1'        ]]) {          dockerImage.push()
    //     }      }    }  }}
    stage('Pushing to ECR') {
      steps{
        // withCredentials([[
        //   $class: 'AmazonWebServicesCredentialsBinding',
        //   // credentialsId: 'ecsagent',
        //   region: 'us-east-1'
        // ]]) {
          script {
            docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:") {
              dockerImage.push()
            }
          }
        }
      }
    }
    //     script {
		// 	    docker.withRegistry("https://" + REPOSITORY_URI, "ecr:${AWS_DEFAULT_REGION}:") {
    //      	dockerImage.push()
    //       }
    //     }
    //   }
    // }
      
    stage('Deploy to ECS') {
      steps{
        withAWS(credentials: ecsagent, region: "${AWS_DEFAULT_REGION}") {
          script {
			      sh './script.sh'
          }
        } 
      }
    }         
  }
}

