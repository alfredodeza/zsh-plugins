#compdef cdp try

_cdp_commands() {
  # this function calls IPython and loops over the list of modules
  # available in a given context. It is a bit slow and I have no idea
  # how to make it faster rather than using cache which I can't figure out

  local line
  local -a cmdlist
  _call_program commands "python -c \"exec('from IPython.core.completerlib import module_completion\nfor i in module_completion(\'import \'): print i')\"" | while read -A line; do
     cmdlist=($cmdlist "${line[1]}")
   done

 _describe -t commands 'python modules' cmdlist && ret=0
}

_cdp() {
  local curcontext=$curcontext ret=1

  if ((CURRENT == 2)); then
    _cdp_commands
  fi
}

compdef _cdp cdp try
