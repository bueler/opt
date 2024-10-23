import numpy as np


def is_bfs(x, A, b):
    """Is Basic Feasible Solution

    Checks if x is a nondegenerate basic feasible solution."""
    if np.any(x < 0):
        return False  # x not feasible
    if np.linalg.cond(A[:, x > 0]) > 1.0e15:
        return False  # B not invertible
    if np.linalg.norm(A @ x - b) > 1.0e-6 * np.linalg.norm(b):
        print("Warning: x is not close to a solution of Ax = b")
    return True


def current_xz(c, hatb, Bset):
    """Current x and z value

    Create the current value of x and z (objective function) using the B_idx.

    Args:
        c (np.ndarray): Objective Function Coefficients
        hatb (np.ndarray): Values of b (need to remember)
        Bset (np.ndarray): Indices that are currently live

    Returns:
        x (np.ndarray): x vector of values
        z (float): objective function value"""
    x = np.zeros_like(c)
    x[Bset] = hatb
    z = c.T @ x
    return x, z


def sfsimplex(c, A, b, x, showiters=False, maxiters=100):
    """Standard Form Simplex Method

    Solve a standard form linear programming problem
    minimize    z = c.T @ x
    subject to  A @ x = b
                x >= 0

    Args:
        c (np.ndarray): Objective Function Coefficients
        A (np.ndarray): A matrix coefficients
        b (np.ndarray): b vector coefficients
        x (np.ndarray): Starting BFS to kick off the method
        showiters (bool): Default value is False
        maxiters (int): Number of iterations, default is 100

    Returns:
        x (np.ndarray): x value that provides the lowest objective
        z (float): objective function value
        k (float): number of iterations
    """
    # Get sizes and check inputs
    m, n = A.shape
    x = np.asarray(x).reshape(-1)  # Ensure x is a column vector
    b = np.asarray(b).reshape(-1)  # Ensure b is a column vector
    c = np.asarray(c).reshape(-1)  # Ensure c is a column vector

    # Validate inputs
    if len(b) != m:
        raise ValueError("A and b do not have compatible sizes")
    if np.any(b < 0):
        raise ValueError("b >= 0 required")
    if len(c) != n:
        raise ValueError("A and c do not have compatible sizes")
    if len(x) != n:
        raise ValueError("A and x do not have compatible sizes")
    if not is_bfs(x, A, b):
        raise ValueError("x is NOT a nondegenerate basic feasible solution")

    # Basic feasible solution defines sorted index sets
    Bset = np.where(x > 0)[0]
    Nset = np.setdiff1d(np.arange(n), Bset)

    # Main loop: move from one basic feasible solution to the next
    for k in range(maxiters):
        if showiters:
            print(f"Iteration {k+1}:")
            print(f"  Bset = {Bset}")
            print(f"  Nset = {Nset}")

        # Get current basis variables (hatb) and reduced costs (hatcN)
        cB = c[Bset]
        cN = c[Nset]
        B = A[:, Bset]
        N = A[:, Nset]
        hatb = np.linalg.solve(B, b)
        y = np.linalg.solve(B.T, cB)
        hatcN = cN - N.T @ y

        if showiters:
            print(f"  ^cN = {hatcN}")
            x_current, z = current_xz(c, hatb, Bset)
            print(f"  x = {x_current}")
            print(f"  z = {z}")

        # Test optimality
        if np.all(hatcN >= 0):
            print(f"Ending: optimum found on iteration {k+1}")
            break

        # Get entering index (t)
        t = np.argmin(hatcN)

        # Check for unbounded problem
        hatAt = np.linalg.solve(B, A[:, Nset[t]])
        if showiters:
            print(f"  ^At = {hatAt}")

        if np.all(hatAt <= 0):
            raise ValueError(f"Ending: detected unbounded problem on iteration {k+1}")

        # Use ratio test to get leaving index (s)
        ratios = hatb / np.where(hatAt > 0, hatAt, -1)  # might need to correct this line
        ratios = np.where(ratios >= 0, ratios, np.inf)  # put infinity if smaller than 0
        s = np.argmin(ratios)

        # Update index sets
        tmp = Bset[s]
        Bset[s] = Nset[t]
        Nset[t] = tmp
        Bset = np.sort(Bset)
        Nset = np.sort(Nset)

    if k >= maxiters:
        print(f"Warning: maximum number of iterations reached ({maxiters})")

    x, z = current_xz(c, hatb, Bset)
    return x, z, k + 1


def ezsimplex(c, A, b, showiters=False, maxiters=100):
    """Easy Form Simplex Method

    Solve the easy form linear programming problem
    minimize    z = c.T @ x
    subject to  A @ x <= b
                x >= 0

    No basic feasible solution is required to kick off the method.

    Args:
        c (np.ndarray): Objective Function Coefficients
        A (np.ndarray): A matrix coefficients
        b (np.ndarray): b vector coefficients
        showiters (bool): Default value is False
        maxiters (int): Number of iterations, default is 100

    Returns:
        x (np.ndarray): x value that provides the lowest objective
        z (float): objective function value
        k (float): number of iterations
    """
    # Ensure inputs are column vectors
    m, n = A.shape
    b = np.asarray(b).reshape(-1)  # Force b to be a column vector
    c = np.asarray(c).reshape(-1)  # Force c to be a column vector

    # Validate inputs
    if len(b) != m:
        raise ValueError("A and b do not have compatible sizes")
    if np.any(b < 0):
        raise ValueError("b >= 0 required")
    if len(c) != n:
        raise ValueError("A and c do not have compatible sizes")

    # Add slack variables and define a basic feasible solution
    print(f"Original variables x_1,..,x_{n}")
    print(f"Adding slack variables x_{n+1},..,x_{n+m}")

    A = np.hstack([A, np.eye(m)])  # Add slack variables (identity matrix)
    c = np.concatenate([c, np.zeros(m)])  # Update cost vector with zeros for slack variables
    x = np.concatenate([np.zeros(n), b])  # Basic feasible solution

    # Now the problem is in standard form; solve it using sfsimplex
    x, z, iters = sfsimplex(c, A, b, x, showiters, maxiters)

    # Trim x to original size (remove slack variables)
    x = x[:n]

    return x, z, iters
