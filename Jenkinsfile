pipeline {
    agent any

    tools { 
        jdk 'JDK 21' 
        maven 'Maven 3.8.7' 
    }

    environment {
        DOCKER_USER = "mahens" 
        IMAGE_NAME  = "app-triangle"
        VERSION     = "1.0.0"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('git checkout') { 
            steps {
                // Page 5 : Récupération sécurisée depuis votre futur dépôt GitHub
                git branch: 'main', 
                    credentialsId: 'github-auth', 
                    url: 'https://github.com/mahensraz/tp_jenkins' 
            }
        }

        stage('Build the application') { 
            steps {
                // Page 5 & 6 : Compilation Maven
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Unit Test Execution') { 
            steps {
                // Page 7 : Exécution obligatoire des tests unitaires
                sh 'mvn test'
            }
        }

        stage('Build the docker image') { 
            steps {
                // Page 7 : Construction automatisée de l'image Docker
                sh "docker build --tag ${DOCKER_USER}/${IMAGE_NAME}:${VERSION} ."
            }
        }

        stage('Push Image to DockerHub') { 
            steps {
                // Page 7 : Connexion et transfert sécurisé vers DockerHub
                withCredentials([string(credentialsId: 'dockerhubpass', variable: 'dockerHubPass')]) {
                    sh "echo '${dockerHubPass}' | docker login -u ${DOCKER_USER} --password-stdin"
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"
                }
            }
        }
    }

    // post {
    //     failure {
    //         // Page 9 : Alerte e-mail obligatoire en cas de problème
    //         emailext body: "Ce Build $BUILD_NUMBER a échoué",
    //                  recipientProviders: [requestor()], 
    //                  subject: 'build failure', 
    //                  to: 'razakatiambolaphillipe@gmail.com'
    //     }
    // }

    post {
      failure {
        // Remplacement d'emailext par un simple echo pour éviter le plantage de Jenkins
        echo "Le Build a échoué. Vérifiez les logs ci-dessus."
      }
    }
}
