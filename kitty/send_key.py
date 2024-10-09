from kittens.tui.handler import result_handler
from kitty.boss import Boss
from kitty.key_encoding import KeyEvent, parse_shortcut


def main(args):
    pass


def select_pane_id(boss: Boss, target_window_id):
    tab = boss.active_tab
    # boss.switch_focus_to(1)
    # print(boss.active_tab.swap_with_window())

    # def callback(tab, window):
    #     if window and window.id != target_window_id:
    #         # tab.swap_with_window(window.id)
    #         boss.switch_focus_to(window.id)

    # boss.visual_window_select_action(tab, callback, "Choose window to swap with")
    tab.focus_visible_window()


# keymap reflex
KEY_MAPPINGS = {
    # "cmd+r": {"-zsh": "text:joshuto"},
    "cmd+r": {"-zsh": "text:yazi"},
    # "cmd+r": {"-zsh": "def:getattr(boss, 'launch')('--copy-env', '--cwd=current', 'sh', '-c', 'yazi')"},
    "cmd+t": {
        "-zsh": "def:getattr(boss, 'new_tab')()",
        "tmux": "ctrl+a->c",
        "nvim": "-zsh",
    },
    # wndow switching
    "cmd+1": {
        "-zsh": "def:getattr(boss, 'goto_tab')(1)",
        "tmux": "ctrl+a->1",
        "nvim": "-zsh",
    },
    "cmd+2": {
        "-zsh": "def:getattr(boss, 'goto_tab')(2)",
        "tmux": "ctrl+a->2",
        "nvim": "-zsh",
    },
    "cmd+3": {
        "-zsh": "def:getattr(boss, 'goto_tab')(3)",
        "tmux": "ctrl+a->3",
        "nvim": "-zsh",
    },
    "cmd+4": {
        "-zsh": "def:getattr(boss, 'goto_tab')(4)",
        "tmux": "ctrl+a->4",
        "nvim": "-zsh",
    },
    "cmd+5": {
        "-zsh": "def:getattr(boss, 'goto_tab')(5)",
        "tmux": "ctrl+a->5",
        "nvim": "-zsh",
    },
    "cmd+6": {
        "-zsh": "def:getattr(boss, 'goto_tab')(6)",
        "tmux": "ctrl+a->6",
        "nvim": "-zsh",
    },
    # window next or prev
    "cmd+[": {
        "-zsh": "def:getattr(boss, 'next_tab')()",
        "tmux": "ctrl+a->n",
        "nvim": "-zsh",
    },
    "cmd+]": {
        "-zsh": "def:getattr(boss, 'previous_tab')()",
        "tmux": "ctrl+a->p",
        "nvim": "-zsh",
    },
    # window closing
    "cmd+w": {"-zsh": "def:getattr(boss, 'close_window')()"},
    # window title rename
    "cmd+shift+k": {
        "-zsh": "def:getattr(boss, 'set_tab_title')()",
        "tmux": "ctrl+a->,",
        "nvim": "-zsh",
    },
    # window switch
    "cmd+alt+[": {
        # "-zsh": "def:getattr(boss.active_tab, 'move_window_forward')()",
        "-zsh": "def:getattr(tab, 'swap_with_window')()",
        "tmux": "ctrl+a->{",
        "nvim": "-zsh",
    },
    "cmd+alt+]": {
        # "-zsh": "def:getattr(boss.active_tab, 'move_window_backward')()",
        "-zsh": "def:getattr(tab, 'swap_with_window')()",
        "tmux": "ctrl+a->}",
        "nvim": "-zsh",
    },
    # window max
    "cmd+enter": {
        "-zsh": "def:getattr(boss.active_tab, 'toggle_layout')('stack')",
        "tmux": "ctrl+a->z",
        "nvim": "-zsh",
    },
    # pane search
    "cmd+f": {
        "-zsh": "def:select_pane_id(boss, target_window_id)",
    },
    "ctrl+f": {"tmux": "ctrl+a->ctrl+f"},
}


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def send_keymap(window, keymap):
    encoded = encode_key_mapping(window, keymap)
    window.write_to_child(encoded)


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.active_window
    tab = boss.active_tab

    if window is None:
        return

    cmd = window.child.foreground_cmdline[0]
    keymap = args[1]

    event = KEY_MAPPINGS.get(keymap, {})

    operate = event.get(cmd, "")

    if operate.startswith("def:"):
        eval(operate[4:])
    elif operate.startswith("text:"):
        window.write_to_child(operate[5:] + "\n")
    elif "->" in operate:
        keymap_list = operate.split("->")
        for keymap in keymap_list:
            send_keymap(window, keymap)
    else:
        if cmd == "nvim":
            if event.get("nvim", None) == "-zsh":
                eval(event["-zsh"][4:])
            else:
                send_keymap(window, keymap)
        elif cmd == "tmux":
            send_keymap(window, keymap)
