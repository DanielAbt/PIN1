pipeline {
  agent any

  options {
    timeout(time: 2, unit: 'MINUTES') // Limita el tiempo de ejecución del pipeline
  }

  environment {
    ARTIFACT_ID = "elbuo8/webapp:${env.BUILD_NUMBER}" // Variable de entorno para el ID del artefacto
    REGISTRY = "127.0.0.1:8083"
  }

  stages {
    stage('Building image') {
      steps {
        sh "docker build -t testapp ."
      }
    }

    stage('Run tests') {
      steps {
        sh 'docker run testapp npm test'
      }
    }

    steps {
        // Utiliza withCredentials para manejar las credenciales de forma segura
        withCredentials([usernamePassword(credentialsId: 'nexus-id', 
                          usernameVariable: 'NEXUS_USERNAME', 
                          passwordVariable: 'NEXUS_PASSWORD')]) {
            sh """
            echo ${NEXUS_PASSWORD} | docker login ${REGISTRY} --username ${NEXUS_USERNAME} --password-stdin
            """
        }
    }

    stage('Deploy Image') {
      steps {
        sh '''
          docker tag testapp ${REGISTRY}/daniel-repo/testapp
          docker push ${REGISTRY}/daniel-repo/testapp   
        '''
      }
    }
  }
}
