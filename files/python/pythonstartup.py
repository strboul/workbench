"""
Python startup file
https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSTARTUP
"""

from pprint import pprint  # noqa: F401


def dirr(obj):
    """
    Simple wrapper to `dir()` not showing methods starting with '__'.
    """
    return [x for x in __builtins__.dir(obj) if not x.startswith("__")]
