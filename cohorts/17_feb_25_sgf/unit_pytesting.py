import pytest
from main import addition

def test_addition():
    assert 2 + 2 == 4, "Addition in Python doesn't work"

@pytest.mark.parametrize(
    "x, y, output",
    [
        (2, 2, 4), # will pass
        (2, 3, 6), # Breaking this intentionally
        (3, 3, 6), # will pass
    ]
)
def test_more_additions(x, y, output):
    assert addition(x, y) == output