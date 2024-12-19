
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 e4 14 80       	mov    $0x8014e4d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 30 10 80       	mov    $0x801030a0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 76 10 80       	push   $0x80107600
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 25 45 00 00       	call   80104580 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 76 10 80       	push   $0x80107607
80100097:	50                   	push   %eax
80100098:	e8 b3 43 00 00       	call   80104450 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 87 46 00 00       	call   80104770 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 a9 45 00 00       	call   80104710 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 43 00 00       	call   80104490 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 76 10 80       	push   $0x8010760e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 6d 43 00 00       	call   80104530 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 f7 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 76 10 80       	push   $0x8010761f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 43 00 00       	call   80104530 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 dc 42 00 00       	call   801044f0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 50 45 00 00       	call   80104770 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 a2 44 00 00       	jmp    80104710 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 26 76 10 80       	push   $0x80107626
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 cb 44 00 00       	call   80104770 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 ce 3e 00 00       	call   801041a0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 e9 36 00 00       	call   801039d0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 15 44 00 00       	call   80104710 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 bf 43 00 00       	call   80104710 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 a2 25 00 00       	call   80102940 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 76 10 80       	push   $0x8010762d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 af 7a 10 80 	movl   $0x80107aaf,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 d3 41 00 00       	call   801045a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 76 10 80       	push   $0x80107641
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 ec 5a 00 00       	call   80105f10 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 21 5a 00 00       	call   80105f10 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 15 5a 00 00       	call   80105f10 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 09 5a 00 00       	call   80105f10 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 9a 43 00 00       	call   80104900 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 f5 42 00 00       	call   80104870 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 45 76 10 80       	push   $0x80107645
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005cb:	e8 a0 41 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ff 10 80       	push   $0x8010ff20
80100604:	e8 07 41 00 00       	call   80104710 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 3c 7b 10 80 	movzbl -0x7fef84c4(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ff 10 80    	mov    0x8010ff54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 93 3f 00 00       	call   80104770 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ff 10 80       	push   $0x8010ff20
801007fb:	e8 10 3f 00 00       	call   80104710 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 58 76 10 80       	mov    $0x80107658,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 5f 76 10 80       	push   $0x8010765f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ff 10 80       	push   $0x8010ff20
801008b3:	e8 b8 3e 00 00       	call   80104770 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ff 10 80       	push   $0x8010ff20
801008ed:	e8 1e 3e 00 00       	call   80104710 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100914:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100933:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
8010094a:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
8010095e:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100998:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100a05:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a27:	68 00 ff 10 80       	push   $0x8010ff00
80100a2c:	e8 2f 38 00 00       	call   80104260 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 ec 38 00 00       	jmp    80104340 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 68 76 10 80       	push   $0x80107668
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 0b 3b 00 00       	call   80104580 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 b0 	movl   $0x801005b0,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 19 00 00       	call   80102460 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 0f 2f 00 00       	call   801039d0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 e4 22 00 00       	call   80102db0 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 61 65 00 00       	call   80107080 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 20 63 00 00       	call   80106eb0 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 1a 62 00 00       	call   80106de0 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 f8 63 00 00       	call   80107000 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 07 22 00 00       	call   80102e20 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 ca 21 00 00       	call   80102e20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 49 62 00 00       	call   80106eb0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 98 64 00 00       	call   80107120 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 91 3d 00 00       	call   80104a60 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 80 3d 00 00       	call   80104a60 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 0d 67 00 00       	call   80107400 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 f8 62 00 00       	call   80107000 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 9c 66 00 00       	call   80107400 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 7c 3c 00 00       	call   80104a20 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 80 5e 00 00       	call   80106c50 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 28 62 00 00       	call   80107000 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 09 20 00 00       	call   80102e20 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 70 76 10 80       	push   $0x80107670
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 7c 76 10 80       	push   $0x8010767c
80100e3b:	68 60 ff 10 80       	push   $0x8010ff60
80100e40:	e8 3b 37 00 00       	call   80104580 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ff 10 80       	push   $0x8010ff60
80100e61:	e8 0a 39 00 00       	call   80104770 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ff 10 80       	push   $0x8010ff60
80100e91:	e8 7a 38 00 00       	call   80104710 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ff 10 80       	push   $0x8010ff60
80100eaa:	e8 61 38 00 00       	call   80104710 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ff 10 80       	push   $0x8010ff60
80100ecf:	e8 9c 38 00 00       	call   80104770 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ff 10 80       	push   $0x8010ff60
80100eec:	e8 1f 38 00 00       	call   80104710 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 83 76 10 80       	push   $0x80107683
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f0c:	00 
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ff 10 80       	push   $0x8010ff60
80100f21:	e8 4a 38 00 00       	call   80104770 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 ff 10 80       	push   $0x8010ff60
80100f5c:	e8 af 37 00 00       	call   80104710 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7d:	00 
80100f7e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f80:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 7d 37 00 00       	jmp    80104710 <release>
80100f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f98:	e8 13 1e 00 00       	call   80102db0 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 69 1e 00 00       	jmp    80102e20 <end_op>
80100fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fbe:	00 
80100fbf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 a2 25 00 00       	call   80103570 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 8b 76 10 80       	push   $0x8010768b
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 7e 26 00 00       	jmp    80103730 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 95 76 10 80       	push   $0x80107695
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 f2 1c 00 00       	call   80102e20 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 5d 1c 00 00       	call   80102db0 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 96 1c 00 00       	call   80102e20 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 9e 76 10 80       	push   $0x8010769e
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 42 24 00 00       	jmp    80103610 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 a4 76 10 80       	push   $0x801076a4
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc 25 11 80    	add    0x801125cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 25 11 80    	cmp    0x801125b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 ae 76 10 80       	push   $0x801076ae
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 e6 1c 00 00       	call   80102f90 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 9e 35 00 00       	call   80104870 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 b6 1c 00 00       	call   80102f90 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 09 11 80       	push   $0x80110960
8010130a:	e8 61 34 00 00       	call   80104770 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131e:	00 
8010131f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 09 11 80       	push   $0x80110960
80101377:	e8 94 33 00 00       	call   80104710 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 09 11 80       	push   $0x80110960
801013a5:	e8 66 33 00 00       	call   80104710 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 c4 76 10 80       	push   $0x801076c4
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013e9:	00 
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 4e 1b 00 00       	call   80102f90 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 d4 76 10 80       	push   $0x801076d4
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101468:	00 
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 a6 1a 00 00       	call   80102f90 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150e:	00 
8010150f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 e7 76 10 80       	push   $0x801076e7
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 9a 33 00 00       	call   80104900 <memmove>
  brelse(bp);
80101566:	83 c4 10             	add    $0x10,%esp
80101569:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 fa 76 10 80       	push   $0x801076fa
80101591:	68 60 09 11 80       	push   $0x80110960
80101596:	e8 e5 2f 00 00       	call   80104580 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 01 77 10 80       	push   $0x80107701
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 9c 2e 00 00       	call   80104450 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 25 11 80       	push   $0x801125b4
801015dc:	e8 1f 33 00 00       	call   80104900 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 25 11 80    	push   0x801125cc
801015ef:	ff 35 c8 25 11 80    	push   0x801125c8
801015f5:	ff 35 c4 25 11 80    	push   0x801125c4
801015fb:	ff 35 c0 25 11 80    	push   0x801125c0
80101601:	ff 35 bc 25 11 80    	push   0x801125bc
80101607:	ff 35 b8 25 11 80    	push   0x801125b8
8010160d:	ff 35 b4 25 11 80    	push   0x801125b4
80101613:	68 50 7b 10 80       	push   $0x80107b50
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010162c:	00 
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165d:	00 
8010165e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 bd 31 00 00       	call   80104870 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 cb 18 00 00       	call   80102f90 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 07 77 10 80       	push   $0x80107707
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 25 11 80    	add    0x801125c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 aa 31 00 00       	call   80104900 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 32 18 00 00       	call   80102f90 <log_write>
  brelse(bp);
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 09 11 80       	push   $0x80110960
8010177f:	e8 ec 2f 00 00       	call   80104770 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010178f:	e8 7c 2f 00 00       	call   80104710 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 c9 2c 00 00       	call   80104490 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 c3 30 00 00       	call   80104900 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 1f 77 10 80       	push   $0x8010771f
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 19 77 10 80       	push   $0x80107719
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187b:	00 
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 98 2c 00 00       	call   80104530 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 3c 2c 00 00       	jmp    801044f0 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 2e 77 10 80       	push   $0x8010772e
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c8:	00 
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 ab 2b 00 00       	call   80104490 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 f1 2b 00 00       	call   801044f0 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101906:	e8 65 2e 00 00       	call   80104770 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 eb 2d 00 00       	jmp    80104710 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 09 11 80       	push   $0x80110960
80101930:	e8 3b 2e 00 00       	call   80104770 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010193f:	e8 cc 2d 00 00       	call   80104710 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	83 c4 10             	add    $0x10,%esp
801019ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a2b:	00 
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 e8 2a 00 00       	call   80104530 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 91 2a 00 00       	call   801044f0 <releasesleep>
  iput(ip);
80101a5f:	83 c4 10             	add    $0x10,%esp
80101a62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 2e 77 10 80       	push   $0x8010772e
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 a4 2d 00 00       	call   80104900 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 09 11 80 	mov    -0x7feef700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 a6 2c 00 00       	call   80104900 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 2e 13 00 00       	call   80102f90 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 8d 2c 00 00       	call   80104970 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 2e 2c 00 00       	call   80104970 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 48 77 10 80       	push   $0x80107748
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 36 77 10 80       	push   $0x80107736
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 11 1c 00 00       	call   801039d0 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 09 11 80       	push   $0x80110960
80101dca:	e8 a1 29 00 00       	call   80104770 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dda:	e8 31 29 00 00       	call   80104710 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 c4 2a 00 00       	call   80104900 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 8f 26 00 00       	call   80104530 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 2d 26 00 00       	call   801044f0 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 10 2a 00 00       	call   80104900 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 06 26 00 00       	call   80104530 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 af 25 00 00       	call   801044f0 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 b6 25 00 00       	call   80104530 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 5f 25 00 00       	call   801044f0 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 2e 77 10 80       	push   $0x8010772e
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 9e 29 00 00       	call   801049c0 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 57 77 10 80       	push   $0x80107757
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 b3 79 10 80       	push   $0x801079b3
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102079:	00 
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209c:	00 
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ee:	00 
801020ef:	90                   	nop
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 6d 77 10 80       	push   $0x8010776d
80102180:	e8 fb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 64 77 10 80       	push   $0x80107764
8010218d:	e8 ee e1 ff ff       	call   80100380 <panic>
80102192:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102199:	00 
8010219a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 7f 77 10 80       	push   $0x8010777f
801021ab:	68 00 26 11 80       	push   $0x80112600
801021b0:	e8 cb 23 00 00       	call   80104580 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 84 a7 14 80       	mov    0x8014a784,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 99 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021cf:	90                   	nop
801021d0:	89 ca                	mov    %ecx,%edx
801021d2:	ec                   	in     (%dx),%al
801021d3:	83 e0 c0             	and    $0xffffffc0,%eax
801021d6:	3c 40                	cmp    $0x40,%al
801021d8:	75 f6                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e5:	89 ca                	mov    %ecx,%edx
801021e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e8:	84 c0                	test   %al,%al
801021ea:	75 1e                	jne    8010220a <ideinit+0x6a>
801021ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801021f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021fd:	00 
801021fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave
80102220:	c3                   	ret
80102221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102228:	00 
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 00 26 11 80       	push   $0x80112600
8010223e:	e8 2d 25 00 00       	call   80104770 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 63                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 33                	mov    (%ebx),%esi
8010225a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102260:	75 2f                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010228f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 be 1f 00 00       	call   80104260 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 00 26 11 80       	push   $0x80112600
801022bb:	e8 50 24 00 00       	call   80104710 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
801022c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022cf:	00 

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 4d 22 00 00       	call   80104530 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c3 00 00 00    	je     801023b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 a8 00 00 00    	je     801023a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 87 00 00 00    	je     80102397 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 00 26 11 80       	push   $0x80112600
80102318:	e8 53 24 00 00       	call   80104770 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	85 c0                	test   %eax,%eax
8010232e:	74 60                	je     80102390 <iderw+0xc0>
80102330:	89 c2                	mov    %eax,%edx
80102332:	8b 40 58             	mov    0x58(%eax),%eax
80102335:	85 c0                	test   %eax,%eax
80102337:	75 f7                	jne    80102330 <iderw+0x60>
80102339:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010233c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010233e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102344:	74 3a                	je     80102380 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102346:	8b 03                	mov    (%ebx),%eax
80102348:	83 e0 06             	and    $0x6,%eax
8010234b:	83 f8 02             	cmp    $0x2,%eax
8010234e:	74 1b                	je     8010236b <iderw+0x9b>
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 00 26 11 80       	push   $0x80112600
80102358:	53                   	push   %ebx
80102359:	e8 42 1e 00 00       	call   801041a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x80>
  }


  release(&idelock);
8010236b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave
  release(&idelock);
80102376:	e9 95 23 00 00       	jmp    80104710 <release>
8010237b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 39 fd ff ff       	call   801020c0 <idestart>
80102387:	eb bd                	jmp    80102346 <iderw+0x76>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102395:	eb a5                	jmp    8010233c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 ae 77 10 80       	push   $0x801077ae
8010239f:	e8 dc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 99 77 10 80       	push   $0x80107799
801023ac:	e8 cf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 83 77 10 80       	push   $0x80107783
801023b9:	e8 c2 df ff ff       	call   80100380 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023cc:	00 c0 fe 
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023e8:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ee:	0f b6 15 80 a7 14 80 	movzbl 0x8014a780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f5:	c1 ee 10             	shr    $0x10,%esi
801023f8:	89 f0                	mov    %esi,%eax
801023fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102400:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102403:	39 c2                	cmp    %eax,%edx
80102405:	74 16                	je     8010241d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 a4 7b 10 80       	push   $0x80107ba4
8010240f:	e8 9c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102414:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010241a:	83 c4 10             	add    $0x10,%esp
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	31 c0                	xor    %eax,%eax
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102428:	89 13                	mov    %edx,(%ebx)
8010242a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010242d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102433:	83 c0 01             	add    $0x1,%eax
80102436:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010243c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010243f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102442:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102445:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102447:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010244d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102454:	39 c6                	cmp    %eax,%esi
80102456:	7d d0                	jge    80102428 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret
8010245f:	90                   	nop

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	55                   	push   %ebp
  ioapic->reg = reg;
80102461:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102467:	89 e5                	mov    %esp,%ebp
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010246c:	8d 50 20             	lea    0x20(%eax),%edx
8010246f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102473:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102475:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010247e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102481:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102484:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102486:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010248e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret
80102493:	66 90                	xchg   %ax,%ax
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
801024a5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024a8:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
801024ae:	0f 85 ae 00 00 00    	jne    80102562 <kfree+0xc2>
801024b4:	81 fe d0 e4 14 80    	cmp    $0x8014e4d0,%esi
801024ba:	0f 82 a2 00 00 00    	jb     80102562 <kfree+0xc2>
801024c0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801024c6:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024cb:	0f 87 91 00 00 00    	ja     80102562 <kfree+0xc2>
    panic("kfree");

  int frame = (V2P(v) / PGSIZE);
801024d1:	c1 e8 0c             	shr    $0xc,%eax
801024d4:	89 c3                	mov    %eax,%ebx
  if(ref_count[frame] > 1) {
801024d6:	8b 04 85 80 26 11 80 	mov    -0x7feed980(,%eax,4),%eax
801024dd:	83 f8 01             	cmp    $0x1,%eax
801024e0:	7e 16                	jle    801024f8 <kfree+0x58>
    ref_count[frame]--; // Decrement reference count
801024e2:	83 e8 01             	sub    $0x1,%eax
801024e5:	89 04 9d 80 26 11 80 	mov    %eax,-0x7feed980(,%ebx,4)
  r->next = kmem.freelist;
  kmem.freelist = r;
  ref_count[frame] = 0; // Reset reference count
  if(kmem.use_lock)
    release(&kmem.lock);
}
801024ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024ef:	5b                   	pop    %ebx
801024f0:	5e                   	pop    %esi
801024f1:	5d                   	pop    %ebp
801024f2:	c3                   	ret
801024f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  memset(v, 1, PGSIZE);
801024f8:	83 ec 04             	sub    $0x4,%esp
801024fb:	68 00 10 00 00       	push   $0x1000
80102500:	6a 01                	push   $0x1
80102502:	56                   	push   %esi
80102503:	e8 68 23 00 00       	call   80104870 <memset>
  if(kmem.use_lock)
80102508:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010250e:	83 c4 10             	add    $0x10,%esp
80102511:	85 d2                	test   %edx,%edx
80102513:	75 3b                	jne    80102550 <kfree+0xb0>
  r->next = kmem.freelist;
80102515:	a1 78 26 11 80       	mov    0x80112678,%eax
8010251a:	89 06                	mov    %eax,(%esi)
  if(kmem.use_lock)
8010251c:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102521:	89 35 78 26 11 80    	mov    %esi,0x80112678
  ref_count[frame] = 0; // Reset reference count
80102527:	c7 04 9d 80 26 11 80 	movl   $0x0,-0x7feed980(,%ebx,4)
8010252e:	00 00 00 00 
  if(kmem.use_lock)
80102532:	85 c0                	test   %eax,%eax
80102534:	74 b6                	je     801024ec <kfree+0x4c>
    release(&kmem.lock);
80102536:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102540:	5b                   	pop    %ebx
80102541:	5e                   	pop    %esi
80102542:	5d                   	pop    %ebp
    release(&kmem.lock);
80102543:	e9 c8 21 00 00       	jmp    80104710 <release>
80102548:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010254f:	00 
    acquire(&kmem.lock);
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 40 26 11 80       	push   $0x80112640
80102558:	e8 13 22 00 00       	call   80104770 <acquire>
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	eb b3                	jmp    80102515 <kfree+0x75>
    panic("kfree");
80102562:	83 ec 0c             	sub    $0xc,%esp
80102565:	68 cc 77 10 80       	push   $0x801077cc
8010256a:	e8 11 de ff ff       	call   80100380 <panic>
8010256f:	90                   	nop

80102570 <freerange>:
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
80102574:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102575:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102578:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010257b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102581:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102587:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010258d:	39 de                	cmp    %ebx,%esi
8010258f:	72 23                	jb     801025b4 <freerange+0x44>
80102591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 f3 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	73 e4                	jae    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret
801025bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801025c0 <kinit2>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
801025c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  memset(ref_count, 0, sizeof(ref_count));
801025c8:	83 ec 04             	sub    $0x4,%esp
801025cb:	68 00 80 03 00       	push   $0x38000
801025d0:	6a 00                	push   $0x0
801025d2:	68 80 26 11 80       	push   $0x80112680
801025d7:	e8 94 22 00 00       	call   80104870 <memset>
  p = (char*)PGROUNDUP((uint)vstart);
801025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025df:	83 c4 10             	add    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801025e2:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f4:	39 de                	cmp    %ebx,%esi
801025f6:	72 24                	jb     8010261c <kinit2+0x5c>
801025f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ff:	00 
    kfree(p);
80102600:	83 ec 0c             	sub    $0xc,%esp
80102603:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102609:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010260f:	50                   	push   %eax
80102610:	e8 8b fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102615:	83 c4 10             	add    $0x10,%esp
80102618:	39 de                	cmp    %ebx,%esi
8010261a:	73 e4                	jae    80102600 <kinit2+0x40>
  kmem.use_lock = 1;
8010261c:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102623:	00 00 00 
}
80102626:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102629:	5b                   	pop    %ebx
8010262a:	5e                   	pop    %esi
8010262b:	5d                   	pop    %ebp
8010262c:	c3                   	ret
8010262d:	8d 76 00             	lea    0x0(%esi),%esi

80102630 <kinit1>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
80102635:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102638:	83 ec 08             	sub    $0x8,%esp
8010263b:	68 d2 77 10 80       	push   $0x801077d2
80102640:	68 40 26 11 80       	push   $0x80112640
80102645:	e8 36 1f 00 00       	call   80104580 <initlock>
  memset(ref_count, 0, sizeof(ref_count));
8010264a:	83 c4 0c             	add    $0xc,%esp
  kmem.use_lock = 0;
8010264d:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102654:	00 00 00 
  memset(ref_count, 0, sizeof(ref_count));
80102657:	68 00 80 03 00       	push   $0x38000
8010265c:	6a 00                	push   $0x0
8010265e:	68 80 26 11 80       	push   $0x80112680
80102663:	e8 08 22 00 00       	call   80104870 <memset>
  p = (char*)PGROUNDUP((uint)vstart);
80102668:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010266b:	83 c4 10             	add    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
8010266e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102674:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102680:	39 de                	cmp    %ebx,%esi
80102682:	72 20                	jb     801026a4 <kinit1+0x74>
80102684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102688:	83 ec 0c             	sub    $0xc,%esp
8010268b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102697:	50                   	push   %eax
80102698:	e8 03 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	39 de                	cmp    %ebx,%esi
801026a2:	73 e4                	jae    80102688 <kinit1+0x58>
}
801026a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026a7:	5b                   	pop    %ebx
801026a8:	5e                   	pop    %esi
801026a9:	5d                   	pop    %ebp
801026aa:	c3                   	ret
801026ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801026bc:	85 c0                	test   %eax,%eax
801026be:	75 30                	jne    801026f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r) {
801026c6:	85 db                	test   %ebx,%ebx
801026c8:	74 1b                	je     801026e5 <kalloc+0x35>
    kmem.freelist = r->next;
801026ca:	8b 03                	mov    (%ebx),%eax
801026cc:	a3 78 26 11 80       	mov    %eax,0x80112678
    int frame = V2P(r) / PGSIZE;
801026d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026d7:	c1 e8 0c             	shr    $0xc,%eax
    ref_count[frame] = 1;
801026da:	c7 04 85 80 26 11 80 	movl   $0x1,-0x7feed980(,%eax,4)
801026e1:	01 00 00 00 
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026e5:	89 d8                	mov    %ebx,%eax
801026e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026ea:	c9                   	leave
801026eb:	c3                   	ret
801026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	68 40 26 11 80       	push   $0x80112640
801026f8:	e8 73 20 00 00       	call   80104770 <acquire>
  r = kmem.freelist;
801026fd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(kmem.use_lock)
80102703:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r) {
80102709:	83 c4 10             	add    $0x10,%esp
8010270c:	85 db                	test   %ebx,%ebx
8010270e:	74 1b                	je     8010272b <kalloc+0x7b>
    kmem.freelist = r->next;
80102710:	8b 03                	mov    (%ebx),%eax
80102712:	a3 78 26 11 80       	mov    %eax,0x80112678
    int frame = V2P(r) / PGSIZE;
80102717:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010271d:	c1 e8 0c             	shr    $0xc,%eax
    ref_count[frame] = 1;
80102720:	c7 04 85 80 26 11 80 	movl   $0x1,-0x7feed980(,%eax,4)
80102727:	01 00 00 00 
  if(kmem.use_lock)
8010272b:	85 d2                	test   %edx,%edx
8010272d:	74 b6                	je     801026e5 <kalloc+0x35>
    release(&kmem.lock);
8010272f:	83 ec 0c             	sub    $0xc,%esp
80102732:	68 40 26 11 80       	push   $0x80112640
80102737:	e8 d4 1f 00 00       	call   80104710 <release>
}
8010273c:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010273e:	83 c4 10             	add    $0x10,%esp
}
80102741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102744:	c9                   	leave
80102745:	c3                   	ret
80102746:	66 90                	xchg   %ax,%ax
80102748:	66 90                	xchg   %ax,%ax
8010274a:	66 90                	xchg   %ax,%ax
8010274c:	66 90                	xchg   %ax,%ax
8010274e:	66 90                	xchg   %ax,%ax

80102750 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102750:	ba 64 00 00 00       	mov    $0x64,%edx
80102755:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102756:	a8 01                	test   $0x1,%al
80102758:	0f 84 c2 00 00 00    	je     80102820 <kbdgetc+0xd0>
{
8010275e:	55                   	push   %ebp
8010275f:	ba 60 00 00 00       	mov    $0x60,%edx
80102764:	89 e5                	mov    %esp,%ebp
80102766:	53                   	push   %ebx
80102767:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102768:	8b 1d 80 a6 14 80    	mov    0x8014a680,%ebx
  data = inb(KBDATAP);
8010276e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102771:	3c e0                	cmp    $0xe0,%al
80102773:	74 5b                	je     801027d0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102775:	89 da                	mov    %ebx,%edx
80102777:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010277a:	84 c0                	test   %al,%al
8010277c:	78 62                	js     801027e0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010277e:	85 d2                	test   %edx,%edx
80102780:	74 09                	je     8010278b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102782:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102785:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102788:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010278b:	0f b6 91 60 7e 10 80 	movzbl -0x7fef81a0(%ecx),%edx
  shift ^= togglecode[data];
80102792:	0f b6 81 60 7d 10 80 	movzbl -0x7fef82a0(%ecx),%eax
  shift |= shiftcode[data];
80102799:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010279b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010279d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010279f:	89 15 80 a6 14 80    	mov    %edx,0x8014a680
  c = charcode[shift & (CTL | SHIFT)][data];
801027a5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027a8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ab:	8b 04 85 40 7d 10 80 	mov    -0x7fef82c0(,%eax,4),%eax
801027b2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027b6:	74 0b                	je     801027c3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027b8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027bb:	83 fa 19             	cmp    $0x19,%edx
801027be:	77 48                	ja     80102808 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027c0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c6:	c9                   	leave
801027c7:	c3                   	ret
801027c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027cf:	00 
    shift |= E0ESC;
801027d0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027d3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027d5:	89 1d 80 a6 14 80    	mov    %ebx,0x8014a680
}
801027db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027de:	c9                   	leave
801027df:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801027e0:	83 e0 7f             	and    $0x7f,%eax
801027e3:	85 d2                	test   %edx,%edx
801027e5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027e8:	0f b6 81 60 7e 10 80 	movzbl -0x7fef81a0(%ecx),%eax
801027ef:	83 c8 40             	or     $0x40,%eax
801027f2:	0f b6 c0             	movzbl %al,%eax
801027f5:	f7 d0                	not    %eax
801027f7:	21 d8                	and    %ebx,%eax
801027f9:	a3 80 a6 14 80       	mov    %eax,0x8014a680
    return 0;
801027fe:	31 c0                	xor    %eax,%eax
80102800:	eb d9                	jmp    801027db <kbdgetc+0x8b>
80102802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102808:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010280b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010280e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102811:	c9                   	leave
      c += 'a' - 'A';
80102812:	83 f9 1a             	cmp    $0x1a,%ecx
80102815:	0f 42 c2             	cmovb  %edx,%eax
}
80102818:	c3                   	ret
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102825:	c3                   	ret
80102826:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010282d:	00 
8010282e:	66 90                	xchg   %ax,%ax

80102830 <kbdintr>:

void
kbdintr(void)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102836:	68 50 27 10 80       	push   $0x80102750
8010283b:	e8 60 e0 ff ff       	call   801008a0 <consoleintr>
}
80102840:	83 c4 10             	add    $0x10,%esp
80102843:	c9                   	leave
80102844:	c3                   	ret
80102845:	66 90                	xchg   %ax,%ax
80102847:	66 90                	xchg   %ax,%ax
80102849:	66 90                	xchg   %ax,%ax
8010284b:	66 90                	xchg   %ax,%ax
8010284d:	66 90                	xchg   %ax,%ax
8010284f:	90                   	nop

80102850 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102850:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102855:	85 c0                	test   %eax,%eax
80102857:	0f 84 c3 00 00 00    	je     80102920 <lapicinit+0xd0>
  lapic[index] = value;
8010285d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102864:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102871:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102877:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010287e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102884:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010288b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102891:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102898:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028a5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028ab:	8b 50 30             	mov    0x30(%eax),%edx
801028ae:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
801028b4:	75 72                	jne    80102928 <lapicinit+0xd8>
  lapic[index] = value;
801028b6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ea:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028f1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028fe:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102901:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102908:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010290e:	80 e6 10             	and    $0x10,%dh
80102911:	75 f5                	jne    80102908 <lapicinit+0xb8>
  lapic[index] = value;
80102913:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010291a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010291d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102920:	c3                   	ret
80102921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102928:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010292f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102932:	8b 50 20             	mov    0x20(%eax),%edx
}
80102935:	e9 7c ff ff ff       	jmp    801028b6 <lapicinit+0x66>
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102940 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102940:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	74 07                	je     80102950 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102949:	8b 40 20             	mov    0x20(%eax),%eax
8010294c:	c1 e8 18             	shr    $0x18,%eax
8010294f:	c3                   	ret
    return 0;
80102950:	31 c0                	xor    %eax,%eax
}
80102952:	c3                   	ret
80102953:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010295a:	00 
8010295b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102960 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102960:	a1 84 a6 14 80       	mov    0x8014a684,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	74 0d                	je     80102976 <lapiceoi+0x16>
  lapic[index] = value;
80102969:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102976:	c3                   	ret
80102977:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010297e:	00 
8010297f:	90                   	nop

80102980 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102980:	c3                   	ret
80102981:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102988:	00 
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102990 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102990:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102991:	b8 0f 00 00 00       	mov    $0xf,%eax
80102996:	ba 70 00 00 00       	mov    $0x70,%edx
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	53                   	push   %ebx
8010299e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029a4:	ee                   	out    %al,(%dx)
801029a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029aa:	ba 71 00 00 00       	mov    $0x71,%edx
801029af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029b0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
801029b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029bd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
801029c0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029c2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ce:	a1 84 a6 14 80       	mov    0x8014a684,%eax
801029d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a05:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1d:	c9                   	leave
80102a1e:	c3                   	ret
80102a1f:	90                   	nop

80102a20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a20:	55                   	push   %ebp
80102a21:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a26:	ba 70 00 00 00       	mov    $0x70,%edx
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	57                   	push   %edi
80102a2e:	56                   	push   %esi
80102a2f:	53                   	push   %ebx
80102a30:	83 ec 4c             	sub    $0x4c,%esp
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	ba 71 00 00 00       	mov    $0x71,%edx
80102a39:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a3a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a42:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a45:	8d 76 00             	lea    0x0(%esi),%esi
80102a48:	31 c0                	xor    %eax,%eax
80102a4a:	89 fa                	mov    %edi,%edx
80102a4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a52:	89 ca                	mov    %ecx,%edx
80102a54:	ec                   	in     (%dx),%al
80102a55:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a58:	89 fa                	mov    %edi,%edx
80102a5a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a60:	89 ca                	mov    %ecx,%edx
80102a62:	ec                   	in     (%dx),%al
80102a63:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a66:	89 fa                	mov    %edi,%edx
80102a68:	b8 04 00 00 00       	mov    $0x4,%eax
80102a6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6e:	89 ca                	mov    %ecx,%edx
80102a70:	ec                   	in     (%dx),%al
80102a71:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 fa                	mov    %edi,%edx
80102a76:	b8 07 00 00 00       	mov    $0x7,%eax
80102a7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al
80102a7f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a82:	89 fa                	mov    %edi,%edx
80102a84:	b8 08 00 00 00       	mov    $0x8,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8f:	89 fa                	mov    %edi,%edx
80102a91:	b8 09 00 00 00       	mov    $0x9,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 fa                	mov    %edi,%edx
80102a9f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aa4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa5:	89 ca                	mov    %ecx,%edx
80102aa7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102aa8:	84 c0                	test   %al,%al
80102aaa:	78 9c                	js     80102a48 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102aac:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ab0:	89 f2                	mov    %esi,%edx
80102ab2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102ab5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab8:	89 fa                	mov    %edi,%edx
80102aba:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102abd:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ac1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102ac4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ac7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102acb:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ace:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ad2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ad5:	31 c0                	xor    %eax,%eax
80102ad7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad8:	89 ca                	mov    %ecx,%edx
80102ada:	ec                   	in     (%dx),%al
80102adb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ade:	89 fa                	mov    %edi,%edx
80102ae0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ae3:	b8 02 00 00 00       	mov    $0x2,%eax
80102ae8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae9:	89 ca                	mov    %ecx,%edx
80102aeb:	ec                   	in     (%dx),%al
80102aec:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aef:	89 fa                	mov    %edi,%edx
80102af1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102af4:	b8 04 00 00 00       	mov    $0x4,%eax
80102af9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afa:	89 ca                	mov    %ecx,%edx
80102afc:	ec                   	in     (%dx),%al
80102afd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b00:	89 fa                	mov    %edi,%edx
80102b02:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b05:	b8 07 00 00 00       	mov    $0x7,%eax
80102b0a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0b:	89 ca                	mov    %ecx,%edx
80102b0d:	ec                   	in     (%dx),%al
80102b0e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b11:	89 fa                	mov    %edi,%edx
80102b13:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b16:	b8 08 00 00 00       	mov    $0x8,%eax
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	89 ca                	mov    %ecx,%edx
80102b1e:	ec                   	in     (%dx),%al
80102b1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b22:	89 fa                	mov    %edi,%edx
80102b24:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b27:	b8 09 00 00 00       	mov    $0x9,%eax
80102b2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2d:	89 ca                	mov    %ecx,%edx
80102b2f:	ec                   	in     (%dx),%al
80102b30:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b33:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b39:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b3c:	6a 18                	push   $0x18
80102b3e:	50                   	push   %eax
80102b3f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b42:	50                   	push   %eax
80102b43:	e8 68 1d 00 00       	call   801048b0 <memcmp>
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 c0                	test   %eax,%eax
80102b4d:	0f 85 f5 fe ff ff    	jne    80102a48 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b53:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b5a:	89 f0                	mov    %esi,%eax
80102b5c:	84 c0                	test   %al,%al
80102b5e:	75 78                	jne    80102bd8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 c2                	mov    %eax,%edx
80102b65:	83 e0 0f             	and    $0xf,%eax
80102b68:	c1 ea 04             	shr    $0x4,%edx
80102b6b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b71:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b74:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b77:	89 c2                	mov    %eax,%edx
80102b79:	83 e0 0f             	and    $0xf,%eax
80102b7c:	c1 ea 04             	shr    $0x4,%edx
80102b7f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b82:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b85:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b88:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b8b:	89 c2                	mov    %eax,%edx
80102b8d:	83 e0 0f             	and    $0xf,%eax
80102b90:	c1 ea 04             	shr    $0x4,%edx
80102b93:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b96:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b99:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b9c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9f:	89 c2                	mov    %eax,%edx
80102ba1:	83 e0 0f             	and    $0xf,%eax
80102ba4:	c1 ea 04             	shr    $0x4,%edx
80102ba7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102baa:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bb0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb3:	89 c2                	mov    %eax,%edx
80102bb5:	83 e0 0f             	and    $0xf,%eax
80102bb8:	c1 ea 04             	shr    $0x4,%edx
80102bbb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc7:	89 c2                	mov    %eax,%edx
80102bc9:	83 e0 0f             	and    $0xf,%eax
80102bcc:	c1 ea 04             	shr    $0x4,%edx
80102bcf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bdb:	89 03                	mov    %eax,(%ebx)
80102bdd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102be0:	89 43 04             	mov    %eax,0x4(%ebx)
80102be3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102be6:	89 43 08             	mov    %eax,0x8(%ebx)
80102be9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bec:	89 43 0c             	mov    %eax,0xc(%ebx)
80102bef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bf2:	89 43 10             	mov    %eax,0x10(%ebx)
80102bf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bf8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102bfb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c05:	5b                   	pop    %ebx
80102c06:	5e                   	pop    %esi
80102c07:	5f                   	pop    %edi
80102c08:	5d                   	pop    %ebp
80102c09:	c3                   	ret
80102c0a:	66 90                	xchg   %ax,%ax
80102c0c:	66 90                	xchg   %ax,%ax
80102c0e:	66 90                	xchg   %ax,%ax

80102c10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c10:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102c16:	85 c9                	test   %ecx,%ecx
80102c18:	0f 8e 8a 00 00 00    	jle    80102ca8 <install_trans+0x98>
{
80102c1e:	55                   	push   %ebp
80102c1f:	89 e5                	mov    %esp,%ebp
80102c21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c22:	31 ff                	xor    %edi,%edi
{
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 0c             	sub    $0xc,%esp
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c30:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102c35:	83 ec 08             	sub    $0x8,%esp
80102c38:	01 f8                	add    %edi,%eax
80102c3a:	83 c0 01             	add    $0x1,%eax
80102c3d:	50                   	push   %eax
80102c3e:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102c44:	e8 87 d4 ff ff       	call   801000d0 <bread>
80102c49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c4b:	58                   	pop    %eax
80102c4c:	5a                   	pop    %edx
80102c4d:	ff 34 bd ec a6 14 80 	push   -0x7feb5914(,%edi,4)
80102c54:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5d:	e8 6e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6a:	68 00 02 00 00       	push   $0x200
80102c6f:	50                   	push   %eax
80102c70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c73:	50                   	push   %eax
80102c74:	e8 87 1c 00 00       	call   80104900 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c79:	89 1c 24             	mov    %ebx,(%esp)
80102c7c:	e8 2f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 67 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c89:	89 1c 24             	mov    %ebx,(%esp)
80102c8c:	e8 5f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c91:	83 c4 10             	add    $0x10,%esp
80102c94:	39 3d e8 a6 14 80    	cmp    %edi,0x8014a6e8
80102c9a:	7f 94                	jg     80102c30 <install_trans+0x20>
  }
}
80102c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c9f:	5b                   	pop    %ebx
80102ca0:	5e                   	pop    %esi
80102ca1:	5f                   	pop    %edi
80102ca2:	5d                   	pop    %ebp
80102ca3:	c3                   	ret
80102ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ca8:	c3                   	ret
80102ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cb7:	ff 35 d4 a6 14 80    	push   0x8014a6d4
80102cbd:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102cc3:	e8 08 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ccb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ccd:	a1 e8 a6 14 80       	mov    0x8014a6e8,%eax
80102cd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	7e 19                	jle    80102cf2 <write_head+0x42>
80102cd9:	31 d2                	xor    %edx,%edx
80102cdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ce0:	8b 0c 95 ec a6 14 80 	mov    -0x7feb5914(,%edx,4),%ecx
80102ce7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ceb:	83 c2 01             	add    $0x1,%edx
80102cee:	39 d0                	cmp    %edx,%eax
80102cf0:	75 ee                	jne    80102ce0 <write_head+0x30>
  }
  bwrite(buf);
