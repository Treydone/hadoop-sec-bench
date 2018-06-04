# hadoop-sec-bench

hadoop-sec-bench is a security best practices assessment, auditing, hardening and forensics readiness tool for Hadoop clusters. The primary goal is to test security defenses and **provide tips for further system hardening**. It will also scan for general system information, vulnerable packages, and possible configuration issues.

## Goals

The main goals are:
- Automated security auditing
- Compliance testing
- Vulnerability detection
- Configuration and asset management
- Software patch management
- System hardening
- Penetration testing (privilege escalation)
- Intrusion detection

## Audience

- System administrators
- Auditors
- Security officers
- Penetration testers
- Security professionals

## Disclaimers

- These benchs aren't approved by the Center For Internet Security

## Platform

- HortonWorks
- Cloudera
- Vanilla Apache
- MapR

## Features

It covers hardening and security best practices for Hadoop clusters related to:

- Data Management
- Identity & Access Management
- Data Protection & Privacy
- Network Security
- Infrastructure Security & Integrity

## Running

Run with:
```
./run.sh --file mapping.json --dry --reporter json -vvvvvv
```

You need a JSON file with:

```
{
 "host1": {"target": "ssh://root:password@host1", "components": ["hdfs-client", "hbase-client"]},
 "host2": {"target": "ssh://root:password@host2", "components": ["hdfs-namenode", "hdfs-http", "hbase-master"]},
 "host3": {"target": "ssh://root:password@host3", "components": ["hdfs-datanode", "hbase-regionserver"]},
 "host4": {"target": "ssh://root:password@host4", "components": ["hdfs-secondarynamenode", "hbase-rest"]}
}
```

```
./run.sh -h
run.sh [OPTION...]
-f, --file           The json mapping file with argument (default: ./mapping.json)
-d, --dry            Dry run (default: 0)
-r, --reporter       InSpec reporter to use (default: cli)
-v, --verbose        Enable verbose output (include multiple times for more
                     verbosity, e.g. -vvv)
```

### Generating mapping file from Ambari

### Generating mapping file from Cloudera Manager

## Contribute

Do you have something to share? An idea? An issue?

## Authors

- Vincent Devillers

## License

hadoop-sec-bench is proudly powered by open source softwares and is free (like a bird) to download and use (and will always be) ...
Both source code and documentations are released under the GNU AGPLv3 license.
For more details, please read the file LICENSE included in the repo, in the archive or directly on the GNU project website http://www.gnu.org/licenses/agpl-3.0.html
