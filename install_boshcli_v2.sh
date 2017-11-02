function install_bosh_cli() {
	prerequisite 'wget'
	if [ ! `which bosh2` ]; then
		if [[ $OSTYPE == "darwin"* ]]; then
		  BOSH_CLI_URL=https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.44-darwin-amd64
		elif [[ $OSTYPE == "linux-gnu" ]]; then
			BOSH_CLI_URL=https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.44-linux-amd64
		fi
		echo "Identified bosh2 cli location as " $BOSH_CLI_URL
		wget -c $BOSH_CLI_URL -O ./downloads/bosh-cli-install
		if [ -e ./downloads/bosh-cli-install ]; then
			chmod +x ./downloads/bosh-cli-install
			mv ./downloads/bosh-cli-install /usr/local/bin/bosh2
		fi
	fi
}
