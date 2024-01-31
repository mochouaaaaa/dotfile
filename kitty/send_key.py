from kittens.tui.handler import result_handler

from kitty.key_encoding import KeyEvent, parse_shortcut
from kitty.keys import keyboard_mode_name


def main(args):
    pass


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


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.active_window
    if window is None:
        return

    cmd = window.child.foreground_cmdline[0]

    key_mapping = args[-1]

    if cmd == "nvim" or cmd == "tmux":
        for keymap in key_mapping.split(">"):
            encoded = encode_key_mapping(window, keymap)
            window.write_to_child(encoded)

    # if args[1] == "C-i":
    #     # Move cursor to the end of line, specific to zsh
    #     if cmd[-3:] == "zsh":
    #         window.write_to_child("\x1b[105;5u")
    #
    #     # A workaround for tmux to fix its bug of Ctrl+i recognition, sending a Ctrl-; instead
    #     elif cmd[-4:] == "tmux":
    #         window.write_to_child("\x1b[59;5u")
    #         return
    #
    #     # Other programs that support CSI u
    #     elif keyboard_mode_name(window.screen) == "kitty":
    #         window.write_to_child("\x1b[105;5u")
    #
    #     # Otherwise send a ^I
    #     else:
    #         window.write_to_child("\x09")
    #
    # elif args[1] == "S-s":
    #     if cmd[-4:] == "nvim":
    #         window.write_to_child("\x1b[115;8u")
