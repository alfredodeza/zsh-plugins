# remove pyc files
alias pyclean='find . \
    \( -type f -name "*.py[co]" -o -type d -name "__pycache__" \) -delete &&
    echo "Removed pycs and __pycache__"'

# Does my python module exist?
try() {
    python -c "
exec('''
try:
    import ${1} as _
    print(_.__file__)
except Exception as e:
    print(e)
''')"
}

# Activate and then change dirs to package directory
acdp2() {
    activate $1
    cdp $1
}

acdp() {
    activate $1
    cdp $1
}

# change to python package directory
cdp2() {
    module=$(sed 's/-/_/g' <<< $1)
    MODULE_DIRECTORY=`python -c "exec 'try: import os.path as _, ${module}; print _.dirname(_.realpath(${module}.__file__))\nexcept Exception, e: print(e)'"`
    if  [[ -d $MODULE_DIRECTORY ]]; then
        cd $MODULE_DIRECTORY
    else
        echo "Module ${1} was not found or is not importable: $MODULE_DIRECTORY"
    fi
}

csv2json () {
	python3 -c "
exec('''
import csv,json
print(json.dumps(list(csv.reader(open(\'${1}\')))))
''')
"
}


# change to python package directory
cdp() {
    module=$(sed 's/-/_/g' <<< $1)
    MODULE_DIRECTORY=`python -c "
exec('''
try:
    import os.path as _, ${module}
    print(_.dirname(_.realpath(${module}.__file__)))
except Exception as e:
    print(e)
''')"`
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

rmv() {
    #set -x
    # A helper to remove virtualenvs
    if [[ -n  $virtualensvhome ]] ; then
        echo "\nThe virtualenvshome variable is not set. Try setting it with"
        echo "the absolute paths of the home for your virtualenvs::\n"
        echo " virtualenvshome=$HOME/.virtualenvs"
        echo ""
        return
    fi

    if [[ $# -eq 1 ]]; then
        for dir in `find $virtualenvshome -maxdepth 1 -type d -name $1`; do
            echo "found virtualenv $1, removing... $dir"
            rm -rf "$dir"
            return 0
        done
        echo "could not find virtualenv $1, make sure it exists in $virtualenvshome/$1"
        return 1
    else
        echo "err... you need to give me a name for the virtualenv to create"
        return 1
    fi
}

mkv() {
    set -x
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
            echo $dir
            if [[ $dir == $1 ]]; then
                echo "virtualenv $1 already exists, activating..."
                . $dir/bin/activate
                return 0
            else
		python3 -m venv "$virtualenvshome/$1"
                #virtualenv -p python3.6 "$virtualenvshome/$1"
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
    P_VERSION=`python -c "
exec('''
try:
    import pkg_resources
    print(pkg_resources.get_distribution(\'${1}\').version)
except Exception:
    print(\'Not found\')
''')
"`
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
    _hash=`python3 -c "
import os,base64
exec('print(base64.b64encode(os.urandom(64))[:${length}].decode(\'utf-8\'))')
    "`
    echo $_hash | pbcopy
    #echo $_hash | xclip -selection clipboard
    echo "new password copied to the system clipboard"
}

# Read JSON input and export key/values as environment variables
j2env() {
    local JSON="$(< /dev/stdin)"
    PREFIX=$1
    python3 -c "
exec('''
import json
prefix = \'${PREFIX}\'
parsed = json.loads(\'\'\'${JSON}\'\'\')
count = 1
for key, value in parsed.items():
    print(f\"{ prefix }{ key.upper() }={ value.strip() }\")
    count +=1
''')" | while read -r value; do
            export $value;
        done
}


# Read JSON and extract a single value
jget() {
    KEY=$1
    # comes from STDIN
    local JSON="$(< /dev/stdin)"
    VALUE=`python3 -c "
exec('''
import json

parsed = json.loads(\'${JSON}\')
print(parsed.get(\'${KEY}\'))
''')"`
    echo $VALUE
}
