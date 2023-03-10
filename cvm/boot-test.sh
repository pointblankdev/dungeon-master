#!/bin/zsh
# clarity-cli and jq required.
cd "$(dirname "$0")"
deployer=$(cat initial-allocations.json | jq ".[0].principal" -r)
deploy_order=(
	# traits
	"traits/extension-trait.clar" "traits/governance-token-trait.clar" "traits/ownable-trait.clar" "traits/proposal-trait.clar" "traits/sip010-ft-trait.clar"
	# DungeonMaster
	"dungeon-master.clar"
	# Extensions
	"extensions/dme000-governance-token.clar" "extensions/dme001-proposal-voting.clar" "extensions/dme002-proposal-submission.clar" "extensions/dme003-emergency-proposals.clar" "extensions/dme004-emergency-execute.clar" "extensions/dme005-dev-fund.clar"
	# Proposals
	"proposals/dmp000-bootstrap.clar" "proposals/dmp001-dev-fund.clar" "proposals/dmp002-kill-emergency-execute.clar"
	)
vmstate="vmstate.db"

rm -rf "$vmstate"
clarity-cli initialize --testnet initial-allocations.json "$vmstate"
for contract in "${deploy_order[@]}"; do
	echo "LAUNCH $contract"
	clarity-cli launch "$deployer.$(basename $contract .clar)" "../contracts/$contract" "$vmstate"
done
echo "BOOTSTRAP"
result=$(clarity-cli execute "$vmstate" "$deployer.dungeon-master" "construct" "$deployer" "'$deployer.dmp000-bootstrap")
if [[ $(echo $result | jq ".success") == "true" ]]; then
	echo "OK"
else
	echo "FAILED"
	exit 1
fi
rm -rf "$vmstate"
