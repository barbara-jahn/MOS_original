$ONEMPTY

*** Generic
Set v / v1*v19 /;
Set p / p1*p8 /;
Set r / r1*r16 /;
Set k / k1 /;
Set vs /
	vs1*vs3, vs14*vs19
	vs1_2, vs1_3, vs1_5, vs1_6, vs2_3, vs2_7, vs2_8, vs3_9, vs3_10, vs4_14, vs5_14, vs12_19, vs13_19, vs14_15, vs15_16, vs16_17, vs17_18, vs18_19
	vs1-3, vs6_15_16, vs7_15_16, vs8_17_18, vs9_15_16, vs10_17_18, vs11_17_18
	vs14-19
/;

* Set membership
Set VSET(vs,v) /
	vs1.v1
	vs2.v2
	vs3.v3
	vs14.v14
	vs15.v15
	vs16.v16
	vs17.v17
	vs18.v18
	vs19.v19
	vs1_2.(v1,v2)
	vs1_3.(v1,v3)
	vs1_5.(v1,v5)
	vs1_6.(v1,v6)
	vs2_3.(v2,v3)
	vs2_7.(v2,v7)
	vs2_8.(v2,v8)
	vs3_9.(v3,v9)
	vs3_10.(v3,v10)
	vs4_14.(v4,v14)
	vs5_14.(v5,v14)
	vs12_19.(v12,v19)
	vs13_19.(v13,v19)
	vs14_15.(v14,v15)
	vs15_16.(v15,v16)
	vs16_17.(v16,v17)
	vs17_18.(v17,v18)
	vs18_19.(v18,v19)
	vs1-3.(v1*v3)
	vs6_15_16.(v6,v15,v16)
	vs7_15_16.(v7,v15,v16)
	vs8_17_18.(v8,v17,v18)
	vs9_15_16.(v9,v15,v16)
	vs10_17_18.(v10,v17,v18)
	vs11_17_18.(v11,v17,v18)
	vs14-19.(v14*v19)
/;

*** Specific
Sets
	VESSEL(r)	Vessels		/ r1*r3 /
	STOR(r)		Storage tanks	/ r4*r9 /
	CHARG(r)	Charging tanks	/ r10*r13 /
	CDU(r)		CDUs		/ r14*r16 /
;

Sets
	UNLOAD(v)	Unloadings	/ v1*v3 /
	TRANSF(v)	Transfers	/ v4*v13 /
	DISTIL(v)	Distillations	/ v14*v19 /
;

*** Generic

* inputs/outputs
Set IN(v,r) /
	v1.r5, v2.r6, v3.r7
	v4.r10, v5.r10, v6.r11, v7.r11, v8.r12, v9.r11, v10.r12, v11.r12, v12.r13, v13.r13
	v14.r14, v15.r14, v16.r15, v17.r15, v18.r16, v19.r16
/;
Set OUT(v,r) /
	v1.r1, v2.r2, v3.r3
	v4.r4, v5.r5, v6.r5, v7.r6, v8.r6, v9.r7, v10.r7, v11.r8, v12.r8, v13.r9
	v14.r10, v15.r11, v16.r11, v17.r12, v18.r12, v19.r13
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

* Non-overlapping cliques TODO
Set CLIQUE(vs) /
	vs1_5
	vs1_6
	vs2_7
	vs2_8
	vs3_9
	vs3_10
	vs4_14
	vs5_14
	vs12_19
	vs13_19
	vs1-3
	vs6_15_16
	vs7_15_16
	vs8_17_18
	vs9_15_16
	vs10_17_18
	vs11_17_18
	vs14_15
	vs16_17
	vs18_19
/;

* Scheduling horizon
H = 15;

* Cardinality
minN(vs) = 0;
maxN(vs) = INF;
minN('vs1') = 1;
maxN('vs1') = 1;
minN('vs2') = 1;
maxN('vs2') = 1;
minN('vs3') = 1;
maxN('vs3') = 1;
minN('vs14-19') = 7;
maxN('vs14-19') = 7;
minN('vs14') = 1;
maxN('vs14') = 2;
minN('vs15') = 1;
maxN('vs15') = 1;
minN('vs16') = 1;
maxN('vs16') = 1;
minN('vs17') = 1;
maxN('vs17') = 1;
minN('vs18') = 1;
maxN('vs18') = 1;
minN('vs19') = 1;
maxN('vs19') = 2;

