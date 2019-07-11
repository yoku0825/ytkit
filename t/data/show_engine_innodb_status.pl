package Ytkit::Test::SHOW_ENGINE_INNODB_STATUS;

$mysql50 = [
          {
            'Status' => '
=====================================
190708 11:49:25 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 18 seconds
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 201960, signal count 160833
Mutex spin waits 0, rounds 24340763, OS waits 81459
RW-shared spins 152853, OS waits 73723; RW-excl spins 54434, OS waits 30136
------------------------
LATEST DETECTED DEADLOCK
------------------------
190708 11:11:59
*** (1) TRANSACTION:
TRANSACTION 0 29557, ACTIVE 1 sec, process no 4356, OS thread id 140577570899712 inserting
mysql tables in use 1, locked 1
LOCK WAIT 11 lock struct(s), heap size 1216, undo log entries 4
MySQL thread id 52, query id 980387 localhost root update
INSERT INTO order_line (ol_o_id, ol_d_id, ol_w_id, ol_number, ol_i_id, ol_supply_w_id, ol_quantity, ol_amount, ol_dist_info) VALUES (3465, 1, 1, 1, 8187, 1, 5, 556.929077148438, \'ow2yP9CQZI7wmaYQqyAQ5xFr\')
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 21 page no 2501 n bits 176 index `PRIMARY` of table `tpcc/order_line` trx id 0 29557 lock_mode X locks gap before rec insert intention waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 82; asc  ;; 2: len 4; hex 80000001; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 000000001872; asc      r;; 5: len 7; hex 80000000390e20; asc     9  ;; 6: len 4; hex 80005259; asc   RY;; 7: len 2; hex 8001; asc   ;; 8: len 8; hex 8000125d03fc137f; asc    ]    ;; 9: len 1; hex 85; asc  ;; 10: len 3; hex 800000; asc    ;; 11: len 24; hex 454e4369536947784d6b43575274506570334c486778624a; asc ENCiSiGxMkCWRtPep3LHgxbJ;;

*** (2) TRANSACTION:
TRANSACTION 0 29392, ACTIVE 14 sec, process no 4356, OS thread id 140577570367232 starting index read, thread declared inside InnoDB 500
mysql tables in use 1, locked 1
1668 lock struct(s), heap size 194544
MySQL thread id 55, query id 980429 localhost root Sending data
SELECT COUNT(*) FROM warehouse FOR UPDATE
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 21 page no 2501 n bits 176 index `PRIMARY` of table `tpcc/order_line` trx id 0 29392 lock_mode X
Record lock, heap no 1 PHYSICAL RECORD: n_fields 1; compact format; info bits 0
 0: len 8; hex 73757072656d756d; asc supremum;;

Record lock, heap no 2 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 82; asc  ;; 2: len 4; hex 80000001; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 000000001872; asc      r;; 5: len 7; hex 80000000390e20; asc     9  ;; 6: len 4; hex 80005259; asc   RY;; 7: len 2; hex 8001; asc   ;; 8: len 8; hex 8000125d03fc137f; asc    ]    ;; 9: len 1; hex 85; asc  ;; 10: len 3; hex 800000; asc    ;; 11: len 24; hex 454e4369536947784d6b43575274506570334c486778624a; asc ENCiSiGxMkCWRtPep3LHgxbJ;;

Record lock, heap no 3 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d017e; asc     - ~;; 6: len 4; hex 8000b41b; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 822b63; asc  +c;; 11: len 24; hex 536d61474b544c6950717675587a5969364963707770486f; asc SmaGKTLiPqvuXzYi6IcpwpHo;;

Record lock, heap no 4 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d0191; asc     -  ;; 6: len 4; hex 8000bfd9; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 81bb1e; asc    ;; 11: len 24; hex 386b37616e34706557796f4e693148764b4d766251736c6f; asc 8k7an4peWyoNi1HvKMvbQslo;;

Record lock, heap no 5 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d01a4; asc     -  ;; 6: len 4; hex 8000cbf2; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 815e10; asc  ^ ;; 11: len 24; hex 47385137306d6b514c61626d577a4d553738677978465178; asc G8Q70mkQLabmWzMU78gyxFQx;;

Record lock, heap no 6 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 88; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d01b7; asc     -  ;; 6: len 4; hex 8000df85; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 80405e; asc  @^;; 11: len 24; hex 50393938725633346870374c4d775745426d4e485a326969; asc P998rV34hp7LMwWEBmNHZ2ii;;

Record lock, heap no 7 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 89; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d01ca; asc     -  ;; 6: len 4; hex 8000fe02; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 807625; asc  v%;; 11: len 24; hex 39704d3536586a5a4a744b484449787471567233576a334b; asc 9pM56XjZJtKHDIxtqVr3Wj3K;;

Record lock, heap no 8 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 8a; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d01dd; asc     -  ;; 6: len 4; hex 8000fefa; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 800253; asc   S;; 11: len 24; hex 4d765153433332494d6351744b396c377649556236307841; asc MvQSC32IMcQtK9l7vIUb60xA;;

Record lock, heap no 9 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 8b; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d01f0; asc     -  ;; 6: len 4; hex 800129ad; asc   ) ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 85; asc  ;; 10: len 3; hex 80ac3e; asc   >;; 11: len 24; hex 6d4f573141395a5a5946545131484e75344e4d584474674b; asc mOW1A9ZZYFTQ1HNu4NMXDtgK;;

Record lock, heap no 10 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 8c; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d0203; asc     -  ;; 6: len 4; hex 80013aa7; asc   : ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 83; asc  ;; 10: len 3; hex 80ff40; asc   @;; 11: len 24; hex 334e6b323752547671664a54536874706d314c337956666b; asc 3Nk27RTvqfJTShtpm1L3yVfk;;

Record lock, heap no 11 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 8d; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d0216; asc     -  ;; 6: len 4; hex 800177e1; asc   w ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 80b15d; asc   ];; 11: len 24; hex 56546f433442684c594e6139675a48764b5351596d474971; asc VToC4BhLYNa9gZHvKSQYmGIq;;

Record lock, heap no 12 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7e; asc    ~;; 3: len 1; hex 8e; asc  ;; 4: len 6; hex 000000006fd9; asc     o ;; 5: len 7; hex 800000002d0229; asc     - );; 6: len 4; hex 80017b80; asc   { ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 82b752; asc   R;; 11: len 24; hex 4536336d7474766978636256694879354c68447158347671; asc E63mttvixcbViHy5LhDqX4vq;;

Record lock, heap no 13 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7f; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 00000000700d; asc     p ;; 5: len 7; hex 80000000390132; asc     9 2;; 6: len 4; hex 800015a6; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 819229; asc   );; 11: len 24; hex 43656e68307337783378574475307335316c51715937374c; asc Cenh0s7x3xWDu0s51lQqY77L;;

Record lock, heap no 14 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7f; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 00000000700d; asc     p ;; 5: len 7; hex 80000000390145; asc     9 E;; 6: len 4; hex 80008041; asc    A;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 815810; asc  X ;; 11: len 24; hex 727036775046685145743654673937684730444761536446; asc rp6wPFhQEt6Tg97hG0DGaSdF;;

Record lock, heap no 15 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7f; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 00000000700d; asc     p ;; 5: len 7; hex 80000000390158; asc     9 X;; 6: len 4; hex 8000efc6; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 802011; asc    ;; 11: len 24; hex 756839626233744b576e3575646d35517847434f6c6c537a; asc uh9bb3tKWn5udm5QxGCOllSz;;

Record lock, heap no 16 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7f; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 00000000700d; asc     p ;; 5: len 7; hex 8000000039016b; asc     9 k;; 6: len 4; hex 800154e1; asc   T ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 80d323; asc   #;; 11: len 24; hex 4e7335754d493633736c484f387543397a73755a73546350; asc Ns5uMI63slHO8uC9zsuZsTcP;;

Record lock, heap no 17 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d7f; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 00000000700d; asc     p ;; 5: len 7; hex 8000000039017e; asc     9 ~;; 6: len 4; hex 80016007; asc   ` ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 808034; asc   4;; 11: len 24; hex 4972426b526b426e41394c5737414d6743314d7674417467; asc IrBkRkBnA9LW7AMgC1MvtAtg;;

Record lock, heap no 18 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d80; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 000000007019; asc     p ;; 5: len 7; hex 80000000390132; asc     9 2;; 6: len 4; hex 80002e82; asc   . ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 80072b; asc   +;; 11: len 24; hex 5765594733593730674963614d526274356c533756596c30; asc WeYG3Y70gIcaMRbt5lS7VYl0;;

Record lock, heap no 19 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d80; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 000000007019; asc     p ;; 5: len 7; hex 80000000390145; asc     9 E;; 6: len 4; hex 80005d21; asc   ]!;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 804a56; asc  JV;; 11: len 24; hex 64594f63686e4964747a75716c6177456834554c68415a43; asc dYOchnIdtzuqlawEh4ULhAZC;;

Record lock, heap no 20 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d80; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 000000007019; asc     p ;; 5: len 7; hex 80000000390158; asc     9 X;; 6: len 4; hex 80014f81; asc   O ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 80c04c; asc   L;; 11: len 24; hex 73567668674a7451516330636963416c6d6f4568776f7651; asc sVvhgJtQQc0cicAlmoEhwovQ;;

Record lock, heap no 21 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d80; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 000000007019; asc     p ;; 5: len 7; hex 8000000039016b; asc     9 k;; 6: len 4; hex 800159e0; asc   Y ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 81795b; asc  y[;; 11: len 24; hex 63455a614137653579366477644970616252365677326c42; asc cEZaA7e5y6dwdIpabR6Vw2lB;;

Record lock, heap no 22 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d80; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 000000007019; asc     p ;; 5: len 7; hex 8000000039017e; asc     9 ~;; 6: len 4; hex 80016e66; asc   nf;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 81f439; asc   9;; 11: len 24; hex 734e6958784c533864346967556a6a4436616177556e7a30; asc sNiXxLS8d4igUjjD6aawUnz0;;

Record lock, heap no 23 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d80; asc     ;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 000000007019; asc     p ;; 5: len 7; hex 80000000390191; asc     9  ;; 6: len 4; hex 80017fe1; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 81c309; asc    ;; 11: len 24; hex 564a73644577725a56655766564f7a5a63426d5550684950; asc VJsdEwrZVeWfVOzZcBmUPhIP;;

Record lock, heap no 24 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d80; asc     ;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 000000007019; asc     p ;; 5: len 7; hex 800000003901a4; asc     9  ;; 6: len 4; hex 80017ffe; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 81cd04; asc    ;; 11: len 24; hex 374e633341446236344e79426b4749794535753047533341; asc 7Nc3ADb64NyBkGIyE5u0GS3A;;

Record lock, heap no 25 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d81; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 0000000070a3; asc     p ;; 5: len 7; hex 80000000d80132; asc       2;; 6: len 4; hex 800076e7; asc   v ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 810b17; asc    ;; 11: len 24; hex 38376d777251483752734e686b52746d7136754b4679384b; asc 87mwrQH7RsNhkRtmq6uKFy8K;;

Record lock, heap no 26 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d81; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 0000000070a3; asc     p ;; 5: len 7; hex 80000000d80145; asc       E;; 6: len 4; hex 8000f607; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 82031b; asc    ;; 11: len 24; hex 784a724c374a617a786243774a4b46785356663844636a48; asc xJrL7JazxbCwJKFxSVf8DcjH;;

Record lock, heap no 27 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d81; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 0000000070a3; asc     p ;; 5: len 7; hex 80000000d80158; asc       X;; 6: len 4; hex 80010ff8; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 809a2a; asc   *;; 11: len 24; hex 30443971413139664d4d3876535a6d643879337054423149; asc 0D9qA19fMM8vSZmd8y3pTB1I;;

Record lock, heap no 28 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d81; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 0000000070a3; asc     p ;; 5: len 7; hex 80000000d8016b; asc       k;; 6: len 4; hex 80014e09; asc   N ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 80fd57; asc   W;; 11: len 24; hex 72746b685444614e4a52667458674c3761315344736d7059; asc rtkhTDaNJRftXgL7a1SDsmpY;;

Record lock, heap no 29 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d81; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 0000000070a3; asc     p ;; 5: len 7; hex 80000000d8017e; asc       ~;; 6: len 4; hex 800177fd; asc   w ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 815f3e; asc  _>;; 11: len 24; hex 696c655a617032564e7236546630714c6d34774f4d4f4537; asc ileZap2VNr6Tf0qLm4wOMOE7;;

Record lock, heap no 30 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d80132; asc       2;; 6: len 4; hex 80001a81; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 83; asc  ;; 10: len 3; hex 80e506; asc    ;; 11: len 24; hex 4c4d6679774c635542396d686c577a4a6b63356535446d77; asc LMfywLcUB9mhlWzJkc5e5Dmw;;

Record lock, heap no 31 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d80145; asc       E;; 6: len 4; hex 80004409; asc   D ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 81a124; asc   $;; 11: len 24; hex 68426973336171563731673443716f6a4d464948756a3739; asc hBis3aqV71g4CqojMFIHuj79;;

Record lock, heap no 32 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d80158; asc       X;; 6: len 4; hex 80008db7; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 82133d; asc   =;; 11: len 24; hex 637a455554755871415645526b6957594e4e304b64616e51; asc czEUTuXqAVERkiWYNN0KdanQ;;

Record lock, heap no 33 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d8016b; asc       k;; 6: len 4; hex 80009406; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 82a650; asc   P;; 11: len 24; hex 307259614a34416a62324558514879784b7242584c336376; asc 0rYaJ4Ajb2EXQHyxKrBXL3cv;;

Record lock, heap no 34 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d8017e; asc       ~;; 6: len 4; hex 8000af45; asc    E;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 85; asc  ;; 10: len 3; hex 80e721; asc   !;; 11: len 24; hex 7232584b4675695279376576376b6b7537515270384e7437; asc r2XKFuiRy7ev7kku7QRp8Nt7;;

Record lock, heap no 35 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d80191; asc        ;; 6: len 4; hex 8000bec2; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 83; asc  ;; 10: len 3; hex 80b750; asc   P;; 11: len 24; hex 4d567a6d564f4d746954416666504d46784a5646427a7677; asc MVzmVOMtiTAffPMFxJVFBzvw;;

Record lock, heap no 36 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d801a4; asc        ;; 6: len 4; hex 8000d9de; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 85; asc  ;; 10: len 3; hex 806f3a; asc  o:;; 11: len 24; hex 714d307a6b4450587179484b564271466132776e6a643230; asc qM0zkDPXqyHKVBqFa2wnjd20;;

Record lock, heap no 37 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 88; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d801b7; asc        ;; 6: len 4; hex 8000ef33; asc    3;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 80d45c; asc   \\;; 11: len 24; hex 4f75784e7a4b72625437493443447637313761764a777937; asc OuxNzKrbT7I4CDv717avJwy7;;

Record lock, heap no 38 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 89; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d801ca; asc        ;; 6: len 4; hex 80013a87; asc   : ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 810254; asc   T;; 11: len 24; hex 34696652315949376e6c3149797a45494d73655334646554; asc 4ifR1YI7nl1IyzEIMseS4deT;;

Record lock, heap no 39 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 8a; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d801dd; asc        ;; 6: len 4; hex 80015bd7; asc   [ ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 800a41; asc   A;; 11: len 24; hex 69473466434a4445596b725470535566734e396c65757264; asc iG4fCJDEYkrTpSUfsN9leurd;;

Record lock, heap no 40 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 8b; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d801f0; asc        ;; 6: len 4; hex 80016a5b; asc   j[;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 80b718; asc    ;; 11: len 24; hex 4f7a7653514148795353506d717568733253775454303247; asc OzvSQAHySSPmquhs2SwTT02G;;

Record lock, heap no 41 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 8c; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d80203; asc        ;; 6: len 4; hex 80016fd3; asc   o ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 81980d; asc    ;; 11: len 24; hex 61456977687a35627239766d61626a63534844303736484d; asc aEiwhz5br9vmabjcSHD076HM;;

Record lock, heap no 42 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 8d; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d80216; asc        ;; 6: len 4; hex 80017406; asc   t ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 85; asc  ;; 10: len 3; hex 810253; asc   S;; 11: len 24; hex 723242446e4a4e70784353596a784862355670746244666c; asc r2BDnJNpxCSYjxHb5VptbDfl;;

Record lock, heap no 43 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d82; asc     ;; 3: len 1; hex 8e; asc  ;; 4: len 6; hex 0000000070a7; asc     p ;; 5: len 7; hex 80000000d80229; asc       );; 6: len 4; hex 8001800a; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 83; asc  ;; 10: len 3; hex 804e34; asc  N4;; 11: len 24; hex 4e46395841597042754452506f614f4733696f784e4e4864; asc NF9XAYpBuDRPoaOG3ioxNNHd;;

Record lock, heap no 44 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d0132; asc     - 2;; 6: len 4; hex 80005f84; asc   _ ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 81d158; asc   X;; 11: len 24; hex 59376579546a46696e416c4c4e5354305a44716d6c716453; asc Y7eyTjFinAlLNST0ZDqmlqdS;;

Record lock, heap no 45 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d0145; asc     - E;; 6: len 4; hex 80007730; asc   w0;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 81ec2c; asc   ,;; 11: len 24; hex 7a516b3834354938474a7873436a4c4977467039355a4f46; asc zQk845I8GJxsCjLIwFp95ZOF;;

Record lock, heap no 46 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d0158; asc     - X;; 6: len 4; hex 800077be; asc   w ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 80a535; asc   5;; 11: len 24; hex 3632713430754a573354476f41586f6768634a4a4474784b; asc 62q40uJW3TGoAXoghcJJDtxK;;

Record lock, heap no 47 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d016b; asc     - k;; 6: len 4; hex 80007ff9; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 82de5d; asc   ];; 11: len 24; hex 4646466e6970676d4b7468556b5a675065474c6235423436; asc FFFnipgmKthUkZgPeGLb5B46;;

Record lock, heap no 48 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d017e; asc     - ~;; 6: len 4; hex 800087e6; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 816462; asc  db;; 11: len 24; hex 7362636b4951455763444b616773494a63503731486d7664; asc sbckIQEWcDKagsIJcP71Hmvd;;

Record lock, heap no 49 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d0191; asc     -  ;; 6: len 4; hex 80009b01; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 83012d; asc   -;; 11: len 24; hex 736c396c63394979755071536c51564e634c6c69386e5335; asc sl9lc9IyuPqSlQVNcLli8nS5;;

Record lock, heap no 50 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d01a4; asc     -  ;; 6: len 4; hex 8000b2a0; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 811d30; asc   0;; 11: len 24; hex 4e77617039704f33514d793357674a635433706f72305271; asc Nwap9pO3QMy3WgJcT3por0Rq;;

Record lock, heap no 51 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 88; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d01b7; asc     -  ;; 6: len 4; hex 8000de05; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 80473a; asc  G:;; 11: len 24; hex 34395a4e526d746b6b3256597939566d6276674a54723959; asc 49ZNRmtkk2VYy9VmbvgJTr9Y;;

Record lock, heap no 52 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 89; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d01ca; asc     -  ;; 6: len 4; hex 8000fc07; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 81c043; asc   C;; 11: len 24; hex 6f6c38516e6577626c4a73496b685a74425a755369596b75; asc ol8QnewblJsIkhZtBZuSiYku;;

Record lock, heap no 53 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 8a; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d01dd; asc     -  ;; 6: len 4; hex 800113ef; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 82cf15; asc    ;; 11: len 24; hex 477654414c6e5874456e67734a444662365268735130766d; asc GvTALnXtEngsJDFb6RhsQ0vm;;

Record lock, heap no 54 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 8b; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d01f0; asc     -  ;; 6: len 4; hex 80015fed; asc   _ ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 801042; asc   B;; 11: len 24; hex 737265304c7757476764516775323476614d4e515732686c; asc sre0LwWGgdQgu24vaMNQW2hl;;

Record lock, heap no 55 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 8c; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d0203; asc     -  ;; 6: len 4; hex 80016006; asc   ` ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 806a1a; asc  j ;; 11: len 24; hex 314e666a79677063644a7246466e43476c46497263336658; asc 1NfjygpcdJrFFnCGlFIrc3fX;;