80102cf2:	83 ec 0c             	sub    $0xc,%esp
80102cf5:	53                   	push   %ebx
80102cf6:	e8 b5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cfb:	89 1c 24             	mov    %ebx,(%esp)
80102cfe:	e8 ed d4 ff ff       	call   801001f0 <brelse>
}
80102d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d06:	83 c4 10             	add    $0x10,%esp
80102d09:	c9                   	leave
80102d0a:	c3                   	ret
80102d0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d10 <initlog>:
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 2c             	sub    $0x2c,%esp
80102d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d1a:	68 d7 77 10 80       	push   $0x801077d7
80102d1f:	68 a0 a6 14 80       	push   $0x8014a6a0
80102d24:	e8 57 18 00 00       	call   80104580 <initlock>
  readsb(dev, &sb);
80102d29:	58                   	pop    %eax
80102d2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d2d:	5a                   	pop    %edx
80102d2e:	50                   	push   %eax
80102d2f:	53                   	push   %ebx
80102d30:	e8 0b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d38:	59                   	pop    %ecx
  log.dev = dev;
80102d39:	89 1d e4 a6 14 80    	mov    %ebx,0x8014a6e4
  log.size = sb.nlog;
80102d3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d42:	a3 d4 a6 14 80       	mov    %eax,0x8014a6d4
  log.size = sb.nlog;
80102d47:	89 15 d8 a6 14 80    	mov    %edx,0x8014a6d8
  struct buf *buf = bread(log.dev, log.start);
80102d4d:	5a                   	pop    %edx
80102d4e:	50                   	push   %eax
80102d4f:	53                   	push   %ebx
80102d50:	e8 7b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d55:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d58:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d5b:	89 1d e8 a6 14 80    	mov    %ebx,0x8014a6e8
  for (i = 0; i < log.lh.n; i++) {
80102d61:	85 db                	test   %ebx,%ebx
80102d63:	7e 1d                	jle    80102d82 <initlog+0x72>
80102d65:	31 d2                	xor    %edx,%edx
80102d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d6e:	00 
80102d6f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d70:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d74:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d7b:	83 c2 01             	add    $0x1,%edx
80102d7e:	39 d3                	cmp    %edx,%ebx
80102d80:	75 ee                	jne    80102d70 <initlog+0x60>
  brelse(buf);
80102d82:	83 ec 0c             	sub    $0xc,%esp
80102d85:	50                   	push   %eax
80102d86:	e8 65 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d8b:	e8 80 fe ff ff       	call   80102c10 <install_trans>
  log.lh.n = 0;
80102d90:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
80102d97:	00 00 00 
  write_head(); // clear the log
80102d9a:	e8 11 ff ff ff       	call   80102cb0 <write_head>
}
80102d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	c9                   	leave
80102da6:	c3                   	ret
80102da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dae:	00 
80102daf:	90                   	nop

80102db0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102db6:	68 a0 a6 14 80       	push   $0x8014a6a0
80102dbb:	e8 b0 19 00 00       	call   80104770 <acquire>
80102dc0:	83 c4 10             	add    $0x10,%esp
80102dc3:	eb 18                	jmp    80102ddd <begin_op+0x2d>
80102dc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dc8:	83 ec 08             	sub    $0x8,%esp
80102dcb:	68 a0 a6 14 80       	push   $0x8014a6a0
80102dd0:	68 a0 a6 14 80       	push   $0x8014a6a0
80102dd5:	e8 c6 13 00 00       	call   801041a0 <sleep>
80102dda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ddd:	a1 e0 a6 14 80       	mov    0x8014a6e0,%eax
80102de2:	85 c0                	test   %eax,%eax
80102de4:	75 e2                	jne    80102dc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102de6:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
80102deb:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80102df1:	83 c0 01             	add    $0x1,%eax
80102df4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102df7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dfa:	83 fa 1e             	cmp    $0x1e,%edx
80102dfd:	7f c9                	jg     80102dc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e02:	a3 dc a6 14 80       	mov    %eax,0x8014a6dc
      release(&log.lock);
80102e07:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e0c:	e8 ff 18 00 00       	call   80104710 <release>
      break;
    }
  }
}
80102e11:	83 c4 10             	add    $0x10,%esp
80102e14:	c9                   	leave
80102e15:	c3                   	ret
80102e16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e1d:	00 
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	57                   	push   %edi
80102e24:	56                   	push   %esi
80102e25:	53                   	push   %ebx
80102e26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e29:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e2e:	e8 3d 19 00 00       	call   80104770 <acquire>
  log.outstanding -= 1;
80102e33:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
  if(log.committing)
80102e38:	8b 35 e0 a6 14 80    	mov    0x8014a6e0,%esi
80102e3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e41:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e44:	89 1d dc a6 14 80    	mov    %ebx,0x8014a6dc
  if(log.committing)
80102e4a:	85 f6                	test   %esi,%esi
80102e4c:	0f 85 22 01 00 00    	jne    80102f74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e52:	85 db                	test   %ebx,%ebx
80102e54:	0f 85 f6 00 00 00    	jne    80102f50 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e5a:	c7 05 e0 a6 14 80 01 	movl   $0x1,0x8014a6e0
80102e61:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e64:	83 ec 0c             	sub    $0xc,%esp
80102e67:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e6c:	e8 9f 18 00 00       	call   80104710 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e71:	8b 0d e8 a6 14 80    	mov    0x8014a6e8,%ecx
80102e77:	83 c4 10             	add    $0x10,%esp
80102e7a:	85 c9                	test   %ecx,%ecx
80102e7c:	7f 42                	jg     80102ec0 <end_op+0xa0>
    acquire(&log.lock);
80102e7e:	83 ec 0c             	sub    $0xc,%esp
80102e81:	68 a0 a6 14 80       	push   $0x8014a6a0
80102e86:	e8 e5 18 00 00       	call   80104770 <acquire>
    log.committing = 0;
80102e8b:	c7 05 e0 a6 14 80 00 	movl   $0x0,0x8014a6e0
80102e92:	00 00 00 
    wakeup(&log);
80102e95:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80102e9c:	e8 bf 13 00 00       	call   80104260 <wakeup>
    release(&log.lock);
80102ea1:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80102ea8:	e8 63 18 00 00       	call   80104710 <release>
80102ead:	83 c4 10             	add    $0x10,%esp
}
80102eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb3:	5b                   	pop    %ebx
80102eb4:	5e                   	pop    %esi
80102eb5:	5f                   	pop    %edi
80102eb6:	5d                   	pop    %ebp
80102eb7:	c3                   	ret
80102eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ebf:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ec0:	a1 d4 a6 14 80       	mov    0x8014a6d4,%eax
80102ec5:	83 ec 08             	sub    $0x8,%esp
80102ec8:	01 d8                	add    %ebx,%eax
80102eca:	83 c0 01             	add    $0x1,%eax
80102ecd:	50                   	push   %eax
80102ece:	ff 35 e4 a6 14 80    	push   0x8014a6e4
80102ed4:	e8 f7 d1 ff ff       	call   801000d0 <bread>
80102ed9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102edb:	58                   	pop    %eax
80102edc:	5a                   	pop    %edx
80102edd:	ff 34 9d ec a6 14 80 	push   -0x7feb5914(,%ebx,4)
80102ee4:	ff 35 e4 a6 14 80    	push   0x8014a6e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eed:	e8 de d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ef2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ef5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ef7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102efa:	68 00 02 00 00       	push   $0x200
80102eff:	50                   	push   %eax
80102f00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f03:	50                   	push   %eax
80102f04:	e8 f7 19 00 00       	call   80104900 <memmove>
    bwrite(to);  // write the log
80102f09:	89 34 24             	mov    %esi,(%esp)
80102f0c:	e8 9f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f11:	89 3c 24             	mov    %edi,(%esp)
80102f14:	e8 d7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 cf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	3b 1d e8 a6 14 80    	cmp    0x8014a6e8,%ebx
80102f2a:	7c 94                	jl     80102ec0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f2c:	e8 7f fd ff ff       	call   80102cb0 <write_head>
    install_trans(); // Now install writes to home locations
80102f31:	e8 da fc ff ff       	call   80102c10 <install_trans>
    log.lh.n = 0;
80102f36:	c7 05 e8 a6 14 80 00 	movl   $0x0,0x8014a6e8
80102f3d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f40:	e8 6b fd ff ff       	call   80102cb0 <write_head>
80102f45:	e9 34 ff ff ff       	jmp    80102e7e <end_op+0x5e>
80102f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f50:	83 ec 0c             	sub    $0xc,%esp
80102f53:	68 a0 a6 14 80       	push   $0x8014a6a0
80102f58:	e8 03 13 00 00       	call   80104260 <wakeup>
  release(&log.lock);
80102f5d:	c7 04 24 a0 a6 14 80 	movl   $0x8014a6a0,(%esp)
80102f64:	e8 a7 17 00 00       	call   80104710 <release>
80102f69:	83 c4 10             	add    $0x10,%esp
}
80102f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5f                   	pop    %edi
80102f72:	5d                   	pop    %ebp
80102f73:	c3                   	ret
    panic("log.committing");
80102f74:	83 ec 0c             	sub    $0xc,%esp
80102f77:	68 db 77 10 80       	push   $0x801077db
80102f7c:	e8 ff d3 ff ff       	call   80100380 <panic>
80102f81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f88:	00 
80102f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	53                   	push   %ebx
80102f94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f97:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
{
80102f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa0:	83 fa 1d             	cmp    $0x1d,%edx
80102fa3:	7f 7d                	jg     80103022 <log_write+0x92>
80102fa5:	a1 d8 a6 14 80       	mov    0x8014a6d8,%eax
80102faa:	83 e8 01             	sub    $0x1,%eax
80102fad:	39 c2                	cmp    %eax,%edx
80102faf:	7d 71                	jge    80103022 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fb1:	a1 dc a6 14 80       	mov    0x8014a6dc,%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	7e 75                	jle    8010302f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fba:	83 ec 0c             	sub    $0xc,%esp
80102fbd:	68 a0 a6 14 80       	push   $0x8014a6a0
80102fc2:	e8 a9 17 00 00       	call   80104770 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fca:	83 c4 10             	add    $0x10,%esp
80102fcd:	31 c0                	xor    %eax,%eax
80102fcf:	8b 15 e8 a6 14 80    	mov    0x8014a6e8,%edx
80102fd5:	85 d2                	test   %edx,%edx
80102fd7:	7f 0e                	jg     80102fe7 <log_write+0x57>
80102fd9:	eb 15                	jmp    80102ff0 <log_write+0x60>
80102fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fe0:	83 c0 01             	add    $0x1,%eax
80102fe3:	39 c2                	cmp    %eax,%edx
80102fe5:	74 29                	je     80103010 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe7:	39 0c 85 ec a6 14 80 	cmp    %ecx,-0x7feb5914(,%eax,4)
80102fee:	75 f0                	jne    80102fe0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 85 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%eax,4)
  if (i == log.lh.n)
80102ff7:	39 c2                	cmp    %eax,%edx
80102ff9:	74 1c                	je     80103017 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102ffb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102ffe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103001:	c7 45 08 a0 a6 14 80 	movl   $0x8014a6a0,0x8(%ebp)
}
80103008:	c9                   	leave
  release(&log.lock);
80103009:	e9 02 17 00 00       	jmp    80104710 <release>
8010300e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103010:	89 0c 95 ec a6 14 80 	mov    %ecx,-0x7feb5914(,%edx,4)
    log.lh.n++;
80103017:	83 c2 01             	add    $0x1,%edx
8010301a:	89 15 e8 a6 14 80    	mov    %edx,0x8014a6e8
80103020:	eb d9                	jmp    80102ffb <log_write+0x6b>
    panic("too big a transaction");
80103022:	83 ec 0c             	sub    $0xc,%esp
80103025:	68 ea 77 10 80       	push   $0x801077ea
8010302a:	e8 51 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010302f:	83 ec 0c             	sub    $0xc,%esp
80103032:	68 00 78 10 80       	push   $0x80107800
80103037:	e8 44 d3 ff ff       	call   80100380 <panic>
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	53                   	push   %ebx
80103044:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103047:	e8 64 09 00 00       	call   801039b0 <cpuid>
8010304c:	89 c3                	mov    %eax,%ebx
8010304e:	e8 5d 09 00 00       	call   801039b0 <cpuid>
80103053:	83 ec 04             	sub    $0x4,%esp
80103056:	53                   	push   %ebx
80103057:	50                   	push   %eax
80103058:	68 1b 78 10 80       	push   $0x8010781b
8010305d:	e8 4e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103062:	e8 d9 2a 00 00       	call   80105b40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103067:	e8 e4 08 00 00       	call   80103950 <mycpu>
8010306c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010306e:	b8 01 00 00 00       	mov    $0x1,%eax
80103073:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010307a:	e8 11 0d 00 00       	call   80103d90 <scheduler>
8010307f:	90                   	nop

80103080 <mpenter>:
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103086:	e8 b5 3b 00 00       	call   80106c40 <switchkvm>
  seginit();
8010308b:	e8 20 3b 00 00       	call   80106bb0 <seginit>
  lapicinit();
80103090:	e8 bb f7 ff ff       	call   80102850 <lapicinit>
  mpmain();
80103095:	e8 a6 ff ff ff       	call   80103040 <mpmain>
8010309a:	66 90                	xchg   %ax,%ax
8010309c:	66 90                	xchg   %ax,%ax
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <main>:
{
801030a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030a4:	83 e4 f0             	and    $0xfffffff0,%esp
801030a7:	ff 71 fc             	push   -0x4(%ecx)
801030aa:	55                   	push   %ebp
801030ab:	89 e5                	mov    %esp,%ebp
801030ad:	53                   	push   %ebx
801030ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030af:	83 ec 08             	sub    $0x8,%esp
801030b2:	68 00 00 40 80       	push   $0x80400000
801030b7:	68 d0 e4 14 80       	push   $0x8014e4d0
801030bc:	e8 6f f5 ff ff       	call   80102630 <kinit1>
  kvmalloc();      // kernel page table
801030c1:	e8 3a 40 00 00       	call   80107100 <kvmalloc>
  mpinit();        // detect other processors
801030c6:	e8 85 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030cb:	e8 80 f7 ff ff       	call   80102850 <lapicinit>
  seginit();       // segment descriptors
801030d0:	e8 db 3a 00 00       	call   80106bb0 <seginit>
  picinit();       // disable pic
801030d5:	e8 86 03 00 00       	call   80103460 <picinit>
  ioapicinit();    // another interrupt controller
801030da:	e8 e1 f2 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
801030df:	e8 7c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030e4:	e8 37 2d 00 00       	call   80105e20 <uartinit>
  pinit();         // process table
801030e9:	e8 42 08 00 00       	call   80103930 <pinit>
  tvinit();        // trap vectors
801030ee:	e8 cd 29 00 00       	call   80105ac0 <tvinit>
  binit();         // buffer cache
801030f3:	e8 48 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030f8:	e8 33 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
801030fd:	e8 9e f0 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103102:	83 c4 0c             	add    $0xc,%esp
80103105:	68 8a 00 00 00       	push   $0x8a
8010310a:	68 8c b4 10 80       	push   $0x8010b48c
8010310f:	68 00 70 00 80       	push   $0x80007000
80103114:	e8 e7 17 00 00       	call   80104900 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
80103123:	00 00 00 
80103126:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
8010312b:	3d a0 a7 14 80       	cmp    $0x8014a7a0,%eax
80103130:	76 7e                	jbe    801031b0 <main+0x110>
80103132:	bb a0 a7 14 80       	mov    $0x8014a7a0,%ebx
80103137:	eb 20                	jmp    80103159 <main+0xb9>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	69 05 84 a7 14 80 b0 	imul   $0xb0,0x8014a784,%eax
80103147:	00 00 00 
8010314a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103150:	05 a0 a7 14 80       	add    $0x8014a7a0,%eax
80103155:	39 c3                	cmp    %eax,%ebx
80103157:	73 57                	jae    801031b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103159:	e8 f2 07 00 00       	call   80103950 <mycpu>
8010315e:	39 c3                	cmp    %eax,%ebx
80103160:	74 de                	je     80103140 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103162:	e8 49 f5 ff ff       	call   801026b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103167:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010316a:	c7 05 f8 6f 00 80 80 	movl   $0x80103080,0x80006ff8
80103171:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103174:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010317b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010317e:	05 00 10 00 00       	add    $0x1000,%eax
80103183:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103188:	0f b6 03             	movzbl (%ebx),%eax
8010318b:	68 00 70 00 00       	push   $0x7000
80103190:	50                   	push   %eax
80103191:	e8 fa f7 ff ff       	call   80102990 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103196:	83 c4 10             	add    $0x10,%esp
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 f6                	je     801031a0 <main+0x100>
801031aa:	eb 94                	jmp    80103140 <main+0xa0>
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b0:	83 ec 08             	sub    $0x8,%esp
801031b3:	68 00 00 00 8e       	push   $0x8e000000
801031b8:	68 00 00 40 80       	push   $0x80400000
801031bd:	e8 fe f3 ff ff       	call   801025c0 <kinit2>
  userinit();      // first user process
801031c2:	e8 39 08 00 00       	call   80103a00 <userinit>
  mpmain();        // finish this processor's setup
801031c7:	e8 74 fe ff ff       	call   80103040 <mpmain>
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031db:	53                   	push   %ebx
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	72 10                	jb     801031f6 <mpsearch1+0x26>
801031e6:	eb 50                	jmp    80103238 <mpsearch1+0x68>
801031e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031ef:	00 
801031f0:	89 fe                	mov    %edi,%esi
801031f2:	39 df                	cmp    %ebx,%edi
801031f4:	73 42                	jae    80103238 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f6:	83 ec 04             	sub    $0x4,%esp
801031f9:	8d 7e 10             	lea    0x10(%esi),%edi
801031fc:	6a 04                	push   $0x4
801031fe:	68 2f 78 10 80       	push   $0x8010782f
80103203:	56                   	push   %esi
80103204:	e8 a7 16 00 00       	call   801048b0 <memcmp>
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	85 c0                	test   %eax,%eax
8010320e:	75 e0                	jne    801031f0 <mpsearch1+0x20>
80103210:	89 f2                	mov    %esi,%edx
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103218:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010321b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010321e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c0                	test   %al,%al
80103226:	75 c8                	jne    801031f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010322b:	89 f0                	mov    %esi,%eax
8010322d:	5b                   	pop    %ebx
8010322e:	5e                   	pop    %esi
8010322f:	5f                   	pop    %edi
80103230:	5d                   	pop    %ebp
80103231:	c3                   	ret
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010323b:	31 f6                	xor    %esi,%esi
}
8010323d:	5b                   	pop    %ebx
8010323e:	89 f0                	mov    %esi,%eax
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret
80103244:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010324b:	00 
8010324c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103259:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103260:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103267:	c1 e0 08             	shl    $0x8,%eax
8010326a:	09 d0                	or     %edx,%eax
8010326c:	c1 e0 04             	shl    $0x4,%eax
8010326f:	75 1b                	jne    8010328c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103271:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103278:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010327f:	c1 e0 08             	shl    $0x8,%eax
80103282:	09 d0                	or     %edx,%eax
80103284:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103287:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010328c:	ba 00 04 00 00       	mov    $0x400,%edx
80103291:	e8 3a ff ff ff       	call   801031d0 <mpsearch1>
80103296:	89 c3                	mov    %eax,%ebx
80103298:	85 c0                	test   %eax,%eax
8010329a:	0f 84 58 01 00 00    	je     801033f8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a0:	8b 73 04             	mov    0x4(%ebx),%esi
801032a3:	85 f6                	test   %esi,%esi
801032a5:	0f 84 3d 01 00 00    	je     801033e8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801032ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ae:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801032b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032b7:	6a 04                	push   $0x4
801032b9:	68 34 78 10 80       	push   $0x80107834
801032be:	50                   	push   %eax
801032bf:	e8 ec 15 00 00       	call   801048b0 <memcmp>
801032c4:	83 c4 10             	add    $0x10,%esp
801032c7:	85 c0                	test   %eax,%eax
801032c9:	0f 85 19 01 00 00    	jne    801033e8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801032cf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032d6:	3c 01                	cmp    $0x1,%al
801032d8:	74 08                	je     801032e2 <mpinit+0x92>
801032da:	3c 04                	cmp    $0x4,%al
801032dc:	0f 85 06 01 00 00    	jne    801033e8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801032e2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032e9:	66 85 d2             	test   %dx,%dx
801032ec:	74 22                	je     80103310 <mpinit+0xc0>
801032ee:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032f1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032f3:	31 d2                	xor    %edx,%edx
801032f5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032f8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032ff:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103302:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103304:	39 f8                	cmp    %edi,%eax
80103306:	75 f0                	jne    801032f8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103308:	84 d2                	test   %dl,%dl
8010330a:	0f 85 d8 00 00 00    	jne    801033e8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103310:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010331c:	a3 84 a6 14 80       	mov    %eax,0x8014a684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103321:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103328:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010332e:	01 d7                	add    %edx,%edi
80103330:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103332:	bf 01 00 00 00       	mov    $0x1,%edi
80103337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010333e:	00 
8010333f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103340:	39 d0                	cmp    %edx,%eax
80103342:	73 19                	jae    8010335d <mpinit+0x10d>
    switch(*p){
80103344:	0f b6 08             	movzbl (%eax),%ecx
80103347:	80 f9 02             	cmp    $0x2,%cl
8010334a:	0f 84 80 00 00 00    	je     801033d0 <mpinit+0x180>
80103350:	77 6e                	ja     801033c0 <mpinit+0x170>
80103352:	84 c9                	test   %cl,%cl
80103354:	74 3a                	je     80103390 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103356:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103359:	39 d0                	cmp    %edx,%eax
8010335b:	72 e7                	jb     80103344 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010335d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103360:	85 ff                	test   %edi,%edi
80103362:	0f 84 dd 00 00 00    	je     80103445 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103368:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010336c:	74 15                	je     80103383 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	b8 70 00 00 00       	mov    $0x70,%eax
80103373:	ba 22 00 00 00       	mov    $0x22,%edx
80103378:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103379:	ba 23 00 00 00       	mov    $0x23,%edx
8010337e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010337f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103382:	ee                   	out    %al,(%dx)
  }
}
80103383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103386:	5b                   	pop    %ebx
80103387:	5e                   	pop    %esi
80103388:	5f                   	pop    %edi
80103389:	5d                   	pop    %ebp
8010338a:	c3                   	ret
8010338b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103390:	8b 0d 84 a7 14 80    	mov    0x8014a784,%ecx
80103396:	83 f9 07             	cmp    $0x7,%ecx
80103399:	7f 19                	jg     801033b4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801033a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033a5:	83 c1 01             	add    $0x1,%ecx
801033a8:	89 0d 84 a7 14 80    	mov    %ecx,0x8014a784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ae:	88 9e a0 a7 14 80    	mov    %bl,-0x7feb5860(%esi)
      p += sizeof(struct mpproc);
801033b4:	83 c0 14             	add    $0x14,%eax
      continue;
801033b7:	eb 87                	jmp    80103340 <mpinit+0xf0>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801033c0:	83 e9 03             	sub    $0x3,%ecx
801033c3:	80 f9 01             	cmp    $0x1,%cl
801033c6:	76 8e                	jbe    80103356 <mpinit+0x106>
801033c8:	31 ff                	xor    %edi,%edi
801033ca:	e9 71 ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033cf:	90                   	nop
      ioapicid = ioapic->apicno;
801033d0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033d7:	88 0d 80 a7 14 80    	mov    %cl,0x8014a780
      continue;
801033dd:	e9 5e ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033e8:	83 ec 0c             	sub    $0xc,%esp
801033eb:	68 39 78 10 80       	push   $0x80107839
801033f0:	e8 8b cf ff ff       	call   80100380 <panic>
801033f5:	8d 76 00             	lea    0x0(%esi),%esi
{
801033f8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033fd:	eb 0b                	jmp    8010340a <mpinit+0x1ba>
801033ff:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103400:	89 f3                	mov    %esi,%ebx
80103402:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103408:	74 de                	je     801033e8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340a:	83 ec 04             	sub    $0x4,%esp
8010340d:	8d 73 10             	lea    0x10(%ebx),%esi
80103410:	6a 04                	push   $0x4
80103412:	68 2f 78 10 80       	push   $0x8010782f
80103417:	53                   	push   %ebx
80103418:	e8 93 14 00 00       	call   801048b0 <memcmp>
8010341d:	83 c4 10             	add    $0x10,%esp
80103420:	85 c0                	test   %eax,%eax
80103422:	75 dc                	jne    80103400 <mpinit+0x1b0>
80103424:	89 da                	mov    %ebx,%edx
80103426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010342d:	00 
8010342e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103430:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103433:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103436:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103438:	39 d6                	cmp    %edx,%esi
8010343a:	75 f4                	jne    80103430 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010343c:	84 c0                	test   %al,%al
8010343e:	75 c0                	jne    80103400 <mpinit+0x1b0>
80103440:	e9 5b fe ff ff       	jmp    801032a0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103445:	83 ec 0c             	sub    $0xc,%esp
80103448:	68 d8 7b 10 80       	push   $0x80107bd8
8010344d:	e8 2e cf ff ff       	call   80100380 <panic>
80103452:	66 90                	xchg   %ax,%ax
80103454:	66 90                	xchg   %ax,%ax
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <picinit>:
80103460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103465:	ba 21 00 00 00       	mov    $0x21,%edx
8010346a:	ee                   	out    %al,(%dx)
8010346b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103470:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103471:	c3                   	ret
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 0c             	sub    $0xc,%esp
80103489:	8b 75 08             	mov    0x8(%ebp),%esi
8010348c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010348f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103495:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010349b:	e8 b0 d9 ff ff       	call   80100e50 <filealloc>
801034a0:	89 06                	mov    %eax,(%esi)
801034a2:	85 c0                	test   %eax,%eax
801034a4:	0f 84 a5 00 00 00    	je     8010354f <pipealloc+0xcf>
801034aa:	e8 a1 d9 ff ff       	call   80100e50 <filealloc>
801034af:	89 07                	mov    %eax,(%edi)
801034b1:	85 c0                	test   %eax,%eax
801034b3:	0f 84 84 00 00 00    	je     8010353d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034b9:	e8 f2 f1 ff ff       	call   801026b0 <kalloc>
801034be:	89 c3                	mov    %eax,%ebx
801034c0:	85 c0                	test   %eax,%eax
801034c2:	0f 84 a0 00 00 00    	je     80103568 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801034c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034dc:	00 00 00 
  p->nwrite = 0;
801034df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034e6:	00 00 00 
  p->nread = 0;
801034e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034f0:	00 00 00 
  initlock(&p->lock, "pipe");
801034f3:	68 51 78 10 80       	push   $0x80107851
801034f8:	50                   	push   %eax
801034f9:	e8 82 10 00 00       	call   80104580 <initlock>
  (*f0)->type = FD_PIPE;
801034fe:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103500:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103503:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103509:	8b 06                	mov    (%esi),%eax
8010350b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010350f:	8b 06                	mov    (%esi),%eax
80103511:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103515:	8b 06                	mov    (%esi),%eax
80103517:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010351a:	8b 07                	mov    (%edi),%eax
8010351c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103522:	8b 07                	mov    (%edi),%eax
80103524:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103528:	8b 07                	mov    (%edi),%eax
8010352a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010352e:	8b 07                	mov    (%edi),%eax
80103530:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103533:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103535:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103538:	5b                   	pop    %ebx
80103539:	5e                   	pop    %esi
8010353a:	5f                   	pop    %edi
8010353b:	5d                   	pop    %ebp
8010353c:	c3                   	ret
  if(*f0)
8010353d:	8b 06                	mov    (%esi),%eax
8010353f:	85 c0                	test   %eax,%eax
80103541:	74 1e                	je     80103561 <pipealloc+0xe1>
    fileclose(*f0);
80103543:	83 ec 0c             	sub    $0xc,%esp
80103546:	50                   	push   %eax
80103547:	e8 c4 d9 ff ff       	call   80100f10 <fileclose>
8010354c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010354f:	8b 07                	mov    (%edi),%eax
80103551:	85 c0                	test   %eax,%eax
80103553:	74 0c                	je     80103561 <pipealloc+0xe1>
    fileclose(*f1);
80103555:	83 ec 0c             	sub    $0xc,%esp
80103558:	50                   	push   %eax
80103559:	e8 b2 d9 ff ff       	call   80100f10 <fileclose>
8010355e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103566:	eb cd                	jmp    80103535 <pipealloc+0xb5>
  if(*f0)
80103568:	8b 06                	mov    (%esi),%eax
8010356a:	85 c0                	test   %eax,%eax
8010356c:	75 d5                	jne    80103543 <pipealloc+0xc3>
8010356e:	eb df                	jmp    8010354f <pipealloc+0xcf>

80103570 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103578:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010357b:	83 ec 0c             	sub    $0xc,%esp
8010357e:	53                   	push   %ebx
8010357f:	e8 ec 11 00 00       	call   80104770 <acquire>
  if(writable){
80103584:	83 c4 10             	add    $0x10,%esp
80103587:	85 f6                	test   %esi,%esi
80103589:	74 65                	je     801035f0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010358b:	83 ec 0c             	sub    $0xc,%esp
8010358e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103594:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010359b:	00 00 00 
    wakeup(&p->nread);
8010359e:	50                   	push   %eax
8010359f:	e8 bc 0c 00 00       	call   80104260 <wakeup>
801035a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ad:	85 d2                	test   %edx,%edx
801035af:	75 0a                	jne    801035bb <pipeclose+0x4b>
801035b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035b7:	85 c0                	test   %eax,%eax
801035b9:	74 15                	je     801035d0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c1:	5b                   	pop    %ebx
801035c2:	5e                   	pop    %esi
801035c3:	5d                   	pop    %ebp
    release(&p->lock);
801035c4:	e9 47 11 00 00       	jmp    80104710 <release>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 37 11 00 00       	call   80104710 <release>
    kfree((char*)p);
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5d                   	pop    %ebp
    kfree((char*)p);
801035e5:	e9 b6 ee ff ff       	jmp    801024a0 <kfree>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103600:	00 00 00 
    wakeup(&p->nwrite);
80103603:	50                   	push   %eax
80103604:	e8 57 0c 00 00       	call   80104260 <wakeup>
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	eb 99                	jmp    801035a7 <pipeclose+0x37>
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 28             	sub    $0x28,%esp
80103619:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010361c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010361f:	53                   	push   %ebx
80103620:	e8 4b 11 00 00       	call   80104770 <acquire>
  for(i = 0; i < n; i++){
80103625:	83 c4 10             	add    $0x10,%esp
80103628:	85 ff                	test   %edi,%edi
8010362a:	0f 8e ce 00 00 00    	jle    801036fe <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103630:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103636:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103639:	89 7d 10             	mov    %edi,0x10(%ebp)
8010363c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010363f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103642:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103645:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010364b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103651:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103657:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010365d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103660:	0f 85 b6 00 00 00    	jne    8010371c <pipewrite+0x10c>
80103666:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103669:	eb 3b                	jmp    801036a6 <pipewrite+0x96>
8010366b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103670:	e8 5b 03 00 00       	call   801039d0 <myproc>
80103675:	8b 48 24             	mov    0x24(%eax),%ecx
80103678:	85 c9                	test   %ecx,%ecx
8010367a:	75 34                	jne    801036b0 <pipewrite+0xa0>
      wakeup(&p->nread);
8010367c:	83 ec 0c             	sub    $0xc,%esp
8010367f:	56                   	push   %esi
80103680:	e8 db 0b 00 00       	call   80104260 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103685:	58                   	pop    %eax
80103686:	5a                   	pop    %edx
80103687:	53                   	push   %ebx
80103688:	57                   	push   %edi
80103689:	e8 12 0b 00 00       	call   801041a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010368e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103694:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	05 00 02 00 00       	add    $0x200,%eax
801036a2:	39 c2                	cmp    %eax,%edx
801036a4:	75 2a                	jne    801036d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036a6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036ac:	85 c0                	test   %eax,%eax
801036ae:	75 c0                	jne    80103670 <pipewrite+0x60>
        release(&p->lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	53                   	push   %ebx
801036b4:	e8 57 10 00 00       	call   80104710 <release>
        return -1;
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c4:	5b                   	pop    %ebx
801036c5:	5e                   	pop    %esi
801036c6:	5f                   	pop    %edi
801036c7:	5d                   	pop    %ebp
801036c8:	c3                   	ret
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d3:	8d 42 01             	lea    0x1(%edx),%eax
801036d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801036dc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036df:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036e8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801036ec:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036f3:	39 c1                	cmp    %eax,%ecx
801036f5:	0f 85 50 ff ff ff    	jne    8010364b <pipewrite+0x3b>
801036fb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103707:	50                   	push   %eax
80103708:	e8 53 0b 00 00       	call   80104260 <wakeup>
  release(&p->lock);
8010370d:	89 1c 24             	mov    %ebx,(%esp)
80103710:	e8 fb 0f 00 00       	call   80104710 <release>
  return n;
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	89 f8                	mov    %edi,%eax
8010371a:	eb a5                	jmp    801036c1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010371c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010371f:	eb b2                	jmp    801036d3 <pipewrite+0xc3>
80103721:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103728:	00 
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103730 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 18             	sub    $0x18,%esp
80103739:	8b 75 08             	mov    0x8(%ebp),%esi
8010373c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010373f:	56                   	push   %esi
80103740:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103746:	e8 25 10 00 00       	call   80104770 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103751:	83 c4 10             	add    $0x10,%esp
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	74 2f                	je     8010378b <piperead+0x5b>
8010375c:	eb 37                	jmp    80103795 <piperead+0x65>
8010375e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103760:	e8 6b 02 00 00       	call   801039d0 <myproc>
80103765:	8b 40 24             	mov    0x24(%eax),%eax
80103768:	85 c0                	test   %eax,%eax
8010376a:	0f 85 80 00 00 00    	jne    801037f0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	56                   	push   %esi
80103774:	53                   	push   %ebx
80103775:	e8 26 0a 00 00       	call   801041a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010377a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103780:	83 c4 10             	add    $0x10,%esp
80103783:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103789:	75 0a                	jne    80103795 <piperead+0x65>
8010378b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103791:	85 d2                	test   %edx,%edx
80103793:	75 cb                	jne    80103760 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103795:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103798:	31 db                	xor    %ebx,%ebx
8010379a:	85 c9                	test   %ecx,%ecx
8010379c:	7f 26                	jg     801037c4 <piperead+0x94>
8010379e:	eb 2c                	jmp    801037cc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037a0:	8d 48 01             	lea    0x1(%eax),%ecx
801037a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b6:	83 c3 01             	add    $0x1,%ebx
801037b9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037bc:	74 0e                	je     801037cc <piperead+0x9c>
801037be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801037c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ca:	75 d4                	jne    801037a0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037d5:	50                   	push   %eax
801037d6:	e8 85 0a 00 00       	call   80104260 <wakeup>
  release(&p->lock);
801037db:	89 34 24             	mov    %esi,(%esp)
801037de:	e8 2d 0f 00 00       	call   80104710 <release>
  return i;
801037e3:	83 c4 10             	add    $0x10,%esp
}
801037e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e9:	89 d8                	mov    %ebx,%eax
801037eb:	5b                   	pop    %ebx
801037ec:	5e                   	pop    %esi
801037ed:	5f                   	pop    %edi
801037ee:	5d                   	pop    %ebp
801037ef:	c3                   	ret
      release(&p->lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037f8:	56                   	push   %esi
801037f9:	e8 12 0f 00 00       	call   80104710 <release>
      return -1;
801037fe:	83 c4 10             	add    $0x10,%esp
}
80103801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103804:	89 d8                	mov    %ebx,%eax
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret
8010380b:	66 90                	xchg   %ax,%ax
8010380d:	66 90                	xchg   %ax,%ax
8010380f:	90                   	nop

80103810 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103814:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
{
80103819:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010381c:	68 20 ad 14 80       	push   $0x8014ad20
80103821:	e8 4a 0f 00 00       	call   80104770 <acquire>
80103826:	83 c4 10             	add    $0x10,%esp
80103829:	eb 10                	jmp    8010383b <allocproc+0x2b>
8010382b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	83 c3 7c             	add    $0x7c,%ebx
80103833:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103839:	74 75                	je     801038b0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010383b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010383e:	85 c0                	test   %eax,%eax
80103840:	75 ee                	jne    80103830 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103842:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103847:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010384a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103851:	89 43 10             	mov    %eax,0x10(%ebx)
80103854:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103857:	68 20 ad 14 80       	push   $0x8014ad20
  p->pid = nextpid++;
8010385c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103862:	e8 a9 0e 00 00       	call   80104710 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103867:	e8 44 ee ff ff       	call   801026b0 <kalloc>
8010386c:	83 c4 10             	add    $0x10,%esp
8010386f:	89 43 08             	mov    %eax,0x8(%ebx)
80103872:	85 c0                	test   %eax,%eax
80103874:	74 53                	je     801038c9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103876:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010387c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010387f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103884:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103887:	c7 40 14 ad 5a 10 80 	movl   $0x80105aad,0x14(%eax)
  p->context = (struct context*)sp;
8010388e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103891:	6a 14                	push   $0x14
80103893:	6a 00                	push   $0x0
80103895:	50                   	push   %eax
80103896:	e8 d5 0f 00 00       	call   80104870 <memset>
  p->context->eip = (uint)forkret;
8010389b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010389e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038a1:	c7 40 10 e0 38 10 80 	movl   $0x801038e0,0x10(%eax)
}
801038a8:	89 d8                	mov    %ebx,%eax
801038aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ad:	c9                   	leave
801038ae:	c3                   	ret
801038af:	90                   	nop
  release(&ptable.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038b5:	68 20 ad 14 80       	push   $0x8014ad20
801038ba:	e8 51 0e 00 00       	call   80104710 <release>
  return 0;
801038bf:	83 c4 10             	add    $0x10,%esp
}
801038c2:	89 d8                	mov    %ebx,%eax
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave
801038c8:	c3                   	ret
    p->state = UNUSED;
801038c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801038d0:	31 db                	xor    %ebx,%ebx
801038d2:	eb ee                	jmp    801038c2 <allocproc+0xb2>
801038d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038db:	00 
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038e6:	68 20 ad 14 80       	push   $0x8014ad20
801038eb:	e8 20 0e 00 00       	call   80104710 <release>

  if (first) {
801038f0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	85 c0                	test   %eax,%eax
801038fa:	75 04                	jne    80103900 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038fc:	c9                   	leave
801038fd:	c3                   	ret
801038fe:	66 90                	xchg   %ax,%ax
    first = 0;
80103900:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103907:	00 00 00 
    iinit(ROOTDEV);
8010390a:	83 ec 0c             	sub    $0xc,%esp
8010390d:	6a 01                	push   $0x1
8010390f:	e8 6c dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
80103914:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010391b:	e8 f0 f3 ff ff       	call   80102d10 <initlog>
}
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	c9                   	leave
80103924:	c3                   	ret
80103925:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010392c:	00 
8010392d:	8d 76 00             	lea    0x0(%esi),%esi

80103930 <pinit>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103936:	68 56 78 10 80       	push   $0x80107856
8010393b:	68 20 ad 14 80       	push   $0x8014ad20
80103940:	e8 3b 0c 00 00       	call   80104580 <initlock>
}
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	c9                   	leave
80103949:	c3                   	ret
8010394a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103950 <mycpu>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	56                   	push   %esi
80103954:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103955:	9c                   	pushf
80103956:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103957:	f6 c4 02             	test   $0x2,%ah
8010395a:	75 46                	jne    801039a2 <mycpu+0x52>
  apicid = lapicid();
8010395c:	e8 df ef ff ff       	call   80102940 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103961:	8b 35 84 a7 14 80    	mov    0x8014a784,%esi
80103967:	85 f6                	test   %esi,%esi
80103969:	7e 2a                	jle    80103995 <mycpu+0x45>
8010396b:	31 d2                	xor    %edx,%edx
8010396d:	eb 08                	jmp    80103977 <mycpu+0x27>
8010396f:	90                   	nop
80103970:	83 c2 01             	add    $0x1,%edx
80103973:	39 f2                	cmp    %esi,%edx
80103975:	74 1e                	je     80103995 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103977:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010397d:	0f b6 99 a0 a7 14 80 	movzbl -0x7feb5860(%ecx),%ebx
80103984:	39 c3                	cmp    %eax,%ebx
80103986:	75 e8                	jne    80103970 <mycpu+0x20>
}
80103988:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010398b:	8d 81 a0 a7 14 80    	lea    -0x7feb5860(%ecx),%eax
}
80103991:	5b                   	pop    %ebx
80103992:	5e                   	pop    %esi
80103993:	5d                   	pop    %ebp
80103994:	c3                   	ret
  panic("unknown apicid\n");
