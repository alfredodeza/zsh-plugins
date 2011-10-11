#compdef pytest

_pytest_commands() {
  # this function calls py.test and loops over the list of apps and options
  # and constructs the help menu with it

  local line
  local -a cmdlist
  _call_program commands py.test --help | while read -A line; do
     # add dashed options for completion only
     if [[ $line[1] =~ ^- ]]; then
         cmdlist=($cmdlist "${line[1]%,}:${line[2,-1]}")
     fi

   done

 _describe -t commands 'py.test commands' cmdlist && ret=0
}

_pytest() {
  local curcontext=$curcontext ret=1

  if ((CURRENT == 2)); then
    _pytest_commands
  fi
}

compdef _pytest py.test
