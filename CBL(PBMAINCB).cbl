       IDENTIFICATION DIVISION.
      *----
       PROGRAM-ID.   PBMAINCB.
       AUTHOR.       SINEM SEN.
      *----
       ENVIRONMENT DIVISION.
      *----
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INP-FILE ASSIGN TO INPFILE
                       STATUS ST-INP-FILE.
           SELECT OUT-FILE ASSIGN TO OUTFILE
                       STATUS ST-OUT-FILE.
      *----
       DATA DIVISION.
      *----
       FILE SECTION.
       FD  INP-FILE RECORDING MODE F.
       01  INP-VARIABLES.
           05 PROCESS-TYPE      PIC X(01).
           05 INP-ID            PIC X(05).
           05 INP-DVZ           PIC X(03).
      *----
       FD  OUT-FILE RECORDING MODE F.
       01  OUT-VARIABLES.
           05 PROCESS-TYPE-O    PIC 9(01).
           05 FILLER            PIC X(02)      VALUE SPACES.
           05 OUT-ID            PIC 9(05).
           05 FILLER            PIC X(02)      VALUE SPACES.
           05 OUT-DVZ           PIC 9(03).
           05 FILLER            PIC X(02)      VALUE SPACES.
           05 OUT-RC            PIC 9(02).
           05 FILLER            PIC X(02)      VALUE SPACES.
           05 OUT-DATA          PIC X(90).
      *----
       WORKING-STORAGE SECTION.
      *----
       01  WS-WORK-AREA.
      *----
           05 WS-PBSUBPG0          PIC X(08)   VALUE 'PBSUBPG0'.
           05 ST-INP-FILE          PIC 9(02).
              88 INP-SUCCESS                   VALUE 00 97.
              88 INP-EOF                       VALUE 10.
      *----
           05 ST-OUT-FILE          PIC 9(02).
              88 OUT-SUCCESS                   VALUE 00 97.
      *----
           05 WS-SUB-AREA.
              10 WS-SUB-FUNC       PIC 9(01).
                 88 WS-FUNC-OPEN               VALUE 1.
                 88 WS-FUNC-READ               VALUE 2.
                 88 WS-FUNC-WRITE              VALUE 3.
                 88 WS-FUNC-UPDATE             VALUE 4.
                 88 WS-FUNC-DELETE             VALUE 5.
                 88 WS-FUNC-CLOSE              VALUE 9.
      *----
              10 WS-SUB-ID        PIC 9(05).
              10 WS-SUB-DVZ       PIC 9(03).
              10 WS-SUB-RC        PIC 9(02).
              10 WS-SUB-DATA      PIC X(90).
      *----
       PROCEDURE DIVISION.
      *----
       0000-MAIN.
           PERFORM H100-OPEN-FILES.
           PERFORM H200-MOVE-PROGRAM UNTIL INP-EOF.
           PERFORM H999-PROGRAM-EXIT.
       0000-END. EXIT.
      *----
       H100-OPEN-FILES.
           OPEN INPUT INP-FILE.
           OPEN OUTPUT OUT-FILE.
           PERFORM H110-OPEN-CHECK.
           SET WS-FUNC-OPEN TO TRUE.
           CALL WS-PBSUBPG0 USING WS-SUB-AREA.
       H100-END-EXIT.
      *----
       H110-OPEN-CHECK.
      *----
           IF NOT INP-SUCCESS
              DISPLAY 'Could not open input file. RC : ' ST-INP-FILE
              PERFORM H999-PROGRAM-EXIT
           END-IF.
           IF NOT OUT-SUCCESS
              DISPLAY 'Could not open output file. RC : ' ST-OUT-FILE
              PERFORM H999-PROGRAM-EXIT
           END-IF.
      *----
           READ INP-FILE.
           IF NOT INP-SUCCESS
              DISPLAY 'Could not read input file. RC : ' ST-INP-FILE
              PERFORM H999-PROGRAM-EXIT
     *     END-IF.
       H110-END. EXIT.
      *----Bu kod parçac, belirli veri alanlarn saysal deerlere
      *dönütürür, ardndan bu verileri baka bir alt programa gönderir,
      *çkt dosyasna yazar ve daha sonra bir sonraki girii okur.
       H200-MOVE-PROGRAM.
           COMPUTE WS-SUB-FUNC = FUNCTION NUMVAL(PROCESS-TYPE).
           COMPUTE WS-SUB-ID = FUNCTION NUMVAL(INP-ID).
           COMPUTE WS-SUB-DVZ = FUNCTION NUMVAL(INP-DVZ).
           CALL WS-PBSUBPG0 USING WS-SUB-AREA.
           MOVE SPACES TO OUT-VARIABLES.
           MOVE WS-SUB-FUNC TO PROCESS-TYPE-O.
           MOVE WS-SUB-ID  TO OUT-ID.
           MOVE WS-SUB-DVZ  TO OUT-DVZ.
           MOVE WS-SUB-RC  TO OUT-RC.
           MOVE WS-SUB-DATA  TO OUT-DATA.
           WRITE OUT-VARIABLES.
           READ INP-FILE.
       H200-END. EXIT.
      *----
       H999-PROGRAM-EXIT.
           CLOSE INP-FILE.
           CLOSE OUT-FILE.
           STOP RUN.
       H999-END. EXIT.
      *----
