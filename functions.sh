#!/bin/bash

# Copyright (C) 2013 Gilles DOFFE <gdoffe@gmail.com>

# This program is free software, distributed under the Apache License
# version 2.0, as well as the GNU General Public License version 3, at
# your own convenience. See LICENSE.apache-2.0 and LICENSE.GPLv3 for details.

# Generic tool functions to import in external scripts

BST_COLUMNS=$(tput cols)
BST_DEFAULT_COLOR=$(tput sgr0)
BST_GREEN=$(tput setaf 2)
BST_RED=$(tput setaf 1)
BST_ORANGE=$(tput setaf 3)

check_result()
{
  if [ "${1}" != "0" ]; then
    print_ko
    if [ ! -z "${2}" ]; then
      print_out "${BST_RED}${2}${BST_DEFAULT_COLOR}"
    fi
  exit ${1}
  fi
}

init_output()
{
  if [ $1 != "0" ]; then
    BST_VERBOSE=1
  else
    BST_VERBOSE=0
  fi

  if [ "$2" != "" ]; then
    BST_TARGET_DIR=${2%/}.log
  else
    BST_TARGET_DIR=/dev/null
  fi

  # If verbose, display command output
  if [ "${BST_VERBOSE}" = "0" ]; then
    exec 6>&1
    exec 7>&2

    exec 1>${BST_TARGET_DIR}
    exec 2>&1
  fi
}

reset_output()
{
  if [ "${BST_VERBOSE}" = "0" ]; then
    exec 1>&6 6>&-
    exec 2>&7 7>&-
  fi
}

print_noln()
{
  if [ "${BST_VERBOSE}" = "0" ]; then
    print_noln_ "${*}" &
  else
    print_out_ "${*}" &
  fi
  wait $!
  string="${*}"
  str_size=${#string}
}

print_noln_()
{
  if [ "${BST_VERBOSE}" = "0" ]; then
    exec 1>&6 6>&-
  fi
  printf "${*}"
}

print_out()
{
  print_out_ "${*}" &
  wait $!
}

print_out_()
{
  if [ "${BST_VERBOSE}" = "0" ]; then
    exec 1>&6 6>&-
  fi
  echo "${*}"
}

print_ok()
{
  shift
  print_ok_ &
  wait $!
}

print_ko()
{
  shift
  print_ko_ &
  wait $!
}

print_warn()
{
  shift
  print_warn_ &
  wait $!
}

print_ok_()
{
  if [ "${BST_VERBOSE}" = "0" ]; then
    exec 1>&6 6>&-
    column=$((BST_COLUMNS - str_size))
    printf "%${column}s" "[${BST_GREEN}OK${BST_DEFAULT_COLOR}]"
    echo
  fi
}

print_ko_()
{
  if [ "${BST_VERBOSE}" = "0" ]; then
    exec 1>&6 6>&-
    column=$((BST_COLUMNS - str_size))
    printf "%${column}s" "[${BST_RED}KO${BST_DEFAULT_COLOR}]"
    echo
  fi
}

print_warn_()
{
  if [ "${BST_VERBOSE}" = "0" ]; then
    exec 1>&6 6>&-
    column=$((BST_COLUMNS - str_size))
    printf "%${column}s" "[${BST_ORANGE}--${BST_DEFAULT_COLOR}]"
    echo
  fi
}