Record lock, heap no 56 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d83; asc     ;; 3: len 1; hex 8d; asc  ;; 4: len 6; hex 0000000070ff; asc     p ;; 5: len 7; hex 800000002d0216; asc     -  ;; 6: len 4; hex 80016007; asc   ` ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 81074b; asc   K;; 11: len 24; hex 4972426b526b426e41394c5737414d6743314d7674417467; asc IrBkRkBnA9LW7AMgC1MvtAtg;;

Record lock, heap no 57 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d84; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 0000000071ef; asc     q ;; 5: len 7; hex 80000000d80132; asc       2;; 6: len 4; hex 80001b03; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 80d55c; asc   \\;; 11: len 24; hex 59636a413174384f444b6f434752424f4a65564f68783761; asc YcjA1t8ODKoCGRBOJeVOhx7a;;

Record lock, heap no 58 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d84; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 0000000071ef; asc     q ;; 5: len 7; hex 80000000d80145; asc       E;; 6: len 4; hex 800055b8; asc   U ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 806c32; asc  l2;; 11: len 24; hex 6934586e6a39527a4b4149694b7655533678396944526934; asc i4Xnj9RzKAIiKvUS6x9iDRi4;;

Record lock, heap no 59 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d84; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 0000000071ef; asc     q ;; 5: len 7; hex 80000000d80158; asc       X;; 6: len 4; hex 80005ede; asc   ^ ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 809650; asc   P;; 11: len 24; hex 484c4c7a52745a724475614663307a6b7349386179566778; asc HLLzRtZrDuaFc0zksI8ayVgx;;

Record lock, heap no 60 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d84; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 0000000071ef; asc     q ;; 5: len 7; hex 80000000d8016b; asc       k;; 6: len 4; hex 8000bedb; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 804c1e; asc  L ;; 11: len 24; hex 764a4d747a66674e3531783649664d42344f7a4644753878; asc vJMtzfgN51x6IfMB4OzFDu8x;;

Record lock, heap no 61 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d84; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 0000000071ef; asc     q ;; 5: len 7; hex 80000000d8017e; asc       ~;; 6: len 4; hex 8000d6d9; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 80483a; asc  H:;; 11: len 24; hex 32544c3754476b70475774645978665538374563326c6965; asc 2TL7TGkpGWtdYxfU87Ec2lie;;

Record lock, heap no 62 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d84; asc     ;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 0000000071ef; asc     q ;; 5: len 7; hex 80000000d80191; asc        ;; 6: len 4; hex 80011c64; asc    d;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 80bd21; asc   !;; 11: len 24; hex 59594452395451657374793572326c6337524a31544a7441; asc YYDR9TQesty5r2lc7RJ1TJtA;;

Record lock, heap no 63 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d84; asc     ;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 0000000071ef; asc     q ;; 5: len 7; hex 80000000d801a4; asc        ;; 6: len 4; hex 80015a04; asc   Z ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 812154; asc  !T;; 11: len 24; hex 457a51616b464a797369436156595135615a594c72503572; asc EzQakFJysiCaVYQ5aZYLrP5r;;

Record lock, heap no 64 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d0132; asc     - 2;; 6: len 4; hex 80000ec2; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 805100; asc  Q ;; 11: len 24; hex 5167635837474f564b73486b4337317a54476144464e3068; asc QgcX7GOVKsHkC71zTGaDFN0h;;

Record lock, heap no 65 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d0145; asc     - E;; 6: len 4; hex 800072b0; asc   r ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 801558; asc   X;; 11: len 24; hex 484b714d6d74396d58384453335269773842356c5a316a4f; asc HKqMmt9mX8DS3Riw8B5lZ1jO;;

Record lock, heap no 66 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d0158; asc     - X;; 6: len 4; hex 80007d73; asc   }s;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 818f09; asc    ;; 11: len 24; hex 766c444b4937394971694b6655615254503573754b4d426f; asc vlDKI79IqiKfUaRTP5suKMBo;;

Record lock, heap no 67 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d016b; asc     - k;; 6: len 4; hex 80007ef6; asc   ~ ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 80510a; asc  Q ;; 11: len 24; hex 53574e3231735150746e59556c444138365863433439435a; asc SWN21sQPtnYUlDA86XcC49CZ;;

Record lock, heap no 68 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d017e; asc     - ~;; 6: len 4; hex 800097c2; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 80591e; asc  Y ;; 11: len 24; hex 316130536e63393138374575724272636b6d7852537a5273; asc 1a0Snc9187EurBrckmxRSzRs;;

Record lock, heap no 69 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d0191; asc     -  ;; 6: len 4; hex 80009fe0; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 80fd26; asc   &;; 11: len 24; hex 6457354473747969356636463137576f7961324676447961; asc dW5Dstyi5f6F17Woya2FvDya;;

Record lock, heap no 70 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d01a4; asc     -  ;; 6: len 4; hex 8000c5bc; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 803b3c; asc  ;<;; 11: len 24; hex 59597064523949456278714c586554494f6f5874555a706f; asc YYpdR9IEbxqLXeTIOoXtUZpo;;

Record lock, heap no 71 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 88; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d01b7; asc     -  ;; 6: len 4; hex 8000deff; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 813d10; asc  = ;; 11: len 24; hex 49543171416a72524e766f356a5077305244424a664a6731; asc IT1qAjrRNvo5jPw0RDBJfJg1;;

Record lock, heap no 72 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 89; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d01ca; asc     -  ;; 6: len 4; hex 80011785; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 82431f; asc  C ;; 11: len 24; hex 7463734f45777067656f4a7432695742364235427070684b; asc tcsOEwpgeoJt2iWB6B5BpphK;;

Record lock, heap no 73 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 8a; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d01dd; asc     -  ;; 6: len 4; hex 800117c3; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 814233; asc  B3;; 11: len 24; hex 5439745879495945524759724e41714d544a586776445333; asc T9tXyIYERGYrNAqMTJXgvDS3;;

Record lock, heap no 74 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 8b; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d01f0; asc     -  ;; 6: len 4; hex 80011a03; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 810912; asc    ;; 11: len 24; hex 746a347663676266646b366238574b4549724f4970596f6f; asc tj4vcgbfdk6b8WKEIrOIpYoo;;

Record lock, heap no 75 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 8c; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d0203; asc     -  ;; 6: len 4; hex 80011aec; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 81c32d; asc   -;; 11: len 24; hex 6d56714a767930423941375a58724d317250646339564e61; asc mVqJvy0B9A7ZXrM1rPdc9VNa;;

Record lock, heap no 76 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 8d; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d0216; asc     -  ;; 6: len 4; hex 80011ec7; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 80200f; asc    ;; 11: len 24; hex 526d64746d536f7138496c35616644326753734e785a5179; asc RmdtmSoq8Il5afD2gSsNxZQy;;

Record lock, heap no 77 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d85; asc     ;; 3: len 1; hex 8e; asc  ;; 4: len 6; hex 000000007235; asc     r5;; 5: len 7; hex 800000002d0229; asc     - );; 6: len 4; hex 80015ec9; asc   ^ ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 81e25e; asc   ^;; 11: len 24; hex 4d4b536e44655970764e4233424c38443174557034315258; asc MKSnDeYpvNB3BL8D1tUp41RX;;

Record lock, heap no 78 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d0132; asc     - 2;; 6: len 4; hex 800001e4; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 81a805; asc    ;; 11: len 24; hex 327570376448586b4667304d5163436d7754644e57444452; asc 2up7dHXkFg0MQcCmwTdNWDDR;;

Record lock, heap no 79 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d0145; asc     - E;; 6: len 4; hex 800017b9; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 83; asc  ;; 10: len 3; hex 804112; asc  A ;; 11: len 24; hex 4a504338387768415948717a6c6b5252644c506563484e65; asc JPC88whAYHqzlkRRdLPecHNe;;

Record lock, heap no 80 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d0158; asc     - X;; 6: len 4; hex 80001806; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 80992a; asc   *;; 11: len 24; hex 776f746f496d636f4442465748496f625a3664566b726241; asc wotoImcoDBFWHIobZ6dVkrbA;;

Record lock, heap no 81 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d016b; asc     - k;; 6: len 4; hex 80002751; asc   \'Q;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 801232; asc   2;; 11: len 24; hex 624c3959514a416c4f366a3679684b417753514f31574d31; asc bL9YQJAlO6j6yhKAwSQO1WM1;;

Record lock, heap no 82 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d017e; asc     - ~;; 6: len 4; hex 80003da1; asc   = ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 80cb3e; asc   >;; 11: len 24; hex 41415272346269785a384a4f4c64526863766a54615a4132; asc AARr4bixZ8JOLdRhcvjTaZA2;;

Record lock, heap no 83 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d0191; asc     -  ;; 6: len 4; hex 80004a4e; asc   JN;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 83; asc  ;; 10: len 3; hex 80f933; asc   3;; 11: len 24; hex 36554c3147703479654b6b444259596a436668376e505176; asc 6UL1Gp4yeKkDBYYjCfh7nPQv;;

Record lock, heap no 84 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d01a4; asc     -  ;; 6: len 4; hex 8000b682; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 811616; asc    ;; 11: len 24; hex 6b4a57493479765049644d453137464d5778417047623372; asc kJWI4yvPIdME17FMWxApGb3r;;

Record lock, heap no 85 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 88; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d01b7; asc     -  ;; 6: len 4; hex 8000baae; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 89; asc  ;; 10: len 3; hex 802d33; asc  -3;; 11: len 24; hex 6d6c3671554e676e636b6c5838444f47596c544a4a425058; asc ml6qUNgncklX8DOGYlTJJBPX;;

Record lock, heap no 86 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 89; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d01ca; asc     -  ;; 6: len 4; hex 8000bd06; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 85; asc  ;; 10: len 3; hex 818a35; asc   5;; 11: len 24; hex 5a30706a563568715a6864376345665a4355495a346d666e; asc Z0pjV5hqZhd7cEfZCUIZ4mfn;;

Record lock, heap no 87 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 8a; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d01dd; asc     -  ;; 6: len 4; hex 800136f5; asc   6 ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 802c16; asc  , ;; 11: len 24; hex 63746a5165486f4f78536855524e713761533441714a6945; asc ctjQeHoOxShURNq7aS4AqJiE;;

Record lock, heap no 88 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 8b; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d01f0; asc     -  ;; 6: len 4; hex 80013ebd; asc   > ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 85; asc  ;; 10: len 3; hex 809f30; asc   0;; 11: len 24; hex 3451754d59484c37417942564b4b4d64684b32394b4a6a54; asc 4QuMYHL7AyBVKKMdhK29KJjT;;

Record lock, heap no 89 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 8c; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d0203; asc     -  ;; 6: len 4; hex 80013f89; asc   ? ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 8a; asc  ;; 10: len 3; hex 827204; asc  r ;; 11: len 24; hex 7367336a6257494c50726c483634374236735742714c494c; asc sg3jbWILPrlH647B6sWBqLIL;;

Record lock, heap no 90 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 8d; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d0216; asc     -  ;; 6: len 4; hex 80014bbd; asc   K ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 802214; asc  " ;; 11: len 24; hex 4551584b6a4d38313277434a5533735364327a5862647572; asc EQXKjM812wCJU3sSd2zXbdur;;

Record lock, heap no 91 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d86; asc     ;; 3: len 1; hex 8e; asc  ;; 4: len 6; hex 000000007237; asc     r7;; 5: len 7; hex 800000002d0229; asc     - );; 6: len 4; hex 80016f83; asc   o ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 82100b; asc    ;; 11: len 24; hex 5638654336775448376e6c4e3063556e59574375345a7072; asc V8eC6wTH7nlN0cUnYWCu4Zpr;;

Record lock, heap no 92 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db0132; asc       2;; 6: len 4; hex 80003fcd; asc   ? ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 86; asc  ;; 10: len 3; hex 81475e; asc  G^;; 11: len 24; hex 38313472323338384e5730447551304d725a453135367346; asc 814r2388NW0DuQ0MrZE156sF;;

Record lock, heap no 93 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db0145; asc       E;; 6: len 4; hex 8000ce20; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 80155c; asc   \\;; 11: len 24; hex 5931457761526a77524a6b563679756b5357665757614c50; asc Y1EwaRjwRJkV6yukSWfWWaLP;;

Record lock, heap no 94 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db0158; asc       X;; 6: len 4; hex 8000df57; asc    W;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 814015; asc  @ ;; 11: len 24; hex 4b62475a6d68484b5973766936694655374e736e5974574c; asc KbGZmhHKYsvi6iFU7NsnYtWL;;

Record lock, heap no 95 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db016b; asc       k;; 6: len 4; hex 8000eedb; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 82aa46; asc   F;; 11: len 24; hex 50616d4e36675168416b4d584f46474636396e70794f524b; asc PamN6gQhAkMXOFGF69npyORK;;

Record lock, heap no 96 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db017e; asc       ~;; 6: len 4; hex 8000f53a; asc    :;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 806f06; asc  o ;; 11: len 24; hex 5a6e635975634b48326739426378446b4e644f5676627437; asc ZncYucKH2g9BcxDkNdOVvbt7;;

Record lock, heap no 97 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db0191; asc        ;; 6: len 4; hex 80012006; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 802f10; asc  / ;; 11: len 24; hex 4d5159576361384277443175437a4d424975315a54723856; asc MQYWca8BwD1uCzMBIu1ZTr8V;;

Record lock, heap no 98 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db01a4; asc        ;; 6: len 4; hex 80012006; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 805e20; asc  ^ ;; 11: len 24; hex 4d5159576361384277443175437a4d424975315a54723856; asc MQYWca8BwD1uCzMBIu1ZTr8V;;

Record lock, heap no 99 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 88; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db01b7; asc        ;; 6: len 4; hex 80013d3d; asc   ==;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 80f532; asc   2;; 11: len 24; hex 6b585259766764517843584d356d5a77774f774c4d383277; asc kXRYvgdQxCXM5mZwwOwLM82w;;

Record lock, heap no 100 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d87; asc     ;; 3: len 1; hex 89; asc  ;; 4: len 6; hex 000000007277; asc     rw;; 5: len 7; hex 80000000db01ca; asc        ;; 6: len 4; hex 80015bbc; asc   [ ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 88; asc  ;; 10: len 3; hex 80cb00; asc    ;; 11: len 24; hex 59356f4170725a4f32326357744769434542724f35494862; asc Y5oAprZO22cWtGiCEBrO5IHb;;

Record lock, heap no 101 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d88; asc     ;; 3: len 1; hex 81; asc  ;; 4: len 6; hex 000000007297; asc     r ;; 5: len 7; hex 800000002d0132; asc     - 2;; 6: len 4; hex 800017fe; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 85; asc  ;; 10: len 3; hex 801333; asc   3;; 11: len 24; hex 4449694a3357423853796f79433732694e325134354e6b32; asc DIiJ3WB8SyoyC72iN2Q45Nk2;;

Record lock, heap no 102 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d88; asc     ;; 3: len 1; hex 82; asc  ;; 4: len 6; hex 000000007297; asc     r ;; 5: len 7; hex 800000002d0145; asc     - E;; 6: len 4; hex 80003b82; asc   ; ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 82; asc  ;; 10: len 3; hex 80395f; asc  9_;; 11: len 24; hex 7563495a47484e336e4c666633376b68707a656a44566f39; asc ucIZGHN3nLff37khpzejDVo9;;

Record lock, heap no 103 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d88; asc     ;; 3: len 1; hex 83; asc  ;; 4: len 6; hex 000000007297; asc     r ;; 5: len 7; hex 800000002d0158; asc     - X;; 6: len 4; hex 800055ca; asc   U ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 819a29; asc   );; 11: len 24; hex 346766395243346b78554a64576555423172514e56756470; asc 4gf9RC4kxUJdWeUB1rQNVudp;;

Record lock, heap no 104 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d88; asc     ;; 3: len 1; hex 84; asc  ;; 4: len 6; hex 000000007297; asc     r ;; 5: len 7; hex 800000002d016b; asc     - k;; 6: len 4; hex 80006c01; asc   l ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 809754; asc   T;; 11: len 24; hex 726934347a56583671386c666d37567364534f6144457272; asc ri44zVX6q8lfm7VsdSOaDErr;;

Record lock, heap no 105 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d88; asc     ;; 3: len 1; hex 85; asc  ;; 4: len 6; hex 000000007297; asc     r ;; 5: len 7; hex 800000002d017e; asc     - ~;; 6: len 4; hex 8000ddb7; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 85; asc  ;; 10: len 3; hex 807e30; asc  ~0;; 11: len 24; hex 384863567736545a536b3077495668786c6c534237433932; asc 8HcVw6TZSk0wIVhxllSB7C92;;

Record lock, heap no 106 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d88; asc     ;; 3: len 1; hex 86; asc  ;; 4: len 6; hex 000000007297; asc     r ;; 5: len 7; hex 800000002d0191; asc     -  ;; 6: len 4; hex 8000ee65; asc    e;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 84; asc  ;; 10: len 3; hex 809744; asc   D;; 11: len 24; hex 496f774a67677830577670307150326a633069766a4a786e; asc IowJggx0Wvp0qP2jc0ivjJxn;;

Record lock, heap no 107 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d88; asc     ;; 3: len 1; hex 87; asc  ;; 4: len 6; hex 000000007297; asc     r ;; 5: len 7; hex 800000002d01a4; asc     -  ;; 6: len 4; hex 8000f4f0; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 87; asc  ;; 10: len 3; hex 807c3d; asc  |=;; 11: len 24; hex 345975725a6461326c305243795048695665317444726345; asc 4YurZda2l0RCyPHiVe1tDrcE;;

Record lock, heap no 108 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 1; hex 81; asc  ;; 2: len 4; hex 80000d88; asc     ;; 3: len 1; hex 88; asc  ;; 4: len 6; hex 000000007297; asc     r ;; 5: len 7; hex 800000002d01b7; asc     -  ;; 6: len 4; hex 8000fe91; asc     ;; 7: len 2; hex 8001; asc   ;; 8: SQL NULL; 9: len 1; hex 81; asc  ;; 10: len 3; hex 802a3e; asc  *>;; 11: len 24; hex 6f6d494c766d7939324273646c384566515a665756644550; asc omILvmy92Bsdl8EfQZfWVdEP;;

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 1 page no 3 n bits 72 index `PRIMARY` of table `tpcc/warehouse` trx id 0 29392 lock_mode X waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;; 1: len 6; hex 00000000737d; asc     s};; 2: len 7; hex 00000002e604b2; asc        ;; 3: len 8; hex 4d656567376c4630; asc Meeg7lF0;; 4: len 19; hex 30566c4c314663556b7665704854625136634a; asc 0VlL1FcUkvepHTbQ6cJ;; 5: len 10; hex 386f626b514772395472; asc 8obkQGr9Tr;; 6: len 10; hex 544b666d4c754f6f6349; asc TKfmLuOocI;; 7: len 2; hex 5158; asc QX;; 8: len 9; hex 353135373930353135; asc 515790515;; 9: len 2; hex 800b; asc   ;; 10: len 6; hex 8000ae661700; asc    f  ;;

*** WE ROLL BACK TRANSACTION (2)
------------
TRANSACTIONS
------------
Trx id counter 0 376765
Purge done for trx\'s n:o < 0 376765 undo n:o < 0 0
History list length 12
Total number of lock structs in row lock hash table 0
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 0 0, not started, process no 4356, OS thread id 140577571432192
MySQL thread id 62, query id 5700267 localhost root
SHOW ENGINE INNODB STATUS
--------
FILE I/O
--------
I/O thread 0 state: waiting for i/o request (insert buffer thread)
I/O thread 1 state: waiting for i/o request (log thread)
I/O thread 2 state: waiting for i/o request (read thread)
I/O thread 3 state: waiting for i/o request (write thread)
Pending normal aio reads: 0, aio writes: 0,
 ibuf aio reads: 0, log i/o\'s: 0, sync i/o\'s: 0
Pending flushes (fsync) log: 0; buffer pool: 0
3700407 OS file reads, 2154945 OS file writes, 508803 OS fsyncs
0.00 reads/s, 0 avg bytes/read, 0.00 writes/s, 0.00 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 398, seg size 400,
982186 inserts, 982186 merged recs, 42242 merges
Hash table size 17393, used cells 1336, node heap has 3 buffer(s)
0.00 hash searches/s, 0.00 non-hash searches/s
---
LOG
---
Log sequence number 0 928852589
Log flushed up to   0 928852589
Last checkpoint at  0 928852589
0 pending log writes, 0 pending chkp writes
369790 log i/o\'s done, 0.00 log i/o\'s/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total memory allocated 21415258; in additional pool allocated 1035520
Buffer pool size   512
Free buffers       0
Database pages     509
Modified db pages  0
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages read 3960154, created 36699, written 2004943
0.00 reads/s, 0.00 creates/s, 0.00 writes/s
No buffer pool page gets since the last printout
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
1 read views open inside InnoDB
Main thread process no. 4356, id 140577450465024, state: waiting for server activity
Number of rows inserted 2798410, updated 1559617, deleted 59131, read 11690789
0.00 inserts/s, 0.00 updates/s, 0.00 deletes/s, 0.00 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
'
          }
        ];

### mysql51_plugin;
$mysql51_plugin = [
          {
            'Type' => 'InnoDB',
            'Name' => '',
            'Status' => '
=====================================
190708 14:20:28 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 8 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 394 1_second, 100 sleeps, 39 10_second, 4 background, 4 flush
srv_master_thread log flush and writes: 116
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 3617, signal count 7442
Mutex spin waits 47994, rounds 166201, OS waits 1072
RW-shared spins 1978, OS waits 743; RW-excl spins 704, OS waits 1625
Spin rounds per wait: 3.46 mutex, 21.58 RW-shared, 107.93 RW-excl
------------------------
LATEST DETECTED DEADLOCK
------------------------
190708 14:20:03
*** (1) TRANSACTION:
TRANSACTION 5DCD, ACTIVE 0 sec, process no 14562, OS thread id 139954760021760 starting index read
mysql tables in use 1, locked 1
LOCK WAIT 17 lock struct(s), heap size 3112, 10 row lock(s), undo log entries 18
MySQL thread id 16, query id 916020 localhost root statistics
SELECT s_quantity, s_data, s_dist_01, s_dist_02, s_dist_03, s_dist_04, s_dist_05, s_dist_06, s_dist_07, s_dist_08, s_dist_09, s_dist_10 FROM stock WHERE s_i_id = 40327 AND s_w_id = 1 FOR UPDATE
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 24 page no 971 n bits 120 index `PRIMARY` of table `tpcc`.`stock` trx id 5DCD lock_mode X locks rec but not gap waiting
Record lock, heap no 48 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80009d87; asc     ;;
 2: len 6; hex 000000002b4d; asc     +M;;
 3: len 7; hex 00000000351e2a; asc     5 *;;
 4: len 2; hex 8045; asc  E;;
 5: len 24; hex 314e66466177317a4e4b4569774b427968356b6533787943; asc 1NfFaw1zNKEiwKByh5ke3xyC;;
 6: len 24; hex 587a306c716d6d44527a6c4e796b6948774f444858427764; asc Xz0lqmmDRzlNykiHwODHXBwd;;
 7: len 24; hex 6265725a726d34716e6e655858707957614a544a326b4451; asc berZrm4qnneXXpyWaJTJ2kDQ;;
 8: len 24; hex 557936505a307942725632655871524c55777148754c7342; asc Uy6PZ0yBrV2eXqRLUwqHuLsB;;
 9: len 24; hex 3942594d6156705762453563434754684835433755586151; asc 9BYMaVpWbE5cCGThH5C7UXaQ;;
 10: len 24; hex 724b686855566f6633424657306c35436f664f3339334b43; asc rKhhUVof3BFW0l5CofO393KC;;
 11: len 24; hex 50686c7a373770516d5775484c584b556c6f555574674a5a; asc Phlz77pQmWuHLXKUloUUtgJZ;;
 12: len 24; hex 4b6733657347335a7a3168347135714b7a37645550374644; asc Kg3esG3Zz1h4q5qKz7dUP7FD;;
 13: len 24; hex 6b37463165464c4b477a4358306b557a505a705550415256; asc k7F1eFLKGzCX0kUzPZpUPARV;;
 14: len 24; hex 767576393655744269737076443743414868413142414f69; asc vuv96UtBispvD7CAHhA1BAOi;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 73383548627242546b4b5a4542697533586f47633051756659747167495a; asc s85HbrBTkKZEBiu3XoGc0QufYtqgIZ; (total 49 bytes);

*** (2) TRANSACTION:
TRANSACTION 5D9A, ACTIVE 0 sec, process no 14562, OS thread id 139954760554240 fetching rows
mysql tables in use 2, locked 2
2185 lock struct(s), heap size 211384, 41395 row lock(s), undo log entries 7432
MySQL thread id 25, query id 915126 localhost root Sending data
INSERT LOW_PRIORITY IGNORE INTO `tpcc`.`_order_line_new` (`ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info`) SELECT `ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info` FROM `tpcc`.`order_line` FORCE INDEX(`PRIMARY`) WHERE ((`ol_w_id` > \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` > \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` > \'2567\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'2567\' AND `ol_number` >= \'12\')) AND ((`ol_w_id` < \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` < \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` < \'3348\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'3348\' AND `ol_number` <= \'8\')) LOCK IN SHARE MODE /*pt-online-schema-change 14773 copy nibble*/
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 24 page no 971 n bits 120 index `PRIMARY` of table `tpcc`.`stock` trx id 5D9A lock mode S locks rec but not gap
Record lock, heap no 7 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80009d5e; asc    ^;;
 2: len 6; hex 000000004b17; asc     K ;;
 3: len 7; hex 00000000c80cff; asc        ;;
 4: len 2; hex 8023; asc  #;;
 5: len 24; hex 6367364b415a704e71667746313735707062345a57513865; asc cg6KAZpNqfwF175ppb4ZWQ8e;;
 6: len 24; hex 4b744579557661417a73495966654d4a61624b6665395547; asc KtEyUvaAzsIYfeMJabKfe9UG;;
 7: len 24; hex 326d62384f67524973506b6e78766d7042495470656d5047; asc 2mb8OgRIsPknxvmpBITpemPG;;
 8: len 24; hex 35754458385058757965486635585653484a504333434f4d; asc 5uDX8PXuyeHf5XVSHJPC3COM;;
 9: len 24; hex 4279506245546537663946326638304a4e644d75396f4251; asc ByPbETe7f9F2f80JNdMu9oBQ;;
 10: len 24; hex 4d544e696e31746d51557975363358474a5a76505a436d44; asc MTNin1tmQUyu63XGJZvPZCmD;;
 11: len 24; hex 674b49706b54424271747a726e6a474666384b6a66613045; asc gKIpkTBBqtzrnjGFf8Kjfa0E;;
 12: len 24; hex 506c643977397047526379756f416966375951716f655477; asc Pld9w9pGRcyuoAif7YQqoeTw;;
 13: len 24; hex 435a59436e7a5a576169546a566838386730757167587845; asc CZYCnzZWaiTjVh88g0uqgXxE;;
 14: len 24; hex 6c3063457761505436624533396c6470434b4c7453525853; asc l0cEwaPT6bE39ldpCKLtSRXS;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 4e3871494c6f314c4f474777646a324379354c6867427430556b53764973; asc N8qILo1LOGGwdj2Cy5LhgBt0UkSvIs; (total 33 bytes);

Record lock, heap no 27 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80009d72; asc    r;;
 2: len 6; hex 000000003932; asc     92;;
 3: len 7; hex 00000000d806a7; asc        ;;
 4: len 2; hex 801b; asc   ;;
 5: len 24; hex 36536f4e5a767870527146326d45383455646b364c71514e; asc 6SoNZvxpRqF2mE84Udk6LqQN;;
 6: len 24; hex 4d306e36414841633458397a5478514a4352334f58367141; asc M0n6AHAc4X9zTxQJCR3OX6qA;;
 7: len 24; hex 7754674c6f37666e756c7843755847526644736363426f33; asc wTgLo7fnulxCuXGRfDsccBo3;;
 8: len 24; hex 42614c316a3977416e487a75776d6e66687a5a43447a7251; asc BaL1j9wAnHzuwmnfhzZCDzrQ;;
 9: len 24; hex 543231473345526358514c674d545464534e584341427237; asc T21G3ERcXQLgMTTdSNXCABr7;;
 10: len 24; hex 344b68746a5a4c6a61626c6d304e4a4f677a6c39534d616e; asc 4KhtjZLjablm0NJOgzl9SMan;;
 11: len 24; hex 6d793365336c674d545a3532756d6154584d527364715963; asc my3e3lgMTZ52umaTXMRsdqYc;;
 12: len 24; hex 67347647706e326c6f6570614b42337345336b7962455576; asc g4vGpn2loepaKB3sE3kybEUv;;
 13: len 24; hex 4d59547441325a4379707a6a706c595561366d6a39657641; asc MYTtA2ZCypzjplYUa6mj9evA;;
 14: len 24; hex 726c624c674767436b5a4b6b365769745651694577436d32; asc rlbLgGgCkZKk6WitVQiEwCm2;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 5439624f4a304534625869714473596b43496f697a68424e514f4a61414a; asc T9bOJ0E4bXiqDsYkCIoizhBNQOJaAJ;;

Record lock, heap no 47 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80009d86; asc     ;;
 2: len 6; hex 0000000042dd; asc     B ;;
 3: len 7; hex 00000000d72ab6; asc      * ;;
 4: len 2; hex 805b; asc  [;;
 5: len 24; hex 776f305274734f59646b4c443730306b4c54465262446741; asc wo0RtsOYdkLD700kLTFRbDgA;;
 6: len 24; hex 686d576342685778687872584a4e3933674d42684b74326e; asc hmWcBhWxhxrXJN93gMBhKt2n;;
 7: len 24; hex 52504937586d6d4a474f5378735164704638366348384965; asc RPI7XmmJGOSxsQdpF86cH8Ie;;
 8: len 24; hex 787741786b484d375953654b457661624f56546f38483348; asc xwAxkHM7YSeKEvabOVTo8H3H;;
 9: len 24; hex 64575474416b7035746d70383975676257796e52594d6e32; asc dWTtAkp5tmp89ugbWynRYMn2;;
 10: len 24; hex 5a383361504f4275713534597537526577616c6f474b4b46; asc Z83aPOBuq54Yu7RewaloGKKF;;
 11: len 24; hex 6b6c53566e4735774a664a677044577547346d4e554f4934; asc klSVnG5wJfJgpDWuG4mNUOI4;;
 12: len 24; hex 344b55505861374a336334486679624a494638546a32686e; asc 4KUPXa7J3c4HfybJIF8Tj2hn;;
 13: len 24; hex 3546384c4a4950636c6d394a72514d555663375242516a51; asc 5F8LJIPclm9JrQMUVc7RBQjQ;;
 14: len 24; hex 42395973754b76415445546a6333534f446d456436673669; asc B9YsuKvATETjc3SODmEd6g6i;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 27; hex 597445464a6d4f6f726967696e616c4e776d7a30454c42795a6d35; asc YtEFJmOoriginalNwmz0ELByZm5;;

Record lock, heap no 48 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80009d87; asc     ;;
 2: len 6; hex 000000002b4d; asc     +M;;
 3: len 7; hex 00000000351e2a; asc     5 *;;
 4: len 2; hex 8045; asc  E;;
 5: len 24; hex 314e66466177317a4e4b4569774b427968356b6533787943; asc 1NfFaw1zNKEiwKByh5ke3xyC;;
 6: len 24; hex 587a306c716d6d44527a6c4e796b6948774f444858427764; asc Xz0lqmmDRzlNykiHwODHXBwd;;
 7: len 24; hex 6265725a726d34716e6e655858707957614a544a326b4451; asc berZrm4qnneXXpyWaJTJ2kDQ;;
 8: len 24; hex 557936505a307942725632655871524c55777148754c7342; asc Uy6PZ0yBrV2eXqRLUwqHuLsB;;
 9: len 24; hex 3942594d6156705762453563434754684835433755586151; asc 9BYMaVpWbE5cCGThH5C7UXaQ;;
 10: len 24; hex 724b686855566f6633424657306c35436f664f3339334b43; asc rKhhUVof3BFW0l5CofO393KC;;
 11: len 24; hex 50686c7a373770516d5775484c584b556c6f555574674a5a; asc Phlz77pQmWuHLXKUloUUtgJZ;;
 12: len 24; hex 4b6733657347335a7a3168347135714b7a37645550374644; asc Kg3esG3Zz1h4q5qKz7dUP7FD;;
 13: len 24; hex 6b37463165464c4b477a4358306b557a505a705550415256; asc k7F1eFLKGzCX0kUzPZpUPARV;;
 14: len 24; hex 767576393655744269737076443743414868413142414f69; asc vuv96UtBispvD7CAHhA1BAOi;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 73383548627242546b4b5a4542697533586f47633051756659747167495a; asc s85HbrBTkKZEBiu3XoGc0QufYtqgIZ; (total 49 bytes);

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 22 page no 2561 n bits 256 index `PRIMARY` of table `tpcc`.`order_line` trx id 5D9A lock mode S waiting
Record lock, heap no 181 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 1; hex 8a; asc  ;;
 2: len 4; hex 80000d16; asc     ;;
 3: len 1; hex 81; asc  ;;
 4: len 6; hex 000000005dcd; asc     ] ;;
 5: len 7; hex 800000002d0132; asc     - 2;;
 6: len 4; hex 800035db; asc   5 ;;
 7: len 2; hex 8001; asc   ;;
 8: SQL NULL;
 9: len 1; hex 88; asc  ;;
 10: len 3; hex 808e07; asc    ;;
 11: len 24; hex 436d52755a433579686935645877324e627650424f507175; asc CmRuZC5yhi5dXw2NbvPBOPqu;;

*** WE ROLL BACK TRANSACTION (1)
------------
TRANSACTIONS
------------
Trx id counter ADF0
Purge done for trx\'s n:o < ACF5 undo n:o < 0
History list length 122
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 0, not started, process no 14562, OS thread id 139954760554240
MySQL thread id 28, query id 1196034 localhost root
SHOW ENGINE INNODB STATUS
---TRANSACTION ADEA, not started, process no 14562, OS thread id 139954758690560 flushing log
MySQL thread id 24, query id 1195969 localhost root
commit
---TRANSACTION ADE7, not started, process no 14562, OS thread id 139955066586880 flushing log
MySQL thread id 23, query id 1195943 localhost root
commit
---TRANSACTION ADEE, ACTIVE (PREPARED) 0 sec, process no 14562, OS thread id 139954759223040 preparing
9 lock struct(s), heap size 1248, 10 row lock(s), undo log entries 9
MySQL thread id 15, query id 1196002 localhost root
commit
Trx read view will not see trx with id >= ADEF, sees < ADC2
---TRANSACTION ADED, ACTIVE 0 sec, process no 14562, OS thread id 139954761086720
14 lock struct(s), heap size 3112, 8 row lock(s), undo log entries 13
MySQL thread id 20, query id 1196033 localhost root
Trx read view will not see trx with id >= ADEE, sees < ADC2
---TRANSACTION ADEB, ACTIVE 0 sec, process no 14562, OS thread id 139954758956800
mysql tables in use 1, locked 0
14 lock struct(s), heap size 3112, 8 row lock(s), undo log entries 13
MySQL thread id 18, query id 1196035 localhost root init
SELECT i_price, i_name, i_data FROM item WHERE i_id = 55160
Trx read view will not see trx with id >= ADEC, sees < ADC2
---TRANSACTION ADE5, ACTIVE 0 sec, process no 14562, OS thread id 139954760288000 starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 376, 1 row lock(s)
MySQL thread id 19, query id 1195932 localhost root Updating
UPDATE warehouse SET w_ytd = w_ytd + 3997 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 6 page no 3 n bits 72 index `PRIMARY` of table `tpcc`.`warehouse` trx id ADE5 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 00000000adc2; asc       ;;
 2: len 7; hex 00000000e22e31; asc      .1;;
 3: len 9; hex 326d66387932347246; asc 2mf8y24rF;;
 4: len 15; hex 6561776a4459416650666a6b6c5464; asc eawjDYAfPfjklTd;;
 5: len 16; hex 64397a46397a7a6f37786f426d34734f; asc d9zF9zzo7xoBm4sO;;
 6: len 16; hex 6f37714b495469764351656633674741; asc o7qKITivCQef3gGA;;
 7: len 2; hex 5648; asc VH;;
 8: len 9; hex 303831373039333635; asc 081709365;;
 9: len 2; hex 800b; asc   ;;
 10: len 6; hex 800105b29f00; asc       ;;

------------------
---TRANSACTION ADE3, ACTIVE 0 sec, process no 14562, OS thread id 139954759489280 starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 376, 1 row lock(s)
MySQL thread id 21, query id 1195892 localhost root Updating
UPDATE warehouse SET w_ytd = w_ytd + 2957 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 6 page no 3 n bits 72 index `PRIMARY` of table `tpcc`.`warehouse` trx id ADE3 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 00000000adc2; asc       ;;
 2: len 7; hex 00000000e22e31; asc      .1;;
 3: len 9; hex 326d66387932347246; asc 2mf8y24rF;;
 4: len 15; hex 6561776a4459416650666a6b6c5464; asc eawjDYAfPfjklTd;;
 5: len 16; hex 64397a46397a7a6f37786f426d34734f; asc d9zF9zzo7xoBm4sO;;
 6: len 16; hex 6f37714b495469764351656633674741; asc o7qKITivCQef3gGA;;
 7: len 2; hex 5648; asc VH;;
 8: len 9; hex 303831373039333635; asc 081709365;;
 9: len 2; hex 800b; asc   ;;
 10: len 6; hex 800105b29f00; asc       ;;

------------------
---TRANSACTION ADD8, ACTIVE 0 sec, process no 14562, OS thread id 139954760820480 starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 376, 1 row lock(s)
MySQL thread id 17, query id 1195578 localhost root Updating
UPDATE warehouse SET w_ytd = w_ytd + 2401 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 6 page no 3 n bits 72 index `PRIMARY` of table `tpcc`.`warehouse` trx id ADD8 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 00000000adc2; asc       ;;
 2: len 7; hex 00000000e22e31; asc      .1;;
 3: len 9; hex 326d66387932347246; asc 2mf8y24rF;;
 4: len 15; hex 6561776a4459416650666a6b6c5464; asc eawjDYAfPfjklTd;;
 5: len 16; hex 64397a46397a7a6f37786f426d34734f; asc d9zF9zzo7xoBm4sO;;
 6: len 16; hex 6f37714b495469764351656633674741; asc o7qKITivCQef3gGA;;
 7: len 2; hex 5648; asc VH;;
 8: len 9; hex 303831373039333635; asc 081709365;;
 9: len 2; hex 800b; asc   ;;
 10: len 6; hex 800105b29f00; asc       ;;

------------------
---TRANSACTION ADC8, ACTIVE 0 sec, process no 14562, OS thread id 139954760021760 starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 376, 1 row lock(s)
MySQL thread id 16, query id 1195442 localhost root Updating
UPDATE warehouse SET w_ytd = w_ytd + 3156 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 6 page no 3 n bits 72 index `PRIMARY` of table `tpcc`.`warehouse` trx id ADC8 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 00000000adc2; asc       ;;
 2: len 7; hex 00000000e22e31; asc      .1;;
 3: len 9; hex 326d66387932347246; asc 2mf8y24rF;;
 4: len 15; hex 6561776a4459416650666a6b6c5464; asc eawjDYAfPfjklTd;;
 5: len 16; hex 64397a46397a7a6f37786f426d34734f; asc d9zF9zzo7xoBm4sO;;
 6: len 16; hex 6f37714b495469764351656633674741; asc o7qKITivCQef3gGA;;
 7: len 2; hex 5648; asc VH;;
 8: len 9; hex 303831373039333635; asc 081709365;;
 9: len 2; hex 800b; asc   ;;
 10: len 6; hex 800105b29f00; asc       ;;

------------------
---TRANSACTION ADC2, ACTIVE (PREPARED) 0 sec, process no 14562, OS thread id 139954759755520 preparing
7 lock struct(s), heap size 1248, 3 row lock(s), undo log entries 4
MySQL thread id 22, query id 1195996 localhost root
commit
Trx read view will not see trx with id >= ADEA, sees < ADC8
--------
FILE I/O
--------
I/O thread 0 state: waiting for i/o request (insert buffer thread)
I/O thread 1 state: waiting for i/o request (log thread)
I/O thread 2 state: waiting for i/o request (read thread)
I/O thread 3 state: waiting for i/o request (read thread)
I/O thread 4 state: waiting for i/o request (read thread)
I/O thread 5 state: waiting for i/o request (read thread)
I/O thread 6 state: waiting for i/o request (write thread)
I/O thread 7 state: waiting for i/o request (write thread)
I/O thread 8 state: waiting for i/o request (write thread)
I/O thread 9 state: waiting for i/o request (write thread)
Pending normal aio reads: 0, aio writes: 0,
 ibuf aio reads: 0, log i/o\'s: 0, sync i/o\'s: 0
Pending flushes (fsync) log: 1; buffer pool: 0
2207 OS file reads, 50640 OS file writes, 24104 OS fsyncs
1.00 reads/s, 16384 avg bytes/read, 669.29 writes/s, 397.95 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 0, seg size 2,
347 inserts, 347 merged recs, 193 merges
Hash table size 276707, node heap has 367 buffer(s)
9866.89 hash searches/s, 13771.65 non-hash searches/s
---
LOG
---
Log sequence number 444468720
Log flushed up to   444463070
Last checkpoint at  441479840
1 pending log writes, 0 pending chkp writes
19730 log i/o\'s done, 365.95 log i/o\'s/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total memory allocated 137232384; in additional pool allocated 0
Dictionary memory allocated 96391
Buffer pool size   8192
Free buffers       797
Database pages     7028
Old database pages 2574
Modified db pages  2019
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 13116, not young 0
32.62 youngs/s, 0.00 non-youngs/s
Pages read 2286, created 19285, written 92483
1.00 reads/s, 16.12 creates/s, 860.52 writes/s
Buffer pool hit rate 1000 / 1000, young-making rate 0 / 1000 not 0 / 1000
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 7028, unzip_LRU len: 0
I/O sum[61497]:cur[0], unzip sum[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
5 read views open inside InnoDB
Main thread process no. 14562, id 139954754651904, state: sleeping
Number of rows inserted 2405817, updated 174583, deleted 6600, read 3073308
1760.78 inserts/s, 3517.31 updates/s, 133.73 deletes/s, 15389.58 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
'
          }
        ];

$mysql51= $mysql51_plugin;

$mysql55 = [
          {
            'Type' => 'InnoDB',
            'Status' => '
=====================================
190708 14:27:14 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 51 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 103 1_second, 103 sleeps, 10 10_second, 14 background, 14 flush
srv_master_thread log flush and writes: 103
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 1639, signal count 2715
Mutex spin waits 27883, rounds 98992, OS waits 732
RW-shared spins 1113, rounds 22292, OS waits 376
RW-excl spins 528, rounds 20058, OS waits 447
Spin rounds per wait: 3.55 mutex, 20.03 RW-shared, 37.99 RW-excl
------------------------
LATEST DETECTED DEADLOCK
------------------------
190708 14:26:41
*** (1) TRANSACTION:
TRANSACTION 3BCC, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 20 lock struct(s), heap size 3112, 13 row lock(s), undo log entries 27
MySQL thread id 8, OS thread handle 0x7f14a864d700, query id 780433 localhost root statistics
SELECT s_quantity, s_data, s_dist_01, s_dist_02, s_dist_03, s_dist_04, s_dist_05, s_dist_06, s_dist_07, s_dist_08, s_dist_09, s_dist_10 FROM stock WHERE s_i_id = 89811 AND s_w_id = 1 FOR UPDATE
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 23 page no 2110 n bits 120 index `PRIMARY` of table `tpcc`.`stock` trx id 3BCC lock_mode X locks rec but not gap waiting
Record lock, heap no 3 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015ed3; asc   ^ ;;
 2: len 6; hex 0000000009de; asc       ;;
 3: len 7; hex b8000009fc2908; asc      ) ;;
 4: len 2; hex 8033; asc  3;;
 5: len 24; hex 514d464730637a6c7432346831665a74745334746a753445; asc QMFG0czlt24h1fZttS4tju4E;;
 6: len 24; hex 344173506a616f3570343553326f4a347379355659774e30; asc 4AsPjao5p45S2oJ4sy5VYwN0;;
 7: len 24; hex 4769754a77474e36396c6e6a5a7458647778646a47695a46; asc GiuJwGN69lnjZtXdwxdjGiZF;;
 8: len 24; hex 356e69536c69695262314e724e5279384667663844493241; asc 5niSliiRb1NrNRy8Fgf8DI2A;;
 9: len 24; hex 6c4f634c644e4f4f3571386d575a4e577643744d397a5a70; asc lOcLdNOO5q8mWZNWvCtM9zZp;;
 10: len 24; hex 66307569386f5457516d386d4155727961645641797a3339; asc f0ui8oTWQm8mAUryadVAyz39;;
 11: len 24; hex 4e497078355263354a4944386d6857576e4968493866736a; asc NIpx5Rc5JID8mhWWnIhI8fsj;;
 12: len 24; hex 30693731727850376b4b433977485444535a78373554744d; asc 0i71rxP7kKC9wHTDSZx75TtM;;
 13: len 24; hex 4255713144773074347a697a4f7069693170644749716772; asc BUq1Dw0t4zizOpii1pdGIqgr;;
 14: len 24; hex 6d76476648506f6c446e77396e71426e5739394d72714c65; asc mvGfHPolDnw9nqBnW99MrqLe;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 617848476d343068496679685468734863323251426e774b7849396e636f; asc axHGm40hIfyhThsHc22QBnwKxI9nco; (total 44 bytes);

*** (2) TRANSACTION:
TRANSACTION 3BBF, ACTIVE 0 sec inserting
mysql tables in use 2, locked 2
2314 lock struct(s), heap size 211384, 41560 row lock(s), undo log entries 12951
MySQL thread id 17, OS thread handle 0x7f14a8404700, query id 779962 localhost root Sending data
INSERT LOW_PRIORITY IGNORE INTO `tpcc`.`_order_line_new` (`ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info`) SELECT `ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info` FROM `tpcc`.`order_line` FORCE INDEX(`PRIMARY`) WHERE ((`ol_w_id` > \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` > \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` > \'1458\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'1458\' AND `ol_number` >= \'2\')) AND ((`ol_w_id` < \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` < \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` < \'3195\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'3195\' AND `ol_number` <= \'14\')) LOCK IN SHARE MODE /*pt-online-schema-change 15764 copy nibble*/
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 23 page no 2110 n bits 120 index `PRIMARY` of table `tpcc`.`stock` trx id 3BBF lock mode S locks rec but not gap
Record lock, heap no 3 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015ed3; asc   ^ ;;
 2: len 6; hex 0000000009de; asc       ;;
 3: len 7; hex b8000009fc2908; asc      ) ;;
 4: len 2; hex 8033; asc  3;;
 5: len 24; hex 514d464730637a6c7432346831665a74745334746a753445; asc QMFG0czlt24h1fZttS4tju4E;;
 6: len 24; hex 344173506a616f3570343553326f4a347379355659774e30; asc 4AsPjao5p45S2oJ4sy5VYwN0;;
 7: len 24; hex 4769754a77474e36396c6e6a5a7458647778646a47695a46; asc GiuJwGN69lnjZtXdwxdjGiZF;;
 8: len 24; hex 356e69536c69695262314e724e5279384667663844493241; asc 5niSliiRb1NrNRy8Fgf8DI2A;;
 9: len 24; hex 6c4f634c644e4f4f3571386d575a4e577643744d397a5a70; asc lOcLdNOO5q8mWZNWvCtM9zZp;;
 10: len 24; hex 66307569386f5457516d386d4155727961645641797a3339; asc f0ui8oTWQm8mAUryadVAyz39;;
 11: len 24; hex 4e497078355263354a4944386d6857576e4968493866736a; asc NIpx5Rc5JID8mhWWnIhI8fsj;;
 12: len 24; hex 30693731727850376b4b433977485444535a78373554744d; asc 0i71rxP7kKC9wHTDSZx75TtM;;
 13: len 24; hex 4255713144773074347a697a4f7069693170644749716772; asc BUq1Dw0t4zizOpii1pdGIqgr;;
 14: len 24; hex 6d76476648506f6c446e77396e71426e5739394d72714c65; asc mvGfHPolDnw9nqBnW99MrqLe;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 617848476d343068496679685468734863323251426e774b7849396e636f; asc axHGm40hIfyhThsHc22QBnwKxI9nco; (total 44 bytes);

Record lock, heap no 4 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015ed4; asc   ^ ;;
 2: len 6; hex 000000003232; asc     22;;
 3: len 7; hex 3800000b6d1db5; asc 8   m  ;;
 4: len 2; hex 8051; asc  Q;;
 5: len 24; hex 70544e70745a6470745936314c69705a75593249335a6a47; asc pTNptZdptY61LipZuY2I3ZjG;;
 6: len 24; hex 6f51724d46443967597958375a4b7a37513051366e7a794c; asc oQrMFD9gYyX7ZKz7Q0Q6nzyL;;
 7: len 24; hex 484f593064746f316938477648775345525a6e6c57764355; asc HOY0dto1i8GvHwSERZnlWvCU;;
 8: len 24; hex 47484a466347557a7053616748624f4e7049666a6b74414a; asc GHJFcGUzpSagHbONpIfjktAJ;;
 9: len 24; hex 766f583549744d61415a41513337445668746b4749383561; asc voX5ItMaAZAQ37DVhtkGI85a;;
 10: len 24; hex 6f4b63796247734e6f7867664845706f4d447255524c3949; asc oKcybGsNoxgfHEpoMDrURL9I;;
 11: len 24; hex 51613956387349515545326a364e583433414a4678386341; asc Qa9V8sIQUE2j6NX43AJFx8cA;;
 12: len 24; hex 345a4744734b64515237584b4e786f627858694c326b4f41; asc 4ZGDsKdQR7XKNxobxXiL2kOA;;
 13: len 24; hex 633742454739496e50546468353239435a5258574638556c; asc c7BEG9InPTdh529CZRXWF8Ul;;
 14: len 24; hex 706c614275636e7a6c7a46754631496a65786f6734794456; asc plaBucnzlzFuF1Ijexog4yDV;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 6b6a6445555331443041376377374f764b47424a57737755676157656f32; asc kjdEUS1D0A7cw7OvKGBJWswUgaWeo2; (total 48 bytes);

Record lock, heap no 12 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015edc; asc   ^ ;;
 2: len 6; hex 0000000009de; asc       ;;
 3: len 7; hex b8000009fc2998; asc      ) ;;
 4: len 2; hex 8026; asc  &;;
 5: len 24; hex 37644f4a73435739534c5a3874584748596d62485270576a; asc 7dOJsCW9SLZ8tXGHYmbHRpWj;;
 6: len 24; hex 484c6456335261676e75587a5167506a4458616b6d704759; asc HLdV3RagnuXzQgPjDXakmpGY;;
 7: len 24; hex 5879443366484a79756f314a5069374846366874574f3631; asc XyD3fHJyuo1JPi7HF6htWO61;;
 8: len 24; hex 6f6c6c34494161454e62746375725668716f3659764e6c30; asc oll4IAaENbtcurVhqo6YvNl0;;
 9: len 24; hex 65554f69544b554633585844376c5a6763425a5267474856; asc eUOiTKUF3XXD7lZgcBZRgGHV;;
 10: len 24; hex 6f4f685a4d68437135734b4e4e584f7532637a6c39664e4b; asc oOhZMhCq5sKNNXOu2czl9fNK;;
 11: len 24; hex 6d7a5331556d6e71544e4438583142504a576d7176657156; asc mzS1UmnqTND8X1BPJWmqveqV;;
 12: len 24; hex 626548777754697677694e695645417350474e4f536e6979; asc beHwwTivwiNiVEAsPGNOSniy;;
 13: len 24; hex 5772434e4d6e7979327676576271514a4536705145667056; asc WrCNMnyy2vvWbqQJE6pQEfpV;;
 14: len 24; hex 42786f74744c516c566e35486a344a657a6e477042583149; asc BxottLQlVn5Hj4JeznGpBX1I;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 525532457a33517572486d43685667536178436f726967696e616c615154; asc RU2Ez3QurHmChVgSaxCoriginalaQT; (total 42 bytes);

Record lock, heap no 19 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015ee3; asc   ^ ;;
 2: len 6; hex 000000003355; asc     3U;;
 3: len 7; hex 4f00000b7922dd; asc O   y" ;;
 4: len 2; hex 8046; asc  F;;
 5: len 24; hex 34585462695954494f734665745a46713551704234493957; asc 4XTbiYTIOsFetZFq5QpB4I9W;;
 6: len 24; hex 33674a505742553366356a4258325a4e4844487154357472; asc 3gJPWBU3f5jBX2ZNHDHqT5tr;;
 7: len 24; hex 32764239516f433438615948326275354b35634b63306271; asc 2vB9QoC48aYH2bu5K5cKc0bq;;
 8: len 24; hex 50484b4736434a304e514f43645349427958445853497056; asc PHKG6CJ0NQOCdSIByXDXSIpV;;
 9: len 24; hex 4138746c7738394253504863674630376441693351743178; asc A8tlw89BSPHcgF07dAi3Qt1x;;
 10: len 24; hex 59504f4d76485731414678494f38696f4e4a55624a5a4554; asc YPOMvHW1AFxIO8ioNJUbJZET;;
 11: len 24; hex 477438466f456d4562383773653831743348473979345548; asc Gt8FoEmEb87se81t3HG9y4UH;;
 12: len 24; hex 35613649314e5773576c6769567348647a38463539373651; asc 5a6I1NWsWlgiVsHdz8F5976Q;;
 13: len 24; hex 464d506b64766e443135434e6234724c6c5a716272536278; asc FMPkdvnD15CNb4rLlZqbrSbx;;
 14: len 24; hex 65366d6c553779725767555355675258716f377664536544; asc e6mlU7yrWgUSUgRXqo7vdSeD;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 4632676f784d543336435645414d697070384854616f4a4d7445304c7142; asc F2goxMT36CVEAMipp8HTaoJMtE0LqB; (total 48 bytes);

Record lock, heap no 24 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015ee8; asc   ^ ;;
 2: len 6; hex 0000000009de; asc       ;;
 3: len 7; hex b8000009fc2a58; asc      *X;;
 4: len 2; hex 804d; asc  M;;
 5: len 24; hex 6b4f53374c69754a53774f4a7a444d5867617778335a4f39; asc kOS7LiuJSwOJzDMXgawx3ZO9;;
 6: len 24; hex 794c77373441725363776d4c72356c6c523269664f474a78; asc yLw74ArScwmLr5llR2ifOGJx;;
 7: len 24; hex 48306a64396c6356686a5872613055576d6e4c7059364859; asc H0jd9lcVhjXra0UWmnLpY6HY;;
 8: len 24; hex 75783142754251757534326467564b4e3239783264526d4f; asc ux1BuBQuu42dgVKN29x2dRmO;;
 9: len 24; hex 6175727054636a516473496f4a43674e434a336864516b6e; asc aurpTcjQdsIoJCgNCJ3hdQkn;;
 10: len 24; hex 6b4f6b566c5635664c7338785a5962526f4e6b7a3437424e; asc kOkVlV5fLs8xZYbRoNkz47BN;;
 11: len 24; hex 747a57626b704a36616f723372564d6a644b4941746b7947; asc tzWbkpJ6aor3rVMjdKIAtkyG;;
 12: len 24; hex 784b613767673066445a4e30735259684a63576f79475047; asc xKa7gg0fDZN0sRYhJcWoyGPG;;
 13: len 24; hex 5a394757516a52694a594f7a573141354d42796f6a64374a; asc Z9GWQjRiJYOzW1A5MByojd7J;;
 14: len 24; hex 74474e4757777165414b32746c6b414b3938713847755652; asc tGNGWwqeAK2tlkAK98q8GuVR;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 4a39544f51614667795642734a70326472774e6234686943567054504b73; asc J9TOQaFgyVBsJp2drwNb4hiCVpTPKs; (total 39 bytes);

Record lock, heap no 30 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015eee; asc   ^ ;;
 2: len 6; hex 0000000009de; asc       ;;
 3: len 7; hex b8000009fc2ab8; asc      * ;;
 4: len 2; hex 805b; asc  [;;
 5: len 24; hex 6b6e68717a474778396a4a735341786d735979365135716b; asc knhqzGGx9jJsSAxmsYy6Q5qk;;
 6: len 24; hex 397a5574766f62675752646d6661744f726c713267617545; asc 9zUtvobgWRdmfatOrlq2gauE;;
 7: len 24; hex 7963636e4e57754b306e44704e724a6f5533553277717466; asc yccnNWuK0nDpNrJoU3U2wqtf;;
 8: len 24; hex 744c486d586f693950565576506d75427a685971794b4931; asc tLHmXoi9PVUvPmuBzhYqyKI1;;
 9: len 24; hex 4b766443594933745a70514d575a6c313465506f59616f44; asc KvdCYI3tZpQMWZl14ePoYaoD;;
 10: len 24; hex 63424f74414244336f4e62365255644573786b53696b554e; asc cBOtABD3oNb6RUdEsxkSikUN;;
 11: len 24; hex 49746834376c66473959524b6a553637344357596f6b526c; asc Ith47lfG9YRKjU674CWYokRl;;
 12: len 24; hex 7253444a6e4d5a6731636c6d4832766e524757744d627858; asc rSDJnMZg1clmH2vnRGWtMbxX;;
 13: len 24; hex 554a7374344a69555731487159797241686450685743366b; asc UJst4JiUW1HqYyrAhdPhWC6k;;
 14: len 24; hex 30354976614f4e7447477658795133786874556469634c4c; asc 05IvaONtGGvXyQ3xhtUdicLL;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 3270433761723766383044574f366b65314862524b573744796b76623345; asc 2pC7ar7f80DWO6ke1HbRKW7Dykvb3E; (total 38 bytes);

Record lock, heap no 35 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015ef3; asc   ^ ;;
 2: len 6; hex 000000003470; asc     4p;;
 3: len 7; hex 6200000b4e22a6; asc b   N" ;;
 4: len 2; hex 8012; asc   ;;
 5: len 24; hex 365264354d614d3158455a694f724858485676324a435257; asc 6Rd5MaM1XEZiOrHXHVv2JCRW;;
 6: len 24; hex 3333525158315579655a4a44744b6b377552546a69793142; asc 33RQX1UyeZJDtKk7uRTjiy1B;;
 7: len 24; hex 315536533144543265745a644e57477570546e3744743163; asc 1U6S1DT2etZdNWGupTn7Dt1c;;
 8: len 24; hex 6a4b4a6954446a7948397855637a3655586b7231796d6f52; asc jKJiTDjyH9xUcz6UXkr1ymoR;;
 9: len 24; hex 76634f7646686558304b31423178514175766b727a434d68; asc vcOvFheX0K1B1xQAuvkrzCMh;;
 10: len 24; hex 4c666f39344a35686930755063524e775157784e7535486e; asc Lfo94J5hi0uPcRNwQWxNu5Hn;;
 11: len 24; hex 376e305455326e386f7743373172707a6a435a4258546231; asc 7n0TU2n8owC71rpzjCZBXTb1;;
 12: len 24; hex 787752456a464a55446c7844593331554438553577526f36; asc xwREjFJUDlxDY31UD8U5wRo6;;
 13: len 24; hex 7863535862725556476744543068676a65724866736a747a; asc xcSXbrUVGgDT0hgjerHfsjtz;;
 14: len 24; hex 7976666b7a65675a344442746667414c74644a5a49324239; asc yvfkzegZ4DBtfgALtdJZI2B9;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 7230336b7a4567737251705436505948615277455a493844626854637363; asc r03kzEgsrQpT6PYHaRwEZI8DbhTcsc; (total 39 bytes);

Record lock, heap no 36 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80015ef4; asc   ^ ;;
 2: len 6; hex 0000000009de; asc       ;;
 3: len 7; hex b8000009fc2b18; asc      + ;;
 4: len 2; hex 8037; asc  7;;
 5: len 24; hex 44576363327541546f4d3334554565396847304842687336; asc DWcc2uAToM34UEe9hG0HBhs6;;
 6: len 24; hex 5048476e486d796c50596e4869463534494158556f654234; asc PHGnHmylPYnHiF54IAXUoeB4;;
 7: len 24; hex 51444b494a5467596a547157526274784e4166634468734c; asc QDKIJTgYjTqWRbtxNAfcDhsL;;
 8: len 24; hex 4d3972564254764e6e4565457544794c31536b614a687854; asc M9rVBTvNnEeEuDyL1SkaJhxT;;
 9: len 24; hex 5a657a5230416e3731494a5345654551495349564f625771; asc ZezR0An71IJSEeEQISIVObWq;;
 10: len 24; hex 37373032594963444633445072494f375a724a44336a5756; asc 7702YIcDF3DPrIO7ZrJD3jWV;;
 11: len 24; hex 7a75635569765a7174624f39445a50486d6f363344426332; asc zucUivZqtbO9DZPHmo63DBc2;;
 12: len 24; hex 7135434b61434a536d6e39694b785a774a6a3974364f6475; asc q5CKaCJSmn9iKxZwJj9t6Odu;;
 13: len 24; hex 6735634a3735394348546c546b42475749777146546d5a43; asc g5cJ759CHTlTkBGWIwqFTmZC;;
 14: len 24; hex 51474733426869474a314f4f3859645a483748544c6e6c48; asc QGG3BhiGJ1OO8YdZH7HTLnlH;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 7a6b4f577649774258784b456662566778726d54534a6c5a6243754f7639; asc zkOWvIwBXxKEfbVgxrmTSJlZbCuOv9; (total 47 bytes);

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 23 page no 1671 n bits 120 index `PRIMARY` of table `tpcc`.`stock` trx id 3BBF lock mode S locks rec but not gap waiting
Record lock, heap no 45 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80010ffd; asc     ;;
 2: len 6; hex 000000003bcc; asc     ; ;;
 3: len 7; hex 4a00000c6501da; asc J   e  ;;
 4: len 2; hex 800b; asc   ;;
 5: len 24; hex 6c4e316a75566e774f4f53476b6661647938304b6b356930; asc lN1juVnwOOSGkfady80Kk5i0;;
 6: len 24; hex 627230554b4746664877616b6a553635774d6e6176515933; asc br0UKGFfHwakjU65wMnavQY3;;
 7: len 24; hex 736d55626b62416261657471745a356e39715764755a5948; asc smUbkbAbaetqtZ5n9qWduZYH;;
 8: len 24; hex 38436c67444157786335684247486c7341626b6868587156; asc 8ClgDAWxc5hBGHlsAbkhhXqV;;
 9: len 24; hex 5350627967793671696b3271457a534b6864597950513879; asc SPbygy6qik2qEzSKhdYyPQ8y;;
 10: len 24; hex 6f666963386b34594a3243473633796f356d3334454c6c70; asc ofic8k4YJ2CG63yo5m34ELlp;;
 11: len 24; hex 68454a6f4253636f384578714856394868504f694c416e37; asc hEJoBSco8ExqHV9HhPOiLAn7;;
 12: len 24; hex 714a575a3950484c68335737664c46744735416a43535161; asc qJWZ9PHLh3W7fLFtG5AjCSQa;;
 13: len 24; hex 377477733138674965475234566c6a594671446135346f38; asc 7tws18gIeGR4VljYFqDa54o8;;
 14: len 24; hex 584964777352336d4c746c546133387154434a437472526a; asc XIdwsR3mLtlTa38qTCJCtrRj;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 306d366f73484d417547314a4a6e664157386b5a4761305172414a696330; asc 0m6osHMAuG1JJnfAW8kZGa0QrAJic0; (total 50 bytes);

*** WE ROLL BACK TRANSACTION (1)
------------
TRANSACTIONS
------------
Trx id counter 4D3D
Purge done for trx\'s n:o < 4D3D undo n:o < 0
History list length 970
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 0, not started
MySQL thread id 19, OS thread handle 0x7f14a85cb700, query id 840612 localhost root
SHOW ENGINE INNODB STATUS
--------
FILE I/O
--------
I/O thread 0 state: waiting for completed aio requests (insert buffer thread)
I/O thread 1 state: waiting for completed aio requests (log thread)
I/O thread 2 state: waiting for completed aio requests (read thread)
I/O thread 3 state: waiting for completed aio requests (read thread)
I/O thread 4 state: waiting for completed aio requests (read thread)
I/O thread 5 state: waiting for completed aio requests (read thread)
I/O thread 6 state: waiting for completed aio requests (write thread)
I/O thread 7 state: waiting for completed aio requests (write thread)
I/O thread 8 state: waiting for completed aio requests (write thread)
I/O thread 9 state: waiting for completed aio requests (write thread)
Pending normal aio reads: 0 [0, 0, 0, 0] , aio writes: 0 [0, 0, 0, 0] ,
 ibuf aio reads: 0, log i/o\'s: 0, sync i/o\'s: 0
Pending flushes (fsync) log: 0; buffer pool: 0
7615 OS file reads, 57796 OS file writes, 11442 OS fsyncs
60.27 reads/s, 16384 avg bytes/read, 614.36 writes/s, 156.13 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 96, seg size 98, 491 merges
merged operations:
 insert 5970, delete mark 0, delete 0
discarded operations:
 insert 5452, delete mark 0, delete 0
Hash table size 276707, node heap has 285 buffer(s)
20878.30 hash searches/s, 12913.65 non-hash searches/s
---
LOG
---
Log sequence number 685377455
Log flushed up to   685377455
Last checkpoint at  685377455
0 pending log writes, 0 pending chkp writes
8736 log i/o\'s done, 134.74 log i/o\'s/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total memory allocated 137363456; in additional pool allocated 0
Dictionary memory allocated 92289
Buffer pool size   8192
Free buffers       1
Database pages     7906
Old database pages 2898
Modified db pages  0
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 16366, not young 0
228.13 youngs/s, 0.00 non-youngs/s
Pages read 7577, created 19788, written 47012
60.25 reads/s, 50.16 creates/s, 468.11 writes/s
Buffer pool hit rate 1000 / 1000, young-making rate 2 / 1000 not 0 / 1000
Pages read ahead 10.76/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 7906, unzip_LRU len: 0
I/O sum[25999]:cur[0], unzip sum[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
1 read views open inside InnoDB
Main thread process no. 6818, id 139726355920640, state: waiting for server activity
Number of rows inserted 2345150, updated 72685, deleted 2719, read 2645260
6882.55 inserts/s, 1203.00 updates/s, 45.00 deletes/s, 32699.14 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
',
            'Name' => ''
          }
        ];

$mysql56 = [
          {
            'Type' => 'InnoDB',
            'Status' => '
=====================================
2019-07-08 14:30:01 7fe6628b9700 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 16 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 80 srv_active, 0 srv_shutdown, 57 srv_idle
srv_master_thread log flush and writes: 137
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 4682
OS WAIT ARRAY INFO: signal count 4585
Mutex spin waits 13396, rounds 166472, OS waits 3721
RW-shared spins 1295, rounds 27813, OS waits 515
RW-excl spins 661, rounds 17666, OS waits 334
Spin rounds per wait: 12.43 mutex, 21.48 RW-shared, 26.73 RW-excl
------------------------
LATEST DETECTED DEADLOCK
------------------------
2019-07-08 14:29:42 7fe6628b9700
*** (1) TRANSACTION:
TRANSACTION 40132, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 15 lock struct(s), heap size 2936, 8 row lock(s), undo log entries 15
MySQL thread id 23, OS thread handle 0x7fe66297f700, query id 786400 localhost root statistics
SELECT s_quantity, s_data, s_dist_01, s_dist_02, s_dist_03, s_dist_04, s_dist_05, s_dist_06, s_dist_07, s_dist_08, s_dist_09, s_dist_10 FROM stock WHERE s_i_id = 66820 AND s_w_id = 1 FOR UPDATE
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 633 page no 1482 n bits 120 index `PRIMARY` of table `tpcc`.`stock` trx id 40132 lock_mode X locks rec but not gap waiting
Record lock, heap no 33 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80010504; asc     ;;
 2: len 6; hex 00000000682e; asc     h.;;
 3: len 7; hex ac00000c683572; asc     h5r;;
 4: len 2; hex 8020; asc   ;;
 5: len 24; hex 72324a306d4f354b70745a6c63646833375365646b36446d; asc r2J0mO5KptZlcdh37Sedk6Dm;;
 6: len 24; hex 6941726a4f366251515a416d63556257334d386531396b54; asc iArjO6bQQZAmcUbW3M8e19kT;;
 7: len 24; hex 4e43735977434737333056395a745836344b6a5774445945; asc NCsYwCG730V9ZtX64KjWtDYE;;
 8: len 24; hex 4144547566454772346f6e47337348334e52614677674a45; asc ADTufEGr4onG3sH3NRaFwgJE;;
 9: len 24; hex 6e38614c4b7557584c4f4358633163526e71536638543358; asc n8aLKuWXLOCXc1cRnqSf8T3X;;
 10: len 24; hex 4954685a69334b6f6467385641646f576f4d39707961636d; asc IThZi3Kodg8VAdoWoM9pyacm;;
 11: len 24; hex 4975564a52575a764236624551507136564c4538386c7755; asc IuVJRWZvB6bEQPq6VLE88lwU;;
 12: len 24; hex 6b51534d43536337767657525552615932707a5066357379; asc kQSMCSc7vvWRURaY2pzPf5sy;;
 13: len 24; hex 7a363374597864794e79397061456b556b39774168564157; asc z63tYxdyNy9paEkUk9wAhVAW;;
 14: len 24; hex 6139585138705043734a6c6e756838736f78523266766c6d; asc a9XQ8pPCsJlnuh8soxR2fvlm;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 76554d35797164384f324542524f32693770647077546274756358704e48; asc vUM5yqd8O2EBRO2i7pdpwTbtucXpNH; (total 42 bytes);

*** (2) TRANSACTION:
TRANSACTION 40112, ACTIVE 0 sec inserting
mysql tables in use 2, locked 2
2105 lock struct(s), heap size 194088, 14311 row lock(s), undo log entries 6937
MySQL thread id 28, OS thread handle 0x7fe6628b9700, query id 786056 localhost root Sending data
INSERT LOW_PRIORITY IGNORE INTO `tpcc`.`_order_line_new` (`ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info`) SELECT `ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info` FROM `tpcc`.`order_line` FORCE INDEX(`PRIMARY`) WHERE ((`ol_w_id` > \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` > \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` > \'2418\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'2418\' AND `ol_number` >= \'8\')) AND ((`ol_w_id` < \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` < \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` < \'3205\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'3205\' AND `ol_number` <= \'13\')) LOCK IN SHARE MODE /*pt-online-schema-change 17005 copy nibble*/
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 633 page no 1482 n bits 120 index `PRIMARY` of table `tpcc`.`stock` trx id 40112 lock mode S locks rec but not gap
Record lock, heap no 3 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 800104e6; asc     ;;
 2: len 6; hex 00000000682e; asc     h.;;
 3: len 7; hex ac00000c683356; asc     h3V;;
 4: len 2; hex 801a; asc   ;;
 5: len 24; hex 794d314947615769386a34416468794a436a7a3268463759; asc yM1IGaWi8j4AdhyJCjz2hF7Y;;
 6: len 24; hex 685747633568625069746449504b52384d5a6b3357314744; asc hWGc5hbPitdIPKR8MZk3W1GD;;
 7: len 24; hex 4775464e5146347657667944474c75377a43574862636442; asc GuFNQF4vWfyDGLu7zCWHbcdB;;
 8: len 24; hex 68664c76734c426b5957416f593349443156544e4e594b61; asc hfLvsLBkYWAoY3ID1VTNNYKa;;
 9: len 24; hex 62396645497a74784c6f7065785844546931326a4a446c6d; asc b9fEIztxLopexXDTi12jJDlm;;
 10: len 24; hex 3641444f69477a70764238733333447272736e4f33473634; asc 6ADOiGzpvB8s33DrrsnO3G64;;
 11: len 24; hex 714c555a353966464b317661306c5639744f43775a326c50; asc qLUZ59fFK1va0lV9tOCwZ2lP;;
 12: len 24; hex 415333455549326e6d62747445384446326f446e484c6564; asc AS3EUI2nmbttE8DF2oDnHLed;;
 13: len 24; hex 5942564b594955314d6954636c484d4b41465847516d4943; asc YBVKYIU1MiTclHMKAFXGQmIC;;
 14: len 24; hex 33534a68356f45454b596e63306d776746595255756b6537; asc 3SJh5oEEKYnc0mwgFYRUuke7;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 74573139697a4441496f726967696e616c7a617a7748465367684c514b53; asc tW19izDAIoriginalzazwHFSghLQKS; (total 31 bytes);

Record lock, heap no 8 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 800104eb; asc     ;;
 2: len 6; hex 00000000682e; asc     h.;;
 3: len 7; hex ac00000c6833b0; asc     h3 ;;
 4: len 2; hex 804d; asc  M;;
 5: len 24; hex 504d77337864736c5a50555354554277396a6d7150394c52; asc PMw3xdslZPUSTUBw9jmqP9LR;;
 6: len 24; hex 5a574172436a4857664b5449414370586748313851764638; asc ZWArCjHWfKTIACpXgH18QvF8;;
 7: len 24; hex 35586f50796d7753786e63653238484d5a58556a4e324e63; asc 5XoPymwSxnce28HMZXUjN2Nc;;
 8: len 24; hex 5533756a42626e6750416339363534726869756f78454c56; asc U3ujBbngPAc9654rhiuoxELV;;
 9: len 24; hex 35716a53516977526365634450476158746864776d536253; asc 5qjSQiwRcecDPGaXthdwmSbS;;
 10: len 24; hex 4e515a6a74476d6878433766375a486c3953384f30664668; asc NQZjtGmhxC7f7ZHl9S8O0fFh;;
 11: len 24; hex 4252676b753138496170396f62716c6e7651755366646135; asc BRgku18Iap9obqlnvQuSfda5;;
 12: len 24; hex 79354f446b634d434a36344b434b733154656148504f436e; asc y5ODkcMCJ64KCKs1TeaHPOCn;;
 13: len 24; hex 6451754456644261304d49636755766b5744787133774868; asc dQuDVdBa0MIcgUvkWDxq3wHh;;
 14: len 24; hex 5734766872394b4833586b6667496632624667333951614d; asc W4vhr9KH3XkfgIf2bFg39QaM;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 4f4f49653570414169727a723948746731594b49424b745130775a525575; asc OOIe5pAAirzr9Htg1YKIBKtQ0wZRUu; (total 48 bytes);

Record lock, heap no 21 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 800104f8; asc     ;;
 2: len 6; hex 00000000682e; asc     h.;;
 3: len 7; hex ac00000c68349a; asc     h4 ;;
 4: len 2; hex 8019; asc   ;;
 5: len 24; hex 636a4157574c346b59516879506543696c4b583047794744; asc cjAWWL4kYQhyPeCilKX0GyGD;;
 6: len 24; hex 475655444c797134364d59524f4a786f7977436336734d4f; asc GVUDLyq46MYROJxoywCc6sMO;;
 7: len 24; hex 4d654d63715a714c3334677a73693645475664585250574c; asc MeMcqZqL34gzsi6EGVdXRPWL;;
 8: len 24; hex 36525153706d6e543850486645636849476741776b4d4245; asc 6RQSpmnT8PHfEchIGgAwkMBE;;
 9: len 24; hex 69664c4379734a50496a453257663877786f415856516d39; asc ifLCysJPIjE2Wf8wxoAXVQm9;;
 10: len 24; hex 697373723671596a396b68313134496c494b487854427348; asc issr6qYj9kh114IlIKHxTBsH;;
 11: len 24; hex 516b68437446736c386b707749573530423432464d6e5868; asc QkhCtFsl8kpwIW50B42FMnXh;;
 12: len 24; hex 5438454c4e566a37447630536d6b59575a536d34586d4663; asc T8ELNVj7Dv0SmkYWZSm4XmFc;;
 13: len 24; hex 567758306261526a6d6c34485542554f4176387352655075; asc VwX0baRjml4HUBUOAv8sRePu;;
 14: len 24; hex 5450386a317643795341583061486b4c4c326e565539644e; asc TP8j1vCySAX0aHkLL2nVU9dN;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 567074756a484f384f3538484834685062697a7153494353366676444949; asc VptujHO8O58HH4hPbizqSICS6fvDII; (total 35 bytes);

Record lock, heap no 33 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80010504; asc     ;;
 2: len 6; hex 00000000682e; asc     h.;;
 3: len 7; hex ac00000c683572; asc     h5r;;
 4: len 2; hex 8020; asc   ;;
 5: len 24; hex 72324a306d4f354b70745a6c63646833375365646b36446d; asc r2J0mO5KptZlcdh37Sedk6Dm;;
 6: len 24; hex 6941726a4f366251515a416d63556257334d386531396b54; asc iArjO6bQQZAmcUbW3M8e19kT;;
 7: len 24; hex 4e43735977434737333056395a745836344b6a5774445945; asc NCsYwCG730V9ZtX64KjWtDYE;;
 8: len 24; hex 4144547566454772346f6e47337348334e52614677674a45; asc ADTufEGr4onG3sH3NRaFwgJE;;
 9: len 24; hex 6e38614c4b7557584c4f4358633163526e71536638543358; asc n8aLKuWXLOCXc1cRnqSf8T3X;;
 10: len 24; hex 4954685a69334b6f6467385641646f576f4d39707961636d; asc IThZi3Kodg8VAdoWoM9pyacm;;
 11: len 24; hex 4975564a52575a764236624551507136564c4538386c7755; asc IuVJRWZvB6bEQPq6VLE88lwU;;
 12: len 24; hex 6b51534d43536337767657525552615932707a5066357379; asc kQSMCSc7vvWRURaY2pzPf5sy;;
 13: len 24; hex 7a363374597864794e79397061456b556b39774168564157; asc z63tYxdyNy9paEkUk9wAhVAW;;
 14: len 24; hex 6139585138705043734a6c6e756838736f78523266766c6d; asc a9XQ8pPCsJlnuh8soxR2fvlm;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 76554d35797164384f324542524f32693770647077546274756358704e48; asc vUM5yqd8O2EBRO2i7pdpwTbtucXpNH; (total 42 bytes);

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 633 page no 910 n bits 120 index `PRIMARY` of table `tpcc`.`stock` trx id 40112 lock mode S locks rec but not gap waiting
Record lock, heap no 12 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80009e00; asc     ;;
 2: len 6; hex 000000009cc4; asc       ;;
 3: len 7; hex 0a0000020c1581; asc        ;;
 4: len 2; hex 8048; asc  H;;
 5: len 24; hex 526a716d7658646b6c70754b6a76576f5378325272667574; asc RjqmvXdklpuKjvWoSx2Rrfut;;
 6: len 24; hex 317859523049736a39636665454e4e3346686d3942616237; asc 1xYR0Isj9cfeENN3Fhm9Bab7;;
 7: len 24; hex 327944787148776e6f4e6c34455642713870345443356a72; asc 2yDxqHwnoNl4EVBq8p4TC5jr;;
 8: len 24; hex 7331515238795434434f73524c64466750497573546a304a; asc s1QR8yT4COsRLdFgPIusTj0J;;
 9: len 24; hex 525472384a69304936504f35745148464a67617775464a43; asc RTr8Ji0I6PO5tQHFJgawuFJC;;
 10: len 24; hex 42666f397761624f526a6637697843374c48796a57453241; asc Bfo9wabORjf7ixC7LHyjWE2A;;
 11: len 24; hex 78347a4747375175745a7154384373737279596f41643750; asc x4zGG7QutZqT8CssryYoAd7P;;
 12: len 24; hex 70746f7233596d3859314d645247573035793948717a396d; asc ptor3Ym8Y1MdRGW05y9Hqz9m;;
 13: len 24; hex 767538314a6971415766433351495a526541737465737963; asc vu81JiqAWfC3QIZReAstesyc;;
 14: len 24; hex 4452794b4454473663464e4b335970676b7336325058655a; asc DRyKDTG6cFNK3Ypgks62PXeZ;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 584447546f4668464331516646574653756156514e4341444941636f6f42; asc XDGToFhFC1QfFWFSuaVQNCADIAcooB; (total 38 bytes);

*** WE ROLL BACK TRANSACTION (1)
------------
TRANSACTIONS
------------
Trx id counter 42325
Purge done for trx\'s n:o < 42325 undo n:o < 0 state: running but idle
History list length 958
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 0, not started
MySQL thread id 33, OS thread handle 0x7fe6628b9700, query id 815971 localhost root init
SHOW ENGINE INNODB STATUS
--------
FILE I/O
--------
I/O thread 0 state: waiting for completed aio requests (insert buffer thread)
I/O thread 1 state: waiting for completed aio requests (log thread)
I/O thread 2 state: waiting for completed aio requests (read thread)
I/O thread 3 state: waiting for completed aio requests (read thread)
I/O thread 4 state: waiting for completed aio requests (read thread)
I/O thread 5 state: waiting for completed aio requests (read thread)
I/O thread 6 state: waiting for completed aio requests (write thread)
I/O thread 7 state: waiting for completed aio requests (write thread)
I/O thread 8 state: waiting for completed aio requests (write thread)
I/O thread 9 state: waiting for completed aio requests (write thread)
Pending normal aio reads: 0 [0, 0, 0, 0] , aio writes: 0 [0, 0, 0, 0] ,
 ibuf aio reads: 0, log i/o\'s: 0, sync i/o\'s: 0
Pending flushes (fsync) log: 0; buffer pool: 0
3761 OS file reads, 22388 OS file writes, 6375 OS fsyncs
6.12 reads/s, 16384 avg bytes/read, 211.74 writes/s, 20.06 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 2093, seg size 2095, 123 merges
merged operations:
 insert 131, delete mark 0, delete 0
discarded operations:
 insert 74, delete mark 0, delete 0
Hash table size 276671, node heap has 350 buffer(s)
333.04 hash searches/s, 517.34 non-hash searches/s
---
LOG
---
Log sequence number 3173668745
Log flushed up to   3173668745
Pages flushed up to 3171079546
Last checkpoint at  3171079546
0 pending log writes, 0 pending chkp writes
5223 log i/o\'s done, 11.25 log i/o\'s/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total memory allocated 137363456; in additional pool allocated 0
Dictionary memory allocated 138680
Buffer pool size   8191
Free buffers       1024
Database pages     6814
Old database pages 2495
Modified db pages  988
Pending reads 0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 16575, not young 520146
15.44 youngs/s, 19.56 non-youngs/s
Pages read 3713, created 9158, written 16308
6.12 reads/s, 0.31 creates/s, 196.61 writes/s
Buffer pool hit rate 998 / 1000, young-making rate 5 / 1000 not 6 / 1000
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 6814, unzip_LRU len: 0
I/O sum[12165]:cur[0], unzip sum[3]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
0 read views open inside InnoDB
Main thread process no. 16678, id 140627468502784, state: sleeping
Number of rows inserted 952813, updated 65571, deleted 2457, read 917702
64.18 inserts/s, 133.37 updates/s, 5.12 deletes/s, 552.22 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
',
            'Name' => ''
          }
        ];

$mysql57 = [
          {
            'Type' => 'InnoDB',
            'Status' => '
=====================================
2019-07-11 18:33:55 0x7fcc9c0d3700 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 17 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 115 srv_active, 0 srv_shutdown, 705036 srv_idle
srv_master_thread log flush and writes: 705110
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 1454
OS WAIT ARRAY INFO: signal count 2016
RW-shared spins 0, rounds 1762, OS waits 553
RW-excl spins 0, rounds 8206, OS waits 231
RW-sx spins 67, rounds 1580, OS waits 28
Spin rounds per wait: 1762.00 RW-shared, 8206.00 RW-excl, 23.58 RW-sx
------------------------
LATEST DETECTED DEADLOCK
------------------------
2019-07-11 18:33:38 0x7fcc9c115700
*** (1) TRANSACTION:
TRANSACTION 14614, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 18 lock struct(s), heap size 1136, 11 row lock(s), undo log entries 24
MySQL thread id 11, OS thread handle 140516770600704, query id 777570 localhost root statistics
SELECT s_quantity, s_data, s_dist_01, s_dist_02, s_dist_03, s_dist_04, s_dist_05, s_dist_06, s_dist_07, s_dist_08, s_dist_09, s_dist_10 FROM stock WHERE s_i_id = 58826 AND s_w_id = 1 FOR UPDATE
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 34 page no 1259 n bits 120 index PRIMARY of table `tpcc`.`stock` trx id 14614 lock_mode X locks rec but not gap waiting
Record lock, heap no 4 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5ca; asc     ;;
 2: len 6; hex 000000000930; asc      0;;
 3: len 7; hex ac000001dc19c9; asc        ;;
 4: len 2; hex 8014; asc   ;;
 5: len 24; hex 3159586864784d4833626d5366364b7830354c4e4b663173; asc 1YXhdxMH3bmSf6Kx05LNKf1s;;
 6: len 24; hex 475663797967795542663736304e395a3961434473414478; asc GVcyygyUBf760N9Z9aCDsADx;;
 7: len 24; hex 5947415a38436e626d6b5a516931634c39674a556f72624f; asc YGAZ8CnbmkZQi1cL9gJUorbO;;
 8: len 24; hex 70474430426a58527234583173386e63664549686f646f55; asc pGD0BjXRr4X1s8ncfEIhodoU;;
 9: len 24; hex 49496d74657067733366346b435462457a6236374f676e61; asc IImtepgs3f4kCTbEzb67Ogna;;
 10: len 24; hex 534f614772565739484e6f36326537686972724152353932; asc SOaGrVW9HNo62e7hirrAR592;;
 11: len 24; hex 454f71317a70524e50664573424d395838445a6d4c475441; asc EOq1zpRNPfEsBM9X8DZmLGTA;;
 12: len 24; hex 6462416b644b793042797a79504b4e355a4645744d6c7a5a; asc dbAkdKy0ByzyPKN5ZFEtMlzZ;;
 13: len 24; hex 6c75594335646e656f584736554748534646705a6173366e; asc luYC5dneoXG6UGHSFFpZas6n;;
 14: len 24; hex 78397177683967626671654a654a35395a42646e52333265; asc x9qwh9gbfqeJeJ59ZBdnR32e;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 5a466a65307162386659706f43515432336b674b706f727a52654f546532; asc ZFje0qb8fYpoCQT23kgKporzReOTe2; (total 36 bytes);

*** (2) TRANSACTION:
TRANSACTION 14529, ACTIVE 0 sec inserting
mysql tables in use 2, locked 2
2140 lock struct(s), heap size 205008, 23419 row lock(s), undo log entries 11443
MySQL thread id 18, OS thread handle 140516768438016, query id 776218 localhost root Sending data
INSERT LOW_PRIORITY IGNORE INTO `tpcc`.`_order_line_new` (`ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info`) SELECT `ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info` FROM `tpcc`.`order_line` FORCE INDEX(`PRIMARY`) WHERE ((`ol_w_id` > \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` > \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` > \'786\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'786\' AND `ol_number` >= \'12\')) AND ((`ol_w_id` < \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` < \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` < \'2648\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'2648\' AND `ol_number` <= \'6\')) LOCK IN SHARE MODE /*pt-online-schema-change 24724 copy nibble*/
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 34 page no 1259 n bits 120 index PRIMARY of table `tpcc`.`stock` trx id 14529 lock mode S locks rec but not gap
Record lock, heap no 4 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5ca; asc     ;;
 2: len 6; hex 000000000930; asc      0;;
 3: len 7; hex ac000001dc19c9; asc        ;;
 4: len 2; hex 8014; asc   ;;
 5: len 24; hex 3159586864784d4833626d5366364b7830354c4e4b663173; asc 1YXhdxMH3bmSf6Kx05LNKf1s;;
 6: len 24; hex 475663797967795542663736304e395a3961434473414478; asc GVcyygyUBf760N9Z9aCDsADx;;
 7: len 24; hex 5947415a38436e626d6b5a516931634c39674a556f72624f; asc YGAZ8CnbmkZQi1cL9gJUorbO;;
 8: len 24; hex 70474430426a58527234583173386e63664549686f646f55; asc pGD0BjXRr4X1s8ncfEIhodoU;;
 9: len 24; hex 49496d74657067733366346b435462457a6236374f676e61; asc IImtepgs3f4kCTbEzb67Ogna;;
 10: len 24; hex 534f614772565739484e6f36326537686972724152353932; asc SOaGrVW9HNo62e7hirrAR592;;
 11: len 24; hex 454f71317a70524e50664573424d395838445a6d4c475441; asc EOq1zpRNPfEsBM9X8DZmLGTA;;
 12: len 24; hex 6462416b644b793042797a79504b4e355a4645744d6c7a5a; asc dbAkdKy0ByzyPKN5ZFEtMlzZ;;
 13: len 24; hex 6c75594335646e656f584736554748534646705a6173366e; asc luYC5dneoXG6UGHSFFpZas6n;;
 14: len 24; hex 78397177683967626671654a654a35395a42646e52333265; asc x9qwh9gbfqeJeJ59ZBdnR32e;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 5a466a65307162386659706f43515432336b674b706f727a52654f546532; asc ZFje0qb8fYpoCQT23kgKporzReOTe2; (total 36 bytes);

Record lock, heap no 9 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5cf; asc     ;;
 2: len 6; hex 000000000930; asc      0;;
 3: len 7; hex ac000001dc1a1e; asc        ;;
 4: len 2; hex 801a; asc   ;;
 5: len 24; hex 3673515a57644330655953576542704779584942456f6d42; asc 6sQZWdC0eYSWeBpGyXIBEomB;;
 6: len 24; hex 6b7a65455165494935736d69346b4b614371454e65554a39; asc kzeEQeII5smi4kKaCqENeUJ9;;
 7: len 24; hex 554e6245576479554841757754437a4a77664c673076716f; asc UNbEWdyUHAuwTCzJwfLg0vqo;;
 8: len 24; hex 42516355584e777478414e61377273486c6d69766c31724f; asc BQcUXNwtxANa7rsHlmivl1rO;;
 9: len 24; hex 564d474c394f575a3030354f75794c354c7643446c527758; asc VMGL9OWZ005OuyL5LvCDlRwX;;
 10: len 24; hex 714739686655427a6b5738363169367a6e53756a6e7a3468; asc qG9hfUBzkW861i6znSujnz4h;;
 11: len 24; hex 465161417769304371667049716e324e76364f62434e4f64; asc FQaAwi0CqfpIqn2Nv6ObCNOd;;
 12: len 24; hex 354f4538354e4e577756536356635339516b7a446b4b3871; asc 5OE85NNWwVScVcS9QkzDkK8q;;
 13: len 24; hex 69313236654a41325749367264616c39304f63616f6c7958; asc i126eJA2WI6rdal90OcaolyX;;
 14: len 24; hex 39463347346979336b326633436658556c50384a38484a57; asc 9F3G4iy3k2f3CfXUlP8J8HJW;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 29; hex 734a6271714b30334c47373345416e476e7054544d76456a335771496e; asc sJbqqK03LG73EAnGnpTTMvEj3WqIn;;

Record lock, heap no 20 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5da; asc     ;;
 2: len 6; hex 000000000930; asc      0;;
 3: len 7; hex ac000001dc1ad9; asc        ;;
 4: len 2; hex 8038; asc  8;;
 5: len 24; hex 6b4550554d6e3251514a5539684a4346556364586d446866; asc kEPUMn2QQJU9hJCFUcdXmDhf;;
 6: len 24; hex 4e33746d6c76557a4b794a35306a544942637a536e43784e; asc N3tmlvUzKyJ50jTIBczSnCxN;;
 7: len 24; hex 53397a386d7656716f465a686a5931677034655958776b38; asc S9z8mvVqoFZhjY1gp4eYXwk8;;
 8: len 24; hex 43763637477561507467396d3978594f57463532476c7249; asc Cv67GuaPtg9m9xYOWF52GlrI;;
 9: len 24; hex 4f6f4b3677434970494f354177533163626d6a5a4b373361; asc OoK6wCIpIO5AwS1cbmjZK73a;;
 10: len 24; hex 366f7778374b4c766352706f696536346845303945616930; asc 6owx7KLvcRpoie64hE09Eai0;;
 11: len 24; hex 464b4f4a73595068554b6d6d6568503355446c36496e6e57; asc FKOJsYPhUKmmehP3UDl6InnW;;
 12: len 24; hex 75694a6169616f317937745655597a6d4b6b517a3955544d; asc uiJaiao1y7tVUYzmKkQz9UTM;;
 13: len 24; hex 5a657a4b396b4372346e5965625862675136417a33754a6e; asc ZezK9kCr4nYebXbgQ6Az3uJn;;
 14: len 24; hex 4a776e6b4a794b767863346970756b63514f427878724e33; asc JwnkJyKvxc4ipukcQOBxxrN3;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 28; hex 4b37726375437472786438757631725934584c7946764f63364a5a76; asc K7rcuCtrxd8uv1rY4XLyFvOc6JZv;;

Record lock, heap no 23 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5dd; asc     ;;
 2: len 6; hex 000000003136; asc     16;;
 3: len 7; hex 530000021827b9; asc S    \' ;;
 4: len 2; hex 8026; asc  &;;
 5: len 24; hex 466f52484e77756d74614f5334534b666161494e6d6a7652; asc FoRHNwumtaOS4SKfaaINmjvR;;
 6: len 24; hex 73464c767a77386e4e4f414a497842714a62766c76614c54; asc sFLvzw8nNOAJIxBqJbvlvaLT;;
 7: len 24; hex 67476162685353756e4c756855683571734d366e56783636; asc gGabhSSunLuhUh5qsM6nVx66;;
 8: len 24; hex 7032514156476f6a6f4f4f45714a7a42426864716b546734; asc p2QAVGojoOOEqJzBBhdqkTg4;;
 9: len 24; hex 54615858674e4d676e55413148746f66473256583265696a; asc TaXXgNMgnUA1HtofG2VX2eij;;
 10: len 24; hex 59526a46564a67356f456b395951773361774b536b78696d; asc YRjFVJg5oEk9YQw3awKSkxim;;
 11: len 24; hex 466d3476564d52773665514e4c564158464a336545344541; asc Fm4vVMRw6eQNLVAXFJ3eE4EA;;
 12: len 24; hex 67734a4d656a62526f55753877704561466174696b4f7933; asc gsJMejbRoUu8wpEaFatikOy3;;
 13: len 24; hex 6348576f5074544843707577504a6b7442716e30354f4464; asc cHWoPtTHCpuwPJktBqn05ODd;;
 14: len 24; hex 774e65734f36536561453352684a655844597557476c6636; asc wNesO6SeaE3RhJeXDYuWGlf6;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 673976726d416c376f6455733338524939737a53555564304d3747386e4c; asc g9vrmAl7odUs38RI9szSUUd0M7G8nL; (total 39 bytes);

Record lock, heap no 26 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5e0; asc     ;;
 2: len 6; hex 000000000930; asc      0;;
 3: len 7; hex ac000001dc1b3f; asc       ?;;
 4: len 2; hex 802b; asc  +;;
 5: len 24; hex 4d6d7033314b477637434443496d7146704466514647324e; asc Mmp31KGv7CDCImqFpDfQFG2N;;
 6: len 24; hex 44556168754731673634674f4b6256556d696e5757304b6b; asc DUahuG1g64gOKbVUminWW0Kk;;
 7: len 24; hex 6b7a746d4d66786f46656756644c5a683179306354554e39; asc kztmMfxoFegVdLZh1y0cTUN9;;
 8: len 24; hex 746746444f73774e6d6768526556654739377555685a5666; asc tgFDOswNmghReVeG97uUhZVf;;
 9: len 24; hex 3836325445484d755659474e536437384b576b6e41317749; asc 862TEHMuVYGNSd78KWknA1wI;;
 10: len 24; hex 527a53776330326932567748716f6b4d34386f6644757a6b; asc RzSwc02i2VwHqokM48ofDuzk;;
 11: len 24; hex 6b7565684156363778306a78315178554b464b397a654235; asc kuehAV67x0jx1QxUKFK9zeB5;;
 12: len 24; hex 72484a6f3177587461433435494230477477484a746d6436; asc rHJo1wXtaC45IB0GtwHJtmd6;;
 13: len 24; hex 6b346a7539376a4f5156504d324875454c785555796c4e75; asc k4ju97jOQVPM2HuELxUUylNu;;
 14: len 24; hex 656c6d47737279775973336462533437704f3736484b5045; asc elmGsrywYs3dbS47pO76HKPE;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 754158463257736f4938653736596478624859314c6472686a7679334c42; asc uAXF2WsoI8e76YdxbHY1Ldrhjvy3LB; (total 35 bytes);

Record lock, heap no 30 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5e4; asc     ;;
 2: len 6; hex 0000000026e0; asc     & ;;
 3: len 7; hex 29000001521aed; asc )   R  ;;
 4: len 2; hex 804c; asc  L;;
 5: len 24; hex 31566a694750486b4956366e6d35595262524d6f69635133; asc 1VjiGPHkIV6nm5YRbRMoicQ3;;
 6: len 24; hex 324d466b4a4e6b6e365333566b6e6d44725a7877374d5857; asc 2MFkJNkn6S3VknmDrZxw7MXW;;
 7: len 24; hex 4b43496b47696d617658754948684f686b73505665614b42; asc KCIkGimavXuIHhOhksPVeaKB;;
 8: len 24; hex 4747736d6e59367a70714656627152366b684c5034303777; asc GGsmnY6zpqFVbqR6khLP407w;;
 9: len 24; hex 635979776a55417a4b776d71326b64727a39516e59575646; asc cYywjUAzKwmq2kdrz9QnYWVF;;
 10: len 24; hex 754a70314446626c4356536767517961436d64755153755a; asc uJp1DFblCVSggQyaCmduQSuZ;;
 11: len 24; hex 68374d444d4235653037724567625143333471543051656d; asc h7MDMB5e07rEgbQC34qT0Qem;;
 12: len 24; hex 594354536c4a3871644a426f4f706e54657a4146504b4a52; asc YCTSlJ8qdJBoOpnTezAFPKJR;;
 13: len 24; hex 6b52594f4459764f7a4c37485479756b3768377555615954; asc kRYODYvOzL7HTyuk7h7uUaYT;;
 14: len 24; hex 6d71303346366e6766417242354641514c5273484b614f31; asc mq03F6ngfArB5FAQLRsHKaO1;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 4754476d7577596b76627a314e646556537059677977314e6f49684e6569; asc GTGmuwYkvbz1NdeVSpYgyw1NoIhNei; (total 35 bytes);

Record lock, heap no 34 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5e8; asc     ;;
 2: len 6; hex 000000000930; asc      0;;
 3: len 7; hex ac000001dc1bc7; asc        ;;
 4: len 2; hex 8017; asc   ;;
 5: len 24; hex 535867656342726350316a55504534654e323935525a4b76; asc SXgecBrcP1jUPE4eN295RZKv;;
 6: len 24; hex 4949656e413944677073473068714e675a71346c75693975; asc IIenA9DgpsG0hqNgZq4lui9u;;
 7: len 24; hex 454d4f58464270587061677a6e4b6d64616c4a52367a7977; asc EMOXFBpXpagznKmdalJR6zyw;;
 8: len 24; hex 6b726a746a5a353376634936526f75315372706d64514d4d; asc krjtjZ53vcI6Rou1SrpmdQMM;;
 9: len 24; hex 6c546a694e6b5343554a77314f7a7731473151327453556b; asc lTjiNkSCUJw1Ozw1G1Q2tSUk;;
 10: len 24; hex 474c666169504d393634577155684b6e644c396147387146; asc GLfaiPM964WqUhKndL9aG8qF;;
 11: len 24; hex 71387a4b734559427439724756304d5856443143566d6e72; asc q8zKsEYBt9rGV0MXVD1CVmnr;;
 12: len 24; hex 4e353243495a3251594c476d745064324875564645326b52; asc N52CIZ2QYLGmtPd2HuVFE2kR;;
 13: len 24; hex 75786c686d6433706644374346566b616a55533835555078; asc uxlhmd3pfD7CFVkajUS85UPx;;
 14: len 24; hex 6643304e623049576a78474d79357a4241425266747a4f4c; asc fC0Nb0IWjxGMy5zBABRftzOL;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 585075754d735a577178366f446359387273377773493531686b74663745; asc XPuuMsZWqx6oDcY8rs7wsI51hktf7E; (total 45 bytes);

Record lock, heap no 39 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 8000e5ed; asc     ;;
 2: len 6; hex 000000001b70; asc      p;;
 3: len 7; hex 72000001f622c0; asc r    " ;;
 4: len 2; hex 800e; asc   ;;
 5: len 24; hex 4d5344515779366239623454616c6f346d30556b35673071; asc MSDQWy6b9b4Talo4m0Uk5g0q;;
 6: len 24; hex 3733705462487032534559514b385a74413254767157666f; asc 73pTbHp2SEYQK8ZtA2TvqWfo;;
 7: len 24; hex 5172634f687756696c774b326a4b53787173477952393652; asc QrcOhwVilwK2jKSxqsGyR96R;;
 8: len 24; hex 314737683233357567545a6377494c73614c62736e586966; asc 1G7h235ugTZcwILsaLbsnXif;;
 9: len 24; hex 6634756c54546c6a59516d63566547774473715442693357; asc f4ulTTljYQmcVeGwDsqTBi3W;;
 10: len 24; hex 74486f63755a4679533052766c395542743465584b596941; asc tHocuZFyS0Rvl9UBt4eXKYiA;;
 11: len 24; hex 434c3444704d373638683069777941754e336555566e4e5a; asc CL4DpM768h0iwyAuN3eUVnNZ;;
 12: len 24; hex 73747962334e6c4f5077446c31487367486163446958626a; asc styb3NlOPwDl1HsgHacDiXbj;;
 13: len 24; hex 334677526f4f48674c716a67623635574870565a68437146; asc 3FwRoOHgLqjgb65WHpVZhCqF;;
 14: len 24; hex 32764a64655365745035676c4e4d3442356b6e3971485266; asc 2vJdeSetP5glNM4B5kn9qHRf;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 794b776d5a6c6f553250365434307137675a53326565354f504443656570; asc yKwmZloU2P6T40q7gZS2ee5OPDCeep; (total 36 bytes);

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 34 page no 811 n bits 120 index PRIMARY of table `tpcc`.`stock` trx id 14529 lock mode S locks rec but not gap waiting
Record lock, heap no 26 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 800091f5; asc     ;;
 2: len 6; hex 000000003916; asc     9 ;;
 3: len 7; hex 530000015b05da; asc S   [  ;;
 4: len 2; hex 802a; asc  *;;
 5: len 24; hex 42417734307a44725758563178757337326b556232534744; asc BAw40zDrWXV1xus72kUb2SGD;;
 6: len 24; hex 64484c48517853627456627169534b45764d427045487277; asc dHLHQxSbtVbqiSKEvMBpEHrw;;
 7: len 24; hex 517a4265435a4654745775717a54685534584156724f4f42; asc QzBeCZFTtWuqzThU4XAVrOOB;;
 8: len 24; hex 455170334d57554c683656454d7837737276704b63484d37; asc EQp3MWULh6VEMx7srvpKcHM7;;
 9: len 24; hex 72786f47384d53593954746676434b32695a4f6665475559; asc rxoG8MSY9TtfvCK2iZOfeGUY;;
 10: len 24; hex 6d414e38476e794463434a77637134356a6a31763231625a; asc mAN8GnyDcCJwcq45jj1v21bZ;;
 11: len 24; hex 474266696a6a5573356438715a4a516a634e4c53504f3936; asc GBfijjUs5d8qZJQjcNLSPO96;;
 12: len 24; hex 33384f65686e74745262613836534468593245725378536e; asc 38OehnttRba86SDhY2ErSxSn;;
 13: len 24; hex 734365324a3235505168374561796443596c477a7878587a; asc sCe2J25PQh7EaydCYlGzxxXz;;
 14: len 24; hex 4e523670444d684e306867326b3654534266303947436631; asc NR6pDMhN0hg2k6TSBf09GCf1;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 65774e417657584c634d597731767868617a52655172703373774a325a4a; asc ewNAvWXLcMYw1vxhazReQrp3swJ2ZJ; (total 43 bytes);

*** WE ROLL BACK TRANSACTION (1)
------------
TRANSACTIONS
------------
Trx id counter 23553
Purge done for trx\'s n:o < 23549 undo n:o < 0 state: running but idle
History list length 12
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 421992034159344, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
---TRANSACTION 23552, ACTIVE 0 sec
2 lock struct(s), heap size 1136, 1 row lock(s), undo log entries 1
MySQL thread id 11, OS thread handle 140516770600704, query id 903279 localhost root
Trx read view will not see trx with id >= 23552, sees < 23508
---TRANSACTION 23550, ACTIVE (PREPARED) 0 sec
9 lock struct(s), heap size 1136, 17 row lock(s), undo log entries 16
MySQL thread id 15, OS thread handle 140516768978688, query id 903270 localhost root starting
commit
Trx read view will not see trx with id >= 23550, sees < 23504
---TRANSACTION 23548, ACTIVE 0 sec
13 lock struct(s), heap size 1136, 7 row lock(s), undo log entries 10
MySQL thread id 12, OS thread handle 140516770330368, query id 903275 localhost root
Trx read view will not see trx with id >= 23548, sees < 23504
---TRANSACTION 23547, ACTIVE 0 sec inserting
mysql tables in use 1, locked 1
14 lock struct(s), heap size 1136, 8 row lock(s), undo log entries 12
MySQL thread id 9, OS thread handle 140516770871040, query id 903261 localhost root update
INSERT INTO order_line (ol_o_id, ol_d_id, ol_w_id, ol_number, ol_i_id, ol_supply_w_id, ol_quantity, ol_amount, ol_dist_info) VALUES (3374, 5, 1, 5, 38659, 1, 4, 293.76275634765625, \'WoBsbLsTLCgmcJ9UdsFtnlFo\')
Trx read view will not see trx with id >= 23547, sees < 23504
---TRANSACTION 23537, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 10, OS thread handle 140516770060032, query id 903084 localhost root updating
UPDATE warehouse SET w_ytd = w_ytd + 4990 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 26 page no 3 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 23537 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000005bd4; asc     [ ;;
 2: len 7; hex 32000002230110; asc 2   #  ;;
 3: len 8; hex 4f4c686d4c386452; asc OLhmL8dR;;
 4: len 13; hex 534554575438734c6b6d314837; asc SETWT8sLkm1H7;;
 5: len 11; hex 6f73585979746146497476; asc osXYytaFItv;;
 6: len 18; hex 4631696530387154634b5a55664945675a4b; asc F1ie08qTcKZUfIEgZK;;
 7: len 2; hex 4c43; asc LC;;
 8: len 9; hex 353338343232393334; asc 538422934;;
 9: len 2; hex 800e; asc   ;;
 10: len 6; hex 80008945a400; asc    E  ;;

------------------
---TRANSACTION 23525, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 17, OS thread handle 140516768708352, query id 902879 localhost root updating
UPDATE warehouse SET w_ytd = w_ytd + 1198 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 26 page no 3 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 23525 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000005bd4; asc     [ ;;
 2: len 7; hex 32000002230110; asc 2   #  ;;
 3: len 8; hex 4f4c686d4c386452; asc OLhmL8dR;;
 4: len 13; hex 534554575438734c6b6d314837; asc SETWT8sLkm1H7;;
 5: len 11; hex 6f73585979746146497476; asc osXYytaFItv;;
 6: len 18; hex 4631696530387154634b5a55664945675a4b; asc F1ie08qTcKZUfIEgZK;;
 7: len 2; hex 4c43; asc LC;;
 8: len 9; hex 353338343232393334; asc 538422934;;
 9: len 2; hex 800e; asc   ;;
 10: len 6; hex 80008945a400; asc    E  ;;

------------------
---TRANSACTION 23518, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 13, OS thread handle 140516769249024, query id 902753 localhost root updating
UPDATE warehouse SET w_ytd = w_ytd + 2012 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 26 page no 3 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 23518 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000005bd4; asc     [ ;;
 2: len 7; hex 32000002230110; asc 2   #  ;;
 3: len 8; hex 4f4c686d4c386452; asc OLhmL8dR;;
 4: len 13; hex 534554575438734c6b6d314837; asc SETWT8sLkm1H7;;
 5: len 11; hex 6f73585979746146497476; asc osXYytaFItv;;
 6: len 18; hex 4631696530387154634b5a55664945675a4b; asc F1ie08qTcKZUfIEgZK;;
 7: len 2; hex 4c43; asc LC;;
 8: len 9; hex 353338343232393334; asc 538422934;;
 9: len 2; hex 800e; asc   ;;
 10: len 6; hex 80008945a400; asc    E  ;;

------------------
---TRANSACTION 23514, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 14, OS thread handle 140516769789696, query id 902739 localhost root updating
UPDATE warehouse SET w_ytd = w_ytd + 857 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 26 page no 3 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 23514 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000005bd4; asc     [ ;;
 2: len 7; hex 32000002230110; asc 2   #  ;;
 3: len 8; hex 4f4c686d4c386452; asc OLhmL8dR;;
 4: len 13; hex 534554575438734c6b6d314837; asc SETWT8sLkm1H7;;
 5: len 11; hex 6f73585979746146497476; asc osXYytaFItv;;
 6: len 18; hex 4631696530387154634b5a55664945675a4b; asc F1ie08qTcKZUfIEgZK;;
 7: len 2; hex 4c43; asc LC;;
 8: len 9; hex 353338343232393334; asc 538422934;;
 9: len 2; hex 800e; asc   ;;
 10: len 6; hex 80008945a400; asc    E  ;;

------------------
---TRANSACTION 23510, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 16, OS thread handle 140516769519360, query id 902718 localhost root updating
UPDATE warehouse SET w_ytd = w_ytd + 2081 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 26 page no 3 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 23510 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000005bd4; asc     [ ;;
 2: len 7; hex 32000002230110; asc 2   #  ;;
 3: len 8; hex 4f4c686d4c386452; asc OLhmL8dR;;
 4: len 13; hex 534554575438734c6b6d314837; asc SETWT8sLkm1H7;;
 5: len 11; hex 6f73585979746146497476; asc osXYytaFItv;;
 6: len 18; hex 4631696530387154634b5a55664945675a4b; asc F1ie08qTcKZUfIEgZK;;
 7: len 2; hex 4c43; asc LC;;
 8: len 9; hex 353338343232393334; asc 538422934;;
 9: len 2; hex 800e; asc   ;;
 10: len 6; hex 80008945a400; asc    E  ;;

------------------
---TRANSACTION 23508, ACTIVE 0 sec
4 lock struct(s), heap size 1136, 2 row lock(s), undo log entries 2
MySQL thread id 8, OS thread handle 140516771141376, query id 903278 localhost root
Trx read view will not see trx with id >= 23552, sees < 23510
--------
FILE I/O
--------
I/O thread 0 state: waiting for completed aio requests (insert buffer thread)
I/O thread 1 state: waiting for completed aio requests (log thread)
I/O thread 2 state: waiting for completed aio requests (read thread)
I/O thread 3 state: waiting for completed aio requests (read thread)
I/O thread 4 state: waiting for completed aio requests (read thread)
I/O thread 5 state: waiting for completed aio requests (read thread)
I/O thread 6 state: waiting for completed aio requests (write thread)
I/O thread 7 state: waiting for completed aio requests (write thread)
I/O thread 8 state: waiting for completed aio requests (write thread)
I/O thread 9 state: waiting for completed aio requests (write thread)
Pending normal aio reads: [0, 0, 0, 0] , aio writes: [0, 0, 0, 0] ,
 ibuf aio reads:, log i/o\'s:, sync i/o\'s:
Pending flushes (fsync) log: 1; buffer pool: 0
3215 OS file reads, 27759 OS file writes, 10415 OS fsyncs
65.82 reads/s, 16384 avg bytes/read, 418.98 writes/s, 213.52 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 0, seg size 2, 135 merges
merged operations:
 insert 140, delete mark 0, delete 0
discarded operations:
 insert 75, delete mark 0, delete 0
Hash table size 34679, node heap has 5 buffer(s)
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 79 buffer(s)
Hash table size 34679, node heap has 29 buffer(s)
Hash table size 34679, node heap has 0 buffer(s)
Hash table size 34679, node heap has 269 buffer(s)
7378.39 hash searches/s, 9598.96 non-hash searches/s
---
LOG
---
Log sequence number 197516328
Log flushed up to   197510332
Pages flushed up to 182858767
Last checkpoint at  182080854
1 pending log flushes, 0 pending chkp writes
8541 log i/o\'s done, 204.00 log i/o\'s/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total large memory allocated 137428992
Dictionary memory allocated 203203
Buffer pool size   8192
Free buffers       1004
Database pages     6806
Old database pages 2492
Modified db pages  3652
Pending reads      0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 17015, not young 449048
264.69 youngs/s, 1223.99 non-youngs/s
Pages read 3159, created 9047, written 17641
65.82 reads/s, 10.53 creates/s, 210.81 writes/s
Buffer pool hit rate 999 / 1000, young-making rate 5 / 1000 not 23 / 1000
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 6806, unzip_LRU len: 0
I/O sum[12301]:cur[6], unzip sum[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
5 read views open inside InnoDB
Process ID=29058, Main thread ID=140516683405056, state: sleeping
Number of rows inserted 965540, updated 91628, deleted 3464, read 1027385
1586.32 inserts/s, 2256.40 updates/s, 86.35 deletes/s, 10414.33 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
',
            'Name' => ''
          }
        ];

$mysql80 = [
          {
            'Type' => 'InnoDB',
            'Status' => '
=====================================
2019-07-11 18:42:57 0x7fe4600f9700 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 52 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 276 srv_active, 0 srv_shutdown, 3744895 srv_idle
srv_master_thread log flush and writes: 0
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 1151
OS WAIT ARRAY INFO: signal count 1294
RW-shared spins 510, rounds 702, OS waits 209
RW-excl spins 282, rounds 4310, OS waits 110
RW-sx spins 19, rounds 562, OS waits 15
Spin rounds per wait: 1.38 RW-shared, 15.28 RW-excl, 29.58 RW-sx
------------------------
LATEST DETECTED DEADLOCK
------------------------
2019-07-11 18:42:40 0x7fe4600b1700
*** (1) TRANSACTION:
TRANSACTION 258347, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 24 lock struct(s), heap size 1136, 17 row lock(s), undo log entries 39
MySQL thread id 251, OS thread handle 140618303547136, query id 665165 localhost tpcc statistics
SELECT s_quantity, s_data, s_dist_01, s_dist_02, s_dist_03, s_dist_04, s_dist_05, s_dist_06, s_dist_07, s_dist_08, s_dist_09, s_dist_10 FROM stock WHERE s_i_id = 77054 AND s_w_id = 1 FOR UPDATE
*** (1) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 101 page no 1705 n bits 120 index PRIMARY of table `tpcc`.`stock` trx id 258347 lock_mode X locks rec but not gap waiting
Record lock, heap no 3 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80012cfe; asc   , ;;
 2: len 6; hex 00000003ecb6; asc       ;;
 3: len 7; hex 82000001f4096e; asc       n;;
 4: len 2; hex 8051; asc  Q;;
 5: len 24; hex 5963617353594768716865655041754a344c75366f49534c; asc YcasSYGhqheePAuJ4Lu6oISL;;
 6: len 24; hex 574e63514b6f7a764f704e7534326a6c674c427044537458; asc WNcQKozvOpNu42jlgLBpDStX;;
 7: len 24; hex 784c6450664e7632794d4b6b4a4636366130416168754630; asc xLdPfNv2yMKkJF66a0AahuF0;;
 8: len 24; hex 344556786a7073345148686d416a6b5532556e4661756f59; asc 4EVxjps4QHhmAjkU2UnFauoY;;
 9: len 24; hex 4f457762437a6651556139495343696a74557362434d6267; asc OEwbCzfQUa9ISCijtUsbCMbg;;
 10: len 24; hex 6f4532636c347a7a7a6142794561526f686a487452796c75; asc oE2cl4zzzaByEaRohjHtRylu;;
 11: len 24; hex 4d3644786e4c6a7a4e4d6b504a684f72724c35526d753656; asc M6DxnLjzNMkPJhOrrL5Rmu6V;;
 12: len 24; hex 7975396a6f303376423067576a6474334d474d3364437579; asc yu9jo03vB0gWjdt3MGM3dCuy;;
 13: len 24; hex 4a6b4251444d4d3755357553386e643652396e3430725147; asc JkBQDMM7U5uS8nd6R9n40rQG;;
 14: len 24; hex 53724c4b7064655a6f326b394f7362526d335a5a6566306c; asc SrLKpdeZo2k9OsbRm3ZZef0l;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 326a4652785074706b44654e70434372774a446f75655976423558713347; asc 2jFRxPtpkDeNpCCrwJDoueYvB5Xq3G; (total 46 bytes);

*** (2) TRANSACTION:
TRANSACTION 258314, ACTIVE 1 sec fetching rows
mysql tables in use 2, locked 2
2083 lock struct(s), heap size 221392, 13230 row lock(s), undo log entries 6234
MySQL thread id 245, OS thread handle 140618840610560, query id 664371 localhost root Sending data
INSERT LOW_PRIORITY IGNORE INTO `tpcc`.`_order_line_new` (`ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info`) SELECT `ol_o_id`, `ol_d_id`, `ol_w_id`, `ol_number`, `ol_i_id`, `ol_supply_w_id`, `ol_delivery_d`, `ol_quantity`, `ol_amount`, `ol_dist_info` FROM `tpcc`.`order_line` FORCE INDEX(`PRIMARY`) WHERE ((`ol_w_id` > \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` > \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` > \'2372\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'2372\' AND `ol_number` >= \'4\')) AND ((`ol_w_id` < \'1\') OR (`ol_w_id` = \'1\' AND `ol_d_id` < \'10\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` < \'3014\') OR (`ol_w_id` = \'1\' AND `ol_d_id` = \'10\' AND `ol_o_id` = \'3014\' AND `ol_number` <= \'15\')) LOCK IN SHARE MODE /*pt-online-schema-change 25595 copy nibble*/
*** (2) HOLDS THE LOCK(S):
RECORD LOCKS space id 101 page no 1705 n bits 120 index PRIMARY of table `tpcc`.`stock` trx id 258314 lock mode S locks rec but not gap
Record lock, heap no 3 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80012cfe; asc   , ;;
 2: len 6; hex 00000003ecb6; asc       ;;
 3: len 7; hex 82000001f4096e; asc       n;;
 4: len 2; hex 8051; asc  Q;;
 5: len 24; hex 5963617353594768716865655041754a344c75366f49534c; asc YcasSYGhqheePAuJ4Lu6oISL;;
 6: len 24; hex 574e63514b6f7a764f704e7534326a6c674c427044537458; asc WNcQKozvOpNu42jlgLBpDStX;;
 7: len 24; hex 784c6450664e7632794d4b6b4a4636366130416168754630; asc xLdPfNv2yMKkJF66a0AahuF0;;
 8: len 24; hex 344556786a7073345148686d416a6b5532556e4661756f59; asc 4EVxjps4QHhmAjkU2UnFauoY;;
 9: len 24; hex 4f457762437a6651556139495343696a74557362434d6267; asc OEwbCzfQUa9ISCijtUsbCMbg;;
 10: len 24; hex 6f4532636c347a7a7a6142794561526f686a487452796c75; asc oE2cl4zzzaByEaRohjHtRylu;;
 11: len 24; hex 4d3644786e4c6a7a4e4d6b504a684f72724c35526d753656; asc M6DxnLjzNMkPJhOrrL5Rmu6V;;
 12: len 24; hex 7975396a6f303376423067576a6474334d474d3364437579; asc yu9jo03vB0gWjdt3MGM3dCuy;;
 13: len 24; hex 4a6b4251444d4d3755357553386e643652396e3430725147; asc JkBQDMM7U5uS8nd6R9n40rQG;;
 14: len 24; hex 53724c4b7064655a6f326b394f7362526d335a5a6566306c; asc SrLKpdeZo2k9OsbRm3ZZef0l;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 326a4652785074706b44654e70434372774a446f75655976423558713347; asc 2jFRxPtpkDeNpCCrwJDoueYvB5Xq3G; (total 46 bytes);

