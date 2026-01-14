  
  

******************************Begining of estimation
tab time, gen(time)
global tlist time2 time3 time4 time5 time6 time7 time8 time9 time10 time11 time12 time13 time14 time15 time16 time17

//Descriptive statistics
//Table 3
mkdir c:/ecgd
cd c:/ecgd
asdoc sum lnco2kt lntgge lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb lnindc lnhcon FI score cc ge ps rq rl va

//Appendix Table 3
mkdir c:/ecgdd
cd c:/ecgdd
asdoc corr lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb lnindc lnhcon FI score  cc ge ps rq rl va

//Table 4: GMM results
eststo clear
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     i.time, twostep  iv(  lnfdi  lntrad lnurb i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI cc  i.time, twostep  iv(  lnfdi lntrad lnurb cc i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI ge  i.time, twostep  iv(  lnfdi  lntrad lnurb ge i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI ps  i.time, twostep  iv(  lnfdi  lntrad lnurb ps i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI rq  i.time, twostep  iv(  lnfdi  lntrad lnurb rq i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI rl  i.time, twostep  iv(  lnfdi lntrad lnurb rl i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI va   i.time, twostep  iv(  lnfdi  lntrad lnurb va  i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 2.doc", title(Table 2: Financial inclusion, governance and carbon emissions [Two-step dynamic-GMM with time fixed effect]) se label rtf b(3) scalars( N r2 hansen hansenp ari arip j arip ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear
//

*****************************************************
//Table 5 Robustness check
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist ,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 3.doc", title(Table 3: Financial inclusion, governance and carbon emissions, [Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear


********************Income group analysis
//Table 6A
//low-income
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if inc_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if inc_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if inc_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if inc_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if inc_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if inc_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if inc_id==1,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 4.doc", title(Table 3: Financial inclusion, governance and carbon emissions in low-income countries, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//lower-middle
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if inc_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if inc_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if inc_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if inc_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if inc_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if inc_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if inc_id==2,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 5.doc", title(Table 5: Financial inclusion, governance and carbon emissions in lower-middle income countries, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//Table 6B
//upper-middle
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if inc_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if inc_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if inc_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if inc_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if inc_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if inc_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if inc_id==3,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 6.doc", title(Table 6: Financial inclusion, governance and carbon emissions in upper-middle income countries, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//High-income
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if inc_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if inc_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if inc_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if inc_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if inc_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if inc_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if inc_id==4,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 7.doc", title(Table 7: Financial inclusion, governance and carbon emissions in high-income countries, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

***********************************Regional analysis
//Table 7A
// South Asia
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if reg_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if reg_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if reg_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if reg_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if reg_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if reg_id==1,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if reg_id==1,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 4.doc", title(Table 3: Financial inclusion, governance and carbon emissions in South Asia, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//Europe and Central Asia 
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if reg_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if reg_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if reg_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if reg_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if reg_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if reg_id==2,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if reg_id==2,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 5.doc", title(Table 5: Financial inclusion, governance and carbon emissions in Europe and Central Asia, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear


//Table 7B
//Middle East and North Africa 
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if reg_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if reg_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if reg_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if reg_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if reg_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if reg_id==3,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if reg_id==3,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 6.doc", title(Table 6: Financial inclusion, governance and carbon emissions in Middle East and North Africa, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//Table 7C
//East Asia and the Pacific 
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if reg_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if reg_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if reg_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if reg_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if reg_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if reg_id==4,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if reg_id==4,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 7.doc", title(Table 7: Financial inclusion, governance and carbon emissions in East Asia and Pacific, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//
//Sub-Saharan Africa 
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if reg_id==5,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if reg_id==5,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if reg_id==5,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if reg_id==5,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if reg_id==5,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if reg_id==5,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if reg_id==5,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 7.doc", title(Table 7: Financial inclusion, governance and carbon emissions in sub-Saharan Africa, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//Latin America and the Caribbean 
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist if reg_id==6,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  cc  $tlist if reg_id==6,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist if reg_id==6,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist if reg_id==6,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist if reg_id==6,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist if reg_id==6,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist if reg_id==6,  lag (8)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 7A.doc", title(Table 15: Financial inclusion, governance and carbon emissions in Latin America and Caribbean, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

**********
//Table 8 and their graphs
//Robustness check
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.FI##c.cc  $tlist ,  lag (8)
margins, dydx(c.FI) at(cc =(-1.597 (0.042) 2.459))             
marginsplot, recast(line) recastci(rline)  ///
title("(a) Marginal effect of financial inclusion on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion (FinInc)") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Control of corruption", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.407  "TCD", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.119 "GHA", place(sw) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.067  "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.758  "GBR", place(s) size(small)) ///
text (0 2.323 "DNK", place(s)  size(small))



eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.FI##c.ge   $tlist ,  lag (8)
margins, dydx(c.FI) at(ge =(-2.137 (0.086) 2.426))             
marginsplot, recast(line) recastci(rline)  ///
title("(b) Marginal effect of financial inclusion on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion (FinInc)") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Government effectiveness", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.407  "TCD", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.162 "GHA", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.247 "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.591  "GBR", place(s) size(small)) ///
text (0 2.199 "SGP", place(s)  size(small))



eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.FI##c.ps   $tlist ,  lag (8)
margins, dydx(c.FI) at(ps =(-3.18 (-0.045) 1.639))             
marginsplot, recast(line) recastci(rline)  ///
title("(c) Marginal effect of financial inclusion on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion (FinInc)") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Political stability", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.276  "IRQ", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.508 "BFA", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.175 "MYS", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 0.386  "GBR", place(s) size(small)) ///
text (0 1.379 "NZL", place(s)  size(small))

eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.FI##c.rq  $tlist ,  lag (8)
margins, dydx(c.FI) at(rq =(-2.282 (0.109) 2.255))             
marginsplot, recast(line) recastci(rline)  ///
title("(d) Marginal effect of financial inclusion on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion (FinInc)") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Regulatory quality", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.831  "ZWE", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.093 "GHA", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.370 "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.718  "GBR", place(s) size(small)) ///
text (0 1.969 "SGP", place(s)  size(small))

eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.FI##c.rl   $tlist ,  lag (8)
margins, dydx(c.FI) at(rl=(-1.87 (0.049) 2.125))             
marginsplot, recast(line) recastci(rline)  ///
title("(e) Marginal effect of financial inclusion on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion (FinInc)") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Rule of law ", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.691  "IRQ", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.086 "THA", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.018 "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.686  "GBR", place(s) size(small)) ///
text (0 1.995 "FIN", place(s)  size(small))

eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.FI##c.va   $tlist ,  lag (8)
margins, dydx(c.FI) at(va=(-1.983 (0.1) 1.801))             
marginsplot, recast(line) recastci(rline)  ///
title("(f) Marginal effect of financial inclusion on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion (FinInc)") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Voice and accountability", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.732  "SAU", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.048 "BOL", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.627 "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.338  "GBR", place(s) size(small)) ///
text (0 1.649 "NOR", place(s)  size(small))

estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 8.doc", title(Table 8: Conditional effect of Financial inclusion and governance on carbon emissions,, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

///Further analysis

//Using total greenhouse gas emissions as dependent variable

//Table 9
eststo clear
eststo: xtabond2 lntgge l.lntgge lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     i.time, twostep  iv(  lnfdi  lntrad lnurb i.time) gmm( l.lntgge lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lntgge l.lntgge lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI cc  i.time, twostep  iv(  lnfdi lntrad lnurb cc i.time) gmm( l.lntgge lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lntgge l.lntgge lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI ge  i.time, twostep  iv(  lnfdi  lntrad lnurb ge i.time) gmm( l.lntgge lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lntgge l.lntgge lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI ps  i.time, twostep  iv(  lnfdi  lntrad lnurb ps i.time) gmm( l.lntgge lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lntgge l.lntgge lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI rq  i.time, twostep  iv(  lnfdi  lntrad lnurb rq i.time) gmm( l.lntgge lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lntgge l.lntgge lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI rl  i.time, twostep  iv(  lnfdi lntrad lnurb rl i.time) gmm( l.lntgge lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
eststo: xtabond2 lntgge l.lntgge lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI va   i.time, twostep  iv(  lnfdi  lntrad lnurb va  i.time) gmm( l.lntgge lnrgdpc lnrgdpc2 FI lnrenew, lag(1 .) collapse)
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 2.doc", title(Table 2: Financial inclusion, governance and total greenhouse gas emissions [Two-step dynamic-GMM with time fixed effect]) se label rtf b(3) scalars( N r2 hansen hansenp ari arip j arip ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear



// OLS results and Oster stability test
//Table 10
eststo clear
eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist ,  robust
psacalc delta FI, rmax (1)

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb  FI cc  $tlist ,  robust
psacalc delta FI, rmax (1)

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist ,  robust
psacalc delta FI, rmax (1)

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist ,  robust
psacalc delta FI, rmax (1)

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist ,  robust
psacalc delta FI, rmax (1)

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist ,  robust
psacalc delta FI, rmax (1)

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist ,  robust
psacalc delta FI, rmax (1)




***************************Using  Alternative Instrumental variable technique*********************************************************
//Table 11
eststo clear
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist (FI= ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist cc (FI= ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist ge (FI= ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist ps (FI= ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist rq (FI= ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist rl (FI= ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist va (FI= ) , first robust
estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 3.doc", title(Table 3: Financial inclusion, governance and carbon emissions, [Lewbel 2SLS estimates) se label rtf b(3) scalars( N r2 widstat) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear


**********Using the financial inclusion index from the entropy weight method
//Table 12A
eststo clear
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score    i.time, twostep  iv(  lnfdi  lntrad lnurb i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 score  lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score  cc  i.time, twostep  iv(  lnfdi lntrad lnurb cc i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 score  lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score ge  i.time, twostep  iv(  lnfdi  lntrad lnurb ge i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 score  lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score  ps  i.time, twostep  iv(  lnfdi  lntrad lnurb ps i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 score lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score  rq  i.time, twostep  iv(  lnfdi  lntrad lnurb rq i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 score lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score rl  i.time, twostep  iv(  lnfdi lntrad lnurb rl i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 score lnrenew, lag(1 .) collapse)
eststo: xtabond2 lnco2kt l.lnco2kt lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score  va   i.time, twostep  iv(  lnfdi  lntrad lnurb va  i.time) gmm( l.lnco2kt lnrgdpc lnrgdpc2 score  lnrenew, lag(1 .) collapse)

estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 2.doc", title(Table 2: Financial inclusion, governance and carbon emissions [Two-step dynamic-GMM with time fixed effect]) se label rtf b(3) scalars( N r2 hansen hansenp ari arip j arip ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//Table 12B
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score      $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score      cc  $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score      ge   $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score      ps   $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score      rq  $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score      rl   $tlist ,  lag (8)
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb score      va   $tlist ,  lag (8)



eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist (score = ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist cc (score = ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist ge (score = ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist ps (score = ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist rq (score = ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist rl (score = ) , first robust
eststo: ivreg2h  lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb $tlist va (score = ) , first robust

estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 2h.doc", title(Table 2: Financial inclusion, governance and carbon emissions [Driscol-Kraay and Lewbel 2SLS estimates]) se label rtf b(3) scalars( N r2 widstat ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

************Mediation Analysis
//Table 13
eststo clear
eststo: xtscc lnco2kt FI  lnrgdpc  lnfdi  lntrad lnurb   $tlist ,  lag (8)

eststo: xtscc lnrenew FI  lnrgdpc  lnfdi  lntrad lnurb   $tlist ,  lag (8)
eststo: xtscc lnco2kt lnrenew FI  lnrgdpc   lnfdi  lntrad lnurb   $tlist ,  lag (8)

eststo: xtscc lnindc FI  lnrgdpc  lnfdi  lntrad lnurb   $tlist ,  lag (8)
eststo: xtscc lnco2kt lnindc FI  lnrgdpc   lnfdi  lntrad lnurb   $tlist ,  lag (8)

eststo: xtscc lnhcon  FI  lnrgdpc  lnfdi  lntrad lnurb   $tlist ,  lag (8)
eststo: xtscc lnco2kt lnhcon  FI  lnrgdpc   lnfdi  lntrad lnurb   $tlist ,  lag (8)

estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 3.doc", title(Table 3: Potential mediation or mechanism test, [Lewbel 2SLS estimates) se label rtf b(3) scalars( N r2) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

//Appendix Table 4
eststo clear
eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI     $tlist ,  robust

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb  FI cc  $tlist ,  robust

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ge   $tlist ,  robust

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  ps   $tlist ,  robust

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rq  $tlist ,  robust

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  rl   $tlist ,  robust

eststo: regress lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb FI  va   $tlist ,  robust

estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 3.doc", title(Table 3: Financial inclusion, governance and carbon emissions, [OLS with time-fixed effect estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear


//Appendix Table 5 and Appendix Figure 5
eststo clear
eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.score##c.cc  $tlist ,  lag (8)
margins, dydx(c.score) at(cc =(-1.597 (0.042) 2.459))             
marginsplot, recast(line) recastci(rline)  ///
title("(a) Marginal effect of Financial inclusion[FI_entropy] on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion[FI_entropy]") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Control of corruption", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.407  "TCD", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.119 "GHA", place(sw) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.067  "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.758  "GBR", place(s) size(small)) ///
text (0 2.323 "DNK", place(s)  size(small))



eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.score##c.ge   $tlist ,  lag (8)
margins, dydx(c.score) at(ge =(-2.137 (0.086) 2.426))             
marginsplot, recast(line) recastci(rline)  ///
title("(b) Marginal effect of financial inclusion[FI_entropy] on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion[FI_entropy]") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Government effectiveness", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.407  "TCD", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.162 "GHA", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.247 "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.591  "GBR", place(s) size(small)) ///
text (0 2.199 "SGP", place(s)  size(small))



eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.score##c.ps   $tlist ,  lag (8)
margins, dydx(c.score) at(ps =(-3.18 (-0.045) 1.639))             
marginsplot, recast(line) recastci(rline)  ///
title("(c) Marginal effect of financial inclusion[FI_entropy] on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion[FI_entropy]") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Political stability", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.276  "IRQ", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.508 "BFA", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.175 "MYS", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 0.386  "GBR", place(s) size(small)) ///
text (0 1.379 "NZL", place(s)  size(small))

eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.score##c.rq  $tlist ,  lag (8)
margins, dydx(c.score) at(rq =(-2.282 (0.109) 2.255))             
marginsplot, recast(line) recastci(rline)  ///
title("(d) Marginal effect of financial inclusion[FI_entropy] on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion[FI_entropy]") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Regulatory quality", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.831  "ZWE", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.093 "GHA", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.370 "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.718  "GBR", place(s) size(small)) ///
text (0 1.969 "SGP", place(s)  size(small))

eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.score##c.rl   $tlist ,  lag (8)
margins, dydx(c.score) at(rl=(-1.87 (0.049) 2.125))             
marginsplot, recast(line) recastci(rline)  ///
title("(e) Marginal effect of financial inclusion[FI_entropy] on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion[FI_entropy]") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Rule of law ", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.691  "IRQ", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.086 "THA", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.018 "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.686  "GBR", place(s) size(small)) ///
text (0 1.995 "FIN", place(s)  size(small))

eststo: xtscc lnco2kt  lnrgdpc lnrgdpc2 lnrenew lnfdi  lntrad lnurb c.score##c.va   $tlist ,  lag (8)
margins, dydx(c.score) at(va=(-1.983 (0.1) 1.801))             
marginsplot, recast(line) recastci(rline)  ///
title("(f) Marginal effect of financial inclusion[FI_entropy] on CO2 emissions") ///
yline(0, lcolor(green) lpattern(dash)) ///
xline(0.5076, lcolor(red) lpattern(dash)) ///
ytitle("∂CO2/ ∂Financial inclusion[FI_entropy]") ///
ylabel(#4) ylabel(, format(%3.2f) angle(0)) ///
xtitle("Voice and accountability", margin(top)) ///
ciopts(lpattern(dot) lcolor(gray) lwidth(medthick))  ///
text (0 -1.732  "SAU", place(ne) size(small)) ///
text (0 -0.925       , place(sw) size(small)) ///
text (0  -0.048 "BOL", place(ne) size(small)) ///
text (0 0.5642       , place(s)  size(small)) ///
text (0 0.627 "ZAF", place(s)  size(small)) ///
text (0 0.6322       , place(ne) size(small)) ///
text (0 1.338  "GBR", place(s) size(small)) ///
text (0 1.649 "NOR", place(s)  size(small))

estout, cells(b(star fmt(3)) se(par fmt(3)) ) stats(N r2 , fmt(3 3 0))  starlevels(* 0.10 ** 0.05 *** 0.01)         
esttab using "C:\Users\XXX\Desktop\Table 8.doc", title(Table 8: Conditional effect of Financial inclusion and governance on carbon emissions,, Driscol-Kraay estimates) se label rtf b(3) scalars( N r2 ) replace ///
star(* 0.10 ** 0.05 *** 0.01) se(3) nonumber mti ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8" "Model 9" "Model 10" "Model 11" "Model 12") nogap 
eststo clear

*********************************END*********************************************