80103995:	83 ec 0c             	sub    $0xc,%esp
80103998:	68 5d 78 10 80       	push   $0x8010785d
8010399d:	e8 de c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
801039a2:	83 ec 0c             	sub    $0xc,%esp
801039a5:	68 f8 7b 10 80       	push   $0x80107bf8
801039aa:	e8 d1 c9 ff ff       	call   80100380 <panic>
801039af:	90                   	nop

801039b0 <cpuid>:
cpuid() {
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039b6:	e8 95 ff ff ff       	call   80103950 <mycpu>
}
801039bb:	c9                   	leave
  return mycpu()-cpus;
801039bc:	2d a0 a7 14 80       	sub    $0x8014a7a0,%eax
801039c1:	c1 f8 04             	sar    $0x4,%eax
801039c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ca:	c3                   	ret
801039cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039d0 <myproc>:
myproc(void) {
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	53                   	push   %ebx
801039d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039d7:	e8 44 0c 00 00       	call   80104620 <pushcli>
  c = mycpu();
801039dc:	e8 6f ff ff ff       	call   80103950 <mycpu>
  p = c->proc;
801039e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039e7:	e8 84 0c 00 00       	call   80104670 <popcli>
}
801039ec:	89 d8                	mov    %ebx,%eax
801039ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039f1:	c9                   	leave
801039f2:	c3                   	ret
801039f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039fa:	00 
801039fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a00 <userinit>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
80103a04:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a07:	e8 04 fe ff ff       	call   80103810 <allocproc>
80103a0c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a0e:	a3 54 cc 14 80       	mov    %eax,0x8014cc54
  if((p->pgdir = setupkvm()) == 0)
80103a13:	e8 68 36 00 00       	call   80107080 <setupkvm>
80103a18:	89 43 04             	mov    %eax,0x4(%ebx)
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	0f 84 bd 00 00 00    	je     80103ae0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a23:	83 ec 04             	sub    $0x4,%esp
80103a26:	68 2c 00 00 00       	push   $0x2c
80103a2b:	68 60 b4 10 80       	push   $0x8010b460
80103a30:	50                   	push   %eax
80103a31:	e8 2a 33 00 00       	call   80106d60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a36:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a3f:	6a 4c                	push   $0x4c
80103a41:	6a 00                	push   $0x0
80103a43:	ff 73 18             	push   0x18(%ebx)
80103a46:	e8 25 0e 00 00       	call   80104870 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a4b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a53:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a56:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a66:	8b 43 18             	mov    0x18(%ebx),%eax
80103a69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a6d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a71:	8b 43 18             	mov    0x18(%ebx),%eax
80103a74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a78:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a86:	8b 43 18             	mov    0x18(%ebx),%eax
80103a89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a90:	8b 43 18             	mov    0x18(%ebx),%eax
80103a93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a9a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a9d:	6a 10                	push   $0x10
80103a9f:	68 86 78 10 80       	push   $0x80107886
80103aa4:	50                   	push   %eax
80103aa5:	e8 76 0f 00 00       	call   80104a20 <safestrcpy>
  p->cwd = namei("/");
80103aaa:	c7 04 24 8f 78 10 80 	movl   $0x8010788f,(%esp)
80103ab1:	e8 ca e5 ff ff       	call   80102080 <namei>
80103ab6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ab9:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103ac0:	e8 ab 0c 00 00       	call   80104770 <acquire>
  p->state = RUNNABLE;
80103ac5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103acc:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103ad3:	e8 38 0c 00 00       	call   80104710 <release>
}
80103ad8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103adb:	83 c4 10             	add    $0x10,%esp
80103ade:	c9                   	leave
80103adf:	c3                   	ret
    panic("userinit: out of memory?");
80103ae0:	83 ec 0c             	sub    $0xc,%esp
80103ae3:	68 6d 78 10 80       	push   $0x8010786d
80103ae8:	e8 93 c8 ff ff       	call   80100380 <panic>
80103aed:	8d 76 00             	lea    0x0(%esi),%esi

80103af0 <growproc>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
80103af5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103af8:	e8 23 0b 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103afd:	e8 4e fe ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b02:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b08:	e8 63 0b 00 00       	call   80104670 <popcli>
  sz = curproc->sz;
80103b0d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b0f:	85 f6                	test   %esi,%esi
80103b11:	7f 1d                	jg     80103b30 <growproc+0x40>
  } else if(n < 0){
80103b13:	75 3b                	jne    80103b50 <growproc+0x60>
  switchuvm(curproc);
80103b15:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b18:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b1a:	53                   	push   %ebx
80103b1b:	e8 30 31 00 00       	call   80106c50 <switchuvm>
  return 0;
80103b20:	83 c4 10             	add    $0x10,%esp
80103b23:	31 c0                	xor    %eax,%eax
}
80103b25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b28:	5b                   	pop    %ebx
80103b29:	5e                   	pop    %esi
80103b2a:	5d                   	pop    %ebp
80103b2b:	c3                   	ret
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	push   0x4(%ebx)
80103b3a:	e8 71 33 00 00       	call   80106eb0 <allocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 cf                	jne    80103b15 <growproc+0x25>
      return -1;
80103b46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b4b:	eb d8                	jmp    80103b25 <growproc+0x35>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 c6                	add    %eax,%esi
80103b55:	56                   	push   %esi
80103b56:	50                   	push   %eax
80103b57:	ff 73 04             	push   0x4(%ebx)
80103b5a:	e8 71 34 00 00       	call   80106fd0 <deallocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	75 af                	jne    80103b15 <growproc+0x25>
80103b66:	eb de                	jmp    80103b46 <growproc+0x56>
80103b68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b6f:	00 

80103b70 <fork>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b79:	e8 a2 0a 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103b7e:	e8 cd fd ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b89:	e8 e2 0a 00 00       	call   80104670 <popcli>
  if((np = allocproc()) == 0){
80103b8e:	e8 7d fc ff ff       	call   80103810 <allocproc>
80103b93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b96:	85 c0                	test   %eax,%eax
80103b98:	0f 84 d6 00 00 00    	je     80103c74 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b9e:	83 ec 08             	sub    $0x8,%esp
80103ba1:	ff 33                	push   (%ebx)
80103ba3:	89 c7                	mov    %eax,%edi
80103ba5:	ff 73 04             	push   0x4(%ebx)
80103ba8:	e8 c3 35 00 00       	call   80107170 <copyuvm>
80103bad:	83 c4 10             	add    $0x10,%esp
80103bb0:	89 47 04             	mov    %eax,0x4(%edi)
80103bb3:	85 c0                	test   %eax,%eax
80103bb5:	0f 84 9a 00 00 00    	je     80103c55 <fork+0xe5>
  np->sz = curproc->sz;
80103bbb:	8b 03                	mov    (%ebx),%eax
80103bbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bc0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103bc2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103bc5:	89 c8                	mov    %ecx,%eax
80103bc7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bca:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bcf:	8b 73 18             	mov    0x18(%ebx),%esi
80103bd2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bd4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bd6:	8b 40 18             	mov    0x18(%eax),%eax
80103bd9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103be0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 13                	je     80103bfb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	50                   	push   %eax
80103bec:	e8 cf d2 ff ff       	call   80100ec0 <filedup>
80103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bfb:	83 c6 01             	add    $0x1,%esi
80103bfe:	83 fe 10             	cmp    $0x10,%esi
80103c01:	75 dd                	jne    80103be0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c0c:	e8 5f db ff ff       	call   80101770 <idup>
80103c11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	53                   	push   %ebx
80103c20:	50                   	push   %eax
80103c21:	e8 fa 0d 00 00       	call   80104a20 <safestrcpy>
  pid = np->pid;
80103c26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c29:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103c30:	e8 3b 0b 00 00       	call   80104770 <acquire>
  np->state = RUNNABLE;
80103c35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c3c:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103c43:	e8 c8 0a 00 00       	call   80104710 <release>
  return pid;
80103c48:	83 c4 10             	add    $0x10,%esp
}
80103c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c4e:	89 d8                	mov    %ebx,%eax
80103c50:	5b                   	pop    %ebx
80103c51:	5e                   	pop    %esi
80103c52:	5f                   	pop    %edi
80103c53:	5d                   	pop    %ebp
80103c54:	c3                   	ret
    kfree(np->kstack);
80103c55:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	ff 73 08             	push   0x8(%ebx)
80103c5e:	e8 3d e8 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103c63:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c6a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c6d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c74:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c79:	eb d0                	jmp    80103c4b <fork+0xdb>
80103c7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103c80 <forkcow>:
int forkcow(void) {
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c89:	e8 92 09 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103c8e:	e8 bd fc ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103c93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c99:	e8 d2 09 00 00       	call   80104670 <popcli>
  if((np = allocproc()) == 0){
80103c9e:	e8 6d fb ff ff       	call   80103810 <allocproc>
80103ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ca6:	85 c0                	test   %eax,%eax
80103ca8:	0f 84 d6 00 00 00    	je     80103d84 <forkcow+0x104>
  if((np->pgdir = copyuvmcow(curproc->pgdir, curproc->sz)) == 0){
80103cae:	83 ec 08             	sub    $0x8,%esp
80103cb1:	ff 33                	push   (%ebx)
80103cb3:	89 c7                	mov    %eax,%edi
80103cb5:	ff 73 04             	push   0x4(%ebx)
80103cb8:	e8 e3 35 00 00       	call   801072a0 <copyuvmcow>
80103cbd:	83 c4 10             	add    $0x10,%esp
80103cc0:	89 47 04             	mov    %eax,0x4(%edi)
80103cc3:	85 c0                	test   %eax,%eax
80103cc5:	0f 84 9a 00 00 00    	je     80103d65 <forkcow+0xe5>
  np->sz = curproc->sz;
80103ccb:	8b 03                	mov    (%ebx),%eax
80103ccd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cd0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103cd2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103cd5:	89 c8                	mov    %ecx,%eax
80103cd7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103cda:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cdf:	8b 73 18             	mov    0x18(%ebx),%esi
80103ce2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++){
80103ce4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ce6:	8b 40 18             	mov    0x18(%eax),%eax
80103ce9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i]){
80103cf0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	74 13                	je     80103d0b <forkcow+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cf8:	83 ec 0c             	sub    $0xc,%esp
80103cfb:	50                   	push   %eax
80103cfc:	e8 bf d1 ff ff       	call   80100ec0 <filedup>
80103d01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d04:	83 c4 10             	add    $0x10,%esp
80103d07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++){
80103d0b:	83 c6 01             	add    $0x1,%esi
80103d0e:	83 fe 10             	cmp    $0x10,%esi
80103d11:	75 dd                	jne    80103cf0 <forkcow+0x70>
  np->cwd = idup(curproc->cwd);
80103d13:	83 ec 0c             	sub    $0xc,%esp
80103d16:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d1c:	e8 4f da ff ff       	call   80101770 <idup>
80103d21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d2d:	6a 10                	push   $0x10
80103d2f:	53                   	push   %ebx
80103d30:	50                   	push   %eax
80103d31:	e8 ea 0c 00 00       	call   80104a20 <safestrcpy>
  pid = np->pid;
80103d36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d39:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103d40:	e8 2b 0a 00 00       	call   80104770 <acquire>
  np->state = RUNNABLE;
80103d45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d4c:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103d53:	e8 b8 09 00 00       	call   80104710 <release>
  return pid;
80103d58:	83 c4 10             	add    $0x10,%esp
}
80103d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d5e:	89 d8                	mov    %ebx,%eax
80103d60:	5b                   	pop    %ebx
80103d61:	5e                   	pop    %esi
80103d62:	5f                   	pop    %edi
80103d63:	5d                   	pop    %ebp
80103d64:	c3                   	ret
    kfree(np->kstack);
80103d65:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d68:	83 ec 0c             	sub    $0xc,%esp
80103d6b:	ff 73 08             	push   0x8(%ebx)
80103d6e:	e8 2d e7 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103d73:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d7a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d7d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d84:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d89:	eb d0                	jmp    80103d5b <forkcow+0xdb>
80103d8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103d90 <scheduler>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d99:	e8 b2 fb ff ff       	call   80103950 <mycpu>
  c->proc = 0;
80103d9e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103da5:	00 00 00 
  struct cpu *c = mycpu();
80103da8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103daa:	8d 78 04             	lea    0x4(%eax),%edi
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103db0:	fb                   	sti
    acquire(&ptable.lock);
80103db1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db4:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
    acquire(&ptable.lock);
80103db9:	68 20 ad 14 80       	push   $0x8014ad20
80103dbe:	e8 ad 09 00 00       	call   80104770 <acquire>
80103dc3:	83 c4 10             	add    $0x10,%esp
80103dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dcd:	00 
80103dce:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103dd0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103dd4:	75 33                	jne    80103e09 <scheduler+0x79>
      switchuvm(p);
80103dd6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103dd9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ddf:	53                   	push   %ebx
80103de0:	e8 6b 2e 00 00       	call   80106c50 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103de5:	58                   	pop    %eax
80103de6:	5a                   	pop    %edx
80103de7:	ff 73 1c             	push   0x1c(%ebx)
80103dea:	57                   	push   %edi
      p->state = RUNNING;
80103deb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103df2:	e8 84 0c 00 00       	call   80104a7b <swtch>
      switchkvm();
80103df7:	e8 44 2e 00 00       	call   80106c40 <switchkvm>
      c->proc = 0;
80103dfc:	83 c4 10             	add    $0x10,%esp
80103dff:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e06:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e09:	83 c3 7c             	add    $0x7c,%ebx
80103e0c:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80103e12:	75 bc                	jne    80103dd0 <scheduler+0x40>
    release(&ptable.lock);
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	68 20 ad 14 80       	push   $0x8014ad20
80103e1c:	e8 ef 08 00 00       	call   80104710 <release>
    sti();
80103e21:	83 c4 10             	add    $0x10,%esp
80103e24:	eb 8a                	jmp    80103db0 <scheduler+0x20>
80103e26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e2d:	00 
80103e2e:	66 90                	xchg   %ax,%ax

80103e30 <sched>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
  pushcli();
80103e35:	e8 e6 07 00 00       	call   80104620 <pushcli>
  c = mycpu();
80103e3a:	e8 11 fb ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103e3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e45:	e8 26 08 00 00       	call   80104670 <popcli>
  if(!holding(&ptable.lock))
80103e4a:	83 ec 0c             	sub    $0xc,%esp
80103e4d:	68 20 ad 14 80       	push   $0x8014ad20
80103e52:	e8 79 08 00 00       	call   801046d0 <holding>
80103e57:	83 c4 10             	add    $0x10,%esp
80103e5a:	85 c0                	test   %eax,%eax
80103e5c:	74 4f                	je     80103ead <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e5e:	e8 ed fa ff ff       	call   80103950 <mycpu>
80103e63:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e6a:	75 68                	jne    80103ed4 <sched+0xa4>
  if(p->state == RUNNING)
80103e6c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e70:	74 55                	je     80103ec7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e72:	9c                   	pushf
80103e73:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e74:	f6 c4 02             	test   $0x2,%ah
80103e77:	75 41                	jne    80103eba <sched+0x8a>
  intena = mycpu()->intena;
80103e79:	e8 d2 fa ff ff       	call   80103950 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e7e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e81:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e87:	e8 c4 fa ff ff       	call   80103950 <mycpu>
80103e8c:	83 ec 08             	sub    $0x8,%esp
80103e8f:	ff 70 04             	push   0x4(%eax)
80103e92:	53                   	push   %ebx
80103e93:	e8 e3 0b 00 00       	call   80104a7b <swtch>
  mycpu()->intena = intena;
80103e98:	e8 b3 fa ff ff       	call   80103950 <mycpu>
}
80103e9d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ea0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ea6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ea9:	5b                   	pop    %ebx
80103eaa:	5e                   	pop    %esi
80103eab:	5d                   	pop    %ebp
80103eac:	c3                   	ret
    panic("sched ptable.lock");
80103ead:	83 ec 0c             	sub    $0xc,%esp
80103eb0:	68 91 78 10 80       	push   $0x80107891
80103eb5:	e8 c6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 bd 78 10 80       	push   $0x801078bd
80103ec2:	e8 b9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103ec7:	83 ec 0c             	sub    $0xc,%esp
80103eca:	68 af 78 10 80       	push   $0x801078af
80103ecf:	e8 ac c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103ed4:	83 ec 0c             	sub    $0xc,%esp
80103ed7:	68 a3 78 10 80       	push   $0x801078a3
80103edc:	e8 9f c4 ff ff       	call   80100380 <panic>
80103ee1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ee8:	00 
80103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ef0 <exit>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ef9:	e8 d2 fa ff ff       	call   801039d0 <myproc>
  if(curproc == initproc)
80103efe:	39 05 54 cc 14 80    	cmp    %eax,0x8014cc54
80103f04:	0f 84 fd 00 00 00    	je     80104007 <exit+0x117>
80103f0a:	89 c3                	mov    %eax,%ebx
80103f0c:	8d 70 28             	lea    0x28(%eax),%esi
80103f0f:	8d 78 68             	lea    0x68(%eax),%edi
80103f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103f18:	8b 06                	mov    (%esi),%eax
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 12                	je     80103f30 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103f1e:	83 ec 0c             	sub    $0xc,%esp
80103f21:	50                   	push   %eax
80103f22:	e8 e9 cf ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103f27:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f2d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f30:	83 c6 04             	add    $0x4,%esi
80103f33:	39 f7                	cmp    %esi,%edi
80103f35:	75 e1                	jne    80103f18 <exit+0x28>
  begin_op();
80103f37:	e8 74 ee ff ff       	call   80102db0 <begin_op>
  iput(curproc->cwd);
80103f3c:	83 ec 0c             	sub    $0xc,%esp
80103f3f:	ff 73 68             	push   0x68(%ebx)
80103f42:	e8 89 d9 ff ff       	call   801018d0 <iput>
  end_op();
80103f47:	e8 d4 ee ff ff       	call   80102e20 <end_op>
  curproc->cwd = 0;
80103f4c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f53:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80103f5a:	e8 11 08 00 00       	call   80104770 <acquire>
  wakeup1(curproc->parent);
80103f5f:	8b 53 14             	mov    0x14(%ebx),%edx
80103f62:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f65:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
80103f6a:	eb 0e                	jmp    80103f7a <exit+0x8a>
80103f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f70:	83 c0 7c             	add    $0x7c,%eax
80103f73:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80103f78:	74 1c                	je     80103f96 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103f7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f7e:	75 f0                	jne    80103f70 <exit+0x80>
80103f80:	3b 50 20             	cmp    0x20(%eax),%edx
80103f83:	75 eb                	jne    80103f70 <exit+0x80>
      p->state = RUNNABLE;
80103f85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f8c:	83 c0 7c             	add    $0x7c,%eax
80103f8f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80103f94:	75 e4                	jne    80103f7a <exit+0x8a>
      p->parent = initproc;
80103f96:	8b 0d 54 cc 14 80    	mov    0x8014cc54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	ba 54 ad 14 80       	mov    $0x8014ad54,%edx
80103fa1:	eb 10                	jmp    80103fb3 <exit+0xc3>
80103fa3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fa8:	83 c2 7c             	add    $0x7c,%edx
80103fab:	81 fa 54 cc 14 80    	cmp    $0x8014cc54,%edx
80103fb1:	74 3b                	je     80103fee <exit+0xfe>
    if(p->parent == curproc){
80103fb3:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103fb6:	75 f0                	jne    80103fa8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103fb8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103fbc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103fbf:	75 e7                	jne    80103fa8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fc1:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
80103fc6:	eb 12                	jmp    80103fda <exit+0xea>
80103fc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fcf:	00 
80103fd0:	83 c0 7c             	add    $0x7c,%eax
80103fd3:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80103fd8:	74 ce                	je     80103fa8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103fda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fde:	75 f0                	jne    80103fd0 <exit+0xe0>
80103fe0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fe3:	75 eb                	jne    80103fd0 <exit+0xe0>
      p->state = RUNNABLE;
80103fe5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fec:	eb e2                	jmp    80103fd0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fee:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ff5:	e8 36 fe ff ff       	call   80103e30 <sched>
  panic("zombie exit");
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 de 78 10 80       	push   $0x801078de
80104002:	e8 79 c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104007:	83 ec 0c             	sub    $0xc,%esp
8010400a:	68 d1 78 10 80       	push   $0x801078d1
8010400f:	e8 6c c3 ff ff       	call   80100380 <panic>
80104014:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010401b:	00 
8010401c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104020 <wait>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	56                   	push   %esi
80104024:	53                   	push   %ebx
  pushcli();
80104025:	e8 f6 05 00 00       	call   80104620 <pushcli>
  c = mycpu();
8010402a:	e8 21 f9 ff ff       	call   80103950 <mycpu>
  p = c->proc;
8010402f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104035:	e8 36 06 00 00       	call   80104670 <popcli>
  acquire(&ptable.lock);
8010403a:	83 ec 0c             	sub    $0xc,%esp
8010403d:	68 20 ad 14 80       	push   $0x8014ad20
80104042:	e8 29 07 00 00       	call   80104770 <acquire>
80104047:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010404a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404c:	bb 54 ad 14 80       	mov    $0x8014ad54,%ebx
80104051:	eb 10                	jmp    80104063 <wait+0x43>
80104053:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104058:	83 c3 7c             	add    $0x7c,%ebx
8010405b:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
80104061:	74 1b                	je     8010407e <wait+0x5e>
      if(p->parent != curproc)
80104063:	39 73 14             	cmp    %esi,0x14(%ebx)
80104066:	75 f0                	jne    80104058 <wait+0x38>
      if(p->state == ZOMBIE){
80104068:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010406c:	74 62                	je     801040d0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010406e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104071:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104076:	81 fb 54 cc 14 80    	cmp    $0x8014cc54,%ebx
8010407c:	75 e5                	jne    80104063 <wait+0x43>
    if(!havekids || curproc->killed){
8010407e:	85 c0                	test   %eax,%eax
80104080:	0f 84 a0 00 00 00    	je     80104126 <wait+0x106>
80104086:	8b 46 24             	mov    0x24(%esi),%eax
80104089:	85 c0                	test   %eax,%eax
8010408b:	0f 85 95 00 00 00    	jne    80104126 <wait+0x106>
  pushcli();
80104091:	e8 8a 05 00 00       	call   80104620 <pushcli>
  c = mycpu();
80104096:	e8 b5 f8 ff ff       	call   80103950 <mycpu>
  p = c->proc;
8010409b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a1:	e8 ca 05 00 00       	call   80104670 <popcli>
  if(p == 0)
801040a6:	85 db                	test   %ebx,%ebx
801040a8:	0f 84 8f 00 00 00    	je     8010413d <wait+0x11d>
  p->chan = chan;
801040ae:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801040b1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040b8:	e8 73 fd ff ff       	call   80103e30 <sched>
  p->chan = 0;
801040bd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040c4:	eb 84                	jmp    8010404a <wait+0x2a>
801040c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040cd:	00 
801040ce:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801040d0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040d3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040d6:	ff 73 08             	push   0x8(%ebx)
801040d9:	e8 c2 e3 ff ff       	call   801024a0 <kfree>
        p->kstack = 0;
801040de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040e5:	5a                   	pop    %edx
801040e6:	ff 73 04             	push   0x4(%ebx)
801040e9:	e8 12 2f 00 00       	call   80107000 <freevm>
        p->pid = 0;
801040ee:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040f5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040fc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104100:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104107:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010410e:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80104115:	e8 f6 05 00 00       	call   80104710 <release>
        return pid;
8010411a:	83 c4 10             	add    $0x10,%esp
}
8010411d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104120:	89 f0                	mov    %esi,%eax
80104122:	5b                   	pop    %ebx
80104123:	5e                   	pop    %esi
80104124:	5d                   	pop    %ebp
80104125:	c3                   	ret
      release(&ptable.lock);
80104126:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104129:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010412e:	68 20 ad 14 80       	push   $0x8014ad20
80104133:	e8 d8 05 00 00       	call   80104710 <release>
      return -1;
80104138:	83 c4 10             	add    $0x10,%esp
8010413b:	eb e0                	jmp    8010411d <wait+0xfd>
    panic("sleep");
8010413d:	83 ec 0c             	sub    $0xc,%esp
80104140:	68 ea 78 10 80       	push   $0x801078ea
80104145:	e8 36 c2 ff ff       	call   80100380 <panic>
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <yield>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104157:	68 20 ad 14 80       	push   $0x8014ad20
8010415c:	e8 0f 06 00 00       	call   80104770 <acquire>
  pushcli();
80104161:	e8 ba 04 00 00       	call   80104620 <pushcli>
  c = mycpu();
80104166:	e8 e5 f7 ff ff       	call   80103950 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 fa 04 00 00       	call   80104670 <popcli>
  myproc()->state = RUNNABLE;
80104176:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010417d:	e8 ae fc ff ff       	call   80103e30 <sched>
  release(&ptable.lock);
80104182:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
80104189:	e8 82 05 00 00       	call   80104710 <release>
}
8010418e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104191:	83 c4 10             	add    $0x10,%esp
80104194:	c9                   	leave
80104195:	c3                   	ret
80104196:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010419d:	00 
8010419e:	66 90                	xchg   %ax,%ax

801041a0 <sleep>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041af:	e8 6c 04 00 00       	call   80104620 <pushcli>
  c = mycpu();
801041b4:	e8 97 f7 ff ff       	call   80103950 <mycpu>
  p = c->proc;
801041b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041bf:	e8 ac 04 00 00       	call   80104670 <popcli>
  if(p == 0)
801041c4:	85 db                	test   %ebx,%ebx
801041c6:	0f 84 87 00 00 00    	je     80104253 <sleep+0xb3>
  if(lk == 0)
801041cc:	85 f6                	test   %esi,%esi
801041ce:	74 76                	je     80104246 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041d0:	81 fe 20 ad 14 80    	cmp    $0x8014ad20,%esi
801041d6:	74 50                	je     80104228 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 20 ad 14 80       	push   $0x8014ad20
801041e0:	e8 8b 05 00 00       	call   80104770 <acquire>
    release(lk);
801041e5:	89 34 24             	mov    %esi,(%esp)
801041e8:	e8 23 05 00 00       	call   80104710 <release>
  p->chan = chan;
801041ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041f7:	e8 34 fc ff ff       	call   80103e30 <sched>
  p->chan = 0;
801041fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104203:	c7 04 24 20 ad 14 80 	movl   $0x8014ad20,(%esp)
8010420a:	e8 01 05 00 00       	call   80104710 <release>
    acquire(lk);
8010420f:	83 c4 10             	add    $0x10,%esp
80104212:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104218:	5b                   	pop    %ebx
80104219:	5e                   	pop    %esi
8010421a:	5f                   	pop    %edi
8010421b:	5d                   	pop    %ebp
    acquire(lk);
8010421c:	e9 4f 05 00 00       	jmp    80104770 <acquire>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104228:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010422b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104232:	e8 f9 fb ff ff       	call   80103e30 <sched>
  p->chan = 0;
80104237:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010423e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104241:	5b                   	pop    %ebx
80104242:	5e                   	pop    %esi
80104243:	5f                   	pop    %edi
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret
    panic("sleep without lk");
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	68 f0 78 10 80       	push   $0x801078f0
8010424e:	e8 2d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104253:	83 ec 0c             	sub    $0xc,%esp
80104256:	68 ea 78 10 80       	push   $0x801078ea
8010425b:	e8 20 c1 ff ff       	call   80100380 <panic>

80104260 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	53                   	push   %ebx
80104264:	83 ec 10             	sub    $0x10,%esp
80104267:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010426a:	68 20 ad 14 80       	push   $0x8014ad20
8010426f:	e8 fc 04 00 00       	call   80104770 <acquire>
80104274:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104277:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
8010427c:	eb 0c                	jmp    8010428a <wakeup+0x2a>
8010427e:	66 90                	xchg   %ax,%ax
80104280:	83 c0 7c             	add    $0x7c,%eax
80104283:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
80104288:	74 1c                	je     801042a6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010428a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010428e:	75 f0                	jne    80104280 <wakeup+0x20>
80104290:	3b 58 20             	cmp    0x20(%eax),%ebx
80104293:	75 eb                	jne    80104280 <wakeup+0x20>
      p->state = RUNNABLE;
80104295:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010429c:	83 c0 7c             	add    $0x7c,%eax
8010429f:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
801042a4:	75 e4                	jne    8010428a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801042a6:	c7 45 08 20 ad 14 80 	movl   $0x8014ad20,0x8(%ebp)
}
801042ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042b0:	c9                   	leave
  release(&ptable.lock);
801042b1:	e9 5a 04 00 00       	jmp    80104710 <release>
801042b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801042bd:	00 
801042be:	66 90                	xchg   %ax,%ax

801042c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ca:	68 20 ad 14 80       	push   $0x8014ad20
801042cf:	e8 9c 04 00 00       	call   80104770 <acquire>
801042d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d7:	b8 54 ad 14 80       	mov    $0x8014ad54,%eax
801042dc:	eb 0c                	jmp    801042ea <kill+0x2a>
801042de:	66 90                	xchg   %ax,%ax
801042e0:	83 c0 7c             	add    $0x7c,%eax
801042e3:	3d 54 cc 14 80       	cmp    $0x8014cc54,%eax
801042e8:	74 36                	je     80104320 <kill+0x60>
    if(p->pid == pid){
801042ea:	39 58 10             	cmp    %ebx,0x10(%eax)
801042ed:	75 f1                	jne    801042e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042ef:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042f3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042fa:	75 07                	jne    80104303 <kill+0x43>
        p->state = RUNNABLE;
801042fc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	68 20 ad 14 80       	push   $0x8014ad20
8010430b:	e8 00 04 00 00       	call   80104710 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104313:	83 c4 10             	add    $0x10,%esp
80104316:	31 c0                	xor    %eax,%eax
}
80104318:	c9                   	leave
80104319:	c3                   	ret
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	68 20 ad 14 80       	push   $0x8014ad20
80104328:	e8 e3 03 00 00       	call   80104710 <release>
}
8010432d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104330:	83 c4 10             	add    $0x10,%esp
80104333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104338:	c9                   	leave
80104339:	c3                   	ret
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104348:	53                   	push   %ebx
80104349:	bb c0 ad 14 80       	mov    $0x8014adc0,%ebx
8010434e:	83 ec 3c             	sub    $0x3c,%esp
80104351:	eb 24                	jmp    80104377 <procdump+0x37>
80104353:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	68 af 7a 10 80       	push   $0x80107aaf
80104360:	e8 4b c3 ff ff       	call   801006b0 <cprintf>
80104365:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104368:	83 c3 7c             	add    $0x7c,%ebx
8010436b:	81 fb c0 cc 14 80    	cmp    $0x8014ccc0,%ebx
80104371:	0f 84 81 00 00 00    	je     801043f8 <procdump+0xb8>
    if(p->state == UNUSED)
80104377:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	74 ea                	je     80104368 <procdump+0x28>
      state = "???";
8010437e:	ba 01 79 10 80       	mov    $0x80107901,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104383:	83 f8 05             	cmp    $0x5,%eax
80104386:	77 11                	ja     80104399 <procdump+0x59>
80104388:	8b 14 85 60 7f 10 80 	mov    -0x7fef80a0(,%eax,4),%edx
      state = "???";
8010438f:	b8 01 79 10 80       	mov    $0x80107901,%eax
80104394:	85 d2                	test   %edx,%edx
80104396:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104399:	53                   	push   %ebx
8010439a:	52                   	push   %edx
8010439b:	ff 73 a4             	push   -0x5c(%ebx)
8010439e:	68 05 79 10 80       	push   $0x80107905
801043a3:	e8 08 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801043a8:	83 c4 10             	add    $0x10,%esp
801043ab:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801043af:	75 a7                	jne    80104358 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043b1:	83 ec 08             	sub    $0x8,%esp
801043b4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043b7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043ba:	50                   	push   %eax
801043bb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043be:	8b 40 0c             	mov    0xc(%eax),%eax
801043c1:	83 c0 08             	add    $0x8,%eax
801043c4:	50                   	push   %eax
801043c5:	e8 d6 01 00 00       	call   801045a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043ca:	83 c4 10             	add    $0x10,%esp
801043cd:	8d 76 00             	lea    0x0(%esi),%esi
801043d0:	8b 17                	mov    (%edi),%edx
801043d2:	85 d2                	test   %edx,%edx
801043d4:	74 82                	je     80104358 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043dc:	52                   	push   %edx
801043dd:	68 41 76 10 80       	push   $0x80107641
801043e2:	e8 c9 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043e7:	83 c4 10             	add    $0x10,%esp
801043ea:	39 f7                	cmp    %esi,%edi
801043ec:	75 e2                	jne    801043d0 <procdump+0x90>
801043ee:	e9 65 ff ff ff       	jmp    80104358 <procdump+0x18>
801043f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801043f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043fb:	5b                   	pop    %ebx
801043fc:	5e                   	pop    %esi
801043fd:	5f                   	pop    %edi
801043fe:	5d                   	pop    %ebp
801043ff:	c3                   	ret

80104400 <numpages>:

