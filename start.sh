#!/usr/bin/env bash

ub_bootstrap() {
    # If we can list a private repo then we must already have an SSH key configured
    git ls-remote git@github.com:unibuddy-labs/oh-my-wsl.git >/dev/null 2>&1  || {

        # No git access; create a new SSH key and configure git
        echo 'Please provide the email you use to connect to Unibuddt github, and your full name'
        read -p 'e-mail address: ' email
        read -p 'full name: ' name
        ssh-keygen -q -t rsa -N '' -C ${email} -f ~/.ssh/id_rsa <<<y 2>&1 >/dev/null
        git config --global user.name ${name}
        git config --global user.email ${email}
        
        # Ask the user to add this key to github
        echo 'Please add the following SSH key to yourt github access keys'
        cat ~/.ssh/id_rsa.pub
        read -s -n 1 -p 'Press any key to continue once done ...'
        echo ''
    
        # Did that work
        git ls-remote git@github.com:unibuddy-labs/oh-my-wsl.git >/dev/null 2>&1  || {
        
            # Failed to get access
            echo 'You do not have access to the unibuddy-labs/oh-my-wsl repository, please try again'
            return
        }
    }
    
    # Make sure the root folder for storing source code exists
    UBSRC=${UBSRC:-/ub}
    if [ ! -s $UBSRC ]; then
        sudo mkdir -p $UBSRC
        sudo chmod 777 $UBSRC
    fi
    
    # Install unibuddly-labs/oh-my-wsl
    cd $UBSRC
    git clone git@github.com:unibuddy-labs/oh-my-wsl.git
    cd oh-my-wsl
    git checkout main
    bash install.sh
}

echo Bootstrapping oh-my-wsl ...
ub_bootstrap
echo All done!

