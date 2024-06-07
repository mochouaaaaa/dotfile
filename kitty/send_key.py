from kittens.tui.handler import result_handler

from kitty.key_encoding import KeyEvent, parse_shortcut


def main(args):
    pass


# keymap reflex
KEY_MAPPINGS = {
    "cmd+r": {"-zsh": "text:joshuto"},
    "cmd+t": {"-zsh": "def:getattr(boss, 'new_tab')()", "tmux": "ctrl+a->c"},
    # wndow switching
    "cmd+1": {"-zsh": "def:getattr(boss, 'goto_tab')(1)", "tmux": "ctrl+a->1"},
    "cmd+2": {"-zsh": "def:getattr(boss, 'goto_tab')(2)", "tmux": "ctrl+a->2"},
    "cmd+3": {"-zsh": "def:getattr(boss, 'goto_tab')(3)", "tmux": "ctrl+a->3"},
    "cmd+4": {"-zsh": "def:getattr(boss, 'goto_tab')(4)", "tmux": "ctrl+a->4"},
    "cmd+5": {"-zsh": "def:getattr(boss, 'goto_tab')(5)", "tmux": "ctrl+a->5"},
    "cmd+6": {"-zsh": "def:getattr(boss, 'goto_tab')(6)", "tmux": "ctrl+a->6"},
    # window next or prev
    "cmd+[": {"-zsh": "def:getattr(boss, 'next_tab')()", "tmux": "ctrl+a->n"},
    "cmd+]": {"-zsh": "def:getattr(boss, 'previous_tab')()", "tmux": "ctrl+a->p"},
    # window closing
    "cmd+w": {"-zsh": "def:getattr(boss, 'close_tab')()"},
    # window title rename
    "cmd+shift+k": {
        "-zsh": "def:getattr(boss, 'set_tab_title')()",
        "tmux": "ctrl+a->,",
    },
    # window switch
    "cmd+alt+[": {
        "-zsh": "def:getattr(boss.active_tab, 'move_window_forward')()",
        "tmux": "ctrl+a->{",
    },
    "cmd+alt+]": {
        "-zsh": "def:getattr(boss.active_tab, 'move_window_backward')()",
        "tmux": "ctrl+a->}",
    },
    # window max
    "cmd+enter": {
        "-zsh": "def:getattr(boss.active_tab, 'toggle_layout')('stack')",
        "tmux": "ctrl+a->z",
    },
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
    if window is None:
        return

    cmd = window.child.foreground_cmdline[0]
    keymap = args[1]

    event = KEY_MAPPINGS.get(keymap, {})

    if not event:
        send_keymap(window, keymap)
        return

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
        send_keymap(window, keymap)
