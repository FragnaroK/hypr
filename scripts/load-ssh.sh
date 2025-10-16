eval "$(ssh-agent -s)"

# Add all private keys in ~/.ssh to the agent if not already added
if ssh-add -l | grep -q "no identities"; then
    for key in ~/.ssh/id_*; do
        # Only add if it's a private key file (skip .pub files)
        if [[ -f "$key" && ! "$key" =~ \.pub$ ]]; then
            ssh-add "$key"
        fi
    done
fi