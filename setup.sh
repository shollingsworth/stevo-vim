#!/usr/bin/env bash
IFS=$'\n\t'

mydir=$(dirname $0)

err() {
    echo "${1?"argv[1]: error text"}"
    exit -1
}

packages+=("vim-pathogen")

clones+=("https://github.com/Valloric/YouCompleteMe.git")
clones+=("https://github.com/davidhalter/jedi.git")
clones+=("https://github.com/davidhalter/jedi-vim.git")
clones+=("https://github.com/ervandew/supertab.git")
clones+=("https://github.com/plasticboy/vim-markdown.git")
clones+=("https://github.com/Raimondi/delimitMate.git")
clones+=("https://github.com/SirVer/ultisnips.git")
clones+=("https://github.com/Valloric/ycmd")
clones+=("https://github.com/honza/vim-snippets.git")
clones+=("https://github.com/Lokaltog/vim-easymotion")

install_pathogen() {
    sudo apt install ${packages[@]} || err "Error installing packages ${packages[@]}"
}

copy_files() {
    mkdir -pv ~/.vim/
    cp -av ${mydir}/skel/* ~/.vim || err "Error copying skeleton directory"
    ln -sv ~/.vim/vimrc ~/.vimrc
}

install_plugins() {
    pushd ~/.vim/bundle || err "Error changing directory to install plugin"
    for clone in ${clones[@]}; do
        git clone ${clone} || err "Error cloning ${clone}!"
    done
}

submodule_updates() {
    for dir in $(find ~/.vim/bundle -type d -maxdepth 1); do
        pushd ${dir}
        git submodule update --init --recursive
    done
}

install_pathogen
copy_files
install_plugins
submodule_updates
