
function dispatch() {
  case $1 in
  start)
     start; ;;
  stop)
     stop; ;;
  install)
     install_bosh_cli; ;;
  *)
  	 error "$0 start|stop"
  	 exit 1; ;;
  esac
}
