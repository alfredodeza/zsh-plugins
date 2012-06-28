#compdef cdp

_cdp_commands() {
  # this function calls IPython and loops over the list of apps and options
  # and constructs the help menu with it

  local line
  local -a cmdlist
  _call_program commands "python -c \"exec('from IPython.core.completerlib import module_completion\nfor i in module_completion(\'import \'): print i')\"" | while read -A line; do
     cmdlist=($cmdlist "${line[1]}")
     #cmdlist=($cmdlist "${line[1]%,}:${line[2,-1]}")
   done

 _describe -t commands 'python modules' cmdlist && ret=0
}

_cdp() {
  local curcontext=$curcontext ret=1
  local curcontext=$curcontext ret=1

  if ((CURRENT == 2)); then
    _cdp_commands
  fi
  #if [[ "$PREFIX" = * ]]; then
    #_cdp_commands
  #else
    #_files
  #fi
}

compdef _cdp cdp
