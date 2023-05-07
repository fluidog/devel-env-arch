FROM archlinux
LABEL authors="fluidog@163.com"

SHELL ["/bin/bash", "-c"]
USER root

# mirror
RUN curl -s "https://archlinux.org/mirrorlist/?country=CN&protocol=https&use_mirror_status=on" |\
	sed -e 's/^#Server/Server/' -e '/^#/d' |\
	cat > /etc/pacman.d/mirrorlist &&\
	pacman --noconfirm -Syyuu

# localize
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
	sed --in-place --regexp-extended -e 's,^#en_US.UTF-8 UTF-8,en_US.UTF-8 UTF-8,' /etc/locale.gen &&\
	locale-gen &&\
	echo LANG=en_US.UTF-8 >> /etc/locale.conf


# core packages
RUN pacman --noconfirm -S git vim openssh rsync man-db man-pages

# docker
RUN pacman --noconfirm -S docker docker-compose

# c/c+
RUN pacman --noconfirm -S base-devel


# terminal environment: zsh ohmyzsh starship
RUN { : "zsh" &&\
        pacman --noconfirm -S zsh &&\
        chsh -s /bin/zsh ;} &&\
        { : "ohmyzsh" &&\
        git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh &&\
        cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc &&\
        sed -i -e 's/^plugins=(git)/plugins=(git\n)/' ~/.zshrc &&\
        sed -i -e '/^plugins=(git/a \docker z zsh-navigation-tools command-not-found aliases'\
                -e 's/^# export LANG=en_US.UTF-8/export LANG=en_US.UTF-8/' ~/.zshrc &&\
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git\
                ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &&\
        sed -i -e '/^plugins=(git/a \zsh-syntax-highlighting' ~/.zshrc &&\
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git \
                ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &&\
        sed -i -e '/^plugins=(git/a \zsh-autosuggestions' ~/.zshrc ;} &&\
        { : "strship" &&\
        curl -sS https://starship.rs/install.sh | sh -s -- --yes &&\
        echo 'eval "$(starship init zsh)"' >> ~/.zshrc ;}

# linux kernel development
RUN pacman --noconfirm -S qemu

# nodejs

# other 
RUN pacman --noconfirm -S pacman-contrib

ADD config /usr/local/config/
ADD entry.sh /usr/local/bin/

RUN ssh-keygen -f ~/.ssh/id_rsa -N "" && \
	mkdir -p ~/.config && \
	ln -s /usr/local/config/starship.toml ~/.config/starship.toml


CMD [ "/bin/bash", "/usr/local/bin/entry.sh"]
