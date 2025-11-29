# Python Best Practices

This document serves as a comprehensive reference for Python best practices, idioms, and patterns to guide code reviews and development.

## Style and Formatting

### PEP 8 - Style Guide for Python Code

- **Indentation**: 4 spaces (never tabs)
- **Line length**: Maximum 79 characters for code, 72 for docstrings/comments
- **Blank lines**:
  - 2 blank lines around top-level functions and classes
  - 1 blank line around method definitions
- **Imports**:
  - Always at the top of the file
  - Grouped: standard library, third-party, local
  - Absolute imports preferred over relative
- **Naming conventions**:
  - `snake_case` for functions, variables, modules
  - `PascalCase` for classes
  - `UPPER_CASE` for constants
  - `_leading_underscore` for internal/private
  - `__double_leading` for name mangling

### Modern Python Formatting

```python
# Good: F-strings for formatting (Python 3.6+)
name = "Alice"
age = 30
message = f"Hello, {name}! You are {age} years old."

# Avoid: Old-style formatting
message = "Hello, %s! You are %d years old." % (name, age)
message = "Hello, {}! You are {} years old.".format(name, age)
```

## Type Hints

### Basic Type Hints

```python
from typing import List, Dict, Optional, Union, Tuple, Set

def greet(name: str) -> str:
    return f"Hello, {name}!"

def process_items(items: List[str], limit: Optional[int] = None) -> Dict[str, int]:
    result: Dict[str, int] = {}
    for item in items[:limit]:
        result[item] = len(item)
    return result
```

### Advanced Type Hints (Python 3.9+)

```python
# Python 3.9+ - use built-in types directly
def process_data(items: list[str], mapping: dict[str, int]) -> tuple[str, ...]:
    return tuple(items)

# Python 3.10+ - union type with |
def handle_id(user_id: int | str) -> str:
    return str(user_id)
```

### Type Aliases

```python
from typing import TypeAlias

UserId: TypeAlias = int | str
UserData: TypeAlias = dict[str, str | int]

def get_user(user_id: UserId) -> UserData:
    ...
```

## Modern Python Features

### Dataclasses (Python 3.7+)

```python
from dataclasses import dataclass, field
from typing import List

@dataclass
class User:
    name: str
    email: str
    age: int
    tags: List[str] = field(default_factory=list)

    def __post_init__(self):
        if self.age < 0:
            raise ValueError("Age cannot be negative")
```

### Pathlib for File Operations

```python
from pathlib import Path

# Good: Using pathlib
config_path = Path.home() / ".config" / "myapp" / "config.json"
if config_path.exists():
    content = config_path.read_text()

# Avoid: String-based path operations
import os
config_path = os.path.join(os.path.expanduser("~"), ".config", "myapp", "config.json")
if os.path.exists(config_path):
    with open(config_path) as f:
        content = f.read()
```

### Context Managers

```python
from contextlib import contextmanager

@contextmanager
def temporary_setting(config, key, value):
    """Temporarily change a configuration value."""
    old_value = config.get(key)
    config[key] = value
    try:
        yield
    finally:
        config[key] = old_value

# Usage
with temporary_setting(config, 'debug', True):
    # debug mode is on
    process_data()
# debug mode restored
```

### Structural Pattern Matching (Python 3.10+)

```python
def process_command(command: dict) -> str:
    match command:
        case {"action": "create", "type": "user", "name": name}:
            return f"Creating user: {name}"
        case {"action": "delete", "type": "user", "id": user_id}:
            return f"Deleting user: {user_id}"
        case {"action": action, "type": type_}:
            return f"Unknown action: {action} on {type_}"
        case _:
            return "Invalid command"
```

## Pythonic Patterns

### List Comprehensions

```python
# Good: List comprehension
squares = [x**2 for x in range(10) if x % 2 == 0]

# Avoid: Traditional loop for simple cases
squares = []
for x in range(10):
    if x % 2 == 0:
        squares.append(x**2)

# Dict comprehension
word_lengths = {word: len(word) for word in words}

# Set comprehension
unique_lengths = {len(word) for word in words}
```

### Generator Expressions

```python
# Good: Memory efficient for large datasets
total = sum(x**2 for x in range(1000000))

# Avoid: Creates entire list in memory
total = sum([x**2 for x in range(1000000)])
```

### Unpacking

