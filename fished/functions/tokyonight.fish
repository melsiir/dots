# . ~/projects/tokyonight.nvim/extras/fish/tokyonight_night.fish

set style storm
set theme tokyonight_{$style}

set src ~/.local/share/nvim/lazy/tokyonight.nvim/extras/fish_themes/{$theme}.theme
set dst ~/.config/fish/themes/{$theme}.theme

[ -L $dst ]
or ln -s $src $dst

fish_config theme choose $theme

