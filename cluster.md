## Rechencluster des Lehrstuhls für Betriebssysteme
Dieses Dokument soll dabei helfen sich auf dem Cluster des Lehrstuhls für Betriebssysteme zurechtzufinden

### Aufbau
Der Cluster besteht aus 32 Knoten (_node49_-_node80_) und dem zusätzlichen Login-Knoten _sollipulli_.  
_node49_-_node72_ verfügen jeweils über 240 Gigabyte schnellen SSD-Speicher, sowie 1 Terabyte HDD-Speicher, ab _node73_ stehen 480 Gigabyte und 1 Terabyte HDD-Speicher bereit.

Bei _node49_-_node64_ kommt als Prozessor ein _Xeon E3-1220_  zum Einsatz, bei _node65_-_node80_ jeweils ein etwas leistungsfähigerer _Xeon E5-1650_ mit 64 Gigabyte Arbeitsspeicher. Beide CPUs basieren auf Intels _Sandy Bridge_ Architektur.  

_node49_-_node56_ verfügen über 16 Gigabyte Arbeitsspeicher, _node57_-_node64_ über 32 Gigabyte, und bei _node65_-_node80_ sind es 64 Gigabyte.

Alle 32 Rechner sind per Gigabit-Ethernet miteinander verbunden.  
_node49_-_node56_ verfügen zusätzlich noch über 40 Gigabit Infiniband, _node65_-_node80_ sogar über 56 Gigabit Infniband.

### Container
Statt direkt auf den Knoten zu arbeiten, hat jeder Nutzer einen eigenen Container, der auf den Knoten gestartet wird. Hierfür wird _systemd-nspawn_ verwendet.  
Das home-Verzeichnis jedes Nutzers liegt auf einem verteilten Dateisystem. Dateien, die auf einem Knoten geschrieben werden, sind somit auch auf allen anderen Knoten verfügbar.

### Login
Der Zugriff auf das Rechencluster erfolgt über den Login-Knoten _sollipulli_.   Diesen erreicht man mit dem folgenden Befehl:

> ssh loginname@sollipulli

Um nun mit den Knoten zu arbeiten gibt es den Befehl _node_. Zunächst sollte man sich eine Liste aller Knoten ausgeben und gucken, welche gerade frei sind:

> user@sollipulli:~$ node status  
> node49 up: username (active)  
> node50 up: \*free\*  
> node51 up: username (active)  
> node52 up: username (active)  
> node53 up: \*free\*  
> node54 up: username (active)  
> node55 up: username (active)  
> node56 up: username (active)  
> node57 up: username (active)  
> node58 up: username (active)  
> node59 up: username (active)  
> node60 up: username (active)  
> node61 up: username (active)  
> node62 up:  \*free\*  
> node63 up: username (active)  
> node64 up: username (active)  
> node65 up: username (active)  
> node66 up: username (active)  
> node67 up: username (active)  
> node68 up: username (active)  
> node69 up: username (active)  
> node70 up: username (active)  
> node71 up: username (active)  
> node72 up: username (active)

In diesem Beispiel sind alle Knoten bis auf _node50_,  _node53_ und _node62_ belegt.  
Um sich nun einen Knoten zu reservieren, benutzt man _node alloc_:

> user@sollipulli:~$ node alloc node62  
> Booting container on node62...  
> No container for user user available, deploying default container...  
> Checking for disk space...  
> Sufficient disk space available, deploying...  
> Booting container of user ruhland...  
> Created symlink from /etc/systemd/system/custom.target.wants/node.service to /etc/systemd/system/node.service.  
> node62 allocated

Wenn man einen Knoten zum ersten Mal reserviert, dauert der Vorgang ca. eine Minute.  
Anschließend kann man sich per _ssh_ auf dem reservierten Knoten einloggen:

> user@sollipulli:~$ ssh node62  
> Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-116-generic x86_64)

> \* Documentation:  https://help.ubuntu.com  
> \* Management:     https://landscape.canonical.com  
> \* Support:        https://ubuntu.com/advantage

> Try to login on 10.0.0.62  
> Login successful.  
> ruhland@node62:~$

Wenn man mit der Arbeit fertig ist, kann man den Knoten mit _exit_ wieder verlassen. Anschließend sollte man ihn wieder freigeben, damit auch andere auf dem Cluster arbeiten können:

> user@node62:~$ exit  
> logout  
> user@sollipulli:~$ node free node62  
> Removed symlink /etc/systemd/system/custom.target.wants/node.service.  
> node62 free'd

