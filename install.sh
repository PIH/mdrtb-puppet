puppet apply -v \
  --detailed-exitcodes \
  --logdest=console \
  --logdest=syslog \
  --modulepath=./modules \
  manifests/site.pp