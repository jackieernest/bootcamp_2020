;; 2. Description: adjusted amount used
;; x1. Author: jackie
$PROBLEM    rabbit PK
$INPUT      ID TIME DV EVID MDV DOSE BW SEX HIV AMT
$DATA       ../simulation_df.csv				 
						IGNORE=@
$SUBROUTINE ADVAN6 TOL=5
$MODEL      NCOMP=3 COMP=(ABS,DEFDOSE) COMP=(CENTRAL, DEFOBS) COMP=(PERIPH)
$PK
       
TVCL = THETA(3) * EXP(ETA(2))
V  = THETA(4)

KA = THETA(5)
S2 = V
F1 = 1 

Q  = THETA(6)
V2 = THETA(7)

; Effect of HIV on CL 
HIVSTAT = 0
IF(HIV.EQ.1) HIVSTAT=1
HIVCL = 1 + HIVSTAT*THETA(8)

; Effect of WT on CL
BWCL = 1 + BW/60*(THETA(9))

CL = TVCL * HIVCL * BWCL
KE = CL/V

$DES      
DADT(1)=-KA*A(1)
DADT(2)= KA*A(1)-KE*A(2) -Q/V2*A(2) + Q/V2*A(3)
DADT(3)= KA*A(1)-KE*A(2) +Q/V2*A(2) - Q/V2*A(3)

$ERROR         

IPRED=A(2)/V

WA=THETA(1) * EXP(ETA(1))
WP=THETA(2)
W = SQRT(WA**2+(WP*IPRED)**2)
IRES=DV-IPRED
IWRES=IRES/W
Y = IPRED + W*EPS(1)

$THETA
0 FIX  ; 1 Additive Error
(0, 0.1) FIX ; 2 Proportional Error
(0, 35) FIX   ; 3 CL L/h
(0, 500) FIX   ; 4 V L
(0, 1) FIX   ; 5 KA 1/h
(0, 0.01) FIX   ; 6 Q
(0, 100) FIX    ; 7 V2
0.25 FIX ; 8 effect of HIV
0.05 FIX ; 9 effect of BW

$OMEGA 
0 FIX    ; 1 Additive Error
0.08 FIX      ; 2 IIV CL

$SIGMA 
1 FIX 

$SIM (12345) (54321) ONLYSIM NSUB=1
;$ESTIMATION METHOD=1 INTERACTION PRINT=5 SIG=3 MAXEVAL=9999 NOABORT
;$COVARIANCE UNCONDITIONAL 

$TABLE ID TIME IPRED PRED DV AMT DOSE BW SEX HIV WRES IWRES CWRES EVID FILE=sdtab01 NOPRINT ONEHEADER
$TABLE ID CL V KA KE FILE=patab01 NOPRINT ONEHEADER