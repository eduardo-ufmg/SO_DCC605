
_corretor:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
                                        r->minute,
                                        r->second);
}


int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  struct rtcdate r;
  int call_ok = 1;

  printf(stdout, "[Caso 0] Testando o date\n");
  call_ok = get_date(&r);
   f:	8d 5d e0             	lea    -0x20(%ebp),%ebx
int main(int argc, char *argv[]) {
  12:	83 ec 28             	sub    $0x28,%esp
  printf(stdout, "[Caso 0] Testando o date\n");
  15:	68 4a 13 00 00       	push   $0x134a
  1a:	ff 35 c8 19 00 00    	push   0x19c8
  20:	e8 4b 0c 00 00       	call   c70 <printf>
  call_ok = get_date(&r);
  25:	89 1c 24             	mov    %ebx,(%esp)
  28:	e8 23 08 00 00       	call   850 <get_date>
  if (call_ok == FALSE) {
  2d:	83 c4 10             	add    $0x10,%esp
  30:	85 c0                	test   %eax,%eax
  32:	75 17                	jne    4b <main+0x4b>
    printf(stdout, "[Caso 0 - ERROR] Falhou!\n");
  34:	50                   	push   %eax
  35:	50                   	push   %eax
  36:	68 64 13 00 00       	push   $0x1364
  3b:	ff 35 c8 19 00 00    	push   0x19c8
  41:	e8 2a 0c 00 00       	call   c70 <printf>
    exit();
  46:	e8 c0 0a 00 00       	call   b0b <exit>
  }
  print_date(&r);
  4b:	83 ec 0c             	sub    $0xc,%esp
  4e:	53                   	push   %ebx
  4f:	e8 3c 08 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 0] OK\n");
  54:	58                   	pop    %eax
  55:	5a                   	pop    %edx
  56:	68 7e 13 00 00       	push   $0x137e
  5b:	ff 35 c8 19 00 00    	push   0x19c8
  61:	e8 0a 0c 00 00       	call   c70 <printf>

  get_date(&r);
  66:	89 1c 24             	mov    %ebx,(%esp)
  69:	e8 e2 07 00 00       	call   850 <get_date>
  print_date(&r);
  6e:	89 1c 24             	mov    %ebx,(%esp)
  71:	e8 1a 08 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 1] Testando o fork\n");
  76:	59                   	pop    %ecx
  77:	58                   	pop    %eax
  78:	68 8b 13 00 00       	push   $0x138b
  7d:	ff 35 c8 19 00 00    	push   0x19c8
  83:	e8 e8 0b 00 00       	call   c70 <printf>
  call_ok = caso1fork();
  88:	e8 a3 02 00 00       	call   330 <caso1fork>
  if (call_ok == FALSE) {
  8d:	83 c4 10             	add    $0x10,%esp
  90:	85 c0                	test   %eax,%eax
  92:	75 17                	jne    ab <main+0xab>
    printf(stdout, "[Caso 1 - ERROR] Falhou!\n");
  94:	51                   	push   %ecx
  95:	51                   	push   %ecx
  96:	68 a5 13 00 00       	push   $0x13a5
  9b:	ff 35 c8 19 00 00    	push   0x19c8
  a1:	e8 ca 0b 00 00       	call   c70 <printf>
    exit();
  a6:	e8 60 0a 00 00       	call   b0b <exit>
  }
  printf(stdout, "[Caso 1] OK\n");
  ab:	50                   	push   %eax
  ac:	50                   	push   %eax
  ad:	68 bf 13 00 00       	push   $0x13bf
  b2:	ff 35 c8 19 00 00    	push   0x19c8
  b8:	e8 b3 0b 00 00       	call   c70 <printf>

  get_date(&r);
  bd:	89 1c 24             	mov    %ebx,(%esp)
  c0:	e8 8b 07 00 00       	call   850 <get_date>
  print_date(&r);
  c5:	89 1c 24             	mov    %ebx,(%esp)
  c8:	e8 c3 07 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 2] Testando o forkcow\n");
  cd:	58                   	pop    %eax
  ce:	5a                   	pop    %edx
  cf:	68 cc 13 00 00       	push   $0x13cc
  d4:	ff 35 c8 19 00 00    	push   0x19c8
  da:	e8 91 0b 00 00       	call   c70 <printf>
  call_ok = caso2forkcow();
  df:	e8 cc 02 00 00       	call   3b0 <caso2forkcow>
  if (call_ok == FALSE) {
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	85 c0                	test   %eax,%eax
  e9:	74 57                	je     142 <main+0x142>
    printf(stdout, "[Caso 2 - ERROR] Falhou!\n");
    exit();
  }
  printf(stdout, "[Caso 2] OK\n");
  eb:	50                   	push   %eax
  ec:	50                   	push   %eax
  ed:	68 03 14 00 00       	push   $0x1403
  f2:	ff 35 c8 19 00 00    	push   0x19c8
  f8:	e8 73 0b 00 00       	call   c70 <printf>

  get_date(&r);
  fd:	89 1c 24             	mov    %ebx,(%esp)
 100:	e8 4b 07 00 00       	call   850 <get_date>
  print_date(&r);
 105:	89 1c 24             	mov    %ebx,(%esp)
 108:	e8 83 07 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 3] Testando se o número de páginas é igual\n");
 10d:	58                   	pop    %eax
 10e:	5a                   	pop    %edx
 10f:	68 04 12 00 00       	push   $0x1204
 114:	ff 35 c8 19 00 00    	push   0x19c8
 11a:	e8 51 0b 00 00       	call   c70 <printf>
  call_ok = caso3numpgs();
 11f:	e8 0c 03 00 00       	call   430 <caso3numpgs>
  if (call_ok == FALSE) {
 124:	83 c4 10             	add    $0x10,%esp
 127:	85 c0                	test   %eax,%eax
 129:	75 2e                	jne    159 <main+0x159>
    printf(stdout, "[Caso 3 - ERROR] Falhou!\n");
 12b:	51                   	push   %ecx
 12c:	51                   	push   %ecx
 12d:	68 10 14 00 00       	push   $0x1410
 132:	ff 35 c8 19 00 00    	push   0x19c8
 138:	e8 33 0b 00 00       	call   c70 <printf>
    exit();
 13d:	e8 c9 09 00 00       	call   b0b <exit>
    printf(stdout, "[Caso 2 - ERROR] Falhou!\n");
 142:	51                   	push   %ecx
 143:	51                   	push   %ecx
 144:	68 e9 13 00 00       	push   $0x13e9
 149:	ff 35 c8 19 00 00    	push   0x19c8
 14f:	e8 1c 0b 00 00       	call   c70 <printf>
    exit();
 154:	e8 b2 09 00 00       	call   b0b <exit>
  }
  printf(stdout, "[Caso 3] OK\n");
 159:	50                   	push   %eax
 15a:	50                   	push   %eax
 15b:	68 2a 14 00 00       	push   $0x142a
 160:	ff 35 c8 19 00 00    	push   0x19c8
 166:	e8 05 0b 00 00       	call   c70 <printf>

  get_date(&r);
 16b:	89 1c 24             	mov    %ebx,(%esp)
 16e:	e8 dd 06 00 00       	call   850 <get_date>
  print_date(&r);
 173:	89 1c 24             	mov    %ebx,(%esp)
 176:	e8 15 07 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 4] Testando se o endereço de uma constante é =\n");
 17b:	58                   	pop    %eax
 17c:	5a                   	pop    %edx
 17d:	68 3c 12 00 00       	push   $0x123c
 182:	ff 35 c8 19 00 00    	push   0x19c8
 188:	e8 e3 0a 00 00       	call   c70 <printf>
  call_ok = caso4mesmoaddr();
 18d:	e8 8e 03 00 00       	call   520 <caso4mesmoaddr>
  if (call_ok == FALSE) {
 192:	83 c4 10             	add    $0x10,%esp
 195:	85 c0                	test   %eax,%eax
 197:	74 57                	je     1f0 <main+0x1f0>
    printf(stdout, "[Caso 4 - ERROR] Falhou!\n");
    exit();
  }
  printf(stdout, "[Caso 4] OK\n");
 199:	50                   	push   %eax
 19a:	50                   	push   %eax
 19b:	68 51 14 00 00       	push   $0x1451
 1a0:	ff 35 c8 19 00 00    	push   0x19c8
 1a6:	e8 c5 0a 00 00       	call   c70 <printf>

  get_date(&r);
 1ab:	89 1c 24             	mov    %ebx,(%esp)
 1ae:	e8 9d 06 00 00       	call   850 <get_date>
  print_date(&r);
 1b3:	89 1c 24             	mov    %ebx,(%esp)
 1b6:	e8 d5 06 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 5] Testando se o endereço de uma global é =\n");
 1bb:	58                   	pop    %eax
 1bc:	5a                   	pop    %edx
 1bd:	68 74 12 00 00       	push   $0x1274
 1c2:	ff 35 c8 19 00 00    	push   0x19c8
 1c8:	e8 a3 0a 00 00       	call   c70 <printf>
  call_ok = caso5mesmoaddr();
 1cd:	e8 5e 04 00 00       	call   630 <caso5mesmoaddr>
  if (call_ok == FALSE) {
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	85 c0                	test   %eax,%eax
 1d7:	75 2e                	jne    207 <main+0x207>
    printf(stdout, "[Caso 5 - ERROR] Falhou!\n");
 1d9:	51                   	push   %ecx
 1da:	51                   	push   %ecx
 1db:	68 5e 14 00 00       	push   $0x145e
 1e0:	ff 35 c8 19 00 00    	push   0x19c8
 1e6:	e8 85 0a 00 00       	call   c70 <printf>
    exit();
 1eb:	e8 1b 09 00 00       	call   b0b <exit>
    printf(stdout, "[Caso 4 - ERROR] Falhou!\n");
 1f0:	51                   	push   %ecx
 1f1:	51                   	push   %ecx
 1f2:	68 37 14 00 00       	push   $0x1437
 1f7:	ff 35 c8 19 00 00    	push   0x19c8
 1fd:	e8 6e 0a 00 00       	call   c70 <printf>
    exit();
 202:	e8 04 09 00 00       	call   b0b <exit>
  }
  printf(stdout, "[Caso 5] OK\n");
 207:	50                   	push   %eax
 208:	50                   	push   %eax
 209:	68 78 14 00 00       	push   $0x1478
 20e:	ff 35 c8 19 00 00    	push   0x19c8
 214:	e8 57 0a 00 00       	call   c70 <printf>

  get_date(&r);
 219:	89 1c 24             	mov    %ebx,(%esp)
 21c:	e8 2f 06 00 00       	call   850 <get_date>
  print_date(&r);
 221:	89 1c 24             	mov    %ebx,(%esp)
 224:	e8 67 06 00 00       	call   890 <print_date>
  printf(stdout, "[Caso 6] Testando o COW\n");
 229:	58                   	pop    %eax
 22a:	5a                   	pop    %edx
 22b:	68 85 14 00 00       	push   $0x1485
 230:	ff 35 c8 19 00 00    	push   0x19c8
 236:	e8 35 0a 00 00       	call   c70 <printf>
  call_ok = caso6cow();
 23b:	e8 00 05 00 00       	call   740 <caso6cow>
  if (call_ok == FALSE) {
 240:	83 c4 10             	add    $0x10,%esp
 243:	85 c0                	test   %eax,%eax
 245:	75 17                	jne    25e <main+0x25e>
    printf(stdout, "[Caso 6 - ERROR] Falhou!\n");
 247:	50                   	push   %eax
 248:	50                   	push   %eax
 249:	68 9e 14 00 00       	push   $0x149e
 24e:	ff 35 c8 19 00 00    	push   0x19c8
 254:	e8 17 0a 00 00       	call   c70 <printf>
    exit();
 259:	e8 ad 08 00 00       	call   b0b <exit>
  }
  printf(stdout, "[Caso 6] OK\n");
 25e:	50                   	push   %eax
 25f:	50                   	push   %eax
 260:	68 b8 14 00 00       	push   $0x14b8
 265:	ff 35 c8 19 00 00    	push   0x19c8
 26b:	e8 00 0a 00 00       	call   c70 <printf>
  printf(stdout, "\n");
 270:	5a                   	pop    %edx
 271:	59                   	pop    %ecx
 272:	68 1e 15 00 00       	push   $0x151e
 277:	ff 35 c8 19 00 00    	push   0x19c8
 27d:	e8 ee 09 00 00       	call   c70 <printf>
  printf(stdout, "         (__)        \n");
 282:	5b                   	pop    %ebx
 283:	58                   	pop    %eax
 284:	68 c5 14 00 00       	push   $0x14c5
 289:	ff 35 c8 19 00 00    	push   0x19c8
 28f:	e8 dc 09 00 00       	call   c70 <printf>
  printf(stdout, "         (oo)        \n");
 294:	58                   	pop    %eax
 295:	5a                   	pop    %edx
 296:	68 dc 14 00 00       	push   $0x14dc
 29b:	ff 35 c8 19 00 00    	push   0x19c8
 2a1:	e8 ca 09 00 00       	call   c70 <printf>
  printf(stdout, "   /------\\/        \n");
 2a6:	59                   	pop    %ecx
 2a7:	5b                   	pop    %ebx
 2a8:	68 f3 14 00 00       	push   $0x14f3
 2ad:	ff 35 c8 19 00 00    	push   0x19c8
 2b3:	e8 b8 09 00 00       	call   c70 <printf>
  printf(stdout, "  / |    ||          \n");
 2b8:	58                   	pop    %eax
 2b9:	5a                   	pop    %edx
 2ba:	68 09 15 00 00       	push   $0x1509
 2bf:	ff 35 c8 19 00 00    	push   0x19c8
 2c5:	e8 a6 09 00 00       	call   c70 <printf>
  printf(stdout, " *  /\\---/\\        \n");
 2ca:	59                   	pop    %ecx
 2cb:	5b                   	pop    %ebx
 2cc:	68 20 15 00 00       	push   $0x1520
 2d1:	ff 35 c8 19 00 00    	push   0x19c8
 2d7:	e8 94 09 00 00       	call   c70 <printf>
  printf(stdout, "    ~~   ~~          \n");
 2dc:	58                   	pop    %eax
 2dd:	5a                   	pop    %edx
 2de:	68 35 15 00 00       	push   $0x1535
 2e3:	ff 35 c8 19 00 00    	push   0x19c8
 2e9:	e8 82 09 00 00       	call   c70 <printf>
  printf(stdout, "....\"Congratulations! You have mooed!\"...\n");
 2ee:	59                   	pop    %ecx
 2ef:	5b                   	pop    %ebx
 2f0:	68 ac 12 00 00       	push   $0x12ac
 2f5:	ff 35 c8 19 00 00    	push   0x19c8
 2fb:	e8 70 09 00 00       	call   c70 <printf>
  printf(stdout, "\n");
 300:	58                   	pop    %eax
 301:	5a                   	pop    %edx
 302:	68 1e 15 00 00       	push   $0x151e
 307:	ff 35 c8 19 00 00    	push   0x19c8
 30d:	e8 5e 09 00 00       	call   c70 <printf>
  printf(stdout, "[0xDCC605 - COW] ALL OK!!!\n");
 312:	59                   	pop    %ecx
 313:	5b                   	pop    %ebx
 314:	68 4c 15 00 00       	push   $0x154c
 319:	ff 35 c8 19 00 00    	push   0x19c8
 31f:	e8 4c 09 00 00       	call   c70 <printf>
  exit();
 324:	e8 e2 07 00 00       	call   b0b <exit>
 329:	66 90                	xchg   %ax,%ax
 32b:	66 90                	xchg   %ax,%ax
 32d:	66 90                	xchg   %ax,%ax
 32f:	90                   	nop

