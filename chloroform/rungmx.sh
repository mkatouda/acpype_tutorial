#!/bin/bash

name=chloroform

acpype_dir=${name}.acpype
input=${name}_GMX

cd ${acpype_dir}

# Edit model

gmx editconf -f ${input}.gro -o ${input}_box.gro -box 10 10 10 -translate 5 5 5
cat << EOS > md.mdp
; to test
; gmx grompp -f md.mdp -c em.gro -p chloroform_GMX.top -o md.tpr
; gmx mdrun -ntmpi 1 -v -deffnm md
integrator               = md
nsteps                   = 10000
nstxout = 100
gen-vel = yes
gen-temp = 300
EOS

# Energy minimization

gmx grompp -f em.mdp -po em.out.mdp -c ${input}_box.gro -p ${input}.top -o em.tpr -maxwarn 1
gmx mdrun -v -nt 1 -ntmpi 1 -deffnm em

# Production MD

gmx grompp -f md.mdp -po md.out.mdp -c em.gro -p ${input}.top -o md.tpr -maxwarn 1
gmx mdrun -v -nt 1 -ntmpi 1 -deffnm md
