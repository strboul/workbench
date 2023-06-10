import json
import subprocess
import unittest


def get_luks_dump(*, disk):
    """
    Get LUKS dump as JSON output
    """
    p = subprocess.Popen(
        ["sudo", "cryptsetup", "luksDump", disk, "--dump-json-metadata"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    stdout, _ = p.communicate()
    return stdout


def parse_luks_dump(stdout):
    return json.loads(stdout.decode("utf-8"))


class TestLuks(unittest.TestCase):
    def test_luks(self):
        stdout = get_luks_dump(disk="/dev/nvme0n1p2")
        parsed = parse_luks_dump(stdout)

        # keyslot type is luks2
        assert parsed["keyslots"]["0"]["type"] == "luks2"
        # pbkdf algorithm is argon2id
        assert parsed["keyslots"]["0"]["kdf"]["type"] == "argon2id"


if __name__ == "__main__":
    unittest.main()