int numpages(void) {
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104407:	e8 14 02 00 00       	call   80104620 <pushcli>
  c = mycpu();
8010440c:	e8 3f f5 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80104411:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104417:	e8 54 02 00 00       	call   80104670 <popcli>
  struct proc *p = myproc();
  int count = 0;
8010441c:	31 c9                	xor    %ecx,%ecx
8010441e:	8b 43 04             	mov    0x4(%ebx),%eax
80104421:	8d 98 00 10 00 00    	lea    0x1000(%eax),%ebx
80104427:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010442e:	00 
8010442f:	90                   	nop
  for (int i = 0; i < NPDENTRIES; i++) {
    if (p->pgdir[i] & PTE_P) {
80104430:	8b 10                	mov    (%eax),%edx
80104432:	83 e2 01             	and    $0x1,%edx
      count++;
80104435:	83 fa 01             	cmp    $0x1,%edx
80104438:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (int i = 0; i < NPDENTRIES; i++) {
8010443b:	83 c0 04             	add    $0x4,%eax
8010443e:	39 c3                	cmp    %eax,%ebx
80104440:	75 ee                	jne    80104430 <numpages+0x30>
    }
  }
  return count;
}
80104442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104445:	89 c8                	mov    %ecx,%eax
80104447:	c9                   	leave
80104448:	c3                   	ret
80104449:	66 90                	xchg   %ax,%ax
8010444b:	66 90                	xchg   %ax,%ax
8010444d:	66 90                	xchg   %ax,%ax
8010444f:	90                   	nop

80104450 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 0c             	sub    $0xc,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010445a:	68 38 79 10 80       	push   $0x80107938
8010445f:	8d 43 04             	lea    0x4(%ebx),%eax
80104462:	50                   	push   %eax
80104463:	e8 18 01 00 00       	call   80104580 <initlock>
  lk->name = name;
80104468:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010446b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104471:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104474:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010447b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010447e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104481:	c9                   	leave
80104482:	c3                   	ret
80104483:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010448a:	00 
8010448b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104490 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104498:	8d 73 04             	lea    0x4(%ebx),%esi
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	56                   	push   %esi
8010449f:	e8 cc 02 00 00       	call   80104770 <acquire>
  while (lk->locked) {
801044a4:	8b 13                	mov    (%ebx),%edx
801044a6:	83 c4 10             	add    $0x10,%esp
801044a9:	85 d2                	test   %edx,%edx
801044ab:	74 16                	je     801044c3 <acquiresleep+0x33>
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044b0:	83 ec 08             	sub    $0x8,%esp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	e8 e6 fc ff ff       	call   801041a0 <sleep>
  while (lk->locked) {
801044ba:	8b 03                	mov    (%ebx),%eax
801044bc:	83 c4 10             	add    $0x10,%esp
801044bf:	85 c0                	test   %eax,%eax
801044c1:	75 ed                	jne    801044b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044c9:	e8 02 f5 ff ff       	call   801039d0 <myproc>
801044ce:	8b 40 10             	mov    0x10(%eax),%eax
801044d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044da:	5b                   	pop    %ebx
801044db:	5e                   	pop    %esi
801044dc:	5d                   	pop    %ebp
  release(&lk->lk);
801044dd:	e9 2e 02 00 00       	jmp    80104710 <release>
801044e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044e9:	00 
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044f8:	8d 73 04             	lea    0x4(%ebx),%esi
801044fb:	83 ec 0c             	sub    $0xc,%esp
801044fe:	56                   	push   %esi
801044ff:	e8 6c 02 00 00       	call   80104770 <acquire>
  lk->locked = 0;
80104504:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010450a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104511:	89 1c 24             	mov    %ebx,(%esp)
80104514:	e8 47 fd ff ff       	call   80104260 <wakeup>
  release(&lk->lk);
80104519:	83 c4 10             	add    $0x10,%esp
8010451c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010451f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104522:	5b                   	pop    %ebx
80104523:	5e                   	pop    %esi
80104524:	5d                   	pop    %ebp
  release(&lk->lk);
80104525:	e9 e6 01 00 00       	jmp    80104710 <release>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	31 ff                	xor    %edi,%edi
80104536:	56                   	push   %esi
80104537:	53                   	push   %ebx
80104538:	83 ec 18             	sub    $0x18,%esp
8010453b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010453e:	8d 73 04             	lea    0x4(%ebx),%esi
80104541:	56                   	push   %esi
80104542:	e8 29 02 00 00       	call   80104770 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104547:	8b 03                	mov    (%ebx),%eax
80104549:	83 c4 10             	add    $0x10,%esp
8010454c:	85 c0                	test   %eax,%eax
8010454e:	75 18                	jne    80104568 <holdingsleep+0x38>
  release(&lk->lk);
80104550:	83 ec 0c             	sub    $0xc,%esp
80104553:	56                   	push   %esi
80104554:	e8 b7 01 00 00       	call   80104710 <release>
  return r;
}
80104559:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010455c:	89 f8                	mov    %edi,%eax
8010455e:	5b                   	pop    %ebx
8010455f:	5e                   	pop    %esi
80104560:	5f                   	pop    %edi
80104561:	5d                   	pop    %ebp
80104562:	c3                   	ret
80104563:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104568:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010456b:	e8 60 f4 ff ff       	call   801039d0 <myproc>
80104570:	39 58 10             	cmp    %ebx,0x10(%eax)
80104573:	0f 94 c0             	sete   %al
80104576:	0f b6 c0             	movzbl %al,%eax
80104579:	89 c7                	mov    %eax,%edi
8010457b:	eb d3                	jmp    80104550 <holdingsleep+0x20>
8010457d:	66 90                	xchg   %ax,%ax
8010457f:	90                   	nop

80104580 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104586:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104589:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010458f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104592:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret
8010459b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801045a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	8b 45 08             	mov    0x8(%ebp),%eax
801045a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801045aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045ad:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801045b2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801045b7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045bc:	76 10                	jbe    801045ce <getcallerpcs+0x2e>
801045be:	eb 28                	jmp    801045e8 <getcallerpcs+0x48>
801045c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801045c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045cc:	77 1a                	ja     801045e8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801045d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801045d4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801045d7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801045d9:	83 f8 0a             	cmp    $0xa,%eax
801045dc:	75 e2                	jne    801045c0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e1:	c9                   	leave
801045e2:	c3                   	ret
801045e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801045e8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801045eb:	83 c1 28             	add    $0x28,%ecx
801045ee:	89 ca                	mov    %ecx,%edx
801045f0:	29 c2                	sub    %eax,%edx
801045f2:	83 e2 04             	and    $0x4,%edx
801045f5:	74 11                	je     80104608 <getcallerpcs+0x68>
    pcs[i] = 0;
801045f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045fd:	83 c0 04             	add    $0x4,%eax
80104600:	39 c1                	cmp    %eax,%ecx
80104602:	74 da                	je     801045de <getcallerpcs+0x3e>
80104604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104608:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010460e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104611:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104618:	39 c1                	cmp    %eax,%ecx
8010461a:	75 ec                	jne    80104608 <getcallerpcs+0x68>
8010461c:	eb c0                	jmp    801045de <getcallerpcs+0x3e>
8010461e:	66 90                	xchg   %ax,%ax

80104620 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp
80104627:	9c                   	pushf
80104628:	5b                   	pop    %ebx
  asm volatile("cli");
80104629:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010462a:	e8 21 f3 ff ff       	call   80103950 <mycpu>
8010462f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104635:	85 c0                	test   %eax,%eax
80104637:	74 17                	je     80104650 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104639:	e8 12 f3 ff ff       	call   80103950 <mycpu>
8010463e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104648:	c9                   	leave
80104649:	c3                   	ret
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104650:	e8 fb f2 ff ff       	call   80103950 <mycpu>
80104655:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010465b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104661:	eb d6                	jmp    80104639 <pushcli+0x19>
80104663:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010466a:	00 
8010466b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104670 <popcli>:

void
popcli(void)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104676:	9c                   	pushf
80104677:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104678:	f6 c4 02             	test   $0x2,%ah
8010467b:	75 35                	jne    801046b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010467d:	e8 ce f2 ff ff       	call   80103950 <mycpu>
80104682:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104689:	78 34                	js     801046bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010468b:	e8 c0 f2 ff ff       	call   80103950 <mycpu>
80104690:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104696:	85 d2                	test   %edx,%edx
80104698:	74 06                	je     801046a0 <popcli+0x30>
    sti();
}
8010469a:	c9                   	leave
8010469b:	c3                   	ret
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046a0:	e8 ab f2 ff ff       	call   80103950 <mycpu>
801046a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046ab:	85 c0                	test   %eax,%eax
801046ad:	74 eb                	je     8010469a <popcli+0x2a>
  asm volatile("sti");
801046af:	fb                   	sti
}
801046b0:	c9                   	leave
801046b1:	c3                   	ret
    panic("popcli - interruptible");
801046b2:	83 ec 0c             	sub    $0xc,%esp
801046b5:	68 43 79 10 80       	push   $0x80107943
801046ba:	e8 c1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046bf:	83 ec 0c             	sub    $0xc,%esp
801046c2:	68 5a 79 10 80       	push   $0x8010795a
801046c7:	e8 b4 bc ff ff       	call   80100380 <panic>
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <holding>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	8b 75 08             	mov    0x8(%ebp),%esi
801046d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046da:	e8 41 ff ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046df:	8b 06                	mov    (%esi),%eax
801046e1:	85 c0                	test   %eax,%eax
801046e3:	75 0b                	jne    801046f0 <holding+0x20>
  popcli();
801046e5:	e8 86 ff ff ff       	call   80104670 <popcli>
}
801046ea:	89 d8                	mov    %ebx,%eax
801046ec:	5b                   	pop    %ebx
801046ed:	5e                   	pop    %esi
801046ee:	5d                   	pop    %ebp
801046ef:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801046f0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046f3:	e8 58 f2 ff ff       	call   80103950 <mycpu>
801046f8:	39 c3                	cmp    %eax,%ebx
801046fa:	0f 94 c3             	sete   %bl
  popcli();
801046fd:	e8 6e ff ff ff       	call   80104670 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104702:	0f b6 db             	movzbl %bl,%ebx
}
80104705:	89 d8                	mov    %ebx,%eax
80104707:	5b                   	pop    %ebx
80104708:	5e                   	pop    %esi
80104709:	5d                   	pop    %ebp
8010470a:	c3                   	ret
8010470b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104710 <release>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104718:	e8 03 ff ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010471d:	8b 03                	mov    (%ebx),%eax
8010471f:	85 c0                	test   %eax,%eax
80104721:	75 15                	jne    80104738 <release+0x28>
  popcli();
80104723:	e8 48 ff ff ff       	call   80104670 <popcli>
    panic("release");
80104728:	83 ec 0c             	sub    $0xc,%esp
8010472b:	68 61 79 10 80       	push   $0x80107961
80104730:	e8 4b bc ff ff       	call   80100380 <panic>
80104735:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104738:	8b 73 08             	mov    0x8(%ebx),%esi
8010473b:	e8 10 f2 ff ff       	call   80103950 <mycpu>
80104740:	39 c6                	cmp    %eax,%esi
80104742:	75 df                	jne    80104723 <release+0x13>
  popcli();
80104744:	e8 27 ff ff ff       	call   80104670 <popcli>
  lk->pcs[0] = 0;
80104749:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104750:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104757:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010475c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104762:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104765:	5b                   	pop    %ebx
80104766:	5e                   	pop    %esi
80104767:	5d                   	pop    %ebp
  popcli();
80104768:	e9 03 ff ff ff       	jmp    80104670 <popcli>
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <acquire>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104777:	e8 a4 fe ff ff       	call   80104620 <pushcli>
  if(holding(lk))
8010477c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010477f:	e8 9c fe ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104784:	8b 03                	mov    (%ebx),%eax
80104786:	85 c0                	test   %eax,%eax
80104788:	0f 85 b2 00 00 00    	jne    80104840 <acquire+0xd0>
  popcli();
8010478e:	e8 dd fe ff ff       	call   80104670 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104793:	b9 01 00 00 00       	mov    $0x1,%ecx
80104798:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010479f:	00 
  while(xchg(&lk->locked, 1) != 0)
801047a0:	8b 55 08             	mov    0x8(%ebp),%edx
801047a3:	89 c8                	mov    %ecx,%eax
801047a5:	f0 87 02             	lock xchg %eax,(%edx)
801047a8:	85 c0                	test   %eax,%eax
801047aa:	75 f4                	jne    801047a0 <acquire+0x30>
  __sync_synchronize();
801047ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047b4:	e8 97 f1 ff ff       	call   80103950 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801047bc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801047be:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047c1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801047c7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801047cc:	77 32                	ja     80104800 <acquire+0x90>
  ebp = (uint*)v - 2;
801047ce:	89 e8                	mov    %ebp,%eax
801047d0:	eb 14                	jmp    801047e6 <acquire+0x76>
801047d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047d8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047de:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047e4:	77 1a                	ja     80104800 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801047e6:	8b 58 04             	mov    0x4(%eax),%ebx
801047e9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047ed:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047f0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047f2:	83 fa 0a             	cmp    $0xa,%edx
801047f5:	75 e1                	jne    801047d8 <acquire+0x68>
}
801047f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047fa:	c9                   	leave
801047fb:	c3                   	ret
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104800:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104804:	83 c1 34             	add    $0x34,%ecx
80104807:	89 ca                	mov    %ecx,%edx
80104809:	29 c2                	sub    %eax,%edx
8010480b:	83 e2 04             	and    $0x4,%edx
8010480e:	74 10                	je     80104820 <acquire+0xb0>
    pcs[i] = 0;
80104810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104816:	83 c0 04             	add    $0x4,%eax
80104819:	39 c1                	cmp    %eax,%ecx
8010481b:	74 da                	je     801047f7 <acquire+0x87>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104826:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104829:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104830:	39 c1                	cmp    %eax,%ecx
80104832:	75 ec                	jne    80104820 <acquire+0xb0>
80104834:	eb c1                	jmp    801047f7 <acquire+0x87>
80104836:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010483d:	00 
8010483e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104840:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104843:	e8 08 f1 ff ff       	call   80103950 <mycpu>
80104848:	39 c3                	cmp    %eax,%ebx
8010484a:	0f 85 3e ff ff ff    	jne    8010478e <acquire+0x1e>
  popcli();
80104850:	e8 1b fe ff ff       	call   80104670 <popcli>
    panic("acquire");
80104855:	83 ec 0c             	sub    $0xc,%esp
80104858:	68 69 79 10 80       	push   $0x80107969
8010485d:	e8 1e bb ff ff       	call   80100380 <panic>
80104862:	66 90                	xchg   %ax,%ax
80104864:	66 90                	xchg   %ax,%ax
80104866:	66 90                	xchg   %ax,%ax
80104868:	66 90                	xchg   %ax,%ax
8010486a:	66 90                	xchg   %ax,%ax
8010486c:	66 90                	xchg   %ax,%ax
8010486e:	66 90                	xchg   %ax,%ax

80104870 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	57                   	push   %edi
80104874:	8b 55 08             	mov    0x8(%ebp),%edx
80104877:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010487a:	89 d0                	mov    %edx,%eax
8010487c:	09 c8                	or     %ecx,%eax
8010487e:	a8 03                	test   $0x3,%al
80104880:	75 1e                	jne    801048a0 <memset+0x30>
    c &= 0xFF;
80104882:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104886:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104889:	89 d7                	mov    %edx,%edi
8010488b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104891:	fc                   	cld
80104892:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104894:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104897:	89 d0                	mov    %edx,%eax
80104899:	c9                   	leave
8010489a:	c3                   	ret
8010489b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801048a3:	89 d7                	mov    %edx,%edi
801048a5:	fc                   	cld
801048a6:	f3 aa                	rep stos %al,%es:(%edi)
801048a8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048ab:	89 d0                	mov    %edx,%eax
801048ad:	c9                   	leave
801048ae:	c3                   	ret
801048af:	90                   	nop

801048b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	8b 75 10             	mov    0x10(%ebp),%esi
801048b7:	8b 45 08             	mov    0x8(%ebp),%eax
801048ba:	53                   	push   %ebx
801048bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048be:	85 f6                	test   %esi,%esi
801048c0:	74 2e                	je     801048f0 <memcmp+0x40>
801048c2:	01 c6                	add    %eax,%esi
801048c4:	eb 14                	jmp    801048da <memcmp+0x2a>
801048c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048cd:	00 
801048ce:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048d0:	83 c0 01             	add    $0x1,%eax
801048d3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048d6:	39 f0                	cmp    %esi,%eax
801048d8:	74 16                	je     801048f0 <memcmp+0x40>
    if(*s1 != *s2)
801048da:	0f b6 08             	movzbl (%eax),%ecx
801048dd:	0f b6 1a             	movzbl (%edx),%ebx
801048e0:	38 d9                	cmp    %bl,%cl
801048e2:	74 ec                	je     801048d0 <memcmp+0x20>
      return *s1 - *s2;
801048e4:	0f b6 c1             	movzbl %cl,%eax
801048e7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048e9:	5b                   	pop    %ebx
801048ea:	5e                   	pop    %esi
801048eb:	5d                   	pop    %ebp
801048ec:	c3                   	ret
801048ed:	8d 76 00             	lea    0x0(%esi),%esi
801048f0:	5b                   	pop    %ebx
  return 0;
801048f1:	31 c0                	xor    %eax,%eax
}
801048f3:	5e                   	pop    %esi
801048f4:	5d                   	pop    %ebp
801048f5:	c3                   	ret
801048f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048fd:	00 
801048fe:	66 90                	xchg   %ax,%ax

80104900 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	8b 55 08             	mov    0x8(%ebp),%edx
80104907:	8b 45 10             	mov    0x10(%ebp),%eax
8010490a:	56                   	push   %esi
8010490b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010490e:	39 d6                	cmp    %edx,%esi
80104910:	73 26                	jae    80104938 <memmove+0x38>
80104912:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104915:	39 ca                	cmp    %ecx,%edx
80104917:	73 1f                	jae    80104938 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104919:	85 c0                	test   %eax,%eax
8010491b:	74 0f                	je     8010492c <memmove+0x2c>
8010491d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104920:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104924:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104927:	83 e8 01             	sub    $0x1,%eax
8010492a:	73 f4                	jae    80104920 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010492c:	5e                   	pop    %esi
8010492d:	89 d0                	mov    %edx,%eax
8010492f:	5f                   	pop    %edi
80104930:	5d                   	pop    %ebp
80104931:	c3                   	ret
80104932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104938:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010493b:	89 d7                	mov    %edx,%edi
8010493d:	85 c0                	test   %eax,%eax
8010493f:	74 eb                	je     8010492c <memmove+0x2c>
80104941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104948:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104949:	39 ce                	cmp    %ecx,%esi
8010494b:	75 fb                	jne    80104948 <memmove+0x48>
}
8010494d:	5e                   	pop    %esi
8010494e:	89 d0                	mov    %edx,%eax
80104950:	5f                   	pop    %edi
80104951:	5d                   	pop    %ebp
80104952:	c3                   	ret
80104953:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010495a:	00 
8010495b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104960 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104960:	eb 9e                	jmp    80104900 <memmove>
80104962:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104969:	00 
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	8b 55 10             	mov    0x10(%ebp),%edx
80104977:	8b 45 08             	mov    0x8(%ebp),%eax
8010497a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010497d:	85 d2                	test   %edx,%edx
8010497f:	75 16                	jne    80104997 <strncmp+0x27>
80104981:	eb 2d                	jmp    801049b0 <strncmp+0x40>
80104983:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104988:	3a 19                	cmp    (%ecx),%bl
8010498a:	75 12                	jne    8010499e <strncmp+0x2e>
    n--, p++, q++;
8010498c:	83 c0 01             	add    $0x1,%eax
8010498f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104992:	83 ea 01             	sub    $0x1,%edx
80104995:	74 19                	je     801049b0 <strncmp+0x40>
80104997:	0f b6 18             	movzbl (%eax),%ebx
8010499a:	84 db                	test   %bl,%bl
8010499c:	75 ea                	jne    80104988 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010499e:	0f b6 00             	movzbl (%eax),%eax
801049a1:	0f b6 11             	movzbl (%ecx),%edx
}
801049a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801049a8:	29 d0                	sub    %edx,%eax
}
801049aa:	c3                   	ret
801049ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801049b3:	31 c0                	xor    %eax,%eax
}
801049b5:	c9                   	leave
801049b6:	c3                   	ret
801049b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049be:	00 
801049bf:	90                   	nop

801049c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	8b 75 08             	mov    0x8(%ebp),%esi
801049c8:	53                   	push   %ebx
801049c9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049cc:	89 f0                	mov    %esi,%eax
801049ce:	eb 15                	jmp    801049e5 <strncpy+0x25>
801049d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049d4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049d7:	83 c0 01             	add    $0x1,%eax
801049da:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801049de:	88 48 ff             	mov    %cl,-0x1(%eax)
801049e1:	84 c9                	test   %cl,%cl
801049e3:	74 13                	je     801049f8 <strncpy+0x38>
801049e5:	89 d3                	mov    %edx,%ebx
801049e7:	83 ea 01             	sub    $0x1,%edx
801049ea:	85 db                	test   %ebx,%ebx
801049ec:	7f e2                	jg     801049d0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801049ee:	5b                   	pop    %ebx
801049ef:	89 f0                	mov    %esi,%eax
801049f1:	5e                   	pop    %esi
801049f2:	5f                   	pop    %edi
801049f3:	5d                   	pop    %ebp
801049f4:	c3                   	ret
801049f5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
801049f8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
801049fb:	83 e9 01             	sub    $0x1,%ecx
801049fe:	85 d2                	test   %edx,%edx
80104a00:	74 ec                	je     801049ee <strncpy+0x2e>
80104a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104a08:	83 c0 01             	add    $0x1,%eax
80104a0b:	89 ca                	mov    %ecx,%edx
80104a0d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104a11:	29 c2                	sub    %eax,%edx
80104a13:	85 d2                	test   %edx,%edx
80104a15:	7f f1                	jg     80104a08 <strncpy+0x48>
}
80104a17:	5b                   	pop    %ebx
80104a18:	89 f0                	mov    %esi,%eax
80104a1a:	5e                   	pop    %esi
80104a1b:	5f                   	pop    %edi
80104a1c:	5d                   	pop    %ebp
80104a1d:	c3                   	ret
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	8b 55 10             	mov    0x10(%ebp),%edx
80104a27:	8b 75 08             	mov    0x8(%ebp),%esi
80104a2a:	53                   	push   %ebx
80104a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a2e:	85 d2                	test   %edx,%edx
80104a30:	7e 25                	jle    80104a57 <safestrcpy+0x37>
80104a32:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a36:	89 f2                	mov    %esi,%edx
80104a38:	eb 16                	jmp    80104a50 <safestrcpy+0x30>
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a40:	0f b6 08             	movzbl (%eax),%ecx
80104a43:	83 c0 01             	add    $0x1,%eax
80104a46:	83 c2 01             	add    $0x1,%edx
80104a49:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a4c:	84 c9                	test   %cl,%cl
80104a4e:	74 04                	je     80104a54 <safestrcpy+0x34>
80104a50:	39 d8                	cmp    %ebx,%eax
80104a52:	75 ec                	jne    80104a40 <safestrcpy+0x20>
    ;
  *s = 0;
80104a54:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a57:	89 f0                	mov    %esi,%eax
80104a59:	5b                   	pop    %ebx
80104a5a:	5e                   	pop    %esi
80104a5b:	5d                   	pop    %ebp
80104a5c:	c3                   	ret
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi

80104a60 <strlen>:

int
strlen(const char *s)
{
80104a60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a61:	31 c0                	xor    %eax,%eax
{
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a68:	80 3a 00             	cmpb   $0x0,(%edx)
80104a6b:	74 0c                	je     80104a79 <strlen+0x19>
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
80104a70:	83 c0 01             	add    $0x1,%eax
80104a73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a77:	75 f7                	jne    80104a70 <strlen+0x10>
    ;
  return n;
}
80104a79:	5d                   	pop    %ebp
80104a7a:	c3                   	ret

80104a7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a83:	55                   	push   %ebp
  pushl %ebx
80104a84:	53                   	push   %ebx
  pushl %esi
80104a85:	56                   	push   %esi
  pushl %edi
80104a86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a89:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a8b:	5f                   	pop    %edi
  popl %esi
80104a8c:	5e                   	pop    %esi
  popl %ebx
80104a8d:	5b                   	pop    %ebx
  popl %ebp
80104a8e:	5d                   	pop    %ebp
  ret
80104a8f:	c3                   	ret

80104a90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 04             	sub    $0x4,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a9a:	e8 31 ef ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a9f:	8b 00                	mov    (%eax),%eax
80104aa1:	39 c3                	cmp    %eax,%ebx
80104aa3:	73 1b                	jae    80104ac0 <fetchint+0x30>
80104aa5:	8d 53 04             	lea    0x4(%ebx),%edx
80104aa8:	39 d0                	cmp    %edx,%eax
80104aaa:	72 14                	jb     80104ac0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104aac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aaf:	8b 13                	mov    (%ebx),%edx
80104ab1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ab3:	31 c0                	xor    %eax,%eax
}
80104ab5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab8:	c9                   	leave
80104ab9:	c3                   	ret
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac5:	eb ee                	jmp    80104ab5 <fetchint+0x25>
80104ac7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ace:	00 
80104acf:	90                   	nop

80104ad0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	53                   	push   %ebx
80104ad4:	83 ec 04             	sub    $0x4,%esp
80104ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104ada:	e8 f1 ee ff ff       	call   801039d0 <myproc>

  if(addr >= curproc->sz)
80104adf:	3b 18                	cmp    (%eax),%ebx
80104ae1:	73 2d                	jae    80104b10 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ae6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ae8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104aea:	39 d3                	cmp    %edx,%ebx
80104aec:	73 22                	jae    80104b10 <fetchstr+0x40>
80104aee:	89 d8                	mov    %ebx,%eax
80104af0:	eb 0d                	jmp    80104aff <fetchstr+0x2f>
80104af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104af8:	83 c0 01             	add    $0x1,%eax
80104afb:	39 d0                	cmp    %edx,%eax
80104afd:	73 11                	jae    80104b10 <fetchstr+0x40>
    if(*s == 0)
80104aff:	80 38 00             	cmpb   $0x0,(%eax)
80104b02:	75 f4                	jne    80104af8 <fetchstr+0x28>
      return s - *pp;
80104b04:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b09:	c9                   	leave
80104b0a:	c3                   	ret
80104b0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b18:	c9                   	leave
80104b19:	c3                   	ret
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b25:	e8 a6 ee ff ff       	call   801039d0 <myproc>
80104b2a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b2d:	8b 40 18             	mov    0x18(%eax),%eax
80104b30:	8b 40 44             	mov    0x44(%eax),%eax
80104b33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b36:	e8 95 ee ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b3b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b3e:	8b 00                	mov    (%eax),%eax
80104b40:	39 c6                	cmp    %eax,%esi
80104b42:	73 1c                	jae    80104b60 <argint+0x40>
80104b44:	8d 53 08             	lea    0x8(%ebx),%edx
80104b47:	39 d0                	cmp    %edx,%eax
80104b49:	72 15                	jb     80104b60 <argint+0x40>
  *ip = *(int*)(addr);
80104b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b51:	89 10                	mov    %edx,(%eax)
  return 0;
80104b53:	31 c0                	xor    %eax,%eax
}
80104b55:	5b                   	pop    %ebx
80104b56:	5e                   	pop    %esi
80104b57:	5d                   	pop    %ebp
80104b58:	c3                   	ret
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b65:	eb ee                	jmp    80104b55 <argint+0x35>
80104b67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b6e:	00 
80104b6f:	90                   	nop

80104b70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	56                   	push   %esi
80104b75:	53                   	push   %ebx
80104b76:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b79:	e8 52 ee ff ff       	call   801039d0 <myproc>
80104b7e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b80:	e8 4b ee ff ff       	call   801039d0 <myproc>
80104b85:	8b 55 08             	mov    0x8(%ebp),%edx
80104b88:	8b 40 18             	mov    0x18(%eax),%eax
80104b8b:	8b 40 44             	mov    0x44(%eax),%eax
80104b8e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b91:	e8 3a ee ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b96:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b99:	8b 00                	mov    (%eax),%eax
80104b9b:	39 c7                	cmp    %eax,%edi
80104b9d:	73 31                	jae    80104bd0 <argptr+0x60>
80104b9f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ba2:	39 c8                	cmp    %ecx,%eax
80104ba4:	72 2a                	jb     80104bd0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ba6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ba9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bac:	85 d2                	test   %edx,%edx
80104bae:	78 20                	js     80104bd0 <argptr+0x60>
80104bb0:	8b 16                	mov    (%esi),%edx
80104bb2:	39 d0                	cmp    %edx,%eax
80104bb4:	73 1a                	jae    80104bd0 <argptr+0x60>
80104bb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bb9:	01 c3                	add    %eax,%ebx
80104bbb:	39 da                	cmp    %ebx,%edx
80104bbd:	72 11                	jb     80104bd0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bc2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bc4:	31 c0                	xor    %eax,%eax
}
80104bc6:	83 c4 0c             	add    $0xc,%esp
80104bc9:	5b                   	pop    %ebx
80104bca:	5e                   	pop    %esi
80104bcb:	5f                   	pop    %edi
80104bcc:	5d                   	pop    %ebp
80104bcd:	c3                   	ret
80104bce:	66 90                	xchg   %ax,%ax
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bd5:	eb ef                	jmp    80104bc6 <argptr+0x56>
80104bd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bde:	00 
80104bdf:	90                   	nop

80104be0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104be5:	e8 e6 ed ff ff       	call   801039d0 <myproc>
80104bea:	8b 55 08             	mov    0x8(%ebp),%edx
80104bed:	8b 40 18             	mov    0x18(%eax),%eax
80104bf0:	8b 40 44             	mov    0x44(%eax),%eax
80104bf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104bf6:	e8 d5 ed ff ff       	call   801039d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bfb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bfe:	8b 00                	mov    (%eax),%eax
80104c00:	39 c6                	cmp    %eax,%esi
80104c02:	73 44                	jae    80104c48 <argstr+0x68>
80104c04:	8d 53 08             	lea    0x8(%ebx),%edx
80104c07:	39 d0                	cmp    %edx,%eax
80104c09:	72 3d                	jb     80104c48 <argstr+0x68>
  *ip = *(int*)(addr);
80104c0b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c0e:	e8 bd ed ff ff       	call   801039d0 <myproc>
  if(addr >= curproc->sz)
80104c13:	3b 18                	cmp    (%eax),%ebx
80104c15:	73 31                	jae    80104c48 <argstr+0x68>
  *pp = (char*)addr;
80104c17:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c1e:	39 d3                	cmp    %edx,%ebx
80104c20:	73 26                	jae    80104c48 <argstr+0x68>
80104c22:	89 d8                	mov    %ebx,%eax
80104c24:	eb 11                	jmp    80104c37 <argstr+0x57>
80104c26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c2d:	00 
80104c2e:	66 90                	xchg   %ax,%ax
80104c30:	83 c0 01             	add    $0x1,%eax
80104c33:	39 d0                	cmp    %edx,%eax
80104c35:	73 11                	jae    80104c48 <argstr+0x68>
    if(*s == 0)
80104c37:	80 38 00             	cmpb   $0x0,(%eax)
80104c3a:	75 f4                	jne    80104c30 <argstr+0x50>
      return s - *pp;
80104c3c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c3e:	5b                   	pop    %ebx
80104c3f:	5e                   	pop    %esi
80104c40:	5d                   	pop    %ebp
80104c41:	c3                   	ret
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c48:	5b                   	pop    %ebx
    return -1;
80104c49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c4e:	5e                   	pop    %esi
80104c4f:	5d                   	pop    %ebp
80104c50:	c3                   	ret
80104c51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c58:	00 
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c60 <syscall>:
[SYS_numpages]  sys_numpages,
};

void
syscall(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	53                   	push   %ebx
80104c64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c67:	e8 64 ed ff ff       	call   801039d0 <myproc>
80104c6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c6e:	8b 40 18             	mov    0x18(%eax),%eax
80104c71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c77:	83 fa 18             	cmp    $0x18,%edx
80104c7a:	77 24                	ja     80104ca0 <syscall+0x40>
80104c7c:	8b 14 85 80 7f 10 80 	mov    -0x7fef8080(,%eax,4),%edx
80104c83:	85 d2                	test   %edx,%edx
80104c85:	74 19                	je     80104ca0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c87:	ff d2                	call   *%edx
80104c89:	89 c2                	mov    %eax,%edx
80104c8b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c8e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c94:	c9                   	leave
80104c95:	c3                   	ret
80104c96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c9d:	00 
80104c9e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104ca0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ca1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ca4:	50                   	push   %eax
80104ca5:	ff 73 10             	push   0x10(%ebx)
80104ca8:	68 71 79 10 80       	push   $0x80107971
80104cad:	e8 fe b9 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104cb2:	8b 43 18             	mov    0x18(%ebx),%eax
80104cb5:	83 c4 10             	add    $0x10,%esp
80104cb8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc2:	c9                   	leave
80104cc3:	c3                   	ret
80104cc4:	66 90                	xchg   %ax,%ax
80104cc6:	66 90                	xchg   %ax,%ax
80104cc8:	66 90                	xchg   %ax,%ax
80104cca:	66 90                	xchg   %ax,%ax
80104ccc:	66 90                	xchg   %ax,%ax
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cd5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104cd8:	53                   	push   %ebx
80104cd9:	83 ec 34             	sub    $0x34,%esp
80104cdc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ce2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ce5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104ce8:	57                   	push   %edi
80104ce9:	50                   	push   %eax
80104cea:	e8 b1 d3 ff ff       	call   801020a0 <nameiparent>
80104cef:	83 c4 10             	add    $0x10,%esp
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	74 5e                	je     80104d54 <create+0x84>
    return 0;
  ilock(dp);
80104cf6:	83 ec 0c             	sub    $0xc,%esp
80104cf9:	89 c3                	mov    %eax,%ebx
80104cfb:	50                   	push   %eax
80104cfc:	e8 9f ca ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d01:	83 c4 0c             	add    $0xc,%esp
80104d04:	6a 00                	push   $0x0
80104d06:	57                   	push   %edi
80104d07:	53                   	push   %ebx
80104d08:	e8 e3 cf ff ff       	call   80101cf0 <dirlookup>
80104d0d:	83 c4 10             	add    $0x10,%esp
80104d10:	89 c6                	mov    %eax,%esi
80104d12:	85 c0                	test   %eax,%eax
80104d14:	74 4a                	je     80104d60 <create+0x90>
    iunlockput(dp);
80104d16:	83 ec 0c             	sub    $0xc,%esp
80104d19:	53                   	push   %ebx
80104d1a:	e8 11 cd ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104d1f:	89 34 24             	mov    %esi,(%esp)
80104d22:	e8 79 ca ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d27:	83 c4 10             	add    $0x10,%esp
80104d2a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d2f:	75 17                	jne    80104d48 <create+0x78>
80104d31:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d36:	75 10                	jne    80104d48 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d3b:	89 f0                	mov    %esi,%eax
80104d3d:	5b                   	pop    %ebx
80104d3e:	5e                   	pop    %esi
80104d3f:	5f                   	pop    %edi
80104d40:	5d                   	pop    %ebp
80104d41:	c3                   	ret
80104d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d48:	83 ec 0c             	sub    $0xc,%esp
80104d4b:	56                   	push   %esi
80104d4c:	e8 df cc ff ff       	call   80101a30 <iunlockput>
    return 0;
80104d51:	83 c4 10             	add    $0x10,%esp
}
80104d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d57:	31 f6                	xor    %esi,%esi
}
80104d59:	5b                   	pop    %ebx
80104d5a:	89 f0                	mov    %esi,%eax
80104d5c:	5e                   	pop    %esi
80104d5d:	5f                   	pop    %edi
80104d5e:	5d                   	pop    %ebp
80104d5f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104d60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d64:	83 ec 08             	sub    $0x8,%esp
80104d67:	50                   	push   %eax
80104d68:	ff 33                	push   (%ebx)
80104d6a:	e8 c1 c8 ff ff       	call   80101630 <ialloc>
80104d6f:	83 c4 10             	add    $0x10,%esp
80104d72:	89 c6                	mov    %eax,%esi
80104d74:	85 c0                	test   %eax,%eax
80104d76:	0f 84 bc 00 00 00    	je     80104e38 <create+0x168>
  ilock(ip);
80104d7c:	83 ec 0c             	sub    $0xc,%esp
80104d7f:	50                   	push   %eax
80104d80:	e8 1b ca ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104d85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d95:	b8 01 00 00 00       	mov    $0x1,%eax
80104d9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d9e:	89 34 24             	mov    %esi,(%esp)
80104da1:	e8 4a c9 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104da6:	83 c4 10             	add    $0x10,%esp
80104da9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dae:	74 30                	je     80104de0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104db0:	83 ec 04             	sub    $0x4,%esp
80104db3:	ff 76 04             	push   0x4(%esi)
80104db6:	57                   	push   %edi
80104db7:	53                   	push   %ebx
80104db8:	e8 03 d2 ff ff       	call   80101fc0 <dirlink>
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	78 67                	js     80104e2b <create+0x15b>
  iunlockput(dp);
80104dc4:	83 ec 0c             	sub    $0xc,%esp
80104dc7:	53                   	push   %ebx
80104dc8:	e8 63 cc ff ff       	call   80101a30 <iunlockput>
  return ip;
80104dcd:	83 c4 10             	add    $0x10,%esp
}
80104dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dd3:	89 f0                	mov    %esi,%eax
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5f                   	pop    %edi
80104dd8:	5d                   	pop    %ebp
80104dd9:	c3                   	ret
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104de0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104de3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104de8:	53                   	push   %ebx
80104de9:	e8 02 c9 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dee:	83 c4 0c             	add    $0xc,%esp
80104df1:	ff 76 04             	push   0x4(%esi)
80104df4:	68 a9 79 10 80       	push   $0x801079a9
80104df9:	56                   	push   %esi
80104dfa:	e8 c1 d1 ff ff       	call   80101fc0 <dirlink>
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	85 c0                	test   %eax,%eax
80104e04:	78 18                	js     80104e1e <create+0x14e>
80104e06:	83 ec 04             	sub    $0x4,%esp
80104e09:	ff 73 04             	push   0x4(%ebx)
80104e0c:	68 a8 79 10 80       	push   $0x801079a8
80104e11:	56                   	push   %esi
80104e12:	e8 a9 d1 ff ff       	call   80101fc0 <dirlink>
80104e17:	83 c4 10             	add    $0x10,%esp
80104e1a:	85 c0                	test   %eax,%eax
80104e1c:	79 92                	jns    80104db0 <create+0xe0>
      panic("create dots");
80104e1e:	83 ec 0c             	sub    $0xc,%esp
80104e21:	68 9c 79 10 80       	push   $0x8010799c
80104e26:	e8 55 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104e2b:	83 ec 0c             	sub    $0xc,%esp
80104e2e:	68 ab 79 10 80       	push   $0x801079ab
80104e33:	e8 48 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e38:	83 ec 0c             	sub    $0xc,%esp
80104e3b:	68 8d 79 10 80       	push   $0x8010798d
80104e40:	e8 3b b5 ff ff       	call   80100380 <panic>
80104e45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e4c:	00 
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi

80104e50 <sys_dup>:
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e5b:	50                   	push   %eax
80104e5c:	6a 00                	push   $0x0
80104e5e:	e8 bd fc ff ff       	call   80104b20 <argint>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	85 c0                	test   %eax,%eax
80104e68:	78 36                	js     80104ea0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e6e:	77 30                	ja     80104ea0 <sys_dup+0x50>
80104e70:	e8 5b eb ff ff       	call   801039d0 <myproc>
80104e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e7c:	85 f6                	test   %esi,%esi
80104e7e:	74 20                	je     80104ea0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e80:	e8 4b eb ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e85:	31 db                	xor    %ebx,%ebx
80104e87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e8e:	00 
80104e8f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104e90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e94:	85 d2                	test   %edx,%edx
80104e96:	74 18                	je     80104eb0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e98:	83 c3 01             	add    $0x1,%ebx
80104e9b:	83 fb 10             	cmp    $0x10,%ebx
80104e9e:	75 f0                	jne    80104e90 <sys_dup+0x40>
}
80104ea0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ea3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ea8:	89 d8                	mov    %ebx,%eax
80104eaa:	5b                   	pop    %ebx
80104eab:	5e                   	pop    %esi
80104eac:	5d                   	pop    %ebp
80104ead:	c3                   	ret
80104eae:	66 90                	xchg   %ax,%ax
  filedup(f);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104eb3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104eb7:	56                   	push   %esi
80104eb8:	e8 03 c0 ff ff       	call   80100ec0 <filedup>
  return fd;
