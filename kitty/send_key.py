import re
from typing import Union
from abc import ABCMeta, abstractmethod

from kitty.key_encoding import KeyEvent, parse_shortcut

from kittens.tui.handler import result_handler


def main(args):
    pass


class BaseCommandKeyMap(metaclass=ABCMeta):
    # 定义特殊字符的映射表，将非法字符映射为合法的函数名片段
    SPECIAL_CHAR_MAP = {
        "+": "_",  # '+' 替换为 '_'
        "-": "dash",  # '-' 替换为 'dash'
        ",": "comma",  # ',' 替换为 'comma'
        "[": "left_bracket",  # '[' 替换为 'left_bracket'
        "]": "right_bracket",  # ']' 替换为 'right_bracket'
        "(": "left_paren",  # '(' 替换为 'left_paren'
        ")": "right_paren",  # ')' 替换为 'right_paren'
    }

    DIRECTORY_KEY_MAP = {
        "h": "left",
        "j": "down",
        "k": "up",
        "l": "right",
    }

    def __init__(self, boss, window, keymap: str):
        self.boss = boss
        self.window = window
        self.keymap = keymap
        self.tab_num = 7

        self.reset_keymap: list[str] = self.create_reset_keymap()
        self._apply_reset_keymap()

        self.create_tab_keymap()

        # 初始化时，提前转换快捷键为合法函数名
        self.function_name = self._convert_keymap_to_function_name()

    def _convert_keymap_to_function_name(self):
        """
        Convert the keymap to a valid function name based on the special char map.
        """
        function_name = self.keymap
        # 使用映射字典只进行一次字符替换操作
        for special_char, replacement in self.SPECIAL_CHAR_MAP.items():
            function_name = function_name.replace(special_char, replacement)
        return function_name

    @abstractmethod
    def create_tab_keymap(self):
        """
        Apply tab keymap, should be overridden by subclasses
        """
        pass

    @abstractmethod
    def create_reset_keymap(self) -> list[str]:
        """
        Factory method to create reset_keymap, should be overridden by subclasses
        """
        return []

    def _apply_reset_keymap(self):
        for key in self.reset_keymap:
            setattr(self, key, self.default_keymap)

    def encode_key_mapping(self, window, key_mapping):
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

    def send_keymap(self, keymap=None):
        """
        send keymap to child process
        """
        if keymap is None:
            keymap = self.keymap
        encoded = self.encode_key_mapping(self.window, keymap)
        self.window.write_to_child(encoded)

    def default_keymap(self):
        self.send_keymap()

    def call_keymap(self):
        """
        Call the corresponding function once.
        """
        call_func = getattr(self, self.function_name, None)
        if call_func is not None:
            # 只调用一次对应函数
            call_func()
        else:
            print(f"Function '{self.function_name}' not found.")


