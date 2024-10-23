import numpy as np
import simplex as sx


def bookexsf():
    # Test SFSIMPLEX on the example from Griva, Nash, Sofer (2009), pages 132-133.

    # Define the problem
    c = np.array([-1, -2, 0, 0, 0], dtype=float)
    A = np.array([[-2, 1, 1, 0, 0], [-1, 2, 0, 1, 0], [1, 0, 0, 0, 1]], dtype=float)
    b = np.array([2, 7, 3], dtype=float)
    x = np.array([0, 0, 2, 7, 3], dtype=float)  # Initial basic feasible solution

    # Call the sfsimplex function
    x_result, z, iters = sx.sfsimplex(c, A, b, x, showiters=True)

    # Assertions to check results
    assert np.allclose(x_result, [3, 5, 3, 0, 0], atol=1.0e-8), "x_result mismatch"
    assert iters == 4, f"Iteration count mismatch: expected 4, got {iters}"

    print("PASS")


def bookexez():
    # Test EZSIMPLEX on the example from Griva, Nash, Sofer (2009), pages 126-127.

    # Define the problem
    c = np.array([-1, -2], dtype=float)
    A = np.array([[-2, 1], [-1, 2], [1, 0]], dtype=float)
    b = np.array([2, 7, 3], dtype=float)

    # Call the ezsimplex function
    x_result, z, iters = sx.ezsimplex(c, A, b, showiters=True)

    # Assertions to check results
    assert np.allclose(x_result, [3, 5], atol=1.0e-8), "x_result mismatch"
    assert iters == 4, f"Iteration count mismatch: expected 4, got {iters}"

    print("PASS")


# Call the test function
bookexsf()
bookexez()
