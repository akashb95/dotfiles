1. Clone repo.
   ```shell
   mkdir ~/.config
   git clone https://github.com/akashb95/dotfiles.git ~/.config
   ```
1. Install Homebrew: https://brew.sh
1. Install packages: `cd ~/.config && brew bundle`

If you need to install a package on Nix ad-hoc, then run `nix profile install nixpkgs#...`. 
Remove using `nix profile remove ...`. Do not preprend nixpkgs.
If you need to run a package on Nix like a demo, then run `nix run nixpkgs#...`. 
