gtk3AppsWrapperArgs=()

findGioModules() {

  if [[ -d "${1}/lib/gio/modules" && \
        -n "$(ls -A "${1}/lib/gio/modules")" ]] ; then
    gtk3AppsWrapperArgs+=("--prefix GIO_EXTRA_MODULES : ${1}/lib/gio/modules")
  fi

}

wrapGtk3AppsHook() {

  local dummy
  local i
  local v

  if [[ -n "${GDK_PIXBUF_MODULE_FILE}" ]] ; then
    gtk3AppsWrapperArgs+=(
      "--set GDK_PIXBUF_MODULE_FILE ${GDK_PIXBUF_MODULE_FILE}"
    )
  fi

  if [[ -n "${XDG_ICON_DIRS}" ]] ; then
    gtk3AppsWrapperArgs+=("--prefix XDG_DATA_DIRS : ${XDG_ICON_DIRS}")
  fi

  if [[ -n "${GSETTINGS_SCHEMAS_PATH}" ]] ; then
    gtk3AppsWrapperArgs+=("--prefix XDG_DATA_DIRS : ${GSETTINGS_SCHEMAS_PATH}")
  fi

  if [[ -d "${prefix}/share" ]] ; then
    gtk3AppsWrapperArgs+=("--prefix XDG_DATA_DIRS : ${prefix}/share")
  fi

  for v in \
    "${wrapPrefixVariables}" \
    'GST_PLUGIN_SYSTEM_PATH_1_0' \
    'GI_TYPELIB_PATH' \
    'GRL_PLUGIN_PATH' ; do
    eval dummy="\$$v"
    gtk3AppsWrapperArgs+=("--prefix ${v} : ${dummy}")
  done

  if [[ "${dontWrapGtk3Apps}" != true && \
        -n "${gtk3AppsWrapperArgs[@]}" ]] ; then
    for i in \
      "${prefix}/bin/"* \
      "${prefix}/libexec/"* ; do
      echo "Wrapping GTK+3 app ${i}"
      wrapProgram "${i}" "${gtk3AppsWrapperArgs[@]}"
    done
  fi

}

envHooks+=('findGioModules')
fixupOutputHooks+=('wrapGtk3AppsHook')
