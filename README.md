A s'imple setup with cmake and makefile for create a project with vulkan and sdl

cd vulksdl
rename the NAME in settings/build.mk and the NAME_OUT for name exec
make
make run
and enjoy :)

src/class.hpp is not updatable but update with all automaticaly

for wsl1 install settings/xcvserv/vcxsrv-64.1.20.14.0.installer.exe
export DISPLAY=$(shell ip route | grep default | awk '{print $$3}'):0.0
