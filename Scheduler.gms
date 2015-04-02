$ONEMPTY
$ONUELLIST

*** Sets declaration
Sets
	i	slots		/ i1*i%gams.user3% /
	v	operations
	p	products
	r	inventory resources
	k	properties
	vs	sets of operations
;
Alias (i,j,i1,i2);
Alias (v,w,v1,v2);
Alias (vs,vs1,vs2,vs3);
Sets
	ORD2(i,j)		ordered slots (i <= j)
	VSET(vs,v)		sets of operations membership
	CLIQUE(vs)		clique sets
	CLIQUE2(v,w)		clique sets of two operations
	SETREQPREC1(vs)
	SETREQPREC1ANTECEDENT(vs,v)
	SETREQPREC1SUBSEQUENT(vs,v)
	IN(v,r)				inventory inlet operations
	OUT(v,r)			inventory outlet operations
;

*** Parameters declaration
Parameters
         H
         minS(v)
         maxS(v)
         minD(v)
         maxD(v)
         minE(v)
         maxE(v)
         minVT(v)
         maxVT(v)
         minB(v)
         maxB(v)
         minCT(r)
         maxCT(r)
         iniCT(r)
         iniCP(r,p)
         minFR(v)
         maxFR(v)
         totD(vs)
         minDem(vs)
         maxDem(vs)
         val(v,p)
         prop(p,k)
         minProp(v,k)
         maxProp(v,k)
         maxE(v)
         minN(vs)
         maxN(vs)
         minN1(vs)
         maxN1(vs)
;

*** Variables declaration
Variable                 OBJ;
Binary Variable          Z(i,v);
Positive Variables       S(i,v), D(i,v), E(i,v);
Positive Variables       VT(i,v), VP(i,v,p);
Positive Variables       LT(i,r), LP(i,r,p);

*** Constraints declaration
Equations
         Objective

	 MinAssignment
         MOSAssignment

         MinCard
         MaxCard
         MinCard1
         MaxCard1

         SetReqPrec1Time
         SSTSetReqPrec1

         Time
         MinStart
         MaxEnd
         MinVolumeTotal
         MaxVolumeTotal
         VolumeCompo
         MinLevelTotal
         MaxLevelTotal
         MinLevelProduct
         MaxLevelProduct
         LevelCompo

         LevelTotalDef
         LevelProdDef
         CompositionCst

         MinFlowrate
         MaxFlowrate

         TotalDuration

         MinDemand
         MaxDemand
 
         MinProperty
         MaxProperty

         MinEndLevelTotal
         MaxEndLevelTotal
         MinEndLevelProduct
         MaxEndLevelProduct

         NoOverlapClique

         SBClique2
;

*** Constraints construction
Objective..
         OBJ =E= Sum((i,v,p), val(v,p) * VP(i,v,p)) ;

MinAssignment(i)..
         Sum(v, Z(i,v)) =G= 1 ;
MOSAssignment(i,vs)$CLIQUE(vs)..
         Sum(v$VSET(vs,v), Z(i,v)) =L= 1 ;

Mincard(vs)$(minN(vs)>0)..
         Sum((i,v)$VSET(vs,v), Z(i,v)) =G= minN(vs) ;
MaxCard(vs)$(maxN(vs)<INF)..
         Sum((i,v)$VSET(vs,v), Z(i,v)) =L= maxN(vs) ;
Mincard1(i,vs)$(ord(i)=1 And minN1(vs)>0)..
         Sum(v$VSET(vs,v), Z(i,v)) =G= minN1(vs) ;
MaxCard1(i,vs)$(ord(i)=1 And maxN1(vs)<INF)..
         Sum(v$VSET(vs,v), Z(i,v)) =L= maxN1(vs) ;

SetReqPrec1Time(vs)$SETREQPREC1(vs)..
         Sum((i,v)$SETREQPREC1ANTECEDENT(vs,v), E(i,v)) =L= Sum((i,v)$SETREQPREC1SUBSEQUENT(vs,v), S(i,v)) ;
