A collection of ZSH plugins, mostly completion ones that can be
installed as oh-my-zsh plugins or sourced directly.

pytest
======
Provides basic autocompletion of commands, including custom 
plugins. There are no other commands provided for this plugin.

python
======


activate
--------
Are you up to 15 levels deep into a path and need to activate your Python
environment? This command will traverse backwards to activate it for you
without changing directories when no arguments are passed::

    activate

Do you have a list of different paths for different environments? List them
in a zsh array in your `.zshrc` file like so::

    virtual_envs=(/path/to/venvs /secondary/path)

So that if you provide and argument that matches a virtualenv in any of those
directories it will activate it and place you in that same directory. This will
happen only when arguments are passed in and when `virtual_envs` is set.

For example, if `test_project` is a virtual environment that lives in
`/path/to/envs` then this would activate it::

    activate test_project

cdp
---
Changes directory to the directory that holds a Python module.
Takes a single argument, and must be the name of a python module. For example::

    cdp os

Would change directories into the path where os.py exists.

pyclean
-------
Removes `*.pyc` and `*.pyo` files from the current working directory.
