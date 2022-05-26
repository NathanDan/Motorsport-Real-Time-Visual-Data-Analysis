ods pdf file="/home/natdanjones0/Alpha Tuari Team-Mate Driver Analysis Throughout the Race.pdf";
options nocenter;
options orientation=portrait;

title1 height=22pt "Emilia Romagna Grand Prix, 2021";
title2 height=14pt " ";
title3 height=18pt "Alpha Tuari Team-Mate Driver Analysis Throughout the Race";
title4 height=12pt "Nathan Jones 2022";
title5 height=14pt " ";

*TEAMMATE 1 DATA;
proc import file="/home/natdanjones0/Gasly/Gasly.xlsx"
    out=work.Gasly
    dbms=xlsx;
run;

*TEAMMATE 2 DATA;
proc import file="/home/natdanjones0/Tsunoda/Tsunoda.xlsx"
    out=work.Tsunoda
    dbms=xlsx;
run;

 ods layout gridded columns=2 width=3.8in column_gutter=.1in style={background=white};
 
 *COLUMN ONE CODE GOES BELOW;
 ods region style={background=white};
 ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.GASLY out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Gasly's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX2d416b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
 proc sort data=WORK.GASLY out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Gasly's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX2d416b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
ods graphics / reset;
title;

title3 height=12pt "Gasly's Top 5 Fastest Laps";

PROC SORT DATA = work.GASLY;
	BY time;
RUN;

proc print data=work.GASLY(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT GASLY.lap, GASLY.position, GASLY.time, GASLY.secs, GASLY.avg_speed, GASLY.tyre 
FROM WORK.GASLY GASLY 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Gasly's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.GASLY out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Gasly Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CX2d416b);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.GASLY out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Gasly's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX2d416b);;
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
		entrytitle "Gasly's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.GASLY;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Gasly's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.GASLY;
run;

ods graphics / reset;
title;



title height=12pt "Gasly's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT GASLY.lap, GASLY.position, GASLY.pos_change, GASLY.tyre, GASLY.pit_stop 
FROM WORK.GASLY GASLY 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Gasly's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT GASLY.lap, GASLY.position, GASLY.pos_change, GASLY.tyre, GASLY.pit_stop 
FROM WORK.GASLY GASLY 
WHERE 
   ( GASLY.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Gasly's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT GASLY.lap, GASLY.position, GASLY.pos_change, GASLY.tyre, GASLY.pit_stop 
FROM WORK.GASLY GASLY 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Gasly's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime 
AS 
SELECT RANGE(GASLY.pit_stop) 
AS pit_stop, SUM(GASLY.pit_stop_time) 
AS pit_stop_time 
FROM WORK.GASLY GASLY; 
QUIT;
proc print data=WORK.PitStopTime();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Gasly's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT GASLY.lap, GASLY.position, GASLY.tyre, GASLY.pit_stop, GASLY.pit_stop_time 
FROM WORK.GASLY GASLY 
WHERE GASLY.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Gasly's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.GASLY;
run;

proc sort data=WORK.GASLY out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Gasly's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX2d416b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

*COLUMN TWO GOES BELOW;
ods region style={background=white};	
ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sort data=WORK.TSUNODA out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Tsunoda's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX2d416b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
 proc sort data=WORK.TSUNODA out=_SeriesPlotTaskData;
	by lap;
 run;
ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Tsunoda's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX2d416b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
ods graphics / reset;
title;

title3 height=12pt "Tsunoda's Top 5 Fastest Laps";

PROC SORT DATA = work.TSUNODA;
	BY time;
RUN;

proc print data=work.TSUNODA(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT TSUNODA.lap, TSUNODA.position, TSUNODA.time, TSUNODA.secs, TSUNODA.avg_speed, TSUNODA.tyre 
FROM WORK.TSUNODA TSUNODA 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Tsunoda's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sort data=WORK.TSUNODA out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Tsunoda Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CX2d416b);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.TSUNODA out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Tsunoda's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX2d416b);;
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
		entrytitle "Tsunoda's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.TSUNODA;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Tsunoda's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.TSUNODA;
run;

ods graphics / reset;
title;



title height=12pt "Tsunoda's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT TSUNODA.lap, TSUNODA.position, TSUNODA.pos_change, TSUNODA.tyre, TSUNODA.pit_stop 
FROM WORK.TSUNODA TSUNODA 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Tsunoda's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT TSUNODA.lap, TSUNODA.position, TSUNODA.pos_change, TSUNODA.tyre, TSUNODA.pit_stop 
FROM WORK.TSUNODA TSUNODA 
WHERE 
   ( TSUNODA.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Tsunoda's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT TSUNODA.lap, TSUNODA.position, TSUNODA.pos_change, TSUNODA.tyre, TSUNODA.pit_stop 
FROM WORK.TSUNODA TSUNODA 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Tsunoda's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime2 
AS 
SELECT RANGE(TSUNODA.pit_stop) 
AS pit_stop, SUM(TSUNODA.pit_stop_time) 
AS pit_stop_time 
FROM WORK.TSUNODA TSUNODA; 
QUIT;
proc print data=WORK.PitStopTime2();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


title height=12pt "Tsunoda's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT TSUNODA.lap, TSUNODA.position, TSUNODA.tyre, TSUNODA.pit_stop, TSUNODA.pit_stop_time 
FROM WORK.TSUNODA TSUNODA 
WHERE TSUNODA.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Tsunoda's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.TSUNODA;
run;

proc sort data=WORK.TSUNODA out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Tsunoda's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX2d416b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;


ods pdf close;