Record lock, heap no 11 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80012d06; asc   - ;;
 2: len 6; hex 00000003ecb6; asc       ;;
 3: len 7; hex 82000001f409fe; asc        ;;
 4: len 2; hex 8032; asc  2;;
 5: len 24; hex 484e6d4351786653613177685a7254786f75584a77504c4b; asc HNmCQxfSa1whZrTxouXJwPLK;;
 6: len 24; hex 676154375074506e645a445943663945616f6c5247694641; asc gaT7PtPndZDYCf9EaolRGiFA;;
 7: len 24; hex 573763735063577a33634f75314259594e34693044776130; asc W7csPcWz3cOu1BYYN4i0Dwa0;;
 8: len 24; hex 7a474e4351616a56415a756c33726f664568674e44436b48; asc zGNCQajVAZul3rofEhgNDCkH;;
 9: len 24; hex 6c54704a54564a6a7156375043625a6c564b704c37555a6d; asc lTpJTVJjqV7PCbZlVKpL7UZm;;
 10: len 24; hex 777a4a6847455168326a385830704c57766b67574b513163; asc wzJhGEQh2j8X0pLWvkgWKQ1c;;
 11: len 24; hex 4d686874546f71533856684b764d4d635672644944374476; asc MhhtToqS8VhKvMMcVrdID7Dv;;
 12: len 24; hex 6a44446a71513356387878756e4e3047324c4250666c7356; asc jDDjqQ3V8xxunN0G2LBPflsV;;
 13: len 24; hex 4167564f6248377055716476753631703374635275735444; asc AgVObH7pUqdvu61p3tcRusTD;;
 14: len 24; hex 71716d694c397231634662744b4f4d393146313545713937; asc qqmiL9r1cFbtKOM91F15Eq97;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 28; hex 597a497a4348713331574f414e4f6c637863764c79344b4435505076; asc YzIzCHq31WOANOlcxcvLy4KD5PPv;;