00000330 <caso1fork>:
int caso1fork(void) {
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
  for(n=0; n<N; n++){
 334:	31 db                	xor    %ebx,%ebx
int caso1fork(void) {
 336:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "[--Caso 1.1] Testando %d chamadas fork\n", N);
 339:	6a 0a                	push   $0xa
 33b:	68 78 0f 00 00       	push   $0xf78
 340:	ff 35 c8 19 00 00    	push   0x19c8
 346:	e8 25 09 00 00       	call   c70 <printf>
 34b:	83 c4 10             	add    $0x10,%esp
 34e:	66 90                	xchg   %ax,%ax
    pid = fork();
 350:	e8 a6 07 00 00       	call   afb <fork>
    if(pid < 0) {
 355:	85 c0                	test   %eax,%eax
 357:	78 27                	js     380 <caso1fork+0x50>
    if(pid == 0)
 359:	74 43                	je     39e <caso1fork+0x6e>
      if (wait() < 0) return FALSE;
 35b:	e8 b3 07 00 00       	call   b13 <wait>
 360:	85 c0                	test   %eax,%eax
 362:	78 33                	js     397 <caso1fork+0x67>
  for(n=0; n<N; n++){
 364:	83 c3 01             	add    $0x1,%ebx
 367:	83 fb 0a             	cmp    $0xa,%ebx
 36a:	75 e4                	jne    350 <caso1fork+0x20>
}
 36c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return TRUE;
 36f:	b8 01 00 00 00       	mov    $0x1,%eax
}
 374:	c9                   	leave
 375:	c3                   	ret
 376:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 37d:	00 
 37e:	66 90                	xchg   %ax,%ax
      printf(stdout, "[--Caso 1.1 - ERROR] Fork %d falhou!\n", n);
 380:	83 ec 04             	sub    $0x4,%esp
 383:	53                   	push   %ebx
 384:	68 a0 0f 00 00       	push   $0xfa0
 389:	ff 35 c8 19 00 00    	push   0x19c8
 38f:	e8 dc 08 00 00       	call   c70 <printf>
      return FALSE;
 394:	83 c4 10             	add    $0x10,%esp
}
 397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return FALSE;
 39a:	31 c0                	xor    %eax,%eax
}
 39c:	c9                   	leave
 39d:	c3                   	ret
      exit();   // fecha filho
 39e:	e8 68 07 00 00       	call   b0b <exit>
 3a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3aa:	00 
 3ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

