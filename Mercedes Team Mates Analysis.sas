ods pdf file="/home/natdanjones0/Mercedes Team-Mate Driver Analysis Throughout the Race.pdf";
options nocenter;
options orientation=portrait;

title1 height=20pt "Emilia Romagna Grand Prix, 2021";
title2 height=14pt " ";
title3 height=18pt "Mercedes Team-Mate Driver Analysis Throughout the Race";
title4 height=12pt "Nathan Jones 2022";
title5 height=14pt " ";


*TEAMMATE 1 DATA;
proc import file="/home/natdanjones0/Hamilton/Hamilton.xlsx"
    out=work.Hamilton
    dbms=xlsx;
run;

*TEAMMATE 2 DATA;
proc import file="/home/natdanjones0/Bottas/Bottas.xlsx"
    out=work.Bottas
    dbms=xlsx;
run;
 ods layout gridded columns=2 width=3.8in column_gutter=.1in style={background=white};
 
 *COLUMN ONE CODE GOES BELOW;
 ods region style={background=white};
 ods graphics / reset width=6.4in height=4.8in imagemap;

proc sort data=WORK.HAMILTON out=_SeriesPlotTaskData;
	by lap;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Hamilton's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX1af8f8);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
run;

proc sort data=WORK.HAMILTON out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Hamilton's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX1af8f8);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;

ods graphics / reset;
title;

title3 height=12pt "Hamilton's Top 5 Fastest Laps";
PROC SQL; 
CREATE TABLE WORK.FastLaps 
AS 
SELECT HAMILTON.lap, HAMILTON.position, HAMILTON.time, HAMILTON.secs, HAMILTON.avg_speed, HAMILTON.tyre 
FROM WORK.HAMILTON HAMILTON 
WHERE 
   ( HAMILTON.position BETWEEN 1 AND 20 ) 
ORDER BY 3 ASC; 
QUIT;

proc print data=work.FastLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT HAMILTON.lap, HAMILTON.position, HAMILTON.time, HAMILTON.secs, HAMILTON.avg_speed, HAMILTON.tyre 
FROM WORK.HAMILTON HAMILTON 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Hamilton's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.HAMILTON out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Hamilton Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CX1af8f8);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.HAMILTON out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Hamilton's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX1af8f8);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-20 to 20 by 1);
 run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Hamilton's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.HAMILTON;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Hamilton's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.HAMILTON;
run;

ods graphics / reset;
title;



title height=12pt "Hamilton's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT HAMILTON.lap, HAMILTON.position, HAMILTON.pos_change, HAMILTON.tyre, HAMILTON.pit_stop 
FROM WORK.HAMILTON HAMILTON 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Hamilton's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT HAMILTON.lap, HAMILTON.position, HAMILTON.pos_change, HAMILTON.tyre, HAMILTON.pit_stop 
FROM WORK.HAMILTON HAMILTON 
WHERE 
   ( HAMILTON.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Hamilton's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT HAMILTON.lap, HAMILTON.position, HAMILTON.pos_change, HAMILTON.tyre, HAMILTON.pit_stop 
FROM WORK.HAMILTON HAMILTON 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Hamilton's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime 
AS 
SELECT RANGE(HAMILTON.pit_stop) 
AS pit_stop, SUM(HAMILTON.pit_stop_time) 
AS pit_stop_time 
FROM WORK.HAMILTON HAMILTON; 
QUIT;
proc print data=WORK.PitStopTime();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Hamilton's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT HAMILTON.lap, HAMILTON.position, HAMILTON.tyre, HAMILTON.pit_stop, HAMILTON.pit_stop_time 
FROM WORK.HAMILTON HAMILTON 
WHERE HAMILTON.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Hamilton's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.HAMILTON;
run;

proc sort data=WORK.HAMILTON out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Hamilton's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX1af8f8);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

*COLUMN TWO GOES BELOW;
ods region style={background=white};	
ods graphics / reset width=6.4in height=4.67in imagemap;



proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
ods graphics / reset width=6.4in height=4.67in imagemap;

proc sort data=WORK.BOTTAS out=_SeriesPlotTaskData;
	by lap;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Bottas's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX1af8f8);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
run;

proc sort data=WORK.BOTTAS out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Bottas's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX1af8f8);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;

ods graphics / reset;
title;

title3 height=12pt "Bottas's Top 5 Fastest Laps";
PROC SQL; 
CREATE TABLE WORK.FastLaps2 
AS 
SELECT BOTTAS.lap, BOTTAS.position, BOTTAS.time, BOTTAS.secs, BOTTAS.avg_speed, BOTTAS.tyre 
FROM WORK.BOTTAS BOTTAS 
WHERE 
   ( BOTTAS.position BETWEEN '1' AND '20' ) 
ORDER BY 3 ASC; 
QUIT;

proc print data=work.FastLaps2(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT BOTTAS.lap, BOTTAS.position, BOTTAS.time, BOTTAS.secs, BOTTAS.avg_speed, BOTTAS.tyre 
FROM WORK.BOTTAS BOTTAS 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Bottas's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sort data=WORK.BOTTAS out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Bottas Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CX1af8f8);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.BOTTAS out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Bottas's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX1af8f8);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-20 to 20 by 1);
 run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Bottas's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.BOTTAS;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Bottas's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.BOTTAS;
run;

ods graphics / reset;
title;



title height=12pt "Bottas's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT BOTTAS.lap, BOTTAS.position, BOTTAS.pos_change, BOTTAS.tyre, BOTTAS.pit_stop 
FROM WORK.BOTTAS BOTTAS 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Bottas's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT BOTTAS.lap, BOTTAS.position, BOTTAS.pos_change, BOTTAS.tyre, BOTTAS.pit_stop 
FROM WORK.BOTTAS BOTTAS 
WHERE 
   ( BOTTAS.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Bottas's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT BOTTAS.lap, BOTTAS.position, BOTTAS.pos_change, BOTTAS.tyre, BOTTAS.pit_stop 
FROM WORK.BOTTAS BOTTAS 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Bottas's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime2 
AS 
SELECT RANGE(BOTTAS.pit_stop) 
AS pit_stop, SUM(BOTTAS.pit_stop_time) 
AS pit_stop_time 
FROM WORK.BOTTAS BOTTAS; 
QUIT;
proc print data=WORK.PitStopTime2();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Bottas's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT BOTTAS.lap, BOTTAS.position, BOTTAS.tyre, BOTTAS.pit_stop, BOTTAS.pit_stop_time 
FROM WORK.BOTTAS BOTTAS 
WHERE BOTTAS.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Bottas's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.BOTTAS;
run;


proc sort data=WORK.BOTTAS out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Bottas's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX1af8f8);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;


ods pdf close;