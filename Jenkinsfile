pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
    		sh 'git clone ${GIT_URL} ${WORKSPACE}'
    		sh 'cd ${WORKSPACE} && docker build -t ${IMAGE_NAME} .'
            }
        }
        stage('Push') {
        	 steps {
			sh 'docker tag ${IMAGE_NAME} ${DOCKER_USERNAME}/${IMAGE_NAME}'
			//docker push ${DOCKER_USERNAME}/${IMAGE_NAME}
			sh 'docker push ${DOCKER_USERNAME}/${IMAGE_NAME}'
		}
        }
    }
}

properties {
    // Set environment variables
    environment {
        GIT_URL = 'https://github.com/hd-appz-dev/omnigen-docker.git'
        IMAGE_NAME = 'omnigen-docker'
        DOCKER_USERNAME = 'hdappzdev'
    }
}
