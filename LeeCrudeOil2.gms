$ONEMPTY

*** Generic
Set v / v1*v14 /;
Set p / p1*p6 /;
Set r / r1*r11 /;
Set k / k1*k2 /;
Set vs /
	vs1*vs3, vs11*vs14
	vs1_2, vs2_3, vs1_3, vs1_4, vs1_5, vs2_6, vs2_7, vs2_8, vs3_9, vs3_10, vs4_11, vs6_11, vs8_14, vs10_14, vs11_12, vs12_13, vs13_14
	vs1-3, vs5_12_13, vs7_12_13, vs9_12_13
	vs11-14
/;

* Set membership
Set VSET(vs,v) /
	vs1.v1
	vs2.v2
	vs3.v3
	vs11.v11
	vs12.v12
	vs13.v13
	vs14.v14
	vs1_2.(v1,v2)
	vs1_3.(v1,v3)
	vs1_4.(v1,v4)
	vs1_5.(v1,v5)
	vs2_3.(v2,v3)
	vs2_6.(v2,v6)
	vs2_7.(v2,v7)
	vs2_8.(v2,v8)
	vs3_9.(v3,v9)
	vs3_10.(v3,v10)
	vs4_11.(v4,v11)
	vs6_11.(v6,v11)
	vs8_14.(v8,v14)
	vs10_14.(v10,v14)
	vs11_12.(v11,v12)
	vs12_13.(v12,v13)
	vs13_14.(v13,v14)
	vs1-3.(v1*v3)
	vs5_12_13.(v5,v12,v13)
	vs7_12_13.(v7,v12,v13)
	vs9_12_13.(v9,v12,v13)
	vs11-14.(v11*v14)
/;

*** Specific
Sets
	VESSEL(r)	Vessels		/ r1*r3 /
	STOR(r)		Storage tanks	/ r4*r6 /
	CHARG(r)	Charging tanks	/ r7*r9 /
	CDU(r)		CDUs		/ r10*r11 /
;

Sets
	UNLOAD(v)	Unloadings	/ v1*v3 /
	TRANSF(v)	Transfers	/ v4*v10 /
	DISTIL(v)	Distillations	/ v11*v14 /
;

*** Generic

* inputs/outputs
Set IN(v,r) /
	v1.r4, v2.r5, v3.r6
	v4.r7, v5.r8, v6.r7, v7.r8, v8.r9, v9.r8, v10.r9
	v11.r10, v12.r10, v13.r11, v14.r11
/;
Set OUT(v,r) /
	v1.r1, v2.r2, v3.r3
	v4.r4, v5.r4, v6.r5, v7.r5, v8.r5, v9.r6, v10.r6
	v11.r7, v12.r8, v13.r8, v14.r9
/;

* Required precedences
SETREQPREC1('vs1_2') = yes ;
SETREQPREC1ANTECEDENT('vs1_2','v1') = yes ;
SETREQPREC1SUBSEQUENT('vs1_2','v2') = yes ;
SETREQPREC1('vs2_3') = yes ;
SETREQPREC1ANTECEDENT('vs2_3','v2') = yes ;
SETREQPREC1SUBSEQUENT('vs2_3','v3') = yes ;
*SETREQPREC1('vs1_3') = yes ;
*SETREQPREC1ANTECEDENT('vs1_3','v1') = yes ;
*SETREQPREC1SUBSEQUENT('vs1_3','v3') = yes ;

* Non-overlapping cliques
Set CLIQUE(vs) /
	vs1_4
	vs1_5
	vs2_6
	vs2_7
	vs2_8
	vs3_9
	vs3_10
	vs4_11
	vs6_11
	vs8_14
	vs10_14
	vs11_12
	vs13_14
	vs1-3
	vs5_12_13
	vs7_12_13
	vs9_12_13
/;

* Scheduling horizon
H = 10;

