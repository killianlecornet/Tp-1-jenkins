pipeline {
    agent any

    environment {
        // Variables d'environnement nécessaires
        ID_DOCKER = "${ID_DOCKER_PARAMS}"
        IMAGE_NAME = "website-karma"
        IMAGE_TAG = "latest"
        DOCKERHUB_PASSWORD = "${DOCKERHUB_PASSWORD_PSW}"
        RENDER_API_TOKEN = credentials('render_api_token') // Assurez-vous d'ajouter ceci dans Jenkins Credentials
        SERVICE_ID = "votre_service_id_render" // Remplacez ceci par l'ID de votre service sur Render
    }

    triggers {
        // Vérifie le dépôt pour des changements toutes les 2 minutes
        pollSCM('H/2 * * * *')
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

        // stage('Deploy') {
        //     steps {
        //         script {
        //             sh 'curl -H "Authorization: Bearer ${RENDER_API_TOKEN}" -H "Content-Type: application/json" \
        //                 -d "{\"serviceId\": \"${SERVICE_ID}\", \"imageName\": \"${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}\"}" \
        //                 https://api.render.com/deploy'
        //         }
        //     }
        // }
    }

    post {
        success {
            mail to: 'killian.lecornet@ynov.com',
                 subject: "Succès du Pipeline ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "Le pipeline a réussi. L'application a été déployée sur Render."
        }
        failure {
            mail to: 'killian.lecornet@ynov.com',
                 subject: "Échec du Pipeline ${env.JOB_NAME} ${env.BUILD_NUMBER}",
                 body: "Le pipeline a échoué. Veuillez vérifier Jenkins pour plus de détails."
        }
    }
}
