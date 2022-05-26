ods pdf file="/home/natdanjones0/HAAS Team-Mate Driver Analysis Throughout the Race.pdf";
options nocenter;
options orientation=portrait;

title1 height=20pt "Emilia Romagna Grand Prix, 2021";
title2 height=14pt " ";
title3 height=18pt "HAAS Team-Mate Driver Analysis Throughout the Race";
title4 height=12pt "Nathan Jones 2022";
title5 height=14pt " ";

*TEAMMATE 1 DATA;
proc import file="/home/natdanjones0/Schumacher/Schumacher.xlsx"
    out=work.Schumacher
    dbms=xlsx;
run;

*TEAMMATE 2 DATA;
proc import file="/home/natdanjones0/Mazepin/Mazepin.xlsx"
    out=work.Mazepin
    dbms=xlsx;
run;

 ods layout gridded columns=2 width=3.8in column_gutter=.1in style={background=white};
 
 *COLUMN ONE CODE GOES BELOW;
 ods region style={background=white};
 ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.SCHUMACHER out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Schumacher Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000) 
		lineattrs=(color=CXf31212);
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
 proc sort data=WORK.SCHUMACHER out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Schumacher's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
ods graphics / reset;
title;

title3 height=12pt "Schumacher's Top 5 Fastest Laps";

PROC SORT DATA = work.SCHUMACHER;
	BY time;
RUN;

proc print data=work.SCHUMACHER(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT SCHUMACHER.lap, SCHUMACHER.position, SCHUMACHER.time, SCHUMACHER.secs, SCHUMACHER.avg_speed, SCHUMACHER.tyre 
FROM WORK.SCHUMACHER SCHUMACHER 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Schumacher's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.SCHUMACHER out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Schumacher Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CXf31212);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.SCHUMACHER out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Schumacher's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
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
		entrytitle "Schumacher's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.SCHUMACHER;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Schumacher's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.SCHUMACHER;
run;

ods graphics / reset;
title;



title height=12pt "Schumacher's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT SCHUMACHER.lap, SCHUMACHER.position, SCHUMACHER.pos_change, SCHUMACHER.tyre, SCHUMACHER.pit_stop 
FROM WORK.SCHUMACHER SCHUMACHER 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Schumacher's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT SCHUMACHER.lap, SCHUMACHER.position, SCHUMACHER.pos_change, SCHUMACHER.tyre, SCHUMACHER.pit_stop 
FROM WORK.SCHUMACHER SCHUMACHER 
WHERE 
   ( SCHUMACHER.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Schumacher's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT SCHUMACHER.lap, SCHUMACHER.position, SCHUMACHER.pos_change, SCHUMACHER.tyre, SCHUMACHER.pit_stop 
FROM WORK.SCHUMACHER SCHUMACHER 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Schumacher's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime 
AS 
SELECT RANGE(SCHUMACHER.pit_stop) 
AS pit_stop, SUM(SCHUMACHER.pit_stop_time) 
AS pit_stop_time 
FROM WORK.SCHUMACHER SCHUMACHER; 
QUIT;
proc print data=WORK.PitStopTime();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Schumacher's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT SCHUMACHER.lap, SCHUMACHER.position, SCHUMACHER.tyre, SCHUMACHER.pit_stop, SCHUMACHER.pit_stop_time 
FROM WORK.SCHUMACHER SCHUMACHER 
WHERE SCHUMACHER.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Schumacher's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.SCHUMACHER;
run;

proc sort data=WORK.SCHUMACHER out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Schumacher's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

*COLUMN TWO GOES BELOW;
ods region style={background=white};	
ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sort data=WORK.MAZEPIN out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Mazepin's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
 proc sort data=WORK.MAZEPIN out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Mazepin's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
ods graphics / reset;
title;

title3 height=12pt "Mazepin's Top 5 Fastest Laps";

PROC SORT DATA = work.MAZEPIN;
	BY time;
RUN;

proc print data=work.MAZEPIN(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT MAZEPIN.lap, MAZEPIN.position, MAZEPIN.time, MAZEPIN.secs, MAZEPIN.avg_speed, MAZEPIN.tyre 
FROM WORK.MAZEPIN MAZEPIN 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Mazepin's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sort data=WORK.MAZEPIN out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Mazepin Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CXf31212);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.MAZEPIN out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Mazepin's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
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
		entrytitle "Mazepin's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.MAZEPIN;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Mazepin's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.MAZEPIN;
run;

ods graphics / reset;
title;



title height=12pt "Mazepin's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT MAZEPIN.lap, MAZEPIN.position, MAZEPIN.pos_change, MAZEPIN.tyre, MAZEPIN.pit_stop 
FROM WORK.MAZEPIN MAZEPIN 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Mazepin's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT MAZEPIN.lap, MAZEPIN.position, MAZEPIN.pos_change, MAZEPIN.tyre, MAZEPIN.pit_stop 
FROM WORK.MAZEPIN MAZEPIN 
WHERE 
   ( MAZEPIN.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Mazepin's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT MAZEPIN.lap, MAZEPIN.position, MAZEPIN.pos_change, MAZEPIN.tyre, MAZEPIN.pit_stop 
FROM WORK.MAZEPIN MAZEPIN 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Mazepin's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime2 
AS 
SELECT RANGE(MAZEPIN.pit_stop) 
AS pit_stop, SUM(MAZEPIN.pit_stop_time) 
AS pit_stop_time 
FROM WORK.MAZEPIN MAZEPIN; 
QUIT;
proc print data=WORK.PitStopTime2();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Mazepin's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT MAZEPIN.lap, MAZEPIN.position, MAZEPIN.tyre, MAZEPIN.pit_stop, MAZEPIN.pit_stop_time 
FROM WORK.MAZEPIN MAZEPIN 
WHERE MAZEPIN.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Mazepin's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.MAZEPIN;
run;

proc sort data=WORK.MAZEPIN out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Mazepin's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;


ods pdf close;