000003b0 <caso2forkcow>:
int caso2forkcow(void) {
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
  for(n=0; n<N; n++){
 3b4:	31 db                	xor    %ebx,%ebx
int caso2forkcow(void) {
 3b6:	83 ec 08             	sub    $0x8,%esp
  printf(stdout, "[--Caso 2.1] Testando %d chamadas forkcow\n", N);
 3b9:	6a 0a                	push   $0xa
 3bb:	68 c8 0f 00 00       	push   $0xfc8
 3c0:	ff 35 c8 19 00 00    	push   0x19c8
 3c6:	e8 a5 08 00 00       	call   c70 <printf>
 3cb:	83 c4 10             	add    $0x10,%esp
 3ce:	66 90                	xchg   %ax,%ax
    pid = forkcow();
 3d0:	e8 2e 07 00 00       	call   b03 <forkcow>
    if(pid < 0) {
 3d5:	85 c0                	test   %eax,%eax
 3d7:	78 27                	js     400 <caso2forkcow+0x50>
    if(pid == 0)
 3d9:	74 43                	je     41e <caso2forkcow+0x6e>
      if (wait() < 0) return FALSE;
 3db:	e8 33 07 00 00       	call   b13 <wait>
 3e0:	85 c0                	test   %eax,%eax
 3e2:	78 33                	js     417 <caso2forkcow+0x67>
  for(n=0; n<N; n++){
 3e4:	83 c3 01             	add    $0x1,%ebx
 3e7:	83 fb 0a             	cmp    $0xa,%ebx
 3ea:	75 e4                	jne    3d0 <caso2forkcow+0x20>
}
 3ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return TRUE;
 3ef:	b8 01 00 00 00       	mov    $0x1,%eax
}
 3f4:	c9                   	leave
 3f5:	c3                   	ret
 3f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3fd:	00 
 3fe:	66 90                	xchg   %ax,%ax
      printf(stdout, "[--Caso 2.1 - ERROR] Fork %d falhou!\n", n);
 400:	83 ec 04             	sub    $0x4,%esp
 403:	53                   	push   %ebx
 404:	68 f4 0f 00 00       	push   $0xff4
 409:	ff 35 c8 19 00 00    	push   0x19c8
 40f:	e8 5c 08 00 00       	call   c70 <printf>
      return FALSE;
 414:	83 c4 10             	add    $0x10,%esp
}
 417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return FALSE;
 41a:	31 c0                	xor    %eax,%eax
}
 41c:	c9                   	leave
 41d:	c3                   	ret
      exit();   // fecha filho
 41e:	e8 e8 06 00 00       	call   b0b <exit>
 423:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 42a:	00 
 42b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

00000430 <caso3numpgs>:
int caso3numpgs(void) {
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
  pipe(fd);
 435:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso3numpgs(void) {
 438:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
 43b:	50                   	push   %eax
 43c:	e8 da 06 00 00       	call   b1b <pipe>
  int np = numpages();
 441:	e8 75 07 00 00       	call   bbb <numpages>
 446:	89 c3                	mov    %eax,%ebx
  int pid = forkcow();
 448:	e8 b6 06 00 00       	call   b03 <forkcow>
  if (pid == 0) { // child manda número de páginas de da exit
 44d:	83 c4 10             	add    $0x10,%esp
 450:	85 c0                	test   %eax,%eax
 452:	74 72                	je     4c6 <caso3numpgs+0x96>
    close(fd[1]);
 454:	83 ec 0c             	sub    $0xc,%esp
 457:	ff 75 e0             	push   -0x20(%ebp)
    read(fd[0], answer, 20);
 45a:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    close(fd[1]);
 45d:	e8 d1 06 00 00       	call   b33 <close>
    wait();
 462:	e8 ac 06 00 00       	call   b13 <wait>
    printf(stdout, "[--Caso 3.3] Parent lendo numpages\n");
 467:	58                   	pop    %eax
 468:	5a                   	pop    %edx
 469:	68 64 10 00 00       	push   $0x1064
 46e:	ff 35 c8 19 00 00    	push   0x19c8
 474:	e8 f7 07 00 00       	call   c70 <printf>
    read(fd[0], answer, 20);
 479:	83 c4 0c             	add    $0xc,%esp
 47c:	6a 14                	push   $0x14
 47e:	56                   	push   %esi
 47f:	ff 75 dc             	push   -0x24(%ebp)
 482:	e8 9c 06 00 00       	call   b23 <read>
    printf(stdout, "[--Caso 3.4] Parent leu %d == %d\n", np, atoi(answer));
 487:	89 34 24             	mov    %esi,(%esp)
 48a:	e8 01 06 00 00       	call   a90 <atoi>
 48f:	50                   	push   %eax
 490:	53                   	push   %ebx
 491:	68 88 10 00 00       	push   $0x1088
 496:	ff 35 c8 19 00 00    	push   0x19c8
 49c:	e8 cf 07 00 00       	call   c70 <printf>
    close(fd[0]);
 4a1:	83 c4 14             	add    $0x14,%esp
 4a4:	ff 75 dc             	push   -0x24(%ebp)
 4a7:	e8 87 06 00 00       	call   b33 <close>
    return atoi(answer) == np;
 4ac:	89 34 24             	mov    %esi,(%esp)
 4af:	e8 dc 05 00 00       	call   a90 <atoi>
 4b4:	83 c4 10             	add    $0x10,%esp
 4b7:	39 d8                	cmp    %ebx,%eax
 4b9:	0f 94 c0             	sete   %al
}
 4bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4bf:	5b                   	pop    %ebx
    return atoi(answer) == np;
 4c0:	0f b6 c0             	movzbl %al,%eax
}
 4c3:	5e                   	pop    %esi
 4c4:	5d                   	pop    %ebp
 4c5:	c3                   	ret
    printf(stdout, "[--Caso 3.1] Child write numpages %d\n", numpages());
 4c6:	e8 f0 06 00 00       	call   bbb <numpages>
 4cb:	51                   	push   %ecx
 4cc:	50                   	push   %eax
 4cd:	68 1c 10 00 00       	push   $0x101c
 4d2:	ff 35 c8 19 00 00    	push   0x19c8
 4d8:	e8 93 07 00 00       	call   c70 <printf>
    close(fd[0]);
 4dd:	5b                   	pop    %ebx
 4de:	ff 75 dc             	push   -0x24(%ebp)
 4e1:	e8 4d 06 00 00       	call   b33 <close>
    printf(fd[1], "%d\0", numpages());
 4e6:	e8 d0 06 00 00       	call   bbb <numpages>
 4eb:	83 c4 0c             	add    $0xc,%esp
 4ee:	50                   	push   %eax
 4ef:	68 d8 12 00 00       	push   $0x12d8
 4f4:	ff 75 e0             	push   -0x20(%ebp)
 4f7:	e8 74 07 00 00       	call   c70 <printf>
    printf(stdout, "[--Caso 3.2] Child indo embora\n");
 4fc:	5e                   	pop    %esi
 4fd:	58                   	pop    %eax
 4fe:	68 44 10 00 00       	push   $0x1044
 503:	ff 35 c8 19 00 00    	push   0x19c8
 509:	e8 62 07 00 00       	call   c70 <printf>
    close(fd[1]);
 50e:	58                   	pop    %eax
 50f:	ff 75 e0             	push   -0x20(%ebp)
 512:	e8 1c 06 00 00       	call   b33 <close>
    exit();
 517:	e8 ef 05 00 00       	call   b0b <exit>
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000520 <caso4mesmoaddr>:
int caso4mesmoaddr(void) {
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	56                   	push   %esi
 524:	53                   	push   %ebx
  pipe(fd);
 525:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso4mesmoaddr(void) {
 528:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
 52b:	50                   	push   %eax
 52c:	e8 ea 05 00 00       	call   b1b <pipe>
  int pid = forkcow();
 531:	e8 cd 05 00 00       	call   b03 <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL1_RO
 536:	83 c4 10             	add    $0x10,%esp
 539:	85 c0                	test   %eax,%eax
 53b:	0f 84 84 00 00 00    	je     5c5 <caso4mesmoaddr+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
 541:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
 544:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
 547:	68 dc 12 00 00       	push   $0x12dc
 54c:	e8 62 06 00 00       	call   bb3 <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 551:	89 c3                	mov    %eax,%ebx
 553:	f7 db                	neg    %ebx
 555:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
 558:	58                   	pop    %eax
 559:	ff 75 e0             	push   -0x20(%ebp)
 55c:	e8 d2 05 00 00       	call   b33 <close>
    wait();
 561:	e8 ad 05 00 00       	call   b13 <wait>
    printf(stdout, "[--Caso 4.3] Parent lendo addr\n");
 566:	5a                   	pop    %edx
 567:	59                   	pop    %ecx
 568:	68 cc 10 00 00       	push   $0x10cc
 56d:	ff 35 c8 19 00 00    	push   0x19c8
 573:	e8 f8 06 00 00       	call   c70 <printf>
    read(fd[0], answer, 20);
 578:	83 c4 0c             	add    $0xc,%esp
 57b:	6a 14                	push   $0x14
 57d:	56                   	push   %esi
 57e:	ff 75 dc             	push   -0x24(%ebp)
 581:	e8 9d 05 00 00       	call   b23 <read>
    printf(stdout, "[--Caso 4.4] Parent leu %d == %d\n",
 586:	89 34 24             	mov    %esi,(%esp)
 589:	e8 02 05 00 00       	call   a90 <atoi>
 58e:	50                   	push   %eax
 58f:	53                   	push   %ebx
 590:	68 ec 10 00 00       	push   $0x10ec
 595:	ff 35 c8 19 00 00    	push   0x19c8
 59b:	e8 d0 06 00 00       	call   c70 <printf>
    close(fd[0]);
 5a0:	83 c4 14             	add    $0x14,%esp
 5a3:	ff 75 dc             	push   -0x24(%ebp)
 5a6:	e8 88 05 00 00       	call   b33 <close>
    return addr == atoi(answer);
 5ab:	89 34 24             	mov    %esi,(%esp)
 5ae:	e8 dd 04 00 00       	call   a90 <atoi>
 5b3:	83 c4 10             	add    $0x10,%esp
 5b6:	39 d8                	cmp    %ebx,%eax
 5b8:	0f 94 c0             	sete   %al
}
 5bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 5be:	5b                   	pop    %ebx
    return addr == atoi(answer);
 5bf:	0f b6 c0             	movzbl %al,%eax
}
 5c2:	5e                   	pop    %esi
 5c3:	5d                   	pop    %ebp
 5c4:	c3                   	ret
    int addr = (int)virt2real((char*)&GLOBAL1_RO);
 5c5:	83 ec 0c             	sub    $0xc,%esp
 5c8:	68 dc 12 00 00       	push   $0x12dc
 5cd:	e8 e1 05 00 00       	call   bb3 <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 5d2:	83 c4 0c             	add    $0xc,%esp
 5d5:	89 c3                	mov    %eax,%ebx
 5d7:	f7 db                	neg    %ebx
 5d9:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 4.1] Child write %d\n", addr);
 5dc:	53                   	push   %ebx
 5dd:	68 e0 12 00 00       	push   $0x12e0
 5e2:	ff 35 c8 19 00 00    	push   0x19c8
 5e8:	e8 83 06 00 00       	call   c70 <printf>
    close(fd[0]);
 5ed:	5e                   	pop    %esi
 5ee:	ff 75 dc             	push   -0x24(%ebp)
 5f1:	e8 3d 05 00 00       	call   b33 <close>
    printf(fd[1], "%d\0", addr);
 5f6:	83 c4 0c             	add    $0xc,%esp
 5f9:	53                   	push   %ebx
 5fa:	68 d8 12 00 00       	push   $0x12d8
 5ff:	ff 75 e0             	push   -0x20(%ebp)
 602:	e8 69 06 00 00       	call   c70 <printf>
    printf(stdout, "[--Caso 4.2] Child indo embora\n");
 607:	58                   	pop    %eax
 608:	5a                   	pop    %edx
 609:	68 ac 10 00 00       	push   $0x10ac
 60e:	ff 35 c8 19 00 00    	push   0x19c8
 614:	e8 57 06 00 00       	call   c70 <printf>
    close(fd[1]);
 619:	59                   	pop    %ecx
 61a:	ff 75 e0             	push   -0x20(%ebp)
 61d:	e8 11 05 00 00       	call   b33 <close>
    exit();
 622:	e8 e4 04 00 00       	call   b0b <exit>
 627:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 62e:	00 
 62f:	90                   	nop

00000630 <caso5mesmoaddr>:
int caso5mesmoaddr(void) {
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	56                   	push   %esi
 634:	53                   	push   %ebx
  pipe(fd);
 635:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso5mesmoaddr(void) {
 638:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
 63b:	50                   	push   %eax
 63c:	e8 da 04 00 00       	call   b1b <pipe>
  int pid = forkcow();
 641:	e8 bd 04 00 00       	call   b03 <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL1_RO
 646:	83 c4 10             	add    $0x10,%esp
 649:	85 c0                	test   %eax,%eax
 64b:	0f 84 84 00 00 00    	je     6d5 <caso5mesmoaddr+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 651:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
 654:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 657:	68 c0 19 00 00       	push   $0x19c0
 65c:	e8 52 05 00 00       	call   bb3 <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 661:	89 c3                	mov    %eax,%ebx
 663:	f7 db                	neg    %ebx
 665:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
 668:	58                   	pop    %eax
 669:	ff 75 e0             	push   -0x20(%ebp)
 66c:	e8 c2 04 00 00       	call   b33 <close>
    wait();
 671:	e8 9d 04 00 00       	call   b13 <wait>
    printf(stdout, "[--Caso 5.3] Parent lendo addr\n");
 676:	5a                   	pop    %edx
 677:	59                   	pop    %ecx
 678:	68 30 11 00 00       	push   $0x1130
 67d:	ff 35 c8 19 00 00    	push   0x19c8
 683:	e8 e8 05 00 00       	call   c70 <printf>
    read(fd[0], answer, 20);
 688:	83 c4 0c             	add    $0xc,%esp
 68b:	6a 14                	push   $0x14
 68d:	56                   	push   %esi
 68e:	ff 75 dc             	push   -0x24(%ebp)
 691:	e8 8d 04 00 00       	call   b23 <read>
    printf(stdout, "[--Caso 5.4] Parent leu %d == %d\n",
 696:	89 34 24             	mov    %esi,(%esp)
 699:	e8 f2 03 00 00       	call   a90 <atoi>
 69e:	50                   	push   %eax
 69f:	53                   	push   %ebx
 6a0:	68 50 11 00 00       	push   $0x1150
 6a5:	ff 35 c8 19 00 00    	push   0x19c8
 6ab:	e8 c0 05 00 00       	call   c70 <printf>
    close(fd[0]);
 6b0:	83 c4 14             	add    $0x14,%esp
 6b3:	ff 75 dc             	push   -0x24(%ebp)
 6b6:	e8 78 04 00 00       	call   b33 <close>
    return addr == atoi(answer);
 6bb:	89 34 24             	mov    %esi,(%esp)
 6be:	e8 cd 03 00 00       	call   a90 <atoi>
 6c3:	83 c4 10             	add    $0x10,%esp
 6c6:	39 d8                	cmp    %ebx,%eax
 6c8:	0f 94 c0             	sete   %al
}
 6cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6ce:	5b                   	pop    %ebx
    return addr == atoi(answer);
 6cf:	0f b6 c0             	movzbl %al,%eax
}
 6d2:	5e                   	pop    %esi
 6d3:	5d                   	pop    %ebp
 6d4:	c3                   	ret
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 6d5:	83 ec 0c             	sub    $0xc,%esp
 6d8:	68 c0 19 00 00       	push   $0x19c0
 6dd:	e8 d1 04 00 00       	call   bb3 <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 6e2:	83 c4 0c             	add    $0xc,%esp
 6e5:	89 c3                	mov    %eax,%ebx
 6e7:	f7 db                	neg    %ebx
 6e9:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 5.1] Child write %d\n", addr);
 6ec:	53                   	push   %ebx
 6ed:	68 fd 12 00 00       	push   $0x12fd
 6f2:	ff 35 c8 19 00 00    	push   0x19c8
 6f8:	e8 73 05 00 00       	call   c70 <printf>
    close(fd[0]);
 6fd:	5e                   	pop    %esi
 6fe:	ff 75 dc             	push   -0x24(%ebp)
 701:	e8 2d 04 00 00       	call   b33 <close>
    printf(fd[1], "%d\0", addr);
 706:	83 c4 0c             	add    $0xc,%esp
 709:	53                   	push   %ebx
 70a:	68 d8 12 00 00       	push   $0x12d8
 70f:	ff 75 e0             	push   -0x20(%ebp)
 712:	e8 59 05 00 00       	call   c70 <printf>
    printf(stdout, "[--Caso 5.2] Child indo embora\n");
 717:	58                   	pop    %eax
 718:	5a                   	pop    %edx
 719:	68 10 11 00 00       	push   $0x1110
 71e:	ff 35 c8 19 00 00    	push   0x19c8
 724:	e8 47 05 00 00       	call   c70 <printf>
    close(fd[1]);
 729:	59                   	pop    %ecx
 72a:	ff 75 e0             	push   -0x20(%ebp)
 72d:	e8 01 04 00 00       	call   b33 <close>
    exit();
 732:	e8 d4 03 00 00       	call   b0b <exit>
 737:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 73e:	00 
 73f:	90                   	nop

00000740 <caso6cow>:
int caso6cow(void) {
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	56                   	push   %esi
 744:	53                   	push   %ebx
  pipe(fd);
 745:	8d 45 dc             	lea    -0x24(%ebp),%eax
int caso6cow(void) {
 748:	83 ec 2c             	sub    $0x2c,%esp
  pipe(fd);
 74b:	50                   	push   %eax
 74c:	e8 ca 03 00 00       	call   b1b <pipe>
  int pid = forkcow();
 751:	e8 ad 03 00 00       	call   b03 <forkcow>
  if (pid == 0) { // child manda addr de GLOBAL2_RW
 756:	83 c4 10             	add    $0x10,%esp
 759:	85 c0                	test   %eax,%eax
 75b:	0f 84 84 00 00 00    	je     7e5 <caso6cow+0xa5>
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 761:	83 ec 0c             	sub    $0xc,%esp
    read(fd[0], answer, 20);
 764:	8d 75 e4             	lea    -0x1c(%ebp),%esi
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 767:	68 c0 19 00 00       	push   $0x19c0
 76c:	e8 42 04 00 00       	call   bb3 <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 771:	89 c3                	mov    %eax,%ebx
 773:	f7 db                	neg    %ebx
 775:	0f 48 d8             	cmovs  %eax,%ebx
    close(fd[1]);
 778:	58                   	pop    %eax
 779:	ff 75 e0             	push   -0x20(%ebp)
 77c:	e8 b2 03 00 00       	call   b33 <close>
    wait();
 781:	e8 8d 03 00 00       	call   b13 <wait>
    printf(stdout, "[--Caso 6.3] Parent lendo addr\n");
 786:	5a                   	pop    %edx
 787:	59                   	pop    %ecx
 788:	68 94 11 00 00       	push   $0x1194
 78d:	ff 35 c8 19 00 00    	push   0x19c8
 793:	e8 d8 04 00 00       	call   c70 <printf>
    read(fd[0], answer, 20);
 798:	83 c4 0c             	add    $0xc,%esp
 79b:	6a 14                	push   $0x14
 79d:	56                   	push   %esi
 79e:	ff 75 dc             	push   -0x24(%ebp)
 7a1:	e8 7d 03 00 00       	call   b23 <read>
    printf(stdout, "[--Caso 6.4] Parent leu %d != %d\n",
 7a6:	89 34 24             	mov    %esi,(%esp)
 7a9:	e8 e2 02 00 00       	call   a90 <atoi>
 7ae:	50                   	push   %eax
 7af:	53                   	push   %ebx
 7b0:	68 b4 11 00 00       	push   $0x11b4
 7b5:	ff 35 c8 19 00 00    	push   0x19c8
 7bb:	e8 b0 04 00 00       	call   c70 <printf>
    close(fd[0]);
 7c0:	83 c4 14             	add    $0x14,%esp
 7c3:	ff 75 dc             	push   -0x24(%ebp)
 7c6:	e8 68 03 00 00       	call   b33 <close>
    return addr != atoi(answer);
 7cb:	89 34 24             	mov    %esi,(%esp)
 7ce:	e8 bd 02 00 00       	call   a90 <atoi>
 7d3:	83 c4 10             	add    $0x10,%esp
 7d6:	39 d8                	cmp    %ebx,%eax
 7d8:	0f 95 c0             	setne  %al
}
 7db:	8d 65 f8             	lea    -0x8(%ebp),%esp
 7de:	5b                   	pop    %ebx
    return addr != atoi(answer);
 7df:	0f b6 c0             	movzbl %al,%eax
}
 7e2:	5e                   	pop    %esi
 7e3:	5d                   	pop    %ebp
 7e4:	c3                   	ret
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 7e5:	83 ec 0c             	sub    $0xc,%esp
    GLOBAL2_RW--;
 7e8:	83 2d c0 19 00 00 01 	subl   $0x1,0x19c0
    int addr = (int)virt2real((char*)&GLOBAL2_RW);
 7ef:	68 c0 19 00 00       	push   $0x19c0
 7f4:	e8 ba 03 00 00       	call   bb3 <virt2real>
    if (addr < 0) addr = -addr; // atoi falha quando <0, nao sei pq
 7f9:	83 c4 0c             	add    $0xc,%esp
 7fc:	89 c3                	mov    %eax,%ebx
 7fe:	f7 db                	neg    %ebx
 800:	0f 48 d8             	cmovs  %eax,%ebx
    printf(stdout, "[--Caso 6.1] Child write %d\n", addr);
 803:	53                   	push   %ebx
 804:	68 1a 13 00 00       	push   $0x131a
 809:	ff 35 c8 19 00 00    	push   0x19c8
 80f:	e8 5c 04 00 00       	call   c70 <printf>
    close(fd[0]);
 814:	5e                   	pop    %esi
 815:	ff 75 dc             	push   -0x24(%ebp)
 818:	e8 16 03 00 00       	call   b33 <close>
    printf(fd[1], "%d\0", addr);
 81d:	83 c4 0c             	add    $0xc,%esp
 820:	53                   	push   %ebx
 821:	68 d8 12 00 00       	push   $0x12d8
 826:	ff 75 e0             	push   -0x20(%ebp)
 829:	e8 42 04 00 00       	call   c70 <printf>
    printf(stdout, "[--Caso 6.2] Child indo embora\n");
 82e:	58                   	pop    %eax
 82f:	5a                   	pop    %edx
 830:	68 74 11 00 00       	push   $0x1174
 835:	ff 35 c8 19 00 00    	push   0x19c8
 83b:	e8 30 04 00 00       	call   c70 <printf>
    close(fd[1]);
 840:	59                   	pop    %ecx
 841:	ff 75 e0             	push   -0x20(%ebp)
 844:	e8 ea 02 00 00       	call   b33 <close>
    exit();
 849:	e8 bd 02 00 00       	call   b0b <exit>
 84e:	66 90                	xchg   %ax,%ax

00000850 <get_date>:
int get_date(struct rtcdate *r) {
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	83 ec 14             	sub    $0x14,%esp
  if (date(r)) {
 856:	ff 75 08             	push   0x8(%ebp)
 859:	e8 4d 03 00 00       	call   bab <date>
 85e:	83 c4 10             	add    $0x10,%esp
 861:	89 c2                	mov    %eax,%edx
 863:	b8 01 00 00 00       	mov    $0x1,%eax
 868:	85 d2                	test   %edx,%edx
 86a:	75 04                	jne    870 <get_date+0x20>
}
 86c:	c9                   	leave
 86d:	c3                   	ret
 86e:	66 90                	xchg   %ax,%ax
    printf(stderr, "[ERROR] Erro na chamada de sistema date\n");
 870:	83 ec 08             	sub    $0x8,%esp
 873:	68 d8 11 00 00       	push   $0x11d8
 878:	ff 35 c4 19 00 00    	push   0x19c4
 87e:	e8 ed 03 00 00       	call   c70 <printf>
 883:	83 c4 10             	add    $0x10,%esp
 886:	31 c0                	xor    %eax,%eax
}
 888:	c9                   	leave
 889:	c3                   	ret
 88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000890 <print_date>:
void print_date(struct rtcdate *r) {
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 08             	sub    $0x8,%esp
 896:	8b 45 08             	mov    0x8(%ebp),%eax
  printf(stdout, "%d/%d/%d %d:%d:%d\n", r->day,
 899:	ff 30                	push   (%eax)
 89b:	ff 70 04             	push   0x4(%eax)
 89e:	ff 70 08             	push   0x8(%eax)
 8a1:	ff 70 14             	push   0x14(%eax)
 8a4:	ff 70 10             	push   0x10(%eax)
 8a7:	ff 70 0c             	push   0xc(%eax)
 8aa:	68 37 13 00 00       	push   $0x1337
 8af:	ff 35 c8 19 00 00    	push   0x19c8
 8b5:	e8 b6 03 00 00       	call   c70 <printf>
}
 8ba:	83 c4 20             	add    $0x20,%esp
 8bd:	c9                   	leave
 8be:	c3                   	ret
 8bf:	90                   	nop

000008c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 8c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 8c1:	31 c0                	xor    %eax,%eax
{
 8c3:	89 e5                	mov    %esp,%ebp
 8c5:	53                   	push   %ebx
 8c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 8d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 8d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 8d7:	83 c0 01             	add    $0x1,%eax
 8da:	84 d2                	test   %dl,%dl
 8dc:	75 f2                	jne    8d0 <strcpy+0x10>
    ;
  return os;
}
 8de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8e1:	89 c8                	mov    %ecx,%eax
 8e3:	c9                   	leave
 8e4:	c3                   	ret
 8e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 8ec:	00 
 8ed:	8d 76 00             	lea    0x0(%esi),%esi

000008f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 8f0:	55                   	push   %ebp
 8f1:	89 e5                	mov    %esp,%ebp
 8f3:	53                   	push   %ebx
 8f4:	8b 55 08             	mov    0x8(%ebp),%edx
 8f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 8fa:	0f b6 02             	movzbl (%edx),%eax
 8fd:	84 c0                	test   %al,%al
 8ff:	75 17                	jne    918 <strcmp+0x28>
 901:	eb 3a                	jmp    93d <strcmp+0x4d>
 903:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 908:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 90c:	83 c2 01             	add    $0x1,%edx
 90f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 912:	84 c0                	test   %al,%al
 914:	74 1a                	je     930 <strcmp+0x40>
 916:	89 d9                	mov    %ebx,%ecx
 918:	0f b6 19             	movzbl (%ecx),%ebx
 91b:	38 c3                	cmp    %al,%bl
 91d:	74 e9                	je     908 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 91f:	29 d8                	sub    %ebx,%eax
}
 921:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 924:	c9                   	leave
 925:	c3                   	ret
 926:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 92d:	00 
 92e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 930:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 934:	31 c0                	xor    %eax,%eax
 936:	29 d8                	sub    %ebx,%eax
}
 938:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 93b:	c9                   	leave
 93c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 93d:	0f b6 19             	movzbl (%ecx),%ebx
 940:	31 c0                	xor    %eax,%eax
 942:	eb db                	jmp    91f <strcmp+0x2f>
 944:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 94b:	00 
 94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000950 <strlen>:

uint
strlen(const char *s)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 956:	80 3a 00             	cmpb   $0x0,(%edx)
 959:	74 15                	je     970 <strlen+0x20>
 95b:	31 c0                	xor    %eax,%eax
 95d:	8d 76 00             	lea    0x0(%esi),%esi
 960:	83 c0 01             	add    $0x1,%eax
 963:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 967:	89 c1                	mov    %eax,%ecx
 969:	75 f5                	jne    960 <strlen+0x10>
    ;
  return n;
}
 96b:	89 c8                	mov    %ecx,%eax
 96d:	5d                   	pop    %ebp
 96e:	c3                   	ret
 96f:	90                   	nop
  for(n = 0; s[n]; n++)
 970:	31 c9                	xor    %ecx,%ecx
}
 972:	5d                   	pop    %ebp
 973:	89 c8                	mov    %ecx,%eax
 975:	c3                   	ret
 976:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 97d:	00 
 97e:	66 90                	xchg   %ax,%ax

00000980 <memset>:

void*
memset(void *dst, int c, uint n)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	57                   	push   %edi
 984:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 987:	8b 4d 10             	mov    0x10(%ebp),%ecx
 98a:	8b 45 0c             	mov    0xc(%ebp),%eax
 98d:	89 d7                	mov    %edx,%edi
 98f:	fc                   	cld
 990:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 992:	8b 7d fc             	mov    -0x4(%ebp),%edi
 995:	89 d0                	mov    %edx,%eax
 997:	c9                   	leave
 998:	c3                   	ret
 999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009a0 <strchr>:

char*
strchr(const char *s, char c)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 9aa:	0f b6 10             	movzbl (%eax),%edx
 9ad:	84 d2                	test   %dl,%dl
 9af:	75 12                	jne    9c3 <strchr+0x23>
 9b1:	eb 1d                	jmp    9d0 <strchr+0x30>
 9b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 9b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 9bc:	83 c0 01             	add    $0x1,%eax
 9bf:	84 d2                	test   %dl,%dl
 9c1:	74 0d                	je     9d0 <strchr+0x30>
    if(*s == c)
 9c3:	38 d1                	cmp    %dl,%cl
 9c5:	75 f1                	jne    9b8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 9c7:	5d                   	pop    %ebp
 9c8:	c3                   	ret
 9c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 9d0:	31 c0                	xor    %eax,%eax
}
 9d2:	5d                   	pop    %ebp
 9d3:	c3                   	ret
 9d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 9db:	00 
 9dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009e0 <gets>:

