include:
  - slurm/nodedef
slurm:
  ClusterName: "ClusterName"
  ControlMachine: 'slurmMaster'
  ControlAddr: 10.xx.xxx.xxx
  BackupController: 'slurmSlave'
  BackupAddr: 10.xx.xx.xx
  CheckpointType: 'dmtcp'
  AuthType: 'munge'
  AuthInfo: '/var/run/munge/munge.socket.2'
  ConstrainCores: 'yes'
  AccountingStorageType: slurmdbd
  TaskPlugin: 'cgroup'
  SlurmctldLogFile: '/var/log/slurm/slurmctld.log'
  SlurmdSpoolDir: '/var/run/slrum/slurmd.%n.spool'
  SlurmUser: 'slurm'
  #SlurmdUser=
  #SrunEpilog=
  #SrunProlog=
  StateSaveLocation: '/var/spool/slurm'
  AccountingStorageHost: 'slurmdbNode'
  AccountingStoragePass: 'slurmPass'  
  AccountingStorageUser: 'slurmUser'
  SlurmDBStorageType: 'mysql'
  PropagateResourceLimitsExcept: 'MEMLOCK'
  JobCompLoc: /var/log/slurm/slurm_jobcomp.log
  PrivateData: "usage"
  MaxArraySize: 100001
  MaxJobCount : 5000001
  PriorityType: 'multifactor'
  ProctrackType: 'cgroup'
  JobacctGatherType: 'cgroup'
  MailProg: '/bin/mail'
  AcctGatherEnergyType: 'none'
  GresTypes: 'gpu'
  Frontends:
    loginNode01:
      State: UNKNOWN
      AllowGroups: group01
      AllowUsers: user01
  nodes:
    typeA:
      - node001
      - node002
      - node003
      - node006
      - node007
      - node011
      - node004
      - node005
    typeD:
      - node008
      - node009
      - node010
    typeC:
      - node14

  partitions:
    small:
      AllowAccounts: accout01,account92
      AllowGroups: ALL
      Priority: 500
      MaxTime: 06:00:00
      Default: 'No'
      State: UP
      Shared: 'YES'
      nodes:
        - node001
        - node002
        - node003
        - node004
        - node005
        - node006
        - node007
        - node008
        - node009
        - node010
        - node011
    short:
      Priority: 2
      MaxTime: 08:00:00
      Default: 'yes'
      State: UP
      Shared: 'YES'
      nodes:
        - node002
        - node003
        - node004
        - nodeode005
        - node006
        - node007
        - node008
        - node009
        - node010
        - node011
    long:
      Priority: 4
      MaxTime: 29-00:00:01
      Default: 'No'
      State: UP
      Shared: 'YES'
      PreemptMode: 'OFF'
      nodes:
        - node007
        - node008
        - node009
        - node010
        - node011
    GPU:
      Priority: 4
      MaxTime: 29-00:00:01
      Default: 'No'
      State: UP
      Shared: 'YES'
      PreemptMode: 'OFF'
      nodes:
        - node14






