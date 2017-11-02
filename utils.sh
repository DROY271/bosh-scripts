
error() {
	>&2 echo $1
}

prerequisite() {
	if [[ ! `which $1` ]]; then
		 error "Requires executable $1"
	   exit 1;
  fi
}