80104ebd:	83 c4 10             	add    $0x10,%esp
}
80104ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec3:	89 d8                	mov    %ebx,%eax
80104ec5:	5b                   	pop    %ebx
80104ec6:	5e                   	pop    %esi
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ed0 <sys_read>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	56                   	push   %esi
80104ed4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ed5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ed8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104edb:	53                   	push   %ebx
80104edc:	6a 00                	push   $0x0
80104ede:	e8 3d fc ff ff       	call   80104b20 <argint>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	78 5e                	js     80104f48 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104eea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eee:	77 58                	ja     80104f48 <sys_read+0x78>
80104ef0:	e8 db ea ff ff       	call   801039d0 <myproc>
80104ef5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ef8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104efc:	85 f6                	test   %esi,%esi
80104efe:	74 48                	je     80104f48 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f00:	83 ec 08             	sub    $0x8,%esp
80104f03:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f06:	50                   	push   %eax
80104f07:	6a 02                	push   $0x2
80104f09:	e8 12 fc ff ff       	call   80104b20 <argint>
80104f0e:	83 c4 10             	add    $0x10,%esp
80104f11:	85 c0                	test   %eax,%eax
80104f13:	78 33                	js     80104f48 <sys_read+0x78>
80104f15:	83 ec 04             	sub    $0x4,%esp
80104f18:	ff 75 f0             	push   -0x10(%ebp)
80104f1b:	53                   	push   %ebx
80104f1c:	6a 01                	push   $0x1
80104f1e:	e8 4d fc ff ff       	call   80104b70 <argptr>
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	85 c0                	test   %eax,%eax
80104f28:	78 1e                	js     80104f48 <sys_read+0x78>
  return fileread(f, p, n);
80104f2a:	83 ec 04             	sub    $0x4,%esp
80104f2d:	ff 75 f0             	push   -0x10(%ebp)
80104f30:	ff 75 f4             	push   -0xc(%ebp)
80104f33:	56                   	push   %esi
80104f34:	e8 07 c1 ff ff       	call   80101040 <fileread>
80104f39:	83 c4 10             	add    $0x10,%esp
}
80104f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f3f:	5b                   	pop    %ebx
80104f40:	5e                   	pop    %esi
80104f41:	5d                   	pop    %ebp
80104f42:	c3                   	ret
80104f43:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4d:	eb ed                	jmp    80104f3c <sys_read+0x6c>
80104f4f:	90                   	nop

80104f50 <sys_write>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f5b:	53                   	push   %ebx
80104f5c:	6a 00                	push   $0x0
80104f5e:	e8 bd fb ff ff       	call   80104b20 <argint>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 5e                	js     80104fc8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f6e:	77 58                	ja     80104fc8 <sys_write+0x78>
80104f70:	e8 5b ea ff ff       	call   801039d0 <myproc>
80104f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f7c:	85 f6                	test   %esi,%esi
80104f7e:	74 48                	je     80104fc8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f80:	83 ec 08             	sub    $0x8,%esp
80104f83:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f86:	50                   	push   %eax
80104f87:	6a 02                	push   $0x2
80104f89:	e8 92 fb ff ff       	call   80104b20 <argint>
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	85 c0                	test   %eax,%eax
80104f93:	78 33                	js     80104fc8 <sys_write+0x78>
80104f95:	83 ec 04             	sub    $0x4,%esp
80104f98:	ff 75 f0             	push   -0x10(%ebp)
80104f9b:	53                   	push   %ebx
80104f9c:	6a 01                	push   $0x1
80104f9e:	e8 cd fb ff ff       	call   80104b70 <argptr>
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	85 c0                	test   %eax,%eax
80104fa8:	78 1e                	js     80104fc8 <sys_write+0x78>
  return filewrite(f, p, n);
80104faa:	83 ec 04             	sub    $0x4,%esp
80104fad:	ff 75 f0             	push   -0x10(%ebp)
80104fb0:	ff 75 f4             	push   -0xc(%ebp)
80104fb3:	56                   	push   %esi
80104fb4:	e8 17 c1 ff ff       	call   801010d0 <filewrite>
80104fb9:	83 c4 10             	add    $0x10,%esp
}
80104fbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fbf:	5b                   	pop    %ebx
80104fc0:	5e                   	pop    %esi
80104fc1:	5d                   	pop    %ebp
80104fc2:	c3                   	ret
80104fc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fcd:	eb ed                	jmp    80104fbc <sys_write+0x6c>
80104fcf:	90                   	nop

80104fd0 <sys_close>:
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fd8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fdb:	50                   	push   %eax
80104fdc:	6a 00                	push   $0x0
80104fde:	e8 3d fb ff ff       	call   80104b20 <argint>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	78 3e                	js     80105028 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fee:	77 38                	ja     80105028 <sys_close+0x58>
80104ff0:	e8 db e9 ff ff       	call   801039d0 <myproc>
80104ff5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ff8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104ffb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104fff:	85 f6                	test   %esi,%esi
80105001:	74 25                	je     80105028 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105003:	e8 c8 e9 ff ff       	call   801039d0 <myproc>
  fileclose(f);
80105008:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010500b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105012:	00 
  fileclose(f);
80105013:	56                   	push   %esi
80105014:	e8 f7 be ff ff       	call   80100f10 <fileclose>
  return 0;
80105019:	83 c4 10             	add    $0x10,%esp
8010501c:	31 c0                	xor    %eax,%eax
}
8010501e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105021:	5b                   	pop    %ebx
80105022:	5e                   	pop    %esi
80105023:	5d                   	pop    %ebp
80105024:	c3                   	ret
80105025:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502d:	eb ef                	jmp    8010501e <sys_close+0x4e>
8010502f:	90                   	nop

80105030 <sys_fstat>:
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105035:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105038:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010503b:	53                   	push   %ebx
8010503c:	6a 00                	push   $0x0
8010503e:	e8 dd fa ff ff       	call   80104b20 <argint>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	78 46                	js     80105090 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010504a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010504e:	77 40                	ja     80105090 <sys_fstat+0x60>
80105050:	e8 7b e9 ff ff       	call   801039d0 <myproc>
80105055:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105058:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010505c:	85 f6                	test   %esi,%esi
8010505e:	74 30                	je     80105090 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105060:	83 ec 04             	sub    $0x4,%esp
80105063:	6a 14                	push   $0x14
80105065:	53                   	push   %ebx
80105066:	6a 01                	push   $0x1
80105068:	e8 03 fb ff ff       	call   80104b70 <argptr>
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	85 c0                	test   %eax,%eax
80105072:	78 1c                	js     80105090 <sys_fstat+0x60>
  return filestat(f, st);
80105074:	83 ec 08             	sub    $0x8,%esp
80105077:	ff 75 f4             	push   -0xc(%ebp)
8010507a:	56                   	push   %esi
8010507b:	e8 70 bf ff ff       	call   80100ff0 <filestat>
80105080:	83 c4 10             	add    $0x10,%esp
}
80105083:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105086:	5b                   	pop    %ebx
80105087:	5e                   	pop    %esi
80105088:	5d                   	pop    %ebp
80105089:	c3                   	ret
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105095:	eb ec                	jmp    80105083 <sys_fstat+0x53>
80105097:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010509e:	00 
8010509f:	90                   	nop

801050a0 <sys_link>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050a8:	53                   	push   %ebx
801050a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 2c fb ff ff       	call   80104be0 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 fb 00 00 00    	js     801051ba <sys_link+0x11a>
801050bf:	83 ec 08             	sub    $0x8,%esp
801050c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050c5:	50                   	push   %eax
801050c6:	6a 01                	push   $0x1
801050c8:	e8 13 fb ff ff       	call   80104be0 <argstr>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	0f 88 e2 00 00 00    	js     801051ba <sys_link+0x11a>
  begin_op();
801050d8:	e8 d3 dc ff ff       	call   80102db0 <begin_op>
  if((ip = namei(old)) == 0){
801050dd:	83 ec 0c             	sub    $0xc,%esp
801050e0:	ff 75 d4             	push   -0x2c(%ebp)
801050e3:	e8 98 cf ff ff       	call   80102080 <namei>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	89 c3                	mov    %eax,%ebx
801050ed:	85 c0                	test   %eax,%eax
801050ef:	0f 84 df 00 00 00    	je     801051d4 <sys_link+0x134>
  ilock(ip);
801050f5:	83 ec 0c             	sub    $0xc,%esp
801050f8:	50                   	push   %eax
801050f9:	e8 a2 c6 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105106:	0f 84 b5 00 00 00    	je     801051c1 <sys_link+0x121>
  iupdate(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010510f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105114:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105117:	53                   	push   %ebx
80105118:	e8 d3 c5 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
8010511d:	89 1c 24             	mov    %ebx,(%esp)
80105120:	e8 5b c7 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105125:	58                   	pop    %eax
80105126:	5a                   	pop    %edx
80105127:	57                   	push   %edi
80105128:	ff 75 d0             	push   -0x30(%ebp)
8010512b:	e8 70 cf ff ff       	call   801020a0 <nameiparent>
80105130:	83 c4 10             	add    $0x10,%esp
80105133:	89 c6                	mov    %eax,%esi
80105135:	85 c0                	test   %eax,%eax
80105137:	74 5b                	je     80105194 <sys_link+0xf4>
  ilock(dp);
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	50                   	push   %eax
8010513d:	e8 5e c6 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105142:	8b 03                	mov    (%ebx),%eax
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	39 06                	cmp    %eax,(%esi)
80105149:	75 3d                	jne    80105188 <sys_link+0xe8>
8010514b:	83 ec 04             	sub    $0x4,%esp
8010514e:	ff 73 04             	push   0x4(%ebx)
80105151:	57                   	push   %edi
80105152:	56                   	push   %esi
80105153:	e8 68 ce ff ff       	call   80101fc0 <dirlink>
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	85 c0                	test   %eax,%eax
8010515d:	78 29                	js     80105188 <sys_link+0xe8>
  iunlockput(dp);
8010515f:	83 ec 0c             	sub    $0xc,%esp
80105162:	56                   	push   %esi
80105163:	e8 c8 c8 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80105168:	89 1c 24             	mov    %ebx,(%esp)
8010516b:	e8 60 c7 ff ff       	call   801018d0 <iput>
  end_op();
80105170:	e8 ab dc ff ff       	call   80102e20 <end_op>
  return 0;
80105175:	83 c4 10             	add    $0x10,%esp
80105178:	31 c0                	xor    %eax,%eax
}
8010517a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010517d:	5b                   	pop    %ebx
8010517e:	5e                   	pop    %esi
8010517f:	5f                   	pop    %edi
80105180:	5d                   	pop    %ebp
80105181:	c3                   	ret
80105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105188:	83 ec 0c             	sub    $0xc,%esp
8010518b:	56                   	push   %esi
8010518c:	e8 9f c8 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105191:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	53                   	push   %ebx
80105198:	e8 03 c6 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010519d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051a2:	89 1c 24             	mov    %ebx,(%esp)
801051a5:	e8 46 c5 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801051aa:	89 1c 24             	mov    %ebx,(%esp)
801051ad:	e8 7e c8 ff ff       	call   80101a30 <iunlockput>
  end_op();
801051b2:	e8 69 dc ff ff       	call   80102e20 <end_op>
  return -1;
801051b7:	83 c4 10             	add    $0x10,%esp
    return -1;
801051ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051bf:	eb b9                	jmp    8010517a <sys_link+0xda>
    iunlockput(ip);
801051c1:	83 ec 0c             	sub    $0xc,%esp
801051c4:	53                   	push   %ebx
801051c5:	e8 66 c8 ff ff       	call   80101a30 <iunlockput>
    end_op();
801051ca:	e8 51 dc ff ff       	call   80102e20 <end_op>
    return -1;
801051cf:	83 c4 10             	add    $0x10,%esp
801051d2:	eb e6                	jmp    801051ba <sys_link+0x11a>
    end_op();
801051d4:	e8 47 dc ff ff       	call   80102e20 <end_op>
    return -1;
801051d9:	eb df                	jmp    801051ba <sys_link+0x11a>
801051db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801051e0 <sys_unlink>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	57                   	push   %edi
801051e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051e8:	53                   	push   %ebx
801051e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051ec:	50                   	push   %eax
801051ed:	6a 00                	push   $0x0
801051ef:	e8 ec f9 ff ff       	call   80104be0 <argstr>
801051f4:	83 c4 10             	add    $0x10,%esp
801051f7:	85 c0                	test   %eax,%eax
801051f9:	0f 88 54 01 00 00    	js     80105353 <sys_unlink+0x173>
  begin_op();
801051ff:	e8 ac db ff ff       	call   80102db0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105204:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105207:	83 ec 08             	sub    $0x8,%esp
8010520a:	53                   	push   %ebx
8010520b:	ff 75 c0             	push   -0x40(%ebp)
8010520e:	e8 8d ce ff ff       	call   801020a0 <nameiparent>
80105213:	83 c4 10             	add    $0x10,%esp
80105216:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105219:	85 c0                	test   %eax,%eax
8010521b:	0f 84 58 01 00 00    	je     80105379 <sys_unlink+0x199>
  ilock(dp);
80105221:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105224:	83 ec 0c             	sub    $0xc,%esp
80105227:	57                   	push   %edi
80105228:	e8 73 c5 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010522d:	58                   	pop    %eax
8010522e:	5a                   	pop    %edx
8010522f:	68 a9 79 10 80       	push   $0x801079a9
80105234:	53                   	push   %ebx
80105235:	e8 96 ca ff ff       	call   80101cd0 <namecmp>
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	85 c0                	test   %eax,%eax
8010523f:	0f 84 fb 00 00 00    	je     80105340 <sys_unlink+0x160>
80105245:	83 ec 08             	sub    $0x8,%esp
80105248:	68 a8 79 10 80       	push   $0x801079a8
8010524d:	53                   	push   %ebx
8010524e:	e8 7d ca ff ff       	call   80101cd0 <namecmp>
80105253:	83 c4 10             	add    $0x10,%esp
80105256:	85 c0                	test   %eax,%eax
80105258:	0f 84 e2 00 00 00    	je     80105340 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010525e:	83 ec 04             	sub    $0x4,%esp
80105261:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105264:	50                   	push   %eax
80105265:	53                   	push   %ebx
80105266:	57                   	push   %edi
80105267:	e8 84 ca ff ff       	call   80101cf0 <dirlookup>
8010526c:	83 c4 10             	add    $0x10,%esp
8010526f:	89 c3                	mov    %eax,%ebx
80105271:	85 c0                	test   %eax,%eax
80105273:	0f 84 c7 00 00 00    	je     80105340 <sys_unlink+0x160>
  ilock(ip);
80105279:	83 ec 0c             	sub    $0xc,%esp
8010527c:	50                   	push   %eax
8010527d:	e8 1e c5 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105282:	83 c4 10             	add    $0x10,%esp
80105285:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010528a:	0f 8e 0a 01 00 00    	jle    8010539a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105290:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105295:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105298:	74 66                	je     80105300 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010529a:	83 ec 04             	sub    $0x4,%esp
8010529d:	6a 10                	push   $0x10
8010529f:	6a 00                	push   $0x0
801052a1:	57                   	push   %edi
801052a2:	e8 c9 f5 ff ff       	call   80104870 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052a7:	6a 10                	push   $0x10
801052a9:	ff 75 c4             	push   -0x3c(%ebp)
801052ac:	57                   	push   %edi
801052ad:	ff 75 b4             	push   -0x4c(%ebp)
801052b0:	e8 fb c8 ff ff       	call   80101bb0 <writei>
801052b5:	83 c4 20             	add    $0x20,%esp
801052b8:	83 f8 10             	cmp    $0x10,%eax
801052bb:	0f 85 cc 00 00 00    	jne    8010538d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801052c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052c6:	0f 84 94 00 00 00    	je     80105360 <sys_unlink+0x180>
  iunlockput(dp);
801052cc:	83 ec 0c             	sub    $0xc,%esp
801052cf:	ff 75 b4             	push   -0x4c(%ebp)
801052d2:	e8 59 c7 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801052d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052dc:	89 1c 24             	mov    %ebx,(%esp)
801052df:	e8 0c c4 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801052e4:	89 1c 24             	mov    %ebx,(%esp)
801052e7:	e8 44 c7 ff ff       	call   80101a30 <iunlockput>
  end_op();
801052ec:	e8 2f db ff ff       	call   80102e20 <end_op>
  return 0;
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	31 c0                	xor    %eax,%eax
}
801052f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052f9:	5b                   	pop    %ebx
801052fa:	5e                   	pop    %esi
801052fb:	5f                   	pop    %edi
801052fc:	5d                   	pop    %ebp
801052fd:	c3                   	ret
801052fe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105300:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105304:	76 94                	jbe    8010529a <sys_unlink+0xba>
80105306:	be 20 00 00 00       	mov    $0x20,%esi
8010530b:	eb 0b                	jmp    80105318 <sys_unlink+0x138>
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
80105310:	83 c6 10             	add    $0x10,%esi
80105313:	3b 73 58             	cmp    0x58(%ebx),%esi
80105316:	73 82                	jae    8010529a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105318:	6a 10                	push   $0x10
8010531a:	56                   	push   %esi
8010531b:	57                   	push   %edi
8010531c:	53                   	push   %ebx
8010531d:	e8 8e c7 ff ff       	call   80101ab0 <readi>
80105322:	83 c4 10             	add    $0x10,%esp
80105325:	83 f8 10             	cmp    $0x10,%eax
80105328:	75 56                	jne    80105380 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010532a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010532f:	74 df                	je     80105310 <sys_unlink+0x130>
    iunlockput(ip);
80105331:	83 ec 0c             	sub    $0xc,%esp
80105334:	53                   	push   %ebx
80105335:	e8 f6 c6 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	ff 75 b4             	push   -0x4c(%ebp)
80105346:	e8 e5 c6 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010534b:	e8 d0 da ff ff       	call   80102e20 <end_op>
  return -1;
80105350:	83 c4 10             	add    $0x10,%esp
    return -1;
80105353:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105358:	eb 9c                	jmp    801052f6 <sys_unlink+0x116>
8010535a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105360:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105363:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105366:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010536b:	50                   	push   %eax
8010536c:	e8 7f c3 ff ff       	call   801016f0 <iupdate>
80105371:	83 c4 10             	add    $0x10,%esp
80105374:	e9 53 ff ff ff       	jmp    801052cc <sys_unlink+0xec>
    end_op();
80105379:	e8 a2 da ff ff       	call   80102e20 <end_op>
    return -1;
8010537e:	eb d3                	jmp    80105353 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105380:	83 ec 0c             	sub    $0xc,%esp
80105383:	68 cd 79 10 80       	push   $0x801079cd
80105388:	e8 f3 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010538d:	83 ec 0c             	sub    $0xc,%esp
80105390:	68 df 79 10 80       	push   $0x801079df
80105395:	e8 e6 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010539a:	83 ec 0c             	sub    $0xc,%esp
8010539d:	68 bb 79 10 80       	push   $0x801079bb
801053a2:	e8 d9 af ff ff       	call   80100380 <panic>
801053a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053ae:	00 
801053af:	90                   	nop

801053b0 <sys_open>:

