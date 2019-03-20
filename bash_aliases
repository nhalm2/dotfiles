#!/bin/bash

###################
#                 #
# Kubectl Helpers #
#                 #
###################

function image {
	echo "    Project: $(kubectl config current-context)"
	if [ $# -eq 0 ]; then
		kubectl describe pods $(kubectl get pods | grep -v 'NAME' | awk '{ print $1 }') | grep 'Image:'
	else
        	kubectl describe pods $(kubectl get pods | grep $1 | awk '{ print $1 }') | grep 'Image:'
	fi
}

function showpod {
	echo "Project: $(kubectl config current-context)"
        kubectl get pods | grep $1
}

function gssh {
#connect to util-1 server of project you pass in
#eg. gssh tredium-scl-pharm-ltc
	#get project id:
	PROJ_ID=$(gcloud projects list | grep ${1} | awk '{ print $1 }')
        ssh-add ~/.ssh/google_compute_engine
	zone=$(gcloud compute instances list --project ${PROJ_ID} --filter="Name:util-1" --format='value(zone)')
	echo "util-1 zone: ${zone}"
        gcloud compute ssh --zone ${zone} --project ${PROJ_ID} util-1 --ssh-flag='-A'
}

function gscp {
#connect to util-1 server of project you pass in
#eg. gssh tredium-scl-pharm-ltc
	echo ""
	echo "DEPREACTED - use 'gpull' instead"
	echo ""
	#get project id:
	PROJ_ID=$(gcloud projects list | grep ${1} | awk '{ print $1 }')

	zone=$(gcloud compute instances list --project ${PROJ_ID} --filter="Name:util-1" --format='value(zone)')
	echo "util-1 zone: ${zone}"
        gcloud compute scp --zone ${zone} --project ${PROJ_ID} util-1:${2} ${3}
}

function gpull {
#connect to util-1 server of project you pass in
#eg. gssh tredium-scl-pharm-ltc
	#get project id:
	PROJ_ID=$(gcloud projects list | grep ${1} | awk '{ print $1 }')

	zone=$(gcloud compute instances list --project ${PROJ_ID} --filter="Name:util-1" --format='value(zone)')
	echo "util-1 zone: ${zone}"
        gcloud compute scp --compress --scp-flag='-o' --scp-flag='ForwardAgent yes' --zone ${zone} --project ${PROJ_ID} util-1:${2} ${3}
}

function gpush {
	#get project id:
	PROJ_ID=$(gcloud projects list | grep ${1} | awk '{ print $1 }')

	zone=$(gcloud compute instances list --project ${PROJ_ID} --filter="Name:util-1" --format='value(zone)')
	echo "util-1 zone: ${zone}"
        gcloud compute scp --compress --scp-flag='-o' --scp-flag='ForwardAgent yes' --zone ${zone} --project ${PROJ_ID} ${2} util-1:${3}
}

function gport {
# gport tredium-tdm=pharm-test 5432:db-prod-1:5432
	#get project id:
	PROJ_ID=$(gcloud projects list | grep ${1} | awk '{ print $1 }')

	zone=$(gcloud compute instances list --project ${PROJ_ID} --filter="Name:util-1" --format='value(zone  )')
	gcloud compute ssh --zone ${zone} --project ${PROJ_ID} util-1 --ssh-flag='-A' --ssh-flag='-L' --ssh-flag="$2" 
}

function gcon {
#connect to cluster-1 in given project. If parameter passed, use that cluster name instead of default cluster-1 (ie, internal-cluster in tredium-internal)
# gcon tredium-tdm-pharm-test
# gcon tredium-tdm-pharm-test cluster-name

	#get project id:
	PROJ_ID=$(gcloud projects list | grep ${1} | awk '{ print $1 }')

	zone=$(gcloud container clusters list --project ${PROJ_ID} | grep ${2:-cluster-1} | awk '{ print $2 }')
	gcloud container clusters get-credentials ${2:-cluster-1} --zone ${zone} --project ${PROJ_ID}
}

# $1 is kind (User, Group, ServiceAccount)
# $2 is name ("system:nodes", etc)
# $3 is namespace (optional, only applies to kind=ServiceAccount)
function getRoles() {
	local kind="${1}"
	local name="${2}"
	local namespace="${3:-}"

	kubectl get clusterrolebinding -o json | jq -r "
	.items[]
	|
	select(
		.subjects[]?
		|
		select(
			.kind == \"${kind}\"
			and
			.name == \"${name}\"
			and
			(if .namespace then .namespace else \"\" end) == \"${namespace}\"
		)
	)
	|
	(.roleRef.kind + \"/\" + .roleRef.name)
	"
}

function __kube_ps1()
{
	if [ -e ${HOME}/.kube/config ]; then
		# Get current context
		CONTEXT=$(cat ${HOME}/.kube/config | grep "current-context:" | awk -F ": " '{ print $2 }')

		if [ ${CONTEXT} != "minikube" ]; then
			CONTEXT=$(echo ${CONTEXT} | awk -F "_" '{ print $2 }' | sed s/tredium-//g)
		fi

		if [ -n "$CONTEXT" ]; then
			echo "(k8s: ${CONTEXT})"
		fi
	else
		echo ""
	fi
}

################
#              #
# PSQL Helpers #
#              #
################

function run_pg()
{
	docker run -d -p ${2:-5432}:5432 -v $HOME/sql:/mnt/startup -e POSTGRES_PASSWORD=password --name=${1:-postgres} docker.tredium.com/tredium/alpine-postgres:9.6.8
}

function restore_pg()
{
	pg_restore -h localhost -d nadb -U postgres -p ${2:-5432} -W -Fc < ${1:-nadb.dump}
}

function get_claim_from_auth()
{
	fname=clm.json

	sql=$(cat  <<- EOF
	SELECT str_value FROM sclaim.claim_field
	WHERE field_num = 'raw_request' AND
	claim_field_id = (
		SELECT claim_field_id FROM sclaim.completed_claim
		WHERE auth_num = '${1}'
		)
	EOF
	)

	psql -q -c "\copy (${sql}) to ${fname};"
	ncpdp_to_json $fname
}

function get_claim_from_cfid()
{
	fname=clm.json

	sql=$(cat <<- EOF
	SELECT str_value
	FROM sclaim.claim_field
	WHERE field_num = 'raw_request'
	AND claim_field_id = ${1}
	EOF
	)

	psql -q -c "\copy (${sql}) to ${fname};"
	ncpdp_to_json $fname
}

##################
#                #
# Elixir Helpers #
#                #
##################

function ncpdp_to_json()
{
	if [[ -s ${1} ]]; then
		filename=${1%%.*}
		ext=${1##*.}

		sed -i.bak 's/^/{"transactionid":"aaaa","contents":"/;s/$/"}/' ${1}
		sed 's/B1/B2/' ${1} > ${filename}_r.${ext}
	else
		echo ${1} is empty
	fi
}

function send_claim()
{
	curl -d @${1} localhost:8080/claim/adjudicate
}

function mix_compile_warning_files()
{
	if [[ ! -p cmprslt ]]; then
		mkfifo cmprslt
	fi
	mix do clean, compile &> cmprslt | grep "${1}" cmprslt
}
