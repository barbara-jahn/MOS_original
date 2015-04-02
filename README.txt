Available files:
- Scheduler.gms: main GAMS file for model definition and solution
- LeeCrudeOilX.gms: crude-oil instance data (X=1..4)
- sbb.opt: option file for sbb to set a large 'nodlim' parameter

To solve an instance use the following arguments:
- u1=minlp/milpnlp: to select solve strategy (direct MINLP or two-step MILP-NLP approach)
- u2=LeeCrudeOilX.gms: to select the instance to solve
- u3=n: to select the number of priority-slots
- other arguments to select solvers

Linux command line example:
gams Scheduler.gms u1=milpnlp u2=LeeCrudeOil4.gms u3=5 milp=xpress nlp=snopt
