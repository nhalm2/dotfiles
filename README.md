# dotfiles

## Checkout

```
git clone --recursive ....
```

## Add a new plugin

All the plugins are git submodules.  To add a new one run the command:
```
git submodule add https://github.com/<some_name> vim/bundle/<some_name>
```

## Get latest changes
```
git pull origin maset
git submodule update --rebase --recursive --remote --init
./initial_setup.sh
```

