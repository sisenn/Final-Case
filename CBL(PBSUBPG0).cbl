       IDENTIFICATION DIVISION.
      *----
       PROGRAM-ID.    PBSUBPG0.
       AUTHOR.        SINEM SEN.
      *----
       ENVIRONMENT DIVISION.
      *----
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE ASSIGN TO IDXFILE
                           ORGANIZATION INDEXED
                           ACCESS RANDOM
                           RECORD KEY IDX-KEY
                           STATUS ST-IDX-FILE.
      *----
       DATA DIVISION.
      *----
       FILE SECTION.
      *----
       FD  IDX-FILE.
       01  IDX-VARIABLES.
           05 IDX-KEY.
               10 IDX-ID         PIC S9(05) COMP-3.
               10 IDX-DVZ        PIC S9(03) COMP.
           05 IDX-NAME           PIC X(15).
           05 IDX-SURNAME        PIC X(15).
           05 IDX-DATE           PIC S9(07) COMP-3.
           05 IDX-BALANCE        PIC S9(15) COMP-3.
      *----
       WORKING-STORAGE SECTION.
      *----
       01  WS-SUB-AREA.
      *----
           05 ST-IDX-FILE        PIC 9(02).
              88 IDX-SUCCESS                         VALUE 00 97.
              88 IDX-EOF                             VALUE 10.
      *----
       01  FLAG                  PIC 9(01)           VALUE 0.
      *----
       01  INX-1                 PIC 9(02)           VALUE 1.
      *----
       01  INX-2                 PIC 9(02)           VALUE 1.
      *----
       LINKAGE SECTION.
      *----
       01  LS-SUB-AREA.
           05 LS-SUB-FUNC        PIC 9(01).
           05 LS-SUB-ID          PIC 9(05).
           05 LS-SUB-DVZ         PIC 9(03).
           05 LS-SUB-RC          PIC 9(02).
           05 LS-SUB-DATA.
              10 LS-NAME-FROM     PIC X(15).
              10 LS-SURNAME-FROM  PIC X(15).
              10 LS-NAME-TO       PIC X(15).
              10 LS-SURNAME-TO    PIC X(15).
              10 LS-EXP           PIC X(30).
      *----
       PROCEDURE DIVISION USING LS-SUB-AREA.
      *----Bu kod parçac, LS-SUB-FUNC deerine göre farkl ilevlerin
      *çarlmasn salar ve ilevin ne yaplacan belirleyen bir
      *kontrol yaps sunar.
       0000-MAIN.
           MOVE SPACES TO LS-SUB-DATA.
           EVALUATE LS-SUB-FUNC
              WHEN 1
                 PERFORM H100-OPEN-FILES
              WHEN 2
                 PERFORM H200-READ-FUNC
              WHEN 3
                 PERFORM H300-WRITE-FUNC
              WHEN 4
                 PERFORM H400-UPDATE-FUNC
              WHEN 5
                 PERFORM H500-DELETE-FUNC
              WHEN 9
                 PERFORM H900-CLOSE-FUNC
              WHEN OTHER
                 MOVE 'UNDEFINED FUNCTION' TO LS-EXP
                 GOBACK
           END-EVALUATE.
       0000-END. EXIT.
      *----
       H100-OPEN-FILES.
           OPEN I-O IDX-FILE.
           IF NOT IDX-SUCCESS
              DISPLAY 'INDEX FILE NOT OPEN. RC : ' ST-IDX-FILE
              STOP RUN
           END-IF.
           GOBACK.
       H100-END. EXIT.
      *----
       H150-KEY-CONTROL.
           MOVE LS-SUB-ID TO IDX-ID.
           MOVE LS-SUB-DVZ TO IDX-DVZ.
      *----
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY
           EVALUATE LS-SUB-FUNC
              WHEN 3
                 MOVE 1 TO FLAG
              WHEN OTHER
                 MOVE 'WRONG RECORD. RC: ' TO LS-EXP
                 GOBACK
           END-EVALUATE
           END-READ.
      *----
           MOVE ST-IDX-FILE TO LS-SUB-RC.
       H150-END. EXIT.
      *----
       H200-READ-FUNC.
           PERFORM H150-KEY-CONTROL.
           MOVE 'READ SUCCESSFULLY' TO LS-EXP.
           MOVE IDX-NAME TO LS-NAME-FROM.
           MOVE IDX-SURNAME TO LS-SURNAME-FROM.
           GOBACK.
       H200-END. EXIT.
      *----Bu kod parçac, FLAG deikeninin deerine göre farkl
      *senaryolara göre ilemler gerçekletirir. Eer FLAG deeri 1 ise
      *yeni bir kayt oluturulur, deeri 0 ise mevcut bir kayt
      *olduunu belirtir. Bu ilemlerden sonra veriler yazlr, baz
      *deikenlere deerler atanr ve program sonlandrlr.
       H300-WRITE-FUNC.
           PERFORM H150-KEY-CONTROL.
      *----
           IF FLAG = 1
              MOVE 'SINEM' TO IDX-NAME
              MOVE 'SEN' TO IDX-SURNAME
              MOVE ZEROES TO IDX-DATE
              MOVE ZEROES TO IDX-BALANCE
              MOVE IDX-NAME TO LS-NAME-FROM
              MOVE IDX-SURNAME TO LS-SURNAME-FROM
              MOVE SPACES TO LS-NAME-TO
              MOVE SPACES TO LS-SURNAME-TO
              MOVE 'CREATED NEW RECORD' TO LS-EXP
           ELSE
              MOVE 'THIS RECORD ALREADY EXIST' TO LS-EXP
              MOVE IDX-NAME TO LS-NAME-FROM
              MOVE IDX-SURNAME TO LS-SURNAME-FROM
      *----
           END-IF.
           WRITE IDX-VARIABLES
           MOVE ST-IDX-FILE TO LS-SUB-RC
           MOVE 0 TO FLAG
           GOBACK.
       H300-END. EXIT.
      *----Bu kod parçac, veri tama, döngü, deiken manipülasyonu
      *ve veri deitirme ilemlerini gerçekletirir. lgili ilemler,
      *verileri kontrol eder, karakterleri deitirir ve deitirilen
      *verileri yazma ilemine tabi tutar.
       H400-UPDATE-FUNC.
      *----
           PERFORM H150-KEY-CONTROL.
           MOVE IDX-NAME TO LS-NAME-FROM.
           MOVE IDX-SURNAME TO LS-SURNAME-FROM.
      *----
           PERFORM VARYING INX-1 FROM 1 BY 1 UNTIL INX-1 >
      -    LENGTH OF IDX-NAME
              IF IDX-NAME(INX-1:1) NOT = SPACE
                 MOVE IDX-NAME(INX-1:1) TO LS-NAME-TO(INX-2:1)
                 ADD 1 TO INX-2
              END-IF
           END-PERFORM.
      *----
           MOVE 1 TO INX-1.
           MOVE 1 TO INX-2.
      *----
           IF LS-NAME-FROM = LS-NAME-TO
              MOVE 'SPACE NOT FOUND' TO LS-EXP
           ELSE
              MOVE 'SUCCESSFULLY UPDATED' TO LS-EXP
           END-IF.
      *----
           INSPECT IDX-SURNAME REPLACING ALL 'E' BY 'I'
           INSPECT IDX-SURNAME REPLACING ALL 'A' BY 'E'
           MOVE LS-NAME-TO TO IDX-NAME.
           MOVE IDX-SURNAME TO LS-SURNAME-TO.
           REWRITE IDX-VARIABLES.
           GOBACK.
       H400-END. EXIT.
      *----
       H500-DELETE-FUNC.
           PERFORM H150-KEY-CONTROL.
           DELETE IDX-FILE.
           MOVE 'SUCCESSFULLY DELETED ' TO LS-EXP.
           GOBACK.
       H500-END. EXIT.
      *----
       H900-CLOSE-FUNC.
           CLOSE IDX-FILE.
           GOBACK.
       H900-END. EXIT.
      *----
