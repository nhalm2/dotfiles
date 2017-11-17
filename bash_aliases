function image {
	echo "    Project: $(kubectl config current-context)"
        kubectl describe pods $(kubectl get pods | grep $1 | awk '{ print $1 }') | grep 'Image:'
}

function showpod {
	echo "Project: $(kubectl config current-context)"
        kubectl get pods | grep $1
}

function gssh {
#connect to util-1 server of project you pass in
#eg. gssh tredium-scl-pharm-ltc
        ssh-add ~/.ssh/google_compute_engine
	zone=$(gcloud compute instances list --project ${1} --filter="Name:util-1" --format='value(zone)')
	#echo "util-1 zone: ${zone}"
        gcloud compute ssh --zone ${zone} --project $1 util-1 --ssh-flag='-A'
}

function gport {
#connect to util-1 server of project you pass in, and setup port forward you set in second parameter
#eg gport tredium-scl-pharm-ltc "5432:pgpool:5432"
	ssh-add ~/.ssh/google_compute_engine
	zone=$(gcloud compute instances list --project ${1} --filter="Name:util-1" --format='value(zone  )')
	gcloud compute ssh --zone ${zone} --project $1 util-1 --ssh-flag='-A' --ssh-flag='-L' --ssh-flag="$2"
}
