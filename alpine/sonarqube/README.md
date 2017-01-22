
# sonarqube

[![Build Status]()

SonarQube（曾用名Sonar（声纳）[1]）是一个开源的代码质量管理系统。


## Install

安装:

    docker pull sonarqube:alpine
    https://docs.sonarqube.org/display/PLUG/Plugin+Library
    https://github.com/SonarQubeCommunity/sonar-l10n-zh/releases/tag/sonar-l10n-zh-plugin-1.14

## Usage

    docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube:alpine
    
    http://127.0.0.1:9000/account/  admin/admin

### 特征

支持超过25种编程语言[2]：Java、C/C++、C#、PHP、Flex、Groovy、JavaScript、Python、PL/SQL、COBOL等。（不过有些是商业软件插件）

可以在Android开发中使用

提供重复代码、编码标准、单元测试、代码覆盖率、代码复杂度、潜在Bug、注释和软件设计报告[3][4]

提供了指标历史记录、计划图（“时间机器”）和微分查看

提供了完全自动化的分析：与Maven、Ant、Gradle和持续集成工具（Atlassian Bamboo、Jenkins、Hudson等）[5][6][7]

与Eclipse开发环境集成

与JIRA、Mantis、LDAP、Fortify等外部工具集

支持扩展插件[8][9]

利用SQALE计算技术债务[10]

支持Tomcat。不过计划从SonarQube 4.1起终止对Tomcat的支持[11]。

```

```