Record lock, heap no 13 PHYSICAL RECORD: n_fields 19; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 4; hex 80012d08; asc   - ;;
 2: len 6; hex 00000003ecb6; asc       ;;
 3: len 7; hex 82000001f40a22; asc       ";;
 4: len 2; hex 8058; asc  X;;
 5: len 24; hex 474e4b6577486550576f36313338395835686d4c30716d77; asc GNKewHePWo61389X5hmL0qmw;;
 6: len 24; hex 665a61623230705149544b5a366a33756f35767543527874; asc fZab20pQITKZ6j3uo5vuCRxt;;
 7: len 24; hex 497232326e53664e33454e31336c4a563673626e76546279; asc Ir22nSfN3EN13lJV6sbnvTby;;
 8: len 24; hex 55416d5234786974786b684f4f325063505167396a42465a; asc UAmR4xitxkhOO2PcPQg9jBFZ;;
 9: len 24; hex 325342635257345a4956624544564277435a4b4379755a4d; asc 2SBcRW4ZIVbEDVBwCZKCyuZM;;
 10: len 24; hex 69336a76635277336259533763314f35646148386c42494a; asc i3jvcRw3bYS7c1O5daH8lBIJ;;
 11: len 24; hex 53464e3163776964666447355a4867356a6c6669376c4c68; asc SFN1cwidfdG5ZHg5jlfi7lLh;;
 12: len 24; hex 52524468696739783139587872426253506730674b354e33; asc RRDhig9x19XxrBbSPg0gK5N3;;
 13: len 24; hex 35425550715571486659784a66764b6f5149645a72347756; asc 5BUPqUqHfYxJfvKoQIdZr4wV;;
 14: len 24; hex 617037787173317a4b51716f4735526d336b537733454b4a; asc ap7xqs1zKQqoG5Rm3kSw3EKJ;;
 15: len 4; hex 80000000; asc     ;;
 16: len 2; hex 8000; asc   ;;
 17: len 2; hex 8000; asc   ;;
 18: len 30; hex 7341756f66775053334b49754c49456c38313042536d4542434145505658; asc sAuofwPS3KIuLIEl810BSmEBCAEPVX; (total 39 bytes);

