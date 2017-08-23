## SLURM PILLARS DOCUMENTATION

- init.sl: definition.

 slurm:
 
 >ClusterName: --> define cluster name.
 
 >ControlMachine:  --> hostname of slurm master
 
 >ControlAddr: --> IP of slurm master
 
 >BackupController:  --> hostname of secondary mater (optional)
 
 >BackupAddr: --> IP of slurm secondary master (optional)
 
 >CheckpointType: --> type of checkpoiting (optional)
 
 >AuthType:  --> auth type (optinal )
 
 >CryptoType:  --> crypto Type (optinal )
 
 >AccountingStorageType: slurmdbd (optinal )
 
 >Frontends: --> frontend definition
   
 
``` 
    UI01:
      State: UNKNOWN
      AllowGroups: Alcegroup
      AllowUsers: Alice
    Ui02:
      State: UNKNOWN
      AllowGroups: bobsgrup
      AllowUsers: Bob
```
Partition definionon on init.sl.
 
 >partitions:
 >>fast: ```--> partition name ```
 >>>Priority: 1 ``` --> partition properties```
 
 >>>MaxTime: 01:00:00 ``` --> partition properties```
 
 >>>Default: 'No' ``` --> partition properties```.
 
 >>>State: UP ``` --> partition properties```.
 
 >>>Shared: 'YES' ``` --> partition properties```.
 
 >>>nodes: ``` --> list of nodes ```
 >>>> - node001
 >>>> - node002
 >>>> - node003
 >>>> -    ...
 
 ```
    short:
      Priority: 2
      MaxTime: 06:00:00
      Default: 'yes'
      State: UP
      Shared: 'YES'
      nodes:
        - node012
        - node013
        - node014
        - ...
 ```
 
Node definintion on init.sl  
```
nodes:
    Standar_config:
      - node001
      - node002
      - node003
      ...
    Standar_config_oldgpu:
      - node004
      - node005
      ...
```
  - Standar_config --> is defined on nodedef.sl is de node definition
  - Standar_config_oldgpu --> is defined on nodedef.sl is de node definition 
- nodedef.sl: file where we have the definition of the nodes
```
nodedef:
  Standar_config: 
      CPUS: 32
      RealMemory: 128
      Sockets: 2
      CoresPerSocket: 8
      ThreadsPerCore: 2
      State: UNKNOWN
      TmpDisk: 55212
      Feature: HyperThread
```
   - Standar_config: name config, we can use this definition on the 
    
## SLURM CONFIG

We have two slurm master nodes 
 - slurm01: (10.100.1.160) is the principal slurm master and it has the slurmdbd 
with the mysql accounting database
 - slurm02: (10.100.1.170) is the secondary server but it has not the accounting 
database in the future we move mysql accounting database to other node in terms
of reliability
 - Partitions: we have only a default partition with 9 nodes
 - The authentication method is munge using de ldap users
 - The accounting use mysql database on slurm01
 - The checkpointing is configured using blr

#### PARTITIONS

we have 4 partitions

|PARTITION| AVAIL | TIMELIMIT | NODES|  NODELIST         |
|---------|------ |-----------|------|-------------------|
|medium   |   up  |2-00:00:00 |     6| hpcnode[002-007]  |
|short*   |   up  |   6:00:00 |     9| hpcnode[003-0012] |
|long     |   up  |30-00:00:00|     4| hpcnode[001-005]  |
|beamlines|   up  |   1:00:00 |    12| hpcnode[001-0012] |



## SLURM ALBA INSTALLATION IN NUMBERS

we have 144 cores with 1,125TB of memory distributed on  9 fujitsu nodes (hpcnode001-hpcnode009)
We are using slurm as a batch system with MPICH3 alias hydra in all nodes. The nodes are interconnected with one link of
10Gb ethernet.

#### USERS and ACCOUNTS
##### Accounts

|Account|Descr|Org|
|-------|-----|---|
|accelerators|accelerators|accelerators|
|arcimboldo|arcimboldo|bl13|
|autoproc|autoproc|bl13|
|bl13|bl13|beamlines|
|experiments|experiments seccion|experiments|
|fluka|fluka|safety|
|pelegant|pelegant|accelerators|
|root|default root account|root|
|safety|safety seccion|safety|
|systems|systems accout|alba|
|wien2k|runing wine2k|experiments|
|xaloc|xaloc beamline|bl13|

##### Users
|User|Def Acct|Admin|
|-----|-------|-----|
|acastellvi|xaloc|None|
|adevienne|safety|None|
|aziem|xaloc|None|
|epellegrin|wien2k|None|
|fgil|xaloc|None|
|icrespo|xaloc|None|
|jandreu|xaloc|None|
|juanhuix|xaloc|None|
|ltorino|accelerators|None|
|marrodriguez|xaloc|None|
|mroda|xaloc|None|
|ngonzalez|xaloc|None|
|prejmak|wien2k|None|
|rboer|xaloc|None|
|roliete|xaloc|None|
|root|root|Administrator|
|set|wien2k|None|
|tguevara|xaloc|None|
|u2013100606|xaloc|None|
|xfarina|xaloc|None|
|ysyryanyy|wien2k|None|
|zeus|pelegant|None|


### PERFORMANCE

| OSU MPI Latency Test one node | OSU MPI Latency Test two node  |
|-------------------------------|--------------------------------|

|# Size|            Latency (us)|# Size|            Latency (us) |
|------|------------------------|------|-------------------------|
|0|                       0.51  |0     |                   24.50 |
|1|                         0.48  |1     |                   24.50 |
|2|                         0.46  |2     |                   24.50|
|4|                         0.44  |4    |                    24.50|
|8|                         0.42  |8     |                   24.50|
|16|                        0.42  |16    |                   24.50|
|32 |                       0.44  |32    |                   24.50|
|64  |                      0.42 |64     |                  24.50|
|128  |                     0.43|128     |                  24.50|
|256  |                     0.46|256     |                 24.52|
|512  |                     0.48|512     |                 27.58|
|1024 |                     0.57|1024    |                 48.00|
|2048  |                    0.77|2048    |                 71.54|
|4096  |                    1.10|4096    |                222.41|
|8192  |                    1.91|8192    |                221.91|
|16384 |                    3.56|16384   |                230.33|
|32768  |                   6.44|32768   |                418.61|
|65536  |                  10.81|65536   |                741.72|
|131072 |                  19.21|131072  |               1504.61|
|262144 |                  36.52|262144  |               2521.02|
|524288 |                  68.09|524288  |               4768.35|
|1048576 |                130.65|1048576 |               9184.20|
|2097152 |                251.23|2097152 |              18208.04|
|4194304 |                499.27|4194304 |              36063.12|


## SLURM TRICK

### PUT ON DRAIN STATUS
```
scontrol: update NodeName=hpcnode001 State=DRAIN
```
### PUT NODE IN IDLE STATUS FROM STATUS DRAIN
- from drain you put firs on status DOWN
```
scontrol: update NodeName=hpcnode01 State=DOWN Reason="undraining"
```
- from down you resume node status
```
scontrol: update NodeName=hpcnode001 State=RESUME
```
- you can verify ne status
```
scontrol: show node hpcnode001
```
### Reconfigure all SLURM daemons on all nodes.
- This should be done after changing the SLURM configuration file.
```
scontrol:  reconfig
```
#### Print the current SLURM configuration
```
scontrol show config
```
#### Shutdown all SLURM daemons on all nodes.
```
scontrol shutdown
```