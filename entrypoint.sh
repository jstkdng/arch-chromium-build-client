#!/bin/sh -l

# switch to canada mirror
echo "Server = http://archlinux.mirror.colo-serv.net/\$repo/os/\$arch" | sudo tee /etc/pacman.d/mirrorlist

# update packages
sudo pacman -Syu --noconfirm

# change permissions
sleep 30
sudo chown -R build $HOME

# switch to repo
cd $HOME/repo

echo "Starting build..." > logfile

# wait for workers
go run .github/workflows/wait_workers.go |& tee -a logfile

# start build
makepkg --syncdeps --noconfirm |& tee -a logfile

# terminate workers
go run .github/workflows/end_workers.go |& tee -a logfile