*** (2) WAITING FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 99 page no 2368 n bits 176 index PRIMARY of table `tpcc`.`order_line` trx id 258314 lock mode S waiting
Record lock, heap no 93 PHYSICAL RECORD: n_fields 12; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 1; hex 8a; asc  ;;
 2: len 4; hex 80000bc7; asc     ;;
 3: len 1; hex 81; asc  ;;
 4: len 6; hex 00000003f12b; asc      +;;
 5: len 7; hex 82000000970134; asc       4;;
 6: len 4; hex 80003a03; asc   : ;;
 7: len 2; hex 8001; asc   ;;
 8: SQL NULL;
 9: len 1; hex 88; asc  ;;
 10: len 3; hex 81ce29; asc   );;
 11: len 24; hex 42316b53556a7a69357a656b65326e5a7a4178686c433073; asc B1kSUjzi5zeke2nZzAxhlC0s;;

*** WE ROLL BACK TRANSACTION (1)
------------
TRANSACTIONS
------------
Trx id counter 265202
Purge done for trx\'s n:o < 265198 undo n:o < 0 state: running but idle
History list length 51
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 422093860472624, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
---TRANSACTION 265201, ACTIVE 0 sec
11 lock struct(s), heap size 1136, 5 row lock(s), undo log entries 7
MySQL thread id 249, OS thread handle 140617430595328, query id 759791 localhost tpcc Opening tables
SELECT s_quantity, s_data, s_dist_01, s_dist_02, s_dist_03, s_dist_04, s_dist_05, s_dist_06, s_dist_07, s_dist_08, s_dist_09, s_dist_10 FROM stock WHERE s_i_id = 40184 AND s_w_id = 1 FOR UPDATE
Trx read view will not see trx with id >= 265201, sees < 265171
---TRANSACTION 265199, ACTIVE (PREPARED) 0 sec
9 lock struct(s), heap size 1136, 15 row lock(s), undo log entries 14
MySQL thread id 247, OS thread handle 140618840315648, query id 759765 localhost tpcc waiting for handler commit
commit
Trx read view will not see trx with id >= 265199, sees < 265165
---TRANSACTION 265197, ACTIVE (PREPARED) 0 sec
19 lock struct(s), heap size 1136, 13 row lock(s), undo log entries 21
MySQL thread id 256, OS thread handle 140618303842048, query id 759763 localhost tpcc waiting for handler commit
commit
Trx read view will not see trx with id >= 265197, sees < 265165
---TRANSACTION 265195, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 254, OS thread handle 140618304136960, query id 759705 localhost tpcc updating
UPDATE warehouse SET w_ytd = w_ytd + 1459 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 93 page no 4 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 265195 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000040bd3; asc       ;;
 2: len 7; hex 010000017e1cd9; asc     ~  ;;
 3: len 7; hex 6d55356a716755; asc mU5jqgU;;
 4: len 10; hex 6b3562506d657a4e4350; asc k5bPmezNCP;;
 5: len 15; hex 6d4a50314d4d6230696a644a54354f; asc mJP1MMb0ijdJT5O;;
 6: len 14; hex 763266636e6b4541587141753058; asc v2fcnkEAXqAu0X;;
 7: len 2; hex 6d72; asc mr;;
 8: len 9; hex 363339313139353233; asc 639119523;;
 9: len 2; hex 800f; asc   ;;
 10: len 6; hex 800034885500; asc   4 U ;;

