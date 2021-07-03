#!/bin/bash

usage () {
    echo
    echo "Usage:"
    echo "  $ $0 <terraform-command> <tf-var> <module>"
    echo
    echo "Options for terraform-command includes:"
    echo "  init, plan, apply, destroy"
    echo
    echo "For example:"
    echo "  $ $0 apply env/example.tfvars eks"
    echo
}

main () {
    cmd=$1
    conf=$2
    comp=$3

    red=$(tput setaf 1)
    green=$(tput setaf 2)
    norm=$(tput sgr0)

    if [[ -z ${cmd} ]] || [[ -z ${conf} ]] || [[ -z ${comp} ]]; then
        echo "${red}[ERROR]${norm} missing arguments"
        usage
        exit 2
    fi

    if [[ -f ${conf} ]]; then
        s3_state_bucket=$(cat ${conf} | grep "s3_state_bucket" | cut -d = -f 2 | tr -d ' ' | sed -e 's/^"//' -e 's/"$//')
        region=$(cat ${conf} | grep "region" | cut -d = -f 2 | tr -d ' ' | sed -e 's/^"//' -e 's/"$//')
    else
        echo "${red}[ERROR]${norm} config ${conf} not found"
        exit 2
    fi

    echo "== Input"
    echo "  module: ${green}${comp}${norm}"
    echo "  config: ${green}${conf}${norm}"
    echo "  s3_state_bucket: ${green}${s3_state_bucket}${norm}"
    echo "  region: ${green}${region}${norm}"
    echo

    if [[ -d ${comp} ]]; then
        cd ${comp}
    else
        echo "${red}[ERROR]${norm} module ${comp} not found"
        exit 2
    fi

    echo "== Command"
    echo "  Running terraform ${red}${cmd}${norm}"
    echo

    case ${cmd} in
        init)
            rm -rf .terraform*
            terraform init \
                -backend-config bucket=${s3_state_bucket} \
                -backend-config key=${comp}/terraform.tfstate \
                -backend-config region=${region}
            ;;
        plan)
            terraform plan -var-file ../${conf}
            ;;
        apply)
            terraform apply -var-file ../${conf}
            ;;
        destroy)
            terraform destroy -var-file ../${conf}
            ;;
        *)
            echo "${red}[ERROR]${norm} unrecognized terraform command"
            exit 2
            ;;
    esac
}

main $@
