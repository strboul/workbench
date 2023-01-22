#!/bin/sh
pass="$(git rev-parse --show-toplevel)/vault_passphrase.gpg"
/usr/bin/gpg --batch --use-agent --decrypt "$pass"
