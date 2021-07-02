# -*- encoding:utf8 -*-

"""
vim stub for mypy checker
"""

import typing # noqa: W0611

from typing import Union, List, Dict, Tuple, Callable, Any


class Range():
    start: int
    end: int

    def append(self, line: Union[str, List[str]], nr: int):
        """
        r.append(str)	Append a line to the range
        r.append(str, nr)  Idem, after line "nr"
        r.append(list)	Append a list of lines to the range
            Note that the option of supplying a list of strings to
            the append method differs from the equivalent method
            for Python's built-in list objects.
        r.append(list, nr)  Idem, after line "nr"
        """
        pass


class Buffer():
    vars: Dict[str, str]
    options: Dict[str, str]
    name: str
    number: int
    valid: bool

    def append(self, line: Union[str, List[str]], nr: int):
        """
        b.append(str)	Append a line to the buffer
        b.append(str, nr)  Idem, below line "nr"
        b.append(list)	Append a list of lines to the buffer
            Note that the option of supplying a list of strings to
            the append method differs from the equivalent method
            for Python's built-in list objects.
        b.append(list, nr)  Idem, below line "nr"
        """
        pass

    def mark(self, name: str) -> Tuple[int, int]:
        """
        Return a tuple (row,col) representing the position
        of the named mark (can also get the []"<> marks)
        """
        pass

    def range(self, s: int, e: int) -> Range:
        """
        Return a range object (see |python-range|) which
        represents the part of the given buffer between line
        numbers s and e |inclusive|.
        """
        pass


class Window():
    buffer: Buffer
    cursor: Tuple[int, int]
    height: int
    width: int
    vars: Dict[str, str]
    options: Dict[str, str]
    number: int
    row: int
    col: int
    tabpage: Any
    valid: bool


class Current():
    line: str
    buffer: Buffer
    window: Window
    tabpage: Any
    range: Range


class TabPage():
    number: int
    vars: Dict[str, str]
    valid: bool
    windows: List[Window]
    window: Window


Window.tabpage = TabPage()
Current.tabpage = TabPage()


def command(cmd: str):
    """
    :py vim.command("set tw=72")
    :py vim.command("%s/aaa/bbb/g")
    """
    pass


def eval(exp: str) -> Union[str, int]:
    """
    :py text_width = vim.eval("&tw")
    :py str = vim.eval("12+12")
    """
    pass


def bindeval(exp: str) -> Union[str, int]:
    """
    :py text_width = vim.bindeval("&tw")
    :py str = vim.bindeval("12+12")
    """
    pass


def strwidth(exp: str) -> int:
    """
    Like |strwidth()|: returns number of display cells str occupies, tab
    is counted as one cell.
    """
    pass


def foreach_rtp(c: Callable[[str], Any]) -> None:
    """
    Call the given callable for each path in 'runtimepath' until either
    callable returns something but None, the exception is raised or there
    are no longer paths. If stopped in case callable returned non-None,
    vim.foreach_rtp function returns the value returned by callable.
    """
    pass


def find_module() -> None:
    pass


def path_hook(path) -> None:
    pass


def _get_paths():
    pass


error: Exception

buffers: List[Buffer]

windows: List[Window]

tabpages: List[TabPage]

current: List[Current]

vars: Dict[str, str]

vvars: Dict[str, str]

options: Dict[str, str]

VIM_SPECIAL_PATH: str
