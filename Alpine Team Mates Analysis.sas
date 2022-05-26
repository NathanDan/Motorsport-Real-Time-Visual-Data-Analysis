ods pdf file="/home/natdanjones0/Alpine Team-Mate Driver Analysis Throughout the Race.pdf";
options nocenter;
options orientation=portrait;

title1 height=20pt "Emilia Romagna Grand Prix, 2021";
title2 height=14pt " ";
title3 height=18pt "Alpine Team-Mate Driver Analysis Throughout the Race";
title4 height=12pt "Nathan Jones 2022";
title5 height=14pt " ";

*TEAMMATE 1 DATA;
proc import file="/home/natdanjones0/Alonso/Alonso.xlsx"
    out=work.Alonso
    dbms=xlsx;
run;

*TEAMMATE 2 DATA;
proc import file="/home/natdanjones0/Ocon/Ocon.xlsx"
    out=work.Ocon
    dbms=xlsx;
run;

 ods layout gridded columns=2 width=3.8in column_gutter=.1in style={background=white};
 
 *COLUMN ONE CODE GOES BELOW;
 ods region style={background=white};
 ods graphics / reset width=6.4in height=4.8in imagemap;

 proc sort data=WORK.ALONSO out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Alonso's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX0753f7);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;

proc sort data=WORK.ALONSO out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Alonso's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX0753f7);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
ods graphics / reset;
title;


title3 height=12pt "Alonso's Top 5 Fastest Laps";

PROC SORT DATA = work.ALONSO;
	BY time;
RUN;

proc print data=work.ALONSO(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT ALONSO.lap, ALONSO.position, ALONSO.time, ALONSO.secs, ALONSO.avg_speed, ALONSO.tyre 
FROM WORK.ALONSO ALONSO 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Alonso's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.ALONSO out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Alonso Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CX0753f7);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.ALONSO out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Alonso's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX0753f7);;
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
		entrytitle "Alonso's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.ALONSO;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Alonso's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.ALONSO;
run;

ods graphics / reset;
title;



title height=12pt "Alonso's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT ALONSO.lap, ALONSO.position, ALONSO.pos_change, ALONSO.tyre, ALONSO.pit_stop 
FROM WORK.ALONSO ALONSO 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Alonso's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT ALONSO.lap, ALONSO.position, ALONSO.pos_change, ALONSO.tyre, ALONSO.pit_stop 
FROM WORK.ALONSO ALONSO 
WHERE 
   ( ALONSO.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Alonso's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT ALONSO.lap, ALONSO.position, ALONSO.pos_change, ALONSO.tyre, ALONSO.pit_stop 
FROM WORK.ALONSO ALONSO 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Alonso's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime 
AS 
SELECT RANGE(ALONSO.pit_stop) 
AS pit_stop, SUM(ALONSO.pit_stop_time) 
AS pit_stop_time 
FROM WORK.ALONSO ALONSO; 
QUIT;
proc print data=WORK.PitStopTime();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Alonso's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT ALONSO.lap, ALONSO.position, ALONSO.tyre, ALONSO.pit_stop, ALONSO.pit_stop_time 
FROM WORK.ALONSO ALONSO 
WHERE ALONSO.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Alonso's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.ALONSO;
run;

proc sort data=WORK.ALONSO out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Alonso's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX0753f7);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;


*COLUMN TWO GOES BELOW;
ods region style={background=white};	
ods graphics / reset width=6.4in height=4.67in imagemap;
proc sort data=WORK.OCON out=_SeriesPlotTaskData;
	by lap;
run;

proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Ocon's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX0753f7);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
run;

proc sort data=WORK.OCON out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Ocon's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX0753f7);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
ods graphics / reset;
title;

title3 height=12pt "Ocon's Top 5 Fastest Laps";

PROC SORT DATA = work.OCON;
	BY time;
RUN;

proc print data=work.OCON(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT OCON.lap, OCON.position, OCON.time, OCON.secs, OCON.avg_speed, OCON.tyre 
FROM WORK.OCON OCON 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Ocon's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sort data=WORK.OCON out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Ocon Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CX0753f7);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.OCON out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Ocon's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX0753f7);;
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
		entrytitle "Ocon's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.OCON;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Ocon's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.OCON;
run;

ods graphics / reset;
title;



title height=12pt "Ocon's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT OCON.lap, OCON.position, OCON.pos_change, OCON.tyre, OCON.pit_stop 
FROM WORK.OCON OCON 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Ocon's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT OCON.lap, OCON.position, OCON.pos_change, OCON.tyre, OCON.pit_stop 
FROM WORK.OCON OCON 
WHERE 
   ( OCON.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Ocon's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT OCON.lap, OCON.position, OCON.pos_change, OCON.tyre, OCON.pit_stop 
FROM WORK.OCON OCON 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Ocon's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime2 
AS 
SELECT RANGE(OCON.pit_stop) 
AS pit_stop, SUM(OCON.pit_stop_time) 
AS pit_stop_time 
FROM WORK.OCON OCON; 
QUIT;
proc print data=WORK.PitStopTime2();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Ocon's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT OCON.lap, OCON.position, OCON.tyre, OCON.pit_stop, OCON.pit_stop_time 
FROM WORK.OCON OCON 
WHERE OCON.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Ocon's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.OCON;
run;

proc sort data=WORK.OCON out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Ocon's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX0753f7);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

ods pdf close;