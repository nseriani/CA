#   Name of the fortran compiler
#   \
#
#
#TARGET = intel laptop
SHELL = /bin/bash

.SUFFIXES : .o .c .f .f90 .F90


GFC = gfortran
GOPTFLAGS = -ffast-math -funroll-loops -O3
GDEBUGFLAGS = -Wall -g  -C -DEBUG -fbounds-check
IOPTFLAGS = -O3 -ipo -static-libcxa
IMOPTFLAGS = -g0 
IDEBUGFLAGS = -g -C -debug extended -debug inline_debug_info -traceback 
IFC = ifort 
ILDFLAGS = #-lg2c
#

SETARCH = LAPTOP

# Prepreocessing needed to produce an environment report at the
# beginning of the calculation.
#
# Get the version control id.  Works with either svn or git or if no VCS is used.
# Outputs a string.
VCS_VER:=$(shell set -o pipefail && echo -n \" && ( if [[ -e .svn ]]; then svnversion; else (git svn info | grep 'Revision' | sed -e 's/Revision: //' ) ||  git log --max-count=1 --pretty=format:%H || echo -n 'Not under version control.'; fi)   2> /dev/null | tr -d '\r\n'  && echo -n \")
# Test to see if the working directory contains changes. Works with either svn or git.
# If the working directory contains changes (or is not under version control) then
# the _WORKING_DIR_CHANGES flag is set.
WORKING_DIR_CHANGES := $(shell (if [[ -e .svn ]]; then test -z "`svn st -q`" ; else (git diff --quiet --cached && git diff --quiet) 2> /dev/null ; fi) || echo -n "-D_WORKING_DIR_CHANGES")
#
CPPDEFS=-D__PARALLEL -D_VCS_VER='$(VCS_VER)'
CPPFLAGS= $(WORKING_DIR_CHANGES)

lazser : 
	make lazser.x FC=$(GFC) FLAGS="$(GOPTFLAGS)" LDFLAGS="$(GLDFLAGS)" \
	ARCH=$(G$(SETARCH)) ARCHFLAGS="$(GARCHFLAGS)"

LIBCOMMON =     

LIBTRAJ = 	lazser.o \
		init.o \
                scvonneumann.o \
                cellular.o \
                scmoore.o

lazser.x : $(LIBCOMMON) $(LIBTRAJ)
	$(FC) -o lazser.x $(FLAGS) $(ARCHFLAGS)$(ARCH) $(LDFLAGS) $(LIBCOMMON) $(LIBTRAJ)

.f.o:
	$(FC) $(FLAGS) $(ARCHFLAGS)$(ARCH) -c $<
%.o: %.F90
	$(FC) $(CPPDEFS) $(CPPFLAGS) $(FFLAGS) -c $< 
.f90.o:
	$(FC) $(FLAGS) $(ARCHFLAGS)$(ARCH) -c $<
clean :
	@-rm *.o *.mod *.x libasap.a
tar :
	cd $(HOME) ; tar -cvf code.tar Code/*.f Code/makefile Code/dependencies ; gzip code.tar

libasap.a: $(LIBCOMMON) $(LIBTRAJ)
	ar src $@ $?