char*
gets(char *buf, int max)
{
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
 9e3:	57                   	push   %edi
 9e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 9e5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 9e8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 9e9:	31 db                	xor    %ebx,%ebx
{
 9eb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 9ee:	eb 27                	jmp    a17 <gets+0x37>
    cc = read(0, &c, 1);
 9f0:	83 ec 04             	sub    $0x4,%esp
 9f3:	6a 01                	push   $0x1
 9f5:	56                   	push   %esi
 9f6:	6a 00                	push   $0x0
 9f8:	e8 26 01 00 00       	call   b23 <read>
    if(cc < 1)
 9fd:	83 c4 10             	add    $0x10,%esp
 a00:	85 c0                	test   %eax,%eax
 a02:	7e 1d                	jle    a21 <gets+0x41>
      break;
    buf[i++] = c;
 a04:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 a08:	8b 55 08             	mov    0x8(%ebp),%edx
 a0b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 a0f:	3c 0a                	cmp    $0xa,%al
 a11:	74 10                	je     a23 <gets+0x43>
 a13:	3c 0d                	cmp    $0xd,%al
 a15:	74 0c                	je     a23 <gets+0x43>
  for(i=0; i+1 < max; ){
 a17:	89 df                	mov    %ebx,%edi
 a19:	83 c3 01             	add    $0x1,%ebx
 a1c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 a1f:	7c cf                	jl     9f0 <gets+0x10>
 a21:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 a23:	8b 45 08             	mov    0x8(%ebp),%eax
 a26:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 a2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a2d:	5b                   	pop    %ebx
 a2e:	5e                   	pop    %esi
 a2f:	5f                   	pop    %edi
 a30:	5d                   	pop    %ebp
 a31:	c3                   	ret
 a32:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 a39:	00 
 a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a40 <stat>:

int
stat(const char *n, struct stat *st)
{
 a40:	55                   	push   %ebp
 a41:	89 e5                	mov    %esp,%ebp
 a43:	56                   	push   %esi
 a44:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 a45:	83 ec 08             	sub    $0x8,%esp
 a48:	6a 00                	push   $0x0
 a4a:	ff 75 08             	push   0x8(%ebp)
 a4d:	e8 f9 00 00 00       	call   b4b <open>
  if(fd < 0)
 a52:	83 c4 10             	add    $0x10,%esp
 a55:	85 c0                	test   %eax,%eax
 a57:	78 27                	js     a80 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 a59:	83 ec 08             	sub    $0x8,%esp
 a5c:	ff 75 0c             	push   0xc(%ebp)
 a5f:	89 c3                	mov    %eax,%ebx
 a61:	50                   	push   %eax
 a62:	e8 fc 00 00 00       	call   b63 <fstat>
  close(fd);
 a67:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 a6a:	89 c6                	mov    %eax,%esi
  close(fd);
 a6c:	e8 c2 00 00 00       	call   b33 <close>
  return r;
 a71:	83 c4 10             	add    $0x10,%esp
}
 a74:	8d 65 f8             	lea    -0x8(%ebp),%esp
 a77:	89 f0                	mov    %esi,%eax
 a79:	5b                   	pop    %ebx
 a7a:	5e                   	pop    %esi
 a7b:	5d                   	pop    %ebp
 a7c:	c3                   	ret
 a7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 a80:	be ff ff ff ff       	mov    $0xffffffff,%esi
 a85:	eb ed                	jmp    a74 <stat+0x34>
 a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 a8e:	00 
 a8f:	90                   	nop

00000a90 <atoi>:

int
atoi(const char *s)
{
 a90:	55                   	push   %ebp
 a91:	89 e5                	mov    %esp,%ebp
 a93:	53                   	push   %ebx
 a94:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 a97:	0f be 02             	movsbl (%edx),%eax
 a9a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 a9d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 aa0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 aa5:	77 1e                	ja     ac5 <atoi+0x35>
 aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 aae:	00 
 aaf:	90                   	nop
    n = n*10 + *s++ - '0';
 ab0:	83 c2 01             	add    $0x1,%edx
 ab3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 ab6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 aba:	0f be 02             	movsbl (%edx),%eax
 abd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 ac0:	80 fb 09             	cmp    $0x9,%bl
 ac3:	76 eb                	jbe    ab0 <atoi+0x20>
  return n;
}
 ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 ac8:	89 c8                	mov    %ecx,%eax
 aca:	c9                   	leave
 acb:	c3                   	ret
 acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ad0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 ad0:	55                   	push   %ebp
 ad1:	89 e5                	mov    %esp,%ebp
 ad3:	57                   	push   %edi
 ad4:	8b 45 10             	mov    0x10(%ebp),%eax
 ad7:	8b 55 08             	mov    0x8(%ebp),%edx
 ada:	56                   	push   %esi
 adb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 ade:	85 c0                	test   %eax,%eax
 ae0:	7e 13                	jle    af5 <memmove+0x25>
 ae2:	01 d0                	add    %edx,%eax
  dst = vdst;
 ae4:	89 d7                	mov    %edx,%edi
 ae6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 aed:	00 
 aee:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 af0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 af1:	39 f8                	cmp    %edi,%eax
 af3:	75 fb                	jne    af0 <memmove+0x20>
  return vdst;
}
 af5:	5e                   	pop    %esi
 af6:	89 d0                	mov    %edx,%eax
 af8:	5f                   	pop    %edi
 af9:	5d                   	pop    %ebp
 afa:	c3                   	ret

00000afb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 afb:	b8 01 00 00 00       	mov    $0x1,%eax
 b00:	cd 40                	int    $0x40
 b02:	c3                   	ret

00000b03 <forkcow>:
SYSCALL(forkcow)
 b03:	b8 16 00 00 00       	mov    $0x16,%eax
 b08:	cd 40                	int    $0x40
 b0a:	c3                   	ret

00000b0b <exit>:
SYSCALL(exit)
 b0b:	b8 02 00 00 00       	mov    $0x2,%eax
 b10:	cd 40                	int    $0x40
 b12:	c3                   	ret

00000b13 <wait>:
SYSCALL(wait)
 b13:	b8 03 00 00 00       	mov    $0x3,%eax
 b18:	cd 40                	int    $0x40
 b1a:	c3                   	ret

00000b1b <pipe>:
SYSCALL(pipe)
 b1b:	b8 04 00 00 00       	mov    $0x4,%eax
 b20:	cd 40                	int    $0x40
 b22:	c3                   	ret

00000b23 <read>:
SYSCALL(read)
 b23:	b8 05 00 00 00       	mov    $0x5,%eax
 b28:	cd 40                	int    $0x40
 b2a:	c3                   	ret

00000b2b <write>:
SYSCALL(write)
 b2b:	b8 10 00 00 00       	mov    $0x10,%eax
 b30:	cd 40                	int    $0x40
 b32:	c3                   	ret

00000b33 <close>:
SYSCALL(close)
 b33:	b8 15 00 00 00       	mov    $0x15,%eax
 b38:	cd 40                	int    $0x40
 b3a:	c3                   	ret

00000b3b <kill>:
SYSCALL(kill)
 b3b:	b8 06 00 00 00       	mov    $0x6,%eax
 b40:	cd 40                	int    $0x40
 b42:	c3                   	ret

00000b43 <exec>:
SYSCALL(exec)
 b43:	b8 07 00 00 00       	mov    $0x7,%eax
 b48:	cd 40                	int    $0x40
 b4a:	c3                   	ret

00000b4b <open>:
SYSCALL(open)
 b4b:	b8 0f 00 00 00       	mov    $0xf,%eax
 b50:	cd 40                	int    $0x40
 b52:	c3                   	ret

00000b53 <mknod>:
SYSCALL(mknod)
 b53:	b8 11 00 00 00       	mov    $0x11,%eax
 b58:	cd 40                	int    $0x40
 b5a:	c3                   	ret

00000b5b <unlink>:
SYSCALL(unlink)
 b5b:	b8 12 00 00 00       	mov    $0x12,%eax
 b60:	cd 40                	int    $0x40
 b62:	c3                   	ret

00000b63 <fstat>:
SYSCALL(fstat)
 b63:	b8 08 00 00 00       	mov    $0x8,%eax
 b68:	cd 40                	int    $0x40
 b6a:	c3                   	ret

00000b6b <link>:
SYSCALL(link)
 b6b:	b8 13 00 00 00       	mov    $0x13,%eax
 b70:	cd 40                	int    $0x40
 b72:	c3                   	ret

00000b73 <mkdir>:
SYSCALL(mkdir)
 b73:	b8 14 00 00 00       	mov    $0x14,%eax
 b78:	cd 40                	int    $0x40
 b7a:	c3                   	ret

00000b7b <chdir>:
SYSCALL(chdir)
 b7b:	b8 09 00 00 00       	mov    $0x9,%eax
 b80:	cd 40                	int    $0x40
 b82:	c3                   	ret

00000b83 <dup>:
SYSCALL(dup)
 b83:	b8 0a 00 00 00       	mov    $0xa,%eax
 b88:	cd 40                	int    $0x40
 b8a:	c3                   	ret

00000b8b <getpid>:
SYSCALL(getpid)
 b8b:	b8 0b 00 00 00       	mov    $0xb,%eax
 b90:	cd 40                	int    $0x40
 b92:	c3                   	ret

00000b93 <sbrk>:
SYSCALL(sbrk)
 b93:	b8 0c 00 00 00       	mov    $0xc,%eax
 b98:	cd 40                	int    $0x40
 b9a:	c3                   	ret

00000b9b <sleep>:
SYSCALL(sleep)
 b9b:	b8 0d 00 00 00       	mov    $0xd,%eax
 ba0:	cd 40                	int    $0x40
 ba2:	c3                   	ret

00000ba3 <uptime>:
SYSCALL(uptime)
 ba3:	b8 0e 00 00 00       	mov    $0xe,%eax
 ba8:	cd 40                	int    $0x40
 baa:	c3                   	ret

00000bab <date>:
SYSCALL(date)
 bab:	b8 17 00 00 00       	mov    $0x17,%eax
 bb0:	cd 40                	int    $0x40
 bb2:	c3                   	ret

00000bb3 <virt2real>:
SYSCALL(virt2real)
 bb3:	b8 18 00 00 00       	mov    $0x18,%eax
 bb8:	cd 40                	int    $0x40
 bba:	c3                   	ret

00000bbb <numpages>:
SYSCALL(numpages)
 bbb:	b8 19 00 00 00       	mov    $0x19,%eax
 bc0:	cd 40                	int    $0x40
 bc2:	c3                   	ret
 bc3:	66 90                	xchg   %ax,%ax
 bc5:	66 90                	xchg   %ax,%ax
 bc7:	66 90                	xchg   %ax,%ax
 bc9:	66 90                	xchg   %ax,%ax
 bcb:	66 90                	xchg   %ax,%ax
 bcd:	66 90                	xchg   %ax,%ax
 bcf:	90                   	nop

00000bd0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 bd0:	55                   	push   %ebp
 bd1:	89 e5                	mov    %esp,%ebp
 bd3:	57                   	push   %edi
 bd4:	56                   	push   %esi
 bd5:	53                   	push   %ebx
 bd6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 bd8:	89 d1                	mov    %edx,%ecx
{
 bda:	83 ec 3c             	sub    $0x3c,%esp
 bdd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 be0:	85 d2                	test   %edx,%edx
 be2:	0f 89 80 00 00 00    	jns    c68 <printint+0x98>
 be8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 bec:	74 7a                	je     c68 <printint+0x98>
    x = -xx;
 bee:	f7 d9                	neg    %ecx
    neg = 1;
 bf0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 bf5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 bf8:	31 f6                	xor    %esi,%esi
 bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 c00:	89 c8                	mov    %ecx,%eax
 c02:	31 d2                	xor    %edx,%edx
 c04:	89 f7                	mov    %esi,%edi
 c06:	f7 f3                	div    %ebx
 c08:	8d 76 01             	lea    0x1(%esi),%esi
 c0b:	0f b6 92 c8 15 00 00 	movzbl 0x15c8(%edx),%edx
 c12:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 c16:	89 ca                	mov    %ecx,%edx
 c18:	89 c1                	mov    %eax,%ecx
 c1a:	39 da                	cmp    %ebx,%edx
 c1c:	73 e2                	jae    c00 <printint+0x30>
  if(neg)
 c1e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 c21:	85 c0                	test   %eax,%eax
 c23:	74 07                	je     c2c <printint+0x5c>
    buf[i++] = '-';
 c25:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 c2a:	89 f7                	mov    %esi,%edi
 c2c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 c2f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 c32:	01 df                	add    %ebx,%edi
 c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 c38:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 c3b:	83 ec 04             	sub    $0x4,%esp
 c3e:	88 45 d7             	mov    %al,-0x29(%ebp)
 c41:	8d 45 d7             	lea    -0x29(%ebp),%eax
 c44:	6a 01                	push   $0x1
 c46:	50                   	push   %eax
 c47:	56                   	push   %esi
 c48:	e8 de fe ff ff       	call   b2b <write>
  while(--i >= 0)
 c4d:	89 f8                	mov    %edi,%eax
 c4f:	83 c4 10             	add    $0x10,%esp
 c52:	83 ef 01             	sub    $0x1,%edi
 c55:	39 c3                	cmp    %eax,%ebx
 c57:	75 df                	jne    c38 <printint+0x68>
}
 c59:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c5c:	5b                   	pop    %ebx
 c5d:	5e                   	pop    %esi
 c5e:	5f                   	pop    %edi
 c5f:	5d                   	pop    %ebp
 c60:	c3                   	ret
 c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 c68:	31 c0                	xor    %eax,%eax
 c6a:	eb 89                	jmp    bf5 <printint+0x25>
 c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c70 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 c70:	55                   	push   %ebp
 c71:	89 e5                	mov    %esp,%ebp
 c73:	57                   	push   %edi
 c74:	56                   	push   %esi
 c75:	53                   	push   %ebx
 c76:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c79:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 c7c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 c7f:	0f b6 1e             	movzbl (%esi),%ebx
 c82:	83 c6 01             	add    $0x1,%esi
 c85:	84 db                	test   %bl,%bl
 c87:	74 67                	je     cf0 <printf+0x80>
 c89:	8d 4d 10             	lea    0x10(%ebp),%ecx
 c8c:	31 d2                	xor    %edx,%edx
 c8e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 c91:	eb 34                	jmp    cc7 <printf+0x57>
 c93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 c98:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 c9b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 ca0:	83 f8 25             	cmp    $0x25,%eax
 ca3:	74 18                	je     cbd <printf+0x4d>
  write(fd, &c, 1);
 ca5:	83 ec 04             	sub    $0x4,%esp
 ca8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 cab:	88 5d e7             	mov    %bl,-0x19(%ebp)
 cae:	6a 01                	push   $0x1
 cb0:	50                   	push   %eax
 cb1:	57                   	push   %edi
 cb2:	e8 74 fe ff ff       	call   b2b <write>
 cb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 cba:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 cbd:	0f b6 1e             	movzbl (%esi),%ebx
 cc0:	83 c6 01             	add    $0x1,%esi
 cc3:	84 db                	test   %bl,%bl
 cc5:	74 29                	je     cf0 <printf+0x80>
    c = fmt[i] & 0xff;
 cc7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 cca:	85 d2                	test   %edx,%edx
 ccc:	74 ca                	je     c98 <printf+0x28>
      }
    } else if(state == '%'){
 cce:	83 fa 25             	cmp    $0x25,%edx
 cd1:	75 ea                	jne    cbd <printf+0x4d>
      if(c == 'd'){
 cd3:	83 f8 25             	cmp    $0x25,%eax
 cd6:	0f 84 04 01 00 00    	je     de0 <printf+0x170>
 cdc:	83 e8 63             	sub    $0x63,%eax
 cdf:	83 f8 15             	cmp    $0x15,%eax
 ce2:	77 1c                	ja     d00 <printf+0x90>
 ce4:	ff 24 85 70 15 00 00 	jmp    *0x1570(,%eax,4)
 ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 cf3:	5b                   	pop    %ebx
 cf4:	5e                   	pop    %esi
 cf5:	5f                   	pop    %edi
 cf6:	5d                   	pop    %ebp
 cf7:	c3                   	ret
 cf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 cff:	00 
  write(fd, &c, 1);
 d00:	83 ec 04             	sub    $0x4,%esp
 d03:	8d 55 e7             	lea    -0x19(%ebp),%edx
 d06:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 d0a:	6a 01                	push   $0x1
 d0c:	52                   	push   %edx
 d0d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 d10:	57                   	push   %edi
 d11:	e8 15 fe ff ff       	call   b2b <write>
 d16:	83 c4 0c             	add    $0xc,%esp
 d19:	88 5d e7             	mov    %bl,-0x19(%ebp)
 d1c:	6a 01                	push   $0x1
 d1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 d21:	52                   	push   %edx
 d22:	57                   	push   %edi
 d23:	e8 03 fe ff ff       	call   b2b <write>
        putc(fd, c);
 d28:	83 c4 10             	add    $0x10,%esp
      state = 0;
 d2b:	31 d2                	xor    %edx,%edx
 d2d:	eb 8e                	jmp    cbd <printf+0x4d>
 d2f:	90                   	nop
        printint(fd, *ap, 16, 0);
 d30:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 d33:	83 ec 0c             	sub    $0xc,%esp
 d36:	b9 10 00 00 00       	mov    $0x10,%ecx
 d3b:	8b 13                	mov    (%ebx),%edx
 d3d:	6a 00                	push   $0x0
 d3f:	89 f8                	mov    %edi,%eax
        ap++;
 d41:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 d44:	e8 87 fe ff ff       	call   bd0 <printint>
        ap++;
 d49:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 d4c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 d4f:	31 d2                	xor    %edx,%edx
 d51:	e9 67 ff ff ff       	jmp    cbd <printf+0x4d>
        s = (char*)*ap;
 d56:	8b 45 d0             	mov    -0x30(%ebp),%eax
 d59:	8b 18                	mov    (%eax),%ebx
        ap++;
 d5b:	83 c0 04             	add    $0x4,%eax
 d5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 d61:	85 db                	test   %ebx,%ebx
 d63:	0f 84 87 00 00 00    	je     df0 <printf+0x180>
        while(*s != 0){
 d69:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 d6c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 d6e:	84 c0                	test   %al,%al
 d70:	0f 84 47 ff ff ff    	je     cbd <printf+0x4d>
 d76:	8d 55 e7             	lea    -0x19(%ebp),%edx
 d79:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 d7c:	89 de                	mov    %ebx,%esi
 d7e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 d80:	83 ec 04             	sub    $0x4,%esp
 d83:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 d86:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 d89:	6a 01                	push   $0x1
 d8b:	53                   	push   %ebx
 d8c:	57                   	push   %edi
 d8d:	e8 99 fd ff ff       	call   b2b <write>
        while(*s != 0){
 d92:	0f b6 06             	movzbl (%esi),%eax
 d95:	83 c4 10             	add    $0x10,%esp
 d98:	84 c0                	test   %al,%al
 d9a:	75 e4                	jne    d80 <printf+0x110>
      state = 0;
 d9c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 d9f:	31 d2                	xor    %edx,%edx
 da1:	e9 17 ff ff ff       	jmp    cbd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 da6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 da9:	83 ec 0c             	sub    $0xc,%esp
 dac:	b9 0a 00 00 00       	mov    $0xa,%ecx
 db1:	8b 13                	mov    (%ebx),%edx
 db3:	6a 01                	push   $0x1
 db5:	eb 88                	jmp    d3f <printf+0xcf>
        putc(fd, *ap);
 db7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 dba:	83 ec 04             	sub    $0x4,%esp
 dbd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 dc0:	8b 03                	mov    (%ebx),%eax
        ap++;
 dc2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 dc5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 dc8:	6a 01                	push   $0x1
 dca:	52                   	push   %edx
 dcb:	57                   	push   %edi
 dcc:	e8 5a fd ff ff       	call   b2b <write>
        ap++;
 dd1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 dd4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 dd7:	31 d2                	xor    %edx,%edx
 dd9:	e9 df fe ff ff       	jmp    cbd <printf+0x4d>
 dde:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 de0:	83 ec 04             	sub    $0x4,%esp
 de3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 de6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 de9:	6a 01                	push   $0x1
 deb:	e9 31 ff ff ff       	jmp    d21 <printf+0xb1>
 df0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 df5:	bb 68 15 00 00       	mov    $0x1568,%ebx
 dfa:	e9 77 ff ff ff       	jmp    d76 <printf+0x106>
 dff:	90                   	nop

00000e00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e00:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e01:	a1 cc 19 00 00       	mov    0x19cc,%eax
{
 e06:	89 e5                	mov    %esp,%ebp
 e08:	57                   	push   %edi
 e09:	56                   	push   %esi
 e0a:	53                   	push   %ebx
 e0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 e0e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e18:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e1a:	39 c8                	cmp    %ecx,%eax
 e1c:	73 32                	jae    e50 <free+0x50>
 e1e:	39 d1                	cmp    %edx,%ecx
 e20:	72 04                	jb     e26 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e22:	39 d0                	cmp    %edx,%eax
 e24:	72 32                	jb     e58 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 e26:	8b 73 fc             	mov    -0x4(%ebx),%esi
 e29:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 e2c:	39 fa                	cmp    %edi,%edx
 e2e:	74 30                	je     e60 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 e30:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 e33:	8b 50 04             	mov    0x4(%eax),%edx
 e36:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 e39:	39 f1                	cmp    %esi,%ecx
 e3b:	74 3a                	je     e77 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 e3d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 e3f:	5b                   	pop    %ebx
  freep = p;
 e40:	a3 cc 19 00 00       	mov    %eax,0x19cc
}
 e45:	5e                   	pop    %esi
 e46:	5f                   	pop    %edi
 e47:	5d                   	pop    %ebp
 e48:	c3                   	ret
 e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e50:	39 d0                	cmp    %edx,%eax
 e52:	72 04                	jb     e58 <free+0x58>
 e54:	39 d1                	cmp    %edx,%ecx
 e56:	72 ce                	jb     e26 <free+0x26>
{
 e58:	89 d0                	mov    %edx,%eax
 e5a:	eb bc                	jmp    e18 <free+0x18>
 e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 e60:	03 72 04             	add    0x4(%edx),%esi
 e63:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 e66:	8b 10                	mov    (%eax),%edx
 e68:	8b 12                	mov    (%edx),%edx
 e6a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 e6d:	8b 50 04             	mov    0x4(%eax),%edx
 e70:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 e73:	39 f1                	cmp    %esi,%ecx
 e75:	75 c6                	jne    e3d <free+0x3d>
    p->s.size += bp->s.size;
 e77:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 e7a:	a3 cc 19 00 00       	mov    %eax,0x19cc
    p->s.size += bp->s.size;
 e7f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 e82:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 e85:	89 08                	mov    %ecx,(%eax)
}
 e87:	5b                   	pop    %ebx
 e88:	5e                   	pop    %esi
 e89:	5f                   	pop    %edi
 e8a:	5d                   	pop    %ebp
 e8b:	c3                   	ret
 e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e90 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e90:	55                   	push   %ebp
 e91:	89 e5                	mov    %esp,%ebp
 e93:	57                   	push   %edi
 e94:	56                   	push   %esi
 e95:	53                   	push   %ebx
 e96:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e99:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 e9c:	8b 15 cc 19 00 00    	mov    0x19cc,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ea2:	8d 78 07             	lea    0x7(%eax),%edi
 ea5:	c1 ef 03             	shr    $0x3,%edi
 ea8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 eab:	85 d2                	test   %edx,%edx
 ead:	0f 84 8d 00 00 00    	je     f40 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eb3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 eb5:	8b 48 04             	mov    0x4(%eax),%ecx
 eb8:	39 f9                	cmp    %edi,%ecx
 eba:	73 64                	jae    f20 <malloc+0x90>
  if(nu < 4096)
 ebc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 ec1:	39 df                	cmp    %ebx,%edi
 ec3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 ec6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 ecd:	eb 0a                	jmp    ed9 <malloc+0x49>
 ecf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ed0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 ed2:	8b 48 04             	mov    0x4(%eax),%ecx
 ed5:	39 f9                	cmp    %edi,%ecx
 ed7:	73 47                	jae    f20 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ed9:	89 c2                	mov    %eax,%edx
 edb:	3b 05 cc 19 00 00    	cmp    0x19cc,%eax
 ee1:	75 ed                	jne    ed0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 ee3:	83 ec 0c             	sub    $0xc,%esp
 ee6:	56                   	push   %esi
 ee7:	e8 a7 fc ff ff       	call   b93 <sbrk>
  if(p == (char*)-1)
 eec:	83 c4 10             	add    $0x10,%esp
 eef:	83 f8 ff             	cmp    $0xffffffff,%eax
 ef2:	74 1c                	je     f10 <malloc+0x80>
  hp->s.size = nu;
 ef4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 ef7:	83 ec 0c             	sub    $0xc,%esp
 efa:	83 c0 08             	add    $0x8,%eax
 efd:	50                   	push   %eax
 efe:	e8 fd fe ff ff       	call   e00 <free>
  return freep;
 f03:	8b 15 cc 19 00 00    	mov    0x19cc,%edx
      if((p = morecore(nunits)) == 0)
 f09:	83 c4 10             	add    $0x10,%esp
 f0c:	85 d2                	test   %edx,%edx
 f0e:	75 c0                	jne    ed0 <malloc+0x40>
        return 0;
  }
}
 f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 f13:	31 c0                	xor    %eax,%eax
}
 f15:	5b                   	pop    %ebx
 f16:	5e                   	pop    %esi
 f17:	5f                   	pop    %edi
 f18:	5d                   	pop    %ebp
 f19:	c3                   	ret
 f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 f20:	39 cf                	cmp    %ecx,%edi
 f22:	74 4c                	je     f70 <malloc+0xe0>
        p->s.size -= nunits;
 f24:	29 f9                	sub    %edi,%ecx
 f26:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 f29:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 f2c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 f2f:	89 15 cc 19 00 00    	mov    %edx,0x19cc
}
 f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 f38:	83 c0 08             	add    $0x8,%eax
}
 f3b:	5b                   	pop    %ebx
 f3c:	5e                   	pop    %esi
 f3d:	5f                   	pop    %edi
 f3e:	5d                   	pop    %ebp
 f3f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 f40:	c7 05 cc 19 00 00 d0 	movl   $0x19d0,0x19cc
 f47:	19 00 00 
    base.s.size = 0;
 f4a:	b8 d0 19 00 00       	mov    $0x19d0,%eax
    base.s.ptr = freep = prevp = &base;
 f4f:	c7 05 d0 19 00 00 d0 	movl   $0x19d0,0x19d0
 f56:	19 00 00 
    base.s.size = 0;
 f59:	c7 05 d4 19 00 00 00 	movl   $0x0,0x19d4
 f60:	00 00 00 
    if(p->s.size >= nunits){
 f63:	e9 54 ff ff ff       	jmp    ebc <malloc+0x2c>
 f68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 f6f:	00 
        prevp->s.ptr = p->s.ptr;
 f70:	8b 08                	mov    (%eax),%ecx
 f72:	89 0a                	mov    %ecx,(%edx)
 f74:	eb b9                	jmp    f2f <malloc+0x9f>
