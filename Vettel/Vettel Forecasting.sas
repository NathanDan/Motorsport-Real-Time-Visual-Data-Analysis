ods pdf file="/home/natdanjones0/Vettel/Vettel Forecasting.pdf";
options center;
options orientation=portrait;

title1 height=22pt "Emilia Romagna Grand Prix, 2021";
title2 height=14pt " ";
title3 height=18pt "Forecasting Sebastian Vettel's Next 5 Lap Times";
title4 height=12pt "Nathan Jones 2022";
title5 height=14pt " ";

ods graphics / reset width=6.4in height=4.8in imagemap;

proc import file="/home/natdanjones0/Vettel/Vettel.xlsx"
    out=work.Vettel
    dbms=xlsx;
run;

 proc arima data=WORK.Vettel plots
     (only)=(forecast(forecast));
	identify var=time (1 1);
	estimate noint method=CLS;
	forecast lead=5 back=0 alpha=%sysevalf((100-1)/100);
	outlier;
	run;
quit;

ods pdf close;