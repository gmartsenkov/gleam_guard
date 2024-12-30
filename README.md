# guard

[![Package Version](https://img.shields.io/hexpm/v/guard)](https://hex.pm/packages/guard)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/guard/)

```sh
gleam add guard@1
```
```gleam
import guard

pub type User {
  User(id: Int, name: String, age: Int)
}

pub fn main() {
  let user = User(id: 1, name: "John", age: 20)

  let assert Ok(_) = guard.new()
  |> guard.field("age", guard.is_gt(user.age, 18))
  |> guard.field("name", guard.is_longer(user.name, 1))
  |> guard.run()

  let assert Error(validator) =
    guard.new()
    |> guard.field("age", guard.is_gt(user.age, 30))
    |> guard.field("name", guard.is_longer(user.name, 5))
    |> guard.run()

  let assert [first, second] = validator.errors
  io.debug(first) // ValidationError("age", IsGreater(value: 20, expected: 30))
  io.debug(second) // ValidationError("name", IsLonger(value: "John", actual: 4, expected: 5))
}
```

Further documentation can be found at <https://hexdocs.pm/guard>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
