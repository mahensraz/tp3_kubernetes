pipeline {
    // ÉTAPE CRUCIALE TP3 : On demande à Kubernetes de créer un Pod esclave avec Maven et Docker
    agent {
        kubernetes {
            label 'jenkins-agent-tp3'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    component: ci
spec:
  containers:
    - name: maven
      image: maven:3.9.6-eclipse-temurin-21
      command: ['cat']
      tty: true
    - name: docker
      image: docker:latest
      command: ['cat']
      tty: true
      volumeMounts:
        - mountPath: /var/run/docker.sock
          name: docker-sock
    - name: kubectl
      image: rancher/kubectl:v1.30.1
      command: ['cat']
      tty: true
    
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
"""
        }
    }

    environment {
        DOCKER_USER = "mahens" 
        IMAGE_NAME  = "app-triangle-k8s" // Nom unique pour différencier du TP2
        VERSION     = "1.0.0-tp3"        // Version spécifique pour le TP3
    }

    stages {
        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('git checkout') { 
            steps {
                // Lien mis à jour vers votre nouveau dépôt public
                git branch: 'main', 
                    url: 'https://github.com/mahensraz/tp3_kubernetes' 
            }
        }

        stage('Build the application') { 
            steps {
                // On force Jenkins à exécuter la commande À L'INTÉRIEUR du conteneur Maven du Pod
                container('maven') {
                    sh 'mvn clean install -DskipTests'
                }
            }
        }

        stage('Unit Test Execution') { 
            steps {
                // Idem, exécution isolée dans le conteneur Maven
                container('maven') {
                    sh 'mvn test'
                }
            }
        }

        stage('Build the docker image') { 
            steps {
                // On passe dans le conteneur Docker du Pod (qui est relié au Docker Desktop de votre PC)
                container('docker') {
                    sh "docker build --tag ${DOCKER_USER}/${IMAGE_NAME}:${VERSION} ."
                }
            }
        }

        stage('Push Image to DockerHub') { 
            steps {
                container('docker') {
                    withCredentials([string(credentialsId: 'dockerhubpass', variable: 'dockerHubPass')]) {
                        sh "echo '${dockerHubPass}' | docker login -u ${DOCKER_USER} --password-stdin"
                        sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    sh "kubectl apply -f ./kubernetes/deployment.yaml"
                    sh "kubectl apply -f ./kubernetes/service.yaml"
                }
            }
        }
    }

    post {
        failure {
            echo "Le Build a échoué. Vérifiez les logs ci-dessus."
        }
    }
}
