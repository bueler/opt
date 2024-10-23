import numpy as np
import simplex as sx


def kleeminty_A(n):
    """Create the Klee-Minty A Matrix"""
    A = np.eye(n)
    for k in range(0, n):
        row = k + 1
        col = k
        A[row:, col] = 2 ** np.arange(2, n + 1 - k, 1)
    return A


def kleeminty(n: int = 4):
    """Klee-Minty Simplex Problem

    Solves the Klee-Minty cube problem using the simplex method in linear
    programming. The simplex method becomes as slow as brute force checking
    of all the extreme points in the optimization problem.

    Args:
        n (int): Number of dimensions, defaults to 4

    Returns:
        Pass or Fail Statement
    """

    # Set up problem
    c = -(2 ** np.arange(n - 1, -1, -1))  # c = [-2^(n-1), -2^(n-2), ..., -1]
    A = kleeminty_A(n)  # Initialize an identity matrix for A
    b = 5 ** np.arange(1, n + 1)  # b = [5^1, 5^2, ..., 5^n]

    # Show problem setup
    print(f"Klee-Minty cube in dimension {n}:")
    print("c' =", c)
    print("A =")
    print(A)
    print("b' =", b)

    # Call the simplex method
    x, z, iters = sx.ezsimplex(c, A, b, showiters=True, maxiters=2**n + 1)  # Show iterations; raise maxiter

    # Check for the number of iterations
    assert iters == 2**n, "The simplex method did not tour every vertex!!"
    print("PASS")


kleeminty(5)
