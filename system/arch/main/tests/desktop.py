import os
import unittest


class TestDesktop(unittest.TestCase):
    def test_window_system(self):
        assert os.environ["XDG_SESSION_TYPE"] == "wayland"


if __name__ == "__main__":
    unittest.main()
