# remove pyc files
alias pyclean='find . -type f -name "*.py[co]" -exec rm -f \{\} \; && find . -type d -name "__pycache__" | xargs rm -r && echo "Removed pycs and __pycache__"'

# Does my python module exist?
try() {
    python -c "exec 'try: import ${1} as _; print _.__file__\nexcept Exception, e: print e'"
}

# change to python package directory
cdp() {
    module=$(sed 's/-/_/g' <<< $1)
    MODULE_DIRECTORY=`python -c "exec 'try: import os.path as _, ${module}; print _.dirname(_.realpath(${module}.__file__))\nexcept Exception, e: print e'"`
    if  [[ -d $MODULE_DIRECTORY ]]; then
        cd $MODULE_DIRECTORY
    else
        echo "Module ${1} was not found or is not importable: $MODULE_DIRECTORY"
    fi
}

# change to python package directory
cdp3() {
    MODULE_DIRECTORY=`python3 -c "exec('try: import os.path as _, ${1}; print(_.dirname(_.realpath(${1}.__file__)))\nexcept Exception as e: print(e)')"`
    if  [[ -d $MODULE_DIRECTORY ]]; then
        cd $MODULE_DIRECTORY
    else
        echo "Module ${1} was not found or is not importable: $MODULE_DIRECTORY"
    fi
}

walkup() {
    FILE="$1"
    let "LEVEL = $2 + 1"
    if [[ -f $1 ]]; then
        echo "$1"
    elif [[ $LEVEL -ge 15 ]]; then
        return
    else
        walkup ../$1 $LEVEL
    fi
}

mkv() {
    # A helper to create virtualenvs
    if [[ -n  $virtualensvhome ]] ; then
        echo "\nThe virtualenvshome variable is not set. Try setting it with"
        echo "the absolute paths of the home for your virtualenvs::\n"
        echo " virtualenvshome=$HOME/.virtualenvs"
        echo ""
        return
    fi
    if [[ $# -eq 1 ]]; then
        for dir in $virtualenvshome; do
            if [[ $dir == $1 ]]; then
                echo "virtualenv $1 already exists, activating..."
                . $dir/bin/activate
                return 0
            else
                virtualenv "$virtualenvshome/$1"
                return 0
            fi
        done
    else
        echo "err... you need to give me a name for the virtualenv to create"
    fi
}


activate() {
    if ! (( $#virtual_envs )) ; then
        echo "\nThe virtual_envs variable is not set. Try setting it with"
        echo "the absolute paths of your environments::\n"
        echo " virtual_envs=(/some/path /other/path)"
        echo ""
        return
    fi
    cwd=`pwd`
    if [[ $# -eq 1 ]]; then
        for dir in $virtual_envs; do
            for i in `ls $dir`; do
                if [[ $i == $1 ]]; then
                    if [[ -d $dir/$i ]] && [[ -f $dir/$i/bin/activate ]]; then
                        . $dir/$i/bin/activate
                        builtin \cd "$cwd"
                        return 0
                    fi
                fi
            done
        done
        echo "No virtualenvs where matched for activation."
    else
         virtualenv="$(walkup bin/activate)"
         if [[ $virtualenv != "" ]]; then
             source $virtualenv
         fi
    fi
}

welp() {
    P_VERSION=`python -c "exec 'try: import pkg_resources; print pkg_resources.get_distribution(\'${1}\').version\nexcept Exception: print \'Not found\''"`
    P_PATH=cdp
    echo "Path: $(try ${1})"
    echo "Version: ${P_VERSION}"
}


mpass() {
    if [ $1 ]; then
        length=$1
    else
        length=12
    fi
    _hash=`python -c "exec 'import os; print os.urandom(30).encode(\'base64\')[:${length}]'"`
    echo $_hash | pbcopy
    echo "new password copied to the system clipboard"
}