SSTSetReqPrec1(i,vs)$SETREQPREC1(vs)..
         Sum((j,v)$(SETREQPREC1ANTECEDENT(vs,v) And ORD2(j+1,i)), Z(j,v)) =G= Sum((j,v)$(SETREQPREC1SUBSEQUENT(vs,v) And ORD2(j,i)), Z(j,v)) ;

Time(i,v)..
         E(i,v) =E= S(i,v) + D(i,v) ;
MinStart(i,v)..
         S(i,v) =G= minS(v) * Z(i,v) ;
MaxEnd(i,v)..
         E(i,v) =L= maxE(v) * Z(i,v) ;
MinVolumeTotal(i,v)$(minVT(v)>0)..
         VT(i,v) =G= minVT(v) * Z(i,v) ;
MaxVolumeTotal(i,v)$(maxVT(v)<INF)..
         VT(i,v) =L= maxVT(v) * Z(i,v) ;
VolumeCompo(i,v)..
         VT(i,v) =E= Sum(p, VP(i,v,p)) ;
MinLevelTotal(i,r)$(minCT(r)>0)..
         LT(i,r) =G= minCT(r) ;
MaxLevelTotal(i,r)$(maxCT(r)<INF)..
         LT(i,r) =L= maxCT(r) ;
MinLevelProduct(i,r,p)..
         LP(i,r,p) =G= 0 ;
MaxLevelProduct(i,r,p)$(maxCT(r)<INF)..
         LP(i,r,p) =L= maxCT(r) ;
LevelCompo(i,r)..
         LT(i,r) =E= Sum(p, LP(i,r,p)) ;

LevelTotalDef(i,r)..
         LT(i,r) =E= iniCT(r) + Sum((j,v)$(ORD2(j+1,i) And IN(v,r)), VT(j,v)) - Sum((j,v)$(ORD2(j+1,i) And OUT(v,r)), VT(j,v)) ;
LevelProdDef(i,r,p)..
         LP(i,r,p) =E= iniCP(r,p) + Sum((j,v)$(ORD2(j+1,i) And IN(v,r)), VP(j,v,p)) - Sum((j,v)$(ORD2(j+1,i) And OUT(v,r)), VP(j,v,p)) ;
CompositionCst(i,r,v,p)$OUT(v,r)..
         VT(i,v) * LP(i,r,p) =E= VP(i,v,p) * LT(i,r) ;

MinFlowrate(i,v)..
         VT(i,v) =G= minFR(v) * D(i,v) ;
MaxFlowrate(i,v)..
         VT(i,v) =L= maxFR(v) * D(i,v) ;

TotalDuration(vs)$(totD(vs)>0 And totD(vs)<INF)..
         Sum((i,v)$VSET(vs,v), D(i,v)) =E= totD(vs) ;

MinDemand(vs)$(minDem(vs)>0)..
         Sum((i,v)$VSET(vs,v), VT(i,v)) =G= minDem(vs) ;
MaxDemand(vs)$(maxDem(vs)>0 And maxDem(vs)<INF)..
         Sum((i,v)$VSET(vs,v), VT(i,v)) =L= maxDem(vs) ;

MinProperty(i,v,k)$(minProp(v,k)>-INF)..
         Sum(p, prop(p,k) * VP(i,v,p)) =G= minProp(v,k) * VT(i,v) ;
MaxProperty(i,v,k)$(maxProp(v,k)<INF)..
         Sum(p, prop(p,k) * VP(i,v,p)) =L= maxProp(v,k) * VT(i,v) ;

MinEndLevelTotal(r)..
         iniCT(r) + Sum((i,v)$IN(v,r), VT(i,v)) - Sum((i,v)$OUT(v,r), VT(i,v)) =G= minCT(r);
MaxEndLevelTotal(r)$(maxCT(r)<INF)..
         iniCT(r) + Sum((i,v)$IN(v,r), VT(i,v)) - Sum((i,v)$OUT(v,r), VT(i,v)) =L= maxCT(r);
MinEndLevelProduct(r,p)..
         iniCP(r,p) + Sum((i,v)$IN(v,r), VP(i,v,p)) - Sum((i,v)$OUT(v,r), VP(i,v,p)) =G= 0;