int
sys_open(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	57                   	push   %edi
801053b4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053b8:	53                   	push   %ebx
801053b9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053bc:	50                   	push   %eax
801053bd:	6a 00                	push   $0x0
801053bf:	e8 1c f8 ff ff       	call   80104be0 <argstr>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
801053c9:	0f 88 8e 00 00 00    	js     8010545d <sys_open+0xad>
801053cf:	83 ec 08             	sub    $0x8,%esp
801053d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053d5:	50                   	push   %eax
801053d6:	6a 01                	push   $0x1
801053d8:	e8 43 f7 ff ff       	call   80104b20 <argint>
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	85 c0                	test   %eax,%eax
801053e2:	78 79                	js     8010545d <sys_open+0xad>
    return -1;

  begin_op();
801053e4:	e8 c7 d9 ff ff       	call   80102db0 <begin_op>

  if(omode & O_CREATE){
801053e9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053ed:	75 79                	jne    80105468 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053ef:	83 ec 0c             	sub    $0xc,%esp
801053f2:	ff 75 e0             	push   -0x20(%ebp)
801053f5:	e8 86 cc ff ff       	call   80102080 <namei>
801053fa:	83 c4 10             	add    $0x10,%esp
801053fd:	89 c6                	mov    %eax,%esi
801053ff:	85 c0                	test   %eax,%eax
80105401:	0f 84 7e 00 00 00    	je     80105485 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105407:	83 ec 0c             	sub    $0xc,%esp
8010540a:	50                   	push   %eax
8010540b:	e8 90 c3 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105410:	83 c4 10             	add    $0x10,%esp
80105413:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105418:	0f 84 ba 00 00 00    	je     801054d8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010541e:	e8 2d ba ff ff       	call   80100e50 <filealloc>
80105423:	89 c7                	mov    %eax,%edi
80105425:	85 c0                	test   %eax,%eax
80105427:	74 23                	je     8010544c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105429:	e8 a2 e5 ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010542e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105430:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105434:	85 d2                	test   %edx,%edx
80105436:	74 58                	je     80105490 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105438:	83 c3 01             	add    $0x1,%ebx
8010543b:	83 fb 10             	cmp    $0x10,%ebx
8010543e:	75 f0                	jne    80105430 <sys_open+0x80>
    if(f)
      fileclose(f);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	57                   	push   %edi
80105444:	e8 c7 ba ff ff       	call   80100f10 <fileclose>
80105449:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010544c:	83 ec 0c             	sub    $0xc,%esp
8010544f:	56                   	push   %esi
80105450:	e8 db c5 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105455:	e8 c6 d9 ff ff       	call   80102e20 <end_op>
    return -1;
8010545a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010545d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105462:	eb 65                	jmp    801054c9 <sys_open+0x119>
80105464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105468:	83 ec 0c             	sub    $0xc,%esp
8010546b:	31 c9                	xor    %ecx,%ecx
8010546d:	ba 02 00 00 00       	mov    $0x2,%edx
80105472:	6a 00                	push   $0x0
80105474:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105477:	e8 54 f8 ff ff       	call   80104cd0 <create>
    if(ip == 0){
8010547c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010547f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105481:	85 c0                	test   %eax,%eax
80105483:	75 99                	jne    8010541e <sys_open+0x6e>
      end_op();
80105485:	e8 96 d9 ff ff       	call   80102e20 <end_op>
      return -1;
8010548a:	eb d1                	jmp    8010545d <sys_open+0xad>
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105490:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105493:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105497:	56                   	push   %esi
80105498:	e8 e3 c3 ff ff       	call   80101880 <iunlock>
  end_op();
8010549d:	e8 7e d9 ff ff       	call   80102e20 <end_op>

  f->type = FD_INODE;
801054a2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054ab:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054ae:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054b1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054b3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054ba:	f7 d0                	not    %eax
801054bc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054bf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054c2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054c5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054cc:	89 d8                	mov    %ebx,%eax
801054ce:	5b                   	pop    %ebx
801054cf:	5e                   	pop    %esi
801054d0:	5f                   	pop    %edi
801054d1:	5d                   	pop    %ebp
801054d2:	c3                   	ret
801054d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801054d8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054db:	85 c9                	test   %ecx,%ecx
801054dd:	0f 84 3b ff ff ff    	je     8010541e <sys_open+0x6e>
801054e3:	e9 64 ff ff ff       	jmp    8010544c <sys_open+0x9c>
801054e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054ef:	00 

801054f0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054f6:	e8 b5 d8 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054fb:	83 ec 08             	sub    $0x8,%esp
801054fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105501:	50                   	push   %eax
80105502:	6a 00                	push   $0x0
80105504:	e8 d7 f6 ff ff       	call   80104be0 <argstr>
80105509:	83 c4 10             	add    $0x10,%esp
8010550c:	85 c0                	test   %eax,%eax
8010550e:	78 30                	js     80105540 <sys_mkdir+0x50>
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105516:	31 c9                	xor    %ecx,%ecx
80105518:	ba 01 00 00 00       	mov    $0x1,%edx
8010551d:	6a 00                	push   $0x0
8010551f:	e8 ac f7 ff ff       	call   80104cd0 <create>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	85 c0                	test   %eax,%eax
80105529:	74 15                	je     80105540 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010552b:	83 ec 0c             	sub    $0xc,%esp
8010552e:	50                   	push   %eax
8010552f:	e8 fc c4 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105534:	e8 e7 d8 ff ff       	call   80102e20 <end_op>
  return 0;
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	31 c0                	xor    %eax,%eax
}
8010553e:	c9                   	leave
8010553f:	c3                   	ret
    end_op();
80105540:	e8 db d8 ff ff       	call   80102e20 <end_op>
    return -1;
80105545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010554a:	c9                   	leave
8010554b:	c3                   	ret
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_mknod>:

int
sys_mknod(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105556:	e8 55 d8 ff ff       	call   80102db0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010555b:	83 ec 08             	sub    $0x8,%esp
8010555e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105561:	50                   	push   %eax
80105562:	6a 00                	push   $0x0
80105564:	e8 77 f6 ff ff       	call   80104be0 <argstr>
80105569:	83 c4 10             	add    $0x10,%esp
8010556c:	85 c0                	test   %eax,%eax
8010556e:	78 60                	js     801055d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105576:	50                   	push   %eax
80105577:	6a 01                	push   $0x1
80105579:	e8 a2 f5 ff ff       	call   80104b20 <argint>
  if((argstr(0, &path)) < 0 ||
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	85 c0                	test   %eax,%eax
80105583:	78 4b                	js     801055d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105585:	83 ec 08             	sub    $0x8,%esp
80105588:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010558b:	50                   	push   %eax
8010558c:	6a 02                	push   $0x2
8010558e:	e8 8d f5 ff ff       	call   80104b20 <argint>
     argint(1, &major) < 0 ||
80105593:	83 c4 10             	add    $0x10,%esp
80105596:	85 c0                	test   %eax,%eax
80105598:	78 36                	js     801055d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010559a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010559e:	83 ec 0c             	sub    $0xc,%esp
801055a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055a5:	ba 03 00 00 00       	mov    $0x3,%edx
801055aa:	50                   	push   %eax
801055ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055ae:	e8 1d f7 ff ff       	call   80104cd0 <create>
     argint(2, &minor) < 0 ||
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 c0                	test   %eax,%eax
801055b8:	74 16                	je     801055d0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055ba:	83 ec 0c             	sub    $0xc,%esp
801055bd:	50                   	push   %eax
801055be:	e8 6d c4 ff ff       	call   80101a30 <iunlockput>
  end_op();
801055c3:	e8 58 d8 ff ff       	call   80102e20 <end_op>
  return 0;
801055c8:	83 c4 10             	add    $0x10,%esp
801055cb:	31 c0                	xor    %eax,%eax
}
801055cd:	c9                   	leave
801055ce:	c3                   	ret
801055cf:	90                   	nop
    end_op();
801055d0:	e8 4b d8 ff ff       	call   80102e20 <end_op>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055da:	c9                   	leave
801055db:	c3                   	ret
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_chdir>:

int
sys_chdir(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
801055e5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055e8:	e8 e3 e3 ff ff       	call   801039d0 <myproc>
801055ed:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055ef:	e8 bc d7 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055f4:	83 ec 08             	sub    $0x8,%esp
801055f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055fa:	50                   	push   %eax
801055fb:	6a 00                	push   $0x0
801055fd:	e8 de f5 ff ff       	call   80104be0 <argstr>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	78 77                	js     80105680 <sys_chdir+0xa0>
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	ff 75 f4             	push   -0xc(%ebp)
8010560f:	e8 6c ca ff ff       	call   80102080 <namei>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	89 c3                	mov    %eax,%ebx
80105619:	85 c0                	test   %eax,%eax
8010561b:	74 63                	je     80105680 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	50                   	push   %eax
80105621:	e8 7a c1 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010562e:	75 30                	jne    80105660 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	53                   	push   %ebx
80105634:	e8 47 c2 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105639:	58                   	pop    %eax
8010563a:	ff 76 68             	push   0x68(%esi)
8010563d:	e8 8e c2 ff ff       	call   801018d0 <iput>
  end_op();
80105642:	e8 d9 d7 ff ff       	call   80102e20 <end_op>
  curproc->cwd = ip;
80105647:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010564a:	83 c4 10             	add    $0x10,%esp
8010564d:	31 c0                	xor    %eax,%eax
}
8010564f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105652:	5b                   	pop    %ebx
80105653:	5e                   	pop    %esi
80105654:	5d                   	pop    %ebp
80105655:	c3                   	ret
80105656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010565d:	00 
8010565e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	53                   	push   %ebx
80105664:	e8 c7 c3 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105669:	e8 b2 d7 ff ff       	call   80102e20 <end_op>
    return -1;
8010566e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105676:	eb d7                	jmp    8010564f <sys_chdir+0x6f>
80105678:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010567f:	00 
    end_op();
80105680:	e8 9b d7 ff ff       	call   80102e20 <end_op>
    return -1;
80105685:	eb ea                	jmp    80105671 <sys_chdir+0x91>
80105687:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010568e:	00 
8010568f:	90                   	nop

80105690 <sys_exec>:

int
sys_exec(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	57                   	push   %edi
80105694:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105695:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010569b:	53                   	push   %ebx
8010569c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056a2:	50                   	push   %eax
801056a3:	6a 00                	push   $0x0
801056a5:	e8 36 f5 ff ff       	call   80104be0 <argstr>
801056aa:	83 c4 10             	add    $0x10,%esp
801056ad:	85 c0                	test   %eax,%eax
801056af:	0f 88 87 00 00 00    	js     8010573c <sys_exec+0xac>
801056b5:	83 ec 08             	sub    $0x8,%esp
801056b8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056be:	50                   	push   %eax
801056bf:	6a 01                	push   $0x1
801056c1:	e8 5a f4 ff ff       	call   80104b20 <argint>
801056c6:	83 c4 10             	add    $0x10,%esp
801056c9:	85 c0                	test   %eax,%eax
801056cb:	78 6f                	js     8010573c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056cd:	83 ec 04             	sub    $0x4,%esp
801056d0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801056d6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056d8:	68 80 00 00 00       	push   $0x80
801056dd:	6a 00                	push   $0x0
801056df:	56                   	push   %esi
801056e0:	e8 8b f1 ff ff       	call   80104870 <memset>
801056e5:	83 c4 10             	add    $0x10,%esp
801056e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ef:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056f0:	83 ec 08             	sub    $0x8,%esp
801056f3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801056f9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105700:	50                   	push   %eax
80105701:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105707:	01 f8                	add    %edi,%eax
80105709:	50                   	push   %eax
8010570a:	e8 81 f3 ff ff       	call   80104a90 <fetchint>
8010570f:	83 c4 10             	add    $0x10,%esp
80105712:	85 c0                	test   %eax,%eax
80105714:	78 26                	js     8010573c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105716:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010571c:	85 c0                	test   %eax,%eax
8010571e:	74 30                	je     80105750 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105720:	83 ec 08             	sub    $0x8,%esp
80105723:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105726:	52                   	push   %edx
80105727:	50                   	push   %eax
80105728:	e8 a3 f3 ff ff       	call   80104ad0 <fetchstr>
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	85 c0                	test   %eax,%eax
80105732:	78 08                	js     8010573c <sys_exec+0xac>
  for(i=0;; i++){
80105734:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105737:	83 fb 20             	cmp    $0x20,%ebx
8010573a:	75 b4                	jne    801056f0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010573c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010573f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105744:	5b                   	pop    %ebx
80105745:	5e                   	pop    %esi
80105746:	5f                   	pop    %edi
80105747:	5d                   	pop    %ebp
80105748:	c3                   	ret
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105750:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105757:	00 00 00 00 
  return exec(path, argv);
8010575b:	83 ec 08             	sub    $0x8,%esp
8010575e:	56                   	push   %esi
8010575f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105765:	e8 46 b3 ff ff       	call   80100ab0 <exec>
8010576a:	83 c4 10             	add    $0x10,%esp
}
8010576d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105770:	5b                   	pop    %ebx
80105771:	5e                   	pop    %esi
80105772:	5f                   	pop    %edi
80105773:	5d                   	pop    %ebp
80105774:	c3                   	ret
80105775:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010577c:	00 
8010577d:	8d 76 00             	lea    0x0(%esi),%esi

80105780 <sys_pipe>:

int
sys_pipe(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105785:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105788:	53                   	push   %ebx
80105789:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010578c:	6a 08                	push   $0x8
8010578e:	50                   	push   %eax
8010578f:	6a 00                	push   $0x0
80105791:	e8 da f3 ff ff       	call   80104b70 <argptr>
80105796:	83 c4 10             	add    $0x10,%esp
80105799:	85 c0                	test   %eax,%eax
8010579b:	0f 88 8b 00 00 00    	js     8010582c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057a1:	83 ec 08             	sub    $0x8,%esp
801057a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057a7:	50                   	push   %eax
801057a8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057ab:	50                   	push   %eax
801057ac:	e8 cf dc ff ff       	call   80103480 <pipealloc>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	85 c0                	test   %eax,%eax
801057b6:	78 74                	js     8010582c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057b8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057bb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057bd:	e8 0e e2 ff ff       	call   801039d0 <myproc>
    if(curproc->ofile[fd] == 0){
801057c2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057c6:	85 f6                	test   %esi,%esi
801057c8:	74 16                	je     801057e0 <sys_pipe+0x60>
801057ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057d0:	83 c3 01             	add    $0x1,%ebx
801057d3:	83 fb 10             	cmp    $0x10,%ebx
801057d6:	74 3d                	je     80105815 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801057d8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057dc:	85 f6                	test   %esi,%esi
801057de:	75 f0                	jne    801057d0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801057e0:	8d 73 08             	lea    0x8(%ebx),%esi
801057e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801057ea:	e8 e1 e1 ff ff       	call   801039d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057ef:	31 d2                	xor    %edx,%edx
801057f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801057f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057fc:	85 c9                	test   %ecx,%ecx
801057fe:	74 38                	je     80105838 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105800:	83 c2 01             	add    $0x1,%edx
80105803:	83 fa 10             	cmp    $0x10,%edx
80105806:	75 f0                	jne    801057f8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105808:	e8 c3 e1 ff ff       	call   801039d0 <myproc>
8010580d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105814:	00 
    fileclose(rf);
80105815:	83 ec 0c             	sub    $0xc,%esp
80105818:	ff 75 e0             	push   -0x20(%ebp)
8010581b:	e8 f0 b6 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105820:	58                   	pop    %eax
80105821:	ff 75 e4             	push   -0x1c(%ebp)
80105824:	e8 e7 b6 ff ff       	call   80100f10 <fileclose>
    return -1;
80105829:	83 c4 10             	add    $0x10,%esp
    return -1;
8010582c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105831:	eb 16                	jmp    80105849 <sys_pipe+0xc9>
80105833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105838:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010583c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010583f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105841:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105844:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105847:	31 c0                	xor    %eax,%eax
}
80105849:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010584c:	5b                   	pop    %ebx
8010584d:	5e                   	pop    %esi
8010584e:	5f                   	pop    %edi
8010584f:	5d                   	pop    %ebp
80105850:	c3                   	ret
80105851:	66 90                	xchg   %ax,%ax
80105853:	66 90                	xchg   %ax,%ax
80105855:	66 90                	xchg   %ax,%ax
80105857:	66 90                	xchg   %ax,%ax
80105859:	66 90                	xchg   %ax,%ax
8010585b:	66 90                	xchg   %ax,%ax
8010585d:	66 90                	xchg   %ax,%ax
8010585f:	90                   	nop

80105860 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105860:	e9 0b e3 ff ff       	jmp    80103b70 <fork>
80105865:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010586c:	00 
8010586d:	8d 76 00             	lea    0x0(%esi),%esi

80105870 <sys_forkcow>:
}

int
sys_forkcow(void)
{
  return forkcow();
80105870:	e9 0b e4 ff ff       	jmp    80103c80 <forkcow>
80105875:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010587c:	00 
8010587d:	8d 76 00             	lea    0x0(%esi),%esi

80105880 <sys_exit>:
}

int
sys_exit(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 08             	sub    $0x8,%esp
  exit();
80105886:	e8 65 e6 ff ff       	call   80103ef0 <exit>
  return 0;  // not reached
}
8010588b:	31 c0                	xor    %eax,%eax
8010588d:	c9                   	leave
8010588e:	c3                   	ret
8010588f:	90                   	nop

80105890 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105890:	e9 8b e7 ff ff       	jmp    80104020 <wait>
80105895:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589c:	00 
8010589d:	8d 76 00             	lea    0x0(%esi),%esi

801058a0 <sys_kill>:
}

int
sys_kill(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a9:	50                   	push   %eax
801058aa:	6a 00                	push   $0x0
801058ac:	e8 6f f2 ff ff       	call   80104b20 <argint>
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	85 c0                	test   %eax,%eax
801058b6:	78 18                	js     801058d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058b8:	83 ec 0c             	sub    $0xc,%esp
801058bb:	ff 75 f4             	push   -0xc(%ebp)
801058be:	e8 fd e9 ff ff       	call   801042c0 <kill>
801058c3:	83 c4 10             	add    $0x10,%esp
}
801058c6:	c9                   	leave
801058c7:	c3                   	ret
801058c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058cf:	00 
801058d0:	c9                   	leave
    return -1;
801058d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d6:	c3                   	ret
801058d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058de:	00 
801058df:	90                   	nop

801058e0 <sys_getpid>:

int
sys_getpid(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058e6:	e8 e5 e0 ff ff       	call   801039d0 <myproc>
801058eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801058ee:	c9                   	leave
801058ef:	c3                   	ret

801058f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058fa:	50                   	push   %eax
801058fb:	6a 00                	push   $0x0
801058fd:	e8 1e f2 ff ff       	call   80104b20 <argint>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	85 c0                	test   %eax,%eax
80105907:	78 27                	js     80105930 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105909:	e8 c2 e0 ff ff       	call   801039d0 <myproc>
  if(growproc(n) < 0)
8010590e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105911:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105913:	ff 75 f4             	push   -0xc(%ebp)
80105916:	e8 d5 e1 ff ff       	call   80103af0 <growproc>
8010591b:	83 c4 10             	add    $0x10,%esp
8010591e:	85 c0                	test   %eax,%eax
80105920:	78 0e                	js     80105930 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105922:	89 d8                	mov    %ebx,%eax
80105924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105927:	c9                   	leave
80105928:	c3                   	ret
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105930:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105935:	eb eb                	jmp    80105922 <sys_sbrk+0x32>
80105937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010593e:	00 
8010593f:	90                   	nop

80105940 <sys_sleep>:

int
sys_sleep(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105947:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 ce f1 ff ff       	call   80104b20 <argint>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 64                	js     801059bd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105959:	83 ec 0c             	sub    $0xc,%esp
8010595c:	68 80 cc 14 80       	push   $0x8014cc80
80105961:	e8 0a ee ff ff       	call   80104770 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105966:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105969:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  while(ticks - ticks0 < n){
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	85 d2                	test   %edx,%edx
80105974:	75 2b                	jne    801059a1 <sys_sleep+0x61>
80105976:	eb 58                	jmp    801059d0 <sys_sleep+0x90>
80105978:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010597f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105980:	83 ec 08             	sub    $0x8,%esp
80105983:	68 80 cc 14 80       	push   $0x8014cc80
80105988:	68 60 cc 14 80       	push   $0x8014cc60
8010598d:	e8 0e e8 ff ff       	call   801041a0 <sleep>
  while(ticks - ticks0 < n){
80105992:	a1 60 cc 14 80       	mov    0x8014cc60,%eax
80105997:	83 c4 10             	add    $0x10,%esp
8010599a:	29 d8                	sub    %ebx,%eax
8010599c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010599f:	73 2f                	jae    801059d0 <sys_sleep+0x90>
    if(myproc()->killed){
801059a1:	e8 2a e0 ff ff       	call   801039d0 <myproc>
801059a6:	8b 40 24             	mov    0x24(%eax),%eax
801059a9:	85 c0                	test   %eax,%eax
801059ab:	74 d3                	je     80105980 <sys_sleep+0x40>
      release(&tickslock);
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	68 80 cc 14 80       	push   $0x8014cc80
801059b5:	e8 56 ed ff ff       	call   80104710 <release>
      return -1;
801059ba:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801059bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c5:	c9                   	leave
801059c6:	c3                   	ret
801059c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ce:	00 
801059cf:	90                   	nop
  release(&tickslock);
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	68 80 cc 14 80       	push   $0x8014cc80
801059d8:	e8 33 ed ff ff       	call   80104710 <release>
}
801059dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801059e0:	83 c4 10             	add    $0x10,%esp
801059e3:	31 c0                	xor    %eax,%eax
}
801059e5:	c9                   	leave
801059e6:	c3                   	ret
801059e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ee:	00 
801059ef:	90                   	nop

801059f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	53                   	push   %ebx
801059f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801059f7:	68 80 cc 14 80       	push   $0x8014cc80
801059fc:	e8 6f ed ff ff       	call   80104770 <acquire>
  xticks = ticks;
80105a01:	8b 1d 60 cc 14 80    	mov    0x8014cc60,%ebx
  release(&tickslock);
80105a07:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105a0e:	e8 fd ec ff ff       	call   80104710 <release>
  return xticks;
}
80105a13:	89 d8                	mov    %ebx,%eax
80105a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a18:	c9                   	leave
80105a19:	c3                   	ret
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a20 <sys_date>:

int
sys_date(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 1c             	sub    $0x1c,%esp
  char *ptr;
  argptr(0, &ptr, sizeof(struct rtcdate*));
80105a26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a29:	6a 04                	push   $0x4
80105a2b:	50                   	push   %eax
80105a2c:	6a 00                	push   $0x0
80105a2e:	e8 3d f1 ff ff       	call   80104b70 <argptr>
  struct rtcdate *r = (struct rtcdate*) ptr;
80105a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  *r = (struct rtcdate) {6, 6, 6, 6, 6, 6666};
80105a36:	c7 00 06 00 00 00    	movl   $0x6,(%eax)
80105a3c:	c7 40 04 06 00 00 00 	movl   $0x6,0x4(%eax)
80105a43:	c7 40 08 06 00 00 00 	movl   $0x6,0x8(%eax)
80105a4a:	c7 40 0c 06 00 00 00 	movl   $0x6,0xc(%eax)
80105a51:	c7 40 10 06 00 00 00 	movl   $0x6,0x10(%eax)
80105a58:	c7 40 14 0a 1a 00 00 	movl   $0x1a0a,0x14(%eax)
  return 0;
}
80105a5f:	31 c0                	xor    %eax,%eax
80105a61:	c9                   	leave
80105a62:	c3                   	ret
80105a63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6a:	00 
80105a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105a70 <sys_virt2real>:

int
sys_virt2real(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	83 ec 1c             	sub    $0x1c,%esp
  char *va;
  argptr(0, &va, sizeof(char*));
80105a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a79:	6a 04                	push   $0x4
80105a7b:	50                   	push   %eax
80105a7c:	6a 00                	push   $0x0
80105a7e:	e8 ed f0 ff ff       	call   80104b70 <argptr>
  return (int) virt2real(va);
80105a83:	58                   	pop    %eax
80105a84:	ff 75 f4             	push   -0xc(%ebp)
80105a87:	e8 44 1a 00 00       	call   801074d0 <virt2real>
}
80105a8c:	c9                   	leave
80105a8d:	c3                   	ret
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_numpages>:

int
sys_numpages(void)
{
  return numpages();
80105a90:	e9 6b e9 ff ff       	jmp    80104400 <numpages>

80105a95 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a95:	1e                   	push   %ds
  pushl %es
80105a96:	06                   	push   %es
  pushl %fs
80105a97:	0f a0                	push   %fs
  pushl %gs
80105a99:	0f a8                	push   %gs
  pushal
80105a9b:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a9c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105aa0:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105aa2:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105aa4:	54                   	push   %esp
  call trap
80105aa5:	e8 c6 00 00 00       	call   80105b70 <trap>
  addl $4, %esp
80105aaa:	83 c4 04             	add    $0x4,%esp

80105aad <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105aad:	61                   	popa
  popl %gs
80105aae:	0f a9                	pop    %gs
  popl %fs
80105ab0:	0f a1                	pop    %fs
  popl %es
80105ab2:	07                   	pop    %es
  popl %ds
80105ab3:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ab4:	83 c4 08             	add    $0x8,%esp
  iret
80105ab7:	cf                   	iret
80105ab8:	66 90                	xchg   %ax,%ax
80105aba:	66 90                	xchg   %ax,%ax
80105abc:	66 90                	xchg   %ax,%ax
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ac0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ac1:	31 c0                	xor    %eax,%eax
{
80105ac3:	89 e5                	mov    %esp,%ebp
80105ac5:	83 ec 08             	sub    $0x8,%esp
80105ac8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105acf:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ad0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ad7:	c7 04 c5 c2 cc 14 80 	movl   $0x8e000008,-0x7feb333e(,%eax,8)
80105ade:	08 00 00 8e 
80105ae2:	66 89 14 c5 c0 cc 14 	mov    %dx,-0x7feb3340(,%eax,8)
80105ae9:	80 
80105aea:	c1 ea 10             	shr    $0x10,%edx
80105aed:	66 89 14 c5 c6 cc 14 	mov    %dx,-0x7feb333a(,%eax,8)
80105af4:	80 
  for(i = 0; i < 256; i++)
80105af5:	83 c0 01             	add    $0x1,%eax
80105af8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105afd:	75 d1                	jne    80105ad0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105aff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b02:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105b07:	c7 05 c2 ce 14 80 08 	movl   $0xef000008,0x8014cec2
80105b0e:	00 00 ef 
  initlock(&tickslock, "time");
80105b11:	68 ee 79 10 80       	push   $0x801079ee
80105b16:	68 80 cc 14 80       	push   $0x8014cc80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b1b:	66 a3 c0 ce 14 80    	mov    %ax,0x8014cec0
80105b21:	c1 e8 10             	shr    $0x10,%eax
80105b24:	66 a3 c6 ce 14 80    	mov    %ax,0x8014cec6
  initlock(&tickslock, "time");
80105b2a:	e8 51 ea ff ff       	call   80104580 <initlock>
}
80105b2f:	83 c4 10             	add    $0x10,%esp
80105b32:	c9                   	leave
80105b33:	c3                   	ret
80105b34:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b3b:	00 
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <idtinit>:

void
idtinit(void)
{
80105b40:	55                   	push   %ebp
  pd[0] = size-1;
80105b41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b46:	89 e5                	mov    %esp,%ebp
80105b48:	83 ec 10             	sub    $0x10,%esp
80105b4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b4f:	b8 c0 cc 14 80       	mov    $0x8014ccc0,%eax
80105b54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b58:	c1 e8 10             	shr    $0x10,%eax
80105b5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b65:	c9                   	leave
80105b66:	c3                   	ret
80105b67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b6e:	00 
80105b6f:	90                   	nop

80105b70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
80105b76:	83 ec 1c             	sub    $0x1c,%esp
80105b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b7c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b7f:	83 f8 40             	cmp    $0x40,%eax
80105b82:	0f 84 30 01 00 00    	je     80105cb8 <trap+0x148>
    if(myproc()->killed)
      exit();
    return;
  }

  if(tf->trapno == T_PGFLT){
80105b88:	83 f8 0e             	cmp    $0xe,%eax
80105b8b:	0f 84 8f 00 00 00    	je     80105c20 <trap+0xb0>
      handle_cow_fault(va);
      return;
    }
  }

  switch(tf->trapno){
80105b91:	83 e8 20             	sub    $0x20,%eax
80105b94:	83 f8 1f             	cmp    $0x1f,%eax
80105b97:	0f 87 8c 00 00 00    	ja     80105c29 <trap+0xb9>
80105b9d:	ff 24 85 e8 7f 10 80 	jmp    *-0x7fef8018(,%eax,4)
80105ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ba8:	e8 83 c6 ff ff       	call   80102230 <ideintr>
    lapiceoi();
80105bad:	e8 ae cd ff ff       	call   80102960 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bb2:	e8 19 de ff ff       	call   801039d0 <myproc>
80105bb7:	85 c0                	test   %eax,%eax
80105bb9:	74 1a                	je     80105bd5 <trap+0x65>
80105bbb:	e8 10 de ff ff       	call   801039d0 <myproc>
80105bc0:	8b 50 24             	mov    0x24(%eax),%edx
80105bc3:	85 d2                	test   %edx,%edx
80105bc5:	74 0e                	je     80105bd5 <trap+0x65>
80105bc7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105bcb:	f7 d0                	not    %eax
80105bcd:	a8 03                	test   $0x3,%al
80105bcf:	0f 84 cb 01 00 00    	je     80105da0 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105bd5:	e8 f6 dd ff ff       	call   801039d0 <myproc>
80105bda:	85 c0                	test   %eax,%eax
80105bdc:	74 0f                	je     80105bed <trap+0x7d>
80105bde:	e8 ed dd ff ff       	call   801039d0 <myproc>
80105be3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105be7:	0f 84 9b 01 00 00    	je     80105d88 <trap+0x218>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bed:	e8 de dd ff ff       	call   801039d0 <myproc>
80105bf2:	85 c0                	test   %eax,%eax
80105bf4:	74 1a                	je     80105c10 <trap+0xa0>
80105bf6:	e8 d5 dd ff ff       	call   801039d0 <myproc>
80105bfb:	8b 40 24             	mov    0x24(%eax),%eax
80105bfe:	85 c0                	test   %eax,%eax
80105c00:	74 0e                	je     80105c10 <trap+0xa0>
80105c02:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c06:	f7 d0                	not    %eax
80105c08:	a8 03                	test   $0x3,%al
80105c0a:	0f 84 d5 00 00 00    	je     80105ce5 <trap+0x175>
    exit();
}
80105c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c13:	5b                   	pop    %ebx
80105c14:	5e                   	pop    %esi
80105c15:	5f                   	pop    %edi
80105c16:	5d                   	pop    %ebp
80105c17:	c3                   	ret
80105c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c1f:	00 

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c20:	0f 20 d0             	mov    %cr2,%eax
    if((tf->err & 0x2) && (va < KERNBASE)){
80105c23:	f6 43 34 02          	testb  $0x2,0x34(%ebx)
80105c27:	75 77                	jne    80105ca0 <trap+0x130>
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c29:	e8 a2 dd ff ff       	call   801039d0 <myproc>
80105c2e:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c31:	85 c0                	test   %eax,%eax
80105c33:	0f 84 81 01 00 00    	je     80105dba <trap+0x24a>
80105c39:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c3d:	0f 84 77 01 00 00    	je     80105dba <trap+0x24a>
80105c43:	0f 20 d1             	mov    %cr2,%ecx
80105c46:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c49:	e8 62 dd ff ff       	call   801039b0 <cpuid>
80105c4e:	8b 73 30             	mov    0x30(%ebx),%esi
80105c51:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c54:	8b 43 34             	mov    0x34(%ebx),%eax
80105c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105c5a:	e8 71 dd ff ff       	call   801039d0 <myproc>
80105c5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c62:	e8 69 dd ff ff       	call   801039d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c67:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c6a:	51                   	push   %ecx
80105c6b:	57                   	push   %edi
80105c6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c6f:	52                   	push   %edx
80105c70:	ff 75 e4             	push   -0x1c(%ebp)
80105c73:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c74:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c77:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c7a:	56                   	push   %esi
80105c7b:	ff 70 10             	push   0x10(%eax)
80105c7e:	68 78 7c 10 80       	push   $0x80107c78
80105c83:	e8 28 aa ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105c88:	83 c4 20             	add    $0x20,%esp
80105c8b:	e8 40 dd ff ff       	call   801039d0 <myproc>
80105c90:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105c97:	e9 16 ff ff ff       	jmp    80105bb2 <trap+0x42>
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((tf->err & 0x2) && (va < KERNBASE)){
80105ca0:	85 c0                	test   %eax,%eax
80105ca2:	78 85                	js     80105c29 <trap+0xb9>
      handle_cow_fault(va);
80105ca4:	89 45 08             	mov    %eax,0x8(%ebp)
}
80105ca7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105caa:	5b                   	pop    %ebx
80105cab:	5e                   	pop    %esi
80105cac:	5f                   	pop    %edi
80105cad:	5d                   	pop    %ebp
      handle_cow_fault(va);
80105cae:	e9 7d 18 00 00       	jmp    80107530 <handle_cow_fault>
80105cb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105cb8:	e8 13 dd ff ff       	call   801039d0 <myproc>
80105cbd:	8b 70 24             	mov    0x24(%eax),%esi
80105cc0:	85 f6                	test   %esi,%esi
80105cc2:	0f 85 e8 00 00 00    	jne    80105db0 <trap+0x240>
    myproc()->tf = tf;
80105cc8:	e8 03 dd ff ff       	call   801039d0 <myproc>
80105ccd:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105cd0:	e8 8b ef ff ff       	call   80104c60 <syscall>
    if(myproc()->killed)
80105cd5:	e8 f6 dc ff ff       	call   801039d0 <myproc>
80105cda:	8b 48 24             	mov    0x24(%eax),%ecx
80105cdd:	85 c9                	test   %ecx,%ecx
80105cdf:	0f 84 2b ff ff ff    	je     80105c10 <trap+0xa0>
}
80105ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ce8:	5b                   	pop    %ebx
80105ce9:	5e                   	pop    %esi
80105cea:	5f                   	pop    %edi
80105ceb:	5d                   	pop    %ebp
      exit();
80105cec:	e9 ff e1 ff ff       	jmp    80103ef0 <exit>
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cf8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cfb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cff:	e8 ac dc ff ff       	call   801039b0 <cpuid>
80105d04:	57                   	push   %edi
80105d05:	56                   	push   %esi
80105d06:	50                   	push   %eax
80105d07:	68 20 7c 10 80       	push   $0x80107c20
80105d0c:	e8 9f a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105d11:	e8 4a cc ff ff       	call   80102960 <lapiceoi>
    break;
80105d16:	83 c4 10             	add    $0x10,%esp
80105d19:	e9 94 fe ff ff       	jmp    80105bb2 <trap+0x42>
80105d1e:	66 90                	xchg   %ax,%ax
    uartintr();
80105d20:	e8 4b 02 00 00       	call   80105f70 <uartintr>
    lapiceoi();
80105d25:	e8 36 cc ff ff       	call   80102960 <lapiceoi>
    break;
80105d2a:	e9 83 fe ff ff       	jmp    80105bb2 <trap+0x42>
80105d2f:	90                   	nop
    kbdintr();
80105d30:	e8 fb ca ff ff       	call   80102830 <kbdintr>
    lapiceoi();
80105d35:	e8 26 cc ff ff       	call   80102960 <lapiceoi>
    break;
80105d3a:	e9 73 fe ff ff       	jmp    80105bb2 <trap+0x42>
80105d3f:	90                   	nop
    if(cpuid() == 0){
80105d40:	e8 6b dc ff ff       	call   801039b0 <cpuid>
80105d45:	85 c0                	test   %eax,%eax
80105d47:	0f 85 60 fe ff ff    	jne    80105bad <trap+0x3d>
      acquire(&tickslock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 80 cc 14 80       	push   $0x8014cc80
80105d55:	e8 16 ea ff ff       	call   80104770 <acquire>
      ticks++;
80105d5a:	83 05 60 cc 14 80 01 	addl   $0x1,0x8014cc60
      wakeup(&ticks);
80105d61:	c7 04 24 60 cc 14 80 	movl   $0x8014cc60,(%esp)
80105d68:	e8 f3 e4 ff ff       	call   80104260 <wakeup>
      release(&tickslock);
80105d6d:	c7 04 24 80 cc 14 80 	movl   $0x8014cc80,(%esp)
80105d74:	e8 97 e9 ff ff       	call   80104710 <release>
80105d79:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d7c:	e9 2c fe ff ff       	jmp    80105bad <trap+0x3d>
80105d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d88:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d8c:	0f 85 5b fe ff ff    	jne    80105bed <trap+0x7d>
    yield();
80105d92:	e8 b9 e3 ff ff       	call   80104150 <yield>
80105d97:	e9 51 fe ff ff       	jmp    80105bed <trap+0x7d>
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105da0:	e8 4b e1 ff ff       	call   80103ef0 <exit>
80105da5:	e9 2b fe ff ff       	jmp    80105bd5 <trap+0x65>
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105db0:	e8 3b e1 ff ff       	call   80103ef0 <exit>
80105db5:	e9 0e ff ff ff       	jmp    80105cc8 <trap+0x158>
80105dba:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105dbd:	e8 ee db ff ff       	call   801039b0 <cpuid>
80105dc2:	83 ec 0c             	sub    $0xc,%esp
80105dc5:	56                   	push   %esi
80105dc6:	57                   	push   %edi
80105dc7:	50                   	push   %eax
80105dc8:	ff 73 30             	push   0x30(%ebx)
80105dcb:	68 44 7c 10 80       	push   $0x80107c44
80105dd0:	e8 db a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105dd5:	83 c4 14             	add    $0x14,%esp
80105dd8:	68 f3 79 10 80       	push   $0x801079f3
80105ddd:	e8 9e a5 ff ff       	call   80100380 <panic>
80105de2:	66 90                	xchg   %ax,%ax
80105de4:	66 90                	xchg   %ax,%ax
80105de6:	66 90                	xchg   %ax,%ax
80105de8:	66 90                	xchg   %ax,%ax
80105dea:	66 90                	xchg   %ax,%ax
80105dec:	66 90                	xchg   %ax,%ax
80105dee:	66 90                	xchg   %ax,%ax

80105df0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105df0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105df5:	85 c0                	test   %eax,%eax
80105df7:	74 17                	je     80105e10 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105df9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105dfe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105dff:	a8 01                	test   $0x1,%al
80105e01:	74 0d                	je     80105e10 <uartgetc+0x20>
80105e03:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e08:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e09:	0f b6 c0             	movzbl %al,%eax
80105e0c:	c3                   	ret
80105e0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e15:	c3                   	ret
80105e16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e1d:	00 
80105e1e:	66 90                	xchg   %ax,%ax

80105e20 <uartinit>:
{
80105e20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e21:	31 c9                	xor    %ecx,%ecx
80105e23:	89 c8                	mov    %ecx,%eax
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	57                   	push   %edi
80105e28:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e2d:	56                   	push   %esi
80105e2e:	89 fa                	mov    %edi,%edx
80105e30:	53                   	push   %ebx
80105e31:	83 ec 1c             	sub    $0x1c,%esp
80105e34:	ee                   	out    %al,(%dx)
80105e35:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e3f:	89 f2                	mov    %esi,%edx
80105e41:	ee                   	out    %al,(%dx)
80105e42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e4c:	ee                   	out    %al,(%dx)
80105e4d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e52:	89 c8                	mov    %ecx,%eax
80105e54:	89 da                	mov    %ebx,%edx
80105e56:	ee                   	out    %al,(%dx)
80105e57:	b8 03 00 00 00       	mov    $0x3,%eax
80105e5c:	89 f2                	mov    %esi,%edx
80105e5e:	ee                   	out    %al,(%dx)
80105e5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e64:	89 c8                	mov    %ecx,%eax
80105e66:	ee                   	out    %al,(%dx)
80105e67:	b8 01 00 00 00       	mov    $0x1,%eax
80105e6c:	89 da                	mov    %ebx,%edx
80105e6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e74:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e75:	3c ff                	cmp    $0xff,%al
80105e77:	0f 84 7c 00 00 00    	je     80105ef9 <uartinit+0xd9>
  uart = 1;
80105e7d:	c7 05 c0 d4 14 80 01 	movl   $0x1,0x8014d4c0
80105e84:	00 00 00 
80105e87:	89 fa                	mov    %edi,%edx
80105e89:	ec                   	in     (%dx),%al
80105e8a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e8f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e90:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e93:	bf f8 79 10 80       	mov    $0x801079f8,%edi
80105e98:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105e9d:	6a 00                	push   $0x0
80105e9f:	6a 04                	push   $0x4
80105ea1:	e8 ba c5 ff ff       	call   80102460 <ioapicenable>
80105ea6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ea9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105eb0:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	74 32                	je     80105eeb <uartinit+0xcb>
80105eb9:	89 f2                	mov    %esi,%edx
80105ebb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ebc:	a8 20                	test   $0x20,%al
80105ebe:	75 21                	jne    80105ee1 <uartinit+0xc1>
80105ec0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ec5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	6a 0a                	push   $0xa
80105ecd:	e8 ae ca ff ff       	call   80102980 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ed2:	83 c4 10             	add    $0x10,%esp
80105ed5:	83 eb 01             	sub    $0x1,%ebx
80105ed8:	74 07                	je     80105ee1 <uartinit+0xc1>
80105eda:	89 f2                	mov    %esi,%edx
80105edc:	ec                   	in     (%dx),%al
80105edd:	a8 20                	test   $0x20,%al
80105edf:	74 e7                	je     80105ec8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ee1:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ee6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105eea:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105eeb:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105eef:	83 c7 01             	add    $0x1,%edi
80105ef2:	88 45 e7             	mov    %al,-0x19(%ebp)
80105ef5:	84 c0                	test   %al,%al
80105ef7:	75 b7                	jne    80105eb0 <uartinit+0x90>
}
80105ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105efc:	5b                   	pop    %ebx
80105efd:	5e                   	pop    %esi
80105efe:	5f                   	pop    %edi
80105eff:	5d                   	pop    %ebp
80105f00:	c3                   	ret
80105f01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f08:	00 
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f10 <uartputc>:
  if(!uart)
80105f10:	a1 c0 d4 14 80       	mov    0x8014d4c0,%eax
80105f15:	85 c0                	test   %eax,%eax
80105f17:	74 4f                	je     80105f68 <uartputc+0x58>
{
80105f19:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f1a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f1f:	89 e5                	mov    %esp,%ebp
80105f21:	56                   	push   %esi
80105f22:	53                   	push   %ebx
80105f23:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f24:	a8 20                	test   $0x20,%al
80105f26:	75 29                	jne    80105f51 <uartputc+0x41>
80105f28:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f38:	83 ec 0c             	sub    $0xc,%esp
80105f3b:	6a 0a                	push   $0xa
80105f3d:	e8 3e ca ff ff       	call   80102980 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f42:	83 c4 10             	add    $0x10,%esp
80105f45:	83 eb 01             	sub    $0x1,%ebx
80105f48:	74 07                	je     80105f51 <uartputc+0x41>
80105f4a:	89 f2                	mov    %esi,%edx
80105f4c:	ec                   	in     (%dx),%al
80105f4d:	a8 20                	test   $0x20,%al
80105f4f:	74 e7                	je     80105f38 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f51:	8b 45 08             	mov    0x8(%ebp),%eax
80105f54:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f59:	ee                   	out    %al,(%dx)
}
80105f5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f5d:	5b                   	pop    %ebx
80105f5e:	5e                   	pop    %esi
80105f5f:	5d                   	pop    %ebp
80105f60:	c3                   	ret
80105f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f68:	c3                   	ret
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f70 <uartintr>:

void
uartintr(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f76:	68 f0 5d 10 80       	push   $0x80105df0
80105f7b:	e8 20 a9 ff ff       	call   801008a0 <consoleintr>
}
80105f80:	83 c4 10             	add    $0x10,%esp
80105f83:	c9                   	leave
80105f84:	c3                   	ret

80105f85 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $0
80105f87:	6a 00                	push   $0x0
  jmp alltraps
80105f89:	e9 07 fb ff ff       	jmp    80105a95 <alltraps>

80105f8e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $1
80105f90:	6a 01                	push   $0x1
  jmp alltraps
80105f92:	e9 fe fa ff ff       	jmp    80105a95 <alltraps>

80105f97 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $2
80105f99:	6a 02                	push   $0x2
  jmp alltraps
80105f9b:	e9 f5 fa ff ff       	jmp    80105a95 <alltraps>

80105fa0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $3
80105fa2:	6a 03                	push   $0x3
  jmp alltraps
80105fa4:	e9 ec fa ff ff       	jmp    80105a95 <alltraps>

80105fa9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $4
80105fab:	6a 04                	push   $0x4
  jmp alltraps
80105fad:	e9 e3 fa ff ff       	jmp    80105a95 <alltraps>

80105fb2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $5
80105fb4:	6a 05                	push   $0x5
  jmp alltraps
80105fb6:	e9 da fa ff ff       	jmp    80105a95 <alltraps>

80105fbb <vector6>:
.globl vector6
vector6:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $6
80105fbd:	6a 06                	push   $0x6
  jmp alltraps
80105fbf:	e9 d1 fa ff ff       	jmp    80105a95 <alltraps>

80105fc4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $7
80105fc6:	6a 07                	push   $0x7
  jmp alltraps
80105fc8:	e9 c8 fa ff ff       	jmp    80105a95 <alltraps>

80105fcd <vector8>:
.globl vector8
vector8:
  pushl $8
80105fcd:	6a 08                	push   $0x8
  jmp alltraps
80105fcf:	e9 c1 fa ff ff       	jmp    80105a95 <alltraps>

80105fd4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $9
80105fd6:	6a 09                	push   $0x9
  jmp alltraps
80105fd8:	e9 b8 fa ff ff       	jmp    80105a95 <alltraps>

80105fdd <vector10>:
.globl vector10
vector10:
  pushl $10
80105fdd:	6a 0a                	push   $0xa
  jmp alltraps
80105fdf:	e9 b1 fa ff ff       	jmp    80105a95 <alltraps>

80105fe4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105fe4:	6a 0b                	push   $0xb
  jmp alltraps
80105fe6:	e9 aa fa ff ff       	jmp    80105a95 <alltraps>

80105feb <vector12>:
.globl vector12
vector12:
  pushl $12
80105feb:	6a 0c                	push   $0xc
  jmp alltraps
80105fed:	e9 a3 fa ff ff       	jmp    80105a95 <alltraps>

80105ff2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ff2:	6a 0d                	push   $0xd
  jmp alltraps
80105ff4:	e9 9c fa ff ff       	jmp    80105a95 <alltraps>

80105ff9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ff9:	6a 0e                	push   $0xe
  jmp alltraps
80105ffb:	e9 95 fa ff ff       	jmp    80105a95 <alltraps>

80106000 <vector15>:
.globl vector15
vector15:
  pushl $0
80106000:	6a 00                	push   $0x0
  pushl $15
80106002:	6a 0f                	push   $0xf
  jmp alltraps
80106004:	e9 8c fa ff ff       	jmp    80105a95 <alltraps>

80106009 <vector16>:
.globl vector16
vector16:
  pushl $0
80106009:	6a 00                	push   $0x0
  pushl $16
8010600b:	6a 10                	push   $0x10
  jmp alltraps
8010600d:	e9 83 fa ff ff       	jmp    80105a95 <alltraps>

80106012 <vector17>:
.globl vector17
vector17:
  pushl $17
80106012:	6a 11                	push   $0x11
  jmp alltraps
80106014:	e9 7c fa ff ff       	jmp    80105a95 <alltraps>

80106019 <vector18>:
.globl vector18
vector18:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $18
8010601b:	6a 12                	push   $0x12
  jmp alltraps
8010601d:	e9 73 fa ff ff       	jmp    80105a95 <alltraps>

80106022 <vector19>:
.globl vector19
vector19:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $19
80106024:	6a 13                	push   $0x13
  jmp alltraps
80106026:	e9 6a fa ff ff       	jmp    80105a95 <alltraps>

8010602b <vector20>:
.globl vector20
vector20:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $20
8010602d:	6a 14                	push   $0x14
  jmp alltraps
8010602f:	e9 61 fa ff ff       	jmp    80105a95 <alltraps>

80106034 <vector21>:
.globl vector21
vector21:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $21
80106036:	6a 15                	push   $0x15
  jmp alltraps
80106038:	e9 58 fa ff ff       	jmp    80105a95 <alltraps>

8010603d <vector22>:
.globl vector22
vector22:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $22
8010603f:	6a 16                	push   $0x16
  jmp alltraps
80106041:	e9 4f fa ff ff       	jmp    80105a95 <alltraps>

80106046 <vector23>:
.globl vector23
vector23:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $23
80106048:	6a 17                	push   $0x17
  jmp alltraps
8010604a:	e9 46 fa ff ff       	jmp    80105a95 <alltraps>

8010604f <vector24>:
.globl vector24
vector24:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $24
80106051:	6a 18                	push   $0x18
  jmp alltraps
80106053:	e9 3d fa ff ff       	jmp    80105a95 <alltraps>

80106058 <vector25>:
.globl vector25
vector25:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $25
8010605a:	6a 19                	push   $0x19
  jmp alltraps
8010605c:	e9 34 fa ff ff       	jmp    80105a95 <alltraps>

80106061 <vector26>:
.globl vector26
vector26:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $26
80106063:	6a 1a                	push   $0x1a
  jmp alltraps
80106065:	e9 2b fa ff ff       	jmp    80105a95 <alltraps>

8010606a <vector27>:
.globl vector27
vector27:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $27
8010606c:	6a 1b                	push   $0x1b
  jmp alltraps
8010606e:	e9 22 fa ff ff       	jmp    80105a95 <alltraps>

80106073 <vector28>:
.globl vector28
vector28:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $28
80106075:	6a 1c                	push   $0x1c
  jmp alltraps
80106077:	e9 19 fa ff ff       	jmp    80105a95 <alltraps>

8010607c <vector29>:
.globl vector29
vector29:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $29
8010607e:	6a 1d                	push   $0x1d
  jmp alltraps
80106080:	e9 10 fa ff ff       	jmp    80105a95 <alltraps>

80106085 <vector30>:
.globl vector30
vector30:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $30
80106087:	6a 1e                	push   $0x1e
  jmp alltraps
80106089:	e9 07 fa ff ff       	jmp    80105a95 <alltraps>

8010608e <vector31>:
.globl vector31
vector31:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $31
80106090:	6a 1f                	push   $0x1f
  jmp alltraps
80106092:	e9 fe f9 ff ff       	jmp    80105a95 <alltraps>

80106097 <vector32>:
.globl vector32
vector32:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $32
80106099:	6a 20                	push   $0x20
  jmp alltraps
8010609b:	e9 f5 f9 ff ff       	jmp    80105a95 <alltraps>

801060a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $33
801060a2:	6a 21                	push   $0x21
  jmp alltraps
801060a4:	e9 ec f9 ff ff       	jmp    80105a95 <alltraps>

801060a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $34
801060ab:	6a 22                	push   $0x22
  jmp alltraps
801060ad:	e9 e3 f9 ff ff       	jmp    80105a95 <alltraps>

801060b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $35
801060b4:	6a 23                	push   $0x23
  jmp alltraps
801060b6:	e9 da f9 ff ff       	jmp    80105a95 <alltraps>

801060bb <vector36>:
.globl vector36
vector36:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $36
801060bd:	6a 24                	push   $0x24
  jmp alltraps
801060bf:	e9 d1 f9 ff ff       	jmp    80105a95 <alltraps>

801060c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $37
801060c6:	6a 25                	push   $0x25
  jmp alltraps
801060c8:	e9 c8 f9 ff ff       	jmp    80105a95 <alltraps>

801060cd <vector38>:
.globl vector38
vector38:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $38
801060cf:	6a 26                	push   $0x26
  jmp alltraps
801060d1:	e9 bf f9 ff ff       	jmp    80105a95 <alltraps>

801060d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $39
801060d8:	6a 27                	push   $0x27
  jmp alltraps
801060da:	e9 b6 f9 ff ff       	jmp    80105a95 <alltraps>

801060df <vector40>:
.globl vector40
vector40:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $40
801060e1:	6a 28                	push   $0x28
  jmp alltraps
801060e3:	e9 ad f9 ff ff       	jmp    80105a95 <alltraps>

801060e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $41
801060ea:	6a 29                	push   $0x29
  jmp alltraps
801060ec:	e9 a4 f9 ff ff       	jmp    80105a95 <alltraps>

801060f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $42
801060f3:	6a 2a                	push   $0x2a
  jmp alltraps
801060f5:	e9 9b f9 ff ff       	jmp    80105a95 <alltraps>

801060fa <vector43>:
.globl vector43
vector43:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $43
801060fc:	6a 2b                	push   $0x2b
  jmp alltraps
801060fe:	e9 92 f9 ff ff       	jmp    80105a95 <alltraps>

80106103 <vector44>:
.globl vector44
vector44:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $44
80106105:	6a 2c                	push   $0x2c
  jmp alltraps
80106107:	e9 89 f9 ff ff       	jmp    80105a95 <alltraps>

8010610c <vector45>:
.globl vector45
vector45:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $45
8010610e:	6a 2d                	push   $0x2d
  jmp alltraps
80106110:	e9 80 f9 ff ff       	jmp    80105a95 <alltraps>

80106115 <vector46>:
.globl vector46
vector46:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $46
80106117:	6a 2e                	push   $0x2e
  jmp alltraps
80106119:	e9 77 f9 ff ff       	jmp    80105a95 <alltraps>

8010611e <vector47>:
.globl vector47
vector47:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $47
80106120:	6a 2f                	push   $0x2f
  jmp alltraps
80106122:	e9 6e f9 ff ff       	jmp    80105a95 <alltraps>

80106127 <vector48>:
.globl vector48
vector48:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $48
80106129:	6a 30                	push   $0x30
  jmp alltraps
8010612b:	e9 65 f9 ff ff       	jmp    80105a95 <alltraps>

80106130 <vector49>:
.globl vector49
vector49:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $49
80106132:	6a 31                	push   $0x31
  jmp alltraps
80106134:	e9 5c f9 ff ff       	jmp    80105a95 <alltraps>

80106139 <vector50>:
.globl vector50
vector50:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $50
8010613b:	6a 32                	push   $0x32
  jmp alltraps
8010613d:	e9 53 f9 ff ff       	jmp    80105a95 <alltraps>

80106142 <vector51>:
.globl vector51
vector51:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $51
80106144:	6a 33                	push   $0x33
  jmp alltraps
80106146:	e9 4a f9 ff ff       	jmp    80105a95 <alltraps>

8010614b <vector52>:
.globl vector52
vector52:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $52
8010614d:	6a 34                	push   $0x34
  jmp alltraps
8010614f:	e9 41 f9 ff ff       	jmp    80105a95 <alltraps>

80106154 <vector53>:
.globl vector53
vector53:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $53
80106156:	6a 35                	push   $0x35
  jmp alltraps
80106158:	e9 38 f9 ff ff       	jmp    80105a95 <alltraps>

8010615d <vector54>:
.globl vector54
vector54:
  pushl $0
8010615d:	6a 00                	push   $0x0
  pushl $54
8010615f:	6a 36                	push   $0x36
  jmp alltraps
80106161:	e9 2f f9 ff ff       	jmp    80105a95 <alltraps>

80106166 <vector55>:
.globl vector55
vector55:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $55
80106168:	6a 37                	push   $0x37
  jmp alltraps
8010616a:	e9 26 f9 ff ff       	jmp    80105a95 <alltraps>

8010616f <vector56>:
.globl vector56
vector56:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $56
80106171:	6a 38                	push   $0x38
  jmp alltraps
80106173:	e9 1d f9 ff ff       	jmp    80105a95 <alltraps>

80106178 <vector57>:
.globl vector57
vector57:
  pushl $0
80106178:	6a 00                	push   $0x0
  pushl $57
8010617a:	6a 39                	push   $0x39
  jmp alltraps
8010617c:	e9 14 f9 ff ff       	jmp    80105a95 <alltraps>

80106181 <vector58>:
.globl vector58
vector58:
  pushl $0
80106181:	6a 00                	push   $0x0
  pushl $58
80106183:	6a 3a                	push   $0x3a
  jmp alltraps
80106185:	e9 0b f9 ff ff       	jmp    80105a95 <alltraps>

8010618a <vector59>:
.globl vector59
vector59:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $59
8010618c:	6a 3b                	push   $0x3b
  jmp alltraps
8010618e:	e9 02 f9 ff ff       	jmp    80105a95 <alltraps>

80106193 <vector60>:
.globl vector60
vector60:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $60
80106195:	6a 3c                	push   $0x3c
  jmp alltraps
80106197:	e9 f9 f8 ff ff       	jmp    80105a95 <alltraps>

8010619c <vector61>:
.globl vector61
vector61:
  pushl $0
8010619c:	6a 00                	push   $0x0
  pushl $61
8010619e:	6a 3d                	push   $0x3d
  jmp alltraps
801061a0:	e9 f0 f8 ff ff       	jmp    80105a95 <alltraps>

801061a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061a5:	6a 00                	push   $0x0
  pushl $62
801061a7:	6a 3e                	push   $0x3e
  jmp alltraps
801061a9:	e9 e7 f8 ff ff       	jmp    80105a95 <alltraps>

801061ae <vector63>:
.globl vector63
vector63:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $63
801061b0:	6a 3f                	push   $0x3f
  jmp alltraps
801061b2:	e9 de f8 ff ff       	jmp    80105a95 <alltraps>

801061b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $64
801061b9:	6a 40                	push   $0x40
  jmp alltraps
801061bb:	e9 d5 f8 ff ff       	jmp    80105a95 <alltraps>

801061c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061c0:	6a 00                	push   $0x0
  pushl $65
801061c2:	6a 41                	push   $0x41
  jmp alltraps
801061c4:	e9 cc f8 ff ff       	jmp    80105a95 <alltraps>

801061c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061c9:	6a 00                	push   $0x0
  pushl $66
801061cb:	6a 42                	push   $0x42
  jmp alltraps
801061cd:	e9 c3 f8 ff ff       	jmp    80105a95 <alltraps>

801061d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $67
801061d4:	6a 43                	push   $0x43
  jmp alltraps
801061d6:	e9 ba f8 ff ff       	jmp    80105a95 <alltraps>

801061db <vector68>:
.globl vector68
vector68:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $68
801061dd:	6a 44                	push   $0x44
  jmp alltraps
801061df:	e9 b1 f8 ff ff       	jmp    80105a95 <alltraps>

801061e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801061e4:	6a 00                	push   $0x0
  pushl $69
801061e6:	6a 45                	push   $0x45
  jmp alltraps
801061e8:	e9 a8 f8 ff ff       	jmp    80105a95 <alltraps>

801061ed <vector70>:
.globl vector70
vector70:
  pushl $0
801061ed:	6a 00                	push   $0x0
  pushl $70
801061ef:	6a 46                	push   $0x46
  jmp alltraps
801061f1:	e9 9f f8 ff ff       	jmp    80105a95 <alltraps>

801061f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $71
801061f8:	6a 47                	push   $0x47
  jmp alltraps
801061fa:	e9 96 f8 ff ff       	jmp    80105a95 <alltraps>

801061ff <vector72>:
.globl vector72
vector72:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $72
80106201:	6a 48                	push   $0x48
  jmp alltraps
80106203:	e9 8d f8 ff ff       	jmp    80105a95 <alltraps>

80106208 <vector73>:
.globl vector73
vector73:
  pushl $0
80106208:	6a 00                	push   $0x0
  pushl $73
8010620a:	6a 49                	push   $0x49
  jmp alltraps
8010620c:	e9 84 f8 ff ff       	jmp    80105a95 <alltraps>

80106211 <vector74>:
.globl vector74
vector74:
  pushl $0
80106211:	6a 00                	push   $0x0
  pushl $74
80106213:	6a 4a                	push   $0x4a
  jmp alltraps
80106215:	e9 7b f8 ff ff       	jmp    80105a95 <alltraps>

8010621a <vector75>:
.globl vector75
vector75:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $75
8010621c:	6a 4b                	push   $0x4b
  jmp alltraps
8010621e:	e9 72 f8 ff ff       	jmp    80105a95 <alltraps>

80106223 <vector76>:
.globl vector76
vector76:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $76
80106225:	6a 4c                	push   $0x4c
  jmp alltraps
80106227:	e9 69 f8 ff ff       	jmp    80105a95 <alltraps>

8010622c <vector77>:
.globl vector77
vector77:
  pushl $0
8010622c:	6a 00                	push   $0x0
  pushl $77
8010622e:	6a 4d                	push   $0x4d
  jmp alltraps
80106230:	e9 60 f8 ff ff       	jmp    80105a95 <alltraps>

80106235 <vector78>:
.globl vector78
vector78:
  pushl $0
80106235:	6a 00                	push   $0x0
  pushl $78
80106237:	6a 4e                	push   $0x4e
  jmp alltraps
80106239:	e9 57 f8 ff ff       	jmp    80105a95 <alltraps>

8010623e <vector79>:
.globl vector79
vector79:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $79
80106240:	6a 4f                	push   $0x4f
  jmp alltraps
80106242:	e9 4e f8 ff ff       	jmp    80105a95 <alltraps>

80106247 <vector80>:
.globl vector80
vector80:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $80
80106249:	6a 50                	push   $0x50
  jmp alltraps
8010624b:	e9 45 f8 ff ff       	jmp    80105a95 <alltraps>

80106250 <vector81>:
.globl vector81
vector81:
  pushl $0
80106250:	6a 00                	push   $0x0
  pushl $81
80106252:	6a 51                	push   $0x51
  jmp alltraps
80106254:	e9 3c f8 ff ff       	jmp    80105a95 <alltraps>

80106259 <vector82>:
.globl vector82
vector82:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $82
8010625b:	6a 52                	push   $0x52
  jmp alltraps
8010625d:	e9 33 f8 ff ff       	jmp    80105a95 <alltraps>

80106262 <vector83>:
.globl vector83
vector83:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $83
80106264:	6a 53                	push   $0x53
  jmp alltraps
80106266:	e9 2a f8 ff ff       	jmp    80105a95 <alltraps>

8010626b <vector84>:
.globl vector84
vector84:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $84
8010626d:	6a 54                	push   $0x54
  jmp alltraps
8010626f:	e9 21 f8 ff ff       	jmp    80105a95 <alltraps>

80106274 <vector85>:
.globl vector85
vector85:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $85
80106276:	6a 55                	push   $0x55
  jmp alltraps
80106278:	e9 18 f8 ff ff       	jmp    80105a95 <alltraps>

8010627d <vector86>:
.globl vector86
vector86:
  pushl $0
8010627d:	6a 00                	push   $0x0
  pushl $86
8010627f:	6a 56                	push   $0x56
  jmp alltraps
80106281:	e9 0f f8 ff ff       	jmp    80105a95 <alltraps>

80106286 <vector87>:
.globl vector87
vector87:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $87
80106288:	6a 57                	push   $0x57
  jmp alltraps
8010628a:	e9 06 f8 ff ff       	jmp    80105a95 <alltraps>

8010628f <vector88>:
.globl vector88
vector88:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $88
80106291:	6a 58                	push   $0x58
  jmp alltraps
80106293:	e9 fd f7 ff ff       	jmp    80105a95 <alltraps>

80106298 <vector89>:
.globl vector89
vector89:
  pushl $0
80106298:	6a 00                	push   $0x0
  pushl $89
8010629a:	6a 59                	push   $0x59
  jmp alltraps
8010629c:	e9 f4 f7 ff ff       	jmp    80105a95 <alltraps>

801062a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062a1:	6a 00                	push   $0x0
  pushl $90
801062a3:	6a 5a                	push   $0x5a
  jmp alltraps
801062a5:	e9 eb f7 ff ff       	jmp    80105a95 <alltraps>

801062aa <vector91>:
.globl vector91
vector91:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $91
801062ac:	6a 5b                	push   $0x5b
  jmp alltraps
801062ae:	e9 e2 f7 ff ff       	jmp    80105a95 <alltraps>

801062b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $92
801062b5:	6a 5c                	push   $0x5c
  jmp alltraps
801062b7:	e9 d9 f7 ff ff       	jmp    80105a95 <alltraps>

801062bc <vector93>:
.globl vector93
vector93:
  pushl $0
801062bc:	6a 00                	push   $0x0
  pushl $93
801062be:	6a 5d                	push   $0x5d
  jmp alltraps
801062c0:	e9 d0 f7 ff ff       	jmp    80105a95 <alltraps>

801062c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062c5:	6a 00                	push   $0x0
  pushl $94
801062c7:	6a 5e                	push   $0x5e
  jmp alltraps
801062c9:	e9 c7 f7 ff ff       	jmp    80105a95 <alltraps>

801062ce <vector95>:
.globl vector95
vector95:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $95
801062d0:	6a 5f                	push   $0x5f
  jmp alltraps
801062d2:	e9 be f7 ff ff       	jmp    80105a95 <alltraps>

801062d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $96
801062d9:	6a 60                	push   $0x60
  jmp alltraps
801062db:	e9 b5 f7 ff ff       	jmp    80105a95 <alltraps>

801062e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $97
801062e2:	6a 61                	push   $0x61
  jmp alltraps
801062e4:	e9 ac f7 ff ff       	jmp    80105a95 <alltraps>

801062e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $98
801062eb:	6a 62                	push   $0x62
  jmp alltraps
801062ed:	e9 a3 f7 ff ff       	jmp    80105a95 <alltraps>

801062f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $99
801062f4:	6a 63                	push   $0x63
  jmp alltraps
801062f6:	e9 9a f7 ff ff       	jmp    80105a95 <alltraps>

801062fb <vector100>:
.globl vector100
vector100:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $100
801062fd:	6a 64                	push   $0x64
  jmp alltraps
801062ff:	e9 91 f7 ff ff       	jmp    80105a95 <alltraps>

80106304 <vector101>:
.globl vector101
vector101:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $101
80106306:	6a 65                	push   $0x65
  jmp alltraps
80106308:	e9 88 f7 ff ff       	jmp    80105a95 <alltraps>

8010630d <vector102>:
.globl vector102
vector102:
  pushl $0
8010630d:	6a 00                	push   $0x0
  pushl $102
8010630f:	6a 66                	push   $0x66
  jmp alltraps
80106311:	e9 7f f7 ff ff       	jmp    80105a95 <alltraps>

80106316 <vector103>:
.globl vector103
vector103:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $103
80106318:	6a 67                	push   $0x67
  jmp alltraps
8010631a:	e9 76 f7 ff ff       	jmp    80105a95 <alltraps>

8010631f <vector104>:
.globl vector104
vector104:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $104
80106321:	6a 68                	push   $0x68
  jmp alltraps
80106323:	e9 6d f7 ff ff       	jmp    80105a95 <alltraps>

80106328 <vector105>:
.globl vector105
vector105:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $105
8010632a:	6a 69                	push   $0x69
  jmp alltraps
8010632c:	e9 64 f7 ff ff       	jmp    80105a95 <alltraps>

80106331 <vector106>:
.globl vector106
vector106:
  pushl $0
80106331:	6a 00                	push   $0x0
  pushl $106
80106333:	6a 6a                	push   $0x6a
  jmp alltraps
80106335:	e9 5b f7 ff ff       	jmp    80105a95 <alltraps>

8010633a <vector107>:
.globl vector107
vector107:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $107
8010633c:	6a 6b                	push   $0x6b
  jmp alltraps
8010633e:	e9 52 f7 ff ff       	jmp    80105a95 <alltraps>

80106343 <vector108>:
.globl vector108
vector108:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $108
80106345:	6a 6c                	push   $0x6c
  jmp alltraps
80106347:	e9 49 f7 ff ff       	jmp    80105a95 <alltraps>

8010634c <vector109>:
.globl vector109
vector109:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $109
8010634e:	6a 6d                	push   $0x6d
  jmp alltraps
80106350:	e9 40 f7 ff ff       	jmp    80105a95 <alltraps>

80106355 <vector110>:
.globl vector110
vector110:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $110
80106357:	6a 6e                	push   $0x6e
  jmp alltraps
80106359:	e9 37 f7 ff ff       	jmp    80105a95 <alltraps>

8010635e <vector111>:
.globl vector111
vector111:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $111
80106360:	6a 6f                	push   $0x6f
  jmp alltraps
80106362:	e9 2e f7 ff ff       	jmp    80105a95 <alltraps>

80106367 <vector112>:
.globl vector112
vector112:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $112
80106369:	6a 70                	push   $0x70
  jmp alltraps
8010636b:	e9 25 f7 ff ff       	jmp    80105a95 <alltraps>

80106370 <vector113>:
.globl vector113
vector113:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $113
80106372:	6a 71                	push   $0x71
  jmp alltraps
80106374:	e9 1c f7 ff ff       	jmp    80105a95 <alltraps>

80106379 <vector114>:
.globl vector114
vector114:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $114
8010637b:	6a 72                	push   $0x72
  jmp alltraps
8010637d:	e9 13 f7 ff ff       	jmp    80105a95 <alltraps>

80106382 <vector115>:
.globl vector115
vector115:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $115
80106384:	6a 73                	push   $0x73
  jmp alltraps
80106386:	e9 0a f7 ff ff       	jmp    80105a95 <alltraps>

8010638b <vector116>:
.globl vector116
vector116:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $116
8010638d:	6a 74                	push   $0x74
  jmp alltraps
8010638f:	e9 01 f7 ff ff       	jmp    80105a95 <alltraps>

80106394 <vector117>:
.globl vector117
vector117:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $117
80106396:	6a 75                	push   $0x75
  jmp alltraps
80106398:	e9 f8 f6 ff ff       	jmp    80105a95 <alltraps>

8010639d <vector118>:
.globl vector118
vector118:
  pushl $0
8010639d:	6a 00                	push   $0x0
  pushl $118
8010639f:	6a 76                	push   $0x76
  jmp alltraps
801063a1:	e9 ef f6 ff ff       	jmp    80105a95 <alltraps>

801063a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $119
801063a8:	6a 77                	push   $0x77
  jmp alltraps
801063aa:	e9 e6 f6 ff ff       	jmp    80105a95 <alltraps>

801063af <vector120>:
.globl vector120
vector120:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $120
801063b1:	6a 78                	push   $0x78
  jmp alltraps
801063b3:	e9 dd f6 ff ff       	jmp    80105a95 <alltraps>

801063b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $121
801063ba:	6a 79                	push   $0x79
  jmp alltraps
801063bc:	e9 d4 f6 ff ff       	jmp    80105a95 <alltraps>

801063c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063c1:	6a 00                	push   $0x0
  pushl $122
801063c3:	6a 7a                	push   $0x7a
  jmp alltraps
801063c5:	e9 cb f6 ff ff       	jmp    80105a95 <alltraps>

801063ca <vector123>:
.globl vector123
vector123:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $123
801063cc:	6a 7b                	push   $0x7b
  jmp alltraps
801063ce:	e9 c2 f6 ff ff       	jmp    80105a95 <alltraps>

801063d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $124
801063d5:	6a 7c                	push   $0x7c
  jmp alltraps
801063d7:	e9 b9 f6 ff ff       	jmp    80105a95 <alltraps>

801063dc <vector125>:
.globl vector125
vector125:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $125
801063de:	6a 7d                	push   $0x7d
  jmp alltraps
801063e0:	e9 b0 f6 ff ff       	jmp    80105a95 <alltraps>

801063e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $126
801063e7:	6a 7e                	push   $0x7e
  jmp alltraps
801063e9:	e9 a7 f6 ff ff       	jmp    80105a95 <alltraps>

801063ee <vector127>:
.globl vector127
vector127:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $127
801063f0:	6a 7f                	push   $0x7f
  jmp alltraps
801063f2:	e9 9e f6 ff ff       	jmp    80105a95 <alltraps>

801063f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $128
801063f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063fe:	e9 92 f6 ff ff       	jmp    80105a95 <alltraps>

80106403 <vector129>:
.globl vector129
vector129:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $129
80106405:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010640a:	e9 86 f6 ff ff       	jmp    80105a95 <alltraps>

8010640f <vector130>:
.globl vector130
vector130:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $130
80106411:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106416:	e9 7a f6 ff ff       	jmp    80105a95 <alltraps>

8010641b <vector131>:
.globl vector131
vector131:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $131
8010641d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106422:	e9 6e f6 ff ff       	jmp    80105a95 <alltraps>

80106427 <vector132>:
.globl vector132
vector132:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $132
80106429:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010642e:	e9 62 f6 ff ff       	jmp    80105a95 <alltraps>

80106433 <vector133>:
.globl vector133
vector133:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $133
80106435:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010643a:	e9 56 f6 ff ff       	jmp    80105a95 <alltraps>

8010643f <vector134>:
.globl vector134
vector134:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $134
80106441:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106446:	e9 4a f6 ff ff       	jmp    80105a95 <alltraps>

8010644b <vector135>:
.globl vector135
vector135:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $135
8010644d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106452:	e9 3e f6 ff ff       	jmp    80105a95 <alltraps>

80106457 <vector136>:
.globl vector136
vector136:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $136
80106459:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010645e:	e9 32 f6 ff ff       	jmp    80105a95 <alltraps>

80106463 <vector137>:
.globl vector137
vector137:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $137
80106465:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010646a:	e9 26 f6 ff ff       	jmp    80105a95 <alltraps>

8010646f <vector138>:
.globl vector138
vector138:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $138
80106471:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106476:	e9 1a f6 ff ff       	jmp    80105a95 <alltraps>

8010647b <vector139>:
.globl vector139
vector139:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $139
8010647d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106482:	e9 0e f6 ff ff       	jmp    80105a95 <alltraps>

80106487 <vector140>:
.globl vector140
vector140:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $140
80106489:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010648e:	e9 02 f6 ff ff       	jmp    80105a95 <alltraps>

80106493 <vector141>:
.globl vector141
vector141:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $141
80106495:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010649a:	e9 f6 f5 ff ff       	jmp    80105a95 <alltraps>

8010649f <vector142>:
.globl vector142
vector142:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $142
801064a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064a6:	e9 ea f5 ff ff       	jmp    80105a95 <alltraps>

801064ab <vector143>:
.globl vector143
vector143:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $143
801064ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064b2:	e9 de f5 ff ff       	jmp    80105a95 <alltraps>

801064b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $144
801064b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064be:	e9 d2 f5 ff ff       	jmp    80105a95 <alltraps>

801064c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $145
801064c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064ca:	e9 c6 f5 ff ff       	jmp    80105a95 <alltraps>

801064cf <vector146>:
.globl vector146
vector146:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $146
801064d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064d6:	e9 ba f5 ff ff       	jmp    80105a95 <alltraps>

801064db <vector147>:
.globl vector147
vector147:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $147
801064dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064e2:	e9 ae f5 ff ff       	jmp    80105a95 <alltraps>

801064e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $148
801064e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064ee:	e9 a2 f5 ff ff       	jmp    80105a95 <alltraps>

801064f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $149
801064f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064fa:	e9 96 f5 ff ff       	jmp    80105a95 <alltraps>

801064ff <vector150>:
.globl vector150
vector150:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $150
80106501:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106506:	e9 8a f5 ff ff       	jmp    80105a95 <alltraps>

8010650b <vector151>:
.globl vector151
vector151:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $151
8010650d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106512:	e9 7e f5 ff ff       	jmp    80105a95 <alltraps>

80106517 <vector152>:
.globl vector152
vector152:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $152
80106519:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010651e:	e9 72 f5 ff ff       	jmp    80105a95 <alltraps>

80106523 <vector153>:
.globl vector153
vector153:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $153
80106525:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010652a:	e9 66 f5 ff ff       	jmp    80105a95 <alltraps>

8010652f <vector154>:
.globl vector154
vector154:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $154
80106531:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106536:	e9 5a f5 ff ff       	jmp    80105a95 <alltraps>

8010653b <vector155>:
.globl vector155
vector155:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $155
8010653d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106542:	e9 4e f5 ff ff       	jmp    80105a95 <alltraps>

80106547 <vector156>:
.globl vector156
vector156:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $156
80106549:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010654e:	e9 42 f5 ff ff       	jmp    80105a95 <alltraps>

80106553 <vector157>:
.globl vector157
vector157:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $157
80106555:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010655a:	e9 36 f5 ff ff       	jmp    80105a95 <alltraps>

8010655f <vector158>:
.globl vector158
vector158:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $158
80106561:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106566:	e9 2a f5 ff ff       	jmp    80105a95 <alltraps>

8010656b <vector159>:
.globl vector159
vector159:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $159
8010656d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106572:	e9 1e f5 ff ff       	jmp    80105a95 <alltraps>

80106577 <vector160>:
.globl vector160
vector160:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $160
80106579:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010657e:	e9 12 f5 ff ff       	jmp    80105a95 <alltraps>

80106583 <vector161>:
.globl vector161
vector161:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $161
80106585:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010658a:	e9 06 f5 ff ff       	jmp    80105a95 <alltraps>

8010658f <vector162>:
.globl vector162
vector162:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $162
80106591:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106596:	e9 fa f4 ff ff       	jmp    80105a95 <alltraps>

8010659b <vector163>:
.globl vector163
vector163:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $163
8010659d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065a2:	e9 ee f4 ff ff       	jmp    80105a95 <alltraps>

801065a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $164
801065a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065ae:	e9 e2 f4 ff ff       	jmp    80105a95 <alltraps>

801065b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $165
801065b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065ba:	e9 d6 f4 ff ff       	jmp    80105a95 <alltraps>

801065bf <vector166>:
.globl vector166
vector166:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $166
801065c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065c6:	e9 ca f4 ff ff       	jmp    80105a95 <alltraps>

801065cb <vector167>:
.globl vector167
vector167:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $167
801065cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065d2:	e9 be f4 ff ff       	jmp    80105a95 <alltraps>

801065d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $168
801065d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065de:	e9 b2 f4 ff ff       	jmp    80105a95 <alltraps>

801065e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $169
801065e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065ea:	e9 a6 f4 ff ff       	jmp    80105a95 <alltraps>

801065ef <vector170>:
.globl vector170
vector170:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $170
801065f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065f6:	e9 9a f4 ff ff       	jmp    80105a95 <alltraps>

801065fb <vector171>:
.globl vector171
vector171:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $171
801065fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106602:	e9 8e f4 ff ff       	jmp    80105a95 <alltraps>

80106607 <vector172>:
.globl vector172
vector172:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $172
80106609:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010660e:	e9 82 f4 ff ff       	jmp    80105a95 <alltraps>

80106613 <vector173>:
.globl vector173
vector173:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $173
80106615:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010661a:	e9 76 f4 ff ff       	jmp    80105a95 <alltraps>

8010661f <vector174>:
.globl vector174
vector174:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $174
80106621:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106626:	e9 6a f4 ff ff       	jmp    80105a95 <alltraps>

8010662b <vector175>:
.globl vector175
vector175:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $175
8010662d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106632:	e9 5e f4 ff ff       	jmp    80105a95 <alltraps>

80106637 <vector176>:
.globl vector176
vector176:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $176
80106639:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010663e:	e9 52 f4 ff ff       	jmp    80105a95 <alltraps>

80106643 <vector177>:
.globl vector177
vector177:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $177
80106645:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010664a:	e9 46 f4 ff ff       	jmp    80105a95 <alltraps>

8010664f <vector178>:
.globl vector178
vector178:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $178
80106651:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106656:	e9 3a f4 ff ff       	jmp    80105a95 <alltraps>

8010665b <vector179>:
.globl vector179
vector179:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $179
8010665d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106662:	e9 2e f4 ff ff       	jmp    80105a95 <alltraps>

80106667 <vector180>:
.globl vector180
vector180:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $180
80106669:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010666e:	e9 22 f4 ff ff       	jmp    80105a95 <alltraps>

80106673 <vector181>:
.globl vector181
vector181:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $181
80106675:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010667a:	e9 16 f4 ff ff       	jmp    80105a95 <alltraps>

8010667f <vector182>:
.globl vector182
vector182:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $182
80106681:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106686:	e9 0a f4 ff ff       	jmp    80105a95 <alltraps>

8010668b <vector183>:
.globl vector183
vector183:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $183
8010668d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106692:	e9 fe f3 ff ff       	jmp    80105a95 <alltraps>

80106697 <vector184>:
.globl vector184
vector184:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $184
80106699:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010669e:	e9 f2 f3 ff ff       	jmp    80105a95 <alltraps>

801066a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $185
801066a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066aa:	e9 e6 f3 ff ff       	jmp    80105a95 <alltraps>

801066af <vector186>:
.globl vector186
vector186:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $186
801066b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066b6:	e9 da f3 ff ff       	jmp    80105a95 <alltraps>

801066bb <vector187>:
.globl vector187
vector187:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $187
801066bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066c2:	e9 ce f3 ff ff       	jmp    80105a95 <alltraps>

801066c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $188
801066c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066ce:	e9 c2 f3 ff ff       	jmp    80105a95 <alltraps>

801066d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $189
801066d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066da:	e9 b6 f3 ff ff       	jmp    80105a95 <alltraps>

801066df <vector190>:
.globl vector190
vector190:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $190
801066e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066e6:	e9 aa f3 ff ff       	jmp    80105a95 <alltraps>

801066eb <vector191>:
.globl vector191
vector191:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $191
801066ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066f2:	e9 9e f3 ff ff       	jmp    80105a95 <alltraps>

801066f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $192
801066f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066fe:	e9 92 f3 ff ff       	jmp    80105a95 <alltraps>

80106703 <vector193>:
.globl vector193
vector193:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $193
80106705:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010670a:	e9 86 f3 ff ff       	jmp    80105a95 <alltraps>

8010670f <vector194>:
.globl vector194
vector194:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $194
80106711:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106716:	e9 7a f3 ff ff       	jmp    80105a95 <alltraps>

8010671b <vector195>:
.globl vector195
vector195:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $195
8010671d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106722:	e9 6e f3 ff ff       	jmp    80105a95 <alltraps>

80106727 <vector196>:
.globl vector196
vector196:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $196
80106729:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010672e:	e9 62 f3 ff ff       	jmp    80105a95 <alltraps>

80106733 <vector197>:
.globl vector197
vector197:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $197
80106735:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010673a:	e9 56 f3 ff ff       	jmp    80105a95 <alltraps>

8010673f <vector198>:
.globl vector198
vector198:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $198
80106741:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106746:	e9 4a f3 ff ff       	jmp    80105a95 <alltraps>

8010674b <vector199>:
.globl vector199
vector199:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $199
8010674d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106752:	e9 3e f3 ff ff       	jmp    80105a95 <alltraps>

80106757 <vector200>:
.globl vector200
vector200:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $200
80106759:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010675e:	e9 32 f3 ff ff       	jmp    80105a95 <alltraps>

80106763 <vector201>:
.globl vector201
vector201:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $201
80106765:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010676a:	e9 26 f3 ff ff       	jmp    80105a95 <alltraps>

8010676f <vector202>:
.globl vector202
vector202:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $202
80106771:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106776:	e9 1a f3 ff ff       	jmp    80105a95 <alltraps>

8010677b <vector203>:
.globl vector203
vector203:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $203
8010677d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106782:	e9 0e f3 ff ff       	jmp    80105a95 <alltraps>

80106787 <vector204>:
.globl vector204
vector204:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $204
80106789:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010678e:	e9 02 f3 ff ff       	jmp    80105a95 <alltraps>

80106793 <vector205>:
.globl vector205
vector205:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $205
80106795:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010679a:	e9 f6 f2 ff ff       	jmp    80105a95 <alltraps>

8010679f <vector206>:
.globl vector206
vector206:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $206
801067a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067a6:	e9 ea f2 ff ff       	jmp    80105a95 <alltraps>

801067ab <vector207>:
.globl vector207
vector207:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $207
801067ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067b2:	e9 de f2 ff ff       	jmp    80105a95 <alltraps>

801067b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $208
801067b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067be:	e9 d2 f2 ff ff       	jmp    80105a95 <alltraps>

801067c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $209
801067c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067ca:	e9 c6 f2 ff ff       	jmp    80105a95 <alltraps>

801067cf <vector210>:
.globl vector210
vector210:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $210
801067d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067d6:	e9 ba f2 ff ff       	jmp    80105a95 <alltraps>

801067db <vector211>:
.globl vector211
vector211:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $211
801067dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067e2:	e9 ae f2 ff ff       	jmp    80105a95 <alltraps>

801067e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $212
801067e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067ee:	e9 a2 f2 ff ff       	jmp    80105a95 <alltraps>

801067f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $213
801067f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067fa:	e9 96 f2 ff ff       	jmp    80105a95 <alltraps>

801067ff <vector214>:
.globl vector214
vector214:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $214
80106801:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106806:	e9 8a f2 ff ff       	jmp    80105a95 <alltraps>

8010680b <vector215>:
.globl vector215
vector215:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $215
8010680d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106812:	e9 7e f2 ff ff       	jmp    80105a95 <alltraps>

80106817 <vector216>:
.globl vector216
vector216:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $216
80106819:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010681e:	e9 72 f2 ff ff       	jmp    80105a95 <alltraps>

80106823 <vector217>:
.globl vector217
vector217:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $217
80106825:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010682a:	e9 66 f2 ff ff       	jmp    80105a95 <alltraps>

8010682f <vector218>:
.globl vector218
vector218:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $218
80106831:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106836:	e9 5a f2 ff ff       	jmp    80105a95 <alltraps>

8010683b <vector219>:
.globl vector219
vector219:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $219
8010683d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106842:	e9 4e f2 ff ff       	jmp    80105a95 <alltraps>

80106847 <vector220>:
.globl vector220
vector220:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $220
80106849:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010684e:	e9 42 f2 ff ff       	jmp    80105a95 <alltraps>

80106853 <vector221>:
.globl vector221
vector221:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $221
80106855:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010685a:	e9 36 f2 ff ff       	jmp    80105a95 <alltraps>

8010685f <vector222>:
.globl vector222
vector222:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $222
80106861:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106866:	e9 2a f2 ff ff       	jmp    80105a95 <alltraps>

8010686b <vector223>:
.globl vector223
vector223:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $223
8010686d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106872:	e9 1e f2 ff ff       	jmp    80105a95 <alltraps>

80106877 <vector224>:
.globl vector224
vector224:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $224
80106879:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010687e:	e9 12 f2 ff ff       	jmp    80105a95 <alltraps>

80106883 <vector225>:
.globl vector225
vector225:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $225
80106885:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010688a:	e9 06 f2 ff ff       	jmp    80105a95 <alltraps>

8010688f <vector226>:
.globl vector226
vector226:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $226
80106891:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106896:	e9 fa f1 ff ff       	jmp    80105a95 <alltraps>

8010689b <vector227>:
.globl vector227
vector227:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $227
8010689d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068a2:	e9 ee f1 ff ff       	jmp    80105a95 <alltraps>

801068a7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $228
801068a9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068ae:	e9 e2 f1 ff ff       	jmp    80105a95 <alltraps>

801068b3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $229
801068b5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068ba:	e9 d6 f1 ff ff       	jmp    80105a95 <alltraps>

801068bf <vector230>:
.globl vector230
vector230:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $230
801068c1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068c6:	e9 ca f1 ff ff       	jmp    80105a95 <alltraps>

801068cb <vector231>:
.globl vector231
vector231:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $231
801068cd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068d2:	e9 be f1 ff ff       	jmp    80105a95 <alltraps>

801068d7 <vector232>:
.globl vector232
vector232:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $232
801068d9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068de:	e9 b2 f1 ff ff       	jmp    80105a95 <alltraps>

801068e3 <vector233>:
.globl vector233
vector233:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $233
801068e5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068ea:	e9 a6 f1 ff ff       	jmp    80105a95 <alltraps>

801068ef <vector234>:
.globl vector234
vector234:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $234
801068f1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068f6:	e9 9a f1 ff ff       	jmp    80105a95 <alltraps>

801068fb <vector235>:
.globl vector235
vector235:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $235
801068fd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106902:	e9 8e f1 ff ff       	jmp    80105a95 <alltraps>

80106907 <vector236>:
.globl vector236
vector236:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $236
80106909:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010690e:	e9 82 f1 ff ff       	jmp    80105a95 <alltraps>

80106913 <vector237>:
.globl vector237
vector237:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $237
80106915:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010691a:	e9 76 f1 ff ff       	jmp    80105a95 <alltraps>

8010691f <vector238>:
.globl vector238
vector238:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $238
80106921:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106926:	e9 6a f1 ff ff       	jmp    80105a95 <alltraps>

8010692b <vector239>:
.globl vector239
vector239:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $239
8010692d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106932:	e9 5e f1 ff ff       	jmp    80105a95 <alltraps>

80106937 <vector240>:
.globl vector240
vector240:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $240
80106939:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010693e:	e9 52 f1 ff ff       	jmp    80105a95 <alltraps>

80106943 <vector241>:
.globl vector241
vector241:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $241
80106945:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010694a:	e9 46 f1 ff ff       	jmp    80105a95 <alltraps>

8010694f <vector242>:
.globl vector242
vector242:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $242
80106951:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106956:	e9 3a f1 ff ff       	jmp    80105a95 <alltraps>

8010695b <vector243>:
.globl vector243
vector243:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $243
8010695d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106962:	e9 2e f1 ff ff       	jmp    80105a95 <alltraps>

80106967 <vector244>:
.globl vector244
vector244:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $244
80106969:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010696e:	e9 22 f1 ff ff       	jmp    80105a95 <alltraps>

80106973 <vector245>:
.globl vector245
vector245:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $245
80106975:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010697a:	e9 16 f1 ff ff       	jmp    80105a95 <alltraps>

8010697f <vector246>:
.globl vector246
vector246:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $246
80106981:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106986:	e9 0a f1 ff ff       	jmp    80105a95 <alltraps>

8010698b <vector247>:
.globl vector247
vector247:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $247
8010698d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106992:	e9 fe f0 ff ff       	jmp    80105a95 <alltraps>

80106997 <vector248>:
.globl vector248
vector248:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $248
80106999:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010699e:	e9 f2 f0 ff ff       	jmp    80105a95 <alltraps>

801069a3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $249
801069a5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069aa:	e9 e6 f0 ff ff       	jmp    80105a95 <alltraps>

801069af <vector250>:
.globl vector250
vector250:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $250
801069b1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069b6:	e9 da f0 ff ff       	jmp    80105a95 <alltraps>

801069bb <vector251>:
.globl vector251
vector251:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $251
801069bd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069c2:	e9 ce f0 ff ff       	jmp    80105a95 <alltraps>

801069c7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $252
801069c9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069ce:	e9 c2 f0 ff ff       	jmp    80105a95 <alltraps>

801069d3 <vector253>:
.globl vector253
vector253:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $253
801069d5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069da:	e9 b6 f0 ff ff       	jmp    80105a95 <alltraps>

801069df <vector254>:
.globl vector254
vector254:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $254
801069e1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069e6:	e9 aa f0 ff ff       	jmp    80105a95 <alltraps>

801069eb <vector255>:
.globl vector255
vector255:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $255
801069ed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069f2:	e9 9e f0 ff ff       	jmp    80105a95 <alltraps>
801069f7:	66 90                	xchg   %ax,%ax
801069f9:	66 90                	xchg   %ax,%ax
801069fb:	66 90                	xchg   %ax,%ax
801069fd:	66 90                	xchg   %ax,%ax
801069ff:	90                   	nop

80106a00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	57                   	push   %edi
80106a04:	56                   	push   %esi
80106a05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a0c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a12:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106a15:	39 d3                	cmp    %edx,%ebx
80106a17:	73 56                	jae    80106a6f <deallocuvm.part.0+0x6f>
80106a19:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106a1c:	89 c6                	mov    %eax,%esi
80106a1e:	89 d7                	mov    %edx,%edi
80106a20:	eb 12                	jmp    80106a34 <deallocuvm.part.0+0x34>
80106a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a28:	83 c2 01             	add    $0x1,%edx
80106a2b:	89 d3                	mov    %edx,%ebx
80106a2d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a30:	39 fb                	cmp    %edi,%ebx
80106a32:	73 38                	jae    80106a6c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106a34:	89 da                	mov    %ebx,%edx
80106a36:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106a39:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106a3c:	a8 01                	test   $0x1,%al
80106a3e:	74 e8                	je     80106a28 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106a40:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a47:	c1 e9 0a             	shr    $0xa,%ecx
80106a4a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106a50:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106a57:	85 c0                	test   %eax,%eax
80106a59:	74 cd                	je     80106a28 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106a5b:	8b 10                	mov    (%eax),%edx
80106a5d:	f6 c2 01             	test   $0x1,%dl
80106a60:	75 1e                	jne    80106a80 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106a62:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a68:	39 fb                	cmp    %edi,%ebx
80106a6a:	72 c8                	jb     80106a34 <deallocuvm.part.0+0x34>
80106a6c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a72:	89 c8                	mov    %ecx,%eax
80106a74:	5b                   	pop    %ebx
80106a75:	5e                   	pop    %esi
80106a76:	5f                   	pop    %edi
80106a77:	5d                   	pop    %ebp
80106a78:	c3                   	ret
80106a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106a80:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a86:	74 26                	je     80106aae <deallocuvm.part.0+0xae>
      kfree(v);
80106a88:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a8b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a94:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a9a:	52                   	push   %edx
80106a9b:	e8 00 ba ff ff       	call   801024a0 <kfree>
      *pte = 0;
80106aa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106aa3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106aa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106aac:	eb 82                	jmp    80106a30 <deallocuvm.part.0+0x30>
        panic("kfree");
80106aae:	83 ec 0c             	sub    $0xc,%esp
80106ab1:	68 cc 77 10 80       	push   $0x801077cc
80106ab6:	e8 c5 98 ff ff       	call   80100380 <panic>
80106abb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106ac0 <mappages>:
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ac6:	89 d3                	mov    %edx,%ebx
80106ac8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ace:	83 ec 1c             	sub    $0x1c,%esp
80106ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ad4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ad8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106add:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae3:	29 d8                	sub    %ebx,%eax
80106ae5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ae8:	eb 3f                	jmp    80106b29 <mappages+0x69>
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106af0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106af2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106af7:	c1 ea 0a             	shr    $0xa,%edx
80106afa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b00:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b07:	85 c0                	test   %eax,%eax
80106b09:	74 75                	je     80106b80 <mappages+0xc0>
    if(*pte & PTE_P)
80106b0b:	f6 00 01             	testb  $0x1,(%eax)
80106b0e:	0f 85 86 00 00 00    	jne    80106b9a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106b14:	0b 75 0c             	or     0xc(%ebp),%esi
80106b17:	83 ce 01             	or     $0x1,%esi
80106b1a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b1f:	39 c3                	cmp    %eax,%ebx
80106b21:	74 6d                	je     80106b90 <mappages+0xd0>
    a += PGSIZE;
80106b23:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106b2c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106b2f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106b32:	89 d8                	mov    %ebx,%eax
80106b34:	c1 e8 16             	shr    $0x16,%eax
80106b37:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106b3a:	8b 07                	mov    (%edi),%eax
80106b3c:	a8 01                	test   $0x1,%al
80106b3e:	75 b0                	jne    80106af0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b40:	e8 6b bb ff ff       	call   801026b0 <kalloc>
80106b45:	85 c0                	test   %eax,%eax
80106b47:	74 37                	je     80106b80 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b49:	83 ec 04             	sub    $0x4,%esp
80106b4c:	68 00 10 00 00       	push   $0x1000
80106b51:	6a 00                	push   $0x0
80106b53:	50                   	push   %eax
80106b54:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b57:	e8 14 dd ff ff       	call   80104870 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b5c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b5f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b62:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b68:	83 c8 07             	or     $0x7,%eax
80106b6b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b6d:	89 d8                	mov    %ebx,%eax
80106b6f:	c1 e8 0a             	shr    $0xa,%eax
80106b72:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b77:	01 d0                	add    %edx,%eax
80106b79:	eb 90                	jmp    80106b0b <mappages+0x4b>
80106b7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b88:	5b                   	pop    %ebx
80106b89:	5e                   	pop    %esi
80106b8a:	5f                   	pop    %edi
80106b8b:	5d                   	pop    %ebp
80106b8c:	c3                   	ret
80106b8d:	8d 76 00             	lea    0x0(%esi),%esi
80106b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b93:	31 c0                	xor    %eax,%eax
}
80106b95:	5b                   	pop    %ebx
80106b96:	5e                   	pop    %esi
80106b97:	5f                   	pop    %edi
80106b98:	5d                   	pop    %ebp
80106b99:	c3                   	ret
      panic("remap");
80106b9a:	83 ec 0c             	sub    $0xc,%esp
80106b9d:	68 00 7a 10 80       	push   $0x80107a00
80106ba2:	e8 d9 97 ff ff       	call   80100380 <panic>
80106ba7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bae:	00 
80106baf:	90                   	nop

80106bb0 <seginit>:
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106bb6:	e8 f5 cd ff ff       	call   801039b0 <cpuid>
  pd[0] = size-1;
80106bbb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bc0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106bc6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106bca:	c7 80 18 a8 14 80 ff 	movl   $0xffff,-0x7feb57e8(%eax)
80106bd1:	ff 00 00 
80106bd4:	c7 80 1c a8 14 80 00 	movl   $0xcf9a00,-0x7feb57e4(%eax)
80106bdb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bde:	c7 80 20 a8 14 80 ff 	movl   $0xffff,-0x7feb57e0(%eax)
80106be5:	ff 00 00 
80106be8:	c7 80 24 a8 14 80 00 	movl   $0xcf9200,-0x7feb57dc(%eax)
80106bef:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bf2:	c7 80 28 a8 14 80 ff 	movl   $0xffff,-0x7feb57d8(%eax)
80106bf9:	ff 00 00 
80106bfc:	c7 80 2c a8 14 80 00 	movl   $0xcffa00,-0x7feb57d4(%eax)
80106c03:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c06:	c7 80 30 a8 14 80 ff 	movl   $0xffff,-0x7feb57d0(%eax)
80106c0d:	ff 00 00 
80106c10:	c7 80 34 a8 14 80 00 	movl   $0xcff200,-0x7feb57cc(%eax)
80106c17:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c1a:	05 10 a8 14 80       	add    $0x8014a810,%eax
  pd[1] = (uint)p;
80106c1f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c23:	c1 e8 10             	shr    $0x10,%eax
80106c26:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c2a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c2d:	0f 01 10             	lgdtl  (%eax)
}
80106c30:	c9                   	leave
80106c31:	c3                   	ret
80106c32:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c39:	00 
80106c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c40 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c40:	a1 c4 d4 14 80       	mov    0x8014d4c4,%eax
80106c45:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c4a:	0f 22 d8             	mov    %eax,%cr3
}
80106c4d:	c3                   	ret
80106c4e:	66 90                	xchg   %ax,%ax

80106c50 <switchuvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	57                   	push   %edi
80106c54:	56                   	push   %esi
80106c55:	53                   	push   %ebx
80106c56:	83 ec 1c             	sub    $0x1c,%esp
80106c59:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c5c:	85 f6                	test   %esi,%esi
80106c5e:	0f 84 cb 00 00 00    	je     80106d2f <switchuvm+0xdf>
  if(p->kstack == 0)
80106c64:	8b 46 08             	mov    0x8(%esi),%eax
80106c67:	85 c0                	test   %eax,%eax
80106c69:	0f 84 da 00 00 00    	je     80106d49 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c6f:	8b 46 04             	mov    0x4(%esi),%eax
80106c72:	85 c0                	test   %eax,%eax
80106c74:	0f 84 c2 00 00 00    	je     80106d3c <switchuvm+0xec>
  pushcli();
80106c7a:	e8 a1 d9 ff ff       	call   80104620 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c7f:	e8 cc cc ff ff       	call   80103950 <mycpu>
80106c84:	89 c3                	mov    %eax,%ebx
80106c86:	e8 c5 cc ff ff       	call   80103950 <mycpu>
80106c8b:	89 c7                	mov    %eax,%edi
80106c8d:	e8 be cc ff ff       	call   80103950 <mycpu>
80106c92:	83 c7 08             	add    $0x8,%edi
80106c95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c98:	e8 b3 cc ff ff       	call   80103950 <mycpu>
80106c9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ca0:	ba 67 00 00 00       	mov    $0x67,%edx
80106ca5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cac:	83 c0 08             	add    $0x8,%eax
80106caf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cb6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cbb:	83 c1 08             	add    $0x8,%ecx
80106cbe:	c1 e8 18             	shr    $0x18,%eax
80106cc1:	c1 e9 10             	shr    $0x10,%ecx
80106cc4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106cca:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106cd0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106cd5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cdc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ce1:	e8 6a cc ff ff       	call   80103950 <mycpu>
80106ce6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ced:	e8 5e cc ff ff       	call   80103950 <mycpu>
80106cf2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106cf6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106cf9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cff:	e8 4c cc ff ff       	call   80103950 <mycpu>
80106d04:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d07:	e8 44 cc ff ff       	call   80103950 <mycpu>
80106d0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d10:	b8 28 00 00 00       	mov    $0x28,%eax
80106d15:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d18:	8b 46 04             	mov    0x4(%esi),%eax
80106d1b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d20:	0f 22 d8             	mov    %eax,%cr3
}
80106d23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d26:	5b                   	pop    %ebx
80106d27:	5e                   	pop    %esi
80106d28:	5f                   	pop    %edi
80106d29:	5d                   	pop    %ebp
  popcli();
80106d2a:	e9 41 d9 ff ff       	jmp    80104670 <popcli>
    panic("switchuvm: no process");
80106d2f:	83 ec 0c             	sub    $0xc,%esp
80106d32:	68 06 7a 10 80       	push   $0x80107a06
80106d37:	e8 44 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106d3c:	83 ec 0c             	sub    $0xc,%esp
80106d3f:	68 31 7a 10 80       	push   $0x80107a31
80106d44:	e8 37 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d49:	83 ec 0c             	sub    $0xc,%esp
80106d4c:	68 1c 7a 10 80       	push   $0x80107a1c
80106d51:	e8 2a 96 ff ff       	call   80100380 <panic>
80106d56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d5d:	00 
80106d5e:	66 90                	xchg   %ax,%ax

80106d60 <inituvm>:
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
80106d69:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106d72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d75:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d7b:	77 49                	ja     80106dc6 <inituvm+0x66>
  mem = kalloc();
80106d7d:	e8 2e b9 ff ff       	call   801026b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106d82:	83 ec 04             	sub    $0x4,%esp
80106d85:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d8a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d8c:	6a 00                	push   $0x0
80106d8e:	50                   	push   %eax
80106d8f:	e8 dc da ff ff       	call   80104870 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d94:	58                   	pop    %eax
80106d95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d9b:	5a                   	pop    %edx
80106d9c:	6a 06                	push   $0x6
80106d9e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106da3:	31 d2                	xor    %edx,%edx
80106da5:	50                   	push   %eax
80106da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106da9:	e8 12 fd ff ff       	call   80106ac0 <mappages>
  memmove(mem, init, sz);
80106dae:	83 c4 10             	add    $0x10,%esp
80106db1:	89 75 10             	mov    %esi,0x10(%ebp)
80106db4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106db7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dbd:	5b                   	pop    %ebx
80106dbe:	5e                   	pop    %esi
80106dbf:	5f                   	pop    %edi
80106dc0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106dc1:	e9 3a db ff ff       	jmp    80104900 <memmove>
    panic("inituvm: more than a page");
80106dc6:	83 ec 0c             	sub    $0xc,%esp
80106dc9:	68 45 7a 10 80       	push   $0x80107a45
80106dce:	e8 ad 95 ff ff       	call   80100380 <panic>
80106dd3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dda:	00 
80106ddb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106de0 <loaduvm>:
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106de9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106dec:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106def:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106df5:	0f 85 a2 00 00 00    	jne    80106e9d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106dfb:	85 ff                	test   %edi,%edi
80106dfd:	74 7d                	je     80106e7c <loaduvm+0x9c>
80106dff:	90                   	nop
  pde = &pgdir[PDX(va)];
80106e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106e03:	8b 55 08             	mov    0x8(%ebp),%edx
80106e06:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106e08:	89 c1                	mov    %eax,%ecx
80106e0a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106e0d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106e10:	f6 c1 01             	test   $0x1,%cl
80106e13:	75 13                	jne    80106e28 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106e15:	83 ec 0c             	sub    $0xc,%esp
80106e18:	68 5f 7a 10 80       	push   $0x80107a5f
80106e1d:	e8 5e 95 ff ff       	call   80100380 <panic>
80106e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e28:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e2b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106e31:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e36:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e3d:	85 c9                	test   %ecx,%ecx
80106e3f:	74 d4                	je     80106e15 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106e41:	89 fb                	mov    %edi,%ebx
80106e43:	b8 00 10 00 00       	mov    $0x1000,%eax
80106e48:	29 f3                	sub    %esi,%ebx
80106e4a:	39 c3                	cmp    %eax,%ebx
80106e4c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e4f:	53                   	push   %ebx
80106e50:	8b 45 14             	mov    0x14(%ebp),%eax
80106e53:	01 f0                	add    %esi,%eax
80106e55:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106e56:	8b 01                	mov    (%ecx),%eax
80106e58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e5d:	05 00 00 00 80       	add    $0x80000000,%eax
80106e62:	50                   	push   %eax
80106e63:	ff 75 10             	push   0x10(%ebp)
80106e66:	e8 45 ac ff ff       	call   80101ab0 <readi>
80106e6b:	83 c4 10             	add    $0x10,%esp
80106e6e:	39 d8                	cmp    %ebx,%eax
80106e70:	75 1e                	jne    80106e90 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106e72:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e78:	39 fe                	cmp    %edi,%esi
80106e7a:	72 84                	jb     80106e00 <loaduvm+0x20>
}
80106e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e7f:	31 c0                	xor    %eax,%eax
}
80106e81:	5b                   	pop    %ebx
80106e82:	5e                   	pop    %esi
80106e83:	5f                   	pop    %edi
80106e84:	5d                   	pop    %ebp
80106e85:	c3                   	ret
80106e86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e8d:	00 
80106e8e:	66 90                	xchg   %ax,%ax
80106e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e98:	5b                   	pop    %ebx
80106e99:	5e                   	pop    %esi
80106e9a:	5f                   	pop    %edi
80106e9b:	5d                   	pop    %ebp
80106e9c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106e9d:	83 ec 0c             	sub    $0xc,%esp
80106ea0:	68 bc 7c 10 80       	push   $0x80107cbc
80106ea5:	e8 d6 94 ff ff       	call   80100380 <panic>
80106eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106eb0 <allocuvm>:
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	57                   	push   %edi
80106eb4:	56                   	push   %esi
80106eb5:	53                   	push   %ebx
80106eb6:	83 ec 1c             	sub    $0x1c,%esp
80106eb9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106ebc:	85 f6                	test   %esi,%esi
80106ebe:	0f 88 98 00 00 00    	js     80106f5c <allocuvm+0xac>
80106ec4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106ec6:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106ec9:	0f 82 a1 00 00 00    	jb     80106f70 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ed2:	05 ff 0f 00 00       	add    $0xfff,%eax
80106ed7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106edc:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106ede:	39 f0                	cmp    %esi,%eax
80106ee0:	0f 83 8d 00 00 00    	jae    80106f73 <allocuvm+0xc3>
80106ee6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106ee9:	eb 44                	jmp    80106f2f <allocuvm+0x7f>
80106eeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106ef0:	83 ec 04             	sub    $0x4,%esp
80106ef3:	68 00 10 00 00       	push   $0x1000
80106ef8:	6a 00                	push   $0x0
80106efa:	50                   	push   %eax
80106efb:	e8 70 d9 ff ff       	call   80104870 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f00:	58                   	pop    %eax
80106f01:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f07:	5a                   	pop    %edx
80106f08:	6a 06                	push   $0x6
80106f0a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f0f:	89 fa                	mov    %edi,%edx
80106f11:	50                   	push   %eax
80106f12:	8b 45 08             	mov    0x8(%ebp),%eax
80106f15:	e8 a6 fb ff ff       	call   80106ac0 <mappages>
80106f1a:	83 c4 10             	add    $0x10,%esp
80106f1d:	85 c0                	test   %eax,%eax
80106f1f:	78 5f                	js     80106f80 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106f21:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f27:	39 f7                	cmp    %esi,%edi
80106f29:	0f 83 89 00 00 00    	jae    80106fb8 <allocuvm+0x108>
    mem = kalloc();
80106f2f:	e8 7c b7 ff ff       	call   801026b0 <kalloc>
80106f34:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f36:	85 c0                	test   %eax,%eax
80106f38:	75 b6                	jne    80106ef0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 7d 7a 10 80       	push   $0x80107a7d
80106f42:	e8 69 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f47:	83 c4 10             	add    $0x10,%esp
80106f4a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f4d:	74 0d                	je     80106f5c <allocuvm+0xac>
80106f4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f52:	8b 45 08             	mov    0x8(%ebp),%eax
80106f55:	89 f2                	mov    %esi,%edx
80106f57:	e8 a4 fa ff ff       	call   80106a00 <deallocuvm.part.0>
    return 0;
80106f5c:	31 d2                	xor    %edx,%edx
}
80106f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f61:	89 d0                	mov    %edx,%eax
80106f63:	5b                   	pop    %ebx
80106f64:	5e                   	pop    %esi
80106f65:	5f                   	pop    %edi
80106f66:	5d                   	pop    %ebp
80106f67:	c3                   	ret
80106f68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f6f:	00 
    return oldsz;
