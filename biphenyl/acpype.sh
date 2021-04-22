#!/bin/bash

smi="c1ccc(cc1)c2ccccc2"
name=biphenyl

export MKL_NUM_THREADS=1
export OMP_NUM_THREADS=1,1
export OMP_STACKSIZE=256MB
ulimit -s unlimited

obabel -:${smi} -omol -O ${name}.mol --gen3d
xtb ${name}.mol --opt
obabel -imol xtbopt.mol -omol2 -O ${name}.mol2
#obabel -:${smi} -omol2 -O ${name}.mol2 --gen3d
acpype -i ${name}.mol2
