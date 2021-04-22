# DCM

A repository for work on Dynamic Causal Modelling

# Build instructions
Some core functions can be compiled to in MEX/C to improve performance. Everything *should* run fine without this step, albiet slower. To build:

```
cd /home/login/DCM/src
make PLATFORM=octave
make PLATFORM=octave install
```