80106f70:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f76:	89 d0                	mov    %edx,%eax
80106f78:	5b                   	pop    %ebx
80106f79:	5e                   	pop    %esi
80106f7a:	5f                   	pop    %edi
80106f7b:	5d                   	pop    %ebp
80106f7c:	c3                   	ret
80106f7d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f80:	83 ec 0c             	sub    $0xc,%esp
80106f83:	68 95 7a 10 80       	push   $0x80107a95
80106f88:	e8 23 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f8d:	83 c4 10             	add    $0x10,%esp
80106f90:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f93:	74 0d                	je     80106fa2 <allocuvm+0xf2>
80106f95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f98:	8b 45 08             	mov    0x8(%ebp),%eax
80106f9b:	89 f2                	mov    %esi,%edx
80106f9d:	e8 5e fa ff ff       	call   80106a00 <deallocuvm.part.0>
      kfree(mem);
80106fa2:	83 ec 0c             	sub    $0xc,%esp
80106fa5:	53                   	push   %ebx
80106fa6:	e8 f5 b4 ff ff       	call   801024a0 <kfree>
      return 0;
80106fab:	83 c4 10             	add    $0x10,%esp
    return 0;
80106fae:	31 d2                	xor    %edx,%edx
80106fb0:	eb ac                	jmp    80106f5e <allocuvm+0xae>
80106fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fbe:	5b                   	pop    %ebx
80106fbf:	5e                   	pop    %esi
80106fc0:	89 d0                	mov    %edx,%eax
80106fc2:	5f                   	pop    %edi
80106fc3:	5d                   	pop    %ebp
80106fc4:	c3                   	ret
80106fc5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fcc:	00 
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi

