#!/bin/bash
# vim:tw=0:ts=2:sw=2:et:norl:
# Project: https://github.com/landonb/home-fries
# License: GPLv3

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

source_deps () {
  local curdir=$(dirname -- "${BASH_SOURCE[0]}")
  . "${curdir}/color_funcs.sh"
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

ensure_trashhome () {
  if [[ -z "${DUB_TRASHHOME}" ]]; then
    # Path is ~/.trash
    DUBS_USE_TRASH_DIR="${HOME}"
  else
    DUBS_USE_TRASH_DIR="${DUB_TRASHHOME}"
  fi
}

# Fix rm to be a respectable trashcan
#####################################

home_fries_create_aliases_trash () {
  # Remove aliases (where "Remove" is a noun, not a verb! =)
  $DUBS_TRACE && echo "Setting trashhome"
  ensure_trashhome

  alias rm='rm_safe'
  alias rmtrash='empty_trashes'
}

# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #

unset_f_trash_util () {
  unset -f source_deps

  unset -f home_fries_create_aliases_trash

  # So meta.
  unset -f unset_f_trash_util
}

main () {
  : #source_deps
  unset -f source_deps
}

main "$@"
unset -f main

