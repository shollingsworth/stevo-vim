#!/usr/bin/env bash
IFS=$'\n\t'
mydir=$(dirname $0)

release_file="/etc/os-release"

if [[ ! -e "${release_file}" ]]; then
    echo "Error, cannot see my OS info in ${release_file}"
    exit -1
else
    source /etc/os-release
fi

deb_pathogen="vim-pathogen"
git_pathogen="https://github.com/tpope/vim-pathogen.git"

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

err() {
    echo "${1?"argv[1]: error text"}"
    exit -1
}

install_fzf() {
    echo "Installing FZF"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}

check_git() {
    which git &>/dev/null || err "Error, please install git first"
}

i_hate_centos_7() {
    yum -y remove vim-enhanced vim-common vim-filesystem
    yum clean all
    yum -y groupinstall "Development tools"
    yum -y install ncurses ncurses-devel
    yum install -y ruby ruby-devel lua lua-devel luajit luajit-devel ctags git python python-devel python3 python3-devel tcl-devel perl perl-devel perl-ExtUtils-ParseXS perl-ExtUtils-XSpp perl-ExtUtils-CBuilder perl-ExtUtils-Embed yum-plugin-versionlock
    yum versionlock vim-*
    pushd /usr/local/src
    test -d vim && rm -rfv vim
    git clone https://github.com/vim/vim.git
    pushd vim
    make distclean
    opts+=("--enable-python3interp")
    opts+=("--enable-rubyinterp")
    opts+=("--enable-luainterp")
    opts+=("--enable-perlinterp")
    opts+=("--enable-terminal")
    opts+=("--enable-multibyte")
    opts+=("--disable-gtktest")
    opts+=("--disable-darwin")
    opts+=("--disable-gpm")
    opts+=("--prefix=/usr")
    opts+=("--with-features=huge")
    opts+=("--enable-pythoninterp")
    ./configure ${opts[@]} || {
       echo "Error compiling"
       exit -1
    }
    make
    make install
}

install_pathogen() {
    case "${ID}" in
        centos)
            mkdir -p ~/repos
            pushd ~/repos
            git clone ${git_pathogen}
            clone_dir=$(echo ${git_pathogen} | awk -F '/' '{print $NF}' | sed 's/\.git$//')
            cp -av ${clone_dir}/autoload ~/.vim
            i_hate_centos_7
            ;;
        kali|ubuntu)
            sudo apt install ${deb_pathogen} || err "Error installing packages ${deb_pathogen}"
            ;;
    esac
}


copy_files() {
    mkdir -pv ~/.vim/
    cp -av ${mydir}/skel/* ~/.vim || err "Error copying skeleton directory"
    ln -sv ~/.vim/vimrc ~/.vimrc
}

install_plugins() {
    rm -rfv ~/.vim/bundle/*
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

check_git
# order is important here
copy_files
install_plugins
submodule_updates
install_pathogen
echo "=============================="
echo "vim install DONE!"
echo "=============================="