------------------
---TRANSACTION 265193, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 250, OS thread handle 140618305021696, query id 759663 localhost tpcc updating
UPDATE warehouse SET w_ytd = w_ytd + 208 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 93 page no 4 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 265193 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000040bd3; asc       ;;
 2: len 7; hex 010000017e1cd9; asc     ~  ;;
 3: len 7; hex 6d55356a716755; asc mU5jqgU;;
 4: len 10; hex 6b3562506d657a4e4350; asc k5bPmezNCP;;
 5: len 15; hex 6d4a50314d4d6230696a644a54354f; asc mJP1MMb0ijdJT5O;;
 6: len 14; hex 763266636e6b4541587141753058; asc v2fcnkEAXqAu0X;;
 7: len 2; hex 6d72; asc mr;;
 8: len 9; hex 363339313139353233; asc 639119523;;
 9: len 2; hex 800f; asc   ;;
 10: len 6; hex 800034885500; asc   4 U ;;

------------------
---TRANSACTION 265188, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 253, OS thread handle 140617430300416, query id 759587 localhost tpcc updating
UPDATE warehouse SET w_ytd = w_ytd + 739 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 93 page no 4 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 265188 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000040bd3; asc       ;;
 2: len 7; hex 010000017e1cd9; asc     ~  ;;
 3: len 7; hex 6d55356a716755; asc mU5jqgU;;
 4: len 10; hex 6b3562506d657a4e4350; asc k5bPmezNCP;;
 5: len 15; hex 6d4a50314d4d6230696a644a54354f; asc mJP1MMb0ijdJT5O;;
 6: len 14; hex 763266636e6b4541587141753058; asc v2fcnkEAXqAu0X;;
 7: len 2; hex 6d72; asc mr;;
 8: len 9; hex 363339313139353233; asc 639119523;;
 9: len 2; hex 800f; asc   ;;
 10: len 6; hex 800034885500; asc   4 U ;;

