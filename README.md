# Spamassassin in Docker

Spamassassin in a Docker container.

spamassassin version: 3.4.6-r7

```bash
mkdir -pv /opt/spamassassin/etc/mail/spamassassin
mkdir -pv /opt/spamassassin/var/log
mkdir -pv /opt/spamassassin/var/lib/spamassassin
mkdir -pv /opt/spamassassin/tmp/.spamassassin
```

```bash
cat <<EOF > /opt/spamassassin/etc/mail/spamassassin/local.cf
required_hits 5
report_safe 0
rewrite_header Subject [SPAM]

add_header all Dyn2 OUI

bayes_path /tmp/.spamassassin/bayesdb/bayes

user_awl_dsn                 DBI:mysql:spamassassin:127.0.0.1:3306
user_awl_sql_username        spamassassin
user_awl_sql_password        pass123
user_awl_sql_table           txrep

bayes_sql_dsn                DBI:mysql:spamassassin:127.0.0.1:3306
bayes_sql_username           spamassassin
bayes_sql_password           pass123

user_scores_dsn              DBI:mysql:spamassassin:127.0.0.1:3306
user_scores_sql_username     spamassassin
user_scores_sql_password     pass123
user_scores_sql_custom_query SELECT preference, value FROM _TABLE_ WHERE username = _USERNAME_ OR username = '$GLOBAL' OR username = CONCAT('%',_DOMAIN_) ORDER BY username ASC

use_auto_whitelist           1

auto_whitelist_factory       Mail::SpamAssassin::SQLBasedAddrList
bayes_store_module           Mail::SpamAssassin::BayesStore::MySQL
txrep_factory                Mail::SpamAssassin::SQLBasedAddrList

EOF
```

```bash
cat <<EOF > /opt/spamassassin/etc/mail/spamassassin/init.pre
# URIDNSBL - look up URLs found in the message against several DNS
# blocklists.
#
loadplugin Mail::SpamAssassin::Plugin::URIDNSBL

# SPF - perform SPF verification.
#
loadplugin Mail::SpamAssassin::Plugin::SPF

# TxRep - Reputation database that replaces AWL
loadplugin Mail::SpamAssassin::Plugin::TxRep

# HashBL - Query hashed/unhashed strings, emails, uris etc from DNS lists
loadplugin Mail::SpamAssassin::Plugin::HashBL

# Phishing - finds uris used in phishing campaigns detected by
# OpenPhish or PhishTank feeds.
loadplugin Mail::SpamAssassin::Plugin::Phishing

EOF
```

```bash
export SPAMDOPTIONS="--pidfile=/var/run/spamassassin.pid --create-prefs --max-children=8 --min-children=1 --listen=0.0.0.0 --setuid-with-sql --nouser-config --syslog=/var/log/spamd.log -u nobody"
```

```bash
spamassassin -D --lint
echo -e "From: myself@mymailserver.net\nTo:myfriend@domain.net\nSubject: test\n\n" | spamc
```

```bash
podman run \
  --name spamassassin \
  --detach \
  --net host \
  --pid host \
  -ti \
  -p 783:783 \
  -e SPAMDOPTIONS="--pidfile=/var/run/spamassassin.pid --create-prefs --max-children=8 --min-children=1 --listen=0.0.0.0 --setuid-with-sql --nouser-config --syslog=/var/log/spamd.log -u nobody" \
  -v "/opt/spamassassin/etc/mail/spamassassin/local.cf:/etc/mail/spamassassin/local.cf" \
  -v "/opt/spamassassin/etc/mail/spamassassin/init.pre:/etc/mail/spamassassin/init.pre" \
  -v "/opt/spamassassin/var/log:/var/log" \
  -v "/opt/spamassassin/var/lib/spamassassin:/var/lib/spamassassin" \
  -v "/opt/spamassassin/tmp/.spamassassin:/tmp/.spamassassin" \
  reinventedstuff/spamassassin-docker:3.4.6
```


```bash
docker manifest create \
  reinventedstuff/spamassassin-docker:3.4.6 \
  --amend reinventedstuff/spamassassin-docker:3.4.6-amd64 \
  --amend reinventedstuff/spamassassin-docker:3.4.6-arm64v8

```