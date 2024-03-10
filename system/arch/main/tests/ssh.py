import os
import pwd
import unittest


def get_stat(*, path):
    stat = os.stat(os.path.expanduser(path))
    out = {}
    out["owner"] = pwd.getpwuid(stat.st_uid).pw_name
    out["group"] = pwd.getpwuid(stat.st_gid).pw_name
    out["chmod"] = oct(stat.st_mode)[-4:]
    return out


class TestSsh(unittest.TestCase):
    def test_authorized_keys(self):
        stat = get_stat(path="~/.ssh/authorized_keys")

        # file owner and group
        assert stat["owner"] == "root"
        assert stat["group"] == "root"
        # file chmod
        assert stat["chmod"] == "0644"


if __name__ == "__main__":
    unittest.main()
