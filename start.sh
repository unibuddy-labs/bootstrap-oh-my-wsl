#!/usr/bin/env bash

ub_bootstrap() {

    # Ensure the root folder for storing source code exists
    UBSRC=${UBSRC:-/ub}
    if [ ! -d $UBSRC ]; then
        sudo mkdir -p $UBSRC
        sudo chmod 777 $UBSRC
    fi

    # Configure git
    echo 'Please provide the email you use to connect to Unibuddy github, and your full name'
    read -p 'e-mail address: ' email
    git config --global user.email ${email}
    read -p 'full name: ' name
    git config --global user.name "${name}"

    # Configure SSH
    ssh-keygen -q -t rsa -N '' -C ${email} -f ~/.ssh/id_rsa <<<y 2>&1 >/dev/null
    echo 'Please add the following SSH key to yourt github access keys'
    cat ~/.ssh/id_rsa.pub
    read -s -n 1 -p 'Press any key to continue once done ...'
    echo ''

    # Check this config is OK by listing a private repo
    git ls-remote git@github.com:unibuddy-labs/oh-my-wsl.git >/dev/null 2>&1  || {

        # No access to Unibuddy private git repository
        echo 'You do not have access to the unibuddy-labs/oh-my-wsl repository, please try again'
        return
    }
    
    # Install unibuddy-labs/oh-my-wsl
    cd $UBSRC
    if [ ! -d ${UBSRC}/oh-my-wsl ]; then
        git clone git@github.com:unibuddy-labs/oh-my-wsl.git
    fi
    cd oh-my-wsl
    git checkout main >/dev/null 2>&1
    git pull &> /dev/null
    bash ./install.sh
}

ub_bootstrap
