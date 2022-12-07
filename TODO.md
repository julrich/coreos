# TODO (neu: 28.04.2019)
* Folgende Dateien / Orte müssen bzgl. duplizierter TYPO3 Services (Entfernen von v7) nachgelagert aufgeräumt werden:
    * Ordner in nfssharettt1 (typo3 vs typo3-v7)
    * Unit-Files in `services/`
    * Entsprechende Ordner anlegen (`typo3/`); vgl. `-install`
    * Nginx Unit muss neu submitted und gestartet werden, damit `-proxyupdaer`-Services auch für `.review`-Systeme, jetzt nach Entfernen von Varnish, funktionieren
    * Nach Abschluss muss in Nginx Unit der `-v7`-Service entfernt werden, lediglich noch als Fallback / Backwards-compatibility drin
    * Prometheus-Konfiguration updaten auf Server, neu starten
    * Doppelten Block in `prometheus.toml` entfernen, Fallback / Backwards-compatibility für alte `-v7`-Services
    * Drei doppelte Blöcke in `prometheus.yml.tmpl` entfernen, Fallback / Backwards-compatibility für alte `-v7`-Services
    * Zuätzliche Unit `tika.service` an den Start bringen (`tika.services.ruhmesmeile.local`), ersetzt `typo3-tech-tika.service` und `typo3-review-tika.service`
    * `.data.data.solrPasswords` in Vault hinterlegen für `bamboo-specs/src/main/resources/build-distribution/03-write-environment-files.sh`, muss pro migriertem Projekt gesetzt werden
    * Prüfen ob bei Deployment auch Multi-Instance Solr korrekt behandelt wird
* Dopplung in TYPO3-Units (`-review` vs `-tech`) wo möglich auflösen
* Elegantere Lösung für Hosting von Solr Production-Units
* Solr-Units alle neu submitten / restarten, mit korrekter, vorhandener Solr-Version `7.5.2`. Teilweise `7.5.1` eingetragen gewesen
* Permission-Fix (`chmod a+?`) von SUPRA (`Makefile`) übertragen, dürfte wahrscheinlich bei jedem Projekt sinnvoll sein (evtl. nur `u+?`)
* Performance-Plan Verbesserungen:
    * Eigener Buildplan für Live-Seite (nicht (!) `.solutions`, Live-Domain), Scan-Interval konfigurierbar (z.B. für GoLive-Vergleiche wie aktuell für Deloro)
    * `.solutions`-Buildplan aus aktuellem Performance-Plan muss einzeln deaktivierbar sein, damit nach GoLive das `.solutions`-System nicht mehr getestet wird
* Maschinen-Konfiguration Services `MomCorpBIL` ins Repository übertragen (e.g. `Nextcloud` config)

# TODO (neu: 30.01.2019)

* Maschinenkonfigurationen von TTT-Maschinen lokal ablegen (z.B. Nginx Config in: /var/nginx/data/conf/nginx.conf, wahrscheinlich für Nginx in TYPO3-Containers(?))


# TODO:

* Nginx als Instance-Units neu starten
* Cluster-Alerts besser fein-tunen
* SkyDNS und Registrator Frequenz fixen
* Memory-Limits für Container, wo sinnvoll (re: Scheduling)
* Backups
* Dashboards auf neuen PMM-Stand bringen, entsprechend Dashboards wieder ins Repo legen auf aktuellem Stand. Evtl. auch Folder nutzen
* RAM in MySQL-Containern erhöhen
* Für Bamboo nur grosse / relevante Daten auf NFS auslagern, wahrscheinlich Performance-Einbussen aktuell durch NFS-Storage (Builds sind seit einiger Zeit spürbar langsamer)
* TYPO3: Permission denied bei lokalem Fileimport fixen
* Nimbus Bridge um JIRA / Confluence erweitern

