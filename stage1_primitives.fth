:! POSTPONE  NAME FIND COMPILE ;
:! :  POSTPONE :! POSTPONE DOCOL ;

:! DPOPQ  POSTPONE RBPMOVQ@  POSTPONE RBP $ 8 POSTPONE ADDQ$ ;
:! DPUSHQ   POSTPONE RBP $ 8 POSTPONE SUBQ$   POSTPONE RBPMOVQ! ;

: NIP  RDX DPOPQ ;
: TUCK  RAX DPUSHQ ;
: OVER  SWAP TUCK ;

: THERE  RDI RAXXCHGQ  ;
: ALLOT  RDI RAX ADDQ  DROP ;
: 1ALLOT  RDI INCQ ;

: 1+  RAX INCQ ;
: 1-  RAX DECQ ;

: COND  RBX RAX MOVQ  DROP  RBX RBX TESTQ ;

:! BEGIN  HERE ;
:! AHEAD  HERE 1+  HERE POSTPONE JMP$ ;
:! IF  POSTPONE COND  HERE 1+  HERE POSTPONE JZ$ ;
:! AGAIN  POSTPONE JMP$ ;
:! UNTIL  POSTPONE COND POSTPONE JZ$ ;
:! THEN  THERE  DUP REL8,  THERE DROP ;
:! ELSE  POSTPONE AHEAD  SWAP  POSTPONE THEN ;
:! WHILE  POSTPONE IF  SWAP ;

: 0=  RBX DUPXORQ  RAX RAX TESTQ  RBX SETNZB  RBX DECQ  RAX RBX MOVQ ;
: =  RBX DUPXORQ  RDX RAX CMPQ  RBX SETNZB  RBX DECQ  RAX RBX MOVQ  NIP ;
:! \  BEGIN  RX $ A =  UNTIL ;

\ Comments are now enabled!

: STARTFOR  RBX POPQ  RCX PUSHQ  RBX PUSHQ  RCX RAX MOVQ  DROP ;
: ENDFOR  RBX POPQ  RCX POPQ  RBX PUSHQ ;
:! FOR  POSTPONE STARTFOR HERE ;
:! AFT  DROP POSTPONE AHEAD POSTPONE BEGIN SWAP ;
:! NEXT  POSTPONE LOOP$ POSTPONE ENDFOR ;
: I  DUP  RAX RCX MOVQ ;

: C@  RAX RAX MOVZXB@ ;
: C!  RAX RDX MOVB!  DROP DROP ;

: COUNT  1+ DUP 1- C@ ;
: TYPE  FOR DUP C@ TX 1+ NEXT DROP ;

: CR  $ A TX ;
: BL  $ 20 ;
: LITERAL  DOLIT , ;
:! CHAR  NAME 1+ C@ LITERAL ;

: EXECUTE   RBX RAX MOVQ  DROP  RBX JMP
:! [  RDI PUSHQ  BEGIN  NAME DUP FIND  DUP
                 IF  NIP EXECUTE
                 ELSE  DROP  COUNT TYPE  CHAR ? TX  CR  POSTPONE \
\ TODO ^ POSTPONE \ should be replaced by QUIT later.
                 THEN AGAIN
:! ]  POSTPONE ;  RBX POPQ  RDI POPQ  RDI JMP
[
\ TODO ^ This should also be replaced by QUIT later.
\ : QUIT  BEGIN CHAR [ TX BL TX POSTPONE [ AGAIN ;
\ ^ This definition almost works, but needs to reset registers
\ Another problem: These definitions rely on each other.

: >R  RBX POPQ  RAX PUSHQ  RBX PUSHQ  DROP ;
: R>  DUP  RBX POPQ  RAX POPQ  RBX PUSHQ ;
: RDROP  RBX POPQ  RSP [ $ 8 ] ADDQ$  RBX PUSHQ ;

: CONTEXT>R  RBX POPQ   RCX PUSHQ RSI PUSHQ RDI PUSHQ  RBX PUSHQ ;
: R>CONTEXT  RBX POPQ   RDI POPQ  RSI POPQ  RCX POPQ   RBX PUSHQ ;
: MOVE  CONTEXT>R  RDI RAX MOVQ DROP  RCX RAX MOVQ DROP  RSI RAX MOVQ  REP MOVSB
        RAX RDI MOVQ  R>CONTEXT  RDI RAX MOVQ  DROP ;
\ TODO ^ Refactor

: INLINE  R> COUNT HERE MOVE ;
:! {  POSTPONE INLINE  HERE  1ALLOT ;
:! }  DUP 1+  HERE SWAP -  SWAP C! ;
\ ^ Hopefully these can be used later for metacompilation.
\ Right now they are of limited usefulness, since the kernel is committed to mostly pure subroutine-threaded code for simplicity.


: TEST  $ 4D TX  $ 1 $ 2 =  IF $ 49 TX ELSE $ 4A TX THEN CR ;
[ TEST ]



[ BYE ]

\ These are some source code fragments for words that I want to implement soon.
\ They are by no means complete or functional in their current form.

\ TODO Investigate using `[` to drive the terminal (i.e. as part of `QUIT`), allowing `]` to execute immediately.
\ TODO Figure out a good way to print '[ ' as a prompt (hinting that `]` does something).
\ TODO Add more error handling to `[`, namely printing unknown names with a question mark, skipping the line, and `QUIT`ting.

\ TODO Rewrite `{` and `}` to not forcefully exit the word they're in.

: *  RDX MUL  NIP ;
: #  $ 0 NAME  COUNT FOR  >R  $ A *  R@ C@ DIGIT +  R> 1+  NEXT DROP ;
: TX#  $ 0 >R  BEGIN  # 10 /MOD  R> 1+ >R  DUP 0= UNTIL  DROP
       R> 1- FOR  $ 30 + TX  NEXT ;

: REL8!  HERE OVER 1+ - SWAP C! ;
: PARSE,  HERE 1ALLOT  >R RX BEGIN DUP R@ <> WHILE C, RX REPEAT DROP
          HERE OVER 1+ - SWAP C! ;
: PARSE   HERE PARSE, THERE DROP ;

: CHAR  NAME 1+ C@ LITERAL ;
: S"  HERE POSTPONE AHEAD  CHAR " PARSE,  POSTPONE THEN  LITERAL ;
: ."  POSTPONE S" { COUNT TYPE } ;