import pytest
from mypkg import __version__

def test_version_number_is_in_alignment():
    assert __version__ == '0.0.1'
