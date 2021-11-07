DEF INT3  $ CC C,  EXIT
DEF INT3!  INT3  EXIT

DEF W, DOCOL  DUP C,  $  8 RSHIFT C,  EXIT
DEF D, DOCOL  DUP W,  $ 10 RSHIFT W,  EXIT
DEF  , DOCOL  DUP D,  $ 20 RSHIFT D,  EXIT

DEF RAX  $ 0  EXIT
DEF RCX  $ 1  EXIT
DEF RDX  $ 2  EXIT
DEF RBX  $ 3  EXIT
DEF RSP  $ 4  EXIT
DEF RBP  $ 5  EXIT
DEF RSI  $ 6  EXIT
DEF RDI  $ 7  EXIT

DEF REX.W, DOCOL  $ 48 C,  EXIT
DEF MODR/M, DOCOL  $ 3 LSHIFT + $ 3 LSHIFT + C,  EXIT

DEF MOV  REX.W,  $ 89 C,  $ 3 MODR/M,  EXIT
DEF INC  $ FF C, $ 0 $ 3 MODR/M,  EXIT
DEF DEC  $ FF C, $ 1 $ 3 MODR/M,  EXIT

DEF HERE   DOCOL  DUP  RAX RDI MOV  EXIT
DEF REL32, DOCOL  HERE $ 4 + - D,  EXIT
DEF REL8,  DOCOL  HERE $ 1 + - D,  EXIT

DEF MOV!  REX.W,  $ 89 C,  $ 0 MODR/M,  EXIT
DEF MOV@  REX.W,  $ 8B C,  $ 0 MODR/M,  EXIT
DEF MOV$  REX.W,  SWAP $ B8 + C,  ,  EXIT

DEF MOVC!  $ 88 C, $ 0 MODR/M,  EXIT
DEF MOVZX@  REX.W, $ B60F W, SWAP $ 0 MODR/M,  EXIT

DEF RAXXCHG  REX.W, $ 90 + C,  EXIT

DEF COMPILE DOCOL  $ E8 C, REL32,  EXIT
DEF CALL$  COMPILE EXIT
DEF CALL  $ FF C, $ 2 $ 3 MODR/M,  EXIT

DEF ADD   REX.W, $ 01 C, $ 3 MODR/M,  EXIT
DEF SUB   REX.W, $ 29 C, $ 3 MODR/M,  EXIT
DEF ADD$  REX.W, $ 81 C, SWAP $ 0 $ 3 MODR/M, D,  EXIT
DEF SUB$  REX.W, $ 81 C, SWAP $ 5 $ 3 MODR/M, D,  EXIT
DEF MUL   REX.W, $ F7 C, $ 4 $ 3 MODR/M,  EXIT
DEF DIV   REX.W, $ F7 C, $ 6 $ 3 MODR/M,  EXIT

DEF PUSH  $ 50 + C,  EXIT
DEF POP   $ 58 + C,  EXIT

DEF AND  REX.W, $ 21 C, $ 3 MODR/M,  EXIT
DEF  OR  REX.W, $ 09 C, $ 3 MODR/M,  EXIT
DEF XOR  REX.W, $ 31 C, $ 3 MODR/M,  EXIT
DEF NOT  REX.W, $ F7 C, $ 2 $ 3 MODR/M,  EXIT
DEF NEG  REX.W, $ F7 C, $ 3 $ 3 MODR/M,  EXIT

DEF JMP$  $ E9 C, REL32,  EXIT
DEF JMP   $ FF C, $ 4 $ 3 MODR/M,  EXIT
DEF JZ$   $ 840F W, REL32,  EXIT
DEF JNZ$  $ 850F W, REL32,  EXIT

DEF REP    $ F3 C,  EXIT
DEF REPE   $ F3 C,  EXIT
DEF CMPSB  $ A6 C,  EXIT
DEF MOVSB  $ A4 C,  EXIT
DEF STOSB  $ AA C,  EXIT


DEF POSTPONE  NAME FIND COMPILE EXIT

DEF BEGIN  HERE EXIT
DEF AGAIN  POSTPONE JMP$ EXIT

DEF EXECUTE  DOCOL  RBX RAX MOV  DROP  RBX JMP
DEF [  RDI PUSH  BEGIN NAME FIND EXECUTE AGAIN
DEF ]  POSTPONE EXIT  RBX POP  RDI POP  RDI JMP


DEF C@ DOCOL  RAX RAX MOVZX@  EXIT
DEF C! DOCOL  RAX RDX MOVC!  DROP DROP  EXIT

DEF 1+ DOCOL  RAX INC  EXIT
DEF 1- DOCOL  RAX DEC  EXIT

DEF COUNT DOCOL  1+ DUP 1- C@  EXIT

DEF >R DOCOL  RBX POP  RAX PUSH  RBX PUSH  DROP  EXIT
DEF R> DOCOL  DUP  RBX POP  RAX POP  RBX PUSH  EXIT
DEF RDROP DOCOL  RBX POP  RSP $ 8 ADD$  RBX PUSH  EXIT

DEF CONTEXT>R DOCOL  RBX POP   RCX PUSH RSI PUSH RDI PUSH  RBX PUSH  EXIT
DEF R>CONTEXT DOCOL  RBX POP   RDI POP  RSI POP  RCX POP   RBX PUSH  EXIT

DEF MOVE DOCOL  CONTEXT>R  RDI RAX MOV DROP  RCX RAX MOV DROP  RSI RAX MOV DROP  REP MOVSB  R>CONTEXT  EXIT

DEF INLINE DOCOL  R> DUP COUNT HERE MOVE EXIT
DEF {  POSTPONE INLINE  HERE  RDI INC  EXIT
DEF }  DUP 1+ HERE SWAP - SWAP C!  EXIT

DEF 1+ { RAX INC }

[ $ 4C 1+ BYE ]
