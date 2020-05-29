#!/bin/bash

REPO_NAME=project # project-id
IMAGE_LIST=$(gcloud container images list --repository=${REPO_NAME} | awk 'NR==2,NR==-1')
for IMAGE in ${IMAGE_LIST}; do
    #  保存最近15次的镜像，如需修改，可以修改 'NR==11'字段
    DIGEST=$(gcloud container images list-tags $IMAGE --format='get(digest)' --sort-by=~timestamp | awk 'NR==15,NR==-1')
    for digest in $DIGEST; do
        (
            # set -x
            echo -e "\033[31m gcloud container images delete -q --force-delete-tags ${IMAGE}@${digest} \033[0m"
            gcloud container images delete -q --force-delete-tags "${IMAGE}@${digest}"
        )
    done
done