class ZshCommandKeyMap(BaseCommandKeyMap):
    def __init__(self, boos, window, keymap: str):
        super().__init__(boos, window, keymap)
        self._init_direction(r"^cmd\+ctrl\+([hjkl])$", self._split_window)
        self._init_direction(r"^ctrl\+shift\+([hjkl])$", self._resize_window)
        self._init_direction(r"^cmd\+([hjkl])$", self._move_window)

    def create_reset_keymap(self) -> list[str]:
        """
        Define reset_keymap for ZshCommandKeyMap
        """
        return []  # Customize as per requirement

    def create_tab_keymap(self):
        for index in range(1, self.tab_num):
            setattr(self, f"cmd_{index}", lambda index=index: self.boss.goto_tab(tab_num=index))

    def _init_direction(self, pattern, func):
        match = re.match(pattern, self.keymap)
        if match:
            func()

    def _resize_window(self):
        amount = 3  # resize amount

        def _func(boss, window, direction):
            neighbors = boss.active_tab.current_layout.neighbors_for_window(window, boss.active_tab.windows)

            left_neighbors = neighbors.get("left")
            right_neighbors = neighbors.get("right")
            top_neighbors = neighbors.get("top")
            bottom_neighbors = neighbors.get("bottom")

            # has a neighbor on both sides
            if direction == "left" and (left_neighbors and right_neighbors):
                boss.active_tab.resize_window("narrower", amount)
            # only has left neighbor
            elif direction == "left" and left_neighbors:
                boss.active_tab.resize_window("wider", amount)
            # only has right neighbor
            elif direction == "left" and right_neighbors:
                boss.active_tab.resize_window("narrower", amount)

            # has a neighbor on both sides
            elif direction == "right" and (left_neighbors and right_neighbors):
                boss.active_tab.resize_window("wider", amount)
            # only has left neighbor
            elif direction == "right" and left_neighbors:
                boss.active_tab.resize_window("narrower", amount)
            # only has right neighbor
            elif direction == "right" and right_neighbors:
                boss.active_tab.resize_window("wider", amount)

            # has a neighbor above and below
            elif direction == "up" and (top_neighbors and bottom_neighbors):
                boss.active_tab.resize_window("shorter", amount)
            # only has top neighbor
            elif direction == "up" and top_neighbors:
                boss.active_tab.resize_window("taller", amount)
            # only has bottom neighbor
            elif direction == "up" and bottom_neighbors:
                boss.active_tab.resize_window("shorter", amount)

            # has a neighbor above and below
            elif direction == "down" and (top_neighbors and bottom_neighbors):
                boss.active_tab.resize_window("taller", amount)
            # only has top neighbor
            elif direction == "down" and top_neighbors:
                boss.active_tab.resize_window("shorter", amount)
            # only has bottom neighbor
            elif direction == "down" and bottom_neighbors:
                boss.active_tab.resize_window("taller", amount)

        for directory_key, direction in self.DIRECTORY_KEY_MAP.items():
            setattr(
                self,
                f"ctrl_shift_{directory_key}",
                lambda direction=direction, window=self.window, boss=self.boss: _func(boss, window, direction),
            )

    def _move_window(self):
        def _func(direction, boss):
            boss.active_tab.neighboring_window(direction)

        for directory_key, direction in self.DIRECTORY_KEY_MAP.items():
            if direction == "up":
                direction = "top"
            if direction == "down":
                direction = "bottom"
            setattr(self, f"cmd_{directory_key}", lambda direction=direction, boss=self.boss: _func(direction, boss))

    def _split_window(self):
        def _func(direction, boss):
            if direction == "up" or direction == "down":
                boss.launch("--cwd=current", "--location=hsplit")
            else:
                boss.launch("--cwd=current", "--location=vsplit")

            if direction == "up" or direction == "left":
                # boss.active_tab.move_window(direction)
                boss.active_tab.neighboring_window(direction)

        for directory_key, direction in self.DIRECTORY_KEY_MAP.items():
            setattr(
                self, f"cmd_ctrl_{directory_key}", lambda direction=direction, boss=self.boss: _func(direction, boss)
            )

    def cmd_m(self):
        """
        minimize kitty
        """
        self.boss.minimize_macos_window()

    def cmd_w(self):
        """
        close currrent window
        """
        self.boss.close_window()

    def cmd_r(self):
        """
        Open file browser
        """
        # import tempfile
        # import os

        # getattr(self.boss, 'launch')('--copy-env', '--cwd=current', 'sh', '-c', 'yazi')

        self.window.write_to_child("yazi\n")
        # 创建临时文件以存储子进程修改的工作目录
        # temp_dir_file = tempfile.NamedTemporaryFile(delete=False, dir="/tmp")
        # temp_dir_file.close()  # 我们仅需要文件名，立即关闭文件
        #
        # # 启动 yazi 进程并将修改后的工作目录写入临时文件
        # self.boss.launch("--copy-env", "--cwd=current", "sh", "-c", f"yazi; pwd > {temp_dir_file.name}")
        #
        # # 读取临时文件中的新工作目录并在主进程中更新
        # try:
        #     with open(temp_dir_file.name, "r") as f:
        #         new_dir = f.read().strip()
        #         if new_dir:
        #             os.chdir(new_dir)  # 更新主进程工作目录
        #             print(f"Changed working directory to: {new_dir}")
        #         else:
        #             print("Failed to read new directory from yazi.")
        # except FileNotFoundError:
        #     print(f"Temporary file not found: {temp_dir_file.name}")
        # finally:
        #     # 删除临时文件
        #     os.unlink(temp_dir_file.name)

    def cmd_t(self):
        """
        new tab
        """
        self.boss.new_tab()

    def cmd_enter(self):
        """
        toggle layout
        """
        self.boss.active_tab.toggle_layout("stack")

    def cmd_shift_k(self):
        """
        rename
        """
        self.boss.set_tab_title()

    def cmd_f(self):
        """
        pane goto
        """
        tab = self.boss.active_tab
        tab.focus_visible_window()

    def cmd_left_bracket(self):
        """
        next tab
        """
        self.boss.next_tab()

    def cmd_right_bracket(self):
        """
        prev tab
        """
        self.boss.previous_tab()

    def cmd_alt_left_bracket(self):
        """
        swap with prev window
        """
        self.boss.swap_with_window()

    def cmd_alt_right_bracket(self):
        """
        swap with next window
        """
        self.boss.swap_with_window()


