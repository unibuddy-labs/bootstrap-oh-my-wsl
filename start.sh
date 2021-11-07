#!/usr/bin/env bash

ub_bootstrap() {

    # Ensure the root folder for storing source code exists
    UBSRC=${UBSRC:-/ub}
    if [ ! -d $UBSRC ]; then
        sudo mkdir -p $UBSRC
        sudo chmod 777 $UBSRC
    fi

    # Configure git
    gitconfig=${UBSRC}/.gitconfig.done
    if [ ! -f $gitconfig ]; then
        echo 'Please provide the email you use to connect to Unibuddy github, and your full name'
        read -p 'e-mail address: ' email
        read -p 'full name: ' name
        git config --global user.email "${email}"
        git config --global user.name "${name}"
        echo "Installed" > $gitconfig
    fi

    # Configure SSH
    if [ ! -f ~/.ssh/id_rsa_ub ]; then

        # No Unibuddy SSH key, so generate it
        ssh-keygen -q -t rsa -N '' -C ${email} -f ~/.ssh/id_rsa_ub <<<y 2>&1 >/dev/null
        echo 'Please add the following SSH key to yourt github access keys'
        cat ~/.ssh/id_rsa_ub.pub
        read -s -n 1 -p 'Press any key to continue once done ...'
        echo ''

        # Configure SSH to use this key for github
        sshconfig=~/.ssh/config
        echo 'Host unibuddy ub github.com' > $sshconfig
        echo -e '\tHostName github.com' >> $sshconfig
        echo -e '\tIdentityFile ~/.ssh/id_rsa_ub' >> $sshconfig
    fi

    # Check this config is OK by listing a private repo
    git ls-remote git@unibuddy:unibuddy-labs/oh-my-wsl.git >/dev/null 2>&1  || {

        # No access to Unibuddy private git repository
        echo 'You do not have access to the unibuddy-labs/oh-my-wsl repository, please try again'
        return
    }
    
    # Install or update unibuddy-labs/oh-my-wsl
    cd $UBSRC
    if [ ! -d ${UBSRC}/oh-my-wsl ]; then
        git clone git@unibuddy:unibuddy-labs/oh-my-wsl.git
    else
        cd oh-my-wsl
        git checkout main &> /dev/null
        git pull &> /dev/null
    fi
    bash ${UBSRC}/oh-my-wsl/install.sh
}

ub_bootstrap