* First slot cardinality
minN1(vs) = 0;
maxN1(vs) = INF;
minN1('vs14_15') = 1;
maxN1('vs14_15') = 1;
minN1('vs16_17') = 1;
maxN1('vs16_17') = 1;
minN1('vs18_19') = 1;
maxN1('vs18_19') = 1;

* Initial inventory
Parameter iniCP(r,p) /
	r1.p1  60
	r2.p2  60
	r3.p3  60
	r4.p4  60
	r5.p1  10
	r6.p2  50
	r7.p3  40
	r8.p5  30
	r9.p5  60
	r10.p6  5
	r11.p7 30
	r12.p8 30
	r13.p5 30
/;
iniCT(r) = Sum(p, iniCP(r,p));

* Minimum inventory
minCT(r) = 0;
Loop(r$(ord(r)>=4 And ord(r)<=9), minCT(r)=10; );

* Maximum inventory
maxCT(r)$VESSEL(r) = iniCT(r);
maxCT(r)$STOR(r) = 90;
Loop(r$(ord(r)>=5 And ord(r)<=7), maxCT(r)=110; );
maxCT(r)$CHARG(r) = 80;
maxCT(r)$CDU(r) = INF;

* Minimum start time
minS(v) = 0;
minS('v1') = 0;
minS('v2') = 5;
minS('v3') = 10;

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
Loop((v,r)$(UNLOAD(v) And OUT(v,r)),
	maxVT(v) = iniCT(r);
);
maxVT(v)$TRANSF(v) = 80;
Loop(v$(ord(v)>=5 And ord(v)<=10), maxVT(v) = 100; );
maxVT(v)$DISTIL(v) = 60;

* Minimum flowrate
minFR(v) = 0;
minFR(v)$DISTIL(v) = 2;

* Maximum flowrate
maxFR(v) = 50;

* Minimum duration for unloadings
Loop((v,r)$(UNLOAD(v) And OUT(v,r)),
        minD(v)$UNLOAD(v) = iniCT(r) / maxFR(v);
);

* Total duration
totD(vs) = 0;
totD('vs14_15') = H;
totD('vs16_17') = H;
totD('vs18_19') = H;
	
* Minimum demand
minDem(vs) = 0;
minDem('vs14') = 60;
minDem('vs15_16') = 60;
minDem('vs17_18') = 60;
minDem('vs19') = 60;

* Maximum demand
maxDem(vs) = INF;
maxDem('vs14') = 60;
maxDem('vs15_16') = 60;
maxDem('vs17_18') = 60;
maxDem('vs19') = 60;

* Product value
val(v,p) = 0;
val(v,'p1')$DISTIL(v) = 0.3;
val(v,'p2')$DISTIL(v) = 0.5;
val(v,'p3')$DISTIL(v) = 0.65;
val(v,'p4')$DISTIL(v) = 0.31;
val(v,'p5')$DISTIL(v) = 0.75;
val(v,'p6')$DISTIL(v) = 0.317;
val(v,'p7')$DISTIL(v) = 0.483;
val(v,'p8')$DISTIL(v) = 0.633;

* Product properties
Parameter prop(p,k) /
	p1.k1 0.3
	p2.k1 0.5
	p3.k1 0.65
	p4.k1 0.31
	p5.k1 0.75
	p6.k1 0.317
	p7.k1 0.483
	p8.k1 0.633
/;

* Minimum operation property
minProp(v,k) = -INF;
Loop(v$(DISTIL(v) And OUT(v,'r10')), minProp(v,'k1') = 0.3; );
Loop(v$(DISTIL(v) And OUT(v,'r11')), minProp(v,'k1') = 0.43; );
Loop(v$(DISTIL(v) And OUT(v,'r12')), minProp(v,'k1') = 0.6; );
Loop(v$(DISTIL(v) And OUT(v,'r13')), minProp(v,'k1') = 0.71; );

* Maximum operation property
maxProp(v,k) = INF;
Loop(v$(DISTIL(v) And OUT(v,'r10')), maxProp(v,'k1') = 0.35; );
Loop(v$(DISTIL(v) And OUT(v,'r11')), maxProp(v,'k1') = 0.5; );
Loop(v$(DISTIL(v) And OUT(v,'r12')), maxProp(v,'k1') = 0.65; );
Loop(v$(DISTIL(v) And OUT(v,'r13')), maxProp(v,'k1') = 0.8; );

