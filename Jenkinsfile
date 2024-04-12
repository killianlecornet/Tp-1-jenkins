pipeline {
    agent any

    environment {
        // Assurez-vous de configurer ces variables dans Jenkins ou dans le Jenkinsfile
        ID_DOCKER = "${ID_DOCKER_PARAMS}"
        IMAGE_NAME = "website-karma"
        IMAGE_TAG = "latest"
        DOCKERHUB_PASSWORD = "${DOCKERHUB_PASSWORD_PSW}"
    }

    triggers {
        // Vérifie le dépôt pour des changements toutes les 5 minutes
        // pollSCM('H/5 * * * *')
        githubPush()
    }

    stages {
        stage('Build image') {
            steps {
                script {
                    sh 'docker build -t ${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }

        stage('Test image') {
            steps {
                script {
                    // Insérez vos commandes de test ici
                    echo "Exécution des tests"
                }
            }
        }

        stage('Login and Push Image on docker hub') {
            steps {
                script {
                    sh '''
                        echo ${DOCKERHUB_PASSWORD} | docker login -u ${ID_DOCKER} --password-stdin
                        docker push ${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "Déploiement de l'application"
                    // Insérez vos commandes de déploiement ici
                }
            }
        }
    }

    post {
        success {
            mail to: 'killian.lecornet@ynov.com',
                 subject: "Succès du Pipeline ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "Le pipeline a réussi. L'application a été déployée."
        }
        failure {
            mail to: 'killian.lecornet@ynov.com',
                 subject: "Échec du Pipeline ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "Le pipeline a échoué. Veuillez vérifier Jenkins pour plus de détails."
        }
    }
}
