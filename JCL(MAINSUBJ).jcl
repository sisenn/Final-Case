//MAINSUBJ JOB ' ',NOTIFY=&SYSUID
//DELETE   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE Z95645.QSAM.OUT
  IF LASTCC LE 08 THEN SET MAXCC = 00
//SUB EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(PBSUBPG0),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(PBSUBPG0),DISP=SHR
//MAIN EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(PBMAINCB),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(PBMAINCB),DISP=SHR
// IF RC < 5 THEN
//MAINRUN   EXEC PGM=PBMAINCB
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//INPFILE   DD DSN=&SYSUID..QSAM.CHK,DISP=SHR
//IDXFILE   DD DSN=&SYSUID..VSAM.SUB,DISP=SHR
//OUTFILE   DD DSN=&SYSUID..QSAM.OUT,
//          DISP=(NEW,CATLG,DELETE),
//          UNIT=SYSDA,
//          SPACE=(TRK,(10,10),RLSE),
//          DCB=(RECFM=FB,LRECL=109,BLKSIZE=0)
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
// ELSE
// ENDIF
// IF RC < 5 THEN
//SUBRUN    EXEC PGM=PBSUBPG0
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//IDXFILE   DD DSN=&SYSUID..VSAM.SUB,DISP=SHR
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
// ELSE
// ENDIF
