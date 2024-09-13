pipeline {
  agent any

  options {
    timeout(time: 2, unit: 'MINUTES') // Limita el tiempo de ejecución del pipeline
  }

  environment {
    IMAGE_NAME = "testapp"
    REGISTRY = "127.0.0.1:8083"
  }

  stages {
    stage('Building image') {
      steps {
        sh "docker build -t ${IMAGE_NAME} ."
      }
    }

    stage('Run tests') {
      steps {
        sh "docker run ${IMAGE_NAME} npm test"
      }
    }
    
    stage('Login to Nexus') {
      steps {
          withCredentials([usernamePassword(credentialsId: 'nexus-id', 
                            usernameVariable: 'NEXUS_USERNAME', 
                            passwordVariable: 'NEXUS_PASSWORD')]) {
              sh """
              echo ${NEXUS_PASSWORD} | docker login ${REGISTRY} --username ${NEXUS_USERNAME} --password-stdin
              """
          }
      }
    }

    stage('Deploy Image') {
      steps {
        sh '''
          docker tag testapp ${REGISTRY}/daniel-repo/${IMAGE_NAME}
          docker push ${REGISTRY}/daniel-repo/${IMAGE_NAME}   
        '''
      }
    }
  }
  post {
    always {
      // Clean images
      sh '''
      docker rmi ${IMAGE_NAME} || true
      docker rmi ${REGISTRY}/daniel-repo/${IMAGE_NAME} || true
      '''
    }
  }
}