* Cardinality
minN(vs) = 0;
maxN(vs) = INF;
minN('vs1') = 1;
maxN('vs1') = 1;
minN('vs2') = 1;
maxN('vs2') = 1;
minN('vs3') = 1;
maxN('vs3') = 1;
minN('vs11-14') = 5;
maxN('vs11-14') = 5;
minN('vs11') = 1;
maxN('vs11') = 2;
minN('vs12') = 1;
maxN('vs12') = 1;
minN('vs13') = 1;
maxN('vs13') = 1;
minN('vs14') = 1;
maxN('vs14') = 2;

* First slot cardinality
minN1(vs) = 0;
maxN1(vs) = INF;
minN1('vs11_12') = 1;
maxN1('vs11_12') = 1;
minN1('vs13_14') = 1;
maxN1('vs13_14') = 1;

* Initial inventory
Parameter iniCP(r,p) /
	r1.p1 100
	r2.p2 100
	r3.p3 100
	r4.p1  20
	r5.p2  50
	r6.p3  70
	r7.p4  30
	r8.p5  50
	r9.p6  30
/;
iniCT(r) = Sum(p, iniCP(r,p));

* Minimum inventory
minCT(r) = 0;

* Maximum inventory
maxCT(r) = 100;
maxCT(r)$CDU(r) = INF;

* Minimum start time
minS(v) = 0;
minS('v2') = 3;
minS('v3') = 6;

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
totD('vs11_12') = H;
totD('vs13_14') = H;
	
* Minimum demand
minDem(vs) = 0;
minDem('vs11') = 100;
minDem('vs12_13') = 100;
minDem('vs14') = 100;

* Maximum demand
maxDem(vs) = INF;
maxDem('vs11') = 100;
maxDem('vs12_13') = 100;
maxDem('vs14') = 100;

* Product value
val(v,p) = 0;
val(v,'p1')$DISTIL(v) = 0.1;
val(v,'p2')$DISTIL(v) = 0.3;
val(v,'p3')$DISTIL(v) = 0.5;
val(v,'p4')$DISTIL(v) = 0.167;
val(v,'p5')$DISTIL(v) = 0.3;
val(v,'p6')$DISTIL(v) = 0.433;

* Product properties
Parameter prop(p,k) /
	p1.k1 0.1
	p2.k1 0.3
	p3.k1 0.5
	p4.k1 0.167
	p5.k1 0.3
	p6.k1 0.433
	p1.k2 0.4
	p2.k2 0.2
	p3.k2 0.1
	p4.k2 0.333
	p5.k2 0.23
	p6.k2 0.133
/;

* Minimum operation property
minProp(v,k) = -INF;
Loop(v$(DISTIL(v) And OUT(v,'r7')), minProp(v,'k1') = 0.1; );
Loop(v$(DISTIL(v) And OUT(v,'r8')), minProp(v,'k1') = 0.25; );
Loop(v$(DISTIL(v) And OUT(v,'r9')), minProp(v,'k1') = 0.4; );
Loop(v$(DISTIL(v) And OUT(v,'r7')), minProp(v,'k2') = 0.3; );
Loop(v$(DISTIL(v) And OUT(v,'r8')), minProp(v,'k2') = 0.18; );
Loop(v$(DISTIL(v) And OUT(v,'r9')), minProp(v,'k2') = 0.1; );

* Maximum operation property
maxProp(v,k) = INF;
Loop(v$(DISTIL(v) And OUT(v,'r7')), maxProp(v,'k1') = 0.2; );
Loop(v$(DISTIL(v) And OUT(v,'r8')), maxProp(v,'k1') = 0.35; );
Loop(v$(DISTIL(v) And OUT(v,'r9')), maxProp(v,'k1') = 0.48; );
Loop(v$(DISTIL(v) And OUT(v,'r7')), maxProp(v,'k2') = 0.38; );
Loop(v$(DISTIL(v) And OUT(v,'r8')), maxProp(v,'k2') = 0.27; );
Loop(v$(DISTIL(v) And OUT(v,'r9')), maxProp(v,'k2') = 0.18; );

