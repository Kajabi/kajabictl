# kajabictl

## Usage

```sh
kajabictl help
```

You might want to create an alias:

```sh
# ~/.bashrc
alias kj="kajabictl"
```

## Installation

### Dependencies

```
brew bundle --no-lock
```

### Install

Here's one way you could install `kajabictl` in your `$HOME` directory:

    cd
    git clone https://github.com/Kajabi/kajabictl.git .kajabictl

For bash users:

    echo 'eval "$($HOME/.kajabictl/bin/kajabictl init -)"' >> ~/.bash_profile
    exec bash

For zsh users:

    echo 'eval "$($HOME/.kajabictl/bin/kajabictl init -)"' >> ~/.zshenv
    source ~/.zshenv

You could also install your sub in a different directory, say `/usr/local`.

## License

MIT. See `LICENSE`.