------------------
---TRANSACTION 265183, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 248, OS thread handle 140618841200384, query id 759576 localhost tpcc updating
UPDATE warehouse SET w_ytd = w_ytd + 3132 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 93 page no 4 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 265183 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000040bd3; asc       ;;
 2: len 7; hex 010000017e1cd9; asc     ~  ;;
 3: len 7; hex 6d55356a716755; asc mU5jqgU;;
 4: len 10; hex 6b3562506d657a4e4350; asc k5bPmezNCP;;
 5: len 15; hex 6d4a50314d4d6230696a644a54354f; asc mJP1MMb0ijdJT5O;;
 6: len 14; hex 763266636e6b4541587141753058; asc v2fcnkEAXqAu0X;;
 7: len 2; hex 6d72; asc mr;;
 8: len 9; hex 363339313139353233; asc 639119523;;
 9: len 2; hex 800f; asc   ;;
 10: len 6; hex 800034885500; asc   4 U ;;

------------------
---TRANSACTION 265178, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 255, OS thread handle 140618304431872, query id 759397 localhost tpcc updating
UPDATE warehouse SET w_ytd = w_ytd + 219 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 93 page no 4 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 265178 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000040bd3; asc       ;;
 2: len 7; hex 010000017e1cd9; asc     ~  ;;
 3: len 7; hex 6d55356a716755; asc mU5jqgU;;
 4: len 10; hex 6b3562506d657a4e4350; asc k5bPmezNCP;;
 5: len 15; hex 6d4a50314d4d6230696a644a54354f; asc mJP1MMb0ijdJT5O;;
 6: len 14; hex 763266636e6b4541587141753058; asc v2fcnkEAXqAu0X;;
 7: len 2; hex 6d72; asc mr;;
 8: len 9; hex 363339313139353233; asc 639119523;;
 9: len 2; hex 800f; asc   ;;
 10: len 6; hex 800034885500; asc   4 U ;;

