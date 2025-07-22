# Isabella's nix-home

Getting started:

```sh
cd ~/.config
git clone git@github.com:CodeWitchBella/nix-home.git home-manager -b main
cd home-manager
nix run home-manager/master -- init --switch
```

Update lix:

```sh
sudo --preserve-env=PATH /nix/var/nix/profiles/default/bin/nix run \
    --experimental-features "nix-command flakes" \
    --extra-substituters https://cache.lix.systems --extra-trusted-public-keys "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=" \
    'git+https://git.lix.systems/lix-project/lix?ref=refs/tags/2.93.2' -- \
    upgrade-nix \
    --extra-substituters https://cache.lix.systems --extra-trusted-public-keys "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
```