```python
# Multiple assignment
first, *middle, last = [1, 2, 3, 4, 5]

# Dictionary unpacking
defaults = {"host": "localhost", "port": 8000}
config = {**defaults, "port": 9000}  # Override port

# Function arguments
def process(x, y, z):
    return x + y + z

values = [1, 2, 3]
result = process(*values)
```

### Enumerate and Zip

```python
# Enumerate for index and value
for i, value in enumerate(items, start=1):
    print(f"{i}. {value}")

# Zip for parallel iteration
names = ["Alice", "Bob", "Charlie"]
ages = [30, 25, 35]
for name, age in zip(names, ages):
    print(f"{name} is {age} years old")
```

## Error Handling

### Specific Exceptions

```python
# Good: Catch specific exceptions
try:
    result = int(user_input)
except ValueError:
    print("Invalid number")
except TypeError:
    print("Wrong type")

# Avoid: Bare except
try:
    result = int(user_input)
except:  # Too broad!
    print("Something went wrong")
```

### Exception Chaining

```python
# Good: Preserve exception context
try:
    process_data()
except DataError as e:
    raise ProcessingError("Failed to process") from e

# Good: Explicit suppression when appropriate
try:
    cleanup()
except CleanupError as e:
    raise RuntimeError("Cleanup failed") from None
```

### Custom Exceptions

```python
class ValidationError(Exception):
    """Raised when data validation fails."""
    pass

class DatabaseError(Exception):
    """Raised when database operations fail."""
    def __init__(self, message: str, query: str):
        super().__init__(message)
        self.query = query
```

## Functions and Methods

### Default Arguments

```python
# Good: Immutable defaults
def process(items: list[str], timeout: int = 30) -> None:
    ...

# Avoid: Mutable defaults
def process(items: list[str], cache: dict = {}) -> None:  # Bug!
    ...

# Good: Use None for mutable defaults
def process(items: list[str], cache: dict | None = None) -> None:
    if cache is None:
        cache = {}
    ...
```

### *args and **kwargs

```python
def flexible_function(*args, **kwargs):
    """Accept any arguments."""
    for arg in args:
        print(arg)
    for key, value in kwargs.items():
        print(f"{key} = {value}")

# Forwarding arguments
def wrapper(*args, **kwargs):
    return original_function(*args, **kwargs)
```

### Keyword-only Arguments

```python
# Force keyword arguments for clarity
def create_user(name: str, *, email: str, age: int) -> User:
    """email and age must be passed as keywords."""
    return User(name, email, age)

# Must call as:
user = create_user("Alice", email="alice@example.com", age=30)
```

## Classes and OOP

### Properties

```python
class Temperature:
    def __init__(self, celsius: float):
        self._celsius = celsius

    @property
    def celsius(self) -> float:
        return self._celsius

    @celsius.setter
    def celsius(self, value: float) -> None:
        if value < -273.15:
            raise ValueError("Temperature below absolute zero")
        self._celsius = value

    @property
    def fahrenheit(self) -> float:
        return self._celsius * 9/5 + 32
```

### Class Methods and Static Methods

```python
class DateUtils:
    @staticmethod
    def is_weekend(date) -> bool:
        """No access to class or instance."""
        return date.weekday() >= 5

    @classmethod
    def from_timestamp(cls, timestamp: float):
        """Factory method - has access to class."""
        return cls(datetime.fromtimestamp(timestamp))
```

### Abstract Base Classes

```python
from abc import ABC, abstractmethod

class Repository(ABC):
    @abstractmethod
    def save(self, item: dict) -> None:
        """Save an item to storage."""
        pass

    @abstractmethod
    def find(self, id: int) -> dict | None:
        """Find an item by ID."""
        pass

class DatabaseRepository(Repository):
    def save(self, item: dict) -> None:
        # Implementation
        pass

    def find(self, id: int) -> dict | None:
        # Implementation
        pass
```

## Working with Collections

### itertools

```python
from itertools import chain, islice, groupby, combinations

# Chain multiple iterables
all_items = chain(list1, list2, list3)

# Take first n items from an iterable
first_ten = list(islice(infinite_generator, 10))

# Group consecutive items
data = [1, 1, 2, 2, 2, 3, 1, 1]
for key, group in groupby(data):
    print(f"{key}: {list(group)}")

# All combinations
pairs = list(combinations([1, 2, 3, 4], 2))
```

### collections

