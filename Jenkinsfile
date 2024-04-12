pipeline {
    agent any

    environment {
        // Variables d'environnement nécessaires
        ID_DOCKER = "${ID_DOCKER_PARAMS}"
        IMAGE_NAME = "website-karma"
        IMAGE_TAG = "latest"
        DOCKERHUB_PASSWORD = "${DOCKERHUB_PASSWORD_PSW}"
        RENDER_API_TOKEN = credentials('RENDER_API_TOKEN')
        RENDER_SERVICE_ID = "srv-cockhsa1hbls73csl2o0"
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

stage('Deploy to Render') {
            steps {
                script {
                    // Définir le JSON dans une variable d'environnement pour éviter tout problème d'interpolation
                    env.JSON_PAYLOAD = '''{
                        "force": true,
                        "clearCache": true
                    }'''

                    // Utiliser un bloc withEnv pour insérer les tokens et autres variables de manière sécurisée
                    withEnv(["AUTH_HEADER=Bearer ${RENDER_API_TOKEN}", "CONTENT_TYPE=application/json", "JSON_PAYLOAD=${env.JSON_PAYLOAD}"]) {
                        sh '''
                        curl -X POST "https://api.render.com/v1/services/${RENDER_SERVICE_ID}/deploys" \
                        -H "Authorization: ${AUTH_HEADER}" \
                        -H "Content-Type: ${CONTENT_TYPE}" \
                        -d "$JSON_PAYLOAD"
                        '''
                    }
                }
            }
        }




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
