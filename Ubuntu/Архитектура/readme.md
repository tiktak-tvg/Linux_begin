```bash
Три порта Debian для ARM: Debian/armel, Debian/armhf и Debian/arm64.
Debian/armhf — это аббревиатура от « arm hard float », обозначающая порт на Debian. Порт Debian armhf был запущен для использования аппаратной поддержки модуля с плавающей запятой (FPU) на современных 32-битных платах ARM.
Он в основном используется для мобильных устройств (смартфонов, планшетов) и встроенных устройств.

Порт Debian/armel или ARM EABI или Embedded ABI в Debian был нацелен на более старые 32-битные процессоры ARM. Он не имеет аппаратной поддержки модуля с плавающей запятой (FPU). 

Debian/arm64 нацелен на 64-битные процессоры ARM, для которых требуется минимальная архитектура ARMv8. 64-битная обработка обеспечивает расширенные вычислительные возможности. 
Это улучшение обработки достигается за счет увеличения емкости адресации памяти в 64-битной архитектуре. 
Аппаратное обеспечение Arm64 было впервые выпущено для iPhone 5 в 2013 году. Имя gnu для ARM64 — aarch64-linux-gnu .
Он в основном используется для несколько устройств IoT, современные ноутбуки и настольные компьютеры, смартфоны и т. д.

root@ub01:~# uname -p
x86_64

Как узнать точную архитектуру процессора
root@ub01:~# dpkg --print-architecture
amd64

root@ub01:~# getconf LONG_BIT
64

root@ub01:~# readelf -A /proc/self/exe | grep Tag_ABI_VFP_args
root@ub01:~#
Если приведенная выше команда возвращает тег Tag_ABI_VFP_args, то это система armhf, тогда как пустой вывод показывает, что это система armel. 
Например, дистрибутив Raspberry вернет Tag_ABI_VFP_args: VFP регистрирует тег, поскольку это дистрибутив armhf. 
С другой стороны, дистрибутив Debian Wheezy с плавающей запятой выдаст пустой вывод, указывающий, что это дистрибутив armel.

root@ub01:~# lscpu
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   45 bits physical, 48 bits virtual
CPU(s):                          2
On-line CPU(s) list:             0,1
Thread(s) per core:              1
Core(s) per socket:              1
Socket(s):                       2
NUMA node(s):                    1
Vendor ID:                       GenuineIntel
CPU family:                      6
Model:                           165
Model name:                      Intel(R) Core(TM) i5-10400F CPU @ 2.90GHz
Stepping:                        3
CPU MHz:                         2903.995
BogoMIPS:                        5807.99
Hypervisor vendor:               VMware
Virtualization type:             full
L1d cache:                       64 KiB
L1i cache:                       64 KiB
L2 cache:                        512 KiB
L3 cache:                        24 MiB
NUMA node0 CPU(s):               0,1
Vulnerability Itlb multihit:     KVM: Vulnerable
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Not affected
Vulnerability Mmio stale data:   Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown
Vulnerability Retbleed:          Mitigation; IBRS
Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl and seccomp
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:        Mitigation; IBRS, IBPB conditional, RSB filling, PBRSB-eIBRS Not affected
Vulnerability Srbds:             Unknown: Dependent on hypervisor status
Vulnerability Tsx async abort:   Not affected
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxs
                                 r sse sse2 ss syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon nopl xtopology tsc
                                 _reliable nonstop_tsc cpuid pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movb
                                 e popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefe
                                 tch invpcid_single ssbd ibrs ibpb stibp fsgsbase tsc_adjust bmi1 avx2 smep bmi2 invpcid
                                  rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 xsaves arat flush_l1d arch_capabili
                                 ties
root@ub01:~#
root@ub01:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 165
model name      : Intel(R) Core(TM) i5-10400F CPU @ 2.90GHz
stepping        : 3
microcode       : 0xffffffff
cpu MHz         : 2903.995
cache size      : 12288 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon nopl xtopology tsc_reliable nonstop_tsc cpuid pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single ssbd ibrs ibpb stibp fsgsbase tsc_adjust bmi1 avx2 smep bmi2 invpcid rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 xsaves arat flush_l1d arch_capabilities
bugs            : spectre_v1 spectre_v2 spec_store_bypass swapgs itlb_multihit srbds mmio_stale_data retbleed
bogomips        : 5807.99
clflush size    : 64
cache_alignment : 64
address sizes   : 45 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 165
model name      : Intel(R) Core(TM) i5-10400F CPU @ 2.90GHz
stepping        : 3
microcode       : 0xffffffff
cpu MHz         : 2903.995
cache size      : 12288 KB
physical id     : 2
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 2
initial apicid  : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 22
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon nopl xtopology tsc_reliable nonstop_tsc cpuid pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single ssbd ibrs ibpb stibp fsgsbase tsc_adjust bmi1 avx2 smep bmi2 invpcid rdseed adx smap clflushopt xsaveopt xsavec xgetbv1 xsaves arat flush_l1d arch_capabilities
bugs            : spectre_v1 spectre_v2 spec_store_bypass swapgs itlb_multihit srbds mmio_stale_data retbleed
bogomips        : 5807.99
clflush size    : 64
cache_alignment : 64
address sizes   : 45 bits physical, 48 bits virtual
power management:
```