```python
from collections import defaultdict, Counter, namedtuple, deque

# defaultdict - avoid KeyError
word_counts = defaultdict(int)
for word in words:
    word_counts[word] += 1

# Counter - count hashable objects
letter_counts = Counter("hello world")
most_common = letter_counts.most_common(3)

# namedtuple - lightweight class
Point = namedtuple('Point', ['x', 'y'])
p = Point(11, 22)

# deque - efficient queue operations
queue = deque([1, 2, 3])
queue.append(4)
queue.appendleft(0)
```

## Testing

### pytest Basics

```python
import pytest

def test_addition():
    assert 1 + 1 == 2

def test_division_by_zero():
    with pytest.raises(ZeroDivisionError):
        1 / 0

@pytest.fixture
def sample_data():
    """Setup fixture."""
    return {"key": "value"}

def test_with_fixture(sample_data):
    assert sample_data["key"] == "value"

@pytest.mark.parametrize("input,expected", [
    (1, 2),
    (2, 3),
    (3, 4),
])
def test_increment(input, expected):
    assert input + 1 == expected
```

### Mocking

```python
from unittest.mock import Mock, patch

def test_api_call():
    with patch('requests.get') as mock_get:
        mock_get.return_value.json.return_value = {"data": "test"}
        result = fetch_data()
        assert result["data"] == "test"
        mock_get.assert_called_once()
```

## Performance

### Profiling

```python
import cProfile
import pstats

# Profile code
cProfile.run('expensive_function()', 'output.prof')

# Analyze results
stats = pstats.Stats('output.prof')
stats.sort_stats('cumulative')
stats.print_stats(10)
```

### List vs Generator

```python
# Generator - memory efficient
def fibonacci_gen(n):
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

# Use when you need one item at a time
for num in fibonacci_gen(1000000):
    if num > 100:
        break
```

## Security

### Input Validation

```python
def process_user_id(user_id: str) -> int:
    # Validate input
    if not user_id.isdigit():
        raise ValueError("User ID must be numeric")

    id_int = int(user_id)
    if not 0 < id_int < 1000000:
        raise ValueError("User ID out of valid range")

    return id_int
```

### SQL Injection Prevention

```python
# Good: Use parameterized queries
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))

# Avoid: String interpolation
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")  # SQL injection!
```

### Secrets Management

```python
import os
from pathlib import Path

# Good: Environment variables or secret files
API_KEY = os.environ.get("API_KEY")
if not API_KEY:
    raise ValueError("API_KEY environment variable not set")

# Good: Load from secure file
secrets_path = Path.home() / ".secrets" / "api_keys.json"

# Avoid: Hardcoded secrets
API_KEY = "sk-1234567890"  # Never do this!
```

## Documentation

### Docstrings (PEP 257)

```python
def calculate_average(numbers: list[float]) -> float:
    """
    Calculate the arithmetic mean of a list of numbers.

    Args:
        numbers: A list of numeric values.

    Returns:
        The arithmetic mean of the input numbers.

    Raises:
        ValueError: If the input list is empty.

    Examples:
        >>> calculate_average([1, 2, 3, 4])
        2.5
        >>> calculate_average([10])
        10.0
    """
    if not numbers:
        raise ValueError("Cannot calculate average of empty list")
    return sum(numbers) / len(numbers)
```

### Type Hints as Documentation

```python
from typing import Protocol

class Drawable(Protocol):
    """Protocol for objects that can be drawn."""
    def draw(self) -> None:
        """Draw the object."""
        ...

def render(items: list[Drawable]) -> None:
    """Render a list of drawable objects."""
    for item in items:
        item.draw()
```

## Common Anti-patterns to Avoid

### Avoid Mutable Default Arguments

```python
# Bad
def append_to_list(item, lst=[]):
    lst.append(item)
    return lst

# Good
def append_to_list(item, lst=None):
    if lst is None:
        lst = []
    lst.append(item)
    return lst
```

### Avoid Bare Except

```python
# Bad
try:
    risky_operation()
except:
    pass

# Good
try:
    risky_operation()
except SpecificException as e:
    logger.error(f"Operation failed: {e}")
    raise
```

### Avoid Using eval()

```python
# Bad - security risk!
user_input = "os.system('rm -rf /')"
result = eval(user_input)

# Good - use ast.literal_eval for data
import ast
safe_data = ast.literal_eval('{"key": "value"}')

# Or parse properly
import json
data = json.loads(user_input)
```

## Resources

- PEP 8: https://pep8.org/
- PEP 257: Docstring Conventions
- Python Type Hints: PEP 484, 526, 544, 585, 604
- The Zen of Python: `import this`