# TODO:
* Maschinen neu starten
* calculon1 ersetzen && SSH-Bastionhost Node konfigurieren + Vault verschieben
* Crowd SSO + Vault-Anbindung
* AWS root-key aus coreos-Repository (/environments/) verschieben (entweder in certificates-Repo, oder aber in Vault)
* Eigene CA auch in Vault nutzen, wenn sinnvoll
* Maschinen-Zugang ausser julrich-Key auf Vault umstellen
* Vault-Infos am Ende des Unit-Files hinzufügen bzgl. Unseal
* TODO.md in JIRA übertragen
* Atlassian-Tools auf aktuelle Versionen bringen
* Repository wieder auf Stand bringen (+Tickets)
* Rundmail (statt Infrastructure Weekly), Änderungen der letzten Wochen beschreiben, auf Commits verweisen, erstes Treffen Teams doodlen -> Thema: Einführung Infrastruktur, Was ist ein Cluster?, Wie nutzen wir den Cluster? Wo finde ich Informationen zum Cluster?
* statics wieder alle an den Start bringen
* Backup-Script wieder an den Start bringen (Performance, kann aktuell kaum durchkommen)
* Backup über .timer-Unit in Infrastruktur starten
* Rolling Backups auf Backblaze o.ä., siehe Ticket
* Tmux Serverside?
* Wieso verliert Solr auf MomCorpFDC bei Restart immer Daten? Re-Index in Projekt notwendig (Probleme mit Docker, Volumes, bei Restart der Maschine?)
* Anleitung: Was muss bei Onboarding in der Infrastruktur hinzugefügt werden (Einträge cloud-configs für TTT-Maschinen, Keys, Benutzer, etc)
* Neues Confluence-Board Team Bonn mit sinnvollen Links in die wichtigsten Spaces
* Vor Urlaub Quickstart noch mit aktuell auftauchenden Problemen auf Stand bringen für Thorsten
* util.sh-Script zum Aktualiseren der eigenen ~/.ssh/config aus /templates/cluster-ssh-hosts
* Auf aktuelle Atlassian-Images für Docker umstellen
* Docker API-Version in Bamboo auf Stand bringen
* Crowd-URLs verschönern: -> crowd.ruhmesmeile.tools, id.ruhmesmeile.tools, openid.ruhmesmeile.tools
* DB-Connections PostgreSQL in Vault rausziehen (aktuell: JIRA, Bitbucket, Confluence, Bamboo, Crowd)
* Backup-Script läuft nur wenn in Terminal Aktivität??!
* Fix 1Password-Erkennung für Atlassian-Logins (RM Bamboo...)
* User / Usergroups in Crowd aufräumen / konsolidieren
* Hard-coded 10.x IP in Remote Access für Apps (JIRA, Bitbucket, ...) bei Crowd durch belastbare Lösung ersetzen
* Mixed Content in Bitbucket: Avatare nicht über https aktuell!!
* Remember Me in Atlassian Tools abschalten
* Atlassian-Unit Dependencies fixen: -jira.service, +crowd.service, wo notwendig (sollte eigentlich nicht)
* Application Link Atlassian Tools (JIRA, Confluence, Bitbucket, Bamboo) -> Crowd, und zurück
* crowd.properties Files in configs/-Verzeichnis
* Bamboo zu voll: Evtl noch Artifacts in /var/atlassian/bamboo, welches aktuell durch NFSShare-Mount nur "shadowed" sind, also noch Platz belegen?
* php-nginx-typo3 Image: 7.1 branch auf master mergen, und entsprechend alle docker-compose und Unit-Files nachziehen / auf php-nginx-typo3:latest ändern
* Load-Balancer gibt Container-IP an Crowd weiter, sollte aber wahrscheinlich die tatsächliche Client-IP durchreichen, damit wir bei Wechsel die Session clearen können
* MomCorpDOOP durch stärkere Maschine ersetzen, altes MomCorpDOOP -> MomCorpSTATIC
* Sidespeed für unsere Infrastruktur nach Vorbild der Taktsoft-Konfiguration wieder an den Start bringen (aktuell alle Buildpläne im Bamboo deaktiviert)


# Manchmal Fehler:

Access is denied; authenticated principal: org.acegisecurity.providers.anonymous.AnonymousAuthenticationToken Username: anonymousUser; Password: [PROTECTED]; Authenticated: true; Details: org.acegisecurity.ui.WebAuthenticationDetails: RemoteIpAddress: SessionId: Granted Authorities: ROLE_ANONYMOUS; secure object: com.atlassian.bamboo.webwork.StarterAction; configuration attributes: [WW_READ, GLOBAL_READ]


# Vor Urlaub:
* Tobi -> Service vorbesprechen, Abstimmung Landschaftsprojekt
* Release KBAP auf Live-System
* Bamboo Specs finalisieren
* Checkout Landschaftsprojekt
* Static KBAP-Flash Messages
* Dachser
