addGstreamer0LibPath() {

  if [[ -d "${1}/lib/gstreamer-0.10" ]] ; then
    export GST_PLUGIN_SYSTEM_PATH_1_0="${GST_PLUGIN_SYSTEM_PATH_1_0}${GST_PLUGIN_SYSTEM_PATH_1_0:+:}${1}/lib/gstreamer-0.10"
  fi

}

envHooks+=('addGstreamer0LibPath')