80106fd0 <deallocuvm>:
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106fdc:	39 d1                	cmp    %edx,%ecx
80106fde:	73 10                	jae    80106ff0 <deallocuvm+0x20>
}
80106fe0:	5d                   	pop    %ebp
80106fe1:	e9 1a fa ff ff       	jmp    80106a00 <deallocuvm.part.0>
80106fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fed:	00 
80106fee:	66 90                	xchg   %ax,%ax
80106ff0:	89 d0                	mov    %edx,%eax
80106ff2:	5d                   	pop    %ebp
80106ff3:	c3                   	ret
80106ff4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ffb:	00 
80106ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107000 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
80107006:	83 ec 0c             	sub    $0xc,%esp
80107009:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010700c:	85 f6                	test   %esi,%esi
8010700e:	74 59                	je     80107069 <freevm+0x69>
  if(newsz >= oldsz)
80107010:	31 c9                	xor    %ecx,%ecx
80107012:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107017:	89 f0                	mov    %esi,%eax
80107019:	89 f3                	mov    %esi,%ebx
8010701b:	e8 e0 f9 ff ff       	call   80106a00 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107020:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107026:	eb 0f                	jmp    80107037 <freevm+0x37>
80107028:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010702f:	00 
80107030:	83 c3 04             	add    $0x4,%ebx
80107033:	39 fb                	cmp    %edi,%ebx
80107035:	74 23                	je     8010705a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107037:	8b 03                	mov    (%ebx),%eax
80107039:	a8 01                	test   $0x1,%al
8010703b:	74 f3                	je     80107030 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010703d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107042:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107045:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107048:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010704d:	50                   	push   %eax
8010704e:	e8 4d b4 ff ff       	call   801024a0 <kfree>
80107053:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107056:	39 fb                	cmp    %edi,%ebx
80107058:	75 dd                	jne    80107037 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010705a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010705d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107060:	5b                   	pop    %ebx
80107061:	5e                   	pop    %esi
80107062:	5f                   	pop    %edi
80107063:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107064:	e9 37 b4 ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
80107069:	83 ec 0c             	sub    $0xc,%esp
8010706c:	68 b1 7a 10 80       	push   $0x80107ab1
80107071:	e8 0a 93 ff ff       	call   80100380 <panic>
80107076:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010707d:	00 
8010707e:	66 90                	xchg   %ax,%ax

80107080 <setupkvm>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	56                   	push   %esi
80107084:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107085:	e8 26 b6 ff ff       	call   801026b0 <kalloc>
8010708a:	85 c0                	test   %eax,%eax
8010708c:	74 5e                	je     801070ec <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010708e:	83 ec 04             	sub    $0x4,%esp
80107091:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107093:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107098:	68 00 10 00 00       	push   $0x1000
8010709d:	6a 00                	push   $0x0
8010709f:	50                   	push   %eax
801070a0:	e8 cb d7 ff ff       	call   80104870 <memset>
801070a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801070a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070ab:	83 ec 08             	sub    $0x8,%esp
801070ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070b1:	8b 13                	mov    (%ebx),%edx
801070b3:	ff 73 0c             	push   0xc(%ebx)
801070b6:	50                   	push   %eax
801070b7:	29 c1                	sub    %eax,%ecx
801070b9:	89 f0                	mov    %esi,%eax
801070bb:	e8 00 fa ff ff       	call   80106ac0 <mappages>
801070c0:	83 c4 10             	add    $0x10,%esp
801070c3:	85 c0                	test   %eax,%eax
801070c5:	78 19                	js     801070e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070c7:	83 c3 10             	add    $0x10,%ebx
801070ca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801070d0:	75 d6                	jne    801070a8 <setupkvm+0x28>
}
801070d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070d5:	89 f0                	mov    %esi,%eax
801070d7:	5b                   	pop    %ebx
801070d8:	5e                   	pop    %esi
801070d9:	5d                   	pop    %ebp
801070da:	c3                   	ret
801070db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801070e0:	83 ec 0c             	sub    $0xc,%esp
801070e3:	56                   	push   %esi
801070e4:	e8 17 ff ff ff       	call   80107000 <freevm>
      return 0;
801070e9:	83 c4 10             	add    $0x10,%esp
}
801070ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801070ef:	31 f6                	xor    %esi,%esi
}
801070f1:	89 f0                	mov    %esi,%eax
801070f3:	5b                   	pop    %ebx
801070f4:	5e                   	pop    %esi
801070f5:	5d                   	pop    %ebp
801070f6:	c3                   	ret
801070f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070fe:	00 
801070ff:	90                   	nop

80107100 <kvmalloc>:
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107106:	e8 75 ff ff ff       	call   80107080 <setupkvm>
8010710b:	a3 c4 d4 14 80       	mov    %eax,0x8014d4c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107110:	05 00 00 00 80       	add    $0x80000000,%eax
80107115:	0f 22 d8             	mov    %eax,%cr3
}
80107118:	c9                   	leave
80107119:	c3                   	ret
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107120 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	83 ec 08             	sub    $0x8,%esp
80107126:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107129:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010712c:	89 c1                	mov    %eax,%ecx
8010712e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107131:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107134:	f6 c2 01             	test   $0x1,%dl
80107137:	75 17                	jne    80107150 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107139:	83 ec 0c             	sub    $0xc,%esp
8010713c:	68 c2 7a 10 80       	push   $0x80107ac2
80107141:	e8 3a 92 ff ff       	call   80100380 <panic>
80107146:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010714d:	00 
8010714e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107150:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107153:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107159:	25 fc 0f 00 00       	and    $0xffc,%eax
8010715e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107165:	85 c0                	test   %eax,%eax
80107167:	74 d0                	je     80107139 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107169:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010716c:	c9                   	leave
8010716d:	c3                   	ret
8010716e:	66 90                	xchg   %ax,%ax

80107170 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107179:	e8 02 ff ff ff       	call   80107080 <setupkvm>
8010717e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107181:	85 c0                	test   %eax,%eax
80107183:	0f 84 e9 00 00 00    	je     80107272 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107189:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010718c:	85 c9                	test   %ecx,%ecx
8010718e:	0f 84 b2 00 00 00    	je     80107246 <copyuvm+0xd6>
80107194:	31 f6                	xor    %esi,%esi
80107196:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010719d:	00 
8010719e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801071a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801071a3:	89 f0                	mov    %esi,%eax
801071a5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801071a8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801071ab:	a8 01                	test   $0x1,%al
801071ad:	75 11                	jne    801071c0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801071af:	83 ec 0c             	sub    $0xc,%esp
801071b2:	68 cc 7a 10 80       	push   $0x80107acc
801071b7:	e8 c4 91 ff ff       	call   80100380 <panic>
801071bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801071c0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071c7:	c1 ea 0a             	shr    $0xa,%edx
801071ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801071d7:	85 c0                	test   %eax,%eax
801071d9:	74 d4                	je     801071af <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801071db:	8b 00                	mov    (%eax),%eax
801071dd:	a8 01                	test   $0x1,%al
801071df:	0f 84 9f 00 00 00    	je     80107284 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801071e5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801071e7:	25 ff 0f 00 00       	and    $0xfff,%eax
801071ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801071ef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801071f5:	e8 b6 b4 ff ff       	call   801026b0 <kalloc>
801071fa:	89 c3                	mov    %eax,%ebx
801071fc:	85 c0                	test   %eax,%eax
801071fe:	74 64                	je     80107264 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107200:	83 ec 04             	sub    $0x4,%esp
80107203:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107209:	68 00 10 00 00       	push   $0x1000
8010720e:	57                   	push   %edi
8010720f:	50                   	push   %eax
80107210:	e8 eb d6 ff ff       	call   80104900 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107215:	58                   	pop    %eax
80107216:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010721c:	5a                   	pop    %edx
8010721d:	ff 75 e4             	push   -0x1c(%ebp)
80107220:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107225:	89 f2                	mov    %esi,%edx
80107227:	50                   	push   %eax
80107228:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010722b:	e8 90 f8 ff ff       	call   80106ac0 <mappages>
80107230:	83 c4 10             	add    $0x10,%esp
80107233:	85 c0                	test   %eax,%eax
80107235:	78 21                	js     80107258 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107237:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010723d:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107240:	0f 82 5a ff ff ff    	jb     801071a0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107246:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107249:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724c:	5b                   	pop    %ebx
8010724d:	5e                   	pop    %esi
8010724e:	5f                   	pop    %edi
8010724f:	5d                   	pop    %ebp
80107250:	c3                   	ret
80107251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107258:	83 ec 0c             	sub    $0xc,%esp
8010725b:	53                   	push   %ebx
8010725c:	e8 3f b2 ff ff       	call   801024a0 <kfree>
      goto bad;
80107261:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107264:	83 ec 0c             	sub    $0xc,%esp
80107267:	ff 75 e0             	push   -0x20(%ebp)
8010726a:	e8 91 fd ff ff       	call   80107000 <freevm>
  return 0;
8010726f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107272:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107279:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010727c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010727f:	5b                   	pop    %ebx
80107280:	5e                   	pop    %esi
80107281:	5f                   	pop    %edi
80107282:	5d                   	pop    %ebp
80107283:	c3                   	ret
      panic("copyuvm: page not present");
80107284:	83 ec 0c             	sub    $0xc,%esp
80107287:	68 e6 7a 10 80       	push   $0x80107ae6
8010728c:	e8 ef 90 ff ff       	call   80100380 <panic>
80107291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107298:	00 
80107299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072a0 <copyuvmcow>:

pde_t*
copyuvmcow(pde_t *pgdir, uint sz)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
801072a9:	e8 d2 fd ff ff       	call   80107080 <setupkvm>
801072ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072b1:	85 c0                	test   %eax,%eax
801072b3:	0f 84 d5 00 00 00    	je     8010738e <copyuvmcow+0xee>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801072b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801072bc:	85 c0                	test   %eax,%eax
801072be:	0f 84 9f 00 00 00    	je     80107363 <copyuvmcow+0xc3>
801072c4:	31 db                	xor    %ebx,%ebx
801072c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072cd:	00 
801072ce:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
801072d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801072d3:	89 d8                	mov    %ebx,%eax
801072d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801072d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801072db:	a8 01                	test   $0x1,%al
801072dd:	75 11                	jne    801072f0 <copyuvmcow+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvmcow: pte should exist");
801072df:	83 ec 0c             	sub    $0xc,%esp
801072e2:	68 00 7b 10 80       	push   $0x80107b00
801072e7:	e8 94 90 ff ff       	call   80100380 <panic>
801072ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801072f0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801072f7:	c1 ea 0a             	shr    $0xa,%edx
801072fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107300:	8d 8c 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%ecx
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107307:	85 c9                	test   %ecx,%ecx
80107309:	74 d4                	je     801072df <copyuvmcow+0x3f>
    if(!(*pte & PTE_P))
8010730b:	8b 01                	mov    (%ecx),%eax
8010730d:	a8 01                	test   $0x1,%al
8010730f:	0f 84 8b 00 00 00    	je     801073a0 <copyuvmcow+0x100>
      panic("copyuvmcow: page not present");
    pa = PTE_ADDR(*pte);
80107315:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
    flags &= ~PTE_W;
80107317:	89 c2                	mov    %eax,%edx
    flags |= PTE_COW;
    *pte = pa | flags;
    int frame = pa / PGSIZE;
    ref_count[frame]++;
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107319:	83 ec 08             	sub    $0x8,%esp
    int frame = pa / PGSIZE;
8010731c:	c1 e8 0c             	shr    $0xc,%eax
    pa = PTE_ADDR(*pte);
8010731f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags &= ~PTE_W;
80107325:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    flags |= PTE_COW;
8010732b:	80 ce 04             	or     $0x4,%dh
    *pte = pa | flags;
8010732e:	89 f7                	mov    %esi,%edi
80107330:	09 d7                	or     %edx,%edi
80107332:	89 39                	mov    %edi,(%ecx)
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107334:	b9 00 10 00 00       	mov    $0x1000,%ecx
    ref_count[frame]++;
80107339:	83 04 85 80 26 11 80 	addl   $0x1,-0x7feed980(,%eax,4)
80107340:	01 
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107341:	52                   	push   %edx
80107342:	89 da                	mov    %ebx,%edx
80107344:	56                   	push   %esi
80107345:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107348:	e8 73 f7 ff ff       	call   80106ac0 <mappages>
8010734d:	83 c4 10             	add    $0x10,%esp
80107350:	85 c0                	test   %eax,%eax
80107352:	78 2c                	js     80107380 <copyuvmcow+0xe0>
  for(i = 0; i < sz; i += PGSIZE){
80107354:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010735a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
8010735d:	0f 82 6d ff ff ff    	jb     801072d0 <copyuvmcow+0x30>
      goto bad;
  }
  lcr3(V2P(pgdir));  // flush TLB
80107363:	8b 45 08             	mov    0x8(%ebp),%eax
80107366:	05 00 00 00 80       	add    $0x80000000,%eax
8010736b:	0f 22 d8             	mov    %eax,%cr3
  return d;

bad:
  freevm(d);
  return 0;
}
8010736e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107374:	5b                   	pop    %ebx
80107375:	5e                   	pop    %esi
80107376:	5f                   	pop    %edi
80107377:	5d                   	pop    %ebp
80107378:	c3                   	ret
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  freevm(d);
80107380:	83 ec 0c             	sub    $0xc,%esp
80107383:	ff 75 e4             	push   -0x1c(%ebp)
80107386:	e8 75 fc ff ff       	call   80107000 <freevm>
  return 0;
8010738b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010738e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107398:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010739b:	5b                   	pop    %ebx
8010739c:	5e                   	pop    %esi
8010739d:	5f                   	pop    %edi
8010739e:	5d                   	pop    %ebp
8010739f:	c3                   	ret
      panic("copyuvmcow: page not present");
801073a0:	83 ec 0c             	sub    $0xc,%esp
801073a3:	68 1d 7b 10 80       	push   $0x80107b1d
801073a8:	e8 d3 8f ff ff       	call   80100380 <panic>
801073ad:	8d 76 00             	lea    0x0(%esi),%esi

801073b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801073b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801073b9:	89 c1                	mov    %eax,%ecx
801073bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801073be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801073c1:	f6 c2 01             	test   $0x1,%dl
801073c4:	0f 84 15 02 00 00    	je     801075df <uva2ka.cold>
  return &pgtab[PTX(va)];
801073ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801073cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801073d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801073d9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073e0:	89 d0                	mov    %edx,%eax
801073e2:	f7 d2                	not    %edx
801073e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073e9:	05 00 00 00 80       	add    $0x80000000,%eax
801073ee:	83 e2 05             	and    $0x5,%edx
801073f1:	ba 00 00 00 00       	mov    $0x0,%edx
801073f6:	0f 45 c2             	cmovne %edx,%eax
}
801073f9:	c3                   	ret
801073fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107400 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 0c             	sub    $0xc,%esp
80107409:	8b 75 14             	mov    0x14(%ebp),%esi
8010740c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010740f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107412:	85 f6                	test   %esi,%esi
80107414:	75 51                	jne    80107467 <copyout+0x67>
80107416:	e9 9d 00 00 00       	jmp    801074b8 <copyout+0xb8>
8010741b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107426:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010742c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107432:	74 74                	je     801074a8 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107434:	89 fb                	mov    %edi,%ebx
80107436:	29 c3                	sub    %eax,%ebx
80107438:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010743e:	39 f3                	cmp    %esi,%ebx
80107440:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107443:	29 f8                	sub    %edi,%eax
80107445:	83 ec 04             	sub    $0x4,%esp
80107448:	01 c1                	add    %eax,%ecx
8010744a:	53                   	push   %ebx
8010744b:	52                   	push   %edx
8010744c:	89 55 10             	mov    %edx,0x10(%ebp)
8010744f:	51                   	push   %ecx
80107450:	e8 ab d4 ff ff       	call   80104900 <memmove>
    len -= n;
    buf += n;
80107455:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107458:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010745e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107461:	01 da                	add    %ebx,%edx
  while(len > 0){
80107463:	29 de                	sub    %ebx,%esi
80107465:	74 51                	je     801074b8 <copyout+0xb8>
  if(*pde & PTE_P){
80107467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010746a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010746c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010746e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107471:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107477:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010747a:	f6 c1 01             	test   $0x1,%cl
8010747d:	0f 84 63 01 00 00    	je     801075e6 <copyout.cold>
  return &pgtab[PTX(va)];
80107483:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107485:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010748b:	c1 eb 0c             	shr    $0xc,%ebx
8010748e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107494:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010749b:	89 d9                	mov    %ebx,%ecx
8010749d:	f7 d1                	not    %ecx
8010749f:	83 e1 05             	and    $0x5,%ecx
801074a2:	0f 84 78 ff ff ff    	je     80107420 <copyout+0x20>
  }
  return 0;
}
801074a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074b0:	5b                   	pop    %ebx
801074b1:	5e                   	pop    %esi
801074b2:	5f                   	pop    %edi
801074b3:	5d                   	pop    %ebp
801074b4:	c3                   	ret
801074b5:	8d 76 00             	lea    0x0(%esi),%esi
801074b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074bb:	31 c0                	xor    %eax,%eax
}
801074bd:	5b                   	pop    %ebx
801074be:	5e                   	pop    %esi
801074bf:	5f                   	pop    %edi
801074c0:	5d                   	pop    %ebp
801074c1:	c3                   	ret
801074c2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074c9:	00 
801074ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074d0 <virt2real>:

char* virt2real(char *va) {
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	53                   	push   %ebx
801074d4:	83 ec 04             	sub    $0x4,%esp
801074d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p = myproc();
801074da:	e8 f1 c4 ff ff       	call   801039d0 <myproc>
  if(*pde & PTE_P){
801074df:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
801074e2:	89 da                	mov    %ebx,%edx
801074e4:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801074e7:	8b 04 90             	mov    (%eax,%edx,4),%eax
801074ea:	a8 01                	test   $0x1,%al
801074ec:	0f 84 fb 00 00 00    	je     801075ed <virt2real.cold>
  return &pgtab[PTX(va)];
801074f2:	c1 eb 0c             	shr    $0xc,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801074fa:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107500:	8b 94 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%edx
  return uva2ka(p->pgdir, va);
}
80107507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010750a:	c9                   	leave
  return (char*)P2V(PTE_ADDR(*pte));
8010750b:	89 d0                	mov    %edx,%eax
8010750d:	f7 d2                	not    %edx
8010750f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107514:	05 00 00 00 80       	add    $0x80000000,%eax
80107519:	83 e2 05             	and    $0x5,%edx
8010751c:	ba 00 00 00 00       	mov    $0x0,%edx
80107521:	0f 45 c2             	cmovne %edx,%eax
}
80107524:	c3                   	ret
80107525:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010752c:	00 
8010752d:	8d 76 00             	lea    0x0(%esi),%esi

80107530 <handle_cow_fault>:

void handle_cow_fault(uint va) {
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 0c             	sub    $0xc,%esp
80107539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pte_t *pte;
  uint pa;
  char *mem;

  pte = walkpgdir(myproc()->pgdir, (void*)va, 0);
8010753c:	e8 8f c4 ff ff       	call   801039d0 <myproc>
  if(*pde & PTE_P){
80107541:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
80107544:	89 da                	mov    %ebx,%edx
80107546:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107549:	8b 04 90             	mov    (%eax,%edx,4),%eax
8010754c:	a8 01                	test   $0x1,%al
8010754e:	75 10                	jne    80107560 <handle_cow_fault+0x30>
  if(!pte || !(*pte & PTE_P) || !(*pte & PTE_COW))
    panic("handle_cow_fault: not a COW page");
80107550:	83 ec 0c             	sub    $0xc,%esp
80107553:	68 e0 7c 10 80       	push   $0x80107ce0
80107558:	e8 23 8e ff ff       	call   80100380 <panic>
8010755d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107560:	c1 eb 0a             	shr    $0xa,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107563:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107568:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010756e:	8d bc 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%edi
  if(!pte || !(*pte & PTE_P) || !(*pte & PTE_COW))
80107575:	85 ff                	test   %edi,%edi
80107577:	74 d7                	je     80107550 <handle_cow_fault+0x20>
80107579:	8b 37                	mov    (%edi),%esi
8010757b:	89 f0                	mov    %esi,%eax
8010757d:	f7 d0                	not    %eax
8010757f:	a9 01 04 00 00       	test   $0x401,%eax
80107584:	75 ca                	jne    80107550 <handle_cow_fault+0x20>

  pa = PTE_ADDR(*pte);
  if((mem = kalloc()) == 0)
80107586:	e8 25 b1 ff ff       	call   801026b0 <kalloc>
  pa = PTE_ADDR(*pte);
8010758b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((mem = kalloc()) == 0)
80107591:	89 c3                	mov    %eax,%ebx
80107593:	85 c0                	test   %eax,%eax
80107595:	74 3b                	je     801075d2 <handle_cow_fault+0xa2>
    panic("handle_cow_fault: kalloc failed");
  memmove(mem, (char*)P2V(pa), PGSIZE);
80107597:	83 ec 04             	sub    $0x4,%esp
8010759a:	81 c6 00 00 00 80    	add    $0x80000000,%esi
  *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;
801075a0:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, (char*)P2V(pa), PGSIZE);
801075a6:	68 00 10 00 00       	push   $0x1000
  *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;
801075ab:	83 cb 07             	or     $0x7,%ebx
  memmove(mem, (char*)P2V(pa), PGSIZE);
801075ae:	56                   	push   %esi
801075af:	50                   	push   %eax
801075b0:	e8 4b d3 ff ff       	call   80104900 <memmove>
  *pte = V2P(mem) | PTE_P | PTE_W | PTE_U;
801075b5:	89 1f                	mov    %ebx,(%edi)
  lcr3(V2P(myproc()->pgdir));  // flush TLB
801075b7:	e8 14 c4 ff ff       	call   801039d0 <myproc>
801075bc:	8b 40 04             	mov    0x4(%eax),%eax
801075bf:	05 00 00 00 80       	add    $0x80000000,%eax
801075c4:	0f 22 d8             	mov    %eax,%cr3
}
801075c7:	83 c4 10             	add    $0x10,%esp
801075ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075cd:	5b                   	pop    %ebx
801075ce:	5e                   	pop    %esi
801075cf:	5f                   	pop    %edi
801075d0:	5d                   	pop    %ebp
801075d1:	c3                   	ret
    panic("handle_cow_fault: kalloc failed");
801075d2:	83 ec 0c             	sub    $0xc,%esp
801075d5:	68 04 7d 10 80       	push   $0x80107d04
801075da:	e8 a1 8d ff ff       	call   80100380 <panic>

801075df <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801075df:	a1 00 00 00 00       	mov    0x0,%eax
801075e4:	0f 0b                	ud2

801075e6 <copyout.cold>:
801075e6:	a1 00 00 00 00       	mov    0x0,%eax
801075eb:	0f 0b                	ud2

801075ed <virt2real.cold>:
801075ed:	a1 00 00 00 00       	mov    0x0,%eax
801075f2:	0f 0b                	ud2