------------------
---TRANSACTION 265175, ACTIVE 0 sec starting index read
mysql tables in use 1, locked 1
LOCK WAIT 2 lock struct(s), heap size 1136, 1 row lock(s)
MySQL thread id 251, OS thread handle 140618303547136, query id 759230 localhost tpcc updating
UPDATE warehouse SET w_ytd = w_ytd + 1082 WHERE w_id = 1
------- TRX HAS BEEN WAITING 0 SEC FOR THIS LOCK TO BE GRANTED:
RECORD LOCKS space id 93 page no 4 n bits 72 index PRIMARY of table `tpcc`.`warehouse` trx id 265175 lock_mode X locks rec but not gap waiting
Record lock, heap no 2 PHYSICAL RECORD: n_fields 11; compact format; info bits 0
 0: len 2; hex 8001; asc   ;;
 1: len 6; hex 000000040bd3; asc       ;;
 2: len 7; hex 010000017e1cd9; asc     ~  ;;
 3: len 7; hex 6d55356a716755; asc mU5jqgU;;
 4: len 10; hex 6b3562506d657a4e4350; asc k5bPmezNCP;;
 5: len 15; hex 6d4a50314d4d6230696a644a54354f; asc mJP1MMb0ijdJT5O;;
 6: len 14; hex 763266636e6b4541587141753058; asc v2fcnkEAXqAu0X;;
 7: len 2; hex 6d72; asc mr;;
 8: len 9; hex 363339313139353233; asc 639119523;;
 9: len 2; hex 800f; asc   ;;
 10: len 6; hex 800034885500; asc   4 U ;;

------------------
---TRANSACTION 265171, ACTIVE (PREPARED) 0 sec
7 lock struct(s), heap size 1136, 3 row lock(s), undo log entries 4
MySQL thread id 252, OS thread handle 140618304726784, query id 759779 localhost tpcc waiting for handler commit
commit
Trx read view will not see trx with id >= 265201, sees < 265175
--------
FILE I/O
--------
I/O thread 0 state: waiting for completed aio requests (insert buffer thread)
I/O thread 1 state: waiting for completed aio requests (log thread)
I/O thread 2 state: waiting for completed aio requests (read thread)
I/O thread 3 state: waiting for completed aio requests (read thread)
I/O thread 4 state: waiting for completed aio requests (read thread)
I/O thread 5 state: waiting for completed aio requests (read thread)
I/O thread 6 state: waiting for completed aio requests (write thread)
I/O thread 7 state: waiting for completed aio requests (write thread)
I/O thread 8 state: waiting for completed aio requests (write thread)
I/O thread 9 state: waiting for completed aio requests (write thread)
Pending normal aio reads: [0, 0, 0, 0] , aio writes: [0, 0, 0, 0] ,
 ibuf aio reads:, log i/o\'s:, sync i/o\'s:
Pending flushes (fsync) log: 1; buffer pool: 0
4463 OS file reads, 196474 OS file writes, 76315 OS fsyncs
0 pending preads, 1 pending pwrites
63.58 reads/s, 23877 avg bytes/read, 996.25 writes/s, 324.34 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 0, seg size 2, 5 merges
merged operations:
 insert 10, delete mark 0, delete 0
discarded operations:
 insert 0, delete mark 0, delete 0
Hash table size 34679, node heap has 1 buffer(s)
Hash table size 34679, node heap has 1 buffer(s)
Hash table size 34679, node heap has 1 buffer(s)
Hash table size 34679, node heap has 67 buffer(s)
Hash table size 34679, node heap has 10 buffer(s)
Hash table size 34679, node heap has 1 buffer(s)
Hash table size 34679, node heap has 237 buffer(s)
Hash table size 34679, node heap has 2 buffer(s)
18264.23 hash searches/s, 9717.35 non-hash searches/s
---
LOG
---
Log sequence number          293246263
Log buffer assigned up to    293246263
Log buffer completed up to   293246007
Log written up to            293245678
Log flushed up to            293244169
Added dirty pages up to      293246263
Pages flushed up to          280773503
Last checkpoint at           280773503
178959 log i/o\'s done, 864.60 log i/o\'s/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total large memory allocated 137363456
Dictionary memory allocated 635457
Buffer pool size   8192
Free buffers       991
Database pages     6881
Old database pages 2520
Modified db pages  4261
Pending reads      0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 18183, not young 238759
349.61 youngs/s, 4591.43 non-youngs/s
Pages read 4398, created 9063, written 15545
63.11 reads/s, 60.19 creates/s, 113.65 writes/s
Buffer pool hit rate 1000 / 1000, young-making rate 4 / 1000 not 61 / 1000
Pages read ahead 6.35/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 6881, unzip_LRU len: 0
I/O sum[8627]:cur[159], unzip sum[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
4 read views open inside InnoDB
Process ID=30898, Main thread ID=140618375309056 , state=sleeping
Number of rows inserted 920607, updated 36137, deleted 2057, read 823104
6139.31 inserts/s, 675.72 updates/s, 35.31 deletes/s, 14436.65 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
',
            'Name' => ''
          }
        ];

$mysql57_no_deadlock = [
          {
            'Type' => 'InnoDB',
            'Status' => '
=====================================
2019-07-11 19:14:22 0x7f0494d38700 INNODB MONITOR OUTPUT
=====================================
Per second averages calculated from the last 6 seconds
-----------------
BACKGROUND THREAD
-----------------
srv_master_thread loops: 2 srv_active, 0 srv_shutdown, 3 srv_idle
srv_master_thread log flush and writes: 5
----------
SEMAPHORES
----------
OS WAIT ARRAY INFO: reservation count 2
OS WAIT ARRAY INFO: signal count 2
RW-shared spins 0, rounds 4, OS waits 2
RW-excl spins 0, rounds 0, OS waits 0
RW-sx spins 0, rounds 0, OS waits 0
Spin rounds per wait: 4.00 RW-shared, 0.00 RW-excl, 0.00 RW-sx
------------
TRANSACTIONS
------------
Trx id counter 44803
Purge done for trx\'s n:o < 0 undo n:o < 0 state: running but idle
History list length 0
LIST OF TRANSACTIONS FOR EACH SESSION:
---TRANSACTION 421133084444496, not started
0 lock struct(s), heap size 1136, 0 row lock(s)
--------
FILE I/O
--------
I/O thread 0 state: waiting for completed aio requests (insert buffer thread)
I/O thread 1 state: waiting for completed aio requests (log thread)
I/O thread 2 state: waiting for completed aio requests (read thread)
I/O thread 3 state: waiting for completed aio requests (read thread)
I/O thread 4 state: waiting for completed aio requests (read thread)
I/O thread 5 state: waiting for completed aio requests (read thread)
I/O thread 6 state: waiting for completed aio requests (write thread)
I/O thread 7 state: waiting for completed aio requests (write thread)
I/O thread 8 state: waiting for completed aio requests (write thread)
I/O thread 9 state: waiting for completed aio requests (write thread)
Pending normal aio reads: [0, 0, 0, 0] , aio writes: [0, 0, 0, 0] ,
 ibuf aio reads:, log i/o\'s:, sync i/o\'s:
Pending flushes (fsync) log: 0; buffer pool: 0
366 OS file reads, 53 OS file writes, 7 OS fsyncs
9.67 reads/s, 16384 avg bytes/read, 6.67 writes/s, 0.83 fsyncs/s
-------------------------------------
INSERT BUFFER AND ADAPTIVE HASH INDEX
-------------------------------------
Ibuf: size 1, free list len 0, seg size 2, 0 merges
merged operations:
 insert 0, delete mark 0, delete 0
discarded operations:
 insert 0, delete mark 0, delete 0
Hash table size 34673, node heap has 0 buffer(s)
Hash table size 34673, node heap has 0 buffer(s)
Hash table size 34673, node heap has 0 buffer(s)
Hash table size 34673, node heap has 0 buffer(s)
Hash table size 34673, node heap has 0 buffer(s)
Hash table size 34673, node heap has 0 buffer(s)
Hash table size 34673, node heap has 0 buffer(s)
Hash table size 34673, node heap has 0 buffer(s)
0.00 hash searches/s, 15.33 non-hash searches/s
---
LOG
---
Log sequence number 226187867
Log flushed up to   226187867
Pages flushed up to 226187867
Last checkpoint at  226187858
0 pending log flushes, 0 pending chkp writes
10 log i/o\'s done, 0.50 log i/o\'s/second
----------------------
BUFFER POOL AND MEMORY
----------------------
Total large memory allocated 137428992
Dictionary memory allocated 116177
Buffer pool size   8191
Free buffers       7819
Database pages     372
Old database pages 0
Modified db pages  0
Pending reads      0
Pending writes: LRU 0, flush list 0, single page 0
Pages made young 0, not young 0
0.00 youngs/s, 0.00 non-youngs/s
Pages read 338, created 34, written 36
7.17 reads/s, 0.00 creates/s, 6.00 writes/s
Buffer pool hit rate 794 / 1000, young-making rate 0 / 1000 not 0 / 1000
Pages read ahead 0.00/s, evicted without access 0.00/s, Random read ahead 0.00/s
LRU len: 372, unzip_LRU len: 0
I/O sum[0]:cur[0], unzip sum[0]:cur[0]
--------------
ROW OPERATIONS
--------------
0 queries inside InnoDB, 0 queries in queue
0 read views open inside InnoDB
Process ID=28516, Main thread ID=139657807808256, state: sleeping
Number of rows inserted 0, updated 0, deleted 0, read 11
0.00 inserts/s, 0.00 updates/s, 0.00 deletes/s, 1.83 reads/s
----------------------------
END OF INNODB MONITOR OUTPUT
============================
',
            'Name' => ''
          }
        ];

return 1;
