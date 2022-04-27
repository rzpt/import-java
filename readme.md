Install the plugin
```
Plug 'rzpt/import-java'
```

Setup a repo
```
:call ImportJavaGenerate()
```

Bind the command
```
nmap <Leader>i <plug>(import-java-n)
```

Hide the import file globally
```
git config --global core.excludesFile '~/.gitignore'
echo .raw.import >> '~/.gitignore'
```
