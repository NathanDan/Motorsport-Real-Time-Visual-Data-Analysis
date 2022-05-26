ods pdf file="/home/natdanjones0/Alfa Romeo Team-Mate Driver Analysis Throughout the Race.pdf";
options nocenter;
options orientation=portrait;

title1 height=22pt "Emilia Romagna Grand Prix, 2021";
title2 height=14pt " ";
title3 height=18pt "Alfa Romeo Team-Mate Driver Analysis Throughout the Race";
title4 height=12pt "Nathan Jones 2022";
title5 height=14pt " ";

*TEAMMATE 1 DATA;
proc import file="/home/natdanjones0/Raikkonen/Raikkonen.xlsx"
    out=work.Raikkonen
    dbms=xlsx;
run;

*TEAMMATE 2 DATA;
proc import file="/home/natdanjones0/Giovinazzi/Giovinazzi.xlsx"
    out=work.Giovinazzi
    dbms=xlsx;
run;

 ods layout gridded columns=2 width=3.8in column_gutter=.1in style={background=white};
 
 *COLUMN ONE CODE GOES BELOW;
 ods region style={background=white};
 ods graphics / reset width=6.4in height=4.8in imagemap;

 proc sort data=WORK.RAIKKONEN out=_SeriesPlotTaskData;
	by lap;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Raikkonen's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXa72828);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
run;

proc sort data=WORK.RAIKKONEN out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Raikkonen's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXa72828);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
ods graphics / reset;
title;

title3 height=12pt "Raikkonen's Top 5 Fastest Laps";

PROC SORT DATA = work.RAIKKONEN;
	BY time;
RUN;

proc print data=work.RAIKKONEN(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT RAIKKONEN.lap, RAIKKONEN.position, RAIKKONEN.time, RAIKKONEN.secs, RAIKKONEN.avg_speed, RAIKKONEN.tyre 
FROM WORK.RAIKKONEN RAIKKONEN 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Raikkonen's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.RAIKKONEN out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Raikkonen Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CXa72828);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.RAIKKONEN out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Raikkonen's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXa72828);;
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
		entrytitle "Raikkonen's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.RAIKKONEN;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Raikkonen's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.RAIKKONEN;
run;

ods graphics / reset;
title;



title height=12pt "Raikkonen's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT RAIKKONEN.lap, RAIKKONEN.position, RAIKKONEN.pos_change, RAIKKONEN.tyre, RAIKKONEN.pit_stop 
FROM WORK.RAIKKONEN RAIKKONEN 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  
   
   run;
   
title height=12pt "Raikkonen's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT RAIKKONEN.lap, RAIKKONEN.position, RAIKKONEN.pos_change, RAIKKONEN.tyre, RAIKKONEN.pit_stop 
FROM WORK.RAIKKONEN RAIKKONEN 
WHERE 
   ( RAIKKONEN.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  
   
   run;

title height=12pt "Raikkonen's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT RAIKKONEN.lap, RAIKKONEN.position, RAIKKONEN.pos_change, RAIKKONEN.tyre, RAIKKONEN.pit_stop 
FROM WORK.RAIKKONEN RAIKKONEN 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Raikkonen's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime 
AS 
SELECT RANGE(RAIKKONEN.pit_stop) 
AS pit_stop, SUM(RAIKKONEN.pit_stop_time) 
AS pit_stop_time 
FROM WORK.RAIKKONEN RAIKKONEN; 
QUIT;
proc print data=WORK.PitStopTime();
    
    VAR pit_stop pit_stop_time;  
    
run;

title height=12pt "Raikkonen's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT RAIKKONEN.lap, RAIKKONEN.position, RAIKKONEN.tyre, RAIKKONEN.pit_stop, RAIKKONEN.pit_stop_time 
FROM WORK.RAIKKONEN RAIKKONEN 
WHERE RAIKKONEN.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Raikkonen's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.RAIKKONEN;
run;

proc sort data=WORK.RAIKKONEN out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Raikkonen's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXa72828);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

*COLUMN TWO GOES BELOW;
ods region style={background=white};	
ods graphics / reset width=6.4in height=4.67in imagemap;

 proc sort data=WORK.GIOVINAZZI out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Giovinazzi's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXa72828);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;

proc sort data=WORK.GIOVINAZZI out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Giovinazzi's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXa72828);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;

ods graphics / reset;
title;

title3 height=12pt "Giovinazzi's Top 5 Fastest Laps";

PROC SORT DATA = work.GIOVINAZZI;
BY time;
RUN;

proc print data=work.GIOVINAZZI(obs=5);
    
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
    
run;


PROC SQL; 
CREATE TABLE WORK.SlowLaps2 
AS 
SELECT GIOVINAZZI.lap, GIOVINAZZI.position, GIOVINAZZI.time, GIOVINAZZI.secs, GIOVINAZZI.avg_speed, GIOVINAZZI.tyre 
FROM WORK.GIOVINAZZI GIOVINAZZI 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Giovinazzi's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps2(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;


ods graphics / reset;
title;


ods graphics / reset width=6.4in height=4.67in imagemap;
proc sort data=WORK.GIOVINAZZI out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Giovinazzi Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CXa72828);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.GIOVINAZZI out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Giovinazzi's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXa72828);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-20 to 20 by 1);
 run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Giovinazzi's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.GIOVINAZZI;
run;

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Giovinazzi's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.GIOVINAZZI;
run;

title height=12pt "Giovinazzi's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos2 
AS 
SELECT GIOVINAZZI.lap, GIOVINAZZI.position, GIOVINAZZI.pos_change, GIOVINAZZI.tyre, GIOVINAZZI.pit_stop 
FROM WORK.GIOVINAZZI GIOVINAZZI 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos2(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Giovinazzi's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap2 
AS 
SELECT GIOVINAZZI.lap, GIOVINAZZI.position, GIOVINAZZI.pos_change, GIOVINAZZI.tyre, GIOVINAZZI.pit_stop 
FROM WORK.GIOVINAZZI GIOVINAZZI 
WHERE 
   ( GIOVINAZZI.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap2(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;  
 
title height=12pt "Giovinazzi's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos2
AS 
SELECT GIOVINAZZI.lap, GIOVINAZZI.position, GIOVINAZZI.pos_change, GIOVINAZZI.tyre, GIOVINAZZI.pit_stop 
FROM WORK.GIOVINAZZI GIOVINAZZI 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos2(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Giovinazzi's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime2 
AS 
SELECT RANGE(GIOVINAZZI.pit_stop) 
AS pit_stop, SUM(GIOVINAZZI.pit_stop_time) 
AS pit_stop_time 
FROM WORK.GIOVINAZZI GIOVINAZZI; 
QUIT;
proc print data=WORK.PitStopTime2();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Giovinazzi's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops2
AS 
SELECT GIOVINAZZI.lap, GIOVINAZZI.position, GIOVINAZZI.tyre, GIOVINAZZI.pit_stop, GIOVINAZZI.pit_stop_time 
FROM WORK.GIOVINAZZI GIOVINAZZI 
WHERE GIOVINAZZI.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops2();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Giovinazzi's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;
ods graphics / reset width=6.4in height=4.67in imagemap;
proc sgrender template=SASStudio.Pie data=WORK.GIOVINAZZI;
run;

proc sort data=WORK.GIOVINAZZI out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Giovinazzi's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXa72828);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

ods pdf close;