### _node_-Befehle
Neben den bereits vorgestellten Befehlen  _node status_,  _node alloc_ und _node free_, gibt es noch einige Weitere. Im Folgenden werden alle Befehle aufgelistet und erläutert:

* **node ls**
 Gibt eine einfache Liste aller Knoten aus.

* **node ls-alive**
Gibt eine Liste aller Knoten aus, die gerade online sind.  
Knoten, die gerade nicht verfügbar sind, zum Beispiel weil sie gewartet werden, werden hier nicht angezeigt.

* **node hwinfo**
Gibt eine Liste aller Knoten und deren Hardware aus.  
Wenn man zum Beispiel mit einer Infiniband-Anwendung arbeiten möchte, kann man mit diesem Befehl gucken, welche Knoten überhaupt über einer Infiniband-Anbindung verfügen.

* **node status**
Gibt eine Liste aller Knoten aus, und zeigt an, welcher Knoten gerade von welchem Nutzer reserviert ist.

* **node ls-alloc**
Gibt eine Liste aller Knoten aus, die man selber reserviert hat.

* **node alloc <knoten\>**
Reserviert einen Knoten

* **node alloc-n <anzah\>**
Versucht eine gegebene Anzahl an Knoten auf einmal zu reservieren.  
Dieser Befehlt schlägt fehl, wenn nicht genügend freie Knoten verfügbar sind.

* **node alloc-range <start\> <ende\>**
Versucht eine Reihe von Knoten zu reservieren.  
Mit _node alloc-range node53 node58_ würde man zum Beispiel versuchen, die Knoten _node53_-_node58_ zu reservieren. Ist einer der Knoten nicht verfügbar, so wird dieser übersprungen. Die restlichen Knoten werden jedoch trotzdem reserviert.

* **node free <knoten\>**
Gibt einen vom aktuellen Nutzer reservierten Knoten wieder frei.

* **node free-all**
Gibt alle vom aktuellen Nutzer reservierten Knoten wieder frei.

### Arbeiten auf dem Cluster
Ist man auf einem Knoten eingeloggt, kann man auf diesem ganz normal arbeiten. Ein paar Kleinigkeiten sind jedoch zu beachten:

* Braucht ein Programm root-Rechte, kann man _sudo_ mit dem Parameter _-P_ verwenden 
 > sudo -P apt install nano
 * Man hat keinen Schreibzugriff auf das _proc_-Dateisystem. Einige verteilte Anwendungen (darunter auch DXRAM) werden sich beschweren, dass sie nicht nach _/proc/sys/net/core/_ schreiben können um die TCP-Buffergröße zu erhöhen. Diese Warnung kann in der Regel ignoriert werden, da die Anwendung trotzdem laufen sollte.
* Wie oben bereits erwähnt, ist es nicht nötig, Dateien auf mehrere Knoten zu kopieren. Erstellt man eine Datei auf einem Knoten, so ist sie auch auf allen anderen verfügbar.
* Zusätzliche Pakete können wie gewohnt mit dem Paketmanager _apt_ installiert werden, jedoch wird ein Paket immer nur auf dem aktuellen Knoten installiert. Braucht man es auf mehreren Knoten, so muss es auf jedem einzeln installiert werden.

Um Dateien auf den Cluster zu kopieren, kann entweder _scp_, oder _sftp_ verwendet werden.

### Einloggen per SSH-Key
Damit man nicht jedes Mal, wenn man sich auf einem Knoten einloggt, sein Passwort eingeben muss, ist es sinnvoll sich mit einem SSH-Schlüssel einzuloggen.  
Hierzu führt man zunächst das Skript [sshkeypairing.sh](https://github.com/hhu-bsinfo/cluster/blob/master/sshkeypairing.sh) auf seinem lokalen Rechner aus. Anschließend muss noch das Skript [sshkeypairingnode.sh](https://github.com/hhu-bsinfo/cluster/blob/master/sshkeypairingnode.sh)
auf einem der Knoten ausgeführt werden.  
Von nun an kann man sich von seinem lokalen Rechner aus direkt auf einem reservierten Knoten einloggen.

### Bekannte Problemstellung
Gelegentlich kommt es vor, dass bei der Kompilierung mittels des _build.sh_ Skripts eine Fehlermeldung der Form

> Could not resolve all artifacts for configuration ':classpath'.
> ...
> org.apache.http.ssl.SSLInitializationException: /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts (Permission denied)

auftritt. Hierbei schafft das Entfernen der Pakete _openjdk-8-jdk_ und _java-common_ mit dem Befehl

> sudo -P apt purge openjdk-8-jdk java-common

und die anschließende Neuinstallation mittels

>sudo -P apt install openjdk-8-jdk
 Abhilfe.