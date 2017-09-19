#compdef pytest

_pytest_commands() {
  # this function calls pytest and loops over the list of apps and options
  # and constructs the help menu with it

  local line
  local -a cmdlist
  _call_program commands pytest --help | while read -A line; do
     # add dashed options for completion only
     if ! [[ $line[1] =~ ^- ]]; then
         continue
     fi
     # Remove `=` operator example values from the help output
     if [[ $line[1] =~ \= ]]; then
         line[1]=${line[1][(ws/=/)1]}\=
     fi
     cmdlist=($cmdlist "${line[1]%,}:${line[2,-1]}")

   done

 _describe -t commands 'pytest commands' cmdlist && ret=0
}

_pytest() {
  local curcontext=$curcontext ret=1

  if [[ "$PREFIX" = -* ]]; then
    _pytest_commands
  else
    _files
  fi
}

compdef _pytest pytest
