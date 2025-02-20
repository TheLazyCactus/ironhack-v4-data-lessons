import unittest
from main import addition, MathOperations

class TestExample(unittest.TestCase):
    def test_addition(self): # Start with test_
        self.assertEqual(addition(2, 2), 4)

class TestSetupExample(unittest.TestCase):
    def setUp(self):
        self.data = [1, 2, 3]
    
    def test_list_length(self):
        self.assertEqual(len(self.data), 3)
    
    def tearDown(self):
        self.data = None

class TestMathOperations(unittest.TestCase):
    def setUp(self):
        self.math = MathOperations()
    
    def test_add(self):
        self.assertEqual(self.math.add(2, 3), 5)

if __name__ == '__main__': # here main is OT main.py, but just naming convention, this
# What comes here is what the command line sees when it starts executing the script
    unittest.main()