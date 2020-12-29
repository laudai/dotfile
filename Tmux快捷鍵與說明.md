Laudai Tmux快捷鍵中文版說明手冊
===
> Author:Laudai

內建快捷鍵說明
---
快捷鍵|語法|說明
---|---|---
\<prefix\> + "	|split-wiwndow	|水平切割視窗(生成原始路徑視窗)
\<prefix\> + %	|split-wiwndow -h	|垂直切割視窗(生成原始路徑視窗)
\<prefix\> + _	|split-window -v	|水平切割視窗(生成原始路徑視窗)
\<prefix\> + \| | split-window -h |垂直切割視窗(生成原始路徑視窗)


新增額外快捷件說明
---
快捷鍵|語法|說明
---|---|---
\<prefix\> + - | split-window -v -c "#{pane_current_path}"	|水平切割視窗（在當前路徑）
\<prefix\> + \	| split-window -h -c "#{pane_current_path}" |垂直切割當視窗（在當前路徑)
\<prefix\> + C	|new-window -a -c "#{pane_current_path}"	|在當前路徑開啟新視窗

