---
layout: post
title: "C库线程安全函数"
date: 2016-07-31 08:28:21
comments: true
mathjax: false
categories: libc
---

C库线程安全函数和不安全函数

<!--more-->

<http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0492c/Chdiedfe.html>

线程安全函数

| Functions	 | Description |
|----|----|
| calloc(),free(),malloc(),realloc() | The heap functions are thread-safe if the _mutex_* functions are implemented.A single heap is shared between all threads, and mutexes are used to avoid data corruption when there is concurrent access. Each heap implementation is responsible for doing its own locking. If you supply your own allocator, it must also do its own locking. This enables it to do fine-grained locking if required, rather than protecting the entire heap with a single mutex (coarse-grained locking).|
|alloca() | alloca() is thread-safe because it allocates memory on the stack.|
| abort(),raise(),signal(),fenv.h |The ARM signal handling functions and floating-point exception traps are thread-safe.The settings for signal handlers and floating-point traps are global across the entire process and are protected by locks. Data corruption does not occur if multiple threads call signal() or an fenv.h function at the same time. However, be aware that the effects of the call act on all threads and not only on the calling thread.
|clearerr(), fclose(),feof(),ferror(), fflush(),fgetc(),fgetpos(), fgets(),fopen(),fputc(), fputs(),fread(),freopen(), fseek(),fsetpos(),ftell(), fwrite(),getc(),getchar(), gets(),perror(),putc(), putchar(),puts(),rewind(), setbuf(),setvbuf(),tmpfile(), tmpnam(),ungetc() | The stdio library is thread-safe if the _mutex_* functions are implemented.Each individual stream is protected by a lock, so two threads can each open their own stdio stream and use it, without interfering with one another.If two threads both want to read or write the same stream, locking at the fgetc() and fputc() level prevents data corruption, but it is possible that the individual characters output by each thread might be interleaved in a confusing way. **Note** tmpnam() also contains a static buffer but this is only used if the argument is NULL. To ensure that your use of tmpnam() is thread-safe, supply your own buffer space.|
|fprintf(), printf(),vfprintf(), vprintf(), fscanf(),scanf() | When using these functions:the standard C printf() and scanf() functions use stdio so they are thread-safe. the standard C printf() function is susceptible to changes in the locale settings if called in a multithreaded program. |
| clock() | clock() contains static data that is written once at program startup and then only ever read. Therefore, clock() is thread-safe provided no extra threads are already running at the time that the library is initialized. |
| errno | errno is thread-safe.Each thread has its own errno stored in a __user_perthread_libspace block. This means that each thread can call errno-setting functions independently and then check errno afterwards without interference from other threads.
| atexit() | The list of exit functions maintained by atexit() is process-global and protected by a lock.In the worst case, if more than one thread calls atexit(), the order that exit functions are called cannot be guaranteed. |
| abs(), acos(), asin(),atan(),atan2(), atof(),atol(), atoi(),bsearch(),ceil(), cos(),cosh(),difftime(), div(),exp(),fabs(), floor(),fmod(),frexp(), labs(),ldexp(),ldiv(), log(),log10(),memchr(), memcmp(),memcpy(),memmove(), memset(),mktime(),modf(), pow(),qsort(),sin(), sinh(),sqrt(),strcat(), strchr(),strcmp(),strcpy(), strcspn(),strlcat(),strlcpy(), strlen(),strncat(),strncmp(), strncpy(),strpbrk(),strrchr(), strspn(),strstr(),strxfrm(), tan(), tanh() | These functions are inherently thread-safe. |
| longjmp(), setjmp() | Although setjmp() and longjmp() keep data in __user_libspace, they call the __alloca_* functions, that are thread-safe. |
| remove(), rename(), time() | These functions use interrupts that communicate with the ARM debugging environments. Typically, you have to reimplement these for a real-world application. |
| snprintf(), sprintf(),vsnprintf(),vsprintf(), sscanf(),isalnum(),isalpha(), iscntrl(),isdigit(),isgraph(), islower(),isprint(),ispunct(), isspace(),isupper(),isxdigit(), tolower(),toupper(),strcoll(), strtod(),strtol(),strtoul(), strftime() | When using these functions, the string-based functions read the locale settings. Typically, they are thread-safe. However, if you change locale in mid-session, you must ensure that these functions are not affected.The string-based functions, such as sprintf() and sscanf(), do not depend on the stdio library. |
| stdin, stdout, stderr | These functions are thread-safe. |

线程不安全函数



