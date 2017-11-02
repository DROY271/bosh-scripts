
function dispatch() {
  case $1 in
  start)
     start; ;;
  stop)
     stop; ;;
  *)
  	 error "$0 start|stop"
  	 exit 1; ;;
  esac
}
