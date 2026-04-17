import unittest
from unittest.mock import patch, mock_open
import json
import numpy as np
import sys
from io import StringIO
from scripts.pilot_sim import load_system, analyze_eigenvalues

class TestLoadSystem(unittest.TestCase):
    def test_load_system_success(self):
        mock_data = {
            "modulus": 5,
            "a": [1, 4, 2, 3, 2],
            "b": [0, 1, 2, 3, 4]
        }
        json_str = json.dumps(mock_data)

        with patch("builtins.open", mock_open(read_data=json_str)):
            d, a, b = load_system("dummy_path.json")

        self.assertEqual(d, 5)
        np.testing.assert_array_equal(a, np.array([1, 4, 2, 3, 2], dtype=np.int64))
        np.testing.assert_array_equal(b, np.array([0, 1, 2, 3, 4], dtype=np.int64))

    def test_load_system_file_not_found(self):
        with patch("builtins.open", side_effect=FileNotFoundError):
            with patch("sys.stdout", new=StringIO()) as fake_out:
                with self.assertRaises(SystemExit) as cm:
                    load_system("non_existent.json")

                self.assertEqual(cm.exception.code, 1)
                self.assertIn("ERROR: non_existent.json not found. Ensure the Lean script has exported it.", fake_out.getvalue())

    def test_load_system_missing_keys(self):
        # Missing "modulus" key
        mock_data = {
            "a": [1, 4, 2, 3, 2],
            "b": [0, 1, 2, 3, 4]
        }
        json_str = json.dumps(mock_data)

        with patch("builtins.open", mock_open(read_data=json_str)):
            with self.assertRaises(KeyError):
                load_system("incomplete.json")

class TestAnalyzeEigenvalues(unittest.TestCase):
    def test_identity_matrix(self):
        P = np.eye(3)
        eigenvalues = analyze_eigenvalues(P)
        np.testing.assert_array_almost_equal(eigenvalues, np.array([1.0, 1.0, 1.0]))

    def test_diagonal_matrix_sorted(self):
        P = np.diag([0.5, 1.0, -0.2])
        eigenvalues = analyze_eigenvalues(P)
        # Sorted by absolute value descending: 1.0, 0.5, -0.2
        np.testing.assert_array_almost_equal(eigenvalues, np.array([1.0, 0.5, -0.2]))

    def test_2x2_known_matrix(self):
        P = np.array([[0.8, 0.2], [0.1, 0.9]])
        eigenvalues = analyze_eigenvalues(P)
        np.testing.assert_array_almost_equal(eigenvalues, np.array([1.0, 0.7]))

    def test_1x1_matrix(self):
        P = np.array([[0.5]])
        eigenvalues = analyze_eigenvalues(P)
        np.testing.assert_array_almost_equal(eigenvalues, np.array([0.5]))

if __name__ == "__main__":
    unittest.main()
