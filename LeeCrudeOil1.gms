$ONEMPTY

*** Generic
Set v / v1*v8 /;
Set p / p1*p4 /;
Set r / r1*r7 /;
Set k / k1 /;
Set vs /
	vs1, vs2, vs7, vs8
	vs12, vs13, vs14, vs25, vs26, vs37, vs48, vs57, vs68, vs78
/;

* Set membership
Set VSET(vs,v) /
	vs1.v1
	vs2.v2
	vs7.v7
	vs8.v8
	vs12.(v1,v2)
	vs13.(v1,v3)
	vs14.(v1,v4)
        vs25.(v2,v5)
        vs26.(v2,v6)
	vs37.(v3,v7)
	vs48.(v4,v8)
	vs57.(v5,v7)
	vs68.(v6,v8)
	vs78.(v7,v8)
/;

*** Specific
Sets
	VESSEL(r)	Vessels		/ r1*r2 /
	STOR(r)		Storage tanks	/ r3*r4 /
	CHARG(r)	Charging tanks	/ r5*r6 /
	CDU(r)		CDUs		/ r7 /
;

Sets
	UNLOAD(v)	Unloadings	/ v1*v2 /
	TRANSF(v)	Transfers	/ v3*v6 /
	DISTIL(v)	Distillations	/ v7*v8 /
;

*** Generic

* inputs/outputs
Sets
IN(v,r)		/ v1.r3, v2.r4, v3.r5, v4.r6, v5.r5, v6.r6, v7.r7, v8.r7 /
OUT(v,r)	/ v1.r1, v2.r2, v3.r3, v4.r3, v5.r4, v6.r4, v7.r5, v8.r6 /
;

* Required precedences
SETREQPREC1('vs12') = yes ;
SETREQPREC1ANTECEDENT('vs12','v1') = yes ;
SETREQPREC1SUBSEQUENT('vs12','v2') = yes ;

* Non-overlapping cliques
Set CLIQUE(vs) /
	vs12
	vs13
	vs14
	vs25
	vs26
	vs37
	vs48
	vs57
	vs68
	vs78
/;

* Scheduling horizon
H = 8;

* Cardinality
minN(vs) = 0;
maxN(vs) = INF;
minN('vs1') = 1;
maxN('vs1') = 1;
minN('vs2') = 1;
maxN('vs2') = 1;
minN('vs78') = 3;
maxN('vs78') = 3;
minN('vs7') = 1;
maxN('vs7') = 2;
minN('vs8') = 1;
maxN('vs8') = 2;

* First slot cardinality
minN1(vs) = 0;
maxN1(vs) = INF;
minN1('vs78') = 1;
maxN1('vs78') = 1;

* Initial inventory
Parameter iniCP(r,p) /
	r1.p1 100
	r2.p2 100
	r3.p1  25
	r4.p2  75
	r5.p3  50
	r6.p4  50
/;
iniCT(r) = Sum(p, iniCP(r,p));

* Minimum inventory
minCT(r) = 0;

* Maximum inventory
maxCT(r) = 100;
maxCT(r)$CDU(r) = INF;

* Minimum start time
minS(v) = 0;
minS('v2') = 4;

* Maximum start time
maxS(v) = H;

* Minimum duration
minD(v) = 0;

* Maximum duration
maxD(v) = H;

* Minimum end time
minE(v) = 0;

* Maximum end time
maxE(v) = H;

* Minimum total volume
minVT(v) = 0;
Loop((v,r)$(UNLOAD(v) And OUT(v,r)),
	minVT(v) = iniCT(r);
);

* Maximum total volume
maxVT(v) = 100;

* Minimum flowrate
minFR(v) = 0;
minFR(v)$DISTIL(v) = 5;

* Maximum flowrate
maxFR(v) = 50;

* Minimum duration for unloadings
Loop((v,r)$(UNLOAD(v) And OUT(v,r)),
	minD(v)$UNLOAD(v) = iniCT(r) / maxFR(v);
);

* Total duration
totD(vs) = 0;
totD('vs78') = H;

* Minimum demand
minDem(vs) = 0;
minDem('vs7') = 100;
minDem('vs8') = 100;

* Maximum demand
maxDem(vs) = INF;
maxDem('vs7') = 100;
maxDem('vs8') = 100;

* Product value
val(v,p) = 0;
val(v,'p1')$DISTIL(v) = 0.1;
val(v,'p2')$DISTIL(v) = 0.6;
val(v,'p3')$DISTIL(v) = 0.2;
val(v,'p4')$DISTIL(v) = 0.5;

* Product properties
Parameter prop(p,k) /
	p1.k1 0.1
	p2.k1 0.6
	p3.k1 0.2
	p4.k1 0.5
/;

* Minimum operation property
minProp(v,k) = -INF;
Loop(v$(DISTIL(v) And OUT(v,'r5')), minProp(v,'k1') = 0.15; );
Loop(v$(DISTIL(v) And OUT(v,'r6')), minProp(v,'k1') = 0.45; );

* Maximum operation property
maxProp(v,k) = INF;
Loop(v$(DISTIL(v) And OUT(v,'r5')), maxProp(v,'k1') = 0.25; );
Loop(v$(DISTIL(v) And OUT(v,'r6')), maxProp(v,'k1') = 0.55; );

