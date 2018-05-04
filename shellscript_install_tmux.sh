# Install tmux on Centos release 6.5
# Install with user defined prefix

# Usage: ./install_tmux.sh /your/prefix

# install deps
# yum install gcc kernel-devel make ncurses-devel

if [ -z $1 ]
then
    echo "Usage: ./install_tmux.sh /your/prefix"
    exit 1
fi

prefix=$(readlink -f $1)

# DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
(
        if [ ! -f libevent-2.0.21-stable.tar.gz ]
        then
                curl -OL https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
        fi
        rm -rf libevent-2.0.21-stable
        tar -xvzf libevent-2.0.21-stable.tar.gz
        cd libevent-2.0.21-stable &&  ./configure --prefix="$prefix" &&  make && make install
)
if [ $? != 0 ]
then
        echo libevent failed
        exit 1
fi

# DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
(
if [ ! -f tmux-2.3.tar.gz ]
then
        wget -O tmux-2.3.tar.gz https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz
fi
rm -rf tmux-2.3
tar -xvzf tmux-2.3.tar.gz
cd tmux-2.3
export CFLAGS="-I$prefix/include"
export LDFLAGS="-L$prefix/lib -Wl,-rpath=$prefix/lib"
./configure --prefix=$prefix
make && make install
)
if [ $? != 0 ]
then
        exit 1
fi

${prefix}/bin/tmux -V
