#/bin/bash

W=`pwd`

BOSH_DEPLOYMENT="$W/workspace/bosh-deployment"

error() {
	>&2 echo $1
}

prerequisite_check() {
	if [ ! `which git` ]; then
		error "Script requires git."
	fi
}

get_bosh_release() {
	if [ ! -d  "$BOSH_DEPLOYMENT"]; then
		mkdir -p "$BOSH_DEPLOYMENT"
		git clone 'https://github.com/cloudfoundry/bosh-deployment' "$BOSH_DEPLOYMENT"
	fi
}

# Starts the bosh-lite director.
start() {

	if [ ! -d "$W/deployments/vbox" ]; then
	  mkdir -p "$W/deployments/vbox"
	fi
	cd deployments/vbox

	bosh2 create-env "$BOSH_DEPLOYMENT/bosh.yml" \
	--state ./state.json \
	-o "$BOSH_DEPLOYMENT/virtualbox/cpi.yml" \
	-o "$BOSH_DEPLOYMENT/virtualbox/outbound-network.yml" \
	-o "$BOSH_DEPLOYMENT/bosh-lite.yml" \
	-o "$BOSH_DEPLOYMENT/bosh-lite-runc.yml" \
	-o "$BOSH_DEPLOYMENT/jumpbox-user.yml" \
	--vars-store ./creds.yml \
	-v director_name="Bosh Lite Director" \
	-v internal_ip=192.168.50.6 \
	-v internal_gw=192.168.50.1 \
	-v internal_cidr=192.168.50.0/24 \
	-v outbound_network_name=NatNetwork

  #Output a login file.
  cat >$W/login <<'EOF'
bosh2 alias-env vbox -e 192.168.50.6 --ca-cert <(bosh2 int ./deployments/vbox/creds.yml --path /director_ssl/ca)
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=`bosh2 int ./deployments/vbox/creds.yml --path /admin_password`
bosh2 -e vbox env
EOF

	echo "Run 'source ./login' from the command to prepare the shell."

}

#Stops the bosh-lite director
stop() {
	W=`pwd`
	rm $W/login 2>/dev/null
	cd deployments/vbox
	bosh2 delete-env "$BOSH_DEPLOYMENT/bosh.yml" \
	  --state ./state.json \
	  -o "$BOSH_DEPLOYMENT/virtualbox/cpi.yml" \
	  -o "$BOSH_DEPLOYMENT/virtualbox/outbound-network.yml" \
	  -o "$BOSH_DEPLOYMENT/bosh-lite.yml" \
	  -o "$BOSH_DEPLOYMENT/bosh-lite-runc.yml" \
	  -o "$BOSH_DEPLOYMENT/jumpbox-user.yml" \
	  --vars-store ./creds.yml \
	  -v director_name="Bosh Lite Director" \
	  -v internal_ip=192.168.50.6 \
	  -v internal_gw=192.168.50.1 \
	  -v internal_cidr=192.168.50.0/24 \
  	-v outbound_network_name=NatNetwork
}

#Dispatch the invocation.
case $1 in
start)
   start; ;;
stop)
   stop; ;;
*)
	 >&2 echo "$0 start|stop"
	 exit 1; ;;
esac