class NvimCommandKeyMap(ZshCommandKeyMap):
    def __init__(self, boos, window, keymap: str):
        super().__init__(boos, window, keymap)

    def create_reset_keymap(self) -> list[str]:
        """
        Define reset_keymap for NvimCommandKeyMap
        """
        return ["cmd_f", "cmd_r", "cmd_shift_f", "cmd_s", "cmd_w", "cmd_e"]


class TmuxCommandKeyMap(ZshCommandKeyMap):
    def __init__(self, boos, window, keymap: str):
        super().__init__(boos, window, keymap)

    def create_reset_keymap(self) -> list[str]:
        """
        Define reset_keymap for TmuxCommandKeyMap
        """
        return ["cmd_s", "cmd_w", "cmd_e", "cmd_f", "cmd_r", "cmd_shift_f"]

    def create_tab_keymap(self):
        for index in range(1, self.tab_num):
            setattr(self, f"cmd_{index}", lambda s=self, i=index: s.send_keymap(f"ctrl+a->{i}"))

    def send_keymap(self, keymap: Union[str, None] = None):
        if keymap is None:
            super().send_keymap()
        else:
            keymap_list = keymap.split("->")
            for keymap in keymap_list:
                super().send_keymap(keymap)

    def _split_window(self):
        for direction in self.DIRECTORY_KEY_MAP.keys():
            setattr(
                self,
                f"cmd_ctrl_{direction}",
                self.default_keymap,
            )

    def _move_window(self):
        for direction in self.DIRECTORY_KEY_MAP.keys():
            setattr(
                self,
                f"cmd_{direction}",
                self.default_keymap,
            )

    def _resize_window(self):
        for direction in self.DIRECTORY_KEY_MAP.keys():
            setattr(
                self,
                f"ctrl_shift_{direction}",
                self.default_keymap,
            )

    def cmd_t(self):
        self.send_keymap("ctrl+a->c")

    def cmd_f(self):
        self.send_keymap("ctrl+a->q")

    def cmd_shift_k(self):
        return self.send_keymap("ctrl+a->,")

    def cmd_enter(self):
        return self.send_keymap("ctrl+a->z")

    def cmd_left_bracket(self):
        return self.send_keymap("ctrl+a->n")

    def cmd_right_bracket(self):
        return self.send_keymap("ctrl+a->p")

    def cmd_alt_left_bracket(self):
        return self.send_keymap("ctrl+a->{")

    def cmd_alt_right_bracket(self):
        return self.send_keymap("ctrl+a->}")


class YaziCommandKeyMap(ZshCommandKeyMap):
    def __init__(self, boos, window, keymap: str):
        super().__init__(boos, window, keymap)

    def create_tab_keymap(self):
        return super().create_tab_keymap()

    def create_reset_keymap(self) -> list[str]:
        """
        Define reset_keymap for TmuxCommandKeyMap
        """
        return ["cmd_f", "cmd_shift_f"]


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    window = boss.active_window

    if window is None:
        return

    cmd = window.child.foreground_cmdline[0]
    keymap = args[1]

    # 类映射字典，只实例化对应的类
    class_map = {
        "/usr/bin/ssh": ZshCommandKeyMap,
        "-zsh": ZshCommandKeyMap,
        "nvim": NvimCommandKeyMap,
        "tmux": TmuxCommandKeyMap,
        "yazi": YaziCommandKeyMap,
    }

    # 判断cmd类型并实例化对应类
    command_class = class_map.get(cmd, None)

    if command_class is None:
        print(f"Unsupported command: {cmd}")
        return

    # 只实例化与当前cmd对应的类
    command_instance = command_class(boss, window, keymap)

    # 调用对应的快捷键映射函数
    command_instance.call_keymap()
