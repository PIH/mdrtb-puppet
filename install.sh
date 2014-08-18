puppet apply -v \
  --detailed-exitcodes \
  --logdest=console \
  --logdest=syslog \
  manifests/site.pp