MaxEndLevelProduct(r,p)$(maxCT(r)<INF)..
         iniCP(r,p) + Sum((i,v)$IN(v,r), VP(i,v,p)) - Sum((i,v)$OUT(v,r), VP(i,v,p)) =L= maxCT(r);

NoOverlapClique(i1,i2,vs)$(ORD2(i1+1,i2) And CLIQUE(vs))..
         Sum(v$VSET(vs,v), E(i1,v)) + Sum((i,v)$(VSET(vs,v) And ord(i1)<ord(i) And ord(i)<ord(i2)), D(i,v)) =L= Sum(v$VSET(vs,v), S(i2,v)) + (smax(v$VSET(vs,v), maxE(v))) * (1 - Sum(v$VSET(vs,v), Z(i2,v))) ;

SBClique2(i-1,v)..
         Z(i,v) =L= Sum(w$(CLIQUE2(v,w) And ord(v)<>ord(w)), Z(i-1,w)) ;


*** Problem parameters
$include %gams.user2%


*** Model declaration
Model MOS /
        Objective

*        MinAssignment
        MOSAssignment

        MinCard
        MaxCard
        MinCard1
        MaxCard1

        SetReqPrec1Time
        SSTSetReqPrec1

        Time
        MinStart
        MaxEnd
        MinVolumeTotal
        MaxVolumeTotal
        VolumeCompo
        MinLevelTotal
        MaxLevelTotal
        MinLevelProduct
        MaxLevelProduct
        LevelCompo

        LevelTotalDef
        LevelProdDef
        CompositionCst

        MinFlowrate
        MaxFlowrate

        TotalDuration

        MinDemand
        MaxDemand

        MinProperty
        MaxProperty

        MinEndLevelTotal
        MaxEndLevelTotal
        MinEndLevelProduct
        MaxEndLevelProduct

        NoOverlapClique

        SBClique2
/;

Model MOSMILP /
        Objective

*        MinAssignment
        MOSAssignment

        MinCard
        MaxCard
        MinCard1
        MaxCard1

        SetReqPrec1Time
        SSTSetReqPrec1

        Time
        MinStart
        MaxEnd
        MinVolumeTotal
        MaxVolumeTotal
        VolumeCompo
        MinLevelTotal
        MaxLevelTotal
        MinLevelProduct
        MaxLevelProduct
        LevelCompo

        LevelTotalDef
        LevelProdDef
*       CompositionCst

        MinFlowrate
        MaxFlowrate

        TotalDuration

        MinDemand
        MaxDemand

        MinProperty
        MaxProperty

        MinEndLevelTotal
        MaxEndLevelTotal
        MinEndLevelProduct
        MaxEndLevelProduct

        NoOverlapClique

        SBClique2
/;

*** Sets construction
ORD2(i,j)$(ord(i) <= ord(j)) = yes ;
Loop(vs$CLIQUE(vs),
	CLIQUE2(v,w)$(VSET(vs,v) and VSET(vs,w) and ord(v)<>ord(w)) = yes;
);

*** Options
Option optcr = 0 ;
Option iterlim = 999999999 ;
Option reslim = 300 ;
Option limcol = 0;
Option limrow = 0;
Option solprint = off;


*** Solve using MINLP
$if not %gams.user1% == minlp
$goto milp
OBJ.L=100;
Z.l(i,v)=0.5;
S.l(i,v)=H/3;
D.l(i,v)=H/3;
E.l(i,v)=H/3;
VT.l(i,v)=10;
LT.l(i,r)=10;
VP.l(i,v,p)=VT.L(i,v)/card(p);
LP.l(i,r,p)=LT.l(i,r)/card(p);
* for setting a higher 'nodlim' for sbb 
MOS.optfile = 1;
Solve MOS using MINLP maximizing OBJ ;
$goto end


*** Solve using MIP relaxation
$label milp
Solve MOSMILP using MIP maximizing OBJ ;
Z.fx(i,v) = Z.l(i,v);
Solve MOS using RMINLP maximizing OBJ ;


$label end
Display OBJ.l, Z.l, S.l, D.l, E.l, VT.l, VP.l, LT.l, LP.l;
