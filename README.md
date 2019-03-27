LauDai dotfile config
===
Author: LauDai

How to use tmux
---

*My tmux configure is running in tmux 2.5 version*

#### Colors
In tmux Manual
```
The colour is one of: black, red, green, yellow, blue, magenta, cyan, white, aixterm bright variants (if supported: brightred, brightgreen, and so on), colour0 to colour255 from the 256-colour set, default, or a hexadecimal RGB string such as ‘#ffffff’, which chooses the closest match from the default 256-colour set.
```
#### Check your terminal color support colors
There are two file can test your terminal color

`$bash color_test1.sh`
or
`$bash color_test1.sh`

#### You can type in ternimal to show your ternimal supoort colors
`$tput colors`

![ternimal suppotr colors](screenshot/tput_colors.png)

Set tmux 256 colors
`set -g default-terminal "screen-256color"`


Show your tmux setting
`$tmux show -g`

Show tmux bind kyes
`<prefix> ?`
or
`:list-keys`


**My addition keybind**
---
```
C-S-Right :add 200 lines to right
C-S-Left : add 200 lines to left
<prefix> C : creat a new windw from current path to  next index
<prefix> C-s : synchronize all panes
M-k : confirm before kill current window
C-k : confirm before kill current session
C-o : rotate the current window
M-| : set layout main vertical
M-_ : set layout main horizontal
C-| : set layout even horizontal
C-_ : set layout even vertical
C-t : set layout tiled
C-b : clear screen & screen history
<prefix> C-t : via a choose window to move current pane to window
<prefix> C-j : prompt a cmd to join <window>.<pane> to this pane
<prefix> M-n : set repeat 0.6s , titles off , display time 0.75s
<prefix> M-s : set repeat 1s , titles on , display time 1.5s
<prefix> S : prompt a cmd to new session
<prefix> T : move window to next unused number
<prefix> @ : prompt a cmd to change window's index
M-1~9 : select current windows's pane
<prefix> o : select next pane (repeat)
<prefix> / : select last window
<prefix> M-s : prompt a cmd to swap current window's index to target index
```
M- which is the Meta key (i.e. Alt on most keyboards)
S- means Shift key

**In copy-mode**

>All copy-mode use VI-mode
plugins use plugin tmux-yank

in copy-mode-vi will binding `Space` key to send begin-selection<br/>
`bind-key    -T copy-mode-vi Space             send-keys -X begin-selection`

you can open a highlighted text in copy-mode via press `o` or `Ctrl-o` to open file by `xdg-open` or `$EDITOR` respectively .
power by tmux-open pulgin

Screenshot for tmux
![tmux2.5 screenshoot](screenshot/tmux2.5.png)

You can find more example tmux.conf from
`/usr/share/doc/tmux/examples`

Requirements
---
#### for workspace.sh
all you can get via `sudo apt-get install `
* `fortunes`
* `lolcat`
* `cowsay`
* `htop`
* `cmatrix`
#### for tmux plugin
* `xsel` (recommended) or `xclip` for tmux-yank
* `urlview` for tmux-urlview
* `iostat` or `sar` (Optional requirement) for tmux-cpu

---
##### tmux_note.txt is a file that remind some tmux setting
##### zshrc.zsh-template.orig is the oh-my-zsh template original file backup.
---

[you can change your Ctrl to CAPS via this link](http://www.atjiang.com/pragmatic-tmux-configure/)
```
绑定 CAPS LOCK 键到 CTRL 键

在 OS X 上：打开 Keyboard preference panel->System Preference，按下 Modifier 键，然后将 CAPS LOCK 的动作改为 Control。

在 Linux，需对键盘配置文件进行修改：

sudo vi /etc/default/keyboard

找到以 XKBOPTIONS 开头的行，添加 ctrl:nocaps 使 CAPS LOCK 成为另一个 CTRL 键，或者添加 ctrl:swapcaps 使 CAPS LOCK 键和 CTRL 两键的功能相互交换。 例如，修改后的内容可能为：

XKBOPTIONS="lv3:ralt_alt,compose:menu,ctrl:nocaps"

然后运行：

sudo dpkg-reconfigure keyboard-configuration
```
---
## [Emacs Wiki : MovingTheCtrlKey](https://www.emacswiki.org/emacs/MovingTheCtrlKey)
---
### Ubuuntu 17.10 can use gnome-tweak-tool to change the CTRL to CAPS LOCK key
![gnome-tweak-tool cahnge CTRL2CAPS](screenshot/gnome-tweak-tool_changeCTRL2CAPS.png)

My zsh plugins
---
```git pip python systemd tmux docker docker-compose encode64```

u need install cloudapp via terminal
`gem install cloudapp_api`
