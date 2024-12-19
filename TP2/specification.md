**Implement**

A `virt2real` call that receives a virtual address (`char*`) and returns a real address. In `user.h` it has the following header:

```c
char* virt2real(char *va);
```

Implement a function `int num_pages(void)` that returns the number of pages that a process uses (references).

```c
int num_pages(void);
```

Both functions need to access the current process. Use the `myproc` call.

### Copy-on-Write Pages

Create a system call called `forkcow`. It must have the same signature as the `fork` call. Unlike the `fork` call, `forkcow` creates a child process with copy-on-write pages. A good part of the effort of the `fork` command is the `copyuvm` function. So, create **a new function** `copyuvmcow`. The steps to follow are: 1. Store the number of references to a frame. This will be useful for copy-on-write. To do this, implement or use a ready-made structure (see `kalloc.c`) that stores that number of references. 2. Ensure that `forkcow` uses the same frames as the parent. For each fork, add the number of references to the frame. 3. Set pages to READ ONLY.

Whenever the hardware indicates a PAGEFAULT trap you must create a new page for the
child.

1. Make sure that the page fault is a write fault at a user address. Use the `tf->err` field and the flags.
2. To determine the virtual address that generated the fault use the CR2 register: `uint va = rcr2();`.
3. Make sure it is a PTE_COW page.
4. Create a new page if necessary.
i. This will be necessary when: The page is shared with the parent.  If the counter is greater than 1, then make a copy.
ii. **Not** necessary when: The reference count is `==1`. In this case, only one process references the page and it can be written to. Remove the PTE_COW flag and set the page as writeable.
*In both cases above, flush the TLB.*

To know if a fault was a write fault, do:

```c
if (tf->ef & 0x2)
```
