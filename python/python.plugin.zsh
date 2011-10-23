# remove pyc files
alias pyclean='find . -type f -name "*.py[co]" -exec rm -f \{\} \;'

# change to python package directory
cdp() {
    cd $(python -c "import os.path as _, ${1}; print _.dirname(_.realpath(${1}.__file__))")
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

activate() {
    if ! (( $#virtual_envs )) ; then
        echo "\nThe virtual_envs variable is not set. Try setting it with"
        echo "the absolute paths of your environments::\n"
        echo " virtual_envs=(/some/path /other/path)"
        echo ""
        return
    fi
    if [[ $# -eq 1 ]]; then
        for dir in $virtual_envs; do
            for i in `ls $dir`; do
                if [[ $i == $1 ]]; then
                    if [[ -d $dir/$i ]] && [[ -f $dir/$i/bin/activate ]]; then
                        . $dir/$i/bin/activate
                        cd $dir/$i
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
